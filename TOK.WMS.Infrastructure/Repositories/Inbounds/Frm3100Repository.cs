using Dapper;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Globalization;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inbounds;

public class Frm3100Repository(DbConnectionFactory db) : IFrm3100Repository
{
    public async Task<IEnumerable<Frm3100Dto>?> SearchAsync(Frm3100Dto model)
    {
        using var conn = db.Create();

        var sql = @"SELECT
                        MAST_CODE   AS MastCode,
                        MAST_BCODE  AS MastBcode,
                        MAST_NAME   AS MastName,
                        MAST_UNIT   AS MastUnit,
                        MAST_WEIGHT AS MastWeight,
                        MAST_GUBN1  AS MastGubn1,
                        GUBN1_NAME  AS Gubn1Name,
                        MAST_GUBN2  AS MastGubn2,
                        GUBN2_NAME  AS Gubn2Name,
                        MAST_GUBN3  AS MastGubn3,
                        GUBN3_NAME  AS Gubn3Name,
                        MAST_DATE   AS MastDate
                    FROM MIMAST
                    LEFT OUTER JOIN MIGUBN1 WITH (NOLOCK)
                        ON GUBN1_CODE = MAST_GUBN1
                    LEFT OUTER JOIN MIGUBN2 WITH (NOLOCK)
                        ON GUBN2_CODE = MAST_GUBN2
                    LEFT OUTER JOIN MIGUBN3 WITH (NOLOCK)
                        ON GUBN3_CODE = MAST_GUBN3
                    WHERE 1 = 1";

        if (!string.IsNullOrWhiteSpace(model.MastCode))
        {
            sql = sql + @"AND MAST_CODE = @_mastCode";
        }

        if (!string.IsNullOrWhiteSpace(model.MastName))
        {
            sql = sql + @"AND MAST_NAME LIKE @_mastName";
        }

        sql = sql + "ORDER BY MAST_CODE";

        return await conn.QueryAsync<Frm3100Dto>(sql, new
        {
            _mastCode = model.MastCode ?? string.Empty,
            _mastName = $"%{model.MastName ?? string.Empty}%"
        });
    }

    public async Task AddAsync(Frm3100Dto model, IReadOnlyCollection<Frm3100Dto.resDto> Items)
    {
        if (string.IsNullOrWhiteSpace(model.PltnoEdit))
        {
            throw new InvalidOperationException("PLT-NO가 없습니다.");
        }

        if (string.IsNullOrWhiteSpace(model.ItnbrEdit))
        {
            throw new InvalidOperationException("품목코드가 없습니다.");
        }

        if (string.IsNullOrWhiteSpace(model.WeightEdit))
        {
            throw new InvalidOperationException("중량을 확인하십시오.");
        }

        using var conn = db.Create();

        var sql = @"
                    SELECT 1
                    FROM MIMAST
                    WHERE MAST_CODE = @_mastCode
                    ";

        var result = conn.QueryFirstOrDefault<int?>(
            sql,
            new
            {
                _mastCode = model.ItnbrEdit ?? string.Empty
            });

        if (result is null)
        {
            throw new InvalidOperationException("존재하지 않는 품목코드입니다.");
        }

        string weight = model.WeightEdit.Replace(",", string.Empty, StringComparison.Ordinal);
        if (!decimal.TryParse(weight, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal weightValue))
        {
            throw new InvalidOperationException("중량은 숫자로 입력하십시오.");
        }

        if (weightValue <= 0)
        {
            throw new InvalidOperationException("입고 작업 중량이 없습니다.");
        }

        if (weightValue > 99999.99m)
        {
            throw new InvalidOperationException("입력 가능한 중량 범위를 초과했습니다. 최대 허용값은 99,999.99입니다.");
        }

        bool hasDuplicate = Items.Any(item =>
            string.Equals(item.SubkPltno, model.PltnoEdit.Trim(), StringComparison.OrdinalIgnoreCase) &&
            string.Equals(item.SubkCode, model.ItnbrEdit.Trim(), StringComparison.OrdinalIgnoreCase) &&
            string.Equals(item.SubkLotno, model.LotnoEdit.Trim(), StringComparison.OrdinalIgnoreCase));

        if (hasDuplicate)
        {
            throw new InvalidOperationException("이미 동일한 입고 예정 데이터가 있습니다.");
        }
    }

    public Task SaveAsync(Frm3100Dto model, IReadOnlyCollection<Frm3100Dto.resDto> Items, IReadOnlyCollection<Frm3100Dto.resDto> delItems)
    {
        throw new NotImplementedException();
    }

    public Task CancleAsync(IReadOnlyCollection<Frm3100Dto.resDto> Items)
    {
        throw new NotImplementedException();
    }

    public async Task<bool> TrakingAsync(string sPltno)
    {
        try
        {
            if (!Trak_check(sPltno ?? string.Empty).Result)
            {
                return false;
            }

            if (!Lstk_check(sPltno ?? string.Empty).Result)
            {
                return false;
            }
        }
        catch (Exception ex)
        {
            return false;
        }

        return true;
    }

    public async Task<IEnumerable<Frm3100Dto.resDto>?> SpeedhAsync(string sPltno)
    {
        using var conn = db.Create();

        var sql = @"SELECT
                    A.SUBK_CODE   AS SubkCode,
                    B.MAST_NAME   AS MastName,
                    A.SUBK_LOTNO  AS SubkLotno,
                    A.SUBK_WGT    AS SubkWgt,
                    A.SUBK_BOXNO  AS SubkBoxno,
                    A.SUBK_REMARK AS SubkRemark,
                    A.SUBK_PLTNO  AS SubkPltno,
                    '1'           AS SubkRowState
                    FROM T2MISUBK A WITH (NOLOCK)
                    LEFT OUTER JOIN MIMAST B WITH (NOLOCK) ON A.SUBK_CODE = B.MAST_CODE
                     WHERE A.SUBK_PLTNO = @sPltno";

        return await conn.QueryAsync<Frm3100Dto.resDto>(sql, new
        {
            sPltno = sPltno ?? string.Empty
        });
    }
    public async Task<bool> Trak_check(string sPltno)
    {
        using var conn = db.Create();

        var trak_sql = @"SELECT COUNT(*)
                    FROM T2TBTRAK WITH (NOLOCK)
                    WHERE TRAK_PLTNO = @sPltno";

        var trak_cnt = await conn.QuerySingleAsync<int>(trak_sql, new
        {
            sPltno = sPltno ?? string.Empty
        });

        if (trak_cnt > 0)
        {
            return false;
        }

        return true;
    }

    public async Task<bool> Lstk_check(string sPltno)
    {
        using var conn = db.Create();

        var lstk_sql = @"SELECT COUNT(*)
                    FROM T2MILSTK WITH (NOLOCK)
                    WHERE LSTK_PLTNO = @sPltno";

        var lstk_cnt = await conn.QuerySingleAsync<int>(lstk_sql, new
        {
            sPltno = sPltno ?? string.Empty
        });

        if (lstk_cnt > 0)
        {
            return false;
        }

        return true;
    }

    public async Task<bool> Subk_check(string sPltno)
    {
        using var conn = db.Create();

        var lstk_sql = @"SELECT COUNT(*)
                    FROM T2MISUBK WITH (NOLOCK)
                    WHERE SUBK_PLTNO = @sPltno";

        var lstk_cnt = await conn.QuerySingleAsync<int>(lstk_sql, new
        {
            sPltno = sPltno ?? string.Empty
        });

        if (lstk_cnt > 0)
        {
            return false;
        }

        return true;
    }

    public async Task<int> Subk_Del(string sPltno, string? sSubkcode = null, string? sSubklotno = null)
    {
        using var conn = db.Create();
        var sql = "";
        if (string.IsNullOrEmpty(sSubkcode) && string.IsNullOrEmpty(sSubklotno))
        {
            sql = @"
                    DELETE FROM T2MISUBK
                    WHERE SUBK_PLTNO = @sPltno";


            return await conn.ExecuteAsync(sql, new { sPltno });
        }
        else
        {
            sql = @"
                    DELETE FROM T2MISUBK
                    WHERE SUBK_PLTNO = @sPltno
                    AND SUBK_CODE = @sSubkcode
                    AND SUBK_LOTNO = @sSubklotno";


            return await conn.ExecuteAsync(sql, new { sPltno, sSubkcode, sSubklotno });
        }
    }

    public async Task<int> Subk_insert(Frm3100Dto.resDto resDto)
    {
        using var conn = db.Create();

        var strDate = DateTime.Now.ToString("yyyyMMdd");
        var strTime = DateTime.Now.ToString("HHmmss");

        var subkWgt = resDto.SubkWgt?.Replace(".", "") ?? "";
        var sql = @"
                     INSERT INTO T2MISUBK
                                        (
                                            SUBK_CODE, SUBK_LOTNO, SUBK_FLAG, SUBK_GUBUN,
                                            SUBK_WGT,SUBK_RWGT, SUBK_BOXNO,SUBK_REMARK,
                                            SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO,SUBK_USERID
                                        )
                                        VALUES
                                        (   @SubkCode, @SubkLotno, '0', '',
                                            @subkWgt, '0', @SubkBoxno, @SubkRemark,
                                            @strDate, @strTime, @SubkPltno, '1'
                                        )";

        return await conn.ExecuteAsync( sql, new { SubkCode = resDto.SubkCode,
                                                    SubkLotno = resDto.SubkLotno,
                                                    subkWgt,
                                                    SubkBoxno = resDto.SubkBoxno,
                                                    SubkRemark = resDto.SubkRemark,
                                                    strDate,
                                                    strTime,
                                                    SubkPltno = resDto.SubkPltno
                                                  });
    } 
}

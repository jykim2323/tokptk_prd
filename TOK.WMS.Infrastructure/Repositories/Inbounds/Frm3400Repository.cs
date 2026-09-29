using Dapper;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Globalization;
using System.Text;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inbounds;

public class Frm3400Repository(DbConnectionFactory db) : IFrm3400Repository
{
    public async Task<IEnumerable<Frm3400Dto.ResDto>> SearchAsync(Frm3400Dto.ReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = new StringBuilder();

        sql.AppendLine(@"
            SELECT
                A.INPT_INDATE   AS InptIndate,
                A.INPT_INDEX    AS InptIndex,
                A.INPT_CODE     AS InptCode,
                B.MAST_NAME     AS MastName,
                A.INPT_LOTNO    AS InptLotno,
                A.INPT_WEIGHT   AS InptWeight,
                A.INPT_LOCA     AS InptLoca,
                A.INPT_STATION  AS InptStation,
                A.INPT_REMARK   AS InptRemark,
                A.INPT_BOXNO    AS InptBoxno,
                A.INPT_STIME    AS InptStime,
                A.INPT_ETIME    AS InptEtime,
                A.INPT_HOGI     AS InptHogi,
                A.INPT_JOB_FLAG AS InptJobFlag,
                A.INPT_RFLAG    AS InptRflag,
                A.INPT_RDATE    AS InptRdate,
                A.INPT_RTIME    AS InptRtime,
                A.INPT_OINDEX   AS InptOindex,
                A.INPT_ID       AS InptId,
                A.INPT_PLTNO    AS InptPltno

            FROM T2MIINPT A WITH (NOLOCK)

            LEFT OUTER JOIN MIMAST B WITH (NOLOCK)
                ON B.MAST_CODE = A.INPT_CODE

            WHERE A.INPT_JOB_FLAG <> '0'
              AND A.INPT_CODE <> 'EMPTY'

              AND A.INPT_INDATE >= @FromDate
              AND A.INPT_INDATE <= @ToDate
        ");

        var param = new DynamicParameters();

        param.Add("FromDate", reqDto.FromDate);
        param.Add("ToDate", reqDto.ToDate);


        // 신규입고 / 재입고
        if (reqDto.RFlag == "N")
        {
            sql.AppendLine(" AND A.INPT_RFLAG = 'N' ");
        }
        else if (reqDto.RFlag == "R")
        {
            sql.AppendLine(" AND A.INPT_RFLAG = 'R' ");
        }


        var searchText = reqDto.SearchText?.Trim();

        switch (reqDto.SearchType)
        {
            case "HOGI":

                if (!string.IsNullOrWhiteSpace(searchText))
                {
                    sql.AppendLine(" AND A.INPT_HOGI = @SearchText ");
                    param.Add("SearchText", searchText);
                }

                sql.AppendLine(" ORDER BY A.INPT_CODE, A.INPT_INDEX ");
                break;


            case "CODE":

                if (!string.IsNullOrWhiteSpace(searchText))
                {
                    sql.AppendLine(" AND A.INPT_CODE = @SearchText ");
                    param.Add("SearchText", searchText);
                }

                sql.AppendLine(" ORDER BY A.INPT_CODE, A.INPT_INDEX ");
                break;


            case "NAME":

                if (!string.IsNullOrWhiteSpace(searchText))
                {
                    sql.AppendLine(" AND B.MAST_NAME LIKE @SearchText ");
                    param.Add("SearchText", $"%{searchText}%");
                }

                sql.AppendLine(" ORDER BY A.INPT_CODE, A.INPT_INDEX ");
                break;


            case "LOTNO":

                if (!string.IsNullOrWhiteSpace(searchText))
                {
                    sql.AppendLine(" AND A.INPT_LOTNO = @SearchText ");
                    param.Add("SearchText", searchText);
                }

                sql.AppendLine(" ORDER BY A.INPT_LOTNO, A.INPT_INDEX ");
                break;


            case "PLTNO":

                if (!string.IsNullOrWhiteSpace(searchText))
                {
                    sql.AppendLine(" AND A.INPT_PLTNO = @SearchText ");
                    param.Add("SearchText", searchText);
                }

                sql.AppendLine(" ORDER BY A.INPT_PLTNO, A.INPT_INDEX ");
                break;


            default:

                sql.AppendLine(" ORDER BY A.INPT_INDEX, A.INPT_CODE ");
                break;
        }


        return await conn.QueryAsync<Frm3400Dto.ResDto>(
            sql.ToString(),
            param);
    }
    public async Task<bool> DeleteAsync(Frm3400Dto.DeleteReqDto reqDto)
    {
        using var conn = db.Create();

        var sql = @"
            DELETE FROM T2MIINPT

            WHERE INPT_CODE  = @InptCode
              AND INPT_INDEX = @InptIndex
        ";

        return await conn.ExecuteAsync(
            sql,
            new
            {
                InptCode = reqDto.InptCode ?? string.Empty,
                InptIndex = reqDto.InptIndex ?? string.Empty
            }) > 0;
    }

}

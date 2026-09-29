using Dapper;
using TOK.WMS.Core.DTOs.Outbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Outbounds;

public class Frm4400Repository(
    DbConnectionFactory db)
    : IFrm4400Repository
{
    // =========================================================
    // 출고 이력 조회
    // =========================================================

    public async Task<IEnumerable<Frm4400Dto.ResDto>?> SearchAsync(
        Frm4400Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        var sql = @"
            SELECT
                A.OUPT_DATE         AS OuptDate,
                A.OUPT_INDEX        AS OuptIndex,
                A.OUPT_SEQNO        AS OuptSeqno,
                A.OUPT_PLTNO        AS OuptPltno,

                A.OUPT_CODE         AS OuptCode,
                B.MAST_NAME         AS MastName,
                A.OUPT_LOTNO        AS OuptLotno,

                A.OUPT_GUBUN        AS OuptGubun,

                ISNULL(
                    A.OUPT_WGT,
                    0
                )                   AS OuptWgt,

                ISNULL(
                    A.OUPT_OUT_WGT,
                    0
                )                   AS OuptOutWgt,

                A.OUPT_LOCA         AS OuptLoca,

                A.OUPT_TIME         AS OuptTime,

                A.OUPT_JOB_FLAG     AS OuptJobFlag,

                A.OUPT_REMARK       AS OuptRemark,

                A.OUPT_ID           AS OuptId,

                A.OUPT_BOXNO        AS OuptBoxno,

                A.OUPT_CHASU        AS OuptChasu,

                A.OUPT_CUST         AS OuptCust,

                A.OUPT_REMARK1      AS OuptRemark1,

                A.OUPT_BOXNO1       AS OuptBoxno1

            FROM T2MIOUPT A WITH (NOLOCK)

            LEFT JOIN MIMAST B WITH (NOLOCK)
                ON B.MAST_CODE =
                   A.OUPT_CODE

            WHERE ISNULL(
                      A.OUPT_CODE,
                      ''
                  ) <> ''

              AND A.OUPT_DATE >= @FromDate
              AND A.OUPT_DATE <= @ToDate

              AND A.OUPT_JOB_FLAG <> '0'
        ";


        var param =
            new DynamicParameters();


        param.Add(
            "FromDate",
            reqDto.FromDate);


        param.Add(
            "ToDate",
            reqDto.ToDate);


        // =====================================================
        // 납품처
        // =====================================================

        if (!string.IsNullOrWhiteSpace(
            reqDto.Customer))
        {
            sql += @"
                AND A.OUPT_CUST LIKE
                    '%' + @Customer + '%'
            ";


            param.Add(
                "Customer",
                reqDto.Customer.Trim());
        }


        var searchType =
            reqDto.SearchType?
                .Trim()
                .ToUpperInvariant()
            ?? "ALL";


        var searchText =
            reqDto.SearchText?
                .Trim()
            ?? string.Empty;


        // =====================================================
        // 품목코드
        // =====================================================

        if (searchType == "CODE")
        {
            if (!string.IsNullOrWhiteSpace(
                searchText))
            {
                sql += @"
                    AND A.OUPT_CODE =
                        @SearchText
                ";


                param.Add(
                    "SearchText",
                    searchText);
            }


            sql += @"
                ORDER BY
                    A.OUPT_CODE,
                    A.OUPT_INDEX
            ";
        }

        // =====================================================
        // 품목명
        // =====================================================

        else if (searchType == "NAME")
        {
            if (!string.IsNullOrWhiteSpace(
                searchText))
            {
                sql += @"
                    AND B.MAST_NAME LIKE
                        '%' + @SearchText + '%'
                ";


                param.Add(
                    "SearchText",
                    searchText);
            }


            sql += @"
                ORDER BY
                    B.MAST_NAME,
                    A.OUPT_INDEX
            ";
        }

        // =====================================================
        // LOT
        // =====================================================

        else if (searchType == "LOTNO")
        {
            if (!string.IsNullOrWhiteSpace(
                searchText))
            {
                sql += @"
                    AND A.OUPT_LOTNO =
                        @SearchText
                ";


                param.Add(
                    "SearchText",
                    searchText);
            }


            sql += @"
                ORDER BY
                    A.OUPT_LOTNO,
                    A.OUPT_INDEX
            ";
        }

        // =====================================================
        // 재고위치
        // =====================================================

        else if (searchType == "LOCA")
        {
            if (!string.IsNullOrWhiteSpace(
                searchText))
            {
                sql += @"
                    AND A.OUPT_LOCA =
                        @SearchText
                ";


                param.Add(
                    "SearchText",
                    searchText);
            }


            sql += @"
                ORDER BY
                    A.OUPT_LOCA,
                    A.OUPT_INDEX
            ";
        }

        // =====================================================
        // ALL
        // =====================================================

        else
        {
            sql += @"
                ORDER BY
                    A.OUPT_DATE,
                    A.OUPT_TIME,
                    A.OUPT_INDEX,
                    A.OUPT_CODE
            ";
        }


        return await conn.QueryAsync<
            Frm4400Dto.ResDto>(
            sql,
            param);
    }


    // =========================================================
    // 납품처 ComboBox
    // =========================================================

    public async Task<IEnumerable<Frm4400Dto.CustomerDto>?> CustomerSearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                CUST_NAME AS Name

            FROM MICUST WITH (NOLOCK)

            WHERE ISNULL(
                      CUST_NAME,
                      ''
                  ) <> ''

            ORDER BY
                CUST_CODE
        ";


        return await conn.QueryAsync<
            Frm4400Dto.CustomerDto>(
            sql);
    }


    // =========================================================
    // 출고이력 삭제
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm4400Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            DELETE FROM T2MIOUPT

            WHERE OUPT_INDEX =
                  @OuptIndex

              AND OUPT_CODE =
                  @OuptCode

              AND OUPT_LOTNO =
                  @OuptLotno
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }
}
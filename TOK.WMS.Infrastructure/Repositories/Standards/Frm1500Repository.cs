using Dapper;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public class Frm1500Repository(
    DbConnectionFactory db)
    : IFrm1500Repository
{
    // =========================================================
    // 구분#1 조회
    // =========================================================

    public async Task<IEnumerable<Frm1500Dto.Gubn1Dto>?> Gubn1SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN1_CODE AS Gubn1Code,
                GUBN1_NAME AS Gubn1Name

            FROM MIGUBN1 WITH (NOLOCK)

            ORDER BY GUBN1_CODE
        ";


        return await conn.QueryAsync<
            Frm1500Dto.Gubn1Dto>(
            sql);
    }


    // =========================================================
    // 구분#2 조회
    // =========================================================

    public async Task<IEnumerable<Frm1500Dto.Gubn2Dto>?> Gubn2SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN2_CODE AS Gubn2Code,
                GUBN2_NAME AS Gubn2Name

            FROM MIGUBN2 WITH (NOLOCK)

            ORDER BY GUBN2_CODE
        ";


        return await conn.QueryAsync<
            Frm1500Dto.Gubn2Dto>(
            sql);
    }


    // =========================================================
    // 구분#3 조회
    // =========================================================

    public async Task<IEnumerable<Frm1500Dto.Gubn3Dto>?> Gubn3SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN3_CODE AS Gubn3Code,
                GUBN3_NAME AS Gubn3Name

            FROM MIGUBN3 WITH (NOLOCK)

            ORDER BY GUBN3_CODE
        ";


        return await conn.QueryAsync<
            Frm1500Dto.Gubn3Dto>(
            sql);
    }


    // =========================================================
    // 구분#1 등록
    // =========================================================

    public async Task<int> InsertGubn1Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            INSERT INTO MIGUBN1
            (
                GUBN1_CODE,
                GUBN1_NAME
            )
            VALUES
            (
                @Code,
                @Name
            )
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 구분#1 수정
    // =========================================================

    public async Task<int> UpdateGubn1Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            UPDATE MIGUBN1

            SET GUBN1_NAME = @Name

            WHERE GUBN1_CODE = @Code
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 구분#1 삭제
    // =========================================================

    public async Task<int> DeleteGubn1Async(
        Frm1500Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            DELETE FROM MIGUBN1

            WHERE GUBN1_CODE = @Code
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 구분#2 등록
    // =========================================================

    public async Task<int> InsertGubn2Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            INSERT INTO MIGUBN2
            (
                GUBN2_CODE,
                GUBN2_NAME
            )
            VALUES
            (
                @Code,
                @Name
            )
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 구분#2 수정
    // =========================================================

    public async Task<int> UpdateGubn2Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            UPDATE MIGUBN2

            SET GUBN2_NAME = @Name

            WHERE GUBN2_CODE = @Code
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 구분#2 삭제
    // =========================================================

    public async Task<int> DeleteGubn2Async(
        Frm1500Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            DELETE FROM MIGUBN2

            WHERE GUBN2_CODE = @Code
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 구분#3 등록
    // =========================================================

    public async Task<int> InsertGubn3Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            INSERT INTO MIGUBN3
            (
                GUBN3_CODE,
                GUBN3_NAME
            )
            VALUES
            (
                @Code,
                @Name
            )
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 구분#3 수정
    // =========================================================

    public async Task<int> UpdateGubn3Async(
        Frm1500Dto.SaveReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            UPDATE MIGUBN3

            SET GUBN3_NAME = @Name

            WHERE GUBN3_CODE = @Code
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 구분#3 삭제
    // =========================================================

    public async Task<int> DeleteGubn3Async(
        Frm1500Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            DELETE FROM MIGUBN3

            WHERE GUBN3_CODE = @Code
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }
}
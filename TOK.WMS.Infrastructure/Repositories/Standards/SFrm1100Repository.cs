using Dapper;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public class SFrm1100Repository(
    DbConnectionFactory db)
    : ISFrm1100Repository
{
    // =========================================================
    // 구분1
    // =========================================================

    public async Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn1SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN1_CODE AS Code,
                GUBN1_NAME AS Name
            FROM MIGUBN1 WITH (NOLOCK)
            ORDER BY GUBN1_CODE
        ";


        return await conn.QueryAsync<
            SFrm1100Dto.GubnDto>(
            sql);
    }


    // =========================================================
    // 구분2
    // =========================================================

    public async Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn2SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN2_CODE AS Code,
                GUBN2_NAME AS Name
            FROM MIGUBN2 WITH (NOLOCK)
            ORDER BY GUBN2_CODE
        ";


        return await conn.QueryAsync<
            SFrm1100Dto.GubnDto>(
            sql);
    }


    // =========================================================
    // 구분3
    // =========================================================

    public async Task<IEnumerable<SFrm1100Dto.GubnDto>?> Gubn3SearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                GUBN3_CODE AS Code,
                GUBN3_NAME AS Name
            FROM MIGUBN3 WITH (NOLOCK)
            ORDER BY GUBN3_CODE
        ";


        return await conn.QueryAsync<
            SFrm1100Dto.GubnDto>(
            sql);
    }


    // =========================================================
    // 등록
    // Delphi Insert_Code
    // =========================================================

    public async Task<int> InsertAsync(
        SFrm1100Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            INSERT INTO MIMAST
            (
                MAST_CODE,
                MAST_BCODE,
                MAST_NAME,
                MAST_UNIT,
                MAST_WEIGHT,
                MAST_DATE,
                MAST_GUBN1,
                MAST_GUBN2,
                MAST_GUBN3,
                MAST_REF1
            )
            VALUES
            (
                @MastCode,
                @MastBcode,
                @MastName,
                @MastUnit,
                @MastWeight,
                GETDATE(),
                @MastGubn1,
                @MastGubn2,
                @MastGubn3,
                @MastRef1
            )
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 수정
    // Delphi Update_Code
    // =========================================================

    public async Task<int> UpdateAsync(
        SFrm1100Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            UPDATE MIMAST

            SET
                MAST_BCODE = @MastBcode,
                MAST_NAME = @MastName,
                MAST_UNIT = @MastUnit,
                MAST_WEIGHT = @MastWeight,
                MAST_DATE = GETDATE(),
                MAST_GUBN1 = @MastGubn1,
                MAST_GUBN2 = @MastGubn2,
                MAST_GUBN3 = @MastGubn3,
                MAST_REF1 = @MastRef1

            WHERE MAST_CODE = @MastCode
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 삭제
    // Delphi Delete_code
    // =========================================================

    public async Task<int> DeleteAsync(
        SFrm1100Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            DELETE FROM MIMAST
            WHERE MAST_CODE = @MastCode
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }
}
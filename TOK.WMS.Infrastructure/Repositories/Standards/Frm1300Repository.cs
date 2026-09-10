using Dapper;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Standards;

public class Frm1300Repository(
    DbConnectionFactory db)
    : IFrm1300Repository
{
    // =========================================================
    // 검색
    // Delphi:
    // WHERE USER_ID >= 검색값
    // =========================================================

    public async Task<IEnumerable<Frm1300Dto.ResDto>?> SearchAsync(
        Frm1300Dto.ReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                USER_ID     AS UserId,
                USER_PW     AS UserPassword,
                USER_NM     AS UserName,
                USER_WDATE  AS UserWdate,
                USER_KIND   AS UserKind,
                USER_USES   AS UserUses

            FROM USERID WITH (NOLOCK)

            WHERE USER_ID >= @SearchText

            ORDER BY USER_ID
        ";


        return await conn.QueryAsync<
            Frm1300Dto.ResDto>(
            sql,
            new
            {
                SearchText =
                    reqDto.SearchText?.Trim()
                    ?? string.Empty
            });
    }


    // =========================================================
    // 전체 조회
    // =========================================================

    public async Task<IEnumerable<Frm1300Dto.ResDto>?> AllSearchAsync()
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT
                USER_ID     AS UserId,
                USER_PW     AS UserPassword,
                USER_NM     AS UserName,
                USER_WDATE  AS UserWdate,
                USER_KIND   AS UserKind,
                USER_USES   AS UserUses

            FROM USERID WITH (NOLOCK)

            ORDER BY USER_ID
        ";


        return await conn.QueryAsync<
            Frm1300Dto.ResDto>(
            sql);
    }


    // =========================================================
    // ID 중복 체크
    // =========================================================

    public async Task<bool> DuplicateCheckAsync(
        Frm1300Dto.DuplicateReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            SELECT COUNT(*)

            FROM USERID WITH (NOLOCK)

            WHERE USER_ID = @UserId
        ";


        var count =
            await conn.ExecuteScalarAsync<int>(
                sql,
                reqDto);


        return count > 0;
    }


    // =========================================================
    // 등록
    // =========================================================

    public async Task<int> InsertAsync(
        Frm1300Dto.SaveReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            INSERT INTO USERID
            (
                USER_ID,
                USER_PW,
                USER_NM,
                USER_KIND
            )
            VALUES
            (
                @UserId,
                @UserPassword,
                @UserName,
                @UserKind
            )
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 수정
    // =========================================================

    public async Task<int> UpdateAsync(
        Frm1300Dto.SaveReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            UPDATE USERID

            SET
                USER_PW = @UserPassword,
                USER_NM = @UserName,
                USER_KIND = @UserKind

            WHERE USER_ID = @UserId
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }


    // =========================================================
    // 삭제
    // =========================================================

    public async Task<int> DeleteAsync(
        Frm1300Dto.DeleteReqDto reqDto)
    {
        using var conn =
            db.Create();


        const string sql = @"
            DELETE FROM USERID

            WHERE USER_ID = @UserId
        ";


        return await conn.ExecuteAsync(
            sql,
            reqDto);
    }
}
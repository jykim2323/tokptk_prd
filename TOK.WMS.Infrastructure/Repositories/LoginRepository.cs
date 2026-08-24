using Dapper;
using TOK.WMS.Core.DTOs.Login;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories;

public sealed class LoginRepository(DbConnectionFactory db) : ILoginRepository
{
    public async Task<CurrentUserDto?> SelectUserAsync(string userId, string password)
    {
        using var conn = db.Create();

        var sql = @"SELECT
                    USER_ID AS UserId, USER_PW AS UserPassword, USER_NM AS UserName,
                    USER_JNO AS UserJobNumber, USER_KIND AS UserKind, USER_USES AS UserUses
                    FROM USERID WITH (NOLOCK)
                    WHERE USER_ID = @UserId
                    AND USER_PW = @Password";

        return await conn.QuerySingleOrDefaultAsync<CurrentUserDto>(sql, new
        {
            UserId = userId,
            Password = password
        });
    }
}

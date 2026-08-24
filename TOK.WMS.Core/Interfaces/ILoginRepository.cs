using TOK.WMS.Core.DTOs.Login;

namespace TOK.WMS.Core.Interfaces;

/// <summary>
/// 로그인 사용자 기능 정의
/// </summary>
public interface ILoginRepository
{
    Task<CurrentUserDto?> SelectUserAsync(
        string userId,
        string password);
}

using TOK.WMS.Core.DTOs.Login;

namespace TOK.WMS.Core.Interfaces;

public interface ILoginRepository
{
    Task<LoginUserDto?> SelectUserAsync(
        string userId,
        string password);
}

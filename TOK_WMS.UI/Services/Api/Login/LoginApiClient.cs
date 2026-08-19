using System.Net.Http;
using System.Net.Http.Json;
using TOK.WMS.Core.DTOs.Login;

namespace TOK.WMS.UI.Services.Api.Login;

public interface ILoginApi
{
    Task<LoginUserDto> Login(LoginUserDto dto);

}
class LoginApiClient(HttpClient http) : ILoginApi
{
    public async Task<LoginUserDto> Login(LoginUserDto dto)
    {
        string qs =
            $"UserId={Uri.EscapeDataString(dto.UserId ?? "")}" +
            $"&UserPassword={Uri.EscapeDataString(dto.UserPassword ?? "")}";

        var response = await http.GetAsync($"api/tok/login?{qs}");

        if (!response.IsSuccessStatusCode)
        {
            var message = await response.Content.ReadAsStringAsync();

            throw new Exception(
                string.IsNullOrWhiteSpace(message)
                    ? "로그인에 실패했습니다."
                    : message);
        }

        return await response.Content.ReadFromJsonAsync<LoginUserDto>();
    }
}

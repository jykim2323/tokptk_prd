using Microsoft.AspNetCore.Mvc;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.DTOs.Login;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;

namespace TOK.WMS.Api.Controllers.Login;

[Route("api/tok")]
[ApiController]
public class LoginController(ILoginRepository login) : ControllerBase
{
    [HttpGet("login")]
    public async Task<IActionResult> Login([FromQuery] LoginUserDto query)
    {
        var user = await login.SelectUserAsync(
            query.UserId,
            query.UserPassword);

        if (user == null)
            return Unauthorized("아이디 또는 비밀번호가 올바르지 않습니다.");


        return Ok(user);
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Login
{
    /// <summary>
    /// 로그인 요청 
    /// </summary>
    /// <remarks>
    /// 로그인 요청시 클라이언트 ->  API
    /// </remarks>
    public sealed class LoginRequestDto
    {
        public string UserId { get; set; } = string.Empty; // 

        public string Password { get; set; } = string.Empty; // 
    }
}

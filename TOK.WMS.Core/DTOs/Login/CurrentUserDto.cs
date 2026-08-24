using System;
using System.Collections.Generic;
using System.Text;

namespace TOK.WMS.Core.DTOs.Login
{
    /// <summary>
    /// 사용자 정보  
    /// </summary>
    /// <remarks>
    /// 로그인 성공 후 사용자 정보 수신 (API -> 클라이언트)
    /// </remarks>
    public sealed class CurrentUserDto
    {
        public string UserId { get; set; } = string.Empty;

        public string UserName { get; set; } = string.Empty;

        public string UserJobNumber { get; set; } = string.Empty;

        public int UserKind { get; set; }

        public string UserUses { get; set; } = string.Empty;
    }
}

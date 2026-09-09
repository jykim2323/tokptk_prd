using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Login;
using TOK.WMS.UI.Services.Interfaces;

namespace TOK.WMS.UI.Services.ETC;

public class CurrentUserService : ICurrentUserService
{
    public LoginUserDto? User { get; set; }
}

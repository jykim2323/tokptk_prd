using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Login;

namespace TOK.WMS.UI.Services.Interfaces;

public interface ICurrentUserService
{
    public LoginUserDto? User { get; set; }
}

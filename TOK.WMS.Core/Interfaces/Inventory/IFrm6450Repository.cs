using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6450Repository
{
    Task<IEnumerable<Frm6450Dto.ResDto>?> SearchAsync(Frm6450Dto.ReqDto reqDto);
    Task<IEnumerable<Frm6450Dto.ResDto>?> PltnoCntAsync(Frm6450Dto.ReqDto reqDto);

}

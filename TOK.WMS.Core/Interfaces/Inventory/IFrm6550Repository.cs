using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6550Repository
{
    Task<IEnumerable<Frm6550Dto.ResDto>?> SearchAsync(Frm6550Dto.ReqDto reqDto);

}

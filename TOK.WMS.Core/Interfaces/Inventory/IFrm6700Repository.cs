using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6700Repository
{
    Task<IEnumerable<Frm6700Dto.ResDto>?> SearchAsync(Frm6700Dto.ReqDto reqDto);

}

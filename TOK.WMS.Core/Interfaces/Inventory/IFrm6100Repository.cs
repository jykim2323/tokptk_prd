using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;

namespace TOK.WMS.Core.Interfaces.Inventory;

public interface IFrm6100Repository
{

    Task<IEnumerable<Frm6100Dto.ResDto>?> SearchAsync(Frm6100Dto reqDto);

}

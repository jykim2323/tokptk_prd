using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs;

namespace TOK.WMS.Core.Interfaces;

public interface ICoreRepository
{
    public Task<bool> Trak_check(string sPltno);
    public Task<bool> Lstk_check(string sPltno);
    public Task<bool> Subk_check(string sPltno);
    public Task<string?> Lstk_pltno_check(string sPltno);
    public Task<bool> Subk_loca_check(string sPltno);
    public Task<string?> SubklocacheckAsync(string subkpltno);
    public Task<bool> Subk_dup_check(string sPltno, string subkCode, string subkLotno);
}

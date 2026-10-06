using System;
using System.Collections.Generic;
using System.Text;
using TOK.WMS.Core.DTOs.Inventory;
using TOK.WMS.Core.DTOs.Standards;
using TOK.WMS.Core.DTOs.Monitoring;
using System.Windows;

namespace TOK.WMS.UI.Services.Interfaces.Popup;

public interface IWindowService
{
    void ShowSFrm6110(Frm6100Dto.ResDto item);
    void ShowSFrm6120(Frm6100Dto.SubkDto item);
    void ShowSFrm6130(Frm6900Dto.SubkDto item);
    void ShowLocaAdd(Frm6100Dto.SubkDto item);
    void ShowSFrm6910(string leftPltno, string rightPltno);
    void ShowSFrm1100(SFrm1100Dto.InitDto item, string mode);
    public MastDispDto.ResDto? ShowMastDisp(string searchText);
    void ShowTrackingInfo(string trackNo);
    void ShowStackerWork(int craneNo);
    void ShowRackOverview(int bank, int selectedBay);
    void ShowRackCellDetail(string location);
    bool ShowRackInventoryEdit(string location, MonitoringRackInventoryDto? original = null, Window? owner = null);
}

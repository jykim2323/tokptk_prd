using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.DTOs.Outbounds;

public partial class Frm4100Dto
{
    public class ReqDto
    {
        public string? ItemCode { get; set; }
        public string? ItemName { get; set; }
        public string? LotNo { get; set; }
    }


    public class StockDto
    {
        public string? SubkLoca { get; set; }
        public string? SubkPltno { get; set; }

        public string? SubkCode { get; set; }
        public string? MastName { get; set; }

        public string? SubkLotno { get; set; }

        public decimal SubkWgt { get; set; }

        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }

        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }
    }


    public class PalletItemDto
    {
        public string? SubkLoca { get; set; }

        public string? SubkCode { get; set; }
        public string? MastName { get; set; }

        public string? SubkLotno { get; set; }

        public string? SubkFlag { get; set; }

        public decimal SubkWgt { get; set; }
        public decimal SubkRwgt { get; set; }

        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }

        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }

        public decimal AvailableQty =>
            SubkWgt - SubkRwgt;
    }


    public class StationStatusDto
    {
        public string? Hogi { get; set; }

        public bool Station1Visible { get; set; }
        public bool Station2Visible { get; set; }

        public string? Station1No { get; set; }
        public string? Station2No { get; set; }

        public bool Station1OutputMode { get; set; }
        public bool Station2OutputMode { get; set; }

        public bool AutoMode { get; set; }

        public string? Station1ModeText { get; set; }
        public string? Station2ModeText { get; set; }
    }


    public partial class WorkDto : ObservableObject
    {
        public string? SubkLoca { get; set; }

        public string? SubkPltno { get; set; }

        public string? SubkCode { get; set; }
        public string? MastName { get; set; }

        public string? SubkLotno { get; set; }

        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }

        public decimal StockQty { get; set; }

        public decimal RequestQty { get; set; }

        public string? Customer { get; set; }

        public string? OutBoxno { get; set; }
        public string? OutRemark { get; set; }

        public string? Wsno { get; set; }

        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }
    }


    public class ReserveReqDto
    {
        public string? UserId { get; set; }

        public bool Emergency { get; set; }

        public List<WorkDto> Items { get; set; } = [];
    }


    public class ReserveResultDto
    {
        public bool Success { get; set; }

        public int PltCount { get; set; }

        public int DetailCount { get; set; }

        public string? Message { get; set; }
    }


    public class DirectOutputReqDto
    {
        public string? UserId { get; set; }

        public bool Emergency { get; set; }

        public WorkDto? Item { get; set; }
    }


    public class DirectOutputResultDto
    {
        public bool Success { get; set; }

        public string? OutIndex { get; set; }

        public string? Message { get; set; }
    }
}
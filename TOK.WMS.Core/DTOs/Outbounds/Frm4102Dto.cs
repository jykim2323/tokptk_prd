using CommunityToolkit.Mvvm.ComponentModel;

namespace TOK.WMS.Core.DTOs.Outbounds;

public partial class Frm4102Dto
{
    public class ReqDto
    {
        public string? OutDate { get; set; }
        public string? ItemCode { get; set; }
    }


    public partial class ResDto : ObservableObject
    {
        [ObservableProperty] private bool _isSelected;

        public string? HoChasu { get; set; }
        public string? HoDate { get; set; }
        public string? HoTime { get; set; }

        public string? HoCode { get; set; }
        public string? MastName { get; set; }

        public string? HoLotno { get; set; }
        public string? HoCust { get; set; }

        public decimal HoQty { get; set; }
        public decimal HoOutQty { get; set; }
        public decimal StokQty { get; set; }

        public string? HoBoxno { get; set; }
        public string? HoRemark { get; set; }

        public string? HoFlag { get; set; }

        public string StatusName =>
            HoFlag == "Y"
                ? "출고"
                : string.Empty;
    }


    public class ReserveItemDto
    {
        public string? HoChasu { get; set; }
        public string? HoDate { get; set; }

        public string? HoCode { get; set; }
        public string? HoLotno { get; set; }
        public string? HoCust { get; set; }

        public decimal HoQty { get; set; }

        public string? HoBoxno { get; set; }
        public string? HoRemark { get; set; }
    }


    public class ReserveReqDto
    {
        public string? UserId { get; set; }

        public List<ReserveItemDto> Items { get; set; } = [];
    }


    public class ReserveResultDto
    {
        public bool Success { get; set; }

        public int SelectedCount { get; set; }

        public int ShortageCount { get; set; }

        public string? Chasu { get; set; }

        public string? Message { get; set; }
    }


    public class DeleteReqDto
    {
        public string? HoDate { get; set; }
        public string? HoChasu { get; set; }

        public string? HoCode { get; set; }
        public string? HoLotno { get; set; }

        public string? HoCust { get; set; }
    }


    public class StockDto
    {
        public string? SubkLoca { get; set; }
        public string? SubkCode { get; set; }
        public string? SubkLotno { get; set; }

        public string? SubkBoxno { get; set; }
        public string? SubkRemark { get; set; }

        public decimal SubkWgt { get; set; }
        public decimal SubkRwgt { get; set; }

        public string? SubkIndate { get; set; }
        public string? SubkIntime { get; set; }

        public string? SubkPltno { get; set; }

        public string? LstkFlag { get; set; }
    }


    public class StatDto
    {
        public string? StatSc1Io { get; set; }
        public string? StatSc2Io { get; set; }
        public string? StatSc3Io { get; set; }

        public string? StatCv1 { get; set; }
        public string? StatCv2 { get; set; }
        public string? StatCv3 { get; set; }
        public string? StatCv4 { get; set; }
        public string? StatCv5 { get; set; }
        public string? StatCv6 { get; set; }

        public string? StatOdate { get; set; }
        public int StatOindx { get; set; }
    }


    public class TiodatDto
    {
        public string? OdatLoca { get; set; }
        public string? OdatCode { get; set; }
        public string? OdatLotno { get; set; }

        public string? OdatCust { get; set; }

        public decimal OdatRqty { get; set; }

        public string? OdatChasu { get; set; }

        public string? OdatIndate { get; set; }
        public string? OdatIntime { get; set; }

        public string? OdatBoxno { get; set; }
        public string? OdatRemark { get; set; }

        public string? OdatBoxno1 { get; set; }
        public string? OdatRemark1 { get; set; }

        public string? SubkPltno { get; set; }

        public decimal SubkWgt { get; set; }
    }
}
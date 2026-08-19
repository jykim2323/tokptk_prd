

namespace TOK.WMS.Core.DTOs.Inbounds;

/// <summary>
/// Frm3100 수동 입고 등록 화면의 품목 조회 결과 한 행을 표현합니다.
/// </summary>
public partial class Frm3100Dto 
{

    public string MastCode { get; set; } = string.Empty;
    public string MastBcode { get; set; } = string.Empty;
    public string MastName { get; set; } = string.Empty;
    public string MastUnit { get; set; } = string.Empty;
    public string MastWeight { get; set; } = string.Empty;
    public string MastGubn1 { get; set; } = string.Empty;
    public string Gubn1Name { get; set; } = string.Empty;
    public string MastGubn2 { get; set; } = string.Empty;
    public string Gubn2Name { get; set; } = string.Empty;
    public string MastGubn3 { get; set; } = string.Empty;
    public string Gubn3Name { get; set; } = string.Empty;
    public string MastDate { get; set; } = string.Empty;

    public string ItemEdit { get; set; } = string.Empty;
    public string ItemNmEdit { get; set; } = string.Empty;
    public string PltnoSrcEdit { get; set; } = string.Empty;
    public string BcrEdit { get; set; } = string.Empty;
    public string RecNoEdit { get; set; } = string.Empty;
    public string PltnoEdit { get; set; } = string.Empty;
    public string ItnbrEdit { get; set; } = string.Empty;
    public string NameEdit { get; set; } = string.Empty;
    public string WeightEdit { get; set; } = string.Empty;
    public string LotnoEdit { get; set; } = string.Empty;
    public string BoxNoEdit { get; set; } = string.Empty;
    public string BigoEdit { get; set; } = string.Empty;

    public object? LstkLv { get; set; }
    public object? LstkBk { get; set; }
    public object? Cnt { get; set; }

    public string? SubkPltno { get; set; } = string.Empty;
    public object? SubkCode { get; set; }
    public object? SubkLotno { get; set; }
    public object? SubkFlag { get; set; }



    public class resDto 
    {
        public string SubkPltno { get; set; } = string.Empty;
        public string SubkCode { get; set; } = string.Empty;
        public string MastName { get; set; } = string.Empty;
        public string SubkLotno { get; set; } = string.Empty;
        public string SubkWgt { get; set; } = string.Empty;
        public string SubkBoxno { get; set; } = string.Empty;
        public string SubkRemark { get; set; } = string.Empty;
        public string SubkIndate { get; set; } = string.Empty;
        public string SubkIntime { get; set; } = string.Empty;
        public string SubkRowState { get; set; } = "1";
    }
}



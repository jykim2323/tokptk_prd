namespace TOK.WMS.Core.DTOs.Outbounds;

public partial class Frm4103Dto
{
    public class ReqDto
    {
        public string? OutDate { get; set; }
        public string? Chasu { get; set; }
    }


    public class ChasuDto
    {
        public string? Chasu { get; set; }
    }


    public class SummaryDto
    {
        public string? OuptDate { get; set; }
        public string? OuptChasu { get; set; }

        public int ProductCount { get; set; }

        public string? JobStatus { get; set; }
    }


    public class ScheduleDto
    {
        public string? ScheSc { get; set; }

        public string? ScheIndex { get; set; }

        public string? ScheJobGubun { get; set; }

        public string? ScheLoca { get; set; }

        public string? ScheWsno { get; set; }

        public string? ScheEmer { get; set; }

        public string? ScheDate { get; set; }

        public string? ScheTime { get; set; }
    }


    public class DeleteReqDto
    {
        public string? ScheIndex { get; set; }

        public string? ScheLoca { get; set; }
    }


    public class ConfirmReqDto
    {
        public string? UserId { get; set; }
    }


    public class ConfirmResultDto
    {
        public bool Success { get; set; }

        public int Count { get; set; }

        public string? Message { get; set; }
    }
}
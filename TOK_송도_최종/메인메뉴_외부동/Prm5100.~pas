unit Prm5100;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, ComObj, ActiveX,
  OleServer, Excel97,  DB, DBTables, Mask;

type
  TPrm_5100 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    PBar: TProgressBar;
    Query2: TQuery;
    CboSCode: TMaskEdit;
    CboECode: TMaskEdit;
    Query1: TQuery;
    Database1: TDatabase;
    Panel1: TPanel;
    Shape2: TShape;
    Label4: TLabel;
    PrintAButton: TSpeedButton;
    PrintSButton: TSpeedButton;
    Query1SUBK_PLTNO: TStringField;
    Query1SUBK_LOCA: TStringField;
    Query1SUBK_FLAG: TStringField;
    Query1SUBK_CODE: TStringField;
    Query1SUBK_QTY: TFloatField;
    Query1SUBK_INDATE: TStringField;
    Query1SUBK_INTIME: TStringField;
    ExitBitBtn: TBitBtn;
    Query1SUBK_GUBUN: TStringField;
    Query1SUBK_RQTY: TFloatField;
    Query1SUBK_CVCOD: TStringField;
    Query1SUBK_LOTNO: TStringField;
    Query1SUBK_JPNO: TStringField;
    Query1ISPEC: TStringField;
    Query1CVNAS: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure PrintSButtonClick(Sender: TObject);
    procedure PrintAButtonClick(Sender: TObject); 
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    procedure Func_Code_Print( var_Chk : Boolean; var_Sql : String );
                                       
  public
    { Public declarations }
  end;

var
  Prm_5100: TPrm_5100;
  s_scode, s_ecode : String;
  pb_data_ok : Boolean;

implementation

USES  Qrt5100, Frm5100;

{$R *.dfm}        


procedure TPrm_5100.PrintSButtonClick(Sender: TObject);
var
  var_sql : String;
  var_scode, var_ecode : String;
begin
  pb_data_ok := True;

  var_scode := CboSCode.Text;
  var_ecode := CboECode.Text;
  s_scode := var_scode;     s_ecode := var_Ecode;

 
  var_Sql := ' Select  a.subk_pltno, a.subk_loca, a.subk_flag, a.subk_code, a.subk_gubun, ';
  var_Sql := var_Sql + ' a.subk_qty, a.subk_rqty, a.subk_cvcod, a.subk_lotno, a.subk_jpno,  ';
  var_Sql := var_Sql + ' a.subk_indate,  a.subk_intime, b.ispec, c.cvnas    ';
  var_Sql := var_Sql + '  From misubk a, mimast b, micust c                 ';
  var_Sql := var_Sql + '  Where a.subk_code = b.itnbr(+)  and a.subk_cvcod = c.cvnas(+)  and       ';
  var_Sql := var_Sql + '        subk_loca  >= '''+ var_scode +''' and subk_loca <= '''+ var_ecode +''' ';
  var_Sql := var_Sql + '  Order By subk_loca, subk_code  ';

  Func_Code_Print( True, var_Sql );
end;

procedure TPrm_5100.PrintAButtonClick(Sender: TObject);
var
  var_sql : String;
begin
  pb_data_ok := False;

  var_Sql := ' Select  a.subk_pltno, a.subk_loca, a.subk_flag, a.subk_code, a.subk_gubun, ';
  var_Sql := var_Sql + ' a.subk_qty, a.subk_rqty, a.subk_cvcod, a.subk_lotno, a.subk_jpno,  ';
  var_Sql := var_Sql + ' a.subk_indate,  a.subk_intime, b.ispec, c.cvnas    ';
  var_Sql := var_Sql + '  From misubk a, mimast b, micust c              ';
  var_Sql := var_Sql + '  Where a.subk_code = b.itnbr(+)  and a.subk_cvcod = c.cvnas(+)        ';
  var_Sql := var_Sql + '  Order By subk_loca, subk_code          ';

  Func_Code_Print( False, var_Sql );
end;

procedure TPrm_5100.Func_Code_Print( var_Chk : Boolean; var_Sql : String );
var
  var_scode, var_ecode : String;
begin
  var_scode := CboSCode.Text;
  var_ecode := CboECode.Text;

  Qrt_5100 := TQrt_5100.Create(Application);
  With Qrt_5100 Do Begin
      With Query1 Do
      begin
        Close;
        SQL.clear;
        SQL.Add(var_Sql);
        Open;
        FetchAll;
        IF RecordCount > 0 Then Begin
            With PBar Do
            Begin
                Min := 0;
                Max := RecordCount;
                Position := 0;
                Visible  := true;
            End;

            QRLbl_DateTime.Caption := DateTimeToStr( Now );
            IF var_Chk Then Begin
                QRLbl_Code.Caption := '선택일자  : ' + var_scode + ' ~ ' + var_ecode;
            End
            Else QRLbl_Code.Caption := '선택일자 : 전체 인쇄';

            Visible  := False;
        End;
      End;

      QuickReport.Preview;
//      QuickReport.Print;
  End;
End;


procedure TPrm_5100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPrm_5100.FormDestroy(Sender: TObject);
begin
  Prm_5100 := Nil;
end;

procedure TPrm_5100.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TPrm_5100.FormCreate(Sender: TObject);
begin
  pb_data_ok := False;
end;

end.


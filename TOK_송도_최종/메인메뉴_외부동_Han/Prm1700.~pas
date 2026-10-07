unit Prm1700;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, ComObj, ActiveX,
  OleServer, Excel97,  DB, DBTables, Mask, ADODB;

type
  TPrm_1700 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    PBar: TProgressBar;
    CboSCode: TMaskEdit;
    CboECode: TMaskEdit;
    Panel1: TPanel;
    ExitBitBtn: TSpeedButton;
    Shape2: TShape;
    Label4: TLabel;
    PrintAButton: TSpeedButton;
    PrintSButton: TSpeedButton;
    Query2: TADOQuery;
    Query1: TADOQuery;
    Query1mesg_dt: TStringField;
    Query1mesg_ehogi: TStringField;
    Query1mesg_eloca: TStringField;
    Query1mesg_desc: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure PrintSButtonClick(Sender: TObject);
    procedure PrintAButtonClick(Sender: TObject); 
    procedure ExitBitBtnClick(Sender: TObject);

  private
    procedure Func_Code_Print( var_Chk : Boolean; var_Sql : String );
                                       
  public
    { Public declarations }
  end;

var
  Prm_1700: TPrm_1700;

implementation

USES Dbset,  Qrt1700;

{$R *.dfm}


procedure TPrm_1700.PrintSButtonClick(Sender: TObject);
var
  var_sql : String;
  var_scode, var_ecode : String;
begin
  var_scode := CboSCode.Text;
  var_ecode := CboECode.Text;

  var_Sql := 'Select * From STK_TIMESG ';
  var_Sql := var_Sql + ' Where SubStr(MESG_DT,1,8) >= '''+ var_scode +''' and SubStr(MESG_DT,1,8) <= '''+ var_ecode +''' ';
  var_Sql := var_Sql + ' Order By MESG_DT ';

  Func_Code_Print( True, var_Sql );
end;


procedure TPrm_1700.PrintAButtonClick(Sender: TObject);
var
  var_sql : String;
begin
  var_Sql := 'select *  from STK1_TbMESG ';
  var_Sql := var_Sql + ' order by MESG_DT  ';


  Func_Code_Print( False, var_Sql );
end;

procedure TPrm_1700.Func_Code_Print( var_Chk : Boolean; var_Sql : String );
var
  var_scode, var_ecode : String;
begin
  var_scode := CboSCode.Text;
  var_ecode := CboECode.Text;

  Qrt_1700 := TQrt_1700.Create(Application);
  With Qrt_1700 Do Begin
      With Query1 Do
      begin
        Close;
        SQL.clear;
        SQL.Add(var_Sql);
        Open;
//        FetchAll;
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


procedure TPrm_1700.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPrm_1700.FormDestroy(Sender: TObject);
begin
  Prm_1700 := Nil;
end;

procedure TPrm_1700.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

end.


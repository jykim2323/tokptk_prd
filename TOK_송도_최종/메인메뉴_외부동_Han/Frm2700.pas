unit Frm2700;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, DBGrids, ExtCtrls, Buttons, StdCtrls, DB,
  DBTables, ADODB, QRCtrls, QuickRpt;

type
  TFrm_2700 = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Label13: TLabel;
    ExitBitBtn: TSpeedButton;
    DeleteBitBtn: TSpeedButton;
    Panel1: TPanel;
    StartBitBtn: TSpeedButton;
    DBGrid1: TDBGrid;
    DateTimePicker1: TDateTimePicker;
    Panel5: TPanel;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    Query2: TADOQuery;
    Query1mesg_dt: TStringField;
    Query1mesg_ehogi: TStringField;
    Query1mesg_eloca: TStringField;
    Query1mesg_desc: TStringField;
    ExlBtn: TSpeedButton;
    HogiCB: TComboBox;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    PrintBitBtn: TSpeedButton;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand4: TQRBand;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel9: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel1: TQRLabel;
    QRLbl_DateTime: TQRLabel;
    QRBand6: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText1: TQRDBText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);  
    procedure ExitBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DeleteBitBtnClick(Sender: TObject); 
    procedure FormDestroy(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
//    procedure ExlBtnClick(Sender: TObject);
    procedure HogiCBChange(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);

  private
     procedure MouseWheelHandler(var Message: TMessage); override;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_2700: TFrm_2700;
  s_date: string;
  s_hogi : string[1];
  s_desc: string[40];

  var_SelForm : TForm;
  var_Modal : Boolean;

implementation

Uses  WinLib, FrmPrompt, FrmError, FrmProgress, DBSet;
{$R *.DFM}

procedure TFrm_2700.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_2700.FormCreate(Sender: TObject);
begin
  if (jj_kind <> '50') then
  begin
    DeleteBitBtn.Visible    := False;   
  end;

  DateTimePicker1.Date := Now;   DateTimePicker2.Date := Now;
  HogiCB.ItemIndex := 0;   
  StartBitBtnClick(self);
end;

procedure TFrm_2700.StartBitBtnClick(Sender: TObject);
var
   ls_sql, f_date, t_date : String;
begin
  f_date := FormatDateTime('yyyymmdd', DateTimePicker1.Date);
  t_date := FormatDateTime('yyyymmdd', DateTimePicker2.Date);

  ls_sql :=  ' select * from t2timesg (nolock)  ';
  ls_sql := ls_sql + ' where Substring(mesg_dt,1,8) Between '''+f_date+''' And '''+t_date+''' ';
  if HogiCB.ItemIndex = 1  then   ls_sql := ls_sql + ' and mesg_ehogi = ''1''  '
  else  if HogiCB.ItemIndex = 2  then   ls_sql := ls_sql + ' and mesg_ehogi = ''2''  '
  else  if HogiCB.ItemIndex = 3  then   ls_sql := ls_sql + ' and mesg_ehogi = ''3''  ';

  ls_sql := ls_sql + '  order by mesg_dt Desc ';

  Query1.disableControls;
  Query1.Close;
  Query1.SQL.clear;
  Query1.SQL.Add (ls_sql);
  Query1.open;
  Query1.EnableControls;
end;

procedure TFrm_2700.HogiCBChange(Sender: TObject);
begin
  StartBitBtnClick(self);
end;

procedure TFrm_2700.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  s_date   := Query1.FieldByName('mesg_dt').AsString;
  s_hogi   := Query1.FieldByName('mesg_ehogi').AsString;
end;

procedure TFrm_2700.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin 
  var_Msg := '정말로 삭제 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add(' delete from t2timesg ');
      Query2.SQL.Add(' where mesg_dt = '''+s_date+''' and  mesg_ehogi =  '''+s_hogi+''' ');
      Query2.ExecSQL;
      StartBitBtnClick(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2700.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_2700.FormDestroy(Sender: TObject);
begin
   Frm_2700 := Nil;
end;

procedure TFrm_2700.DateTimePicker1Change(Sender: TObject);
begin
   StartBitBtnClick(self);
end;


procedure TFrm_2700.ExlBtnClick(Sender: TObject);
begin
  if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '에러이력 현황');
 end;  
end;

procedure TFrm_2700.PrintBitBtnClick(Sender: TObject);
begin
    if MessageDlg('인쇄 합니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_2700.MouseWheelHandler(var Message: TMessage);
var
 i: SmallInt;
begin
 // inherited;
 if Message.Msg = WM_MOUSEWHEEL then
 begin
   if ActiveControl is TDBGrid then
   begin
     Message.Msg := WM_KEYDOWN;
     Message.lParam := 0;
     i := HiWord(Message.wParam);
     if i > 0 then
       Message.wParam := VK_UP
     else
       Message.wParam := VK_DOWN;
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     (ActiveControl as TDBGrid).Refresh;
   end;
 end;
end;



end.

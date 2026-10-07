unit Frm3500;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, DB,
  DBTables, ADODB;

type
  TFrm_3500 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    DataSource1: TDataSource;
    Panel2: TPanel;
    StartBitBtn: TSpeedButton;
    InDateDTP: TDateTimePicker;
    Panel9: TPanel;
    DBGrid1: TDBGrid;
    UpdateBitBtn: TSpeedButton;
    DeleteBitBtn: TSpeedButton;
    ResvGBox: TGroupBox;
    Shape2: TShape;
    Label1: TLabel;
    ExecSb: TSpeedButton;
    ExitSP: TSpeedButton;
    Panel17: TPanel;
    BQtyEdit: TEdit;
    Panel4: TPanel;
    QtyEdit: TEdit;
    Panel5: TPanel;
    FLAGCB: TComboBox;
    Query1: TADOQuery;
    UpdtQuery: TADOQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    BCDField1: TBCDField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    Query1INSEND_JPNO: TStringField;
    Query1INSEND_ITEMNO: TStringField;
    Query1INSEND_ZGRGI: TStringField;
    Query1INSEND_DATE: TStringField;
    Query1INSEND_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1INSEND_AREA: TStringField;
    Query1INSEND_PGUBN: TStringField;
    Query1INSEND_QTY: TIntegerField;
    Query1INSEND_TIME: TStringField;
    Query1INSEND_LOCA: TStringField;
    Query1INSEND_FLAG: TStringField;
    RecNoEdit: TEdit;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure InDateDTPChange(Sender: TObject);  
    procedure UpdateBitBtnClick(Sender: TObject);
    procedure ExecSbClick(Sender: TObject);
    procedure ExitSPClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
   

  private
    { Private declarations }
   procedure MouseWheelHandler(var Message: TMessage);

  public
    { Public declarations }
  end;

var
  Frm_3500: TFrm_3500;

  ls_sql : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate : String;

   s_pltno, s_code, s_index, s_lotno, s_job, s_jpno, s_itemno, s_bqty, s_qty : String;
   li_BOXQTY, li_bqty, li_qty  : Real;

implementation

uses WinLib, FrmPrompt, FrmError;

{$R *.dfm} 


procedure TFrm_3500.FormCreate(Sender: TObject);
begin
  ResvGBox.Visible := False;

  InDateDTP.Date := Now;

  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;  

  
  StartBitBtnClick(Self);
end;


procedure TFrm_3500.StartBitBtnClick(Sender: TObject);
begin
  StrDate := FormatDateTime('yyyymmdd', InDateDTP.Date);

  ls_sql := '  Select  INSEND_JPNO, INSEND_ITEMNO, INSEND_ZGRGI, INSEND_DATE, INSEND_CODE, MAST_NAME,  ';
  ls_Sql := ls_Sql + ' INSEND_AREA, INSEND_PGUBN, INSEND_QTY, INSEND_TIME, INSEND_LOCA, INSEND_FLAG  ';
  ls_Sql := ls_Sql + ' From STK_INSEND (NOLOCK) ';
  ls_Sql := ls_Sql + ' LEFT OUTER JOIN STK_MIMAST (NOLOCK) ON MAST_CODE = INSEND_CODE ';
  ls_Sql := ls_Sql + ' Where  INSEND_JPNO <> '''' ';   
  ls_Sql := ls_Sql + '  And  INSEND_DATE = '''+StrDate+'''  ';
  ls_Sql := ls_Sql + ' Order By INSEND_JPNO, INSEND_ITEMNO ';     
  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
  end;

  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);
end;

procedure TFrm_3500.DataSource1DataChange(Sender: TObject; Field: TField);
begin
   s_jpno       := Query1.FieldByName('INSEND_JPNO').AsString;
   s_itemno     := Query1.FieldByName('INSEND_ITEMNO').AsString;
end;

procedure TFrm_3500.InDateDTPChange(Sender: TObject);
begin    
   StartBitBtnClick(Self);
end;

procedure TFrm_3500.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_3500.FormDestroy(Sender: TObject);
begin
  Frm_3500 := Nil;
end;

procedure TFrm_3500.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_3500.UpdateBitBtnClick(Sender: TObject);
var
   StrMsg : String;
begin
   If Length(s_bqty) = 0 Then Begin
    StrMsg := '변경할 데이타가 없습니다...'+#13#10+ ' 확인후 다시 시도 하십시요';
    WinLib_ErrorForm( StrMsg );  Exit;
    Exit;
  End;

  ResvGBox.Visible := True;

  if length(s_bqty) = 0  then  s_bqty := '0';

  BqtyEdit.Text      := s_bqty;
  QtyEdit.Text       := s_qty;

  li_BQty    := StrToInt(s_bqty);
  li_Qty     := StrToInt(s_qty);

  li_BOXQTY  :=  li_Qty  / li_Bqty;

  FlagCB.Text := s_job;

  BQtyEdit.SetFocus;
end;

procedure TFrm_3500.ExecSbClick(Sender: TObject);
var
   StrQry, ls_bqty, ls_qty, StrMsg : String;
begin
  StrMsg := ' 확정 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin  Exit;    End;
{
  if (BQtyEdit.Text = '') or (Length(BQtyEdit.Text) = 0) then
  Begin
    StrMsg := '박스를 입력하세요...!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  li_BQty   := StrToInt(BQtyEdit.Text);
  li_Qty    := li_boxqty *  li_BQty;

  ls_bqty := FloatTostr(li_BQty);
  ls_qty  := FloatTostr(li_Qty);

  StrQry := ' Update HHPROD Set PROD_BQTY      = To_Number('''+ls_BQty+'''),  ';
  StrQry := StrQry + '          PROD_QTY       = To_Number('''+ls_Qty+'''),  ';
  StrQry := StrQry + '          PROD_JOB_FLAG  = '''+FlagCB.TEXT+''' ';
  StrQry := StrQry + ' Where  PROD_PLTNO   = '''+s_pltno+''' ';
  StrQry := StrQry + ' And    PROD_INDEX   = '''+s_index+''' ';
  StrQry := StrQry + ' And    PROD_ITNBR   = '''+s_code+''' ';
  StrQry := StrQry + ' And    PROD_JPNO    = '''+s_jpno+''' ';
  StrQry := StrQry + ' And    PROD_CVCOD   = '''+s_cvcod+''' ';
  StrQry := StrQry + ' And    PROD_LOTNO   = '''+s_lotno+''' ';
  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSql;
    End;
  Except
    Showmessage(StrQry);
  End;

  ResvGBox.Visible := False;

  StartBitBtnClick(Self);
}  
end;

procedure TFrm_3500.ExitSPClick(Sender: TObject);
begin
   ResvGBox.Visible := False;
end;

procedure TFrm_3500.DeleteBitBtnClick(Sender: TObject);
var
  StrMsg, StrQry : String;                            
begin
  StrMsg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( StrMsg ) then
  begin
    StrQry := ' Delete  From  STK_INSEND  ';
    StrQry := StrQry + ' Where INSEND_JPNO     = '''+s_jpno+''' ';
    StrQry := StrQry + ' And   INSEND_ITEMNO   = '''+s_itemno+''' ';
    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('입고전송 ' + s_pltno + ' 삭제 에러!!!! ');
      Exit;
    End;
    StartBitBtnClick(Self);
  end;
end;

procedure TFrm_3500.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    Value : String;
    WW    : Integer;
begin
  If DataCol = 0 Then
  begin
   with(Sender as TDBGrid).Canvas do
   begin
    Value := IntToStr(Query1.RecNo);
    WW    := Canvas.TextWidth(value);
    TextOut(Rect.Left+(Rect.Right - Rect.Left - WW) div 2, Rect.Top+2,Value);
   end;
  end;
end;

procedure TFrm_3500.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_3500.DBGrid1TitleClick(Column: TColumn);
begin
  if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

end.

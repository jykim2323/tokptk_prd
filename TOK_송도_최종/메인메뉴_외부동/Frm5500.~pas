unit Frm5500;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask, ComCtrls;

type
  TFrm_5500 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    DataSource1: TDataSource;
    PrintBitBtn: TBitBtn;
    ExitBitBtn: TBitBtn;
    Query1: TADOQuery;
    UpdtQuery: TADOQuery;
    DBGrid1: TDBGrid;
    RecNoEdit: TEdit;
    ExlBtn: TBitBtn;
    Query1STOK1_ITEM: TStringField;
    Query1STOK1_PGUBN: TStringField;
    Query1STOK1_ERPQTY: TBCDField;
    Query1STOK1_AUTOQTY: TBCDField;
    Query1STOK1_CQTY: TBCDField;
    Query1MAST_NAME: TStringField;
    GroupBox1: TGroupBox;
    StartBitBtn: TBitBtn;
    Panel2: TPanel;
    ItemEdit: TEdit;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);  
    procedure StartBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure RackRGClick(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_5500: TFrm_5500;
  
  var_SelForm : TForm;
  var_Modal : Boolean;
  Var_ItemDiv : String;

implementation

uses Dbset, WinLib, FrmPrompt, FrmError;

{$R *.dfm}   

procedure TFrm_5500.FormCreate(Sender: TObject);
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;
  StartBitBtnClick(Self);
end;

procedure TFrm_5500.StartBitBtnClick(Sender: TObject);
var
  StrQry, StrCode : String;
  PltQty : Real;
begin
  StrCode := Trim(ItemEdit.Text);    


  StrQry :=  ' SELECT STOK1_ITEM, STOK1_PGUBN, MAX(MAST_NAME) AS MAST_NAME, ';
  StrQry := StrQry + ' SUM(STOK1_ERPQTY) AS STOK1_ERPQTY,   ';
  StrQry := StrQry + ' SUM(STOK1_AUTOQTY) AS STOK1_AUTOQTY,   ';
  StrQry := StrQry + ' SUM(STOK1_ERPQTY) - SUM(STOK1_AUTOQTY) AS STOK1_CQTY   ';
  StrQry := StrQry + ' FROM  STK1_STOK1 (NOLOCK)                   ';
  StrQry := StrQry + ' LEFT OUTER JOIN STK_MIMAST (NOLOCK) ON MAST_CODE = STOK1_ITEM ';   
  StrQry := StrQry + ' Where STOK1_ITEM  <> '''' ';
  if StrCode <> '' then   StrQry := StrQry + ' And  STOK1_ITEM  = '''+StrCode+''' ';
   StrQry := StrQry + ' GROUP BY STOK1_ITEM, STOK1_PGUBN ';
  StrQry := StrQry + ' Order By STOK1_ITEM, STOK1_PGUBN    ';

  with Query1 do Begin
    DisableControls;
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    First;
    EnableControls;
  End;
  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);
end;

procedure TFrm_5500.PrintBitBtnClick(Sender: TObject);
begin
{
  var_Modal   := False;
  var_SelForm := Nil;

  var_SelForm := TPrm_6700.Create(Application);
  var_Modal := True;

  if var_SelForm <> Nil then begin
    With TForm(var_SelForm) do begin
      if var_Modal then ShowModal
      Else begin
        BorderIcons := [];
        Show;
      End;
    end;
  end;
}
end;

procedure TFrm_5500.ExlBtnClick(Sender: TObject);
begin
  if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(Query1, 'ERP 재고현황');
 end;
end;

procedure TFrm_5500.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_5500.FormDestroy(Sender: TObject);
begin
  Frm_5500 := Nil;
end;

procedure TFrm_5500.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_5500.RackRGClick(Sender: TObject);
begin
   StartBitBtnClick(self);
end;

procedure TFrm_5500.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_5500.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    Value : String;
    WW, li_qty    : Integer;
begin
  li_qty :=  Query1.FieldByName('STOK1_CQTY').AsInteger;
  if  li_qty <> 0 then
  begin
   with(Sender as TDBGrid).Canvas do
    begin
      Brush.Color := clYellow;
      Font.Color  := clRed;
      Canvas.Font.Style := [fsBold];
      FillRect(Rect);
    end;
    DbGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
  
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

procedure TFrm_5500.DBGrid1TitleClick(Column: TColumn);
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

unit Frm9210;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask, ComCtrls, QRCtrls, QuickRpt;

type
  TFrm_9210 = class(TForm)
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
    GroupBox1: TGroupBox;
    StartBitBtn: TBitBtn;
    Panel2: TPanel;
    ItemEdit: TEdit;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText5: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel12: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel10: TQRLabel;
    Query1STOK1_LOCA: TStringField;
    Query1STOK1_ITEM: TStringField;
    Query1STOK1_PGUBN: TStringField;
    Query1MAST_NAME: TStringField;
    Query1STOK1_SQTY: TBCDField;
    Query1STOK1_AQTY: TBCDField;
    Query1STOK1_CQTY: TBCDField;
    SelRG: TRadioGroup;
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
  Frm_9210: TFrm_9210;
  
  var_SelForm : TForm;
  var_Modal : Boolean;
  Var_ItemDiv : String;

implementation

uses Dbset, WinLib, FrmPrompt, FrmError;

{$R *.dfm}   

procedure TFrm_9210.FormCreate(Sender: TObject);
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;
  StartBitBtnClick(Self);
end;

procedure TFrm_9210.StartBitBtnClick(Sender: TObject);
var
  StrQry, StrCode : String;
  PltQty : Real;    
begin
  StrCode := Trim(ItemEdit.Text);

  StrQry :=  ' SELECT  STOK1_LOCA, STOK1_ITEM, STOK1_PGUBN,  MAX(MAST_NAME) AS MAST_NAME, ';
  StrQry := StrQry + ' SUM(STOK1_SQTY) As STOK1_SQTY, SUM(STOK1_AQTY)As STOK1_AQTY,       ';
  StrQry := StrQry + ' SUM(STOK1_AQTY) - SUM(STOK1_SQTY) AS STOK1_CQTY            ';
  StrQry := StrQry + ' FROM  STK2_SILSA (NOLOCK)                        ';
  StrQry := StrQry + ' LEFT OUTER JOIN STK2_MIMAST (NOLOCK) ON MAST_CODE = STOK1_ITEM ';
  StrQry := StrQry + ' Where STOK1_ITEM  <> '''' ';

  if StrCode <> '' then   StrQry := StrQry + ' And  STOK1_ITEM  = '''+StrCode+''' ';

  StrQry := StrQry + ' GROUP BY STOK1_LOCA, STOK1_ITEM, STOK1_PGUBN ';
  StrQry := StrQry + '  Order By STOK1_LOCA, STOK1_ITEM, STOK1_PGUBN    ';

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

procedure TFrm_9210.PrintBitBtnClick(Sender: TObject);
begin
if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_9210.ExlBtnClick(Sender: TObject);
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

procedure TFrm_9210.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_9210.FormDestroy(Sender: TObject);
begin
  Frm_9210 := Nil;
end;

procedure TFrm_9210.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_9210.RackRGClick(Sender: TObject);
begin
   StartBitBtnClick(self);
end;

procedure TFrm_9210.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_9210.DBGrid1DrawColumnCell(Sender: TObject;
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

procedure TFrm_9210.DBGrid1TitleClick(Column: TColumn);
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

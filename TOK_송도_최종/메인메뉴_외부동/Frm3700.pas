unit Frm3700;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, DB,
  DBTables, ADODB, QRCtrls, QuickRpt;

type
  TFrm_3700 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    Panel2: TPanel;
    StartBitBtn: TSpeedButton;
    TitlePl: TPanel;
    ExlBtn: TSpeedButton;
    DBGrid1: TDBGrid;
    Panel6: TPanel;
    Panel3: TPanel;
    DBGrid2: TDBGrid;
    ItemCB: TEdit;
    Panel4: TPanel;
    FromDate: TDateTimePicker;
    Label1: TLabel;
    ToDate: TDateTimePicker;
    Label2: TLabel;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    DataSource2: TDataSource;
    Query2: TADOQuery;
    UpdtQuery: TADOQuery;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText5: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText3: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel9: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    Query1STK_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query2STK_CODE: TStringField;
    Query2MAST_NAME: TStringField;
    Query2STK_LOTNO: TStringField;
    Query1STK_TQTY: TBCDField;
    Query2STK_TQTY: TBCDField;
    PrintBitBtn: TSpeedButton;
    QRLabel1: TQRLabel;
    QRLbl_FDate: TQRLabel;
    QRLbl_TDate: TQRLabel;
    QRLabel6: TQRLabel;
    Panel5: TPanel;
    itemNmEdit: TEdit;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure InDateDTPChange(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char);
    procedure itemNmEditKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    procedure  LotNo_Select_Proc;
    procedure MouseWheelHandler(var Message: TMessage); override;

  public
    { Public declarations }
  end;

var
  Frm_3700: TFrm_3700;

  var_Sql : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate : String;
  StrDate1, StrDate2, s_code : String;

implementation

uses DbSet;

{$R *.dfm} 


procedure TFrm_3700.FormCreate(Sender: TObject);
begin

  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  FromDate.Date := Now;   ToDate.Date := Now;

  StartBitBtnClick(Self);
end;

procedure TFrm_3700.StartBitBtnClick(Sender: TObject);
begin
  StrDate1 := FormatDateTime('yyyymmdd', FromDate.Date);
  StrDate2 := FormatDateTime('yyyymmdd', ToDate.Date);

  var_Sql := ' SELECT STK_CODE,  ';
  var_Sql := var_Sql + ' SUM(STK_TQTY) STK_TQTY,  MAX(MAST_NAME) MAST_NAME  ';
  var_Sql := var_Sql + ' FROM T2INPT_VIEW (NOLOCK) ';
  var_Sql := var_Sql + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON STK_CODE   = MAST_CODE    ';
  var_Sql := var_Sql + ' WHERE  ISNULL(STK_DATE, '''') <> '''' And STK_CODE <> ''EMPTY''         ';

  // 품목코드
  if Length(Trim(ItemCb.Text)) > 0 then
     //var_Sql := var_Sql + ' And STK_CODE LIKE ''%' + Trim(ItemCb.Text) + '%'' ';
     var_Sql := var_Sql + ' AND STK_CODE = ''' + Trim(ItemCb.Text) + ''' ';

  // 품목명
  if Length(Trim(ItemNmEdit.Text)) > 0 then
     var_Sql := var_Sql + ' AND MAST_NAME LIKE ''%' + Trim(ItemNmEdit.Text) + '%'' ';

  var_Sql := var_Sql + ' AND STK_DATE >= '''+StrDate1+'''  And STK_DATE <= '''+StrDate2+''' ';
  var_Sql := var_Sql + '  GROUP By STK_CODE        ';
  var_Sql := var_Sql + '  Order By STK_CODE        ';

  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
  end;
end;

procedure TFrm_3700.LotNo_Select_Proc;
begin
  var_Sql := ' SELECT   STK_CODE, STK_LOTNO,   ';
  var_Sql := var_Sql + ' SUM(STK_TQTY) STK_TQTY, MAX(MAST_NAME) MAST_NAME  ';
  var_Sql := var_Sql + ' FROM T2INPT_VIEW (NOLOCK) ';
  var_Sql := var_Sql + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON STK_CODE   = MAST_CODE   ';
  var_Sql := var_Sql + ' WHERE  ISNULL(STK_DATE, '''') <> ''''         ';
  var_Sql := var_Sql + ' And  STK_CODE  = '''+s_code+'''   ';
  var_Sql := var_Sql + ' AND STK_DATE >= '''+StrDate1+'''  And STK_DATE <= '''+StrDate2+''' ';
  var_Sql := var_Sql + '  GROUP By STK_CODE, STK_LOTNO       ';
  var_Sql := var_Sql + '  Order By STK_CODE, STK_LOTNO       ';

   with Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    First;
  end;
end;

procedure TFrm_3700.DataSource1DataChange(Sender: TObject; Field: TField);
begin          
    s_code    := Query1.FieldByName('STK_CODE').AsString;
    LotNo_Select_Proc;
end;

procedure TFrm_3700.InDateDTPChange(Sender: TObject);
begin
   StartBitBtnClick(Self);
end;

procedure TFrm_3700.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_FDate.Caption := FormatDateTime('yyyy-mm-dd', FromDate.Date);
      QRLbl_TDate.Caption := FormatDateTime('yyyy-mm-dd', ToDate.Date);
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_3700.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_3700.FormDestroy(Sender: TObject);
begin
  Frm_3700 := Nil;
end;

procedure TFrm_3700.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;  


procedure TFrm_3700.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '입고 실적 현황');
 end;
end;

procedure TFrm_3700.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_3700.DBGrid1TitleClick(Column: TColumn);
begin
    if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_3700.DBGrid2TitleClick(Column: TColumn);
begin
    if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_3700.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

procedure TFrm_3700.itemNmEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

end.

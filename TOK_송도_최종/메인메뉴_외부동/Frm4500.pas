unit Frm4500;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, DB,
  DBTables, ADODB, QRCtrls, QuickRpt;

type
  TFrm_4500 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    Panel2: TPanel;
    StartBitBtn: TSpeedButton;
    TitlePl: TPanel;
    Panel9: TPanel;
    ExlBtn: TSpeedButton;
    FromDate: TDateTimePicker;
    Label1: TLabel;
    ToDate: TDateTimePicker;
    Label2: TLabel;
    ItemCB: TEdit;
    Panel3: TPanel;
    Panel6: TPanel;
    DataSource2: TDataSource;
    Query2: TADOQuery;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Query2MAST_NAME: TStringField;
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
    Query1STK_TQTY: TBCDField;
    Query2STK_CODE: TStringField;
    Query2STK_LOTNO: TStringField;
    Query2STK_TQTY: TBCDField;
    PrintBitBtn: TSpeedButton;
    QRLabel1: TQRLabel;
    QRLbl_FDate: TQRLabel;
    QRLabel6: TQRLabel;
    QRLbl_TDate: TQRLabel;
    Panel4: TPanel;
    ItemNm: TEdit;
    Panel5: TPanel;
    DBGrid3: TDBGrid;
    DataSource3: TDataSource;
    Query3: TADOQuery;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure LotNo_Select_Proc;
    procedure Cust_Select_Proc;
    procedure ExlBtnClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char);
    procedure ItemNmKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
     procedure MouseWheelHandler(var Message: TMessage); override;
  public
    { Public declarations }
  end;

var
  Frm_4500: TFrm_4500;

  var_Sql : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate : String;
  StrDate1, StrDate2, s_code : String;
  s_floor : String;

implementation

uses DbSet;

{$R *.dfm} 


procedure TFrm_4500.FormCreate(Sender: TObject);
begin
  FromDate.Date := Now;   ToDate.Date := Now;

  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  Titlepl.Caption := '품목코드';
  StartBitBtnClick(Self);
end;

procedure TFrm_4500.StartBitBtnClick(Sender: TObject);
begin
  StrDate1 := FormatDateTime('yyyymmdd', FromDate.Date);
  StrDate2 := FormatDateTime('yyyymmdd', ToDate.Date);

  var_Sql := ' SELECT STK_CODE,   ';
  var_Sql := var_Sql + ' SUM(STK_TQTY) STK_TQTY,  MAX(MAST_NAME) MAST_NAME  ';
  var_Sql := var_Sql + ' FROM T2OUPT_VIEW (NOLOCK) ';
  var_Sql := var_Sql + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON STK_CODE   = MAST_CODE   ';
  var_Sql := var_Sql + ' WHERE  ISNULL(STK_DATE, '''') <> ''''   And STK_CODE <> ''EMPTY''      ';

  if Length(Trim(ItemCb.Text)) > 0 then
     //var_Sql := var_Sql + ' And STK_CODE  LIKE ''%'+itemCB.Text+'%''   ';
     var_Sql := var_Sql + ' AND STK_CODE = ''' + Trim(ItemCb.Text) + ''' '; // 고객사 요청 

  if Length(Trim(ItemNm.Text)) > 0 then
     var_Sql := var_Sql + ' AND MAST_NAME LIKE ''%' + Trim(ItemNm.Text) + '%'' ';

  var_Sql := var_Sql + ' AND STK_DATE >= '''+StrDate1+'''  And STK_DATE <= '''+StrDate2+''' ';
  var_Sql := var_Sql + '  GROUP By STK_CODE       ';
  var_Sql := var_Sql + '  Order By STK_CODE       ';
  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
  end;
end;

procedure TFrm_4500.LotNo_Select_Proc;
begin
   var_Sql := ' SELECT  STK_CODE, STK_LOTNO,   ';
  var_Sql := var_Sql + ' SUM(STK_TQTY) STK_TQTY, MAX(MAST_NAME) MAST_NAME  ';
  var_Sql := var_Sql + ' FROM T2OUPT_VIEW (NOLOCK) ';
  var_Sql := var_Sql + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON STK_CODE   = MAST_CODE   ';
  var_Sql := var_Sql + ' WHERE  ISNULL(STK_DATE, '''') <> ''''         ';
  var_Sql := var_Sql + ' And  STK_CODE  =  '''+s_code+'''   ';
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

procedure TFrm_4500.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    s_code    := Query1.FieldByName('STK_CODE').AsString;
    LotNo_Select_Proc;
    //Cust_Select_Proc; // 거래처별
end;

procedure TFrm_4500.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '출고 실적 현황');
 end;
end;

procedure TFrm_4500.PrintBitBtnClick(Sender: TObject);
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

procedure TFrm_4500.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_4500.FormDestroy(Sender: TObject);
begin
  Frm_4500 := Nil;
end;

procedure TFrm_4500.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_4500.MouseWheelHandler(var Message: TMessage);
var
 i: SmallInt;
begin
 // inherited
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

procedure TFrm_4500.Cust_Select_Proc;
begin
  // DBGrid3용 쿼리: 품목코드, 품목명, 납품처명, 중량합계
  var_Sql := ' SELECT OUPT_CODE, ';
  var_Sql := var_Sql + ' MAX(M.MAST_NAME) AS MAST_NAME, '; // 품목명 (MIMAST 조인)
  var_Sql := var_Sql + ' MAX(OUPT_CUST) AS CUST_NAME, '; // 납품처명 (MICUST 조인)
  var_Sql := var_Sql + ' SUM(OUPT_OUT_WGT) AS STK_TQTY ';  // 중량 합계

  var_Sql := var_Sql + ' FROM T2MIOUPT (NOLOCK) ';

  // 품목명 가져오기 위한 조인
  var_Sql := var_Sql + ' LEFT OUTER JOIN MIMAST M (NOLOCK) ON OUPT_CODE = M.MAST_CODE ';

  var_Sql := var_Sql + ' WHERE ISNULL(OUPT_CODE, '''') <> '''' ';
  var_Sql := var_Sql + ' AND OUPT_CODE = ''' + s_code + ''' '; // 선택된 품목코드

  // 기간 조건
  var_Sql := var_Sql + ' AND OUPT_DATE >= ''' + StrDate1 + ''' AND OUPT_DATE <= ''' + StrDate2 + ''' ';
  var_Sql := var_Sql + ' AND OUPT_JOB_FLAG <> ''0'' ';

  // 거래처 코드별로 그룹핑 (이름은 MAX로 가져옴)
  var_Sql := var_Sql + ' GROUP BY OUPT_CODE, OUPT_CUST ';
  var_Sql := var_Sql + ' ORDER BY CUST_NAME '; // 납품처명 순 정렬

  with Query3 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;

    (FieldByName('STK_TQTY') as TNumericField).DisplayFormat := '###,##0.00';
    
    First;
  end;
end;

procedure TFrm_4500.DBGrid1TitleClick(Column: TColumn);
begin
    if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_4500.DBGrid2TitleClick(Column: TColumn);
begin
    if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_4500.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

procedure TFrm_4500.ItemNmKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

end.

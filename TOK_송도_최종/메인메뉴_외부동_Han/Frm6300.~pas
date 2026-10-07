unit Frm6300;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask, QRCtrls, QuickRpt;

type
  TFrm_6300 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    DataSource1: TDataSource;
    StartBitBtn: TBitBtn;
    UpdtQuery: TADOQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    ItemCB: TEdit;
    Panel6: TPanel;
    Panel2: TPanel;
    DataSource2: TDataSource;
    Query2: TADOQuery;
    Query1: TADOQuery;
    Panel3: TPanel;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText6: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText8: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel3: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel7: TQRLabel;
    Query1STK_CODE: TStringField;
    Query1STK_TQTY: TBCDField;
    Query1MAST_NAME: TStringField;
    Query2STK_CODE: TStringField;
    Query2STK_LOTNO: TStringField;
    Query2STK_TQTY: TBCDField;
    Query2MAST_NAME: TStringField;
    SB_Search: TSpeedButton;
    PrintBitBtn: TSpeedButton;
    ExlBtn: TSpeedButton;
    Gubn1Cb: TComboBox;
    Gubn2Cb: TComboBox;
    Gubn3Cb: TComboBox;
    Query3: TADOQuery;
    Query1GUBN1_NAME: TStringField;
    Query1GUBN2_NAME: TStringField;
    Query1GUBN3_NAME: TStringField;
    Label14: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ExitBitBtn: TSpeedButton;
    QRLabel1: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    Panel4: TPanel;
    StockEd: TPanel;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);  
    procedure StartBitBtnClick(Sender: TObject);  
    procedure ItemCBChange(Sender: TObject);   
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char); 
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure LotNo_Select_Proc;
    procedure ExlBtnClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SB_SearchClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_6300: TFrm_6300;
  
  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;

  Var_ItemDiv : String;

  s_code, s_cvcod, s_loca,  s_lotno, s_jpno, s_qty, s_bqty, s_date,  s_time, s_gubun : String;
  s_pltno, s_flag, s_depot, s_rqty, s_awh : String;
  li_BOXQTY, li_bqty, li_qty  : Real;

implementation

uses DBSet, WinLib, FrmPrompt, FrmError, MastDisp;

{$R *.dfm}


procedure TFrm_6300.FormCreate(Sender: TObject);
var
  ls_sql, StrCode, ls_gubn, ls_name : String;
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  Gubn1CB.Clear;
  Gubn1CB.Items.Add('');
  ls_sql := ' Select GUBN1_CODE, GUBN1_NAME  From MIGUBN1 (NOLOCK) ';
  ls_sql := ls_sql + ' Order by  GUBN1_CODE ';
  With Query3 do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    While Not Eof do   begin
       ls_gubn := FieldByName('GUBN1_CODE').AsString;
       ls_name := FieldByName('GUBN1_NAME').AsString;
       Gubn1CB.Items.Add(ls_gubn + '-' +  ls_name);
       Next;
    end;
  End;

  Gubn1CB.ItemIndex := -1;

  Gubn2CB.Clear;
  Gubn2CB.Items.Add('');
  ls_sql := ' Select GUBN2_CODE, GUBN2_NAME  From MIGUBN2 (NOLOCK) ';
  ls_sql := ls_sql + ' Order by  GUBN2_CODE ';
  With Query3 do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    While Not Eof do   begin
       ls_gubn := FieldByName('GUBN2_CODE').AsString;
       ls_name := FieldByName('GUBN2_NAME').AsString;
       Gubn2CB.Items.Add(ls_gubn + '-' +  ls_name);
       Next;
    end;
  End;
  Gubn2CB.ItemIndex := -1;

  Gubn3CB.Clear;
  Gubn3CB.Items.Add('');
  ls_sql := ' Select GUBN3_CODE, GUBN3_NAME  From MIGUBN3 (NOLOCK) ';
  ls_sql := ls_sql + ' Order by  GUBN3_CODE ';
  With Query3 do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    While Not Eof do   begin
       ls_gubn := FieldByName('GUBN3_CODE').AsString;
       ls_name := FieldByName('GUBN3_NAME').AsString;
       Gubn3CB.Items.Add(ls_gubn + '-' +  ls_name);
       Next;
    end;
  End;
  Gubn3CB.ItemIndex := -1;

  StartBitBtnClick(self);
end;

procedure TFrm_6300.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
   if key <> #13 then Exit;
   StartBitBtnClick(self);
end;

procedure TFrm_6300.StartBitBtnClick(Sender: TObject);
var
   ls_gubn1,  ls_gubn2,  ls_gubn3 : String;
   li_qty : Real;
begin
  ls_gubn1 :=  Trim(Copy(Gubn1Cb.Text,1,1));
  ls_gubn2 :=  Trim(Copy(Gubn2Cb.Text,1,1));
  ls_gubn3 :=  Trim(Copy(Gubn3Cb.Text,1,1));  
  li_qty   := 0;
  
  with Query1 do Begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT STK_CODE,  ');
    SQL.Add(' SUM(STK_TQTY) STK_TQTY,  MAX(MAST_NAME) MAST_NAME, ');
    SQL.Add(' MAX(GUBN1_NAME) GUBN1_NAME,  MAX(GUBN2_NAME) GUBN2_NAME, ');
    SQL.Add(' MAX(GUBN3_NAME) GUBN3_NAME ');
    SQL.Add(' FROM T2SUBK_VIEW (NOLOCK)   ');
    SQL.Add(' LEFT OUTER JOIN MIMAST (NOLOCK) ON STK_CODE   = MAST_CODE     ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1    ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2   ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3  ');
    SQL.Add(' WHERE  ISNULL(STK_CODE, '''') <> ''''         ');
    if  Length(Trim(ItemCb.Text)) > 0   then   SQL.Add(' And  STK_CODE  LIKE '''+itemCB.Text+'%''   ');

    if  (ls_gubn1 <> '') then  SQL.Add(' And  MAST_GUBN1 = '''+ls_gubn1+'''   ');
    if  (ls_gubn2 <> '') then  SQL.Add(' And  MAST_GUBN2 = '''+ls_gubn2+'''   ');
    if  (ls_gubn3 <> '') then  SQL.Add(' And  MAST_GUBN3 = '''+ls_gubn3+'''   ');


    SQL.Add('  GROUP By STK_CODE       ');
    SQL.Add('  Order By STK_CODE       ');
    Open;
    First;
  End;

  with Query3 do Begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT  SUM(STK_TQTY) STK_TQTY ');
    SQL.Add(' FROM T2SUBK_VIEW (NOLOCK)   ');
    SQL.Add(' LEFT OUTER JOIN MIMAST (NOLOCK) ON STK_CODE   = MAST_CODE     ');
    SQL.Add(' LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1    ');
    SQL.Add(' LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2   ');
    SQL.Add(' LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3  ');
    SQL.Add(' WHERE  ISNULL(STK_CODE, '''') <> ''''         ');
    if  Length(Trim(ItemCb.Text)) > 0   then   SQL.Add(' And  STK_CODE  LIKE '''+itemCB.Text+'%''   ');

    if  (ls_gubn1 <> '') then  SQL.Add(' And  MAST_GUBN1 = '''+ls_gubn1+'''   ');
    if  (ls_gubn2 <> '') then  SQL.Add(' And  MAST_GUBN2 = '''+ls_gubn2+'''   ');
    if  (ls_gubn3 <> '') then  SQL.Add(' And  MAST_GUBN3 = '''+ls_gubn3+'''   ');

    Open;
    li_qty := FieldByName('STK_TQTY').AsFloat;
  End;
  StockEd.caption := FormatFloat('###,##0.00', li_qty);
end;

procedure TFrm_6300.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_6300.DBGrid2TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;


procedure TFrm_6300.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//
end;

procedure TFrm_6300.DBGrid2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//
end;

procedure TFrm_6300.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
   DM1.GridToExel(query1, '재고 집계자료 현황');
 end;
end;


procedure TFrm_6300.ItemCBChange(Sender: TObject);
begin
   StartBitBtnClick(self);
end;

procedure TFrm_6300.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    s_code    := Query1.FieldByName('STK_CODE').AsString;
    LotNo_Select_Proc;
end;

procedure TFrm_6300.LotNo_Select_Proc;
begin
   with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT STK_CODE, STK_LOTNO, ');
    SQL.Add(' SUM(STK_TQTY) STK_TQTY,  MAX(MAST_NAME) MAST_NAME ');
    SQL.Add(' FROM T2SUBK_VIEW (NOLOCK)   ');
    SQL.Add(' LEFT OUTER JOIN MIMAST (NOLOCK) ON STK_CODE   = MAST_CODE     ');
    SQL.Add(' WHERE  ISNULL(STK_CODE, '''') <> ''''         ');
    SQL.Add(' And  STK_CODE  = '''+s_code+'''   ');
    SQL.Add('  GROUP By STK_CODE, STK_LOTNO       ');
    SQL.Add('  Order By STK_CODE , STK_LOTNO      ');
    Open;
    First;
  End;
end;



procedure TFrm_6300.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_6300.FormDestroy(Sender: TObject);
begin
  Frm_6300 := Nil;
end;

procedure TFrm_6300.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;  

procedure TFrm_6300.SB_SearchClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  Mast_Disp  := TMast_Disp.Create(Application);
  Bol_Modal := True;

  Mast_Disp.Edt_Search.Text := ItemCB.Text;
  If Mast_Disp <> Nil Then
    With TForm(Mast_Disp) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      Mast_Disp.Free;
    End;

    ItemCB.Text :=  jj_code;
end;

procedure TFrm_6300.PrintBitBtnClick(Sender: TObject);
begin
 if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

end.

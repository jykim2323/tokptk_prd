unit Frm1100;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask, QRCtrls, QuickRpt;

type
  TFrm_1100 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    InsertBitBtn: TSpeedButton;
    UpdateBitBtn: TSpeedButton;
    DeleteBitBtn: TSpeedButton;
    ExitBitBtn: TSpeedButton;
    GroupBox1: TGroupBox;
    StartBitBtn: TSpeedButton;
    Titlepl: TPanel;
    itemEdit: TEdit;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    Query2: TADOQuery;
    ExlBtn: TSpeedButton;
    RecNoEdit: TEdit;
    PrintBitBtn: TSpeedButton;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText5: TQRDBText;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    PageHeaderBand1: TQRBand;
    QRLbl_DateTime: TQRLabel;
    Query1MAST_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1MAST_UNIT: TStringField;
    Query1MAST_WEIGHT: TBCDField;
    Query1MAST_DATE: TDateTimeField;
    Query1MAST_GUBN1: TStringField;
    Query1MAST_GUBN2: TStringField;
    Query1MAST_GUBN3: TStringField;
    Query1GUBN1_NAME: TStringField;
    Query1GUBN2_NAME: TStringField;
    Query1GUBN3_NAME: TStringField;
    Query1MAST_BCODE: TStringField;
    QRDBText2: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRLabel2: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    Query1MAST_REF1: TStringField;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure InsertBitBtnClick(Sender: TObject);  
    procedure DBGrid1CellClick(Column: TColumn);
    procedure UpdateBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);  
    procedure ExlBtnClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure PrintBitBtnClick(Sender: TObject);


  private

    { Private declarations }
  
  public
    { Public declarations }
  end;

var
  Frm_1100: TFrm_1100;

  StrCode : String;
  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;

  s_wcode, s_code,s_name,s_remark, s_zflag, s_zstate :String;
  wr_cnt, li_RecNo : Integer;

implementation

uses DBSet, WinLib, FrmPrompt, FrmError, SFrm1100, FrmProgress;


{$R *.dfm}


procedure TFrm_1100.FormCreate(Sender: TObject);  
begin

  itemEdit.Text := '0';
  
  if (jj_kind <> '50') then
  begin
    InsertBitBtn.Visible := False;
    UpdateBitBtn.Visible := False;
    DeleteBitBtn.Visible := False;
  end;    
  
  StartBitBtnClick(Self);
end;

procedure TFrm_1100.StartBitBtnClick(Sender: TObject);
var
  ls_sql : String;
begin
  StrCode := ItemEdit.Text;

  ls_sql := ' Select MAST_CODE, MAST_BCODE,MAST_NAME, MAST_UNIT, MAST_WEIGHT, MAST_GUBN1,  GUBN1_NAME, ';
  ls_sql := ls_sql + ' MAST_GUBN2, GUBN2_NAME, MAST_GUBN3, GUBN3_NAME, MAST_DATE, MAST_REF1 From MIMAST ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1   ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2   ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3   ';
  ls_sql := ls_sql + ' Where MAST_CODE >= '''+StrCode+'''  ';
  ls_sql := ls_sql + ' Order By  MAST_CODE  ';

  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(ls_sql);
//  Query1.MaxRecords := 30;
  Query1.Open;
  Query1.First;     

  ItemEdit.Text  := Query1.FieldByName('MAST_CODE').AsString;
  RecNoEdit.Text := Format('%d',[Query1.RecordCount]); 
end;

procedure TFrm_1100.InsertBitBtnClick(Sender: TObject);
var
  ls_sql, ls_gubn, ls_code,ls_name : String;
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  SFrm_1100  := TSFrm_1100.Create(Application);
  Bol_Modal := True;

  SFrm_1100.Bol_Insert := True;
  SFrm_1100.Bol_Update := False;
  SFrm_1100.Bol_Delete := False;
  SFrm_1100.TitleLbl.Caption := '품목 코드 등록';


   SFrm_1100.Gubn1CB.Items.Clear;
  SFrm_1100.Gubn1CB.Items.Add('');

  ls_sql := ' Select * From MIGUBN1 (NOLOCK) Order By GUBN1_CODE';

  With Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    While Not Eof Do Begin
      ls_code :=  FieldByNAme('GUBN1_CODE').AsString;
      ls_name :=  FieldByNAme('GUBN1_NAME').AsString;

      ls_gubn := ls_code + '-' + ls_name;
      SFrm_1100.Gubn1CB.Items.Add(ls_gubn);
      Next;
    End;
  End;

  SFrm_1100.Gubn1CB.ItemIndex := 0;
////////////////////////////////////////////
  SFrm_1100.Gubn2CB.Items.Clear;
  SFrm_1100.Gubn2CB.Items.Add('');

  ls_sql := ' Select * From MIGUBN2 (NOLOCK) Order By GUBN2_CODE';

  With Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    While Not Eof Do Begin
      ls_code :=  FieldByNAme('GUBN2_CODE').AsString;
      ls_name :=  FieldByNAme('GUBN2_NAME').AsString;

      ls_gubn := ls_code + '-' + ls_name;
      SFrm_1100.Gubn2CB.Items.Add(ls_gubn);
      Next;
    End;
  End;

  SFrm_1100.Gubn2CB.ItemIndex := 0;
/////////////////////////////////////////
  SFrm_1100.Gubn3CB.Items.Clear;
  SFrm_1100.Gubn3CB.Items.Add('');

  ls_sql := ' Select * From MIGUBN3 (NOLOCK) Order By GUBN3_CODE';

  With Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    While Not Eof Do Begin
      ls_code :=  FieldByNAme('GUBN3_CODE').AsString;
      ls_name :=  FieldByNAme('GUBN3_NAME').AsString;

      ls_gubn := ls_code + '-' + ls_name;
      SFrm_1100.Gubn3CB.Items.Add(ls_gubn);
      Next;
    End;
  End;

  SFrm_1100.Gubn3CB.ItemIndex := 0;

  If SFrm_1100 <> Nil Then
    With TForm(SFrm_1100) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      SFrm_1100.Free;
    End;
    StartBitBtnClick(Self);
end;


procedure TFrm_1100.DBGrid1CellClick(Column: TColumn);
begin
//  ItemEdit.Text  := Query1.FieldByName('MAST_CODE').AsString;
end;

procedure TFrm_1100.UpdateBitBtnClick(Sender: TObject);
var
  strCode, ls_sql, ls_gubn, ls_code, ls_name : String;
begin

  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  SFrm_1100  := TSFrm_1100.Create(Application);
  Bol_Modal := True;

  SFrm_1100.Bol_Insert := False;
  SFrm_1100.Bol_Update := True;
  SFrm_1100.Bol_Delete := False;
  SFrm_1100.TitleLbl.Caption := '품목 코드 코드 수정';

   SFrm_1100.Gubn1CB.Items.Clear;
  SFrm_1100.Gubn1CB.Items.Add('');

  ls_sql := ' Select * From MIGUBN1 (NOLOCK) Order By GUBN1_CODE';

  With Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    While Not Eof Do Begin
      ls_code :=  FieldByNAme('GUBN1_CODE').AsString;
      ls_name :=  FieldByNAme('GUBN1_NAME').AsString;

      ls_gubn := ls_code + '-' + ls_name;
      SFrm_1100.Gubn1CB.Items.Add(ls_gubn);
      Next;
    End;
  End;

  SFrm_1100.Gubn1CB.ItemIndex := 0;
////////////////////////////////////////////
  SFrm_1100.Gubn2CB.Items.Clear;
  SFrm_1100.Gubn2CB.Items.Add('');

  ls_sql := ' Select * From MIGUBN2 (NOLOCK) Order By GUBN2_CODE';

  With Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    While Not Eof Do Begin
      ls_code :=  FieldByNAme('GUBN2_CODE').AsString;
      ls_name :=  FieldByNAme('GUBN2_NAME').AsString;

      ls_gubn := ls_code + '-' + ls_name;
      SFrm_1100.Gubn2CB.Items.Add(ls_gubn);
      Next;
    End;
  End;

  SFrm_1100.Gubn2CB.ItemIndex := 0;
/////////////////////////////////////////
  SFrm_1100.Gubn3CB.Items.Clear;
  SFrm_1100.Gubn3CB.Items.Add('');

  ls_sql := ' Select * From MIGUBN3 (NOLOCK) Order By GUBN3_CODE';

  With Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    While Not Eof Do Begin
      ls_code :=  FieldByNAme('GUBN3_CODE').AsString;
      ls_name :=  FieldByNAme('GUBN3_NAME').AsString;

      ls_gubn := ls_code + '-' + ls_name;
      SFrm_1100.Gubn3CB.Items.Add(ls_gubn);
      Next;
    End;
  End;

  SFrm_1100.Gubn3CB.ItemIndex := 0;

  SFrm_1100.codeEd.Enabled := False;

  SFrm_1100.CodeEd.Text   := Trim(Query1.FieldByName('MAST_CODE').AsString);
  SFrm_1100.BCodeEd.Text  := Trim(Query1.FieldByName('MAST_BCODE').AsString);
  SFrm_1100.NameEd.Text   := Trim(Query1.FieldByName('MAST_NAME').AsString);
  SFrm_1100.UnitCB.Text   := Trim(Query1.FieldByName('MAST_UNIT').AsString);
  SFrm_1100.WeightEd.Text := Trim(Query1.FieldByName('MAST_WEIGHT').AsString);
  SFrm_1100.WeightEd.Text := Trim(Query1.FieldByName('MAST_WEIGHT').AsString);
  SFrm_1100.Ref1Ed.Text   := Trim(Query1.FieldByName('MAST_REF1').AsString);
  ls_code :=  Trim(Query1.FieldByName('MAST_GUBN1').AsString);
  ls_name :=  Trim(Query1.FieldByName('GUBN1_NAME').AsString);

  if (ls_code <> '') then   ls_gubn := ls_code + '-' + ls_name else   ls_gubn := '';
  SFrm_1100.Gubn1Cb.Text   :=   ls_gubn;


  ls_code :=  Trim(Query1.FieldByName('MAST_GUBN2').AsString);
  ls_name :=  Trim(Query1.FieldByName('GUBN2_NAME').AsString);

  if (ls_code <> '') then   ls_gubn := ls_code + '-' + ls_name else   ls_gubn := '';
  SFrm_1100.Gubn2Cb.Text   :=   ls_gubn;


  ls_code :=  Trim(Query1.FieldByName('MAST_GUBN3').AsString);
  ls_name :=  Trim(Query1.FieldByName('GUBN3_NAME').AsString);

  if (ls_code <> '') then   ls_gubn := ls_code + '-' + ls_name else   ls_gubn := '';
  SFrm_1100.Gubn3Cb.Text   :=   ls_gubn;


   If SFrm_1100 <> Nil Then
    With TForm(SFrm_1100) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      SFrm_1100.Free;
    End;
    StartBitBtnClick(Self);
end;

procedure TFrm_1100.DeleteBitBtnClick(Sender: TObject);
var
  strcode, ls_gubn, ls_code, ls_name : String;
begin

  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  SFrm_1100  := TSFrm_1100.Create(Application);
  Bol_Modal := True;

  SFrm_1100.Bol_Insert := False;
  SFrm_1100.Bol_Update := False;
  SFrm_1100.Bol_Delete := True;
  SFrm_1100.TitleLbl.Caption := '품목 코드 삭제';

  SFrm_1100.codeEd.Enabled    := False;
  SFrm_1100.bcodeEd.Enabled    := False;
  SFrm_1100.NameEd.Enabled    := False;
  SFrm_1100.UnitCb.Enabled    := False;
  SFrm_1100.WeightEd.Enabled  := False;
  SFrm_1100.Gubn1Cb.Enabled  := False;
  SFrm_1100.Gubn2Cb.Enabled  := False;
  SFrm_1100.Gubn3Cb.Enabled  := False;

  SFrm_1100.CodeEd.Text   := Trim(Query1.FieldByName('MAST_CODE').AsString);
  SFrm_1100.BCodeEd.Text  := Trim(Query1.FieldByName('MAST_BCODE').AsString);
  SFrm_1100.NameEd.Text   := Trim(Query1.FieldByName('MAST_NAME').AsString);
  SFrm_1100.UnitCb.Text   := Trim(Query1.FieldByName('MAST_UNIT').AsString);
  SFrm_1100.WeightEd.Text := Trim(Query1.FieldByName('MAST_WEIGHT').AsString);
  SFrm_1100.Ref1Ed.Text   := Trim(Query1.FieldByName('MAST_REF1').AsString);  


  ls_code :=  Trim(Query1.FieldByName('MAST_GUBN1').AsString);
  ls_name :=  Trim(Query1.FieldByName('GUBN1_NAME').AsString);

  if (ls_code <> '') then   ls_gubn := ls_code + '-' + ls_name else   ls_gubn := '';
  SFrm_1100.Gubn1Cb.Text   :=   ls_gubn;


  ls_code :=  Trim(Query1.FieldByName('MAST_GUBN2').AsString);
  ls_name :=  Trim(Query1.FieldByName('GUBN2_NAME').AsString);

  if (ls_code <> '') then   ls_gubn := ls_code + '-' + ls_name else   ls_gubn := '';
  SFrm_1100.Gubn2Cb.Text   :=   ls_gubn;


  ls_code :=  Trim(Query1.FieldByName('MAST_GUBN3').AsString);
  ls_name :=  Trim(Query1.FieldByName('GUBN3_NAME').AsString);

  if (ls_code <> '') then   ls_gubn := ls_code + '-' + ls_name else   ls_gubn := '';
  SFrm_1100.Gubn3Cb.Text   :=   ls_gubn;

  If SFrm_1100 <> Nil Then
    With TForm(SFrm_1100) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      SFrm_1100.Free;
    End;
   StartBitBtnClick(Self);
end;    


procedure TFrm_1100.ExitBitBtnClick(Sender: TObject);
begin   
  Close;
end;

procedure TFrm_1100.FormDestroy(Sender: TObject);
begin
  Frm_1100 := Nil;
end;

procedure TFrm_1100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_1100.DBGrid1DrawColumnCell(Sender: TObject;
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

procedure TFrm_1100.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_1100.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '품목코드 관리');
 end;
end;

procedure TFrm_1100.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_1100.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg('정말로 인쇄 합니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

end.

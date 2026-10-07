unit Frm6200;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask, ComCtrls, QRCtrls, QuickRpt;

type
  TFrm_6200 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    DbGrid1: TDBGrid;
    DataSource1: TDataSource;
    StartBitBtn: TBitBtn;
    UpdtQuery: TADOQuery;
    Query1: TADOQuery;
    Query1SUBK_LOCA: TStringField;
    Query1SUBK_FLAG: TStringField;
    Query1SUBK_CODE: TStringField;
    Query1SUBK_INDATE: TStringField;
    Query1SUBK_INTIME: TStringField;
    Query1SUBK_WGT: TBCDField;
    Query1SUBK_RWGT: TBCDField;
    Query1SUBK_LOTNO: TStringField;
    ItemCB: TEdit;
    SeltCB: TComboBox;
    Titlepl: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Query1MAST_NAME: TStringField;
    InsertBitBtn: TBitBtn;
    UpdateBitBtn: TBitBtn;
    DeleteBitBtn: TBitBtn;
    FDateEdit: TMaskEdit;
    TDateEdit: TMaskEdit;
    Query2: TADOQuery;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText6: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel6: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel10: TQRLabel;
    RecNoEdit: TEdit;
    ExlBtn: TSpeedButton;
    PrintBitBtn: TSpeedButton;
    Query1subk_remark: TStringField;
    NoUseBitBtn: TSpeedButton;
    UsePnl: TPanel;
    Shape2: TShape;
    Label3: TLabel;
    GroupBox4: TGroupBox;
    NuseRB: TRadioButton;
    UseRB: TRadioButton;
    UseConfirmBtn: TButton;
    UseCloseBtn: TButton;
    StaticText8: TStaticText;
    BigoEdit: TEdit;
    Query1gubn1_name: TStringField;
    Query1gubn2_name: TStringField;
    Query1gubn3_name: TStringField;
    Label14: TLabel;
    Gubn1Cb: TComboBox;
    Label5: TLabel;
    Gubn2Cb: TComboBox;
    Label6: TLabel;
    Gubn3Cb: TComboBox;
    ExitBitBtn: TSpeedButton;
    QRLabel7: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRDBText4: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText13: TQRDBText;
    Panel6: TPanel;
    StockEd: TPanel;
    Query1subk_boxno: TStringField;
    Query1SUBK_PLTNO: TStringField;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);  
    procedure StartBitBtnClick(Sender: TObject);  
    procedure ItemCBChange(Sender: TObject); 
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char);
    procedure SeltCBChange(Sender: TObject);
    procedure Query1SUBK_FLAGGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);  

    procedure UpdateBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure InsertBitBtnClick(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
    procedure DbGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DbGrid1TitleClick(Column: TColumn);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DbGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure NoUseBitBtnClick(Sender: TObject);
    procedure UseCloseBtnClick(Sender: TObject);
    procedure UseConfirmBtnClick(Sender: TObject);


  private
    { Private declarations }
    procedure Cntl_loca_update;
  public 
    { Public declarations }
  end;

var
  Frm_6200: TFrm_6200;
  
  var_SelForm : TForm;
  Var_Form    : TForm;
  var_Modal   : Boolean;
  Var_ItemDiv : String;
  Bol_Modal   : Boolean;
  Bol_Data_Ok : Boolean;

  s_itnbr, s_cvcod, s_code, s_loca,  s_lotno, s_jpno, s_qty, s_bqty, s_date,  s_time, s_gubun : String;
  s_pltno, s_flag, s_depot, s_rqty,  var_sql : String;
  li_BOXQTY, li_bqty, li_qty  : Real;

implementation

uses DBSet, WinLib, FrmPrompt, FrmError, SFrm6200, FrmProgress;

{$R *.dfm}


procedure TFrm_6200.FormCreate(Sender: TObject);
var
  ls_sql, StrCode, ls_gubn, ls_name : String;
begin
  ls_sql := ' Select MIN(subk_indate) subk_findate, MAX(subk_indate) subk_tindate  From T2misubk (NOLOCK) ';
  With Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    FDateEdit.Text := FieldByName('subk_findate').AsString;
    TDateEdit.Text   := FieldByName('subk_tindate').AsString;      
  End;

  Gubn1CB.Clear;
  Gubn1CB.Items.Add('');
  ls_sql := ' Select GUBN1_CODE, GUBN1_NAME  From MIGUBN1 (NOLOCK) ';
  ls_sql := ls_sql + ' Order by  GUBN1_CODE ';
  With Query2 do Begin
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
  With Query2 do Begin
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
  With Query2 do Begin
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

{
  if (jj_kind <> '50') then
  begin
    InsertBitBtn.Visible  := False;
    UpdateBitBtn.Visible  := False;
    DeleteBitBtn.Visible      := False;
  end;
}
  SeltCB.ItemIndex := 0;
  StartBitBtnClick(self);
end;  

procedure TFrm_6200.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
   if key <> #13 then Exit;
   StartBitBtnClick(self);
end;

procedure TFrm_6200.SeltCBChange(Sender: TObject);
begin
    ItemCb.Text := '';
end;  

procedure TFrm_6200.StartBitBtnClick(Sender: TObject);
var
   ls_gubn1,  ls_gubn2,  ls_gubn3 : String;
   li_qty : Real;
begin

  ls_gubn1 :=  Trim(Copy(Gubn1Cb.Text,1,1));
  ls_gubn2 :=  Trim(Copy(Gubn2Cb.Text,1,1));
  ls_gubn3 :=  Trim(Copy(Gubn3Cb.Text,1,1));
  li_qty := 0;

  with Query1 do Begin
    Close;
    SQL.Clear;
    SQL.Add(' Select  subk_loca, subk_code, mast_name, subk_flag,  subk_gubun, SUBK_PLTNO,  ');
    SQL.Add('         subk_wgt,   subk_rwgt, subk_lotno,  Subk_boxNo, ');
    SQL.Add('         subk_indate,  subk_intime, subk_remark, gubn1_name, gubn2_name, gubn3_name   ');
    SQL.Add('  from   T2misubk (NOLOCK)          ');
    SQL.Add('  LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = subk_code    ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1    ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2   ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3  ');
    SQL.Add('  Where  ISNULL(subk_loca, '''') <> ''''       ');
    SQL.Add('         And subk_indate >= '''+FDateEdit.Text+'''  And subk_indate <= '''+TDateEdit.Text+''' ');

    if  SeltCB.ItemIndex = 1      then   SQL.Add(' And  subk_loca  = '''+itemCB.Text+'''   ')

    {
    //else if SeltCB.ItemIndex = 2  then   SQL.Add(' And  subk_code  LIKE '''+itemCB.Text+'%''   ')
    else if SeltCB.ItemIndex = 2  then   SQL.Add(' And  subk_code  = '''+itemCB.Text+'''   ')
    else if SeltCB.ItemIndex = 3  then   SQL.Add(' And  mast_name  LIKE ''%'+itemCB.Text+'%''   ')
    }
    else if SeltCB.ItemIndex = 2 then
    begin
        if Trim(itemCB.Text) <> '' then
            SQL.Add(' And  subk_code  = '''+Trim(itemCB.Text)+'''   ');
    end
    else if SeltCB.ItemIndex = 3 then
    begin
        if Trim(itemCB.Text) <> '' then
            SQL.Add(' And  mast_name  LIKE ''%'+Trim(itemCB.Text)+'%''   ');
    end
    else if SeltCB.ItemIndex = 4  then   SQL.Add(' And  subk_lotno = '''+itemCB.Text+'''   ');

    if  (ls_gubn1 <> '') then  SQL.Add(' And  MAST_GUBN1 = '''+ls_gubn1+'''   ');
    if  (ls_gubn2 <> '') then  SQL.Add(' And  MAST_GUBN2 = '''+ls_gubn2+'''   ');
    if  (ls_gubn3 <> '') then  SQL.Add(' And  MAST_GUBN3 = '''+ls_gubn3+'''   ');

   // SQL.Add(' Order By subk_indate,  subk_intime, subk_loca, subk_pltno, subk_code              ');
    SQL.Add(' Order By subk_loca, subk_pltno ');
    Open;
    First;
  End;

  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(' Select  Sum(subk_wgt) As subk_wgt  ');
    SQL.Add('  from   T2misubk (NOLOCK)          ');
    SQL.Add('  LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = subk_code    ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1    ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2   ');
    SQL.Add('  LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3  ');
    SQL.Add('  Where  ISNULL(subk_loca, '''') <> ''''       ');
    SQL.Add('         And subk_indate >= '''+FDateEdit.Text+'''  And subk_indate <= '''+TDateEdit.Text+''' ');
    if  SeltCB.ItemIndex = 1      then   SQL.Add(' And  subk_loca  = '''+itemCB.Text+'''   ')
    {
    //else if SeltCB.ItemIndex = 2  then   SQL.Add(' And  subk_code  LIKE  '''+itemCB.Text+'%''   ')
    else if SeltCB.ItemIndex = 2  then   SQL.Add(' And  subk_code  =  '''+itemCB.Text+'''   ')
    else if SeltCB.ItemIndex = 3  then   SQL.Add(' And  mast_name  LIKE  ''%'+itemCB.Text+'%''   ')
    }
    else if SeltCB.ItemIndex = 2 then
    begin
        if Trim(itemCB.Text) <> '' then
            SQL.Add(' And  subk_code  = '''+Trim(itemCB.Text)+'''   ');
    end
    else if SeltCB.ItemIndex = 3 then
    begin
        if Trim(itemCB.Text) <> '' then
            SQL.Add(' And  mast_name  LIKE ''%'+Trim(itemCB.Text)+'%''   ');
    end
    else if SeltCB.ItemIndex = 4  then   SQL.Add(' And  subk_lotno = '''+itemCB.Text+'''   ');

    if  (ls_gubn1 <> '') then  SQL.Add(' And  MAST_GUBN1 = '''+ls_gubn1+'''   ');
    if  (ls_gubn2 <> '') then  SQL.Add(' And  MAST_GUBN2 = '''+ls_gubn2+'''   ');
    if  (ls_gubn3 <> '') then  SQL.Add(' And  MAST_GUBN3 = '''+ls_gubn3+'''   ');

    Open;
    li_qty := FieldByName('subk_wgt').AsFloat;
  End;
    StockEd.caption := FormatFloat('###,##0.00', li_qty);


end;


procedure TFrm_6200.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
   DM1.GridToExel(query1, '재고 자료 조회');
 end;
end;

procedure TFrm_6200.DbGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//
end;

procedure TFrm_6200.DbGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_6200.ItemCBChange(Sender: TObject);
begin
   StartBitBtnClick(self);
end;

procedure TFrm_6200.InsertBitBtnClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  SFrm_6200  := TSFrm_6200.Create(Application);
  Bol_Modal := True;

  SFrm_6200.Bol_Insert := True;
  SFrm_6200.Bol_Update := False;
  SFrm_6200.TitleLbl.Caption := '재고 등록';
  SFrm_6200.SB_Search.Enabled := True;

  If SFrm_6200 <> Nil Then
    With TForm(SFrm_6200) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      SFrm_6200.Free;
    End;
    StartBitBtnClick(Self);
end;

procedure TFrm_6200.UpdateBitBtnClick(Sender: TObject);
var
  ls_date, ls_gubun, ls_flag : string;
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  SFrm_6200  := TSFrm_6200.Create(Application);
  Bol_Modal := True;

  SFrm_6200.Bol_Insert := False;
  SFrm_6200.Bol_Update := True;
  SFrm_6200.TitleLbl.Caption := '재고 수정';

  SFrm_6200.LocaMed.Enabled := False;
  SFrm_6200.ItemCodeMed.Enabled := False;
  SFrm_6200.SpecEd.Enabled := False;     
  SFrm_6200.LotnoEd.Enabled := False;
  SFrm_6200.SB_Search.Enabled := False; 

  SFrm_6200.LocaMed.Text        := Query1.FieldByName('SUBK_LOCA').AsString;
  SFrm_6200.ItemCodeMed.Text    := Query1.FieldByName('SUBK_CODE').AsString;
  SFrm_6200.SpecEd.Text         := Query1.FieldByName('MAST_NAME').AsString;
  SFrm_6200.QtyEd.Text          := Query1.FieldByName('SUBK_WGT').AsString;
  SFrm_6200.RQtyEd.Text         := Query1.FieldByName('SUBK_RWGT').AsString;
  SFrm_6200.LotnoEd.Text        := Query1.FieldByName('SUBK_Lotno').AsString;
  SFrm_6200.InTimeEd.Text       := Query1.FieldByName('SUBK_INTIME').AsString;

  if Query1.FieldByName('SUBK_INDATE').AsString <> '' Then
  begin
    ls_date := Query1.FieldByName('SUBK_INDATE').AsString;
    ls_date := Copy(ls_date, 1, 4) + '-' +  Copy(ls_date, 5, 2) + '-' + Copy(ls_date, 7, 2);
    SFrm_6200.InDateDTP.Date := StrToDate(ls_date);
  end
  else SFrm_6200.InDateDTP.Date := Now;

  ls_flag  := Query1.FieldByName('SUBK_FLAG').AsString;

  if  (ls_flag = '0')  then  SFrm_6200.FlagCB.ItemIndex := 0
  else if (ls_flag = '1')  then  SFrm_6200.FlagCB.ItemIndex := 1
  else if (ls_flag = 'X')  then  SFrm_6200.FlagCB.ItemIndex := 2
  else if (ls_flag = 'Y')  then  SFrm_6200.FlagCB.ItemIndex := 3
  else if (ls_flag = 'W')  then  SFrm_6200.FlagCB.ItemIndex := 4
  else if (ls_flag = 'E')  then  SFrm_6200.FlagCB.ItemIndex := 5
  else if (ls_flag = 'N')  then  SFrm_6200.FlagCB.ItemIndex := 6
  else SFrm_6200.FlagCB.ItemIndex := -1;
                                            

  If SFrm_6200 <> Nil Then
    With TForm(SFrm_6200) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      SFrm_6200.Free;
    End;
    StartBitBtnClick(Self);
end;


procedure TFrm_6200.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
   s_code  :=  Trim(Query1.FieldByName('SUBK_CODE').AsString);
   s_loca  :=  Trim(Query1.FieldByName('SUBK_LOCA').AsString);  
   s_lotno :=  Trim(Query1.FieldByName('SUBK_LOTNO').AsString);

    var_sql := ' Delete From T2misubk Where SUBK_LOCA   = '''+s_loca+'''   and ';    
    var_sql := var_sql + '                SUBK_CODE   = '''+s_code+'''   and ';
    var_sql := var_sql + '                SUBK_lotno  = '''+s_lotno+'''  ';
    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('재고위치 ' + s_loca + ' 삭제 에러!!!! ');
      Exit;
    End;

    var_sql := ' Select * From T2misubk Where SUBK_LOCA   = '''+s_loca+'''  ';
    With UpdtQuery Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      Open;
      if RecordCount = 0   then
      Begin
         var_sql := 'Update T2MILSTK Set ';
         var_sql := var_sql + ' LSTK_FLAG = ''0'',                ';
         var_sql := var_sql + ' LSTK_INDATE  = '''',             LSTK_INTIME  = '''' ';
         var_sql := var_sql + ' , LSTK_PLTNO = '''' ';      // 김준영 추가
         var_sql := var_sql + ' Where LSTK_LOCA = '''' ';
       Try
        Close;
        SQL.Clear;
        SQL.Add( var_sql );
        ExecSql;
       Except
        WinLib_ErrorForm('재고위치 ' + s_loca+ ' 삭제 에러!!!! ');
        Exit;
       End;
      End;  
    End;    
    Query1.ReQuery;
  End;
end;  

procedure TFrm_6200.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_6200.FormDestroy(Sender: TObject);
begin
  Frm_6200 := Nil;
end;

procedure TFrm_6200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_6200.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    s_loca := Query1.FieldByName('SUBK_LOCA').AsString;
end;

procedure TFrm_6200.Query1SUBK_FLAGGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   if Sender.Value = '1'  then Text := '대기'
   else if Sender.Value = 'N' then Text := '금지'
   else Text := '예약';
end;



procedure TFrm_6200.DbGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    ls_use, Value, ls_rsrv : String;
    WW     : Integer;
    xDBGrid: TDBGrid;
 begin
  ls_rsrv :=  Query1.FieldByName('SUBK_FLAG').AsString;
  if  (ls_rsrv = 'Y') or (ls_rsrv = 'E') then
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

  if  (ls_rsrv = 'N') then
  begin
   with(Sender as TDBGrid).Canvas do
    begin
      Brush.Color := clRed;
      Font.Color  := clWhite;
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

procedure TFrm_6200.PrintBitBtnClick(Sender: TObject);
begin
 if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_6200.NoUseBitBtnClick(Sender: TObject);
begin
  usePnl.Visible := True;
  NuseRb.Checked := True;  useRb.Checked := False;
end;

procedure TFrm_6200.UseCloseBtnClick(Sender: TObject);
begin
   UsePnl.Visible := False;
end;

procedure TFrm_6200.UseConfirmBtnClick(Sender: TObject);
var
  intPos   : Integer;
begin
    if (NuseRb.Checked = False) And (useRb.Checked = False) then Exit;

    For intPos := 1 To DBGrid1.SelectedRows.Count Do Begin
      With DBGrid1.DataSource.DataSet Do Begin
        If DBGrid1.SelectedRows.Count > 0 Then Begin
           gotobookmark(pointer(DBGrid1.SelectedRows.items[intpos -1]));
           s_loca     := Query1.FieldByName('subk_loca').AsString;
           Cntl_loca_update;
        End;
      End;
    End;
    Query1.Requery;
end;

procedure TFrm_6200.Cntl_loca_update;
var
  ls_sql, ls_use, ls_bigo : String;
begin
  if (NuseRb.Checked = True)  then  ls_use := 'N'  else ls_use := '1';

  ls_bigo := Trim(BigoEdit.Text);

  ls_sql := 'Update T2MILSTK Set LSTK_FLAG = '''+ls_use+'''  ';
  ls_sql := ls_sql + ' Where  lstk_Loca = '''+s_loca+'''  ';

  With Query2 Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( ls_sql );
      ExecSql;
    Except
      Begin
        WinLib_ErrorForm('Lock Setup ' + s_loca + ' Update Error! ');
        Exit;
      End;
    End;

  ls_sql := 'Update T2misubk Set SUBK_FLAG = '''+ls_use+''', SUBK_REMARK = '''+ls_bigo+''' ';
  ls_sql := ls_sql + ' Where  subk_Loca = '''+s_loca+'''  ';

  With Query2 Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( ls_sql );
      ExecSql;
    Except
      Begin
        WinLib_ErrorForm('Lock Setup ' + s_loca + ' Subk Update Error! ');
        Exit;
      End;
    End;
end;

end.

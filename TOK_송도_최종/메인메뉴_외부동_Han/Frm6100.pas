unit Frm6100;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB,
  DBTables, QRCtrls, QuickRpt;

type
  TFrm_6100 = class(TForm)
    GroupBox1: TGroupBox;
    Panel12: TPanel;
    LocaMEd: TMaskEdit;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    Shape2: TShape;
    Label1: TLabel;
    Panel4: TPanel;
    Panel1: TPanel;
    StartSpdBtn: TBitBtn;
    lstkUpdateBitBtn: TBitBtn;
    UpdateBitBtn: TBitBtn;
    DeleteBitBtn: TBitBtn;
    PrintBitBtn: TBitBtn;
    lstkDeleteBitBtn: TBitBtn;
    Panel6: TPanel;
    StockEd: TEdit;
    LstkQuery: TADOQuery;
    UpdtQuery: TADOQuery;
    SubkQuery: TADOQuery;
    LstkQueryLSTK_LOCA: TStringField;
    LstkQueryLSTK_FLAG: TStringField;
    LstkQueryLSTK_INDATE: TStringField;
    LstkQueryLSTK_INTIME: TStringField;
    SubkQuerySUBK_LOCA: TStringField;
    SubkQuerySUBK_FLAG: TStringField;
    SubkQuerySUBK_CODE: TStringField;
    SubkQuerySUBK_GUBUN: TStringField;
    SubkQuerySUBK_INDATE: TStringField;
    SubkQuerySUBK_INTIME: TStringField;
    SubkQueryMAST_NAME: TStringField;
    SubkQuerySUBK_WGT: TBCDField;
    SubkQuerySUBK_RWGT: TBCDField;
    SubkQuerySUBK_LOTNO: TStringField;
    ExitBitBtn: TBitBtn;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRLbl_Code: TQRLabel;
    QRBand5: TQRBand;
    QRLabel3: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel4: TQRLabel;
    QRDBText10: TQRDBText;
    SubkQuerysubk_remark: TStringField;
    SubkQueryGUBN1_Name: TStringField;
    SubkQueryGUBN2_Name: TStringField;
    SubkQueryGUBN3_Name: TStringField;
    QRLabel7: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    SubkQuerySUBK_BOXNO: TStringField;
    SubkQuerySUBK_PLTNO: TStringField;
    LstkQueryLSTK_PLTNO: TStringField;
    InsertBitBtn: TBitBtn;
    cellCancelBitBtn: TBitBtn;
    AddBitBtn: TBitBtn;
    ChkQuery: TADOQuery;
    QRLabel10: TQRLabel;
    QRDBText14: TQRDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure StartSpdBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure T2Misubk_Select_Proc;
    procedure LocaMEdEnter(Sender: TObject);
    procedure lstkUpdateBitBtnClick(Sender: TObject);
    procedure lstkDeleteBitBtnClick(Sender: TObject);
    procedure DataSource2DataChange(Sender: TObject; Field: TField);
    procedure InsertBitBtnClick(Sender: TObject);
    procedure UpdateBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure Cntl_LocationSelect_proc;
//    procedure MoveLocaMedChange(Sender: TObject);
//    procedure ConfirmBitBtnClick(Sender: TObject);
//    procedure CloseBitBtnClick(Sender: TObject);
    procedure LocaMEdKeyPress(Sender: TObject; var Key: Char);
    procedure LstkQueryLSTK_FLAGGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure SubkQuerySUBK_GUBUNGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure SeltCBChange(Sender: TObject);
    procedure SubkQuerySUBK_FLAGGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cellCancelBitBtnClick(Sender: TObject);
    procedure AddBitBtnClick(Sender: TObject);
    procedure DBGrid2TitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_6100: TFrm_6100;

  StrCode : String;
  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;

  s_loca, s_pltno, s_code, s_cvcod, s_lotno, s_ttl_qty, s_flag, var_lot : String;
  lk_qty, lk_amt, sk_qty, sk_amt : Real;

implementation

uses WinLib, FrmPrompt, FrmError, SFrm6110, SFrm6120, SFrm6130, FrmProgress,
  LocaAdd_u;

{$R *.dfm}

procedure TFrm_6100.FormCreate(Sender: TObject);
begin
//  Top  := (Screen.Height - Self.Height) div 2;
//  Left := (Screen.Width - Self.Width) div 2;
  LocaMEd.Text := '1011';

  if (jj_kind <> '50') then
  begin
    lstkUpdateBitBtn.Visible  := False;
    lstkDeleteBitBtn.Visible  := False;
    InsertBitBtn.Visible      := False;
    UpdateBitBtn.Visible      := False;
    DeleteBitBtn.Visible      := False;
  end;
  
end;

procedure TFrm_6100.SeltCBChange(Sender: TObject);
begin
   StartSpdBtnClick(Self);
end;


procedure TFrm_6100.StartSpdBtnClick(Sender: TObject);
begin
  with LstkQuery do Begin
    DisableControls;
    Close;
    SQL.Clear;
    SQL.Add(' Select lstk_loca, lstk_flag, lstk_indate, lstk_intime, lstk_pltno ');
    SQL.Add('  From T2MILSTK (NOLOCK) ');
    SQL.Add('  Where lstk_loca >= '''+LocaMEd.Text+''' ');
    SQL.Add('  Order By LSTK_LOCA ');
    Open;
     First;
    EnableControls;   

    LocaMEd.Text  := FieldByName('lstk_loca').AsString;
  end;

  T2MISUBK_Select_Proc;
end;

procedure TFrm_6100.T2MISUBK_Select_Proc;
var
  li_Bqty, li_qty, bi_qty, bi_bqty : Real;
begin
    with subkQuery do Begin
     Close;
     SQL.Clear;
     SQL.Add(' Select  subk_loca, subk_flag, subk_code, subk_gubun,  ');
     SQL.Add('         subk_wgt, subk_rwgt, subk_lotno, subk_remark, subk_boxno, subk_pltno, ');  // 김준영 pltno  추가 
     SQL.Add('         subk_indate, subk_intime, Mast_name, gubn1_name, gubn2_name, gubn3_name  ');
     SQL.Add('  from  T2MISUBK  (NOLOCK)                                  ');
     SQL.Add('  LEFT OUTER JOIN MIMAST  (NOLOCK) ON MAST_CODE = subk_code    ');
     SQL.Add('  LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1  ');
     SQL.Add('  LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2  ');
     SQL.Add('  LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3  ');
     SQL.Add('  Where subk_loca = '''+locaMEd.Text+'''              ');
     SQL.Add('  Order By subk_loca, subk_code                       ');
     Open;
     First;

     While Not Eof Do Begin
      bi_qty  := FieldByName('SUBK_WGT').AsFloat;
      li_qty  := li_qty + bi_qty;
      Next;
    End;
   End;

   StockEd.Text := FormatFloat('#,###,##0.00',li_qty);
end;

procedure TFrm_6100.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    LocaMEd.Text  := LstkQuery.FieldByName('lstk_loca').AsString;
    s_Flag        := LstkQuery.FieldByName('lstk_flag').AsString;
    T2MISUBK_Select_Proc;
end;



procedure TFrm_6100.LocaMEdEnter(Sender: TObject);
begin
    StartSpdBtnClick(Self);
end;

procedure TFrm_6100.lstkUpdateBitBtnClick(Sender: TObject);
var
  ls_flag : String;
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  SFrm_6110  := TSFrm_6110.Create(Application);
  Bol_Modal := True;

  SFrm_6110.Bol_Insert := False;
  SFrm_6110.Bol_Update := True;
  SFrm_6110.Bol_Delete := False;
  SFrm_6110.TitleLbl.Caption := '재고위치수정';

  SFrm_6110.LocaMed.Enabled := False;

  SFrm_6110.LocaMed.Text   := LstkQuery.FieldByName('LSTK_LOCA').AsString;  
  SFrm_6110.DateEd.Text    := LstkQuery.FieldByName('LSTK_INDATE').AsString;
  SFrm_6110.TimeEd.Text    := LstkQuery.FieldByName('LSTK_INTIME').AsString;
  SFrm_6110.pltNoEd.Text   := LstkQuery.FieldByName('LSTK_PLTNO').AsString;

  ls_flag  := LstkQuery.FieldByName('LSTK_FLAG').AsString;

  if  (ls_flag = '0')  then  SFrm_6110.FlagEd.ItemIndex := 0
  else if (ls_flag = '1')  then  SFrm_6110.FlagEd.ItemIndex := 1
  else if (ls_flag = 'X')  then  SFrm_6110.FlagEd.ItemIndex := 2
  else if (ls_flag = 'Y')  then  SFrm_6110.FlagEd.ItemIndex := 3
  else if (ls_flag = 'W')  then  SFrm_6110.FlagEd.ItemIndex := 4
  else if (ls_flag = 'E')  then  SFrm_6110.FlagEd.ItemIndex := 5
  else if (ls_flag = 'N')  then  SFrm_6110.FlagEd.ItemIndex := 6
  else SFrm_6110.FlagEd.ItemIndex := -1;

  If SFrm_6110 <> Nil Then
    With TForm(SFrm_6110) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      SFrm_6110.Free;
    End;

    LstkQuery.ReQuery;
end;

procedure TFrm_6100.lstkDeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := ' 정말로 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    // T2MISUBK 삭제, 해당 T2MILSTK 초기화 
    var_sql := ' Select * From T2MISUBK (NOLOCK) Where SUBK_LOCA   = '''+LocaMEd.Text+'''  ';
    With UpdtQuery Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      Open;
      if RecordCount > 0   then
      Begin
        var_Msg := ' 재고가 있습니다.확정 합니까? (재고가 지워집니다)';
        if WinLib_ConfirmForm( var_Msg ) then
        begin
           var_sql := ' Delete From T2MISUBK Where SUBK_LOCA = '''+LocaMEd.Text+'''  ';
           With UpdtQuery Do
           Try
             Close;
             SQL.Clear;
             SQL.Add( var_sql );
             ExecSql;
           Except
             WinLib_ErrorForm('재고위치(T2MISUBK) ' + s_loca + ' 삭제 에러!!!! ');
             Exit;
           End;
        end;
      end;
    End;

    var_sql := 'Update T2MILSTK Set ';
    var_sql := var_sql + ' LSTK_FLAG = ''0'',               ';
    var_sql := var_sql + ' LSTK_INDATE  = '''',             LSTK_INTIME  = '''' ';
    var_sql := var_sql + ' , LSTK_PLTNO = '''' '; 
    var_sql := var_sql + ' Where LSTK_LOCA = '''+LocaMEd.Text+''' ';
    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('재고위치 ' + LocaMEd.Text + ' 삭제 에러!!!! ');
      Exit;
    End;
    LstkQuery.ReQuery;
    StartSpdBtnClick(Self);
  end;
end;


// 셀 재고 취소
procedure TFrm_6100.cellCancelBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := ' 정말로 셀 재고 취소를 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    // 셀 재고 취소
    // T2MISUBK loca '' 초기화 flag  '0' 초기화 gubun '' 초기화
    // T2MILSTK LSTK_INDATE, LSTK_INTIME, LSTK_PLTNO '' , LSTK_FLAG  '0' 초기화
    with UpdtQuery Do
    begin
      var_sql := ' UPDATE T2MISUBK SET SUBK_LOCA = '''', SUBK_FLAG = ''0'', SUBK_GUBUN = '''' WHERE SUBK_LOCA = '''+LocaMEd.Text+''' ';
      Try
        Close;
        SQL.Clear;
        SQL.Add(var_sql);
        ExecSql;
      EXCEPT
        WinLib_ErrorForm('재고위치 ' + LocaMEd.Text + ' 셀 재고 취소 에러!!!!(SUBK 초기화 에러) ');
        Exit;
      END;
    end;

    with UpdtQuery Do
    begin
      var_sql := ' UPDATE T2MILSTK SET LSTK_INDATE = '''', LSTK_INTIME = '''', LSTK_PLTNO = '''', LSTK_FLAG = ''0'' '; 
      var_sql := var_sql + ' WHERE LSTK_LOCA = '''+LocaMEd.Text+''' ';
      Try
        Close;
        SQL.Clear;
        SQL.Add(var_sql);
        ExecSql;
      EXCEPT
        WinLib_ErrorForm('재고위치 ' + LocaMEd.Text + ' 셀 재고 취소 에러!!!!(LSTK 초기화 에러) ');
        Exit;
      END;
    end;
    StartSpdBtnClick(Self);
  end;
end;




procedure TFrm_6100.DataSource2DataChange(Sender: TObject; Field: TField);
begin
   s_loca     := SubkQuery.FieldByName('Subk_loca').AsString;
   s_code     := SubkQuery.FieldByName('Subk_code').AsString;
   s_lotno    := SubkQuery.FieldByName('Subk_lotno').AsString;
   sk_qty     := SubkQuery.FieldByName('SUBK_wgt').AsFloat;
end;

procedure TFrm_6100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_6100.FormDestroy(Sender: TObject);
begin
  Frm_6100 := Nil;
end;

procedure TFrm_6100.Cntl_LocationSelect_proc;
var
  ls_date, ls_gubun, ls_flag : string;
begin
  SFrm_6130.ItemCodeMed.Text    := SubkQuery.FieldByName('SUBK_CODE').AsString;
  SFrm_6130.SpecEd.Text         := SubkQuery.FieldByName('MAST_NAME').AsString;
  SFrm_6130.QtyEd.Text          := SubkQuery.FieldByName('SUBK_WGT').AsString;
  SFrm_6130.RQtyEd.Text         := SubkQuery.FieldByName('SUBK_RWGT').AsString;
  SFrm_6130.LotnoEd.Text        := SubkQuery.FieldByName('SUBK_Lotno').AsString;
  SFrm_6130.BigoEd.Text         := SubkQuery.FieldByName('SUBK_REMARK').AsString;
  SFrm_6130.BoxNoEd.Text        := SubkQuery.FieldByName('SUBK_BOXNO').AsString;

  SFrm_6130.InTimeEd.Text       := SubkQuery.FieldByName('SUBK_INTIME').AsString;
  if SubkQuery.FieldByName('SUBK_INDATE').AsString <> '' Then
  begin
    ls_date := SubkQuery.FieldByName('SUBK_INDATE').AsString;
    ls_date := Copy(ls_date, 1, 4) + '-' +  Copy(ls_date, 5, 2) + '-' + Copy(ls_date, 7, 2);
    SFrm_6130.InDateDTP.Date := StrToDate(ls_date);
  end
  else SFrm_6130.InDateDTP.Date := Now;


  ls_flag  := SubkQuery.FieldByName('SUBK_FLAG').AsString;

  if  (ls_flag = '0')  then  SFrm_6130.FlagCB.ItemIndex := 0
  else if (ls_flag = '1')  then  SFrm_6130.FlagCB.ItemIndex := 1
  else if (ls_flag = 'X')  then  SFrm_6130.FlagCB.ItemIndex := 2
  else if (ls_flag = 'Y')  then  SFrm_6130.FlagCB.ItemIndex := 3
  else if (ls_flag = 'W')  then  SFrm_6130.FlagCB.ItemIndex := 4
  else if (ls_flag = 'E')  then  SFrm_6130.FlagCB.ItemIndex := 5
  else if (ls_flag = 'N')  then  SFrm_6130.FlagCB.ItemIndex := 6
  else SFrm_6130.FlagCB.ItemIndex := -1;

end;

procedure TFrm_6100.InsertBitBtnClick(Sender: TObject);
var
  ls_loca, ls_flag, ls_pltno : String;
begin
  if LstkQuery.RecordCount = 0 then
  begin
    WinLib_ErrorForm('선택한 행이 없습니다.');
    Exit;
  end;

  ls_loca := LstkQuery.FieldByName('LSTK_LOCA').AsString;

  // LstkQuery에서 현재 위치의 FLAG와 PLTNO 확인
  with LstkQuery do
  begin
    // LocaMEd.Text에 해당하는 행이 현재 선택되어 있는지 확인
    // 또는 Locate를 사용하여 해당 행을 찾기
    if Locate('LSTK_LOCA', ls_loca, []) then
    begin
      ls_flag := FieldByName('LSTK_FLAG').AsString;
      ls_pltno := FieldByName('LSTK_PLTNO').AsString;
      
      // 예외처리: LSTK_FLAG = '1' 이거나 LSTK_PLTNO가 빈 문자열이 아니면
      if (ls_flag = '1') or (Trim(ls_pltno) <> '') then
      begin
        WinLib_ErrorForm('이미 재고가 들어있는 위치입니다. 다른 위치를 선택해주세요.');
        Exit;
      end;
    end;
  end;

  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  SFrm_6120  := TSFrm_6120.Create(Application);
  Bol_Modal := True;

  SFrm_6120.Bol_Insert := True;
  SFrm_6120.Bol_Update := False;

  //SFrm_6120.LocaMed.Text := LocaMEd.Text;
  SFrm_6120.LocaMed.Text :=ls_loca;
  SFrm_6120.LocaMed.Enabled := False;
  SFrm_6120.TitleLbl.Caption := '재고 위치 등록';
//  SFrm_6120.SB_Search.Enabled := True;

  if  (s_flag = '0')  then  SFrm_6120.FlagCB.ItemIndex := 0
  else if (s_flag = '1')  then  SFrm_6120.FlagCB.ItemIndex := 1
  else if (s_flag = 'X')  then  SFrm_6120.FlagCB.ItemIndex := 2
  else if (s_flag = 'Y')  then  SFrm_6120.FlagCB.ItemIndex := 3
  else if (s_flag = 'W')  then  SFrm_6120.FlagCB.ItemIndex := 4
  else if (s_flag = 'E')  then  SFrm_6120.FlagCB.ItemIndex := 5
  else if (s_flag = 'N')  then  SFrm_6120.FlagCB.ItemIndex := 6
  else SFrm_6120.FlagCB.ItemIndex := -1;

  If SFrm_6120 <> Nil Then
    With TForm(SFrm_6120) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      SFrm_6120.Free;
    End;
    StartSpdBtnClick(Self);
end;

// 셀 재고 추가
procedure TFrm_6100.AddBitBtnClick(Sender: TObject);
var
  ls_sql, ls_pltno : String;
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  // 해당 버튼 클릭시 DBGrid2 가 SELECT 되었는지 그리고 헤당 위치 정보에 PLTNO 정보가 들어가 있는지 확인이 필요함.
  // selected 유무
  // PLTNO 정보가 들어가 있는지 check
  // LocaAdd 에 PLTNO 정보, LOCA 정보 등이 들어가 있어야 함.

  if (LocaMEd.Text = '') then
  begin
    WinLib_ErrorForm('선택한 행이 없습니다.');
    Exit;
  end;


  with ChkQuery Do
  Begin
    ls_sql := ' SELECT LSTK_PLTNO FROM T2MILSTK WHERE LSTK_LOCA = '''+LocaMEd.Text+''' ';

    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    if(FieldByName('LSTK_PLTNO').AsString = '') then
    begin
      StrMsg := '해당 위치에 재고가 없습니다. 셀 재고 등록후 추가해 주세요';
      WinLib_ErrorForm(StrMsg);
      Exit;
    end;

    ls_pltno := FieldByName('LSTK_PLTNO').AsString;

    ls_sql := ' SELECT SUBK_LOCA FROM T2MISUBK WHERE SUBK_PLTNO = '''+ls_pltno+''' ';

    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    if(RecordCount = 0) then
    begin
      StrMsg := '해당 PLTNO 정보가 없습니다. 확인후 다시 시도하십시오.';
      WinLib_ErrorForm(StrMsg);
      Exit;
    end;
  end;

  LocaAdd  := TLocaAdd.Create(Application);
  Bol_Modal := True;

  LocaAdd.LocaMed.Text := LocaMEd.Text;
  LocaAdd.PltnoEdit.Text := ls_pltno;

  If LocaAdd <> Nil Then
    With TForm(LocaAdd) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      LocaAdd.Free;
    End;
  StartSpdBtnClick(Self);
end;


procedure TFrm_6100.UpdateBitBtnClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  SFrm_6130  := TSFrm_6130.Create(Application);
  Bol_Modal := True;

  SFrm_6130.Bol_Insert := False;
  SFrm_6130.Bol_Update := True;
  SFrm_6130.TitleLbl.Caption := '재고 위치 수정';

  SFrm_6130.LocaMed.Text :=LocaMEd.Text;
  SFrm_6130.LocaMed.Enabled := False;
  SFrm_6130.ItemCodeMed.Enabled := False;
  SFrm_6130.SpecEd.Enabled := False;
  SFrm_6130.LotnoEd.Enabled := False;
  SFrm_6130.SB_Search.Enabled := False;

  Cntl_LocationSelect_proc;

  If SFrm_6130 <> Nil Then
    With TForm(SFrm_6130) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      SFrm_6130.Free;
    End;
    StartSpdBtnClick(Self);
end;

procedure TFrm_6100.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := ' PLT 정보가 사라집니다..  정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From T2MISUBK Where SUBK_LOCA   = '''+s_loca+'''   and ';
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

    var_sql := ' Select * From T2MISUBK (NOLOCK) Where SUBK_LOCA   = '''+s_loca+''' ';
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
         var_sql := var_sql + ' , LSTK_PLTNO = '''' '; 
         var_sql := var_sql + ' Where LSTK_LOCA = '''+LocaMEd.Text+''' ';
       Try
        Close;
        SQL.Clear;
        SQL.Add( var_sql );
        ExecSql;
       Except
        WinLib_ErrorForm('재고위치 ' + s_loca+ ' 삭제 에러!!!! ');
        Exit;
       End;
        LstkQuery.ReQuery;
      End;  
    End;    
    SubkQuery.ReQuery;
  End;  
end;

procedure TFrm_6100.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_6100.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_6100.DBGrid2DblClick(Sender: TObject);
begin
  lstkUpdateBitBtnClick(self);
end;

procedure TFrm_6100.LocaMEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then StartSpdBtnClick(Self);
end;


procedure TFrm_6100.LstkQueryLSTK_FLAGGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   if Sender.Value = 'Y'  then Text := '출고'
   else if Sender.Value = 'X'  then Text := '입고'
   else if Sender.Value = '1'  then Text := '제품유'
   else if Sender.Value = '0'  then Text := '빈셀'
   else if Sender.Value = 'N'  then Text := '금지'
   else if Sender.Value = 'W'  then Text := '이중'
   else if Sender.Value = 'E'  then Text := '공출'
   else Text := '';
end;

procedure TFrm_6100.SubkQuerySUBK_GUBUNGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   if Sender.Value = 'Y'  then Text := '불량'
   else if Sender.Value = 'N'  then Text := '정상'
   else Text := '';
end;   

procedure TFrm_6100.SubkQuerySUBK_FLAGGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   if Sender.Value = '1'  then Text := '대기' 
   else if Sender.Value = 'Y' then Text := '예약'
   else Text := '';
end;


procedure TFrm_6100.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    ls_use, Value, ls_rsrv : String;
    WW     : Integer;
    xDBGrid: TDBGrid;
 begin
  ls_rsrv :=  subkQuery.FieldByName('SUBK_FLAG').AsString;
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

end;

procedure TFrm_6100.DBGrid2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    ls_use, Value, ls_rsrv : String;
    WW     : Integer;
    xDBGrid: TDBGrid;

 begin
  ls_rsrv :=  LstkQuery.FieldByName('LSTK_FLAG').AsString;
  if  (ls_rsrv = 'Y') or (ls_rsrv = 'E') then
  begin
   with(Sender as TDBGrid).Canvas do
    begin
      Brush.Color := clYellow;
      Font.Color  := clRed;
      Canvas.Font.Style := [fsBold];
      FillRect(Rect);
    end;
    DbGrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);
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
    DbGrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;

end;






procedure TFrm_6100.DBGrid2TitleClick(Column: TColumn);
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

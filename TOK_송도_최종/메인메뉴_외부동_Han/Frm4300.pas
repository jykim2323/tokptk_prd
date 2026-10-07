unit Frm4300;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Mask, ComCtrls, Buttons, ExtCtrls, Db,
  DBTables, ADODB, QRCtrls, QuickRpt, qrBarcode;

type
  TFrm_4300 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DeleteBitBtn: TSpeedButton;
    Query1: TADOQuery;
    UpdtQuery: TADOQuery;
    Query1OUPT_DATE: TStringField;
    Query1OUPT_INDEX: TStringField;
    Query1OUPT_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1OUPT_LOTNO: TStringField;
    Query1OUPT_SEQNO: TIntegerField;
    Query1OUPT_LOCA: TStringField;
    Query1OUPT_TIME: TStringField;
    Query1OUPT_JOB_FLAG: TStringField;
    Query1OUPT_REMARK: TStringField;
    ExlBtn: TSpeedButton;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText9: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel12: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel13: TQRLabel;
    Query1OUPT_WGT: TBCDField;
    Query1OUPT_OUT_WGT: TBCDField;
    PrintBitBtn: TSpeedButton;
    RecNoEdit: TEdit;
    QRDBText6: TQRDBText;
    Query1OUPT_ID: TStringField;
    Query1OUPT_BOXNO: TStringField;
    Query1OUPT_CHASU: TStringField;
    Panel2: TPanel;
    StartBitBtn: TSpeedButton;
    Query2: TADOQuery;
    SeltCB: TComboBox;
    ItemCB: TEdit;
    Query1OUPT_CUST: TStringField;
    ReservedSB: TSpeedButton;
    QRLabel2: TQRLabel;
    QRDBText7: TQRDBText;
    QRLabel6: TQRLabel;
    QRLabel8: TQRLabel;
    QRDBText8: TQRDBText;
    Query1OUPT_BOXNO1: TStringField;
    Query1OUPT_REMARK1: TStringField;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRDBText10: TQRDBText;
    QRDBText13: TQRDBText;
    Query1OUPT_PLTNO: TStringField;
    procedure StartBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
  
    procedure SelRGClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
  
    procedure QRBand3BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure ReservedSBClick(Sender: TObject);
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char);
   

  private
    { Private declarations }
    procedure MouseWheelHandler(var Message: TMessage); override;

    procedure Outlet_complete_proc;
    function f_get_sysdate_time1(): String;
  public
    { Public declarations }
  end;

var
  Frm_4300: TFrm_4300;

  var_Sql, s_index, s_code, s_lotno : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate1, StrDate2: String;
  StrQry, StrChasu, StrDate  : String;

   s_cust, s_loca : String;
   s_qty, s_rqty, s_boxno, s_remark : string;
   s_pltno : string;  
implementation

uses DbSet, WinLib, FrmPrompt, FrmError, FrmProgress;
{$R *.dfm}

procedure TFrm_4300.FormCreate(Sender: TObject);
begin
//  Top  := (Screen.Height - Self.Height) div 2;
//  Left := (Screen.Width - Self.Width) div 2;

  if (jj_kind <> '50') then
  begin
    DeleteBitBtn.Visible    := False;   
  end;

  StartBitBtnClick(Self);

end;


procedure TFrm_4300.StartBitBtnClick(Sender: TObject);
var
   ls_chasu : string;
begin


  var_Sql := ' Select OUPT_DATE, OUPT_INDEX, OUPT_CODE, MAST_NAME,  OUPT_LOTNO, OUPT_SEQNO, ';
  var_Sql := var_Sql + ' OUPT_GUBUN,  OUPT_WGT, OUPT_OUT_WGT,  OUPT_LOCA, OUPT_BOXNO1, OUPT_REMARK1,';
  var_Sql := var_Sql + ' OUPT_TIME,   OUPT_JOB_FLAG,  OUPT_REMARK, OUPT_ID, OUPT_BOXNO, OUPT_CHASU, OUPT_CUST, OUPT_PLTNO ';
  var_Sql := var_Sql + ' From T2MIOUPT (NOLOCK) ';
  var_Sql := var_Sql + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = OUPT_CODE  ';
  var_Sql := var_Sql + ' Where ISNULL(OUPT_CODE, '''') <> ''''   ';
  var_Sql := var_Sql + '   And  OUPT_JOB_FLAG   = ''0''         ';

  {
  if  SeltCB.ItemIndex = 1      then   begin
      //var_Sql := var_Sql + '  And OUPT_CODE   LIKE '''+itemCB.Text+'%'' ';
      var_Sql := var_Sql + '  And OUPT_CODE   = '''+itemCB.Text+''' ';
      var_Sql := var_Sql + '   Order by OUPT_CODE,  OUPT_INDEX    '
  end
  else if SeltCB.ItemIndex = 2  then   begin
      var_Sql := var_Sql + '  And MAST_NAME  LIKE ''%'+itemCB.Text+'%'' ';
      var_Sql := var_Sql + '   Order by OUPT_LOTNO,  OUPT_INDEX    '
  end
  }
  if SeltCB.ItemIndex = 1 then begin
      if Trim(itemCB.Text) <> '' then
          var_Sql := var_Sql + '  And OUPT_CODE = '''+Trim(itemCB.Text)+''' ';
      var_Sql := var_Sql + '   Order by OUPT_CODE,  OUPT_INDEX    ';
  end
  else if SeltCB.ItemIndex = 2 then begin
      if Trim(itemCB.Text) <> '' then
          var_Sql := var_Sql + '  And MAST_NAME LIKE ''%'+Trim(itemCB.Text)+'%'' ';
      var_Sql := var_Sql + '   Order by OUPT_LOTNO,  OUPT_INDEX    ';
  end
  else if SeltCB.ItemIndex = 3  then   begin
      var_Sql := var_Sql + '  And OUPT_LOTNO  = '''+itemCB.Text+''' ';
      var_Sql := var_Sql + '   Order by OUPT_LOTNO,  OUPT_INDEX    '
  end
  else if SeltCB.ItemIndex = 4  then   begin
      var_Sql := var_Sql + '  And OUPT_LOCA   = '''+itemCB.Text+''' ';
      var_Sql := var_Sql + '   Order by OUPT_LOCA,  OUPT_INDEX    '
  end
  else
  begin
      var_Sql := var_Sql + '   Order by  OUPT_INDEX,  OUPT_CODE  ';
  end;


  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
  end;
  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);
end;

procedure TFrm_4300.DeleteBitBtnClick(Sender: TObject);
var
   var_sql, var_Msg, ls_seqid, ls_code, ls_lotno, ls_index, ls_cust, ls_loca : String;
   intPos : Integer;
begin
  if Dbgrid1.SelectedRows.Count = 0 then Exit;

  var_Msg := ' 출고 이력  데이타를 삭제 하겠습니까??';
  If Not WinLib_ConfirmForm( var_Msg ) Then Begin  Exit;    End;


  For intPos := 1 To DBGrid1.SelectedRows.Count Do Begin
      With DBGrid1.DataSource.DataSet Do Begin
        If DBGrid1.SelectedRows.Count > 0 Then Begin
           gotobookmark(pointer(DBGrid1.SelectedRows.items[intpos -1]));
//           DBgrid1.SelectedRows.Delete;
           ls_code     := Query1.FieldByName('OUPT_CODE').AsString;
           ls_lotno    := Query1.FieldByName('OUPT_LOTNO').AsString;
           ls_index    := Query1.FieldByName('OUPT_INDEX').AsString;
           ls_cust     := Query1.FieldByName('OUPT_CUST').AsString;
           ls_loca     := Query1.FieldByName('OUPT_LOCA').AsString;

           Query2.Close;
           Query2.SQL.Clear;
           Query2.SQL.Add(' Delete From T2MIOUPT Where OUPT_INDEX    = '''+ls_index+'''  ');
           Query2.SQL.Add(' And OUPT_CODE   = '''+ls_code+''' And OUPT_LOTNO   = '''+ls_lotno+'''  ');
           Query2.SQL.Add(' And OUPT_CUST   = '''+ls_cust+'''   ');
           Query2.ExecSQL;

           Query2.Close;
           Query2.SQL.Clear;
           Query2.SQL.Add(' Update T2MISUBK Set SUBK_RWGT = ''0.00'', SUBK_FLAG = ''1''  Where SUBK_FLAG = ''Y'' And SUBK_LOCA  = '''+ls_loca+'''  ');
           Query2.ExecSQL;

           Query2.Close;
           Query2.SQL.Clear;
           Query2.SQL.Add(' Update T2MILSTK Set LSTK_FLAG = ''1''  Where LSTK_FLAG = ''Y'' And LSTK_LOCA  = '''+ls_loca+'''  ');
           Query2.ExecSQL;

           Query2.Close;
           Query2.SQL.Clear;
           Query2.SQL.Add(' UpDate T2TBTRAK Set TRAK_INDEX = '''', TRAK_LOCA  = '''', TRAK_GUBUN = '''', TRAK_HIGH = '''',');
           Query2.SQL.Add(' TRAK_FLAG  = '''', TRAK_DATE    = '''',  TRAK_TIME  = '''' ');
           Query2.SQL.Add(' Where TRAK_INDEX = '''+ls_index+''' ');
           Query2.ExecSQL;
        End;
      End;
    End;
    Dbgrid1.SelectedRows.Clear;
    StartBitBtnClick(Self);

{
    var_sql := ' Delete From T2MIOUPT Where OUPT_INDEX  = '''+s_index+'''  ';
    var_sql := var_sql + ' And  OUPT_CODE  = '''+s_code+''' ';
    var_sql := var_sql + ' And  OUPT_LOTNO = '''+s_lotno+''' ';
    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('출고예약 ' + s_index  + ' 삭제 에러!!!! ');
      Exit;
    End;
    StartBitBtnClick(Self);
  end;
}
end;

procedure TFrm_4300.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    s_index  := Query1.FieldByName('OUPT_Index').AsString;
    s_code   := Query1.FieldByName('OUPT_code').AsString;
    s_lotno  := Query1.FieldByName('OUPT_lotno').AsString;
end;

procedure TFrm_4300.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_4300.FormDestroy(Sender: TObject);
begin
  Frm_4300 := Nil;
end;

procedure TFrm_4300.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_4300.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '미 출고 현황');
 end;
end;


procedure TFrm_4300.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin

      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;


procedure TFrm_4300.SelRGClick(Sender: TObject);
begin
   StartBitBtnClick(Self);
end;

procedure TFrm_4300.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    ls_use, Value, ls_rsrv : String;
    WW     : Integer;
    xDBGrid: TDBGrid;
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

procedure TFrm_4300.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_4300.MouseWheelHandler(var Message: TMessage);
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



procedure TFrm_4300.QRBand3BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  //  QRAsBarcode1.Text  := Query1.FieldByName('OUPT_Index').AsString;
end;

{
procedure TFrm_4300.ReservedSBClick(Sender: TObject);
var
   var_sql, var_Msg : String;
   intPos : Integer;
begin
  if Dbgrid1.SelectedRows.Count = 0 then Exit;

  var_Msg :=  ' 제품을 출고 완료  하시겠습니까?...';
  if Not WinLib_ConfirmForm( var_Msg ) then Exit;

  For intPos := 1 To DBGrid1.SelectedRows.Count Do Begin
      With DBGrid1.DataSource.DataSet Do Begin
        If DBGrid1.SelectedRows.Count > 0 Then Begin
           gotobookmark(pointer(DBGrid1.SelectedRows.items[intpos -1]));
           s_index   := Query1.FieldByName('OUPT_INDEX').AsString;
           s_code    := Query1.FieldByName('OUPT_CODE').AsString;
           s_lotno   := Query1.FieldByName('OUPT_LOTNO').AsString;
           s_cust    := Query1.FieldByName('OUPT_CUST').AsString;
           s_qty     := Query1.FieldByName('OUPT_WGT').AsString;
           s_rqty    := Query1.FieldByName('OUPT_OUT_WGT').AsString;
           s_boxno   := Query1.FieldByName('OUPT_BOXNO').AsString;
           s_loca    := Query1.FieldByName('OUPT_LOCA').AsString;
           s_remark  := Query1.FieldByName('OUPT_REMARK').AsString;
           s_pltno   := Query1.FieldByName('OUPT_PLTNO').AsString;
           Outlet_complete_proc;
        End;
      End;
    End;

    StartBitBtnClick(Self);  
end;
}

procedure TFrm_4300.ReservedSBClick(Sender: TObject);
var
   var_sql, var_Msg : String;
   intPos : Integer;
   ls_pltno_check : String;
   cnt_same_plt : Integer;
begin
  if Dbgrid1.SelectedRows.Count = 0 then Exit;

  // [추가] 선택된 행의 PLTNO 확인 및 동일 파렛트 건수 조회
  // (첫 번째 선택된 행 기준으로 파렛트 번호를 가져와서 확인)
  ls_pltno_check := '';
  cnt_same_plt := 0;
  
  if Dbgrid1.SelectedRows.Count > 0 then
  begin
      With DBGrid1.DataSource.DataSet do 
      begin
          gotobookmark(pointer(DBGrid1.SelectedRows.items[0]));
          ls_pltno_check := FieldByName('OUPT_PLTNO').AsString;
      end;
      
      if ls_pltno_check <> '' then
      begin
          // 같은 파렛트에 몇 건의 미처리 지시가 있는지 확인
          var_sql := ' SELECT COUNT(*) FROM T2MIOUPT (NOLOCK) ';
          var_sql := var_sql + ' WHERE OUPT_PLTNO = ''' + ls_pltno_check + ''' ';
          var_sql := var_sql + '   AND OUPT_JOB_FLAG = ''0'' ';
          
          with Query2 do begin
             Close; SQL.Clear; SQL.Add(var_sql); Open;
             cnt_same_plt := Fields[0].AsInteger;
          end;
      end;
  end;

  // [메시지 분기 처리]
  if cnt_same_plt > 1 then
  begin
      var_Msg := '선택하신 파렛트(' + ls_pltno_check + ')에는 총 ' + IntToStr(cnt_same_plt) + '건의 출고 지시가 있습니다.' + #13#10 +
                 '이 작업은 해당 파렛트의 [모든 품목]을 일괄 출고 완료 처리합니다.' + #13#10 + #13#10 +
                 '계속 진행하시겠습니까?';
  end
  else
  begin
      var_Msg := '제품을 출고 완료 하시겠습니까?';
  end;

  if Not WinLib_ConfirmForm(var_Msg) then Exit;


  // [기존 로직 수행]
  For intPos := 1 To DBGrid1.SelectedRows.Count Do Begin
      With DBGrid1.DataSource.DataSet Do Begin
        If DBGrid1.SelectedRows.Count > 0 Then Begin
           gotobookmark(pointer(DBGrid1.SelectedRows.items[intpos -1]));
           s_index    := Query1.FieldByName('OUPT_INDEX').AsString;
           s_code     := Query1.FieldByName('OUPT_CODE').AsString;
           s_lotno    := Query1.FieldByName('OUPT_LOTNO').AsString;
           s_cust     := Query1.FieldByName('OUPT_CUST').AsString;
           s_qty      := Query1.FieldByName('OUPT_WGT').AsString;
           s_rqty     := Query1.FieldByName('OUPT_OUT_WGT').AsString;
           s_boxno    := Query1.FieldByName('OUPT_BOXNO').AsString;
           s_loca     := Query1.FieldByName('OUPT_LOCA').AsString;
           s_remark   := Query1.FieldByName('OUPT_REMARK').AsString;
           s_pltno    := Query1.FieldByName('OUPT_PLTNO').AsString;
           
           Outlet_complete_proc;
        End;
      End;
  End;

  StartBitBtnClick(Self);  
end;

{
procedure TFrm_4300.Outlet_complete_proc;
var
    ls_sql, ls_date, ls_time, sys_date, step : String;
begin
// sys_date  :=  Formatdatetime('yyyymmddhhnnss', now);

  sys_date :=  f_get_sysdate_time1();
  ls_date := Copy(sys_date,1,8);
  ls_time := Copy(sys_date,9,6);


 Try
    var_sql := ' select * from T2MISUBK (NOLOCK) where SUBK_LOCA = '''+s_loca+'''  ';
    var_sql := var_sql + ' And  SUBK_CODE   = '''+s_code+'''    ';
    var_sql := var_sql + ' And  SUBK_LOTNO  = '''+s_lotno+''' ';
    var_sql := var_sql + ' And  SUBK_RWGT >= '''+s_rqty+''' ';
    with UpdtQuery do begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      open;
      First;
      if Recordcount = 0  then  exit;
    end;


    step := '1';

    var_sql := ' UPDATE  T2MISUBK SET  SUBK_FLAG = ''1'', SUBK_WGT = SUBK_WGT - '''+s_rqty+''', SUBK_RWGT = SUBK_RWGT - '''+s_rqty+''', ';
    var_sql := var_sql + '    SUBK_BOXNO = '''+s_boxno+''',   SUBK_REMARK = '''+s_remark+'''  ';
    var_sql := var_sql + ' Where  SUBK_LOCA = '''+s_loca+'''   And  SUBK_CODE   = '''+s_code+'''    ';
    var_sql := var_sql + '  And SUBK_LOTNO  = '''+s_lotno+''' ';
    with UpdtQuery  do
    begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      ExecSQL;
    end;


    step := '2';

    var_sql := ' update T2MIOUPT set oupt_time   = '''+ls_time+''', oupt_job_flag = ''C''   ';
    var_sql := var_sql + ' where  oupt_index  = '''+s_index+'''   And  oupt_code  = '''+s_code+'''    ';
    var_sql := var_sql + ' And oupt_lotno  = '''+s_lotno+'''  And oupt_cust = '''+s_cust+''' ';
    with UpdtQuery  do
    begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      ExecSQL;
    end;


    step := '3';
    var_sql := ' Delete from  T2MISUBK  ';
    var_sql := var_sql + ' Where  SUBK_LOCA = '''+s_loca+'''   And  SUBK_CODE   = '''+s_code+'''    ';
    var_sql := var_sql + '    And SUBK_LOTNO  = '''+s_lotno+'''  And SUBK_WGT = ''0'' ';
    with UpdtQuery  do
    begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      ExecSQL;
    end;


    ////////////////////////////////////////////////////////////////////////////////////

    step := '4';

    var_sql := ' select * from T2MISUBK (NOLOCK) where subk_loca = '''+s_loca+'''  ';
    with Query2 do begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      open;
      First;
      if Recordcount = 0  then
      begin
         var_sql := '  update T2MILSTK set  lstk_flag = ''0'',  lstk_indate = '''', lstk_intime = '''', lstk_pltno = '''' ';  
         var_sql := var_sql + '   where  lstk_loca = '''+s_loca+''' ';
         with UpdtQuery  do
           begin
           Close;
           SQL.Clear;
           SQL.Add(var_sql);
           ExecSQL;
           exit;
         end;
     end;
   end;


   step := '5';   

   var_sql := '  update T2MILSTK set  lstk_flag = ''1'' ';
   var_sql := var_sql + '   where  lstk_loca = '''+s_loca+''' ';
   with UpdtQuery  do
   begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      ExecSQL;
   end;

 except
      WinLib_ErrorForm('Subk Insert Error =' + s_code + ' = ' + s_loca +  ' step = ' + step);
      
 end;
end;
}

procedure TFrm_4300.Outlet_complete_proc;
var
    ls_sql, ls_date, ls_time, sys_date, step : String;
    ls_pltno : String;
    
    // 루프 처리용 변수
    LoopCode, LoopLot, LoopBox : String;
    LoopRQty : Double;
begin
  // [0] 필수 데이터 체크
  if (Trim(s_loca) = '') or (Trim(s_index) = '') then
  begin
      WinLib_ErrorForm('필수 데이터(위치, 지시번호)가 누락되었습니다.');
      Exit;
  end;

  sys_date := f_get_sysdate_time1();
  ls_date  := Copy(sys_date, 1, 8);
  ls_time  := Copy(sys_date, 9, 6);

  // [Step 0] 작업 대상 파렛트 번호(PLTNO) 확보
  // 그리드에 없으면 DB에서 찾기
  ls_pltno := s_pltno;
  if Trim(ls_pltno) = '' then 
  begin
      var_sql := ' select MAX(SUBK_PLTNO) as PLTNO from T2MISUBK (NOLOCK) where SUBK_LOCA = '''+s_loca+''' ';
      with Query2 do begin  // Query2 등 여분의 쿼리 컴포넌트 사용
        Close; SQL.Clear; SQL.Add(var_sql); open;
        ls_pltno := FieldByName('PLTNO').AsString;
      end;
  end;

  if Trim(ls_pltno) = '' then
  begin
      WinLib_ErrorForm('파렛트 번호를 찾을 수 없습니다.');
      Exit;
  end;

  Try
    // =========================================================================
    // [Step 1] 해당 파렛트의 모든 출고 지시를 조회하여 일괄 처리 (Loop)
    // =========================================================================
    step := '1_Loop';
    
    // 같은 INDEX, 같은 PLTNO를 가진 미처리('0') 지시를 모두 가져옴
    var_sql := ' SELECT OUPT_CODE, OUPT_LOTNO, OUPT_BOXNO, OUPT_OUT_WGT, OUPT_CUST ';
    var_sql := var_sql + ' FROM T2MIOUPT (NOLOCK) ';
    var_sql := var_sql + ' WHERE OUPT_INDEX = ''' + s_index + ''' ';
    var_sql := var_sql + '   AND OUPT_PLTNO = ''' + ls_pltno + ''' ';
    var_sql := var_sql + '   AND OUPT_JOB_FLAG = ''0'' '; 

    with Query2 do begin
       Close; SQL.Clear; SQL.Add(var_sql); Open;
       
       while not Eof do 
       begin
          LoopCode := FieldByName('OUPT_CODE').AsString;
          LoopLot  := FieldByName('OUPT_LOTNO').AsString;
          LoopBox  := FieldByName('OUPT_BOXNO').AsString;
          LoopRQty := FieldByName('OUPT_OUT_WGT').AsFloat; // 차감할 수량

          // 1-1. T2MISUBK 수량 차감 (해당 품목에 대해서만)
          // 출고예약량(RWGT)과 실재고(WGT) 모두 차감
          var_sql := ' UPDATE T2MISUBK SET ';
          var_sql := var_sql + '    SUBK_WGT  = SUBK_WGT - ' + FloatToStr(LoopRQty) + ', ';
          var_sql := var_sql + '    SUBK_RWGT = SUBK_RWGT - ' + FloatToStr(LoopRQty) + ' '; 
          var_sql := var_sql + ' WHERE SUBK_PLTNO = ''' + ls_pltno + ''' ';
          var_sql := var_sql + '   AND SUBK_CODE  = ''' + LoopCode + ''' ';
          var_sql := var_sql + '   AND SUBK_LOTNO = ''' + LoopLot + ''' ';
          
          with UpdtQuery do begin Close; SQL.Clear; SQL.Add(var_sql); ExecSQL; end;

          // 1-2. T2MIOUPT 완료 처리 ('C')
          var_sql := ' UPDATE T2MIOUPT SET ';
          var_sql := var_sql + '    OUPT_JOB_FLAG = ''C'', ';
          var_sql := var_sql + '    OUPT_TIME = ''' + ls_time + ''' ';
          var_sql := var_sql + ' WHERE OUPT_INDEX = ''' + s_index + ''' ';
          var_sql := var_sql + '   AND OUPT_PLTNO = ''' + ls_pltno + ''' ';
          var_sql := var_sql + '   AND OUPT_CODE  = ''' + LoopCode + ''' ';
          var_sql := var_sql + '   AND OUPT_LOTNO = ''' + LoopLot + ''' ';
          
          with UpdtQuery do begin Close; SQL.Clear; SQL.Add(var_sql); ExecSQL; end;

          Next;
       end;
    end;


    // =========================================================================
    // [Step 2] 재고 정리 (전량 출고된 것 삭제 & 남은 것 위치 비움)
    // =========================================================================
    
    // 2-1. 수량이 0 이하가 된 것은 삭제 (완전 출고됨)
    step := '2_Delete';
    var_sql := ' DELETE FROM T2MISUBK ';
    var_sql := var_sql + ' WHERE SUBK_PLTNO = ''' + ls_pltno + ''' ';
    var_sql := var_sql + '   AND SUBK_WGT <= 0.001 '; // 부동소수점 오차 고려 0 이하 삭제

    with UpdtQuery do begin
      Close; SQL.Clear; SQL.Add(var_sql); ExecSQL;
    end;

    // 2-2. 아직 남아있는 재고는 위치를 비우고 'R'(재입고) 상태로 변경
    // (스태커 크레인 위에 떠 있는 상태가 됨)
    step := '2_Update';
    var_sql := ' UPDATE T2MISUBK SET ';
    var_sql := var_sql + '     SUBK_LOCA = '''', ';      // 위치 정보 삭제
    var_sql := var_sql + '     SUBK_FLAG = ''R'' ';      // 재입고 대기
    var_sql := var_sql + ' WHERE SUBK_PLTNO = ''' + ls_pltno + ''' ';
    // (이미 0인 것은 위에서 지웠으므로 조건 불필요)

    with UpdtQuery do begin
      Close; SQL.Clear; SQL.Add(var_sql); ExecSQL;
    end;


    // =========================================================================
    // [Step 3] 랙 마스터 & 스케줄 정리
    // =========================================================================
    
    // 3-1. 랙 마스터 초기화 (빈 셀)
    step := '3_Master';
    var_sql := ' UPDATE T2MILSTK SET ';
    var_sql := var_sql + '     LSTK_FLAG    = ''0'', ';
    var_sql := var_sql + '     LSTK_INDATE = '''', ';
    var_sql := var_sql + '     LSTK_INTIME = '''', ';
    var_sql := var_sql + '     LSTK_PLTNO  = '''' ';
    var_sql := var_sql + ' WHERE LSTK_LOCA = ''' + s_loca + ''' ';
    
    with UpdtQuery do begin
      Close; SQL.Clear; SQL.Add(var_sql); ExecSQL;
    end;

    // 3-2. 스케줄 삭제
    step := '3_Sche';
    var_sql := ' DELETE FROM T2TISCHE1 ';  // 테이블명 확인 (T2TISCHE or T2TISCHE1)
    var_sql := var_sql + ' WHERE SCHE_PLTNO = ''' + ls_pltno + ''' ';

    with UpdtQuery do begin
       Close; SQL.Clear; SQL.Add(var_sql); ExecSQL;
    end;

 except
      WinLib_ErrorForm('Outlet Complete Error Loca=' + s_loca + ' Step=' + step);
 end;
end;



function TFrm_4300.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl (NOLOCK) ';
    With Query2 Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      ls_date    := Fields[0].AsString;
    End;

    ls := trim(ls_date);
    ls_date := Copy(ls, 1, 4)  + Copy(ls, 6, 2)  + Copy(ls, 9, 2) + Copy(ls, 12, 2) + Copy(ls, 15, 2) + Copy(ls, 18, 2);

    Result :=  ls_date;
end;

procedure TFrm_4300.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

end.

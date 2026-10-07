unit Frm3300;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, DB,
  DBTables, ADODB, QRCtrls, QuickRpt;

type
  TFrm_3300 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ExlBtn: TSpeedButton;
    DeleteBitBtn: TSpeedButton;
    UpdtQuery: TADOQuery;
    StartBitBtn: TSpeedButton;
    RecNoEdit: TEdit;
    PrintBitBtn: TSpeedButton;
    LabelPrintBitBtn: TSpeedButton;
    Query2: TADOQuery;
    Query3: TADOQuery;
    CLabelPrintBitBtn: TSpeedButton;
    Query1: TADOQuery;
    Query1INPT_INDATE: TStringField;
    Query1INPT_STIME: TStringField;
    Query1INPT_LOCA: TStringField;
    Query1INPT_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1INPT_LOTNO: TStringField;
    Query1INPT_WEIGHT: TBCDField;
    Query1INPT_INDEX: TStringField;
    Query1INPT_BOXNO: TStringField;
    Query1INPT_REMARK: TStringField;
    Query1INPT_ETIME: TStringField;
    Query1INPT_JOB_FLAG: TStringField;
    Query1INPT_ID: TStringField;
    Query1INPT_LABEL: TStringField;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText5: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel6: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel4: TQRLabel;
    Query1INPT_HOGI: TStringField;
    Query1INPT_PLTNO: TStringField;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);  
    procedure PrintBitBtnClick(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure LabelPrintBitBtnClick(Sender: TObject);
    procedure CLabelPrintBitBtnClick(Sender: TObject);
  

  private
    { Private declarations }
    procedure Inlet_Label_print;
    procedure Inlet_Label_print1;        
    function f_get_sysdate_time1(): String;
    procedure MouseWheelHandler(var Message: TMessage); override;
  public
    { Public declarations }
  end;

var
  Frm_3300: TFrm_3300;

  var_Sql : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate : String;
  StrDate1, StrDate2, s_index, s_code, s_lotno, s_qty, s_boxno, s_name, s_loca : String;
  s_remark : string;

implementation

uses WinLib, FrmPrompt, FrmError, DbSet, FrmProgress;

{$R *.dfm} 


procedure TFrm_3300.FormCreate(Sender: TObject);
begin
  if (jj_kind <> '50') then
  begin
    DeleteBitBtn.Visible    := False;   
  end;


  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  StartBitBtnClick(Self);
end;


procedure TFrm_3300.StartBitBtnClick(Sender: TObject);
begin
  var_Sql := ' Select INPT_INDATE, INPT_INDEX,  INPT_CODE, MAST_NAME, INPT_LOTNO,  ';
  var_Sql := var_Sql + ' INPT_WEIGHT,  INPT_REMARK, INPT_HOGI, INPT_LOCA, INPT_BOXNO,  ';
  var_Sql := var_Sql + ' INPT_STIME,  INPT_ETIME,  INPT_JOB_FLAG, INPT_ID, INPT_LABEL, INPT_PLTNO ';
  var_Sql := var_Sql + ' From T2MIINPT (NOLOCK) ';
  var_Sql := var_Sql + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = INPT_CODE ';
  var_Sql := var_Sql + ' Where INPT_JOB_FLAG = ''0'' ';
  var_Sql := var_Sql + ' Order by  INPT_INDEX,  INPT_CODE  '; 

  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
  end;
  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);
end;

procedure TFrm_3300.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    s_index := Query1.FieldByName('INPT_INDEX').AsString;
    s_code  := Query1.FieldByName('INPT_CODE').AsString;
    s_lotno := Query1.FieldByName('INPT_LOTNO').AsString;
end;   

procedure TFrm_3300.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '미 입고  현황');
 end;
end;

procedure TFrm_3300.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_3300.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_3300.FormDestroy(Sender: TObject);
begin
  Frm_3300 := Nil;
end;

procedure TFrm_3300.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_3300.DeleteBitBtnClick(Sender: TObject);
var
   var_sql, var_Msg, ls_seqid, ls_code, ls_lotno, ls_index, ls_loca : String;
   intPos : Integer;
begin
  if Dbgrid1.SelectedRows.Count = 0 then Exit;

  var_Msg := ' 입고 이력  데이타를 삭제 하겠습니까??';
  If Not WinLib_ConfirmForm( var_Msg ) Then Begin  Exit;    End;


  For intPos := 1 To DBGrid1.SelectedRows.Count Do Begin
      With DBGrid1.DataSource.DataSet Do Begin
        If DBGrid1.SelectedRows.Count > 0 Then Begin
           gotobookmark(pointer(DBGrid1.SelectedRows.items[intpos -1]));
//           DBgrid1.SelectedRows.Delete;
           ls_code     := Query1.FieldByName('INPT_CODE').AsString;
           ls_lotno    := Query1.FieldByName('INPT_LOTNO').AsString;
           ls_index    := Query1.FieldByName('INPT_INDEX').AsString;
           ls_loca     := Query1.FieldByName('INPT_LOCA').AsString;

           Query2.Close;
           Query2.SQL.Clear;
           Query2.SQL.Add(' Delete From T2MIINPT Where INPT_CODE    = '''+ls_code+'''  ');
           Query2.SQL.Add(' And INPT_LOTNO   = '''+ls_lotno+''' And INPT_INDEX   = '''+ls_index+'''  ');
           Query2.ExecSQL;

           Query2.Close;
           Query2.SQL.Clear;
           //Query2.SQL.Add(' Update T2MILSTK Set LSTK_FLAG = ''0''  Where LSTK_FLAG = ''X'' And LSTK_LOCA  = '''+ls_loca+'''  '); // 기존
           Query2.SQL.Add(' Update T2MILSTK Set LSTK_FLAG = ''0'', LSTK_PLTNO = ''''  Where LSTK_FLAG = ''X'' And LSTK_LOCA  = '''+ls_loca+'''  '); // 입고 예약중인 상태인 입고이력 삭제시 PLTNO 초기화 김준영 추가 

           Query2.ExecSQL;
        End;
      End;
    End;
    Dbgrid1.SelectedRows.Clear;
    StartBitBtnClick(Self);

{
  var_Msg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From T2MIINPT Where INPT_CODE    = '''+s_code+'''  ';
    var_sql := var_sql + '            And INPT_LOTNO   = '''+s_lotno+'''   ';
    var_sql := var_sql + '            And INPT_INDEX   = '''+s_index+'''    ';

    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('미 입고이력 ' + s_code + ' 삭제 에러!!!! ');
      Exit;
    End;
    StartBitBtnClick(Self);
  end;
}
end;


procedure TFrm_3300.DBGrid1DrawColumnCell(Sender: TObject;
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

procedure TFrm_3300.DBGrid1TitleClick(Column: TColumn);
begin
    if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_3300.MouseWheelHandler(var Message: TMessage);
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


procedure TFrm_3300.LabelPrintBitBtnClick(Sender: TObject);
var
  intPos   : Integer;
begin
 if MessageDlg('입고라벨을 발행합니까?.?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then  Exit;

  For intPos := 1 To DBGrid1.SelectedRows.Count Do Begin
      With DBGrid1.DataSource.DataSet Do Begin
        If DBGrid1.SelectedRows.Count > 0 Then Begin
           gotobookmark(pointer(DBGrid1.SelectedRows.items[intpos -1]));
           s_index   := Query1.FieldByName('INPT_INDEX').AsString;
           s_code    := Query1.FieldByName('INPT_CODE').AsString;
           s_lotno   := Query1.FieldByName('INPT_LOTNO').AsString;
           s_qty     := Query1.FieldByName('INPT_WEIGHT').AsString;
           s_boxno   := Query1.FieldByName('INPT_BOXNO').AsString;
           s_loca    := Query1.FieldByName('INPT_LOCA').AsString;
           Inlet_Label_print;;
        End;
      End;
    End;

    StartBitBtnClick(Self);
end;

procedure TFrm_3300.Inlet_Label_print;
var
    ls_sql, ls_date, ls_time : String;
begin
    var_sql := ' Update  T2MIINPT SET  INPT_LABEL = ''N''  Where INPT_CODE    = '''+s_code+'''  ';
    var_sql := var_sql + '            And INPT_LOTNO   = '''+s_lotno+'''   ';
    var_sql := var_sql + '            And INPT_INDEX   = '''+s_index+'''    ';

    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('미 입고이력 ' + s_code + ' UPDATE  에러!!!! ' + var_sql);
      Exit;
    End;

{
    ls_sql := ' SELECT  *  FROM MIMAST (NOLOCK) WHERE MAST_CODE = '''+s_code+''' ';
    with Query2  do
    begin
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        Open;
        First;
        if (RecordCount = 0) then
        begin
           WinLib_ErrorForm(' 제품코드가 업습니다.. 등록후 다시하세요 = ' + s_code);      exit;
        end;
        s_name := Trim(FieldByName('MAST_NAME').AsString);
     end;

     ls_date := FormatDateTime('yyyymmdd', now);
     ls_time := FormatDateTime('hhmmss', now);


    ls_sql := ' Insert Into TILABL (LABL_INDEX,   LABL_CODE, LABL_LOTNO, LABL_NAME,     ';
    ls_sql := ls_sql + '             LABL_QTY,    LABL_BOXNO, LABL_LOCA, LABL_DATE, LABL_TIME )';
    ls_sql := ls_sql + ' Values ( '''+s_index+''', '''+s_code+''', '''+s_lotno+''', '''+s_name+''', ';
    ls_sql := ls_sql + '          '''+s_qty+''',   '''+s_boxno+''',    '''+s_loca+''', '''+ls_date+''', '''+ls_time+''' ) ';
    with Query3  do
    begin
      Try
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        ExecSQL;
      except      
          Showmessage('TILABL insert Error =' + ls_sql);   Exit;
      end;
    end;

    var_sql := ' Update  T2MIINPT SET  INPT_LABEL = ''Y''  Where INPT_CODE    = '''+s_code+'''  ';
    var_sql := var_sql + '            And INPT_LOTNO   = '''+s_lotno+'''   ';
    var_sql := var_sql + '            And INPT_INDEX   = '''+s_index+'''    ';

    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('미 입고이력 ' + s_code + ' UPDATE  에러!!!! ');
      Exit;
    End;
}
end;

procedure TFrm_3300.CLabelPrintBitBtnClick(Sender: TObject);
var
  intPos   : Integer;
begin
 if MessageDlg('입고라벨을 발행완료 합니까?.?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then  Exit;

  For intPos := 1 To DBGrid1.SelectedRows.Count Do Begin
      With DBGrid1.DataSource.DataSet Do Begin
        If DBGrid1.SelectedRows.Count > 0 Then Begin
           gotobookmark(pointer(DBGrid1.SelectedRows.items[intpos -1]));
           s_index   := Query1.FieldByName('INPT_INDEX').AsString;
           s_code    := Query1.FieldByName('INPT_CODE').AsString;
           s_lotno   := Query1.FieldByName('INPT_LOTNO').AsString;
           s_qty     := Query1.FieldByName('INPT_WEIGHT').AsString;
           s_boxno   := Query1.FieldByName('INPT_BOXNO').AsString;
           s_loca    := Query1.FieldByName('INPT_LOCA').AsString;
           Inlet_Label_print1;
        End;
      End;
    End;

    StartBitBtnClick(Self);
end;

procedure TFrm_3300.Inlet_Label_print1;
var
    ls_sql, ls_date, ls_time : String;
begin
    var_sql := ' Update  T2MIINPT SET  INPT_LABEL = ''Y''  Where INPT_CODE    = '''+s_code+'''  ';
    var_sql := var_sql + '            And INPT_LOTNO   = '''+s_lotno+'''   ';
    var_sql := var_sql + '            And INPT_INDEX   = '''+s_index+'''    ';

    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('미 입고이력 ' + s_code + ' UPDATE  에러!!!! ');
      Exit;
    End;
end;



function TFrm_3300.f_get_sysdate_time1(): String;
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

end.

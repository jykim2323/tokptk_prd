unit Frm4201;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Grids, DBGrids, StdCtrls, ComCtrls, GradRoundBtn, ExtCtrls,
  ADODB;

type
  TFrm_4201 = class(TForm)
    Panel6: TPanel;
    GradRoundBtn1: TGradRoundBtn;
    InsertBtn: TGradRoundBtn;
    CloseBtn: TGradRoundBtn;
    Panel19: TPanel;
    Panel3: TPanel;
    Panel10: TPanel;
    Panel13: TPanel;
    BcStratBtn: TGradRoundBtn;
    CommitEdit: TEdit;
    Panel14: TPanel;
    Panel15: TPanel;
    DBGrid: TDBGrid;
    MesgStatusBar: TStatusBar;
    Panel16: TPanel;
    Panel17: TPanel;
    InitBtn: TGradRoundBtn;
    AutoBtn: TGradRoundBtn;
    SGrid: TStringGrid;
    Panel11: TPanel;
    DateTimePk: TDateTimePicker;
    Panel2: TPanel;
    Panel8: TPanel;
    JpNoEdit: TEdit;
    GateCB: TComboBox;
    Panel5: TPanel;
    Panel12: TPanel;
    Label1: TLabel;
    Frm4201_db: TADOConnection;
    BCQuery: TADOQuery;
    Query2: TADOQuery;
    Query3: TADOQuery;
    updateQuery: TADOQuery;
    SGrid1: TStringGrid;
    DataSource1: TDataSource;
    LocaQuery: TADOQuery;
    LocaQueryLOCA: TStringField;
    LocaQueryFLAG: TStringField;
    LocaQueryWCODE: TStringField;
    LocaQueryPCODE: TStringField;
    LocaQueryNAME: TStringField;
    LocaQueryPLTID: TStringField;
    LocaQueryPLTSN: TStringField;
    LocaQueryINDATE: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Cntl_TBbclSelect_Proc;
    procedure Cntl_MilstkSelect_Proc;
    procedure CloseBtnClick(Sender: TObject);    
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure Cntl_MilstkUpdate_Proc;      
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure InitBtnClick(Sender: TObject);
    procedure BcStratBtnClick(Sender: TObject);
    procedure AutoBtnClick(Sender: TObject);
    procedure InsertBtnClick(Sender: TObject);
    procedure Cntl_SerialSelect_proc;
    procedure SGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Cntl_TBStatSelect_Proc;

    function LP_JOBDATE():String;
    procedure SGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SGrid1DblClick(Sender: TObject);
    procedure SGrid1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_4201: TFrm_4201;

  s_fser : String[02];
  s_commit : String[04];
  s_loca  : Array [1..2] of String[06];
  s_LR    : Array [1..2] of String[01];
  s_model : Array [1..2] of String[10]; 
  s_bubun : Array [1..2] of String[13];

  s_sysdate : String[14];
  s_wcode,s_OTFLAG : String;
  s_index: String[04];
  s_date : String[08];
  s_time : String[06];

  pb_out_ok : Boolean;

implementation

uses WinLib, FrmPrompt, FrmError, Frm4200;

{$R *.DFM}

procedure TFrm_4201.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
end;

procedure TFrm_4201.FormCreate(Sender: TObject);
var
  i : Integer;
begin

  DateTimePk.Date := StrToDate(LP_JOBDATE());

  CommitEdit.Text := '0000';
  Cntl_TBStatSelect_Proc;
  Cntl_TBbclSelect_Proc;
  GateCB.Itemindex := 0;
  SGrid.Cells[0,0] := '순번';
  SGrid.Cells[1,0] := '열-연-단';
  SGrid.Cells[2,0] := '석';
  SGrid.Cells[3,0] := 'COMMIT';
  SGrid.Cells[4,0] := '모 델';
  SGrid.Cells[5,0] := '부 번';
  for i := 1 to 16 do
  begin
    SGrid.Cells[0,i] := IntToStr(i);
  end;

  SGrid1.Cells[1,0] := '순차';
  SGrid1.Cells[2,0] := '투입시각';
  SGrid1.Cells[3,0] := '차종';
  SGrid1.Cells[4,0] := 'COMMIT';
  SGrid1.Cells[5,0] := 'BODYNO';
  SGrid1.Cells[6,0] := '완제품코드';
  SGrid1.Cells[7,0] := '색상';
  SGrid1.Cells[8,0] := '구분';
end;

procedure TFrm_4201.Cntl_TBStatSelect_Proc;
var
  ls_SQL : String;   
begin
  ls_SQL := ' SELECT   STAT_ORSEQ  FROM  TBSTAT (NOLOCK)  WHERE STAT_PSWD = ''JPLS'' ';
  with Query2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ls_SQL);
    Open;
    First;
    jpnoEdit.Text := Format('%3.3d',[FieldByName('STAT_ORSEQ').AsInteger]);
  end;
end;

procedure TFrm_4201.Cntl_TBbclSelect_Proc;
var
  ls_SQL : String;
  ls_date : String[14];
  i, j, k : Integer;
begin
  for k := 1 to 11 do
  begin
    for j := 1 to 8 do
    begin
      SGrid1.Cells[k,j] := '';
    end;
  end;

  ls_SQL := ' Select  INDATE, CARGBN, SEQ, BODYNO, WCODE,  OUTCOLOR, ZFLAG ';
  ls_SQL := ls_SQL + ' From AS3ALC1 (NOLOCK) ';
  ls_SQL := ls_SQL + ' Where ZFLAG <> ''Y''  ';
  ls_SQL := ls_SQL + ' Order By SEQ ';

  with BCQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ls_SQL);
    Open;
    First;

    For i := 1 to 8 do
    begin
     if Eof  then  Break;
     SGrid1.Cells[1,i]  := IntToStr(i);
     ls_date            := FieldByName('INDATE').AsString;
     SGrid1.Cells[2,i]  := Copy(ls_date,1,4) + '-' +Copy(ls_date,5,2) + '-' +Copy(ls_date,7,2) + ' ' +
                           Copy(ls_date,9,2) + ':' +Copy(ls_date,11,2) + ':' +Copy(ls_date,13,2);
     SGrid1.Cells[3,i]  := FieldByName('CARGBN').AsString;
     SGrid1.Cells[4,i]  := FieldByName('SEQ').AsString;
     SGrid1.Cells[5,i]  := FieldByName('BODYNO').AsString;
     SGrid1.Cells[6,i]  := FieldByName('WCODE').AsString;
     if     i = 1  then  s_wcode :=  SGrid1.Cells[6,i];
     SGrid1.Cells[7,i]  := FieldByName('OUTCOLOR').AsString;
     SGrid1.Cells[8,i]  := FieldByName('ZFLAG').AsString;
     Next;
   end;
 end;

 if  Length(s_wcode) > 0   then Cntl_MilstkSelect_Proc;
end;


procedure TFrm_4201.SGrid1Click(Sender: TObject);
var
   StrMsg : String;
begin
   If SGrid1.Cells[6, SGrid1.Row] = '' Then Begin
    StrMsg := '조회할 데이타가 없습니다...'+#13#10+ ' 확인후 다시 시도 하십시요';
    WinLib_ErrorForm( StrMsg );  Exit;
    Exit;
  End;
  
  s_wcode := SGrid1.Cells[6, SGrid1.Row];
  Cntl_MilstkSelect_Proc;
end;

procedure TFrm_4201.Cntl_MilstkSelect_Proc;
var
  ls_SQL : String;
  ls_date : String[08];
  ls_assy : String;
begin
  try
    l_step := '31';

    ls_SQL := ' SELECT T1.LOCA, T1.FLAG, T1.WCODE, T1.PCODE,  ';
    ls_SQL := ls_SQL + ' T2.NAME AS NAME, T1.PLTID, T1.PLTSN, INDATE  ';
    ls_SQL := ls_SQL + ' FROM   MILSTK T1 (NOLOCK) LEFT OUTER JOIN ';
    ls_SQL := ls_SQL + ' MIMAST T2 ON T2.WCODE = T1.WCODE  ';
    ls_SQL := ls_SQL + ' WHERE T1.FLAG = ''1'' AND  T1.Wcode >= '''+s_wcode+'''  ';
    ls_SQL := ls_SQL + ' ORDER BY T1.INDATE ';  
    l_step := '35';

    with LocaQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ls_SQL);
      Open;
      First;
    End;

    l_step := '36';
   except
   ShowMessage('l_step = ' + ls_SQL);
   end;
  end;
end;


procedure TFrm_4201.SGrid1DblClick(Sender: TObject);
begin
   Cntl_MilstkUpdate_Proc;
end;


procedure TFrm_4201.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if (gdSelected in State) then
  begin
    DbGrid.Canvas.brush.Color := clAqua;
    DbGrid.Canvas.Font.Color  := clNavy;
  end;
  DbGrid.DefaultDrawColumnCell(Rect , Datacol, Column, State);
end;

procedure TFrm_4201.InitBtnClick(Sender: TObject);
var
  i, k : Integer;
  ls_loca : Array [1..16] of String;
  ls_commit : Array [1..16] of String;
  ls_date : Array [1..16] of String;
  ls_SQL : String;
  ls_loc : String;
begin
  if MessageDlg(' 정말로 초기화를 실행합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    for i := 1 to 16 do
    begin
      if (Length(SGrid.Cells[1,1]) = 0) then
      Begin
        Showmessage('초기화 실행할 내용이 없습니다.!!');
        exit;
      end;
    
      ls_loca[i]   :=  SGrid.Cells[1,i];
      ls_commit[i] :=  SGrid.Cells[3,i];
      ls_date[i]   :=  SGrid.Cells[6,i];

      Query3.Close;
      Query3.SQL.Clear;
      Query3.SQL.Add(' Select * from tbbcl ');
      Query3.SQL.Add(' where log_date = '''+ls_date[i]+''' and commit_no = '''+ls_commit[i]+''' ');
      Query3.Open;

      if Query3.RecordCount <> 0 then
      begin
        l_step := '47';

        ls_SQL := ' UPDATE TBBCL SET OTSUB_FLAG = ''N'' ';
        ls_SQL := ls_SQL + ' WHERE LOG_DATE = '''+ls_date[i]+''' AND COMMIT_NO  = '''+ls_commit[i]+'''  ';

        UpdateQuery.Close;
        UpdateQuery.SQL.Clear;
        UpdateQuery.SQL.Add(ls_SQL);
        UpdateQuery.ExecSQL;
      end;

      if (Length(ls_loca[i]) <> 0) then
      begin
        ls_loc := Copy(ls_loca[i], 1, 2) + Copy(ls_loca[i], 4, 2) + Copy(ls_loca[i], 7, 2) ;
        ls_SQL := ' UPDATE MILSTK SET LSTK_FLAG = ''1'' WHERE LSTK_LOCA = '''+ls_loc+'''  ';

        UpdateQuery.Close;
        UpdateQuery.SQL.Clear;
        UpdateQuery.SQL.Add(ls_SQL);
        UpdateQuery.ExecSQL;
      end;
    end;

    for k := 1 to 6 do
    begin
      for i := 1 to 16 do
      begin
        SGrid.Cells[k,i] := '';
      end;
    end;
    CommitEdit.Text := '0000';
    Cntl_TBbclSelect_Proc;
    Cntl_MilstkSelect_Proc;
  end;
end;

procedure TFrm_4201.BcStratBtnClick(Sender: TObject);
begin
  Cntl_TBbclSelect_Proc;
end;

procedure TFrm_4201.AutoBtnClick(Sender: TObject);
var
  ls_SQL : String;
  ls_date : String[08];
  i : Integer;
begin
  if MessageDlg(' 자동설정을 실행합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if Length(SGrid.Cells[1,1]) <> 0 then
    begin
      Showmessage('출고예약이  있습니다. 확인후 출고예약을 하십시요.');
      exit;
    end;

    pb_out_ok := True;
    ls_date := FormatDateTime('yyyymmdd', DateTimePk.Date);

    ls_SQL := ' Select  INDATE, CARGBN, SEQ, BODYNO, WCODE,  OUTCOLOR, ZFLAG ';
    ls_SQL := ls_SQL + ' From AS3ALC1 (NOLOCK) ';
    ls_SQL := ls_SQL + ' Where ZFLAG <> ''Y''  ';
    ls_SQL := ls_SQL + ' Order By SEQ ';  

    Query3.Close;
    Query3.SQL.Clear;
    Query3.SQL.Add(ls_SQL);
    Query3.Open;
    Query3.First;

    if Query3.RecordCount < 8 then
    begin
      Showmessage('BC 수신(8) 부족합니다. 확인 후 실행바랍니다.!!');
      exit;
    end;

    i := 0;
    While TRue do
    begin
      i := i + 1;
      if (i = 9) or (pb_out_ok = False) then break;

      s_commit := Query3.FieldByName('Commit_no').AsString;
      s_date   := Query3.FieldByName('INDATE').AsString;
      Cntl_MilstkUpdate_Proc;
      Query3.Next;
    end;
  end;
end;

procedure TFrm_4201.Cntl_MilstkUpdate_Proc;
var
  ls_SQL : String;
  ls_date : String[08];
  ls_assy : String;
  i, k, t : Integer;
  LR : String[01];
  ls_OTFlag : String[01];
begin
  try
    pb_out_ok := True;

    if Length(SGrid.Cells[1,16]) <> 0 then
    begin
      Showmessage('출고예약을 설정을 마쳤습니다. 확인후 출고예약을 하십시요.');
      exit;
    end;


    for i := 1 to 2 do
    begin
      if i = 1 then LR := 'L' else  LR := 'R';
      ls_SQL := ' SELECT T1.LSTK_LOCA, T1.LSTK_FLAG, T1.LSTK_AGUBN, T1.LSTK_MODEL1, T1.LSTK_BUBUN1,  ';
      ls_SQL := ls_SQL + ' T2.PROD_NAME AS PROD_NAME1, T1.LSTK_COLOR1, T1.LSTK_MDATE1,  ';
      ls_SQL := ls_SQL + ' T1.LSTK_LINE1, T1.LSTK_LOT1, T1.LSTK_SEQNO1, T1.LSTK_MODEL2, ';
      ls_SQL := ls_SQL + ' T1.LSTK_BUBUN2, T3.PROD_NAME AS PROD_NAME2, T1.LSTK_COLOR2,  ';
      ls_SQL := ls_SQL + ' T1.LSTK_MDATE2, T1.LSTK_LINE2, T1.LSTK_LOT2, T1.LSTK_SEQNO2, ';
      ls_SQL := ls_SQL + ' T1.LSTK_MCODE, T1.LSTK_TCODE, T1.LSTK_PLT, CONVERT(varchar(10), ';
      ls_SQL := ls_SQL + ' CONVERT(datetime, T1.LSTK_DATE), 120) AS LSTK_DATE,  ';
      ls_SQL := ls_SQL + ' SUBSTRING(T1.LSTK_TIME, 1, 2) + '':'' + SUBSTRING(T1.LSTK_TIME, 3, 2) ';
      ls_SQL := ls_SQL + ' + '':'' + SUBSTRING(T1.LSTK_TIME, 5, 2) AS LSTK_TIME ';
      ls_SQL := ls_SQL + ' FROM      MILSTK T1 LEFT OUTER JOIN ';
      ls_SQL := ls_SQL + ' MIMAST T2 ON T2.PROD_CODE = T1.LSTK_MODEL1 LEFT OUTER JOIN ';
      ls_SQL := ls_SQL + ' MIMAST T3 ON T3.PROD_CODE = T1.LSTK_MODEL2  ';
      ls_SQL := ls_SQL + ' WHERE LSTK_FLAG = ''1'' AND SUBSTRING(T1.LSTK_MODEL1, 1, 5) = '''+ls_assy+'''  ';
      ls_SQL := ls_SQL + '   AND LSTK_AGUBN = '''+LR+''' ORDER BY T1.LSTK_DATE, T1.LSTK_TIME ';

      l_step := '35';

      LocaQuery.Close;
      LocaQuery.SQL.Clear;
      LocaQuery.SQL.Add(ls_SQL);
      LocaQuery.Open;

      l_step := '36';

      s_loca[i]  := LocaQuery.FieldByName('LSTK_LOCA').AsString;
      s_LR[i]    := LocaQuery.FieldByName('LSTK_AGUBN').AsString;
      s_model[i] := LocaQuery.FieldByName('LSTK_MODEL1').AsString;
      s_bubun[i] := LocaQuery.FieldByName('LSTK_BUBUN1').AsString;
    end;

    if (Length(s_loca[2]) = 0) then
    begin
      pb_out_ok := False;
      Showmessage('Location의 재고가 부족합니다. 확인후 등록하시기 바랍니다.');
      exit;
    end;

    if LocaQuery.RecordCount = 0 then
    begin
      pb_out_ok := False;
      Showmessage('Location의 재고가 없습니다. 확인후 등록하시기 바랍니다.');
      exit;
    end;   

    for k := 1 to 16 do
    begin
      if Length(SGrid.Cells[1,1]) = 0 then begin t := 0; break; end;
      if Length(SGrid.Cells[1,k]) = 0 then begin t := k - 1; break; end;
    end;

    for i := 1 to 2 do
    begin
      t := t + 1;
      l_step := '41';

      if i = 1 then LR := 'L' else  LR := 'R';
      ls_SQL := ' SELECT T1.LSTK_LOCA, T1.LSTK_FLAG, T1.LSTK_AGUBN, T1.LSTK_MODEL1, T1.LSTK_BUBUN1,  ';
      ls_SQL := ls_SQL + ' T2.PROD_NAME AS PROD_NAME1, T1.LSTK_COLOR1, T1.LSTK_MDATE1,  ';
      ls_SQL := ls_SQL + ' T1.LSTK_LINE1, T1.LSTK_LOT1, T1.LSTK_SEQNO1, T1.LSTK_MODEL2, ';
      ls_SQL := ls_SQL + ' T1.LSTK_BUBUN2, T3.PROD_NAME AS PROD_NAME2, T1.LSTK_COLOR2,  ';
      ls_SQL := ls_SQL + ' T1.LSTK_MDATE2, T1.LSTK_LINE2, T1.LSTK_LOT2, T1.LSTK_SEQNO2, ';
      ls_SQL := ls_SQL + ' T1.LSTK_MCODE, T1.LSTK_TCODE, T1.LSTK_PLT, CONVERT(varchar(10), ';
      ls_SQL := ls_SQL + ' CONVERT(datetime, T1.LSTK_DATE), 120) AS LSTK_DATE,  ';
      ls_SQL := ls_SQL + ' SUBSTRING(T1.LSTK_TIME, 1, 2) + '':'' + SUBSTRING(T1.LSTK_TIME, 3, 2) ';
      ls_SQL := ls_SQL + ' + '':'' + SUBSTRING(T1.LSTK_TIME, 5, 2) AS LSTK_TIME ';
      ls_SQL := ls_SQL + ' FROM      MILSTK T1 LEFT OUTER JOIN ';
      ls_SQL := ls_SQL + ' MIMAST T2 ON T2.PROD_CODE = T1.LSTK_MODEL1 LEFT OUTER JOIN ';
      ls_SQL := ls_SQL + ' MIMAST T3 ON T3.PROD_CODE = T1.LSTK_MODEL2  ';
      ls_SQL := ls_SQL + ' WHERE LSTK_FLAG = ''1'' AND SUBSTRING(T1.LSTK_MODEL1, 1, 5) = '''+ls_assy+'''  ';
      ls_SQL := ls_SQL + '   AND LSTK_AGUBN = '''+LR+''' ORDER BY T1.LSTK_DATE, T1.LSTK_TIME ';

      l_step := '42';

      LocaQuery.Close;
      LocaQuery.SQL.Clear;
      LocaQuery.SQL.Add(ls_SQL);
      LocaQuery.Open;

      l_step := '43';

      s_loca[i]  := LocaQuery.FieldByName('LSTK_LOCA').AsString;
      s_LR[i]    := LocaQuery.FieldByName('LSTK_AGUBN').AsString;
      s_model[i] := LocaQuery.FieldByName('LSTK_MODEL1').AsString;
      s_bubun[i] := LocaQuery.FieldByName('LSTK_BUBUN1').AsString;

      SGrid.Cells[1,t] := Copy(s_loca[i], 1, 2) + '-' + Copy(s_loca[i], 3, 2) + '-' + Copy(s_loca[i], 5, 2) ;
      SGrid.Cells[2,t] := s_LR[i];
      SGrid.Cells[3,t] := s_commit;
      SGrid.Cells[4,t] := s_model[i];
      SGrid.Cells[5,t] := s_bubun[i];
      SGrid.Cells[6,t] := s_sysdate;

      l_step := '46';

      ls_SQL := ' UPDATE MILSTK SET LSTK_FLAG = ''Y'' WHERE LSTK_LOCA = '''+s_loca[i]+'''  ';

      UpdateQuery.Close;
      UpdateQuery.SQL.Clear;
      UpdateQuery.SQL.Add(ls_SQL);
      UpdateQuery.ExecSQL;

      l_step := '47';

      ls_SQL := ' UPDATE TBBCL SET OTSUB_FLAG = ''Y'' ';
      ls_SQL := ls_SQL + ' WHERE LOG_DATE = '''+s_sysdate+''' AND COMMIT_NO  = '''+s_commit+'''  ';

      UpdateQuery.Close;
      UpdateQuery.SQL.Clear;
      UpdateQuery.SQL.Add(ls_SQL);
      UpdateQuery.ExecSQL;
    end;

    Cntl_TBbclSelect_Proc;
    Cntl_MilstkSelect_Proc;

    l_step := '36';
  except
  on E : EDBEngineError do
    begin
      if E.Errors[1].ErrorCode = 13059 then ShowMessage('l_step= ' + l_step + 'DB Error->' + E.Message)
      else ShowMessage('l_step = ' + l_step);
    end;
  end;
end;

procedure TFrm_4201.InsertBtnClick(Sender: TObject);
var
  ls_sql : String;
  ls_sc : String[01];
  ls_date : STring[08];
  ls_time : STring[06];
  ls_fact : String[02];
  ls_index : String[05];
  li_index, i, k, j : Integer;
  ls_loca : String[06];
  ls_commit : String[04];
  ls_agubn : String[01];
  ls_model1, ls_model2 : String[10];
  ls_bubun1, ls_bubun2 : String[13];
  ls_color1, ls_color2 : String[05];
  ls_mdate1, ls_mdate2 : String[06];
  ls_line1, ls_line2 : String[02];
  ls_lot1, ls_lot2 : String[02];
  ls_seqno1, ls_seqno2 : String[03];
  ls_plt : String[04];
  ls_mcode, ls_tcode : String[02];
begin
  try
    if (Length(SGrid.Cells[1,16]) = 0) then
    begin
      Showmessage('출고예약 수량이 부족합니다. 확인 후 등록하십시요');
      exit;
    end;
    
    if (Length(JpNoEdit.Text) <> 4) or (JpNoEdit.Text = '') then
    begin
      Showmessage('전표번호 4자리를 입력하세요.!!');
      JpNoEdit.SetFocus;
      exit;
    end;  


    if (Length(GateCB.Text) <> 1) or (GateCB.Text = '') then
    begin
      Showmessage('출고 GATE를 입력하세요.!!');
      GateCB.SetFocus;
      exit;
    end;

    if MessageDlg(' 집계표 등록을 실행합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      s_date := FormatDateTime('yyyymmdd', DateTimePk.Date);
      s_time := FormatDateTime('hhnnss', DateTimePk.Time);

      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add(' SELECT   * FROM TICHUL ');
      Query2.SQL.Add(' Where CHUL_DATE = '''+s_date+''' AND CHUL_NO = '''+JpnoEdit.Text+''' ');
      Query2.Open;

      If Query2.RecordCount > 0 Then
      begin
        Showmessage('이미 등록된 자료입니다. 기존의 정보를 삭제한 후 추가하거나 수정하시기 바랍니다.');
        exit;
      End;

     
      /////////////////////  TICHUL Insert ///////////////////

      ls_sql := ' INSERT INTO TICHUL(CHUL_DATE, CHUL_NO,  CHUL_KLINE, ';
      ls_sql := ls_sql + ' CHUL_GATE, CHUL_TIME, CHUL_FLOW) ';
      ls_sql := ls_sql + ' Values('''+s_date+''', '''+JpnoEdit.Text+''', Substring('''+s_date+''', 7, 2), ';
      ls_sql := ls_sql + '        '''+ls_fact+''',  '''+GateCB.Text+''', '''+s_time+''', ''N'') ';

      Query3.Close;
      Query3.SQL.Clear;
      Query3.SQL.Add(ls_SQL);
      Query3.ExecSQL;

      For i := 16 downto 1 do
      begin
        /////////////////////// TBSCHL Insert //////////////
        Cntl_SerialSelect_proc;

        li_index := 0;
        li_index := StrToInt(s_index);
        ls_index := 'O' + Format('%4.4d', [li_index]);

        ls_loca := Copy(SGrid.Cells[1,i], 1, 2) + Copy(SGrid.Cells[1,i], 4, 2) + Copy(SGrid.Cells[1,i], 7, 2) ;
        ls_commit := SGrid.Cells[3,i];

        Query2.Close;
        Query2.SQL.Clear;
        Query2.SQL.Add(' select * from milstk where lstk_loca = '''+ls_loca+''' ');
        Query2.Open;

        ls_agubn  := Query2.FieldByName('lstk_agubn').AsString;
        ls_model1 := Query2.FieldByName('lstk_model1').AsString;
        ls_bubun1 := Query2.FieldByName('lstk_bubun1').AsString;
        ls_color1 := Query2.FieldByName('lstk_color1').AsString;
        ls_mdate1 := Query2.FieldByName('lstk_mdate1').AsString;
        ls_line1  := Query2.FieldByName('lstk_line1').AsString;
        ls_lot1   := Query2.FieldByName('lstk_lot1').AsString;
        ls_seqno1 := Query2.FieldByName('lstk_seqno1').AsString;
        ls_model2 := Query2.FieldByName('lstk_model2').AsString;
        ls_bubun2 := Query2.FieldByName('lstk_bubun2').AsString;
        ls_color2 := Query2.FieldByName('lstk_color2').AsString;
        ls_mdate2 := Query2.FieldByName('lstk_mdate2').AsString;
        ls_line2  := Query2.FieldByName('lstk_line2').AsString;
        ls_lot2   := Query2.FieldByName('lstk_lot2').AsString;
        ls_seqno2 := Query2.FieldByName('lstk_seqno2').AsString;
        ls_mcode  := Query2.FieldByName('lstk_mcode').AsString;
        ls_tcode  := Query2.FieldByName('lstk_tcode').AsString;
        ls_plt    := Query2.FieldByName('lstk_plt').AsString;
        ls_date   := Query2.FieldByName('lstk_date').AsString;
        ls_time   := Query2.FieldByName('lstk_time').AsString;

        ls_sql := ' INSERT INTO TBSCHL ';
        ls_sql := ls_sql + ' (SCHL_DATE, SCHL_NO, SCHL_DD, SCHL_KLINE, SCHL_INDEX, SCHL_AGUBN, ';
        ls_sql := ls_sql + '  SCHL_MODEL1, SCHL_BUBUN1, SCHL_COLOR1, SCHL_MDATE1, SCHL_LINE1, SCHL_LOT1, SCHL_SEQNO1, ';
        ls_sql := ls_sql + '  SCHL_MODEL2, SCHL_BUBUN2, SCHL_COLOR2, SCHL_MDATE2, SCHL_LINE2, SCHL_LOT2, SCHL_SEQNO2, ';
        ls_sql := ls_sql + '  SCHL_LOCA, SCHL_MCODE,  SCHL_GATE, SCHL_COMMIT, SCHL_FSER, SCHL_USR_COLOR, ';
        ls_sql := ls_sql + '  SCHL_IDATE, SCHL_STIME, SCHL_ETIME, SCHL_PLT, SCHL_FLOW) ';
        ls_sql := ls_sql + ' Values('''+s_date+''',      '''+JpnoEdit.Text+''', Substring('''+ls_date+''', 7, 2), ';
        ls_sql := ls_sql + '        '''+ls_fact+''',     '''+ls_index+''',   '''+ls_agubn+''',  '''+ls_model1+''',  ';
        ls_sql := ls_sql + '        '''+ls_bubun1+''',   '''+ls_color1+''',  '''+ls_mdate1+''', '''+ls_line1+''',   ';
        ls_sql := ls_sql + '        '''+ls_lot1+''',     '''+ls_seqno1+''',  '''+ls_model2+''', '''+ls_bubun2+''',  ';
        ls_sql := ls_sql + '        '''+ls_color2+''',   '''+ls_mdate2+''',  '''+ls_line2+''',  '''+ls_lot2+''',    ';
        ls_sql := ls_sql + '        '''+ls_seqno2+''',   '''+ls_loca+''',    '''+ls_mcode+''',     ';
        ls_sql := ls_sql + '        '''+GateCB.Text+''', '''+ls_commit+''',  '''+ls_tcode+''',  '''+ls_color1+''',  ';
        ls_sql := ls_sql + '        '''+ls_date+''',     '''+ls_time+''',    NULL,    '''+ls_plt+''', ''N'')     ';

        UpdateQuery.Close;
        UpdateQuery.SQL.Clear;
        UpdateQuery.SQL.Add(ls_SQL);
        UpdateQuery.ExecSQL;

        if      (Copy(ls_loca, 1, 2) = '01') or (Copy(ls_loca, 1, 2) = '02') then ls_sc := '1'
        else if (Copy(ls_loca, 1, 2) = '03') or (Copy(ls_loca, 1, 2) = '04') then ls_sc := '2'
        else if (Copy(ls_loca, 1, 2) = '05') or (Copy(ls_loca, 1, 2) = '06') then ls_sc := '3'
        else if (Copy(ls_loca, 1, 2) = '07') or (Copy(ls_loca, 1, 2) = '08') then ls_sc := '4'
        else if (Copy(ls_loca, 1, 2) = '09') or (Copy(ls_loca, 1, 2) = '10') then ls_sc := '5';
        
        //-------------- 출고 이력 -----------------
        ls_SQL := ' Insert Into MIIOHT(IOHT_INDEX, IOHT_AGUBN, IOHT_MODEL1, IOHT_BUBUN1, IOHT_COLOR1, ';
        ls_SQL := ls_SQL + ' IOHT_MDATE1, IOHT_LINE1, IOHT_LOT1, IOHT_SEQNO1, IOHT_MODEL2,  ';
        ls_SQL := ls_SQL + ' IOHT_BUBUN2, IOHT_COLOR2, IOHT_MDATE2, IOHT_LINE2, IOHT_LOT2, IOHT_SEQNO2, ';
        ls_SQL := ls_SQL + ' IOHT_LOCA, IOHT_MCODE, IOHT_TCODE, IOHT_JPNO, IOHT_GATE, IOHT_COMMIT, ';
        ls_SQL := ls_SQL + ' IOHT_C001, IOHT_FSER, IOHT_USR_COLOR, IOHT_ASSY, IOHT_FLOW,  ';
        ls_SQL := ls_SQL + ' IOHT_BCR, IOHT_DATE, IOHT_STIME, IOHT_ETIME, IOHT_PLT, IOHT_CHK, IOHT_SYHG) ';
        ls_SQL := ls_SQL + ' Values('''+ls_index+''',   '''+ls_agubn+''',  '''+ls_model1+''',  '''+ls_bubun1+''',      ';
        ls_SQL := ls_SQL + '        '''+ls_color1+''',  '''+ls_mdate1+''', '''+ls_line1+''',   '''+ls_lot1+''',        ';
        ls_sql := ls_sql + '        '''+ls_seqno1+''',  '''+ls_model2+''', '''+ls_bubun2+''',  '''+ls_color2+''',      ';
        ls_sql := ls_sql + '        '''+ls_mdate2+''',  '''+ls_line2+''',  '''+ls_lot2+''',    '''+ls_seqno2+''',      ';
        ls_sql := ls_sql + '        '''+ls_loca+''',    '''+ls_mcode+''',  '''+ls_tcode+''',   '''+JpnoEdit.Text+''',  ';
        ls_SQL := ls_SQL + '          '''+GateCB.Text+''', '''+ls_commit+''', NULL,  ';
        ls_SQL := ls_SQL + '        NULL, '''+ls_color1+''', Substring('''+ls_model1+''', 1, 5), ''0'',     ';
        ls_SQL := ls_SQL + '        ''S'', '''+s_date+''',   '''+s_time+''', NULL, '''+ls_plt+''', NULL, '''+ls_sc+''') ';

        UpdateQuery.Close;
        UpdateQuery.SQL.Clear;
        UpdateQuery.SQL.Add(ls_SQL);
        UpdateQuery.ExecSQL;
      end;

      for k := 1 to 6 do
      begin
        for j := 1 to 16 do
        begin
          SGrid.Cells[k,j] := '';
        end;
      end;

      Showmessage('집게표 등록을 완료하였습니다.');
    end;
  except
  on E : EDBEngineError do
    begin
      if E.Errors[1].ErrorCode = 13059 then ShowMessage('l_step= ' + l_step + 'DB Error->' + E.Message)
      else ShowMessage('l_step = ' + l_step);
    end;
  end;
end;

procedure TFrm_4201.Cntl_SerialSelect_proc;
begin
  try
    l_step := '01';

    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add(' select STAT_I_SERIAL from tbstat ');
    Query2.SQL.Add(' where  stat_pswd = ''JPLS'' ');
    Query2.Open;

    s_index   := Query2.FieldByName('STAT_I_SERIAL').AsString;

// tbstat table에서 Serial번호를 증가시켜 갱신한다.
    l_step := '02';
    if s_index = '9999' then
    begin
      Query3.Close;
      Query3.SQL.Clear;
      Query3.SQL.Add(' update tbstat set');
      Query3.SQL.Add(' STAT_I_SERIAL = 1 ');
      Query3.SQL.Add(' where stat_pswd = ''JPLS'' ');
      Query3.ExecSQL;
    end
    else
    begin
      Query3.Close;
      Query3.SQL.Clear;
      Query3.SQL.Add(' update tbstat set');
      Query3.SQL.Add(' STAT_I_SERIAL = STAT_I_SERIAL + 1 ');
      Query3.SQL.Add(' where stat_pswd = ''JPLS'' ');
      Query3.ExecSQL;
    end;
  except
    on E : EDBEngineError do
    begin
      if E.Errors[1].ErrorCode = 13059 then ShowMessage('l_step= ' + l_step + 'DB Error->' + E.Message)
      else ShowMessage('l_step = ' + l_step);
    end
  end;
end;

procedure TFrm_4201.SGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
 LeftPos: Integer;
 CellStr: string;
begin
  with TStringGrid(Sender).Canvas do
  begin
    CellStr := TStringGrid(Sender).Cells[ACol, ARow];
    LeftPos := ((Rect.Right - Rect.Left - TStringGrid(Sender).Canvas.TextWidth(CellStr)) div 2) + Rect.Left;
    FillRect(Rect);
    TextOut(LeftPos, Rect.Top+5, CellStr);
  end;
end;

procedure TFrm_4201.SGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
 LeftPos: Integer;
 CellStr: string;
begin
  with TStringGrid(Sender).Canvas do
  begin
    CellStr := TStringGrid(Sender).Cells[ACol, ARow];
    IF ARow = 0 Then Begin
      if ACol > 0 Then Begin
        LeftPos := ((Rect.Right-Rect.Left-TStringGrid(Sender).Canvas.TextWidth(CellStr)) div 2) + Rect.Left;  // 가운데 정렬
        With TStringGrid(Sender).Canvas.Font Do Begin
          Font.Color  := clWhite;
          Style := [fsBold];
       End;
        FillRect(Rect);
        TextOut(LeftPos, Rect.Top+5, CellStr);
      End;
    End;     
  end;
end;


function TFrm_4201.LP_JOBDATE(): String;
var
  ls_sql : String;
  ls_Result : String;
begin
  ls_sql := ' Select CONVERT(varchar(10), CONVERT(datetime, STAT_JOBDATE), 120) AS STAT_JOBDATE  FROM TBSTAT (NOLOCK) ';
  Try
    With Query2 Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      ls_Result := FieldByName('STAT_JOBDATE').AsString;
    End;
  Except    
  End;

  Result := ls_Result;
end;


procedure TFrm_4201.FormDestroy(Sender: TObject);
begin
  Frm_4201 := Nil;
end;

procedure TFrm_4201.CloseBtnClick(Sender: TObject);
begin
  if Length(SGrid.Cells[1,1]) <> 0 then
  begin
    Showmessage('출고예약이 있습니다. 등록 및 초기화 후 종료 하십시요.');
    exit;
  end;
  Close;
end;





end.

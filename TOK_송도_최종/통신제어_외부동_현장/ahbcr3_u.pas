unit ahbcr3_u;

interface

uses
  Windows, Classes, SysUtils, Dialogs, dbtables, DB, ADODB, Messages, ScktComp;

type
  ahbcr3_T = class(TThread)
  private
    recv_buff   : String;
    send_buff   : String;

    pb_img_ok:  Boolean;

    ps_r_ch01: String[16];   ps_r_ch02: String[16];
    ps_w_ch01: String[16];
    pa_r_ch01: array [1..16] of Char;   pa_r_ch02: array [1..16] of Char;
    pa_w_ch01: array [1..16] of Char;

    // tbtrak table 제어변수선언.
    ps_trak_no       : String;      ps_trak_index   : String;
    ps_trak_gubun    : String;      ps_trak_loca    : String;
    ps_trak_high     : String;      ps_trak_flag    : String;
    ps_trak_date     : String;      ps_trak_time    : String;
    ps_trak_pltno    : String;

    ps_bcr_data : String;
    s_date, s_time,  s_index, s_code : String;
    s_lotno,   s_qty,   s_rqty, s_boxno, s_remark,  s_indate, s_intime, s_pltno, s_userId : String;
    s_subk_flag : String; // [추가] 재입고 여부 확인용 변수 20260115
    sc_io, s_datetime : String;
      
    pb_send_ok: Boolean;
    pb_recv_ok: Boolean;   

    pi_bcr_retry_cnt: Integer;

  protected
    procedure Execute; override;
    procedure main_init_proc; 
    procedure main_cntl_proc;       

    procedure Cntl_init_proc;

    procedure Cntl_StrToArrayProc;
    procedure Cntl_TrakOneSelectProc;

    procedure Recv_ActionProc(Sender: TObject; Socket: TCustomWinSocket);
    procedure Error_ActionProc(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);

    procedure Cntl_BCR_Data_proc;

    procedure f_bcr_err(ae: integer);
    function f_get_sysdate_time1(): String;
    procedure Cntl_TrakSettingProc;
    procedure Cntl_Miinpt_Proc;

  end;
var
  bcr3_pgm : char;
  bcr3_step: Integer;
  s_BOXID, s_bcr3, send_flag, s_bcr3_data : String;
implementation

uses ahcomm_u, Convision_u;

procedure ahbcr3_T.Execute;
begin
  bcr3_pgm  := 'T';
  pb_img_ok := False;

  ahcomm_f.bcr3BlueImg.Visible := False;
  ahcomm_f.bcr3RedImg.Visible  := True;

  ahcomm_f.bcr3Edit.Text := 'Bcr#03 Communication Start.!!';

  main_init_proc; /// 

  pi_bcr_retry_cnt := 0;

  Sleep(1000);
  While (not (bcr3_T.Terminated)) and (bcr3_pgm = 'T') do
  begin
    if ahcomm_f.Memo1.Lines.Count >= 100 then ahcomm_f.Memo1.Lines.Clear;

    if pb_img_ok = True then
    begin
     pb_img_ok := False;
    end
    else
    begin
      pb_img_ok := True;  
    end;

    main_cntl_proc;
    
    Sleep(2000);
  end;
// 통신 port를 close 한다. 
  ahcomm_u.bcr3_Socket.Close;  ///
  ahcomm_f.bcr3BlueImg.Visible := False;
  ahcomm_f.bcr3RedImg.Visible  := True;
  ahcomm_f.bcr3Edit.Text := 'Commnication Stop.!!';  //통신종료 작업을 하였습니다
  bcr3_pgm := 'F';
end;

procedure ahbcr3_T.main_init_proc;
begin
  pb_recv_ok := False;
  pb_send_ok := False;

  pi_bcr_retry_cnt := 0;

  Try
    ahcomm_u.bcr3_Socket.OnRead  := Recv_ActionProc;
    ahcomm_u.bcr3_Socket.OnError := Error_ActionProc;
    ahcomm_f.bcr3Edit.Text := 'Connected to bcr3.!!';
    ahcomm_f.bcr3BlueImg.Visible := True;
    ahcomm_f.bcr3RedImg.Visible  := False;
  Except
    ahcomm_f.bcr3Edit.Text := 'Connection Error to bcr3.!!';
    bcr3_pgm := 'F';
  End;
end;

procedure ahbcr3_T.main_cntl_proc;
begin
  s_time := FormatDateTime('hhmmss', Now);
  ahcomm_f.bcr3Edit.Text := 'main_cntl_proc!! = ' + Copy(s_time,1,2) + ':' + Copy(s_time,3,2) + ':' + Copy(s_time,5,2) ;

  pb_send_ok := False;

  Cntl_init_proc;

  if (s_bcr3 = '0')  then Exit; // BCR Reading 사용안함.
  if (pa_r_ch01[12] = '1') then Exit;  // 17 구간 출고모드


 //  17 PLT유,   17 CV 완료 신호, 17 CV 직진 신호,
 If (pa_r_ch01[01] = '1') And (pa_r_ch02[01] = '0') And (pa_w_ch01[01] = '0')  Then
 Begin
   ps_trak_no := '17';
   Cntl_TrakOneSelectProc;

   If (Length(Trim(ps_trak_index)) <> 0) then  exit;
   If ((ps_trak_flag >= '2'))  Then   exit;

   {
///////////////////////////////////////////
   //ps_bcr_data := 'P113';
   //ps_bcr_data := 'P002';
   //ps_bcr_data := 'P003';
   //ps_bcr_data := 'P004';
   //ps_bcr_data := 'P005';
   //ps_bcr_data := 'P006';
   //ps_bcr_data := 'P007';
   //ps_bcr_data := 'P008';
   //ps_bcr_data := 'P009';
   //ps_bcr_data := 'P010';
   //ps_bcr_data := 'P999';

   Cntl_BCR_Data_proc;   //Test

////////////////////////////////////////
   }
   
    ///
    ahcomm_f.bcr3Edit.Text := 'BCR_S_CMD!!';

    ps_trak_index := '';

    ahcomm_f.Memo1.Lines.Add('BCR#3 LON on = ' + FormatDateTime('hh:mm:ss:zz', Now));

    send_buff := 'LON' + CR;
    ahcomm_u.bcr3_Socket.Socket.SendText(send_buff);
    /// /// 
    Sleep(1000);

    pb_send_ok := True;
 end;
end;

///  Data 수신 ////
procedure ahbcr3_T.Recv_ActionProc(Sender: TObject; Socket: TCustomWinSocket);
var
   li_len : Integer;
   ls_time : String;
begin
  sleep(200);
  ahcomm_f.bcr3Edit.Text := 'Receive Action Processing.!!';
  ls_time :=  Copy(s_time,1,2) + ':' + Copy(s_time,3,2) + ':' + Copy(s_time,5,2);

  recv_buff  := '';
  recv_buff := ahcomm_u.bcr3_Socket.Socket.ReceiveText;

  li_len := length(recv_buff);

  ahcomm_f.Memo1.Lines.Add('BCR#3 = ' + Copy(recv_buff, 1, li_len - 1) + ' = ' + ls_time);

  if  Copy(recv_buff, li_len, 1) <> ETX  then
  begin
      ahcomm_f.Memo1.Lines.Add('BCR3 = ETX ERROR');
      ahcomm_f.Bcr3BlueImg.Visible := False;   ahcomm_f.Bcr3RedImg.Visible  := True;     Exit;
  end;

  if  Copy(recv_buff, 1, 1) <> STX  then
  begin
      ahcomm_f.Bcr3BlueImg.Visible := False;   ahcomm_f.Bcr3RedImg.Visible  := True;     Exit;
  end;
  if  Copy(recv_buff, li_len, 1) <> ETX  then
  begin
      ahcomm_f.Bcr3BlueImg.Visible := False;   ahcomm_f.Bcr3RedImg.Visible  := True;     Exit;
  end;

  ps_bcr_data := Trim(Copy(recv_buff, 2, li_len - 1));

  if (Length(ps_bcr_data) = 0)   then
  begin
   ahcomm_f.Bcr3BlueImg.Visible := False;
   ahcomm_f.Bcr3RedImg.Visible  := True;
   Exit;
  end;

  ahcomm_f.Bcr3BlueImg.Visible := True;    ahcomm_f.Bcr3RedImg.Visible  := False;

  ahcomm_f.Memo1.Lines.Add('BCR#3=[' + ps_bcr_data + '] = ' + FormatDateTime('hh:mm:ss:zz', Now));
////////////////////////////////////////////////////////////////////////////////
  s_date := FormatDateTime('yyyymmdd', Now);
  s_time := FormatDateTime('hhmmss', Now);

  if (Copy(ps_bcr_data,1,3) = '???') then
  begin
     pi_bcr_retry_cnt  :=  pi_bcr_retry_cnt + 1;
     if  pi_bcr_retry_cnt < 3  then  exit;
     ps_trak_index := '????';
     pi_bcr_retry_cnt := 0;
     f_bcr_err(2);
  end
  else
  begin
     pi_bcr_retry_cnt := 0;
     Cntl_BCR_Data_proc;
  end;
end;

procedure ahbcr3_T.Cntl_BCR_Data_proc;
var
  ls_sql : String;
  ls_index, ls_gubun, ls_loca, ls_date, ls_time, ls_Pltno : String;
  ls_high, ls_flag : String;
  li_cnt, li_seqno   : Integer;

  li_empty_rack_cnt : Integer; // DB상 물리적 빈 랙 (상태 '0')
  li_moving_cnt     : Integer; // 이동 중인 화물 (중복 차감 방지 적용)
  li_real_avail_cnt : Integer; // 최종 계산된 가용 수량
begin
   ahcomm_f.bcr3Edit.Text := 'Cntl_BCR_Data_proc!! = ' + FormatDateTime('hh:mm:ss', Now);

   ls_sql := ' Select Count(*) from T2MISUBK (NOLOCK) Where SUBK_PLTNO  = '''+ps_bcr_data+''' ';
   With ahcomm_f.Bcr3Query Do Begin
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        Open;
        li_cnt := Fields[0].AsInteger;
   End;

   if (li_cnt = 0)  then
   begin
      ps_trak_index := '????';
      f_bcr_err(4);
      ahcomm_f.Memo1.Lines.Add('BCR#03 입고정보에 PLT ID 가 미등록 상태 입니다.==>[' + ps_bcr_data + ']' );
      exit;
   end;

   ls_sql := ' Select Count(*) From  T2MILSTK (NOLOCK) Where (LSTK_FLAG = ''0'') ';
   ls_sql := ls_sql + ' And LSTK_BK  BETWEEN ''5'' AND ''6'' '; // 5, 6번 빈셀 cnt
   
   With ahcomm_f.Bcr3Query Do Begin
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        Open;
        li_empty_rack_cnt := Fields[0].AsInteger;
   End;

   ls_sql := ' SELECT COUNT(*) FROM T2TBTRAK T (NOLOCK) ';
   ls_sql := ls_sql + ' WHERE TRAK_GUBUN IN (''I'', ''R'') ';
   ls_sql := ls_sql + '   AND ISNULL(TRAK_PLTNO, '''') <> '''' ';
   ls_sql := ls_sql + '   AND ( ';
   ls_sql := ls_sql + '          T.TRAK_NO IN (''18'', ''19'', ''21'', ''22'', ''23'') ';
   ls_sql := ls_sql + '       OR ';
   ls_sql := ls_sql + '         ( T.TRAK_NO IN (''20'', ''24'') ';
   ls_sql := ls_sql + '           AND NOT EXISTS ( ';
   ls_sql := ls_sql + '               SELECT 1 FROM T2TBSCRC S (NOLOCK) ';
   ls_sql := ls_sql + '               INNER JOIN T2MILSTK M (NOLOCK) ON M.LSTK_LOCA = S.SCRC_LOCA ';
   ls_sql := ls_sql + '               WHERE S.SCRC_PLTNO = T.TRAK_PLTNO ';
   ls_sql := ls_sql + '                 AND M.LSTK_FLAG <> ''0'' ';
   ls_sql := ls_sql + '           ) ';
   ls_sql := ls_sql + '         ) ';
   ls_sql := ls_sql + '   ) ';
   
   With ahcomm_f.Bcr3Query Do Begin
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        Open;
        li_moving_cnt := Fields[0].AsInteger;
        ahcomm_f.Memo1.Lines.Add('3 호기 가용랙 수 ==>[' + IntToStr(li_moving_cnt) + ']' );        
   End;

   li_real_avail_cnt := li_empty_rack_cnt - li_moving_cnt; // 가용 수량

   if li_real_avail_cnt <= 0  then
   begin
      ps_trak_index := '????';
      f_bcr_err(5); // 만재 에러 처리
      
      ahcomm_f.Memo1.Lines.Add('BCR#03 3 호기  입고할 랙이 없습니다...==>[' + ps_bcr_data + ']' );
      exit;
   end;

   // 5. 입고 가능하면 트래킹 생성 및 진행
   Cntl_TrakSettingProc;
end;

procedure ahbcr3_T.Cntl_init_proc;
var
  ls_sql : String;
begin
   ls_sql := ' Select CVC3_CH01, CVC3_CH02 From T2TBCVC3 (NOLOCK) Where CVC3_SR = ''R'' ';
  With ahcomm_f.bcr3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    ps_r_ch01 := FieldByName('CVC3_CH01').AsString;
    ps_r_ch02 := FieldByName('CVC3_CH02').AsString;
  End;

  ls_sql := ' Select CVC3_CH01 From T2TBCVC3 (NOLOCK) Where CVC3_SR = ''S'' ';
  With ahcomm_f.bcr3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    ps_w_ch01 := FieldByName('CVC3_CH01').AsString;
  End;

  Cntl_StrToArrayProc;

  ls_sql := ' Select STAT_SC3IO, STAT_BCR3 From t2TBSTAT (NOLOCK) Where STAT_PSWD = ''JPLS'' ';
  With ahcomm_f.bcr3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    sc_io  := FieldByName('STAT_SC3IO').AsString; // SC 설정 0: 입출고 금지 , 1: 입고가능, 2: 출고가능, 3: 입출고가능
    s_bcr3 := FieldByName('STAT_BCR3').AsString;
  End;
end;

procedure ahbcr3_T.Cntl_StrToArrayProc;
begin
  MV_NDATA(@pa_r_ch01[1], @ps_r_ch01[1], 16);    MV_NDATA(@pa_r_ch02[1], @ps_r_ch02[1], 16);
  MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);
end;

procedure ahbcr3_T.Cntl_TrakOneSelectProc;
var
  ls_sql : String;
begin

  ps_trak_index     := '';   ps_trak_gubun  := '';   ps_trak_loca   := '';     ps_trak_high   := '';
  ps_trak_flag      := '';   ps_trak_date    := '';  ps_trak_time   := '';     ps_trak_pltno   := '';

  ls_sql := ' Select *  From T2TBTRAK (NOLOCK) Where TRAK_NO = '''+ps_trak_no+''' ';
  Try
    With ahcomm_f.bcr3Query Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      ps_trak_index    := TRIM(FieldByname('TRAK_INDEX').AsString);
      ps_trak_gubun    := TRIM(FieldByname('TRAK_GUBUN').AsString);
      ps_trak_loca     := TRIM(FieldByname('TRAK_LOCA').AsString);
      ps_trak_high     := TRIM(FieldByname('TRAK_HIGH').AsString);
      ps_trak_flag     := TRIM(FieldByname('TRAK_FLAG').AsString);
      ps_trak_date     := TRIM(FieldByname('TRAK_DATE').AsString);
      ps_trak_time     := TRIM(FieldByname('TRAK_TIME').AsString);
      ps_trak_pltno    := TRIM(FieldByname('TRAK_PLTNO').AsString);
    End;
  Except
    ahcomm_f.Memo1.Lines.Add('BCR3 STEP=' + ls_sql);
  End;
end;


procedure ahbcr3_T.Cntl_TrakSettingProc;
var
  ls_sql, ls_idate, ls_date, ls_time, ls_index : String;
begin

  s_datetime :=  f_get_sysdate_time1();

  s_date := Copy(s_datetime,1,8);
  s_time := Copy(s_datetime,9,6);

  ls_sql := ' Select STAT_DATE, STAT_IINDX  From T2TBSTAT (NOLOCK) Where STAT_PSWD = ''JPLS'' ';

  ahcomm_f.bcr3Query.Close;
  ahcomm_f.bcr3Query.SQL.Clear;
  ahcomm_f.bcr3Query.SQL.Add(ls_sql);
  ahcomm_f.bcr3Query.Open;

  ls_idate  :=  ahcomm_f.bcr3Query.FieldByName('Stat_DATE').AsString;

  if  (ls_idate = s_date)  then
  begin
     ls_index := s_date + 'I' + Format('%4.4d', [ahcomm_f.bcr3Query.FieldByName('Stat_IINDX').AsInteger]);
     if ahcomm_f.bcr3Query.FieldByName('STAT_IINDX').AsInteger >= 9999 Then Begin
           ls_sql := ' Update T2TBSTAT Set STAT_IINDX = convert(Numeric,''1'') ';
     End Else Begin
         ls_sql := ' Update T2TBSTAT Set STAT_IINDX = STAT_IINDX + 1 ';
     End;
     ls_sql := ls_sql + ' Where STAT_PSWD = ''JPLS'' ';
  end
  else
  begin
      ls_index := s_date + 'I' + Format('%4.4d', [1]);
      ls_sql := ' Update T2TBSTAT Set STAT_DATE = '''+s_date+''', STAT_IINDX = convert(Numeric,''2'') ';
      ls_sql := ls_sql + ' Where STAT_PSWD = ''JPLS'' ';
  end;


 with ahcomm_f.Bcr3UpdtQuery  do
    begin
      Try
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        ExecSQL;
      except
          ahcomm_f.Memo1.Lines.Add('Bcr#3 TBSTAT insert Error = ' + ls_sql);   Exit;
      end;
  end;      


  s_index    := ls_index;

  ps_trak_no     := '17';
  ps_trak_index  := ls_index;    ps_trak_gubun := 'I';        ps_trak_loca   := '';
  ps_trak_flag   := '';          ps_trak_date   := s_date;   ps_trak_time    := s_time;
  ps_trak_pltno  := ps_bcr_data;

  ls_sql := ' UpDate T2TBTRAK Set ';
  ls_sql := ls_sql + ' TRAK_INDEX    = '''+ps_trak_index+''',    TRAK_GUBUN = ''I'', ';
  ls_sql := ls_sql + ' TRAK_LOCA     = '''+ps_trak_loca+''',     TRAK_HIGH   = '''+ps_trak_high+''',   ';
  ls_sql := ls_sql + ' TRAK_FLAG     = '''+ps_trak_flag+''',     TRAK_DATE   = '''+ps_trak_date+''',   ';
  ls_sql := ls_sql + ' TRAK_TIME     = '''+ps_trak_time+''',     TRAK_PLTNO  = '''+ps_trak_pltno+'''  ';
  ls_sql := ls_sql + ' Where TRAK_NO = '''+ps_trak_no+''' ';
  try
    With ahcomm_f.bcr3UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  except
    ahcomm_f.Memo1.Lines.Add('bcr3 STEP=' + ls_sql);
  end;



   with ahcomm_f.bcr3Query do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT * FROM T2MISUBK (NOLOCK)  WHERE SUBK_PLTNO = '''+ps_trak_pltno+'''   ');
      open;
      First;
      if Recordcount = 0  then  exit;

      While True do
      begin
       if  Eof = True  then Exit;

      s_code       := Trim(FieldByName('SUBK_CODE').AsString);
      s_lotno      := Trim(FieldByName('SUBK_LOTNO').AsString);
      s_qty        := Trim(FieldByName('SUBK_WGT').AsString);
      s_rqty       := Trim(FieldByName('SUBK_RWGT').AsString);
      s_boxno      := Trim(FieldByName('SUBK_BOXNO').AsString);
      s_remark     := Trim(FieldByName('SUBK_REMARK').AsString);
      s_indate     := Trim(FieldByName('SUBK_INDATE').AsString);
      s_intime     := Trim(FieldByName('SUBK_INTIME').AsString);
      s_pltno      := Trim(FieldByName('SUBK_PLTNO').AsString);
      s_userId     := Trim(FieldByName('SUBK_USERID').AsString);
      s_subk_flag   := Trim(FieldByName('SUBK_FLAG').AsString); // 20260115      
      Cntl_Miinpt_Proc;
      Next;
    end;
  end;
end;


procedure ahbcr3_T.Cntl_Miinpt_Proc;
var
   ls_bcrerr, ls_sql : String;
   ls_rflag : String; // 20260115
begin;

  // 20260115
  if s_subk_flag = 'R' then
     ls_rflag := 'R'
  else
     ls_rflag := 'N';

  ls_sql := ' Insert Into T2MIINPT(INPT_INDEX, INPT_CODE, INPT_GUBUN, INPT_HOGI,';
  ls_sql := ls_sql + '    INPT_WEIGHT, INPT_LOCA, INPT_LOTNO, INPT_STATION, INPT_BOXNO,  INPT_REMARK, ';
  ls_sql := ls_sql + '    INPT_INDATE, INPT_STIME, INPT_ETIME, INPT_RFLAG, INPT_JOB_FLAG, INPT_PLTNO, INPT_ID )';
  ls_sql := ls_sql + ' Values('''+s_index+''', '''+s_code+''', ''Y'', ''1'', ';
  ls_sql := ls_sql + '         Convert(Numeric(7,2) ,'''+s_qty+'''),  '''', ';
  ls_sql := ls_sql + '        '''+s_lotno+''', ''17'', '''+s_boxno+''', '''+s_remark+''', ';
  ls_sql := ls_sql + '        '''+s_date+''', '''+s_time+''',  '''', '''+ls_rflag+''',  ''0'', '''+s_pltno+''', '''+s_userId+''') '; // 20260115
  with ahcomm_f.Bcr3UpdtQuery  do
    begin
      Try
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        ExecSQL;
      except
          ahcomm_f.Memo1.Lines.Add('T2MIINPT 17 Line insert Error = ' + ls_sql);   Exit;
      end;
  end;
end;



procedure ahbcr3_T.f_bcr_err(ae: integer);
var
   ls_bcrerr, ls_sql : String;
begin;
  ls_bcrerr := Format('%1.1d', [ae]);

  ls_sql := ' UpDate T2TBTRAK Set ';
  ls_sql := ls_sql + ' TRAK_INDEX  = '''+ps_trak_index+''', TRAK_FLAG = '''+ls_bcrerr+''' Where TRAK_NO = ''17'' ';
  try
    With ahcomm_f.bcr3UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  except
    ahcomm_f.Memo1.Lines.Add('BCR#03 STEP=' + ls_sql);
  end;
end;

function ahbcr3_T.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl (NOLOCK) ';
    With ahcomm_f.bcr3Query Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      ls_date    := Fields[0].AsString;
    End;

    ls := trim(ls_date);
    ls_date := Copy(ls, 1, 4)  + Copy(ls, 6, 2)  + Copy(ls, 9, 2) + Copy(ls, 12, 2) + Copy(ls, 15, 2) + Copy(ls, 18, 2);

    Result :=  ls_date
end; 


procedure ahbcr3_T.Error_ActionProc(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;

  If bcr3_Socket.Active then bcr3_Socket.Active := False;
     bcr3_Socket.Host   := '172.16.139.174';
     bcr3_Socket.Port   := StrToInt('2112');
     bcr3_Socket.Active := True;
end;


end.

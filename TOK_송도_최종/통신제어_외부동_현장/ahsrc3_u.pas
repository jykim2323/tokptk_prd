unit ahsrc3_u;

interface

uses
  Windows, Classes, SysUtils, Dialogs, dbtables, Messages, ScktComp,
  WinTypes, WinProcs, controls;

type
  ahsrc3_T = class(TThread)
  private
    recv_buff: String;
    send_buff: String;

    pb_recv_ok: Boolean;
    pb_img_ok:  Boolean;

    ps_r_ch01: String[16];    ps_r_ch02: String[04];
    ps_r_ch03: String[04];    ps_r_ch04: String[04];
    ps_r_ch05: String[04];    ps_r_ch06: String[04];

    ps_w_ch01: String[16];    ps_w_ch02: String[04];
    ps_w_ch03: String[04];    ps_w_ch04: String[04];
    ps_w_ch05: String[04];    ps_w_ch06: String[04];
    ps_w_ch07: String[04];

    pa_r_ch01: array [1..16] of Char;
    pa_w_ch01: array [1..16] of Char;

    s_date : string[8];
    s_time : string[6];

///// program variable definition area    /////
    s_cycle1, s_cycle2, s_cycle,  s_ack,    s_load,  s_unload : String;
    s_loca,   s_scplt,  s_posby,  s_error,  s_ready  : String;
    s_poslv,  s_online, s_desc,   s_index,  s_wsno   : String;
    s_gubun,  s_high,   s_pltno : String;    // 251031


    cv_no, i_gubun, i_high, i_loca : String;
    i_plt, o_plt  : String;
    sc_io : String;

    send_check : Integer;
    Error_Write : Boolean;

    sv_ecode, s_ecode : String;

    i_rdy : Array[1..2] of String[1];
    o_rdy : Array[1..2] of String[1];
    i_trk :  array [1..2] of String;
    o_trk :  array [1..2] of String;
    i_mode :  array [1..2] of String[1];
    o_mode :  array [1..2] of String[1];
    cv_op :  array [1..2] of String[1];
    Plt_Exist : Array[1..2] of String[1];

  protected
    procedure Execute; override;
   
    procedure main_recv_proc;
    procedure Recv_ActionProc(Sender: TObject; Socket: TCustomWinSocket);
    procedure Error_ActionProc(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);

    procedure main_send_proc;
    procedure Recv_OracleUpdateProc;

    procedure main_cntl_proc;
    procedure main_TableSelect_proc;

    procedure Cntl_StrToArrayProc;
    procedure Cntl_JobCheck_Proc;
    procedure Cntl_ErrorReport_Proc;
    procedure Cntl_ErrorReport_Proc1;
    procedure Cntl_ErrorReport_Proc2;
    procedure Cntl_RecvAck_proc;
    procedure Cntl_OutputUpdate_Proc;   

    procedure Cntl_IOUpdate_Proc;    
    procedure Cntl_TrakUpdate_Proc;
    procedure Cntl_OjobFetch_Proc;
    procedure Cntl_IjobFetch_Proc;
    procedure Cntl_DoubleIn_Proc;
    procedure Cntl_EmptyOut_Proc;
    procedure Cntl_Load_Proc;
    procedure Cntl_Unload_Proc;
    procedure Cntl_InitSelect_Proc;
    procedure Cntl_IOError_Proc;
    procedure Cntl_IODirect_Proc;
    procedure Cntl_IOChange_Proc;
    procedure Cntl_IOSearch_Proc;
    procedure Cntl_TbscrcSelect_Proc;
    procedure Cntl_TbscrcUpdate_Proc;
    procedure Error_LogDataWrite;

    function f_get_sysdate_time1(): String;


    function Func_LocationUpdate(F_Flag, F_loca : String): Boolean;
  end;

const
  LogFilePath : String = 'D:\app_error_log\';
var
  src3_pgm : char;
  src3_step: Integer;
  LogText : String;
  Log_File : TextFile;
  LogFileName : String;

implementation

uses ahcomm_u, Convision_u;

procedure ahsrc3_T.Execute;
begin
  src3_pgm := 'T';
  pb_img_ok := False;
  Error_Write := False;

  ahcomm_f.src3Edit.Text := '통신개시 작업을 하였습니다.!!';

  ahcomm_u.src3_Socket.OnRead := Recv_ActionProc;      ///
  ahcomm_u.src3_Socket.OnError := Error_ActionProc;    ///
  
  sleep(1000);

  While (not (src3_T.Terminated)) and (src3_pgm = 'T') do
  begin
    if ahcomm_f.Memo1.Lines.Count >= 300 then ahcomm_f.Memo1.Lines.Clear;
    if pb_img_ok = True then
    begin
     pb_img_ok := False;
    end
    else
    begin
      pb_img_ok := True;    
    end;

    main_recv_proc;  ///
    
    Sleep(200);

    main_TableSelect_proc;
    main_cntl_proc;
    recv_buff := '';
    main_send_proc;
    sleep(200);
  end;
// 통신 port를 close 한다.

  ahcomm_f.src3Edit.Text := '통신종료 작업을 하였습니다.!!';

  ahcomm_u.src3_Socket.Close;            ///
  
  ahcomm_f.src3BlueImg.Visible := False;
  ahcomm_f.src3RedImg.Visible  := True;
  src3_pgm := 'F';
end;

procedure ahsrc3_T.main_recv_proc;
var
  li_Len, li_rc, li_i, li_k, li_x, li_d, li_m: Integer;
  la_Source  :  array [1..40] of Char;
  la_conv_buf:  array [1..160] of Char;

  ls_recv_data: String;
  ls_conv_data: String;
  ls_rack_mode: String;
begin
  recv_buff := '';
  ahcomm_f.src3Edit.Text := 'Port Receive Processing.!!';

// Read Command 를 송신한다.
  send_buff := src3_R_CMD;
//  ahcomm_f.Memo1.Lines.Add('[SC#3]Read =' + Send_buff);
  ahcomm_u.src3_Socket.Socket.SendText(send_buff);
  Sleep(200);

// 실제로 recv data 얻는다.
   ls_rack_mode := recv_buff;

  if (Length(ls_rack_mode) = 0) And (Copy(ls_rack_mode, 1, 1) <> 'D') then
  begin
//    ahcomm_f.Memo1.Lines.Add('Receive Error =' + ls_rack_mode);
    ahcomm_f.src3BlueImg.Visible := False;
    ahcomm_f.src3RedImg.Visible  := True;
    pb_recv_ok := False;
    exit;
  end;

  li_len := Length(recv_buff);

  If Length(recv_buff) < 23 Then Begin
//    ahcomm_f.Memo1.Lines.Add(' Send Ack Receive : ' + recv_buff);
    pb_recv_ok := False;
    exit;
  End;

  If Not (li_len = 46)  Then Begin
    ahcomm_f.src3BlueImg.Visible := False;
    ahcomm_f.src3RedImg.Visible  := True;
    pb_recv_ok := False;
    exit;
  End;
 
/////////////////////////////////////////////////
// 실제Data만 가져와서 변수에 저장한다....
/////////////////////////////////////////////////
  ls_recv_data := Copy(recv_buff, 23, 24);

  ps_r_ch02  := Copy(ls_recv_data,  5, 4);
  ps_r_ch02  := Format('%4.4d', [StrToInt('$' + Copy(ps_r_ch02, 1, 4))]);

  ps_r_ch03  := Copy(ls_recv_data,  9, 4);
  ps_r_ch03  := Format('%4.4d', [StrToInt('$' + Copy(ps_r_ch03, 1, 4))]);

  ps_r_ch04  := Copy(ls_recv_data, 13, 4);
  ps_r_ch04  := Format('%4.4d', [StrToInt('$' + Copy(ps_r_ch04, 1, 4))]);

  ps_r_ch05  := Copy(ls_recv_data, 17, 4);
  ps_r_ch05  := Format('%4.4d', [StrToInt('$' + Copy(ps_r_ch05, 1, 4))]);

  ps_r_ch06  := Copy(ls_recv_data, 21, 4);
  ps_r_ch06  := Format('%4.4d', [StrToInt('$' + Copy(ps_r_ch06, 1, 4))]);
/////////////////////////////////////////////////

// 수신한 data를 변환하는 Module start
  ls_recv_data := Copy(ls_recv_data, 1, 4);

  li_Len := Length(ls_recv_data);
  li_x := 1;
  for li_k := 1 to li_len do
  begin
    li_d := li_k mod 4;
    li_m := li_k div 4;
    case li_d of
      1: li_x := 4;
      2: li_x := 3;
      3: li_x := 2;
      0: begin li_m := li_m - 1; li_x := 1; end;
    end;
   la_source[(li_m * 4) + li_x] := ls_recv_data[li_k];
  end;
  li_rc := StrToDscDigit(@la_conv_buf[1], @la_source[1], li_Len);
  for li_i := 1 to li_len * 4 do
  begin
    ls_conv_data := ls_conv_data + la_conv_buf[li_i];
  end;

//임시 display
//  ahcomm_f.Memo1.Lines.Add('convert =' + ls_conv_data);      

  ps_r_ch01 := Copy(ls_conv_data,   1, 16);

  if    li_rc = 0 then pb_recv_ok := True
  else  pb_recv_ok := False;

  if pb_recv_ok = True  then Recv_OracleUpdateProc;
end;

/// Read, Send Data 수신 ////
procedure ahsrc3_T.Recv_ActionProc(Sender: TObject; Socket: TCustomWinSocket);
begin
  ahcomm_f.src3Edit.Text := 'Receive Action Processing.!!';

  recv_buff  := '';
  recv_buff := ahcomm_u.src3_Socket.Socket.ReceiveText;
  ahcomm_f.Memo1.Lines.Add('[SC#3]수신=' + recv_buff);
end;

///////////////////////////////////////////////////////////////////////
///    Recv_OracleUpdateProc;
///////////////////////////////////////////////////////////////////////
procedure ahsrc3_T.Recv_OracleUpdateProc;
begin
  src3_step := 10;

  if  Length(ps_r_ch01) <> 16 then Exit;
  if  Length(ps_r_ch02) <> 04 then Exit;
  if  Length(ps_r_ch03) <> 04 then Exit;
  if  Length(ps_r_ch04) <> 04 then Exit;
  if  Length(ps_r_ch05) <> 04 then Exit;
  if  Length(ps_r_ch06) <> 04 then Exit;

  ahcomm_f.src3Edit.Text := 'Receive Oracle Update Processing';
//  ahcomm_f.Memo1.Lines.Add('Scrc READ=' + copy(recv_buff, 1, 50));
  try
    with ahcomm_f.src3Query do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' update T2TBSCC3 set  ');
      SQL.Add(' SCC3_ch01 = '''+ps_r_ch01+''', SCC3_ch02 = '''+ps_r_ch02+''', ');
      SQL.Add(' SCC3_ch03 = '''+ps_r_ch03+''', SCC3_ch04 = '''+ps_r_ch04+''', ');
      SQL.Add(' SCC3_ch05 = '''+ps_r_ch05+''', SCC3_ch06 = '''+ps_r_ch06+'''  ');
      SQL.Add(' where SCC3_sr = ''R'' ');
      ExecSQL;
    end;
  except
    begin
      ahcomm_f.Memo1.Lines.Add('[*]T2TBSCC3 Update error ' + IntToStr(src3_step));
    end;
  end;
end;

procedure ahsrc3_T.main_TableSelect_proc;
var
  ls_sql : String;
begin
  ahcomm_f.src3Edit.Text := 'main_TableSelect_proc.!!';

  ls_sql := ' Select SCC3_CH01, SCC3_CH02, SCC3_CH03, SCC3_CH04, SCC3_CH05, SCC3_CH06   From T2TBSCC3 (NOLOCK) ';
  ls_sql := ls_sql + ' Where SCC3_SR = ''R'' ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    ps_r_ch01 := FieldByName('SCC3_CH01').AsString;
    ps_r_ch02 := FieldByName('SCC3_CH02').AsString;
    ps_r_ch03 := FieldByName('SCC3_CH03').AsString;
    ps_r_ch04 := FieldByName('SCC3_CH04').AsString;
    ps_r_ch05 := FieldByName('SCC3_CH05').AsString;
    ps_r_ch06 := FieldByName('SCC3_CH06').AsString;
  End;

  ls_sql := ' Select SCC3_CH01, SCC3_CH02, SCC3_CH03, SCC3_CH04, SCC3_CH05, SCC3_CH06, SCC3_CH07 From T2TBSCC3 (NOLOCK) ';
  ls_sql := ls_sql + ' Where SCC3_SR = ''S'' ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    ps_w_ch01 := FieldByName('SCC3_CH01').AsString;
    ps_w_ch02 := FieldByName('SCC3_CH02').AsString;
    ps_w_ch03 := FieldByName('SCC3_CH03').AsString;
    ps_w_ch04 := FieldByName('SCC3_CH04').AsString;
    ps_w_ch05 := FieldByName('SCC3_CH05').AsString;
    ps_w_ch06 := FieldByName('SCC3_CH06').AsString;
    ps_w_ch07 := FieldByName('SCC3_CH07').AsString;
  End;

  Cntl_StrToArrayProc;
end;

procedure ahsrc3_T.Cntl_StrToArrayProc;
begin
  MV_NDATA(@pa_r_ch01[1], @ps_r_ch01[1], 16);      
  MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);
end;
/////////////////////////////////////////////////////
///  Cntl_job_Check     //////////////////////////////
//////////////////////////////////////////////////////
procedure ahsrc3_T.Cntl_JobCheck_Proc;
var
  li_bay, li_level : Integer;
begin
  ahcomm_f.src3Edit.Text := 'Cntl_JobCheck_Proc!!';
  li_bay   := 0;
  li_level := 0;

  s_posby   :=  Copy(ps_r_ch02,3,2);
  s_poslv   :=  Copy(ps_r_ch03,4,1);

  s_ecode  := ps_r_ch04;

  s_online := pa_r_ch01[01];
  s_ready  := pa_r_ch01[05];
  s_scplt  := pa_r_ch01[09];

/////////////////////////////Data Reset////////////////////////////////////////
  If (pa_r_ch01[05] = '1') And (pa_w_ch01[16] = '1') Then pa_w_ch01[16] := '0';
///////////////////////////////////////////////////////////////////////////////
/////////////////////////////Home position////////////////////////////////////////
  If (pa_r_ch01[07] = '1') And (pa_w_ch01[15] = '1') Then pa_w_ch01[15] := '0';
/////////////////////////////////////////////////////////////////////////////////

// 호기에러 , 기타에러
  if      (pa_r_ch01[04] = '1') and (s_cycle2 = '0') and (s_ack    = '0') then Cntl_RecvAck_proc
  else If (pa_r_ch01[14] = '1') Or  (pa_r_ch01[15] = '1')  then Cntl_ErrorReport_Proc
  else If (pa_r_ch01[16] = '1') then Cntl_ErrorReport_Proc1
  else if (pa_r_ch01[11] = '1') and (s_cycle2 = '2') and (s_unload = '0') then s_unload := '1'
  else if (pa_r_ch01[10] = '1') and (s_cycle2 = '1') and (s_load   = '0') then s_load   := '1';
end;

procedure ahsrc3_T.Cntl_RecvAck_proc;
var
  li_i : Integer;
begin
 s_ack := '1';

 For li_i := 1 To 16 Do Begin
    pa_w_ch01[li_i] := '0';
  End;

  ps_w_ch02 := '0000';   ps_w_ch03 := '0000';
  ps_w_ch04 := '0000';   ps_w_ch05 := '0000';
  ps_w_ch06 := '0000';   ps_w_ch07 := '0000';

  sv_ecode := '';
end;


procedure ahsrc3_T.Cntl_ErrorReport_Proc;
var
  ls_sql : String;
  Error_id, Error_proc, ls_dt : String;
  Li_i     : Integer;
begin

///// 이중격납
    if  (pa_r_ch01[15] = '1') and  (s_cycle2 = '2') then
    begin
        s_error := 'W';    pa_w_ch01[16]  := '1';   main_send_proc;   sleep(2000);;
        s_desc  := ' ErrorSC#3 Double Input' + s_posby + '-' + s_poslv;
    end;

///// 공출고
    if  pa_r_ch01[14] = '1' then
    begin
        s_error := 'E';    pa_w_ch01[16]  := '1';   main_send_proc;   sleep(2000);
        s_desc  := ' ErrorSC#3 Empty Outlet' + s_posby + '-' + s_poslv;
    end;

   if  (s_ecode <> '0000')  then
   begin
      if  (s_ecode <> sv_ecode)  then
      begin
        Cntl_ErrorReport_Proc2;
        sv_ecode := s_ecode;
      end
   end;
end;

procedure ahsrc3_T.Cntl_ErrorReport_Proc1;
var
  ls_sql : String;
  Error_id, Error_proc, ls_dt : String;
  Li_i     : Integer;
begin
///// 기타에러
   s_error :=  'G';    

   if  (s_ecode <> '0000')  then
   begin
      if  (s_ecode <> sv_ecode)  then
      begin
        Cntl_ErrorReport_Proc2;
        sv_ecode := s_ecode;
      end
   end;
End;

procedure ahsrc3_T.Cntl_ErrorReport_Proc2;
var
  ls_sql : String;
  Error_id, Error_proc, ls_dt, ls_desc : String;
  Li_i     : Integer;
begin

  if Error_Write = True Then Exit;


  s_desc := '';     

  ls_sql := ' select err_desc  from  T2TBECODE (NOLOCK) Where  err_ecode = '''+s_ecode+''' ';
  with ahcomm_f.src3Query do
  begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      open;
      if RecordCount = 0  then   Exit;
      ls_desc := FieldByName('err_desc').AsString;
  end;

  s_desc  :=  s_ecode +' = '+ls_desc + s_posby + '-' + s_poslv;

  ls_dt := FormatDateTime('YYYYMMDDHHNNSS', Now);

  ls_sql := ' insert into T2TIMESG(mesg_dt, mesg_ehogi,  mesg_eloca, mesg_desc)  ';
  ls_sql := ls_sql + ' values ('''+ls_dt+''',  ''3'', '''+s_loca+''', '''+s_desc+''') ';
  with ahcomm_f.src3UpdtQuery  do
  begin
      try
         src3_step := 42;
         Close;
         SQL.Clear;
         SQL.Add(ls_sql);
         ExecSQL;
      except
         ahcomm_f.Memo1.Lines.Add('[*]SC1 timesg Update error ' + IntToStr(src3_step));
      end;
   end;

   Error_Write := True;
end;

//////////////////////////////////////////////////////
///  Main_Cntl_proc      /////////////////////////////
//////////////////////////////////////////////////////
procedure ahsrc3_T.main_cntl_proc;
begin
   ///
   if pb_recv_ok = False then Exit;

  ahcomm_f.src3Edit.Text := 'main_cntl_proc.!!' + FormatDateTime('YYYYMMDDHHNNSS', Now);;
  Cntl_InitSelect_Proc;
  Cntl_TbscrcSelect_Proc;
  Cntl_JobCheck_Proc;

  If (s_cycle2 = '0') And (s_ack = '1')    Then s_cycle2 := '1'
  Else If (s_error <> '0') Then  Cntl_IOError_Proc
  Else If (s_cycle2 = '0') And (s_ack = '0')    Then Cntl_IODirect_Proc
  Else If (s_cycle2 = '1') And (s_load = '1')   Then Cntl_Load_Proc
  Else If (s_cycle2 = '2') And (s_unload = '1') Then Cntl_Unload_Proc
  Else If (s_cycle2 = '3') And (s_unload = '1') Then Cntl_IOChange_Proc
  Else If (s_cycle2 = '3') And (s_unload = '0') Then Cntl_IOSearch_Proc;

  Cntl_TbscrcUpdate_Proc;
end;
//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
procedure ahsrc3_T.Cntl_IODirect_Proc;
var
  li_i : Integer;
  ls_bank, ls_bay, ls_level : String;
  ls_bay1, ls_bay2, ls_level1, ls_level2 : String;

  ls_tobank, ls_tobay, ls_tolevel : String;
  ls_tobay1, ls_tobay2, ls_tolevel1, ls_tolevel2 : String;
begin
  s_error := '0';  s_desc := '';   Error_Write := False;

  If (s_online = '0') Or (s_ready = '0') Then Exit;

  For li_i := 0 To 16 Do Begin
    pa_w_ch01[li_i] := '0';
  End;
  
  ps_w_ch02 := '0000';    ps_w_ch03 := '0000';
  ps_w_ch04 := '0000';    ps_w_ch05 := '0000';
  ps_w_ch06 := '0000';    ps_w_ch07 := '0000';

  If (s_cycle1 = 'I') Then Begin pa_w_ch01[01] := '1';   End;
  If (s_cycle1 = 'O') Then Begin pa_w_ch01[02] := '1';   End;
  If (s_cycle1 = 'M') Then pa_w_ch01[03] := '1';

 if  s_cycle1 = 'I'   then
  begin
    pa_w_ch01[01] := '1';  // 입고 지시
    if  (copy(s_loca, 1, 1) = '5')   then  pa_w_ch01[11] := '1' else  pa_w_ch01[12] := '1';
    ps_w_ch02 := '0000';    ps_w_ch03 := '0000';
    ps_w_ch04 := '00' + Copy(s_loca,2,2);      ps_w_ch05 := '000' + Copy(s_loca,4,1);

    if (s_wsno = '1') then
    begin
       ps_w_ch06 := '0001';
    end
    else if (s_wsno = '2') then
    begin
       ps_w_ch06 := '0002';
    end;
  end;

  if  s_cycle1 = 'O'   then
  begin
    pa_w_ch01[02] := '1';  // 출고 지시
    if  (copy(s_loca, 1, 1) = '5') then  pa_w_ch01[09] := '1' else  pa_w_ch01[10] := '1';
    ps_w_ch02 := '00' + Copy(s_loca,2,2);      ps_w_ch03 := '000' + Copy(s_loca,4,1);
    ps_w_ch04 := '0000';    ps_w_ch05 := '0000';

    if (s_wsno = '1') then
    begin
       ps_w_ch07 := '0001';
    end
    else if (s_wsno = '2') then
    begin
       ps_w_ch07 := '0002';
    end;
  end;     
end;

procedure ahsrc3_T.Cntl_Load_Proc;
begin
  s_cycle2 := '2';
  s_ack := '0';
  If (s_cycle1 = 'I') Then Cntl_TrakUpdate_Proc;
end;

procedure ahsrc3_T.Cntl_Unload_Proc;
begin
  s_cycle2 := '3';
  s_load := '0';
//  if (s_cycle1 = 'O') then  Cntl_OutputUpdate_Proc;

  Cntl_IOUpdate_Proc;
end;            

procedure ahsrc3_T.Cntl_IOChange_Proc;
begin
   if s_cycle1 = 'I'  then  s_cycle1 := 'O'  else  s_cycle1 := 'I'; 

   s_cycle2 := '3';        s_ack    := '0';   s_load  := '0';    s_unload   := '0';
   s_loca   := '';         s_error  := '0';   s_index := '';     s_pltno  := '';
   s_desc   := '';         s_gubun  := '';    s_high  := '';     s_wsno  := '';
end;

procedure ahsrc3_T.Cntl_IOSearch_Proc;
begin    
  If (s_online = '0') Or (s_ready = '0') Then Exit;
  If (s_ack = '1')    Or (s_load = '1') Then Exit;

  If ((s_cycle1 = 'I') And (sc_io = '2')) Or ((s_cycle1 = 'O') And (sc_io = '1')) Then
  Begin
    Cntl_IOChange_Proc;      Exit;
  End;

  send_check := 0;   


  If (s_cycle1 = 'O') And ((sc_io = '2') Or (sc_io = '3')) And
     (send_check = 0) And ((o_rdy[1] = '1') Or (o_rdy[2] = '1')) Then Cntl_OjobFetch_Proc;

  If (s_cycle1 = 'I') And ((sc_io = '1') Or (sc_io = '3')) And
     (send_check = 0) And ((i_rdy[1] = '1') Or (i_rdy[2] = '1')) Then Cntl_IjobFetch_Proc;

  If (send_check = 0) Then Cntl_IOChange_Proc;     
end;

// 입고 예약 체크
procedure ahsrc3_T.Cntl_IjobFetch_Proc;
label NextHere1;
var
  ls_sql : String;
  ls_trkno, ls_index, ls_loca, ls_flag, ls_high : String;
  ls_date, ls_time, ls_pltno : String;
begin
  ls_sql := ' Select * From T2TBTRAK (NOLOCK) Where TRAK_NO IN (''20'', ''24'') ';
  ls_sql := ls_sql + ' And  ISNULL(TRAK_INDEX, '''')  <> ''''   ';
  ls_sql := ls_sql + ' And  Substring(TRAK_INDEX,9,1) = ''I''       ';
  ls_sql := ls_sql + ' Order by  trak_date, trak_time ';
  With ahcomm_f.src3Query Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      First;
      while True do
      Begin
        if  Eof = True  then Exit;

        ls_trkno   := Trim(FieldByName('TRAK_NO').AsString);
        ls_index   := Trim(FieldByName('TRAK_INDEX').AsString);
        ls_loca    := Trim(FieldByName('TRAK_LOCA').AsString);
        ls_flag    := Trim(FieldByName('TRAK_FLAG').AsString);
        ls_high    := Trim(FieldByName('TRAK_HIGH').AsString);
        ls_date    := Trim(FieldByName('TRAK_DATE').AsString);
        ls_time    := Trim(FieldByName('TRAK_TIME').AsString);
        ls_pltno   := Trim(FieldByName('TRAK_PLTNO').AsString);
        
        if (ls_trkno = '20') And (i_rdy[1] = '1') And (cv_op[1] = '1') And (i_mode[1] = '1') then GoTo  NextHere1
        else if (ls_trkno = '24') and (i_rdy[2] = '1') And (cv_op[2] = '1') And (i_mode[2] = '1') then  GoTo  NextHere1;

        Next;
      End;
    End;

 NextHere1:

   if (ls_loca = '')  then
   Begin
    ls_sql := ' Select LSTK_LOCA From T2MILSTK (NOLOCK) Where LSTK_BK In (''5'', ''6'') And LSTK_FLAG = ''0''  ';
    ls_sql := ls_sql + ' Order By LSTK_LV, LSTK_BY, LSTK_BK ';
    With ahcomm_f.src3Query Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      First;

      If Eof Then Exit;
      ls_loca := FieldByName('LSTK_LOCA').AsString;
    End;
   End; 

   If (ls_loca = '') Then Exit;

   ls_high := Copy(ls_loca,4,1); // 높이 정보  추가   

   If Not Func_LocationUpdate('X', ls_loca) Then Exit;

   if (ls_trkno = '20') then  s_wsno := '1'  else s_wsno := '2';

   s_cycle1 := 'I';       s_cycle2  := '0';       s_ack  := '0';       s_error := '0';
   s_index  := ls_index;  s_desc   := '';         s_high  := ls_high;
   s_loca   := ls_loca;   s_gubun   := 'I';       s_pltno := ls_pltno;

   send_check := 1;
end;

// 출고 예약 체크
procedure ahsrc3_T.Cntl_OjobFetch_Proc;
label NextHere;
var
  ls_sql : String;
  ls_index,  ls_loca, ls_job : String;
  ls_wsno, ls_date, ls_time, ls_trkno, ls_pltno : String;
begin  
  ls_sql := ' Select * From T2TISCHE (NOLOCK) Where SCHE_SC = ''3'' ';
  ls_sql := ls_sql + ' Order by SCHE_EMER, SCHE_INDEX ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;

    If RecordCount = 0 Then Exit;

    while True do
    Begin
      if  Eof = True  then Exit;

      ls_index   := FieldByName('SCHE_INDEX').AsString;
      ls_loca    := FieldByName('SCHE_LOCA').AsString;
      ls_job     := FieldByName('SCHE_JOBGUBUN').AsString;
      ls_wsno    := FieldByName('SCHE_WSNO').AsString;
      ls_date    := FieldByName('SCHE_DATE').AsString;
      ls_time    := FieldByName('SCHE_TIME').AsString;
      ls_pltno   := FieldByName('SCHE_PLTNO').AsString;

      if (ls_wsno = '1') then
      begin
         if (o_rdy[1] = '1') And (o_trk[1] = '') And (cv_op[1] = '1') And
            (Plt_Exist[1] = '0') And (o_mode[1] = '1')  then   GoTo  NextHere;
      end
      else if (ls_wsno = '2') then
      begin
         if (o_rdy[2] = '1') And (o_trk[2] = '') And (cv_op[2] = '1') And
            (Plt_Exist[2] = '0') And (o_mode[2] = '1')  then   GoTo  NextHere;
      end;

      Next;
    End;
  End;

NextHere:

  ls_sql := ' Delete from  T2TISCHE  where  sche_index = '''+ls_index+''' ';
  with ahcomm_f.src3Query do
  begin
      try
         Close;
         SQL.Clear;
         SQL.Add (ls_sql);
         ExecSQL;
      except
         ahcomm_f.Memo1.Lines.Add('STEP:36 tische delete error.!!' + ls_sql);
      end;
  end;

  s_cycle1 := 'O';       s_cycle2  := '0';         s_error  := '0';      s_ack := '0';
  s_index  := ls_index;  s_loca   := ls_loca;      s_gubun  := 'O';
  s_wsno   := ls_wsno;   s_desc   := '';           s_pltno  := ls_pltno;

  send_check := 1;
end;

// 에러처리
procedure ahsrc3_T.Cntl_IOError_Proc;
begin
  If s_cycle2 = '3' Then   Begin      s_error := '0';  s_desc  := '';     Exit;    End;

  If (s_error = 'G') Then Exit;

  If (s_cycle = 'I2') And (s_error = 'W') Then Cntl_DoubleIn_Proc
  Else If (s_cycle = 'O1') And (s_error = 'E') Then Cntl_EmptyOut_Proc;
end;

// 이중격납  처리
procedure ahsrc3_T.Cntl_DoubleIn_Proc;
var   
  ls_sql, ls_loca : String;
begin

  If Not Func_LocationUpdate('W', s_loca) Then Exit;

  ls_sql := ' Select LSTK_LOCA From  T2MILSTK (NOLOCK) ';
  ls_sql := ls_sql + ' Where LSTK_Flag = ''0''  ';
  ls_sql := ls_sql + ' And LSTK_BK In (''5'', ''6'') ';
  ls_sql := ls_sql + ' Order By LSTK_LV, LSTK_BY, LSTK_BK ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    If Eof Then Exit;

    ls_loca := FieldByName('LSTK_LOCA').AsString;
  End;

  If Not Func_LocationUpdate('X', ls_loca) Then Exit;    

  s_cycle1 := 'I';  s_cycle2 := '0';    s_load := '1';    s_error  := '0';
  s_unload := '0';  s_ack := '0';       s_desc := '';     s_loca := ls_loca;
end;
// 공 출고 처리
procedure ahsrc3_T.Cntl_EmptyOut_Proc;
begin
  If Not Func_LocationUpdate('E', s_loca) Then Exit;

  s_cycle1 := 'O';
  s_cycle2 := '3';  s_ack   := '0';   s_load  := '0';   s_unload := '0';
  s_error  := '0';  s_index  := '';   s_high   := '';   s_loca   := '';
  s_wsno  := '';    s_desc   := '';   s_gubun := '';    s_pltno := '';
end;

// 입고 Loading 완료 처리
procedure ahsrc3_T.Cntl_TrakUpdate_Proc;
var
  ls_sql, ls_trak : String;
begin
  if (s_cycle1 = 'I') and (s_wsno = '1') and (s_index <> i_trk[1]) then  exit;
  if (s_cycle1 = 'I') and (s_wsno = '2') and (s_index <> i_trk[2]) then  exit;

  if (s_wsno = '1') then ls_trak := '20'
  else if (s_wsno = '2') then ls_trak := '24'
  else exit;

  ls_sql := ' Update T2TBTRAK Set ';
  ls_sql := ls_sql + ' TRAK_INDEX = '''',   ';
  ls_sql := ls_sql + ' TRAK_LOCA    = '''', TRAK_FLAG   = '''', TRAK_HIGH = '''', ';
  ls_sql := ls_sql + ' TRAK_DATE  = '''',   TRAK_TIME    = '''', TRAK_GUBUN  = '''', TRAK_PLTNO = ''''  ';
  ls_sql := ls_sql + ' Where TRAK_NO = '''+ls_trak+''' ';

  Try
    With ahcomm_f.src3UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
    ahcomm_f.Memo1.Lines.Add('TBTRAK Table 수정중 에러 발생 ' + ls_sql);
  End;
end;

// 출고 완료
procedure ahsrc3_T.Cntl_OutputUpdate_Proc;
var
  ls_sql, ls_onalja, ls_trak : String;
begin
   ls_onalja := f_get_sysdate_time1();
   s_date    := Copy(ls_onalja, 1, 8);
   s_time    := Copy(ls_onalja, 9, 6);

   if (s_wsno = '1') then ls_trak := '20'
   else if (s_wsno = '2') then ls_trak := '24'
   else exit;

   ls_sql := ' update t2tbtrak  set  ';
   ls_sql := ls_sql + ' trak_index = '''+s_index+''',    ';
   ls_sql := ls_sql + ' trak_loca  = '''+s_loca+''',   trak_flag  = ''O'',          ';
   ls_sql := ls_sql + ' trak_date  = '''+s_date+''',   trak_time  = '''+s_time+''',    ';
   ls_sql := ls_sql + ' trak_gubun = '''+s_gubun+''',  trak_pltno = '''+s_pltno+'''     ';
   ls_sql := ls_sql + ' where  trak_no = '''+ls_trak+''' ';

   with ahcomm_f.src3UpdtQuery do
   begin
      try
          Close;
          SQL.Clear;
          SQL.Add(ls_sql);
          ExecSQL;
      except
          ahcomm_f.Memo1.Lines.Add('[*]tbscrc1 update error ' + ls_sql );
      end;
   end;
end;

// 입,출고 완료 처리
procedure ahsrc3_T.Cntl_IOUpdate_Proc;
var
  ls_sql, ls_onalja : String;
begin

  ls_onalja := f_get_sysdate_time1();
  s_date   := Copy(ls_onalja, 1, 8);
  s_time   := Copy(ls_onalja, 9, 6);

  ls_sql := ' Insert Into T2TIUPDT(UPDT_INDEX, UPDT_LOCA, UPDT_JOB, UPDT_DATE, UPDT_TIME, UPDT_PLTNO ) ';
  ls_sql := ls_sql + ' Values('''+s_index+''', '''+s_loca+''', '''+s_gubun+''',   ';
  ls_sql := ls_sql + '        '''+s_date+''', '''+s_time+''', '''+s_pltno+''') ';
  Try
    With ahcomm_f.src3UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
    ahcomm_f.Memo1.Lines.Add('TIUPDT Table 등록중 에러 발생 ' + ls_sql);
  End;
end;
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
procedure ahsrc3_T.Cntl_InitSelect_Proc;
var
  ls_sql, ls_trk : String;
begin
  ls_sql := ' Select STAT_SC3IO From T2TBSTAT (NOLOCK) Where STAT_PSWD = ''JPLS'' ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    sc_io := FieldByName('STAT_SC3IO').AsString;
  End;

  cv_no := '20';
  ls_sql := ' Select TRAK_INDEX From T2TBTRAK (NOLOCK) Where TRAK_NO = '''+cv_no+''' ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    if (Copy(ls_trk,9,1) = 'I') then   begin
      i_trk[1]    := Trim(FieldByName('trak_index').AsString);
    end
    else if (Copy(ls_trk,9,1) = 'O') then   begin
      O_trk[1]    := Trim(FieldByName('trak_index').AsString);
    end
    else begin
      i_trk[1] := Trim(FieldByName('trak_index').AsString);
      O_trk[1] := Trim(FieldByName('trak_index').AsString);
    end;
  End;

  cv_no := '24';
  ls_sql := ' Select TRAK_INDEX From T2TBTRAK (NOLOCK) Where TRAK_NO = '''+cv_no+''' ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    ls_trk   := Trim(FieldByName('trak_index').AsString);

    if (Copy(ls_trk,9,1) = 'I') then   begin
      i_trk[2]    := Trim(FieldByName('trak_index').AsString);
    end
    else if (Copy(ls_trk,9,1) = 'O') then   begin
      O_trk[2]  := Trim(FieldByName('trak_index').AsString);
    end
    else begin
      i_trk[2] := Trim(FieldByName('trak_index').AsString);
      O_trk[2] := Trim(FieldByName('trak_index').AsString);
    end;
  End;
  
  ls_sql := ' Select SCC3_CH05, SCC3_CH06 From T2TBSCC3 (NOLOCK) Where SCC3_SR = ''R'' ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    i_rdy[1] := '0'; i_rdy[2] := '0';  o_rdy[1] := '0'; o_rdy[2] := '0';

    If (Copy(FieldByName('SCC3_CH05').AsString, 4, 1) = '1') then i_rdy[1] := '1';
    If (Copy(FieldByName('SCC3_CH05').AsString, 4, 1) = '2') then i_rdy[2] := '1';
    If (Copy(FieldByName('SCC3_CH05').AsString, 4, 1) = '3') then begin i_rdy[1] := '1';  i_rdy[2] := '1'; end;

    If (Copy(FieldByName('SCC3_CH06').AsString, 4, 1) = '1') then o_rdy[1] := '1';
    If (Copy(FieldByName('SCC3_CH06').AsString, 4, 1) = '2') then o_rdy[2] := '1';
    If (Copy(FieldByName('SCC3_CH06').AsString, 4, 1) = '3') then begin o_rdy[1] := '1'; o_rdy[2] := '1'; end;
   End;

  ls_sql := ' Select CVC3_CH01, CVC3_CH02 From T2TBCVC3 (NOLOCK) Where CVC3_SR = ''R'' ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;


    Cv_Op[1] := Copy(FieldByName('CVC3_CH01').AsString, 16, 1);
    Cv_Op[2] := Copy(FieldByName('CVC3_CH01').AsString, 16, 1);

    i_mode[1] := Copy(FieldByName('CVC3_CH01').AsString, 10, 1);
    i_mode[2] := Copy(FieldByName('CVC3_CH01').AsString, 11, 1);

    o_mode[1] := Copy(FieldByName('CVC3_CH01').AsString, 12, 1);
    o_mode[2] := Copy(FieldByName('CVC3_CH01').AsString, 13, 1);

    Plt_Exist[1] := Copy(FieldByName('CVC3_CH01').AsString, 4, 1);
    Plt_Exist[2] := Copy(FieldByName('CVC3_CH01').AsString, 8, 1);
  End;
end;

procedure ahsrc3_T.Cntl_TbscrcSelect_Proc;
var
  ls_sql : String;
begin
  ls_sql := ' select * from t2tbscrc (NOLOCK) where scrc_no = ''3'' ';
  With ahcomm_f.src3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

     s_cycle  := Trim(FieldByName('scrc_cycle').AsString);    s_online  := Trim(FieldByName('scrc_online').AsString);
     s_ready  := Trim(FieldByName('scrc_ready').AsString);    s_high    := Trim(FieldByName('scrc_high').AsString);
     s_loca   := Trim(FieldByName('scrc_loca').AsString);     s_ack     := Trim(FieldByName('scrc_ack').AsString);
     s_load   := Trim(FieldByName('scrc_load').AsString);     s_unload  := Trim(FieldByName('scrc_unload').AsString);
     s_error  := Trim(FieldByName('scrc_error').AsString);    s_scplt   := Trim(FieldByName('scrc_scplt').AsString);
     s_posby  := Trim(FieldByName('scrc_posby').AsString);    s_poslv   := Trim(FieldByName('scrc_poslv').AsString);
     s_index  := Trim(FieldByName('scrc_index').AsString);    s_wsno    := Trim(FieldByName('scrc_wsno').AsString);
     s_desc   := Trim(FieldByName('scrc_desc').AsString);     s_pltno   := Trim(FieldByName('scrc_pltno').AsString);
     s_gubun  := Trim(FieldByName('scrc_gubun').AsString);

     s_cycle1 := copy(s_cycle,1, 1);
     s_cycle2 := copy(s_cycle,2, 1);
  End;
end;


procedure ahsrc3_T.Cntl_TbscrcUpdate_Proc;
var
  ls_sql : String;
begin
   src3_step := 4;
   s_cycle := s_cycle1 + s_cycle2;

  ls_sql := ' update t2tbscrc set ';
  ls_sql := ls_sql + ' scrc_cycle   = '''+s_cycle+''',  scrc_online  = '''+s_online+''', ';
  ls_sql := ls_sql + ' scrc_ready   = '''+s_ready+''',  scrc_high    = '''+s_high+''', ';
  ls_sql := ls_sql + ' scrc_loca    = '''+s_loca+''',   scrc_ack     = '''+s_ack+''',   ';
  ls_sql := ls_sql + ' scrc_load    = '''+s_load+''',   scrc_unload  = '''+s_unload+''', ';
  ls_sql := ls_sql + ' scrc_error   = '''+s_error+''',  scrc_scplt   = '''+s_scplt+''', ';
  ls_sql := ls_sql + ' scrc_posby   = '''+s_posby+''',  scrc_poslv   = '''+s_poslv+''',  ';
  ls_sql := ls_sql + ' scrc_index   = '''+s_index+''',  scrc_wsno    = '''+s_wsno+''', ';
  ls_sql := ls_sql + ' scrc_desc    = '''+s_desc+''',   ';
  ls_sql := ls_sql + ' scrc_gubun   = '''+s_gubun+''',  scrc_pltno   = '''+s_pltno+'''   ';
  ls_sql := ls_sql + ' where scrc_no = ''3'' ';

  Try
    With ahcomm_f.src3UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
    ahcomm_f.Memo1.Lines.Add('TBSCRC Table Update 처리중 에러 발생 ' + ls_sql);
  End;
end;

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
function ahsrc3_T.Func_LocationUpdate(F_Flag, F_loca: String): Boolean;
var
  ls_sql : String;
  ls_Result : Boolean;
begin
  ls_Result := True;
  F_loca :=  F_loca;

  ls_sql := ' Update T2MILSTK Set ';
  ls_sql := ls_sql + ' LSTK_FLAG = '''+F_Flag+''' ';
  ls_sql := ls_sql + ' Where LSTK_LOCA = '''+F_loca+''' ';


  Try
    With ahcomm_f.src3UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
    ahcomm_f.Memo1.Lines.Add('적재 위치 수정 처리중 에러 발생 ' + ls_sql);
    ls_Result := False;
  End;

  Result := ls_Result;
end;
////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
procedure ahsrc3_T.main_send_proc;
var
  ls_sql : String;
  ls_send_data: String;
  ls_conv_data: String;    

  li_Len, li_rc, li_i, li_k, li_m, li_d, li_x: Integer;
  la_Source: array [1..64] of Char;
  la_conv_buf: array [1..16] of Char;
  la_change_buf: array [1..16] of Char;

  ls_fby, ls_flv, ls_tby, ls_tlv, ls_fst, ls_tst : String;
begin

  if pb_recv_ok = False then Exit; ///
  
//  ahcomm_f.Memo1.Lines.Add('main_Send_proc ');

  ahcomm_f.src3Edit.Text := 'main_Send_proc.!!';

  ahcomm_f.src3BlueImg.Visible := True;
  ahcomm_f.src3RedImg.Visible  := False;

//  If pb_img_ok = True Then pa_w_ch01[14] := '1' else pa_w_ch01[14] := '0';

  ps_w_ch01 := '0000000000000000';

  For li_i := 1 To 16 Do Begin
    ps_w_ch01[li_i] := pa_w_ch01[li_i];
  End;   

  if (length(ps_w_ch01) <> 16) or (length(ps_w_ch02) <> 4) or
     (length(ps_w_ch03) <> 4)  or (length(ps_w_ch04) <> 4) or
     (length(ps_w_ch05) <> 4)  or (length(ps_w_ch06) <> 4) or (length(ps_w_ch07) <> 4) then exit;

  ls_sql := ' Update T2TBSCC3 Set ';
  ls_sql := ls_sql + ' SCC3_CH01 = '''+ps_w_ch01+''',  SCC3_CH02 = '''+ps_w_ch02+''', ';
  ls_sql := ls_sql + ' SCC3_CH03 = '''+ps_w_ch03+''',  SCC3_CH04 = '''+ps_w_ch04+''',  ';
  ls_sql := ls_sql + ' SCC3_CH05 = '''+ps_w_ch05+''',  SCC3_CH06 = '''+ps_w_ch06+''',  ';
  ls_sql := ls_sql + ' SCC3_CH07 = '''+ps_w_ch07+'''  ';
  ls_sql := ls_sql + ' Where SCC3_SR = ''S'' ';

  Try
    With ahcomm_f.src3UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
    ahcomm_f.Memo1.Lines.Add('T2TBSCC3 Table Update Error ' + ls_sql);
  End;

  ///

  ////////////////////////////////////////////////////////////////////////////////
  ls_send_data := ps_w_ch01;

  li_Len := Length(ls_send_data);
  MV_NDATA(@la_source[1], @ls_send_data[1], li_Len);

  li_rc := DigitToDscStr(@la_conv_buf[1], @la_source[1], li_Len);

// 송신할 data를 변환하는 도중 Data 오류이면 port로 전송하지 않는다.
  if li_rc <> 0 then exit;

  li_x := 1;
  for li_k := 1 to (li_len div 4) do
  begin
    li_d := li_k mod 4;
    li_m := li_k div 4;
    case li_d of
      1: li_x := 4;
      2: li_x := 3;
      3: li_x := 2;
      0: begin li_m := li_m - 1; li_x := 1; end;
    end;
   la_change_buf[(li_m * 4) + li_x] := la_conv_buf[li_k];
  end;

  for li_i := 1 to (li_len div 4) do
  begin
    ls_conv_data := ls_conv_data + la_change_buf[li_i];
  end;

  ahcomm_f.src3Edit.Text :='[*]CH Transmission= ' + ls_send_data;

  ls_fby       :=  Format('%4.4x', [StrToInt(Copy(ps_w_ch02,3,2))]);
  ls_flv       :=  Format('%4.4x', [StrToInt(Copy(ps_w_ch03,3,2))]);
  ls_tby       :=  Format('%4.4x', [StrToInt(Copy(ps_w_ch04,3,2))]);
  ls_tlv       :=  Format('%4.4x', [StrToInt(Copy(ps_w_ch05,3,2))]);
  ls_fst       :=  Format('%4.4x', [StrToInt(Copy(ps_w_ch06,3,2))]);
  ls_tst       :=  Format('%4.4x', [StrToInt(Copy(ps_w_ch07,3,2))]);

  ls_conv_data := ls_conv_data + ls_fby + ls_flv + ls_tby + ls_tlv + ls_fst + ls_tst;

  send_buff :=  src3_W_CMD + ls_conv_data ;

// 실제 port로 전송한다.
//  ahcomm_f.Memo1.Lines.Add('[SC#3]Send = ' + send_buff);

  ahcomm_f.src3Edit.Text := 'PORT Send Processing.!!';
  ahcomm_u.src3_Socket.Socket.SendText(send_buff);
  Sleep(200);  
////////////////////////////////////////////////////////////////////////////////

///
  ahcomm_f.src3BlueImg.Visible := True;
  ahcomm_f.src3RedImg.Visible  := False;
end;

function ahsrc3_T.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl (NOLOCK) ';
    With ahcomm_f.src3Query Do Begin
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

procedure ahsrc3_T.Error_LogDataWrite;
var
  ls_date, ls_time, ls_desc, ls_PcName : String;
begin
  LogFileName := LogFilePath + 'Stocker_error_' + FormatDateTime('yymmdd', Now) + '.log';
  AssignFile(Log_File, LogFileName);

  If FileExists(LogFileName) Then
     Append(Log_File)
  Else
     Rewrite(Log_File);

  ls_date := FormatDateTime('yyyy-mm-dd', Now);
  ls_time := FormatDateTime('hh:mm:ss', Now);
  ls_desc := ls_date + '||' + ls_time + '||' + LogText;

  Writeln(Log_File, ls_desc);
  CloseFile(Log_File);
end;

// Socket Error 프로시져 //
procedure ahsrc3_T.Error_ActionProc(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;

  If src3_Socket.Active then src3_Socket.Active := False;
     src3_Socket.Host   :=   '172.16.139.183';
     src3_Socket.Port   := StrToInt('$600');
     src3_Socket.Active := True;
end;


end.

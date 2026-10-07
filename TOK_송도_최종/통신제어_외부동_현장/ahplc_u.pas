unit ahplc_u;

interface

uses
  Windows, Classes, SysUtils, Dialogs, dbtables, Messages, ScktComp;

type
  ahplc_T = class(TThread)


  private
// 송,수신 data 전체 저장 변수선언.
    recv_buff: String;
    send_buff: String;
    
// 수신 Commend를 Setting 저장 변수선언.
//    ps_read_cmd: String;
// 수신한 data Oracle Update check 변수선언.
    pb_recv_ok: Boolean;
    pb_img_ok:  Boolean;

    ps_r_ch01: String[16];    ps_r_ch02: String[16];    ps_r_ch03: String[04];
    ps_r_ch04: String[16];    ps_r_ch05: String[16];    ps_r_ch06: String[04];
    ps_r_ch07: String[16];    ps_r_ch08: String[16];    ps_r_ch09: String[04];
    ps_r_ch10: String[16];    ps_r_ch11: String[16];    ps_r_ch12: String[16];
    ps_r_ch13: String[16];    ps_r_ch14: String[16];

    ps_w_ch01: String[16];    ps_w_ch02: String[16];    ps_w_ch03: String[16];
    ps_w_ch04: String[16];    ps_w_ch05: String[16];    ps_w_ch06: String[16];
    ps_w_ch07: String[16];    ps_w_ch08: String[16];    ps_w_ch09: String[16];
    ps_w_ch10: String[16];    ps_w_ch11: String[16];    ps_w_ch12: String[16];

  protected
    procedure Execute; override;

    procedure main_recv_proc; 
    procedure main_send_proc;

    procedure Recv_OracleUpdateProc; 
    procedure Recv_ActionProc(Sender: TObject; Socket: TCustomWinSocket);
    procedure Error_ActionProc(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  end;

var
  plc_pgm: char;
  plc_step: Integer;
  plc_ok: Integer;
  comm_sw : integer;
  pi_togle : Integer;

  sys_date  : string[14];
  s_date : string[8];
  s_time : string[6];

implementation

uses ahcomm_u, Convision_u;     

procedure ahplc_T.Execute;
begin
  plc_step := 0;  // recv:10, send:20, cntl:30
  
  plc_pgm  := 'T';
  comm_sw   := 0;
  plc_ok   := 1;
  pi_togle  := 1;
  pb_img_ok := False;

  ahcomm_f.plcEdit.Text := '통신개시 작업을 하였습니다.!!';

  ahcomm_u.Client_Socket.OnRead  := Recv_ActionProc;
  ahcomm_u.Client_Socket.OnError := Error_ActionProc;
  sleep(1000);

  While (not (plc_T.Terminated)) and (plc_pgm = 'T') do
  begin
    if (ahcomm_f.Memo1.Lines.Count > 30) then ahcomm_f.Memo1.Lines.Clear; 
    if pb_img_ok = True then   // 폼 이미지
    begin
     pb_img_ok := False;
     ahcomm_f.plcimg.Visible := False;
    end
    else
    begin
      pb_img_ok := True;
      ahcomm_f.plcimg.Visible := True;
    end;
    main_recv_proc;
    sleep(200);
    main_send_proc;
    sleep(200);
  end;

// 통신 port를 close 한다.  
  ahcomm_f.plcEdit.Text := '통신종료 작업을 하였습니다.!!';
  ahcomm_u.Client_Socket.Close;
  plc_pgm := 'F';
end;

procedure ahplc_T.main_recv_proc;
var
  li_Len, li_rc, li_i, li_k, li_x, li_d, li_m: Integer;
  la_Source  :  array [1..48] of Char;
  la_conv_buf:  array [1..192] of Char;

  ls_recv_data: String;
  ls_conv_data: String;
  ls_rack_mode: String;
begin
  recv_buff := '';
  ahcomm_f.plcEdit.Text := 'Port Receive Processing.!!';

// Read Command 를 송신한다.
  send_buff := PLC_R_CMD;
  ahcomm_f.Memo1.Lines.Add('Read =' + Send_buff);
  ahcomm_u.Client_Socket.Socket.SendText(send_buff);
  Sleep(200);

// 실제로 recv data 얻는다.
  ls_rack_mode := recv_buff;

// 수신응답 모드가 이상이면 data를 변환하지 않는다.
  if (Length(ls_rack_mode) = 0) and (Copy(ls_rack_mode, 1, 1) <> 'D') then
  begin
    pb_recv_ok := False;
    exit;
  end;

  If Length(recv_buff) < 23 Then Begin
    ahcomm_f.Memo1.Lines.Add(' Send Ack Receive : ' + recv_buff);
    pb_recv_ok := False;
    exit;
  End;
/////////////////////////////////////////////////
// 실제Data만 가져와서 변수에 저장한다....
/////////////////////////////////////////////////
 li_len := Length(recv_buff);
 If Not (li_len = 78)  Then Exit;
/////////////////////////////////////////////////
// 실제Data만 가져와서 변수에 저장한다....
/////////////////////////////////////////////////
  ls_recv_data := Copy(recv_buff, 23, 56);

  ps_r_ch03 := Copy(ls_recv_data,  9, 4);
  ps_r_ch06 := Copy(ls_recv_data, 21, 4);
  ps_r_ch09 := Copy(ls_recv_data, 33, 4);

  ps_r_ch03  := Format('%4.4d', [StrToInt('$' + Copy(ps_r_ch03, 1, 4))]);
  ps_r_ch06  := Format('%4.4d', [StrToInt('$' + Copy(ps_r_ch06, 1, 4))]);
  ps_r_ch09  := Format('%4.4d', [StrToInt('$' + Copy(ps_r_ch09, 1, 4))]);

  ls_recv_data :=  Copy(ls_recv_data,1,8) + Copy(ls_recv_data,13,8) + Copy(ls_recv_data,25,8) + Copy(ls_recv_data,37,20);


// 수신한 data를 변환하는 Module start
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
// ahcomm_f.Memo1.Lines.Add ('convert =' + ls_conv_data);

  ps_r_ch01 := Copy(ls_conv_data,   1, 16);  ps_r_ch02 := Copy(ls_conv_data,  17, 16);
  ps_r_ch04 := Copy(ls_conv_data,  33, 16);  ps_r_ch05 := Copy(ls_conv_data,  49, 16);
  ps_r_ch07 := Copy(ls_conv_data,  65, 16);  ps_r_ch08 := Copy(ls_conv_data,  81, 16);
  ps_r_ch10 := Copy(ls_conv_data,  97, 16);  ps_r_ch11 := Copy(ls_conv_data, 113, 16);
  ps_r_ch12 := Copy(ls_conv_data, 129, 16);  ps_r_ch13 := Copy(ls_conv_data, 145, 16);
  ps_r_ch14 := Copy(ls_conv_data, 161, 16); 

//  ahcomm_f.Memo1.Lines.Add ('li_rc =' + IntToStr(li_rc));
  
  if    li_rc = 0 then pb_recv_ok := True
  else  pb_recv_ok := False;       

  if pb_recv_ok = True  then Recv_OracleUpdateProc;
end;    
////////////////////////////////////////////////////////
////    recv_action_proc;
///////////////////////////////////////////////////////

/// Read, Send Data 수신 ////
procedure ahplc_T.Recv_ActionProc(Sender: TObject; Socket: TCustomWinSocket);
begin  
  ahcomm_f.plcEdit.Text := 'Receive Action Processing.!!';

  recv_buff  := '';
  recv_buff := ahcomm_u.Client_Socket.Socket.ReceiveText;
  ahcomm_f.Memo1.Lines.Add('수신=' + recv_buff);
end;

///////////////////////////////////////////////////////////////////////
///    Recv_OracleUpdateProc;
///////////////////////////////////////////////////////////////////////
procedure ahplc_T.Recv_OracleUpdateProc;
begin
  plc_step := 10;

  ahcomm_f.plcEdit.Text := 'Receive Oracle Update Processing';   
  try
    with ahcomm_f.plcQuery do
    begin

      plc_step := 11;
      Close;
      SQL.Clear;
      SQL.Add(' update stk1_tbscc1 set  ');
      SQL.Add(' scc1_ch01 = '''+ps_r_ch01+''', scc1_ch02 = '''+ps_r_ch02+''', ');
      SQL.Add(' scc1_ch04 = '''+ps_r_ch03+'''  ');
      SQL.Add(' where scc1_sr = ''R'' ');
      ExecSQL;

      plc_step := 12;

      Close;
      SQL.Clear;
      SQL.Add(' update stk1_tbscc2 set  ');
      SQL.Add(' scc2_ch01 = '''+ps_r_ch04+''', scc2_ch02 = '''+ps_r_ch05+''', ');
      SQL.Add(' scc2_ch04 = '''+ps_r_ch06+'''  ');
      SQL.Add(' where scc2_sr = ''R'' ');
      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add(' update stk1_tbscc3 set  ');
      SQL.Add(' scc3_ch01 = '''+ps_r_ch07+''', scc3_ch02 = '''+ps_r_ch08+''', ');
      SQL.Add(' scc3_ch04 = '''+ps_r_ch09+'''  ');
      SQL.Add(' where scc3_sr = ''R'' ');
      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add(' update stk1_tbcvc1 set  ');
      SQL.Add(' cvc1_ch01  = '''+ps_r_ch10+''',  cvc1_ch02 = '''+ps_r_ch11+''', ');
      SQL.Add(' cvc1_ch03  = '''+ps_r_ch12+''',  cvc1_ch04 = '''+ps_r_ch13+''', ');
      SQL.Add(' cvc1_ch05  = '''+ps_r_ch14+''' ');
      SQL.Add(' where cvc1_sr = ''R'' ');
      ExecSQL;
    end;
  except
    begin
      ahcomm_f.Memo1.Lines.Add('[*]tbplc Update error ' + IntToStr(plc_step));
    end;
  end;
end;

/////////////////////////////////////////////////
procedure ahplc_T.main_send_proc;
var
// 송신할 data를 변환하는 Module 변수선언
  ls_send_data: String;
  ls_conv_data: String;    

  li_Len, li_rc, li_i, li_k, li_m, li_d, li_x: Integer;
  la_Source: array [1..192] of Char;
  la_conv_buf: array [1..48] of Char;
  la_change_buf: array [1..48] of Char;
begin

  if pb_recv_ok = False  then  Exit;

  plc_step := 20;
  send_buff := '';
  ahcomm_f.plcEdit.Text := 'PORT Send Processing.!!';

  with ahcomm_f do
  begin
    try

      plc_step := 24;

      plcQuery.Close;
      plcQuery.SQL.Clear;
      plcQuery.SQL.Add(' select scc1_ch01, scc1_ch02, scc1_ch03  ');
      plcQuery.SQL.Add('   from stk1_tbscc1 (nolock)  where scc1_sr = ''S''');
      plcQuery.open;

      ps_w_ch01 := plcQuery.FieldByName('scc1_ch01').AsString;    ps_w_ch02 := plcQuery.FieldByName('scc1_ch02').AsString;
      ps_w_ch03 := plcQuery.FieldByName('scc1_ch03').AsString;

      plc_step := 25;

      plcQuery.Close;
      plcQuery.SQL.Clear;
      plcQuery.SQL.Add(' select scc2_ch01, scc2_ch02, scc2_ch03 ');
      plcQuery.SQL.Add('   from stk1_tbscc2 (nolock) where scc2_sr = ''S''');
      plcQuery.open;

      ps_w_ch04 := plcQuery.FieldByName('scc2_ch01').AsString;    ps_w_ch05 := plcQuery.FieldByName('scc2_ch02').AsString;
      ps_w_ch06 := plcQuery.FieldByName('scc2_ch03').AsString;

      plc_step := 26;

      plcQuery.Close;
      plcQuery.SQL.Clear;
      plcQuery.SQL.Add(' select scc3_ch01, scc3_ch02, scc3_ch03 ');
      plcQuery.SQL.Add('   from stk1_tbscc3 (nolock) where scc3_sr = ''S''');
      plcQuery.open;

      ps_w_ch07 := plcQuery.FieldByName('scc3_ch01').AsString;    ps_w_ch08 := plcQuery.FieldByName('scc3_ch02').AsString;
      ps_w_ch09 := plcQuery.FieldByName('scc3_ch03').AsString;

      plc_step := 27;

      plcQuery.Close;
      plcQuery.SQL.Clear;
      plcQuery.SQL.Add(' select cvc1_ch01, cvc1_ch02, cvc1_ch03 ');
      plcQuery.SQL.Add('   from stk1_tbcvc1 (nolock) where cvc1_sr = ''S'' ');
      plcQuery.open;

      ps_w_ch10 := plcQuery.FieldByName('cvc1_ch01').AsString;    ps_w_ch11 := plcQuery.FieldByName('cvc1_ch02').AsString;
      ps_w_ch12 := plcQuery.FieldByName('cvc1_ch03').AsString;
    except
      ahcomm_f.Memo1.Lines.Add('plc1 SEND STEP=' + IntToStr(plc_step));
    end;
  end;


  ls_send_data := ps_w_ch01 + ps_w_ch02 + ps_w_ch03 + ps_w_ch04 + ps_w_ch05 + ps_w_ch06 + ps_w_ch07 + ps_w_ch08 +
                  ps_w_ch09 + ps_w_ch10 + ps_w_ch11 + ps_w_ch12;

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

  ahcomm_f.plcEdit.Text :='[*]채널 송신= ' + ls_send_data;

  send_buff := PLC_W_CMD + ls_conv_data;

// 실제 port로 전송한다.
  ahcomm_f.Memo1.Lines.Add('Send = ' + send_buff);

  ahcomm_f.plcEdit.Text := 'PORT Send Processing.!!';
  ahcomm_u.Client_Socket.Socket.SendText(send_buff);
  Sleep(200);
end;

// Socket Error 프로시져 //
procedure ahplc_T.Error_ActionProc(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;

  If Client_Socket.Active then Client_Socket.Active := False;
     Client_Socket.Host := '192.168.16.131';
     Client_Socket.Port := StrToInt('$600');
     Client_Socket.Active := True;
end;          

end.

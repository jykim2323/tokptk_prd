unit ahcvc3_u;

interface

uses
  Windows, Classes, SysUtils, Dialogs, dbtables, Messages, ScktComp,
  WinTypes, WinProcs, controls;

type
  ahcvc3_T = class(TThread)
  private

    recv_buff: String;
    send_buff: String;
    
// 수신 Commend를 Setting 저장 변수선언.
//    ps_read_cmd: String;
// 수신한 data Oracle Update check 변수선언.
    pb_recv_ok : Boolean;
    pb_send_ok : Boolean;

    pb_img_ok:  Boolean;    

    ps_r_ch01: String[16];    ps_r_ch02: String[16];
    pa_r_ch01: array [1..16] of Char;    pa_r_ch02: array [1..16] of Char;

    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;

    ps_no, ps_from, ps_to, Pos_no : String;

    TRAK_INDEX : Array[1..24] of String;
    TRAK_LOCA  : Array[1..24] of String;     TRAK_FLAG    : Array[1..24] of String;
    TRAK_DATE  : Array[1..24] of String;     TRAK_TIME    : Array[1..24] of String;
    TRAK_GUBUN : Array[1..24] of String;     TRAK_HIGH    : Array[1..24] of String;
    TRAK_PLTNO : Array[1..24] of String;

    From_Pos, To_Pos, Cmd_Pos, Cmd_jisi: Integer;

    Plt_Exist : Array[1..24] of Char;
    Str_Cmd : Array[1..2] of Char;
    Str_End : Array[1..2] of Char;
    Cv_OP   : Array[1..2] of Char;
    i_mode  :  array [1..2] of Char;
    o_mode  :  array [1..2] of Char;

  sys_datetime  : string[14];

  protected
    procedure Execute; override;
    procedure main_recv_proc;
    procedure Recv_ActionProc(Sender: TObject; Socket: TCustomWinSocket);
    procedure Error_ActionProc(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);

    procedure main_send_proc;
    procedure Recv_OracleUpdateProc;

   
    procedure main_cntl_proc;   

    procedure Cntl_TBcvc3TableSelect;
  
    procedure Cntl_StrToArrayProc;
    procedure Cntl_TrakMove_Proc;
    procedure Cntl_TrakOneDelete_Proc;    

    function f_get_sysdate_time1(): String;
  end;
var
  cvc3_pgm : char;
  cvc3_step: Integer;   

implementation

uses ahcomm_u, Convision_u, DB, ADODB;

procedure ahcvc3_T.Execute;
var
  IntPos : Integer;
begin
  cvc3_pgm := 'T';
  pb_img_ok := False;

  pb_recv_ok := True;
  pb_send_ok := False;

  
  ahcomm_f.cvc3Edit.Text := '통신개시 작업을 하였습니다.!!';

  ahcomm_u.cvc3_Socket.OnRead  := Recv_ActionProc;     ///
  ahcomm_u.cvc3_Socket.OnError := Error_ActionProc;    ///


  ahcomm_f.cvc3Edit.Text := '통신개시 작업을 하였습니다.!!';
  For IntPos := 17 to 24 do
   Begin
     TRAK_INDEX[IntPos]   := '';       TRAK_HIGH[IntPos]    := '';
     TRAK_GUBUN[IntPos]   := '';
     TRAK_DATE[IntPos]    := '';       TRAK_TIME[IntPos]     := '';
     TRAK_FLAG[IntPos]    := '';       TRAK_LOCA[IntPos]     := '';
     TRAK_PLTNO[IntPos]   := '';     
  End;


  Sleep(1000);
  While (Not (cvc3_T.Terminated)) And (cvc3_pgm = 'T') Do Begin
    if ahcomm_f.Memo1.Lines.Count >= 300 then ahcomm_f.Memo1.Lines.Clear;

    If pb_img_ok = True Then Begin
      pb_img_ok := False;
    End Else Begin
      pb_img_ok := True;   
    End;

      main_recv_proc;   ///

      Sleep(200);

      Cntl_TBcvc3TableSelect;
      main_cntl_proc;
      main_Send_proc;

      Sleep(500);

  End;
  // 통신 port를 close 한다.

  ahcomm_u.cvc3_Socket.Close;     ///

  ahcomm_f.cvc3BlueImg.Visible := False;
  ahcomm_f.cvc3RedImg.Visible  := True;
  ahcomm_f.cvc3Edit.Text := '통신종료 작업을 하였습니다.!!';
  cvc3_pgm := 'F';
end;

procedure ahcvc3_T.main_recv_proc;
var
  li_Len, li_rc, li_i, li_k, li_x, li_d, li_m: Integer;
  la_Source  :  array [1..40] of Char;
  la_conv_buf:  array [1..160] of Char;

  ls_recv_data: String;
  ls_conv_data: String;
  ls_rack_mode: String;

begin
  recv_buff := '';
  ahcomm_f.cvc3Edit.Text := 'Port Receive Processing.!!';

// Read Command 를 송신한다.
  send_buff := cvc3_R_CMD;
//  ahcomm_f.Memo1.Lines.Add('[CVC]Read =' + Send_buff);
  ahcomm_u.cvc3_Socket.Socket.SendText(send_buff);
  Sleep(300);

// 실제로 recv data 얻는다.
   ls_rack_mode := recv_buff;

  if (Length(ls_rack_mode) = 0) and (Copy(ls_rack_mode, 1, 1) <> 'D') then
  begin
    ahcomm_f.Memo1.Lines.Add('Receive Error =' + ls_rack_mode);
    ahcomm_f.cvc3BlueImg.Visible := False;
    ahcomm_f.cvc3RedImg.Visible  := True;

    pb_recv_ok := False;
    exit;
  end;

  li_len := Length(recv_buff);

  If Length(recv_buff) < 23 Then Begin
    ahcomm_f.Memo1.Lines.Add(' Send Ack Receive : ' + recv_buff);
    pb_recv_ok := False;
    exit;
  End;


 If Not (li_len = 30)  Then Begin
    ahcomm_f.cvc3BlueImg.Visible := False;
    ahcomm_f.cvc3RedImg.Visible  := True;
    pb_recv_ok := False;
    exit;
 End;    
/////////////////////////////////////////////////
// 실제Data만 가져와서 변수에 저장한다....
/////////////////////////////////////////////////
  ls_recv_data := Copy(recv_buff, 23, 8);

// 수신한 data를 변환하는 Module start
  ls_recv_data := Copy(ls_recv_data, 1, 8);

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

//  ahcomm_f.Memo1.Lines.Add('convert =' + ls_conv_data);

  ps_r_ch01 := Copy(ls_conv_data,   1, 16);  ps_r_ch02 := Copy(ls_conv_data,  17, 16);

  if    li_rc = 0 then pb_recv_ok := True
  else  pb_recv_ok := False;

  if pb_recv_ok = True  then Recv_OracleUpdateProc;

end;
///////////////////////////////////////////////////////////////////////
///    Recv_OracleUpdateProc;
///////////////////////////////////////////////////////////////////////
procedure ahcvc3_T.Recv_OracleUpdateProc;
var
   var_sql : String;
begin
  cvc3_step := 10;  

  ahcomm_f.cvc3Edit.Text := 'Receive Oracle Update Processing';
  var_sql := ' update T2tbcvc3 set ';
  var_sql := var_sql + ' cvc3_CH01 = '''+ps_r_ch01+''', cvc3_CH02 = '''+ps_r_ch02+''' ';
  var_sql := var_sql + ' where cvc3_sr = ''R'' ';
  try
    with ahcomm_f.cvc3Query do
    begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      ExecSQL;
    end;
  except
    begin
      ahcomm_f.Memo1.Lines.Add('[*]tbcvc3 Update error ' + var_sql);
    end;
  end;
end;
///////////////////////////////////////////////////////////////////////  

procedure ahcvc3_T.Cntl_TBcvc3TableSelect;
var
  ls_sql : String;
  IntPos : Integer;
begin
  ahcomm_f.cvc3Edit.Text := 'Cntl_TBcvc3TableSelect.!!';
  ls_sql := ' Select *  From T2tbcvc3 (NOLOCK) ';
  ls_sql := ls_sql + ' Where cvc3_Sr = ''R'' ';
  With ahcomm_f.cvc3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    If Eof Then Exit;
    ps_r_ch01 := FieldByName('cvc3_CH01').AsString;
    ps_r_ch02 := FieldByName('cvc3_CH02').AsString;
  End;

  ls_sql := ' Select cvc3_CH01 From T2tbcvc3 (NOLOCK) ';
  ls_sql := ls_sql + ' Where cvc3_Sr = ''S'' ';

  With ahcomm_f.cvc3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    If Eof Then Exit;
    ps_w_ch01 := FieldByName('cvc3_CH01').AsString;
  End;

  Cntl_StrToArrayProc;   

  ls_sql := ' Select * From T2TBTRAK (NOLOCK)   ';
  ls_sql := ls_sql + ' Where TRAK_NO BETWEEN ''17'' AND ''24'' ';
  ls_sql := ls_sql + ' ORDER BY TRAK_NO ';
  With ahcomm_f.cvc3Query Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;

    While Not Eof Do
    Begin
     IntPos     := FieldByNAme('TRAK_NO').AsInteger;
     Trak_index[IntPos] := Trim(FieldByName('TRAK_INDEX').AsString);
     Trak_Loca[IntPos]  := Trim(FieldByName('TRAK_LOCA').AsString);    Trak_Flag[IntPos]    := Trim(FieldByName('TRAK_FLAG').AsString);
     Trak_date[IntPos]  := Trim(FieldByName('TRAK_DATE').AsString);    Trak_time[IntPos]    := Trim(FieldByName('TRAK_TIME').AsString);
     Trak_gubun[IntPos] := Trim(FieldByName('TRAK_GUBUN').AsString);
     Trak_high[IntPos]  := Trim(FieldByName('TRAK_HIGH').AsString);
     Trak_pltno[IntPos]  := Trim(FieldByName('TRAK_PLTNO').AsString);
     Next;
   End;
  End;
end;

procedure ahcvc3_T.Cntl_StrToArrayProc;
var
   i : integer;
begin
  MV_NDATA(@pa_r_ch01[1], @ps_r_ch01[1], 16);  MV_NDATA(@pa_r_ch02[1], @ps_r_ch02[1], 16);
  MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);
  
  for i := 1  to 8 Do
  begin
    Plt_Exist[16 + i] := pa_r_ch01[i];
  end;

  for i := 1  to 2 Do
  begin
     Str_Cmd[i] := pa_w_ch01[i];;   Str_End[i] := pa_r_ch02[i];
  end;

   cv_op[01]  := pa_r_ch01[16];    cv_op[02]  := pa_r_ch01[16];
   i_mode[01] := pa_r_ch01[10];    i_mode[02] := pa_r_ch01[11];    // i_mode[01] 17 구간 입고 모드 , i_mode[02] 21 구간 입고 모드
   o_mode[01] := pa_r_ch01[12];    o_mode[02] := pa_r_ch02[13];
end;

/////////////////////////////////////////////////////////////
////////////  Main_Cntl_proc                /////////////////
/////////////////////////////////////////////////////////////
procedure ahcvc3_T.main_cntl_proc;
var
  BoolRept : Boolean;
  IntPos : Integer;
begin

  if pb_recv_ok = False then Exit; ///
  
   For IntPos := 24  Downto 17 Do
   Begin
      Case IntPos of
         18..19 :   // Tracking 이동 구간
         Begin
            if (Cv_OP[1] = '0') Or (i_mode[01] = '0') Then Continue;

            From_Pos := IntPos;
            To_Pos   := IntPos + 1;

            If (Copy(Trak_index[From_Pos],9,1) = 'I')    then
            begin
              if (Trak_index[From_Pos] <> '') And (Trak_index[To_Pos] = '')  Then Cntl_TrakMove_Proc;
            end;
         End;

         22..23 :   // Tracking 이동 구간
         Begin
            if (Cv_OP[2] = '0') Or (i_mode[02] = '0') Then Continue;

            From_Pos := IntPos;
            To_Pos   := IntPos + 1;

            If (Copy(Trak_index[From_Pos],9,1) = 'I')    then
            begin     
              if (Trak_index[From_Pos] <> '') And (Trak_index[To_Pos] = '')  Then Cntl_TrakMove_Proc;
            end;
         End;

         17: // 직진 지시
         Begin
            From_Pos := IntPos;
            To_Pos   := IntPos + 1;
            Cmd_pos  := 1;
            Cmd_jisi := 1;

            if      (Trak_Flag[From_Pos] = '1')  then begin pa_w_ch01[11] := '1'; pa_w_ch01[12] := '0';  pa_w_ch01[13] := '0';  end
            else if (Trak_Flag[From_Pos] = '2')  then begin pa_w_ch01[11] := '0'; pa_w_ch01[12] := '1';  pa_w_ch01[13] := '0';  end
            else if (Trak_Flag[From_Pos] >= '3') then begin pa_w_ch01[11] := '0'; pa_w_ch01[12] := '0';  pa_w_ch01[13] := '1';  end
            else  begin pa_w_ch01[11] := '0'; pa_w_ch01[12] := '0';  pa_w_ch01[13] := '0';  end;

            // 직진 완료 처리
            If (Copy(Trak_index[From_Pos],9,1) = 'I')  And
               (Trak_index[From_Pos] <> '') And (Trak_index[To_Pos] = '') And
               (Str_Cmd[Cmd_Pos] = '1')     And (Str_End[Cmd_Pos] = '1')  And
               (i_mode[01] = '1')    Then
            Begin
               Cntl_TrakMove_Proc;
               Str_Cmd[Cmd_Pos] := '0';
               Continue;
            End;

            if (Trak_index[From_Pos] = '????')   then   Continue; // ???

            // 직진 지령 처리
            If (Copy(Trak_index[From_Pos],9,1) = 'I')  And
               (Trak_index[From_Pos] <> '') And (Trak_index[To_Pos]  = '')    And
               (Plt_Exist[From_Pos] = '1')  And (Plt_Exist[To_Pos]  = '0')    And
               (Str_Cmd[Cmd_Pos] = '0')     And (Str_End[Cmd_Pos] = '0')      And
               (i_mode[01] = '1')    Then
            Begin
                Str_Cmd[Cmd_Pos] := '1';
                Continue;
            End;
         End;

         21: // 직진 지시
         Begin
            From_Pos := IntPos;
            To_Pos   := IntPos + 1;
            Cmd_pos  := 2;
            Cmd_jisi := 2;

            // 직진 완료 처리
            If (Copy(Trak_index[From_Pos],9,1) = 'I')  And
               (Trak_index[From_Pos] <> '') And (Trak_index[To_Pos] = '') And
               (Str_Cmd[Cmd_Pos] = '1')     And (Str_End[Cmd_Pos] = '1')  And
               (i_mode[02] = '1')    Then
            Begin
               Cntl_TrakMove_Proc;
               Str_Cmd[Cmd_Pos] := '0';
               Continue;
            End;

            // 직진 지령 처리
            If (Copy(Trak_index[From_Pos],9,1) = 'I')  And
               (Trak_index[From_Pos] <> '') And (Trak_index[To_Pos]  = '')    And
               (Plt_Exist[From_Pos] = '1')  And (Plt_Exist[To_Pos]  = '0')    And
               (Str_Cmd[Cmd_Pos] = '0')     And (Str_End[Cmd_Pos] = '0')      And
               (i_mode[02] = '1')    Then
            Begin
                Str_Cmd[Cmd_Pos] := '1';
                Continue;
            End;
         End;

         20, 24: // 출고삭제
         Begin
            From_Pos := IntPos;

            if (Copy(Trak_index[From_Pos],9,1) = 'O')  Then Cntl_TrakOneDelete_Proc;
         End;



      End;
  End;

  For IntPos := 1 to 2 do   Begin  pa_w_ch01[IntPos] := Str_Cmd[IntPos];   End;
end;   


procedure ahcvc3_T.Cntl_TrakMove_Proc;
Var
   ls_PosNo, ls_sql : String;
begin
   ls_PosNo := Format('%2.2d', [To_Pos]);

   ls_sql := ls_sql + ' Trak_index  = '''',    Trak_loca  = '''',     Trak_flag = '''',  ';
   ls_sql := ls_sql + ' Trak_date  = '''',     Trak_time = '''',      Trak_gubun = '''',   ';
   ls_sql := ls_sql + ' Trak_high  = '''',     Trak_pltno = '''' '; // 추가

   ls_sql := ' update T2TBTRAK set ';
   ls_sql := ls_sql + ' Trak_index   = '''+Trak_index[From_Pos]+''',   Trak_high    = '''+Trak_high[From_Pos]+''',   ';
   ls_sql := ls_sql + ' Trak_gubun   = '''+Trak_gubun[From_Pos]+''',      ';
   ls_sql := ls_sql + ' Trak_date    = '''+Trak_date[From_Pos]+''',    Trak_time     = '''+Trak_time[From_Pos]+''',   ';
   ls_sql := ls_sql + ' Trak_Flag    = '''+Trak_flag[From_Pos]+''',    Trak_Loca    = '''+Trak_Loca[From_Pos]+''', ';
   ls_sql := ls_sql + ' Trak_Pltno    = '''+Trak_pltno[From_Pos]+''' ';
      
   ls_sql := ls_sql + ' where trak_no = '''+ls_PosNo+''' ';
  Try
   With ahcomm_f.cvc3UpdtQuery do
   Begin
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        ExecSQL;
   End;

   ls_PosNo   := Format('%2.2d', [From_Pos]);
   ls_sql := ' update T2TBTRAK set ';
   ls_sql := ls_sql + ' Trak_index  = '''',   Trak_gubun  = '''',    Trak_high = '''',  ';
   ls_sql := ls_sql + ' Trak_date  = '''',    Trak_time = '''',     Trak_Flag    = '''',     Trak_Loca    = '''',     Trak_Pltno    = ''''   ';
   ls_sql := ls_sql + ' where trak_no = '''+ls_PosNo+''' ';
   With ahcomm_f.cvc3UpdtQuery do
   Begin
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        ExecSQL;
   End;

  Except
    ahcomm_f.Memo1.Lines.Add(' Update error = ' + ls_sql);
  End;
end;

procedure ahcvc3_T.Cntl_TrakOneDelete_Proc;
Var
   ls_PosNo, ls_sql : String;
begin     
   ls_PosNo   := Format('%2.2d', [From_Pos]);
   ls_sql := ' update t2tbtrak set ';
   ls_sql := ls_sql + ' Trak_index  = '''',    Trak_loca  = '''',     Trak_flag = '''',  ';
   ls_sql := ls_sql + ' Trak_date  = '''',     Trak_time = '''',      Trak_gubun = '''',   ';
   ls_sql := ls_sql + ' Trak_high  = '''',     Trak_pltno  = ''''   ';
   ls_sql := ls_sql + ' where trak_no = '''+ls_PosNo+''' ';
  Try
   With ahcomm_f.cvc3UpdtQuery do
   Begin
        Close;
        SQL.Clear;
        SQL.Add(ls_sql);
        ExecSQL;
   End;

  Except
    ahcomm_f.Memo1.Lines.Add(' Update error = ' + ls_sql);
  End;
end;


procedure ahcvc3_T.main_send_proc;
var
  ls_sql : String;
  ls_send_data: String;
  ls_conv_data: String;

  ls_StrToHex_data, s_zero, ls_StrToHex_data2,ls_StrToHex_data3,ls_StrToHex_data4,ls_StrToHex_data5, ls_ok : String;

  li_Len, li_rc, li_i, li_k, li_m, li_d, li_x: Integer;
  la_Source: array [1..48] of Char;
  la_conv_buf: array [1..12] of Char;
  la_change_buf: array [1..12] of Char;
begin

  if pb_recv_ok = False then Exit; ///
  
  
  ahcomm_f.cvc3Edit.Text := 'main_Send_proc.!!';

  ahcomm_f.cvc3BlueImg.Visible := True;
  ahcomm_f.cvc3RedImg.Visible  := False;

  if pb_img_ok = True then  pa_w_ch01[16] := '1'  else pa_w_ch01[16] := '0';

  /////////////////////////////Door Open, close///////////////////////////////////////
  If (pa_r_ch02[05] = '1') And (pa_w_ch01[05] = '1') Then pa_w_ch01[05] := '0';
  If (pa_r_ch02[06] = '1') And (pa_w_ch01[06] = '1') Then pa_w_ch01[06] := '0';

  If (pa_r_ch02[07] = '1') And (pa_w_ch01[07] = '1') Then pa_w_ch01[07] := '0';
  If (pa_r_ch02[08] = '1') And (pa_w_ch01[08] = '1') Then pa_w_ch01[08] := '0';
///////////////////////////////////////////////////////////////////////////////
 

  ps_w_ch01 := '0000000000000000';
  
  For li_i := 1 To 16 Do Begin  ps_w_ch01[li_i] := pa_w_ch01[li_i];   End;
           
  ls_sql := ' Update T2tbcvc3 Set ';
  ls_sql := ls_sql + ' cvc3_CH01 = '''+ps_w_ch01+''' ';
  ls_sql := ls_sql + ' Where cvc3_SR = ''S'' ';

  Try
    With ahcomm_f.cvc3UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
    ahcomm_f.Memo1.Lines.Add('TBcvc3 Table Update Error ' + ls_sql);
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


  ahcomm_f.cvc3Edit.Text :='[*]CH Transmission= ' + ls_send_data;  //채널 송신

  send_buff := cvc3_W_CMD + ls_conv_data;

//  ahcomm_f.Memo1.Lines.Add('[CVC]Send = ' + send_buff);

  ahcomm_f.cvc3Edit.Text := 'PORT Send Processing.!!';
  ahcomm_u.cvc3_Socket.Socket.SendText(send_buff);
  Sleep(200);
////////////////////////////////////////////////////////////////////////////////

   ///

  ahcomm_f.cvc3BlueImg.Visible := True;
  ahcomm_f.cvc3RedImg.Visible  := False;
end;

////////////////////////////////////////////////////////
////    recv_action_proc;
///////////////////////////////////////////////////////
/// Read, Send Data 수신 ////
procedure ahcvc3_T.Recv_ActionProc(Sender: TObject; Socket: TCustomWinSocket);
begin
  ahcomm_f.cvc3Edit.Text := 'Receive Action Processing.!!';

  recv_buff  := '';
  recv_buff := ahcomm_u.cvc3_Socket.Socket.ReceiveText;
  ahcomm_f.Memo1.Lines.Add('[CVC#3]Recv=' + recv_buff);
end;     


// Socket Error 프로시져 //
procedure ahcvc3_T.Error_ActionProc(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;

  If cvc3_Socket.Active then cvc3_Socket.Active := False;
     cvc3_Socket.Host   :=   '172.16.139.183';
     cvc3_Socket.Port := StrToInt('$601');
     cvc3_Socket.Active := True;
end;


function ahcvc3_T.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl (NOLOCK) ';
    With ahcomm_f.SelQuery Do Begin
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

unit Convision_u;

interface

uses WinTypes, WinProcs, SysUtils, classes, controls, Dialogs;

const

  STX = #02;
  ETX = #03;
  EOT = #04;
  ENQ = #05;
  ACK = #06;
  NAK = #15;

// 4800, 8, 0, 1
// PLC: Gold Sec 3번 Type  CVC1 변수선언
// STX + STNO:00 + PCNO:FF + COMD:CR + WMSG:1 + ADDR:00300 + DATL:14 + ETX
  CVC1_R_CMD = '00FFCR10030014';
// 수신 Data = STX + STNO:00 + PCNO:FF + COMD:(CR:정상) + RDATA:56Byte(14*4) + ETX
// 수신 Data = STX + STNO:00 + PCNO:FF + COMD:(NN:에러응답) + ERR_CODE:2Byte + ETX

// STX + STNO:00 + PCNO:FF + COMD:GG + ETX (Read한후 Ack 송신).
  CVC1_A_CMD = '00FFGG';

// STX + STNO:00 + PCNO:FF + COMD:CW + WMSG:1 + ADDR:00200 + DATL:05 + WDATA:20Byte(5*4) + ETX
  CVC1_W_CMD = '00FFCW10020005';

//    1.BAUD  RATE: 1200,2400,4800,9600
//    2.DATA   BIT: 7, 8.
//    3.PARITY BIT: 0 =  No , 1 = Odd, 2 = Even
//    4.STOP   BIT: 1 =  1 stop, 2 = 2 stop
// 4800, 8, 0, 1
// PLC: Gold Sec 3번 Type  CVC1 변수선언
// STX + STNO:00 + PCNO:FF + COMD:CR + WMSG:1 + ADDR:00300 + DATL:38 + ETX
  CVC2_R_CMD = '00FFCR10030038';
// 수신 Data = STX + STNO:00 + PCNO:FF + COMD:(CR:정상) + RDATA:152Byte(38*4) + ETX
// 수신 Data = STX + STNO:00 + PCNO:FF + COMD:(NN:에러응답) + ERR_CODE:2Byte + ETX

// STX + STNO:00 + PCNO:FF + COMD:GG + ETX (Read한후 Ack 송신).
  CVC2_A_CMD = '00FFGG';

// STX + STNO:00 + PCNO:FF + COMD:CW + WMSG:1 + ADDR:00200 + DATL:06 + WDATA:24Byte(6*4) + ETX
  CVC2_W_CMD = '00FFCW10034006';
  
// bcr start commend
  BCR_S_CMD = 'S';
// bcr end commend
  BCR_E_CMD = 'E';
// bcr no read data format
  BCR_NO_READ = '??????????????';


// 사용할 함수및 프로시저 선언
  function  GetBit(Data: Word; Bits: Integer): WORD; far;
  function  CMP_NDATA(des: PChar; source: PChar; count: Integer): Integer; far;

  function  StrToAscDigit(Buf: PChar; PSource: PChar; Count: Integer): Integer; far;
  function  StrToDscDigit(Buf: PChar; PSource: PChar; Count: Integer): Integer; far;
  function  DigitToAscStr(Buf: PChar; PSource: PChar; Count: Integer): Integer; far;
  function  DigitToDscStr(Buf: PChar; PSource: PChar; Count: Integer): Integer; far;

  procedure MV_NDATA(PDest: PChar; PSrc: PChar; count: Integer); far;
  procedure SerialNoToStr(SerialNo: Integer; PSerialNo: PChar); far;

implementation
// 8,4,2,1
function StrToAscDigit(Buf: PChar; PSource: PChar; Count: Integer): Integer;
var
  Value: Char;
  Str: String[4];
  i, j: Integer;
begin
  if Count < 1 then
  begin
    StrToAscDigit := 1;
    exit;
  end;

  for i := 1 to Count do
  begin
    Str := '0000';
    Value  := PSource^;

    case Value of
      '0': Str := '0000';
      '1': Str := '0001';
      '2': Str := '0010';
      '3': Str := '0011';
      '4': Str := '1000';
      '5': Str := '0101';
      '6': Str := '0110';
      '7': Str := '0111';
      '8': Str := '1000';
      '9': Str := '1001';
      'A': Str := '1010';
      'B': Str := '1011';
      'C': Str := '1100';
      'D': Str := '1101';
      'E': Str := '1110';
      'F': Str := '1111';
    else
      begin
        Str := '0000';
        StrToAscDigit := 1;
        exit;
      end;
    end;

    for j := 1 to 4 do
    begin
      Buf^ := Str[j];
      Inc(Buf);
    end;
    Inc(PSource);
  end;

  StrToAscDigit := 0;
end;  {* The End of StrToAscDigit() *}

// 1,2,4,8
function StrToDscDigit(Buf: PChar; PSource: PChar; Count: Integer): Integer;
var
  Value: Char;
  Str: String[4];
  i, j: Integer;
begin
  if Count < 1 then
  begin
    StrToDscDigit := 1;
    exit;
  end;

  for i := 1 to Count do
  begin
    Str := '0000';
    Value  := PSource^;

    case Value of
      '0': Str := '0000';
      '1': Str := '1000';
      '2': Str := '0100';
      '3': Str := '1100';
      '4': Str := '0010';
      '5': Str := '1010';
      '6': Str := '0110';
      '7': Str := '1110';
      '8': Str := '0001';
      '9': Str := '1001';
      'A': Str := '0101';
      'B': Str := '1101';
      'C': Str := '0011';
      'D': Str := '1011';
      'E': Str := '0111';
      'F': Str := '1111';
    else
      begin
        Str := '0000';
        StrToDscDigit := 1;
        exit;
      end;
    end;

    for j := 1 to 4 do
    begin
      Buf^ := Str[j];
      Inc(Buf);
    end;

    Inc(PSource);
  end;

  StrToDscDigit := 0;
end;  {* The End of StrToDscDigit() *}

// 8,4,2,1
function DigitToAscStr(Buf: PChar; PSource: PChar; Count: Integer): Integer;
var
  Value: String[1];
  Str: String[4];
  i, j, k, LenSu: Integer;
begin
  k     := Count mod 4;
  LenSu := Count div 4;

  if (LenSu < 1) or (k <> 0) then
  begin
    DigitToAscStr := 1;
    exit;
  end;

  for i := 1 to LenSu do
  begin
    Str   := '0000';
    Value := '0';
    for j := 1 to 4 do
    begin
      Str[j] := PSource^;
      Inc(PSource);
    end;

    if      CMP_NDATA(@Str[1], '0000', 4) = 0 then Value := '0'
    else if CMP_NDATA(@Str[1], '0001', 4) = 0 then Value := '1'
    else if CMP_NDATA(@Str[1], '0010', 4) = 0 then Value := '2'
    else if CMP_NDATA(@Str[1], '0011', 4) = 0 then Value := '3'
    else if CMP_NDATA(@Str[1], '0100', 4) = 0 then Value := '4'
    else if CMP_NDATA(@Str[1], '0101', 4) = 0 then Value := '5'
    else if CMP_NDATA(@Str[1], '0110', 4) = 0 then Value := '6'
    else if CMP_NDATA(@Str[1], '0111', 4) = 0 then Value := '7'
    else if CMP_NDATA(@Str[1], '1000', 4) = 0 then Value := '8'
    else if CMP_NDATA(@Str[1], '1001', 4) = 0 then Value := '9'
    else if CMP_NDATA(@Str[1], '1010', 4) = 0 then Value := 'A'
    else if CMP_NDATA(@Str[1], '1011', 4) = 0 then Value := 'B'
    else if CMP_NDATA(@Str[1], '1100', 4) = 0 then Value := 'C'
    else if CMP_NDATA(@Str[1], '1101', 4) = 0 then Value := 'D'
    else if CMP_NDATA(@Str[1], '1110', 4) = 0 then Value := 'E'
    else if CMP_NDATA(@Str[1], '1111', 4) = 0 then Value := 'F'
    else
      begin
        Value := '0';
        DigitToAscStr := 1;
        exit;
      end;

    Buf^ := Value[1];
    Inc(Buf);
  end;

  DigitToAscStr := 0;

end;  {* The End of DigitToAscStr() *}

// 1,2,4,8
function DigitToDscStr(Buf: PChar; PSource: PChar; Count: Integer): Integer;
var
  Value: String[1];
  Str: String[4];
  i, j, k, LenSu: Integer;
begin
  k     := Count mod 4;
  LenSu := Count div 4;

  if (LenSu < 1) or (k <> 0) then
  begin
    DigitToDscStr := 1;
    exit;
  end;

  for i := 1 to LenSu do
  begin
    Str   := '0000';
    Value := '0';
    for j := 1 to 4 do
    begin
      Str[j] := PSource^;
      Inc(PSource);
    end;

    if      CMP_NDATA(@Str[1], '0000', 4) = 0 then Value := '0'
    else if CMP_NDATA(@Str[1], '1000', 4) = 0 then Value := '1'
    else if CMP_NDATA(@Str[1], '0100', 4) = 0 then Value := '2'
    else if CMP_NDATA(@Str[1], '1100', 4) = 0 then Value := '3'
    else if CMP_NDATA(@Str[1], '0010', 4) = 0 then Value := '4'
    else if CMP_NDATA(@Str[1], '1010', 4) = 0 then Value := '5'
    else if CMP_NDATA(@Str[1], '0110', 4) = 0 then Value := '6'
    else if CMP_NDATA(@Str[1], '1110', 4) = 0 then Value := '7'
    else if CMP_NDATA(@Str[1], '0001', 4) = 0 then Value := '8'
    else if CMP_NDATA(@Str[1], '1001', 4) = 0 then Value := '9'
    else if CMP_NDATA(@Str[1], '0101', 4) = 0 then Value := 'A'
    else if CMP_NDATA(@Str[1], '1101', 4) = 0 then Value := 'B'
    else if CMP_NDATA(@Str[1], '0011', 4) = 0 then Value := 'C'
    else if CMP_NDATA(@Str[1], '1011', 4) = 0 then Value := 'D'
    else if CMP_NDATA(@Str[1], '0111', 4) = 0 then Value := 'E'
    else if CMP_NDATA(@Str[1], '1111', 4) = 0 then Value := 'F'
    else
      begin
        Value := '0';
        DigitToDscStr := 1;
        exit;
      end;

    Buf^ := Value[1];
    Inc(Buf);
  end;

  DigitToDscStr := 0;

end;  {* The End of DigitToDscStr() *}

procedure MV_NDATA(PDest: PChar; PSrc: PChar; Count: Integer);
begin
   while count > 0 do
   begin
     PDest^ := PSrc^;
     Inc(PDest);
     Inc(PSrc);
     Dec(count);
   end;

end;  {* The End of MV_NDATA() *}

procedure SerialNoToStr(SerialNo: Integer; PSerialNo: PChar);
var
  SeqNo: String;
begin

  SeqNo := IntToStr(SerialNo);

  PSerialNo^ := '0';

  if SerialNo < 10 then
    StrMove(PSerialNo + 1, @SeqNo[1], 1)
  else
    StrMove(PSerialNo, @SeqNo[1], 2);

end; {* The End of SerialNoToStr() *}


function GetBit(Data: WORD; Bits: Integer): WORD;
begin
  GetBit := (Data shr Bits) and 1;
end; {* The End of GetBit() *}

function CMP_NDATA(des: PChar; source: PChar; count: Integer): Integer;
begin
  while (count > 0) do
  begin

    if(des^ > source^) then
    begin
      CMP_NDATA := 1;
      exit;
    end;

    if(des^ < source^) then
    begin
      CMP_NDATA := -1;
      exit;
    end;

    Inc(des);
    Inc(Source);
    dec(count);
  end;

  CMP_NDATA := 0;

end; {* End of CMP_NDATA() *}

end.

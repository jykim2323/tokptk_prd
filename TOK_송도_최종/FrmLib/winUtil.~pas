unit WinUtil;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     ComCtrls, StdCtrls, ExtCtrls, Db, DBTables, Winsock, Registry;

   Function WinUtil_Disket_Copy( var_FileNm, var_Target_FileNm : String ) : Boolean;
   Function WinUtil_FileCheck( var_FileNm : String ) : Boolean;                 // 파일이 존재하는지 확인한다
   Function WinUtil_FileCopy( SrcFile, DstFile : String ) : Boolean;
      
   procedure WinUtil_GetLocalIpList(aList : TStrings);                          // 로컬 아이피 주소

implementation

Uses WinLib;

// 디스켓으로 부터 DATA 를 읽어서 복사한다
Function WinUtil_Disket_Copy( var_FileNm, var_Target_FileNm : String ) : Boolean;
var
    var_Result : Boolean;
    var_Src_FileNm : String;
Begin
    // 파일이 존재하는지 확인한다
    IF WinUtil_FileCheck( var_FileNm ) Then
       var_Src_FileNm := ExtractFileName(var_FileNm);   // 있으면 복사한다

    IF NOT WinUtil_FileCopy( var_FileNm, var_Target_FileNm ) Then var_Result := False
    Else var_Result := True;

    Result := var_Result;
End;

// 파일이 존재하는지 확인한다
Function WinUtil_FileCheck( var_FileNm : String ) : Boolean;
var
        var_Result : Boolean;
        F : file of Byte;        
Begin
        var_Result := FileExists( var_FileNm );
        
        IF var_Result Then Begin
                AssignFile( F, var_FileNm );
                {$I-}
                Reset(F);
                {$I+}
                if IOResult <> 0 then begin
                      WinLib_ErrorForm('파일은 존재하지만 이상이 있는것 같습니다..원본화일를 확인하여 주세요');
                      var_Result := False;
                end;
                CloseFile(F);
        End
        Else Begin
               WinLib_ErrorForm('선택 하신 파일이 존재 하지 않습니다..확인하시고 다시 시도하여 주세요');
               var_Result := False;
        End;
        
        Result := var_Result;
End;

Function WinUtil_FileCopy( SrcFile, DstFile : String ) : Boolean;
const
        BufSize = 2048;
var
        SrcStream,DstStream : TFileStream;
        Buffer : Pointer;
        NBytes : integer;
begin
        SrcStream := TFileStream.Create(SrcFile, fmOpenRead or fmShareDenyWrite);
        // 원본 파일 스트림을 생성합니다..
        Try
             DstStream := TFileStream.Create(DstFile,fmCreate or fmShareExclusive);
             // 타겟 파일 스트림을 생성합니다..
             Try
                  GetMem(Buffer, BufSize);  // 버퍼 사이즈 크기의 메모리 할당
                  Try
                        Repeat
                            NBytes := SrcStream.read(Buffer^,BufSize); // 버퍼 에 원본 복사..
                            DstStream.Write(Buffer^,BufSize);          // 버퍼 내용 타겟 스트림에 쓰기...
                        Until NBytes = 0;
                  Finally
                        FreeMem(Buffer,BufSize);   // 메모리 해제..
                  End;
             Finally
                  DstStream.Free;
             End;
        Finally                        
             SrcStream.Free;
        End;

        Result := True;
End;

procedure WinUtil_FileRead ( const f: integer; var Line: String; var _bof: boolean );
const
        MAXLINELENGTH = 256;
var
        curr,
        Before : Longint;
        Buffer : Array [0..MAXLINELENGTH] Of char;
        p : PChar;
begin
        // scan backwards to the last CR-LF
        curr := FileSeek (f, 0, 1);
        Before := curr - MAXLINELENGTH;
        if Before < 0 then
                Before := 0;
                FileSeek (f, Before, 0);
                FileRead (f, Buffer, curr - Before);
                Buffer[curr - Before] := #0;
                p := StrRScan (Buffer, #10);
                if p = Nil then begin
                        Line := StrPas (Buffer);
                        FileSeek (f, 0, 0);
                        _bof := True
                end
        else
        begin
                Line := StrPas (p + 1);
                FileSeek (f, Before + Longint (p) - Longint (@Buffer), 0);
                _bof := False
        end;

        // this will also work with Unix files (#10 only, no #13)
        if length (Line) > 0 then
                if Line[length (Line)] = #13 then begin
                        SetLength ( Line, length (Line) - 1 )
                end;
end;


// 로컬 아이피 주소 얻는넘
procedure WinUtil_GetLocalIpList(aList : TStrings);
type
   TaPInAddr = array [0..255] of PInAddr;
   PaPInAddr = ^TaPInAddr;
var
 buff : array [0..63] of char;
 pHEnt : PHostEnt;
 pptr : PaPInAddr;
 WSData : TWSAData;
 i : integer;
begin
 aList.Clear;
 if WSAStartup($101,WSData) <> 0 then begin
   showmessagefmt('%d',[getlasterror]);
   exit;
 end;
 try
   if GetHostName (buff,sizeof(buff)) <> 0 then begin
     showmessagefmt('%d',[getlasterror]);
     exit;
   end;
   pHEnt := gethostbyname(buff);
   if pHEnt <> nil then begin
     pptr := PaPInAddr(pHEnt^.h_addr_list);
     I := 0;
     while pptr^[I] <> nil do begin
         aList.Add(StrPas(inet_ntoa(pptr^[I]^)));
         Inc(I);
     end;
   end;
 finally
   WSACleanup;
 end;
end;


// Cpu Vendor Check하는 넘..
const
 ID_BIT   =  $200000;       // EFLAGS ID bit
type
 TCPUID   = array[1..4] of Longint;
 TVendor  = array [0..11] of char;

function WinUtil_IsCPUID_Available : Boolean; register;
asm
PUSHFD             {direct access to flags no possible, only via stack}
POP     EAX        {flags to EAX}
MOV     EDX,EAX    {save current flags}
XOR     EAX,ID_BIT {not ID bit}
PUSH    EAX        {onto stack}
POPFD              {from stack to flags, with not ID bit}
PUSHFD             {back to stack}
POP     EAX        {get back to EAX}
XOR     EAX,EDX    {check if ID bit affected}
JZ      @exit      {no, CPUID not availavle}
MOV     AL,True    {Result=True}
@exit:
end;

function WinUtil_GetCPUVendor: TVendor; assembler; register;
asm
 PUSH    EBX        {Save affected register}
 PUSH    EDI
 MOV     EDI,EAX    {@Result (TVendor)}
 MOV     EAX,0
 DW      $A20F      {CPUID Command}
 MOV     EAX,EBX
 XCHG    EBX,ECX    {save ECX result}
 MOV     ECX,4
@1:
 STOSB
 SHR     EAX,8
 LOOP    @1
 MOV     EAX,EDX
 MOV     ECX,4
@2:
 STOSB
 SHR     EAX,8
 LOOP    @2
 MOV     EAX,EBX
 MOV     ECX,4
@3:
 STOSB
 SHR     EAX,8
 LOOP    @3
 POP     EDI        {Restore registers}
 POP     EBX
end;


end.

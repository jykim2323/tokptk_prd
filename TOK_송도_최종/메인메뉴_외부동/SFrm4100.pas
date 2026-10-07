unit SFrm4100;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_4100 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    ItemEd: TEdit;
    MesgStsBar: TStatusBar;
    ExitBitBtn: TBitBtn;
    CarGbnEd: TEdit;
    Label1: TLabel;
    Query3: TADOQuery;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    PcodeEd: TEdit;
    BodyEd: TEdit;
    Cbx_1: TCheckBox;
    Label3: TLabel;
    Label9: TLabel;
    SeqEd: TMaskEdit;
    DtEd: TMaskEdit;
    ConfirmBitBtn: TBitBtn;
    ChasuEd: TMaskEdit;
    FactEd: TEdit;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function f_get_sysdate_time1(): String;
    function IsDate(Str : String) : Boolean;

  private
    { Private declarations }
    procedure Insert_Code;  
  public

    { Public declarations }
    Bol_insert : Boolean;
    Bol_Update : Boolean;
    Bol_Delete : Boolean;
  end;

var
  SFrm_4100: TSFrm_4100;
  var_sql, s_user : String;
  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];

implementation

uses DBSet,WinLib, FrmPrompt, FrmError, Frm3200;

{$R *.dfm}


procedure TSFrm_4100.FormCreate(Sender: TObject);
begin
   bodyEd.Text   := '';
   CargbnEd.Text := '';
   itemEd.Text   := '';
   SeqEd.Text    := '';
   DtEd.Text     :=  f_get_sysdate_time1;
   cbx_1.Checked := False;
end;


procedure TSFrm_4100.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg, ls : String;
begin
   var_Msg := ' 정말로 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(FactEd.Text) = '' then
      Begin
         WinLib_ErrorForm(' 출고공장코드를 입력 하십시요...');   FactEd.SetFocus;     Exit;
      End;

      IF Trim(ChasuEd.Text) = '' then
      Begin
         WinLib_ErrorForm(' 차수를 입력 하십시요...');   ChasuEd.SetFocus;       Exit;
      End;

      IF Trim(CarGbnEd.Text) = '' then
      Begin
         WinLib_ErrorForm(' 출고차종을 입력 하십시요...');     CarGbnEd.SetFocus;       Exit;
      End;

      ls := Copy(DtEd.Text,1,8);
      if Not IsDate(ls) then
      begin
         WinLib_ErrorForm(' 날짜가 틀립니다...');     DTEd.SetFocus;       Exit;
      end;

    Insert_Code;
    Close;
  end;
end;

procedure TSFrm_4100.Insert_Code;
var
   ls_fact, ls_cargbn, ls_chasu, ls_item, ls_pcode, l_pcode1, l_pcode2, l_pcode3 : String;
   ls_body, ls_seq, ls_dt, ls_onalja, l_sno1, ls_xseq, ls_sno, ls_lotdate : string;
   li_chasu, lc, li_sno : Integer;
begin
   ls_fact    := Trim(FactEd.Text);
   ls_cargbn  := Trim(CargbnEd.Text);
   ls_chasu   := Trim(ChasuEd.Text);
   ls_body    := Trim(BodyEd.Text);
   ls_cargbn  := Trim(CargbnEd.Text);
   ls_item    := Trim(ItemEd.Text);
   ls_pcode   := Trim(PcodeEd.Text);
   ls_seq     := Trim(SeqEd.Text);
   ls_dt      := DtEd.Text;

   var_sql := ' Select Count(*) from wjp_pa_tbl  where wp_code = '''+ls_item+''' ';
    With Query3 Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      Open;
      lc := Fields[0].AsInteger;
    End;

    if (lc = 0)  then
    begin
       WinLib_ErrorForm(' 완제품 마스터에 없는 코드입니다...');         Exit;
    end;

     var_sql := ' Select Count(*) from mimast  where mast_code = '''+ls_pcode+''' ';
    With Query3 Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      Open;
      lc := Fields[0].AsInteger;
    End;

    if (lc = 0)  then
    begin
       WinLib_ErrorForm(' 파렛트품 마스터에 없는 코드입니다...');        Exit;
    end;

    var_sql := ' Select Count(*) from mioupt  ';
    With Query3 Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      Open;
      lc := Fields[0].AsInteger;
    End;

    if (lc >= 10)  then
    begin
       WinLib_ErrorForm(' 이미 10개 이상존재 더이상 등록 불가...');        Exit;
    end;

    var_sql := ' Select Count(*) from tbstat  where stat_pswd = ''JPLS'' And stat_pull1 = ''1''  ';
    With Query3 Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      Open;
      lc := Fields[0].AsInteger;
    End;

    if (lc <> 0)  then
    begin
       WinLib_ErrorForm(' 연속 끌기모드 정지시키기 바람...');         Exit;
    end;

    var_sql := ' Select Count(*) from tbstat  where stat_pswd = ''JPLS'' And stat_mode = ''5''  ';
    With Query3 Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      Open;
      lc := Fields[0].AsInteger;
    End;

    if (lc = 0)  then
    begin
       WinLib_ErrorForm(' 운영모드가 개별모드가 아니다...');         Exit;
    end;

    var_sql := ' Select Max(oupt_sno) As ls_msno from mioupt (NOLOCK) ';
    With Query3 Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      Open;
      ls_sno := FieldByName('ls_msno').AsString;
    End;
    if  Trim(ls_sno) = ''  then  ls_sno := '00';

    ls_lotdate := Formatdatetime('yyyymmddhhmmss', now);
    ls_onalja  := f_get_sysdate_time1;
    li_sno     := StrToint(ls_sno);
    li_sno     := li_sno + 1;
    l_sno1     := Format('%2.2d', [li_sno]);
    ls_xseq    := ls_onalja + l_sno1;

    var_sql := ' Insert Into mioupt(OUPT_CARGBN, OUPT_SNO, OUPT_CODE, OUPT_ONUM, OUPT_PCODE, OUPT_BODYNO, ';
    var_sql := var_sql + '   OUPT_LOTDATE, OUPT_SEQNO, OUPT_FLAG, OUPT_RHOGI, OUPT_RLOCA, OUPT_RDATE, OUPT_OSEQ, ';
    var_sql := var_sql + '   OUPT_PTID,    OUPT_CARCNT,  OUPT_STOK, OUPT_CHEK,  OUPT_FACT ) ';
    var_sql := var_sql + '   Values('''+ls_cargbn+''',  '''+l_sno1+''', '''+ls_item+''', ''0'', '''+ls_pcode+''', '''+ls_body+''', ';
    var_sql := var_sql + '          '''+ls_lotDate+''','''+ls_seq+''', ''0'', ''0'', '''', '''', '''+ls_xseq+''', ';
    var_sql := var_sql + '          '''', Convert(NUMERIC,'''+ls_chasu+'''), ''0'', ''0'', '''+ls_fact+''' ) ';
    With Query3 Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         showmessage(' 등록 에러!!!! ' + var_sql);     Exit;
 //        WinLib_ErrorForm(' 등록 에러!!!! ' + var_sql);     Exit;
      End;
    End;

    if cbx_1.Checked  then
    Begin
       var_sql := ' Insert Into tijunp(junp_code, junp_bodyno, junp_lotdate, junp_seqno, junp_onalja, ';
       var_sql := var_sql + '   junp_carcnt, junp_print, junp_cargbn, junp_pcode, junp_pltseq, junp_fact ) ';
       var_sql := var_sql + '   Values('''+ls_item+''', '''+ls_body+''', '''+ls_lotDate+''', '''+ls_seq+''',  '''+ls_onalja+''',  ';
       var_sql := var_sql + '     Convert(NUMERIC,'''+ls_chasu+'''), ''0'', '''+ls_cargbn+''',  '''+ls_pcode+''', ''0'', '''+ls_fact+''' ) ';
       With Query3 Do
       Try
        Close;
        SQL.Clear;
        SQL.Add( var_sql );
        ExecSql;
       Except
       Begin
           WinLib_ErrorForm(' 등록 에러!!!! ' + var_sql);         Exit;
       End;
    End;

    End; 
    MesgStsBar.SimpleText := '서열데이터를 등록 하였습니다...';
end;

function TSFrm_4100.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl (NOLOCK) ';
    With Query3 Do Begin
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

function TSFrm_4100.IsDate(Str : String) : Boolean;    
const   days: array[0..11] of Integer =(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var
   iyear,imm,idd : integer;
begin
   if length(Str) <> 8 then begin
     result := False;
     exit;
   end;  
   iyear := StrtoInt(copy(Str,1,4));
   imm := StrtoInt(copy(Str,5,2));
   idd := StrtoInt(copy(Str,7,8));
//  현재년도가 윤년인지를 먼저 구해서 2월말일을 구한다.
//  if (iyear mod 4=0) and ((iyear mod 100>0) or (iyear mod 400=0)) then  days[1] := 29;

   if (imm > 0) and (imm < 13) then
     if (idd > 0) and (idd <= days[imm-1]) then
       result := True
     else
       result := False
   else
     result := False;
end;


procedure TSFrm_4100.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_4100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSFrm_4100.FormDestroy(Sender: TObject);
begin
  SFrm_4100 := Nil;
end;


end.


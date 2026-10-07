unit SFrm4300;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_4300 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label8: TLabel;
    MesgStsBar: TStatusBar;
    ExitBitBtn: TBitBtn;
    CarGbnEd: TEdit;
    Query3: TADOQuery;
    Label5: TLabel;
    Label6: TLabel;
    ItemEd: TEdit;
    PtidEd: TEdit;
    LineCB: TComboBox;
    Label1: TLabel;
    DtEd: TMaskEdit;
    ConfirmBitBtn: TBitBtn;
    Cbx_bogo: TCheckBox;
    Panel3: TPanel;
    Label3: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SeqNoEd: TEdit;
    WcodeEd: TEdit;
    BodyEd: TEdit;
    LotDtEd: TMaskEdit;
    Cbx_2: TCheckBox;
    Label11: TLabel;
    OugbnCB: TComboBox;
    Label12: TLabel;

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
  SFrm_4300: TSFrm_4300;
  var_sql, s_user : String;
  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];


implementation

uses DBSet,WinLib, FrmPrompt, FrmError, Frm3200;

{$R *.dfm}


procedure TSFrm_4300.FormCreate(Sender: TObject);
var
   ls_dt, ls_date, ls_time, StrCode : String;
begin
   cbx_bogo.Checked := False;
   ptidEd.Text   := ''; ItemEd.Text := '';
   DtEd.Text     :=  f_get_sysdate_time1;
   ls_dt         :=  f_get_sysdate_time1;
   ls_date       :=  Copy(ls_dt,1,8);
   ls_time       :=  Copy(ls_dt,9,2);
   LotDtEd.Text  :=  ls_date + ls_time + '0000';

  OugbnCB.Clear;
  var_sql := ' Select OG_CODE, OG_NAME From OUTGBN  Order By OG_CODE ';
  With Query3 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_sql);
    Open;

    if Recordcount = 0 Then Exit;
    While Not Eof Do Begin
      StrCode := FieldByName('OG_CODE').AsString + '-' + FieldByName('OG_NAME').AsString;
      OugbnCB.Items.Add(StrCode);
      Next;
    End;
   End;
   OugbnCB.ItemIndex := -1;
end;

procedure TSFrm_4300.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg  : String;
begin
   var_Msg := ' 정말로 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
     Insert_Code;
     Close;
  end;
end;      

procedure TSFrm_4300.Insert_Code;
Label NNNN_RTN;
var
   ls_line, ls_item, ls_ptid, ls_date, ls_time, ls, ls_dt, ls_bogo, ls_cargbn : String;
   ls_fact, ls_bodyno, ls_seqno, ls_code, ls_ogubn, ls_pltseq, ls_lotdt, ls_chasu : String;
   ls_onalja, ls_sw, ls_loca : String;
   lc : Integer;
begin
  ls_line   := Trim(LineCB.Text);
  ls_item   := Trim(ItemEd.Text);
  ls_ptid   := Trim(PtidEd.Text);
  ls_cargbn := Trim(CargbnEd.Text);
  ls_dt     := DtEd.Text;

  ls_code := ''; ls_bodyno :='';  ls_seqno := '';  ls_lotdt := ''; ls_chasu := '';


  if not (( ls_line >= '0') And (ls_line <= '4')) then
  begin
      WinLib_ErrorForm(' 입고호기 입력에러...');      Exit;
  end;

  if (ls_item  = '')  then
  begin
      WinLib_ErrorForm(' 파레트코드 입력에러...');      Exit;
  end;

   var_sql := ' Select Count(*) from mimast  where mast_code = '''+ls_item+''' ';
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

   if (ls_cargbn  = '')  then
   begin
      WinLib_ErrorForm(' 차종코드 입력에러...');      Exit;
   end;

   if (ls_ptid  = '')  then
   begin
      WinLib_ErrorForm(' PLTID 입력에러...');      Exit;
   end;

   ls := Copy(DtEd.Text,1,8);
   if Not IsDate(ls) then
   begin
       WinLib_ErrorForm(' 날짜가 틀립니다...');     DTEd.SetFocus;       Exit;
   end;

   ls            :=  f_get_sysdate_time1;
   ls_date       :=  Copy(ls,1,8);
   ls_time       :=  Copy(ls,9,6);
   ls_onalja     :=  ls_dt;
   ls_pltseq     :=  '0';
   ls_sw         := '';

   if  cbx_2.Checked  then
   begin
      if MessageDlg('파렛트 + 완제품 출고실적 등록이 맞습니까 ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
      ls_sw := '1';
   end
   else
   begin
      if MessageDlg('파렛트만 출고실적 등록이 맞습니까 ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
      ls_sw := '2';
   end;

   if ls_sw = '2'  then goto NNNN_RTN;
   /////////////////////////////////////
   // 완제품 정보
   /////////////////////////////////////  
   ls_code   := Trim(WcodeEd.Text);
   ls_bodyNo := Trim(BodyEd.Text);
   ls_seqno  := Trim(SeqnoEd.Text);
   ls_lotdt  := Trim(LotdtEd.Text);

   if (ls_code  = '')  then
   begin
      WinLib_ErrorForm(' 완제품코드 입력에러...');      Exit;
   end;

   if (ls_bodyno  = '')  then
   begin
      WinLib_ErrorForm(' 바디번호드 입력에러...');      Exit;
   end;

   if (ls_seqno  = '')  then
   begin
      WinLib_ErrorForm(' SEQNO 코드 입력에러...');      Exit;
   end;

    var_sql := ' Select Count(*) from wjp_pa_tbl  where wp_code = '''+ls_code+''' ';
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
       WinLib_ErrorForm(' 완제품 마스터에 없는 코드입니다...');    Exit;
    end;

 NNNN_RTN:
    ls_loca  := ls_line + '00000';
    ls_ogubn := Copy(OugbnCB.Text,1,1);

    if (ls_ogubn  = '')  then
    begin
       WinLib_ErrorForm(' 출고유형을 선택 하세요...');      Exit;
    end;

    if MessageDlg('출고실적 시간대가 ['+ ls_dt +']입니다. 맞습니까', mtConfirmation, [mbYes, mbNo], 0) = mrNO then Exit;

    if MessageDlg('ERP에 보고 합니까 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then  ls_bogo := '0'
    else  ls_bogo := '1';

   ls_date := Copy(DtEd.Text,1,8);
   ls_time := Copy(DtEd.Text,9,6);
   ls_chasu := '0';

   var_sql := ' INSERT INTO MIOHST(OHST_DATE, OHST_TIME, OHST_CODE, OHST_LINE, OHST_LOTDATE, OHST_WCODE, OHST_BODYNO, ';
   var_Sql := var_Sql + '  OHST_SEQNO, OHST_FLAG, OHST_PTID, OHST_OGUBN, OHST_CARCNT, OHST_CARGBN, OHST_FACT,   ';
   var_Sql := var_Sql + '  OHST_LOCA,   OHST_FLG123 ) ';
   var_sql := var_sql + '   Values('''+ls_date+''', '''+ls_time+''',  '''+ls_item+''', '''+ls_line+''', '''+ls_lotdt+''', ';
   var_sql := var_sql + '          '''+ls_code+''','''+ls_bodyno+''', '''+ls_seqno+''', '''+ls_bogo+''', '''+ls_ptid+''', ';
   var_sql := var_sql + '          '''+ls_ogubn+''', 0, '''+CargbnEd.Text+''',''F1'', '''+ls_loca+''', '''+ls_pltseq+''' ) ';
   With Query3 Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      Begin
         WinLib_ErrorForm('출고이력  등록 에러!!!! ' +var_sql);       Exit;
      End;
    End;

    MesgStsBar.SimpleText := '출고이력 ' + itemEd.Text + '를 등록 하였습니다...';
end;

function TSFrm_4300.f_get_sysdate_time1(): String;
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

function TSFrm_4300.IsDate(Str : String) : Boolean;
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

procedure TSFrm_4300.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_4300.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSFrm_4300.FormDestroy(Sender: TObject);
begin
  SFrm_4300 := Nil;
end;


end.


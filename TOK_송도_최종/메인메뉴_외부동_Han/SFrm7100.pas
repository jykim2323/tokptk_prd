unit SFrm7100;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_7100 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    MesgStatusBar: TStatusBar;
    ExitBitBtn: TBitBtn;
    ConfirmBitBtn: TBitBtn;
    Query2: TADOQuery;
    Panel3: TPanel;
    BankEdit: TEdit;
    BayEdit: TEdit;
    LevlEdit: TEdit;
    Panel7: TPanel;
    Panel4: TPanel;
    DateEdit: TMaskEdit;
    Panel8: TPanel;
    Panel9: TPanel;
    TimeEdit: TMaskEdit;
    UseCB: TComboBox;
    ResvCB: TComboBox;
    Panel12: TPanel;
    Query1: TADOQuery;
    TrNoEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PnlKeyPad: TPanel;
    BtnNum7: TButton;
    BtnNum8: TButton;
    BtnNum9: TButton;
    BtnNum6: TButton;
    BtnNum5: TButton;
    BtnNum4: TButton;
    BtnNum1: TButton;
    BtnNum2: TButton;
    BtnNum3: TButton;
    BtnBS: TButton;
    BtnClear: TButton;
    BtnNum0: TButton;
    Btn_Enter: TButton;
    BtnExit: TButton;
    Btn_Kpad: TSpeedButton;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Data_display;
    procedure FormActivate(Sender: TObject);
    procedure Btn_KpadClick(Sender: TObject);
    procedure TrNoEditClick(Sender: TObject);
    procedure DateEditClick(Sender: TObject);
    procedure TimeEditClick(Sender: TObject);
    procedure BtnNum0Click(Sender: TObject);
    procedure BtnNum1Click(Sender: TObject);
    procedure BtnNum2Click(Sender: TObject);
    procedure BtnNum3Click(Sender: TObject);
    procedure BtnNum4Click(Sender: TObject);
    procedure BtnNum5Click(Sender: TObject);
    procedure BtnNum6Click(Sender: TObject);
    procedure BtnNum7Click(Sender: TObject);
    procedure BtnNum8Click(Sender: TObject);
    procedure BtnNum9Click(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnBSClick(Sender: TObject);
    procedure Btn_EnterClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);

  private
    { Private declarations }

     procedure Update_Code;
     procedure Delete_Code;

     function GetAKeyPad(nNum : string ): string;
     procedure Focusset;
  public
    { Public declarations }

    Bol_Update : Boolean;
    Bol_Delete : Boolean;
  end;

var
  SFrm_7100: TSFrm_7100;
  var_sql: String;
  s_loca, s_item : String;

  g_focus : integer;
implementation

uses DbSet, WinLib, Frm7100, MastDisp;

{$R *.dfm}

procedure TSFrm_7100.FormCreate(Sender: TObject);
begin
//
end;

procedure TSFrm_7100.FormActivate(Sender: TObject);
begin
   Data_display;
end;

procedure TSFrm_7100.Data_display;
var
   l_date, l_time, l_flag, l_use : string;
   l_Pgubn : string;
begin
   with Query2 do
   begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT LSTK_LOCA, LSTK_BK, LSTK_BY, LSTK_LV, LSTK_USE, LSTK_RESV, ');
      Sql.Add('       LSTK_TRAINNO, LSTK_DATE, LSTK_DATE, LSTK_TIME ');
      Sql.Add('  FROM STK1_MILSTK (NOLOCK)  ');
      sql.Add('   where LSTK_BK  = '''+BankEdit.Text+''' ');
      sql.Add('    and  LSTK_BY  = '''+BayEdit.Text+'''  ');
      sql.Add('    and  LSTK_LV  = '''+LevlEdit.Text+''' ');
      Open;


      l_date   := FieldByName('lstk_date').AsString;
      l_time   := FieldByName('lstk_time').AsString;
      l_use    := FieldByname('lstk_use').AsString;
      l_flag   := FieldByname('lstk_resv').AsString;

      TrNoEdit.Text   := FieldByname('lstk_trainno').AsString;
      DateEdit.Text   := FieldByname('lstk_date').AsString;
      TimeEdit.Text   := FieldByname('lstk_time').AsString;

      if      l_use   = '0' then   UseCB.ItemIndex := 0
      else if l_use   = '1' then   UseCB.ItemIndex := 1;

      if      l_flag   = '0' then   ResvCB.ItemIndex := 0
      else if l_flag   = '1' then   ResvCB.ItemIndex := 1
      else if l_flag   = 'X' then   ResvCB.ItemIndex := 2
      else if l_flag   = 'Y' then   ResvCB.ItemIndex := 3
      else if l_flag   = 'W' then   ResvCB.ItemIndex := 4
      else if l_flag   = 'E' then   ResvCB.ItemIndex := 5;

   end;
end;


procedure TSFrm_7100.ConfirmBitBtnClick(Sender: TObject);
begin
   s_loca := BankEdit.Text + BayEdit.Text + LevlEdit.Text;

   if Bol_Update Then Update_Code
   else if Bol_Delete Then Delete_Code;

//    Close;
end;

procedure TSFrm_7100.UpDate_Code;
var
   ls_type, ls_Date, ls_Time, ls_DateTime, ls_loca, ls_flag,  ls_Use : String;
   StrQry, StrTrNo, StrCode, ls_qty   : String;
begin
   ls_DateTime := FormatDateTime('yyyymmddhhmmss', now);
   ls_date := copy(ls_datetime, 1, 8);
   ls_time := copy(ls_datetime, 9, 6);

   ls_loca := BankEdit.Text + BayEdit.Text + LevlEdit.Text;

   StrTrNo  :=  Trim(TrNoEdit.Text);

   If  (StrTrNo <> '99999') And (Length(StrTrNo) = 0) Then
   Begin
      WinLib_ErrorForm('차호(객차번호)를 입력 하세요!');
      TrNoEdit.SetFocus;
      Exit;
   end;

   If  Length(StrTrNo) <> 5   Then
   Begin
     WinLib_ErrorForm('차호(객차번호) 5자리를 입력 하세요!');
     TrNoEdit.SetFocus;
     Exit;
   end;
   
   If UseCB.ItemIndex = 0 Then ls_Use := '0'
   Else If UseCB.ItemIndex = 1 Then ls_Use := '1';

   If ResvCB.ItemIndex = 0 Then ls_flag := '0'
   Else If ResvCB.ItemIndex = 1 Then ls_flag := '1';

   If (ls_flag = '0') And (length(TrNoEdit.Text) <> 0) Then  ls_flag := '1';

   if Length(Trim(DateEdit.Text)) = 0  then ls_date := copy(ls_datetime, 1, 8)
   else  ls_date :=  DateEdit.Text;

   if Length(Trim(TimeEdit.Text)) = 0  then ls_time := copy(ls_datetime, 9, 6)
   else  ls_Time :=  TimeEdit.Text;

   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      With Query2 do
      begin
         try
            Close;
            Sql.Clear;
            Sql.Add(' Update STK1_milstk set lstk_use = '''+ls_use+''', ');
            Sql.Add(' lstk_resv = '''+ls_flag+''', lstk_trainno = '''+StrTrNo+''', ');
            Sql.Add(' lstk_date = '''+ls_date+''', lstk_time = '''+ls_time+'''     ');
            Sql.Add(' Where lstk_loca = '''+ls_loca+''' ');
            ExecSql;     
         except
            ShowMessage('저장위치 '+ls_loca+'에 수정을 실패 하였습니다..... ');
         end;

      end;
   end;
   MesgStatusBar.SimpleText := '정상 수정 하였습니다.!!';
end;

procedure TSFrm_7100.Delete_Code;
var
  ls_loca : String;
begin      

   ls_loca := BankEdit.Text + BayEdit.Text + LevlEdit.Text;
   if MessageDlg(' 정말로 삭제 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      With Query2 do
      begin
         try
            Close;
            Sql.Clear;
            Sql.Add(' Update STK1_milstk Set lstk_resv = ''0'', ');
            Sql.Add(' lstk_use = ''0'', lstk_trainno = '''',  ');
            Sql.Add(' Lstk_Date = '''', Lstk_Time = ''''      ');
            Sql.Add(' Where lstk_loca = '''+ls_loca+''' ');
            ExecSql;
         except
            ShowMessage('저장위치 '+ls_loca+'에 내용삭제를 실패 하였습니다..... ');
         end;
      end;
   end;

   MesgStatusBar.SimpleText := '정상 삭제 하였습니다.!!';
end;

procedure TSFrm_7100.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_7100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSFrm_7100.FormDestroy(Sender: TObject);
begin
  SFrm_7100 := Nil;
end;


/////////////////////////////KeyPad/////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TSFrm_7100.Btn_KpadClick(Sender: TObject);
begin
  PnlKeyPad.Visible := True;
end;

procedure TSFrm_7100.BtnNum0Click(Sender: TObject);
begin
  GetAKeyPad('0');
end;

procedure TSFrm_7100.BtnNum1Click(Sender: TObject);
begin
  GetAKeyPad('1');
end;

procedure TSFrm_7100.BtnNum2Click(Sender: TObject);
begin
  GetAKeyPad('2');
end;

procedure TSFrm_7100.BtnNum3Click(Sender: TObject);
begin
  GetAKeyPad('3');
end;

procedure TSFrm_7100.BtnNum4Click(Sender: TObject);
begin
  GetAKeyPad('4');
end;

procedure TSFrm_7100.BtnNum5Click(Sender: TObject);
begin
  GetAKeyPad('5');
end;

procedure TSFrm_7100.BtnNum6Click(Sender: TObject);
begin
  GetAKeyPad('6');
end;

procedure TSFrm_7100.BtnNum7Click(Sender: TObject);
begin
  GetAKeyPad('7');
end;

procedure TSFrm_7100.BtnNum8Click(Sender: TObject);
begin
  GetAKeyPad('8');
end;

procedure TSFrm_7100.BtnNum9Click(Sender: TObject);
begin
  GetAKeyPad('9');
end;

procedure TSFrm_7100.BtnClearClick(Sender: TObject);
begin
  GetAKeyPad('CL');
end;
        
procedure TSFrm_7100.BtnBSClick(Sender: TObject);
begin
  GetAKeyPad('Bk');
end;

procedure TSFrm_7100.Btn_EnterClick(Sender: TObject);
begin
  Focusset();
    case g_focus of
        //--- 입고 터미널
        1:
        begin
            TrnoEdit.Color := $0080FF80 ;
            TrnoEdit.SetFocus;
        end;
        2:
        begin
            DateEdit.Color := $0080FF80 ;
            DateEdit.SetFocus;
        end;
        3:
        begin
            TimeEdit.Color := $0080FF80 ;
            TimeEdit.SetFocus;
        end;
    end;
end;

procedure TSFrm_7100.Focusset;
begin
    TrnoEdit.Color  := clWhite;
    DateEdit.Color  := clWhite;
    TimeEdit.Color  := clWhite;
end;

procedure TSFrm_7100.BtnExitClick(Sender: TObject);
begin
  PnlKeyPad.Visible := false;
end;

procedure TSFrm_7100.TrNoEditClick(Sender: TObject);
begin
  g_focus := 1;
  Btn_EnterClick(Self);
end;

procedure TSFrm_7100.DateEditClick(Sender: TObject);
begin
  g_focus := 2;
  Btn_EnterClick(Self);
end;

procedure TSFrm_7100.TimeEditClick(Sender: TObject);
begin
  g_focus := 3;
  Btn_EnterClick(Self);
end;

function TSFrm_7100.GetAKeyPad(nNum: string): string;
begin
    case g_focus of
    //---입고터미널
        1:
        begin
            if nNum='Bk' then
                TrnoEdit.Text := copy(TrnoEdit.Text,1,Length(TrnoEdit.Text)-1)
            else if nNum='CL' then
                TrnoEdit.Text := ''
            else if Length(TrnoEdit.Text) <5 then
                TrnoEdit.Text := TrnoEdit.Text + nNum
            else
                TrnoEdit.Text :=  nNum;
        end;

        2:
        begin
            if nNum='Bk' then
                DateEdit.Text := copy(DateEdit.Text,1,Length(DateEdit.Text)-1)
            else if nNum='CL' then
                DateEdit.Text := ''
            else if Length(DateEdit.Text) <8 then
                DateEdit.Text := DateEdit.Text + nNum
            else
                DateEdit.Text :=  nNum;
        end;
        3:
        begin
            if nNum='Bk' then
                TimeEdit.Text := copy(TimeEdit.Text,1,Length(TimeEdit.Text)-1)
            else if nNum='CL' then
                TimeEdit.Text := ''
            else if Length(TimeEdit.Text) <6 then
                TimeEdit.Text := TimeEdit.Text + nNum
            else
                TimeEdit.Text :=  nNum;
        end;
    end;
end;

end.


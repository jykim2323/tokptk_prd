unit Frm2400;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ComCtrls, StdCtrls, Buttons, CheckLst, ExtCtrls, ADODB;

type
  TFrm_2400 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    UpdateBitBtn11: TBitBtn;
    CH10CLB: TCheckListBox;
    UpdateBitBtn10: TBitBtn;
    UpdateBitBtn16: TBitBtn;
    UpdateBitBtn15: TBitBtn;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    StartBitBtn1: TSpeedButton;
    CH15CLB: TCheckListBox;
    UpdateBitBtn17: TBitBtn;
    UpdateBitBtn20: TBitBtn;
    UpdateBitBtn21: TBitBtn;
    UpdateBitBtn22: TBitBtn;
    UpdateBitBtn27: TBitBtn;
    UpdateBitBtn26: TBitBtn;
    UpdateBitBtn25: TBitBtn;
    UpdateBitBtn30: TBitBtn;
    UpdateBitBtn31: TBitBtn;
    BitBtn32: TBitBtn;
    UpdateBitBtn37: TBitBtn;
    UpdateBitBtn36: TBitBtn;
    UpdateBitBtn35: TBitBtn;
    StartBitBtn2: TSpeedButton;
    StartBitBtn0: TSpeedButton;
    CH20CLB: TCheckListBox;
    CH25CLB: TCheckListBox;
    CH30CLB: TCheckListBox;
    CH35CLB: TCheckListBox;
    Query1: TADOQuery;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Sby1Edit: TEdit;
    Slv1Edit: TEdit;
    GroupBox6: TGroupBox;
    ECode1Edit: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Ird1Edit: TEdit;
    GroupBox3: TGroupBox;
    Ord1Edit: TEdit;
    UpdateBitBtn12: TBitBtn;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    Fst1Edit: TEdit;
    GroupBox12: TGroupBox;
    Tst1Edit: TEdit;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Bay: TLabel;
    Fby1Edit: TEdit;
    Flv1Edit: TEdit;
    GroupBox9: TGroupBox;
    Label3: TLabel;
    Tby1Edit: TEdit;
    Tlv1Edit: TEdit;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    Label2: TLabel;
    Sby2Edit: TEdit;
    Slv2Edit: TEdit;
    GroupBox15: TGroupBox;
    ECode2Edit: TEdit;
    GroupBox16: TGroupBox;
    GroupBox17: TGroupBox;
    Ird2Edit: TEdit;
    GroupBox18: TGroupBox;
    Ord2Edit: TEdit;
    GroupBox19: TGroupBox;
    GroupBox20: TGroupBox;
    Label5: TLabel;
    Fby2Edit: TEdit;
    Flv2Edit: TEdit;
    GroupBox21: TGroupBox;
    Label6: TLabel;
    Tby2Edit: TEdit;
    Tlv2Edit: TEdit;
    GroupBox22: TGroupBox;
    GroupBox23: TGroupBox;
    Fst2Edit: TEdit;
    GroupBox24: TGroupBox;
    Tst2Edit: TEdit;
    GroupBox25: TGroupBox;
    GroupBox26: TGroupBox;
    Label7: TLabel;
    Sby3Edit: TEdit;
    Slv3Edit: TEdit;
    GroupBox27: TGroupBox;
    ECode3Edit: TEdit;
    GroupBox28: TGroupBox;
    GroupBox29: TGroupBox;
    Ird3Edit: TEdit;
    GroupBox30: TGroupBox;
    Ord3Edit: TEdit;
    GroupBox31: TGroupBox;
    GroupBox32: TGroupBox;
    Label8: TLabel;
    Fby3Edit: TEdit;
    Flv3Edit: TEdit;
    GroupBox33: TGroupBox;
    Label9: TLabel;
    Tby3Edit: TEdit;
    Tlv3Edit: TEdit;
    GroupBox34: TGroupBox;
    GroupBox35: TGroupBox;
    Fst3Edit: TEdit;
    GroupBox36: TGroupBox;
    Tst3Edit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateBitBtn10Click(Sender: TObject);
    procedure UpdateBitBtn11Click(Sender: TObject);
    procedure UpdateBitBtn12Click(Sender: TObject);
   
    procedure UpdateBitBtn15Click(Sender: TObject);
    procedure UpdateBitBtn20Click(Sender: TObject);
    procedure UpdateBitBtn21Click(Sender: TObject);
    procedure UpdateBitBtn22Click(Sender: TObject);
   
    procedure UpdateBitBtn25Click(Sender: TObject);
    procedure StartBitBtn2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure UpdateBitBtn30Click(Sender: TObject);
    procedure UpdateBitBtn31Click(Sender: TObject); 
   
    procedure UpdateBitBtn35Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StartBitBtn0Click(Sender: TObject);
    procedure StartBitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure UpdateBitBtn17Click(Sender: TObject);
    procedure UpdateBitBtn16Click(Sender: TObject);
    procedure UpdateBitBtn27Click(Sender: TObject);
    procedure UpdateBitBtn26Click(Sender: TObject);
    procedure UpdateBitBtn37Click(Sender: TObject);
    procedure UpdateBitBtn36Click(Sender: TObject);
    procedure UpdateBitBtn32Click(Sender: TObject);
   


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_2400: TFrm_2400;

  pclb_ch1  : array [0..9] of TCheckListBox;
  pclb_ch2  : array [0..9] of TCheckListBox;
  pclb_ch3  : array [0..9] of TCheckListBox;

  var_Msg   : String;

implementation

uses WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.DFM}

procedure TFrm_2400.FormCreate(Sender: TObject);
begin
   Pagecontrol1.ActivePage := TabSheet1;

   if (jj_kind <> '50') then
  begin
    UpdateBitBtn15.Visible    := False;   UpdateBitBtn16.Visible    := False; UpdateBitBtn17.Visible    := False;
    UpdateBitBtn25.Visible    := False;   UpdateBitBtn26.Visible    := False; UpdateBitBtn27.Visible    := False;
    UpdateBitBtn35.Visible    := False;   UpdateBitBtn36.Visible    := False; UpdateBitBtn37.Visible    := False;
  end;

   StartBitBtn0Click(Self);

end;

procedure TFrm_2400.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_2400.StartBitBtn0Click(Sender: TObject);
var
  ls_ch10, ls_ch16 : String[16];
  ls_ch11, ls_ch12, ls_ch13, ls_ch14, ls_ch15, ls_ch17, ls_ch18, ls_ch19, ls_ch20, ls_ch21, ls_ch22 : String[04];
  li_i, li_k, li_x: Integer;
  ls_chgroup: array [0..8] of String[16];
  ls_bit: String[01];
begin
  pclb_ch1[00] := CH10CLB;
  pclb_ch1[01] := CH15CLB;

  Query1.DisableControls;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add (' select scc1_ch01, scc1_ch02, scc1_ch03, scc1_ch04, scc1_ch05, scc1_ch06 ');
  Query1.SQL.Add (' from t2tbscc1 (nolock) ');
  Query1.SQL.Add (' where scc1_sr = ''R'' ');
  Query1.open;
  Query1.EnableControls;

  ls_ch10 := Query1.FieldByName('scc1_ch01').AsString;
  ls_ch11 := Query1.FieldByName('scc1_ch02').AsString;
  ls_ch12 := Query1.FieldByName('scc1_ch03').AsString;
  ls_ch13 := Query1.FieldByName('scc1_ch04').AsString;
  ls_ch14 := Query1.FieldByName('scc1_ch05').AsString;
  ls_ch15 := Query1.FieldByName('scc1_ch06').AsString;

  Query1.DisableControls;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add (' select scc1_ch01, scc1_ch02, scc1_ch03, scc1_ch04, scc1_ch05, scc1_ch06, scc1_ch07 ');
  Query1.SQL.Add (' from t2tbscc1  (nolock) ');
  Query1.SQL.Add (' where scc1_sr = ''S'' ');
  Query1.open;
  Query1.EnableControls;

  ls_ch16 := Query1.FieldByName('scc1_ch01').AsString;
  ls_ch17 := Query1.FieldByName('scc1_ch02').AsString;
  ls_ch18 := Query1.FieldByName('scc1_ch03').AsString;
  ls_ch19 := Query1.FieldByName('scc1_ch04').AsString;
  ls_ch20 := Query1.FieldByName('scc1_ch05').AsString;
  ls_ch21 := Query1.FieldByName('scc1_ch06').AsString;
  ls_ch22 := Query1.FieldByName('scc1_ch07').AsString;

  ls_chgroup[00] := ls_ch10;  ls_chgroup[01] := ls_ch16;

  for li_i := 0 to 1 do
  begin
    for li_k := 1 to 16 do
    begin
      li_x := li_k - 1;
      pclb_ch1[li_i].ItemIndex := li_x;
      ls_bit := Copy(ls_chgroup[li_i], li_k, 1);
      if ls_bit = '1' then pclb_ch1[li_i].Checked[li_x] := True
      else                 pclb_ch1[li_i].Checked[li_x] := False;
      pclb_ch1[li_i].ItemIndex := -1;
    end;
  end;

   Sby1Edit.Text := ls_ch11;     Slv1Edit.Text := ls_ch12;  Ecode1Edit.Text := ls_ch13;
   Ird1Edit.Text := ls_ch14;     Ord1Edit.Text := ls_ch15;

   Fby1Edit.Text := ls_ch17;     Flv1Edit.Text := ls_ch18;
   Tby1Edit.Text := ls_ch19;     Tlv1Edit.Text := ls_ch20;

   Fst1Edit.Text := ls_ch21;     TSt1Edit.Text := ls_ch22;

end;

procedure TFrm_2400.UpdateBitBtn10Click(Sender: TObject);
var
  ls_ch10 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add (' select scc1_ch01 from t2tbscc1 (nolock) where scc1_sr = ''R'' ');
      Query1.open;

      ls_ch10 := Query1.FieldByName('scc1_ch01').AsString;

      ls_chgroup[00] := ls_ch10;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch1[00].ItemIndex := li_x;
        if (pclb_ch1[00].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch1[00].ItemIndex := -1;
     end;

      ls_ch10 := ls_chgroup[00];

      if (Length(ls_ch10) = 0) then exit;

      if (ls_ch10 = '') then exit;

      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbscc1 set  ');
      Query1.SQL.Add(' scc1_ch01 = '''+ls_ch10+''' where scc1_sr = ''R'' ');
      Query1.ExecSQL;
      StartBitBtn0Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2400.UpdateBitBtn11Click(Sender: TObject);
var
  ls_ch02, ls_ch03, ls_ch04 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch02 := Sby1Edit.Text;
         ls_ch03 := Slv1Edit.Text;
         ls_ch04 := ECode1Edit.Text;

         if  length(ls_ch02) <> 4 then Exit;
         if  length(ls_ch03) <> 4 then Exit;
         if  length(ls_ch04) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc1 set  ');
         Query1.SQL.Add(' scc1_ch02 = '''+ls_ch02+''', scc1_ch03 = '''+ls_ch03+''',  ');
         Query1.SQL.Add(' scc1_ch04 = '''+ls_ch04+''' ');
         Query1.SQL.Add(' where scc1_sr = ''R'' ');
         Query1.ExecSQL;
         StartBitBtn0Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2400.UpdateBitBtn12Click(Sender: TObject);
var
  ls_ch05, ls_ch06 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch05 := Ird1Edit.Text;
         ls_ch06 := Ord1Edit.Text;

         if  length(ls_ch05) <> 4 then Exit;
         if  length(ls_ch06) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc1 set  ');
         Query1.SQL.Add(' scc1_ch05 = '''+ls_ch05+''', scc1_ch06 = '''+ls_ch06+'''  ');
         Query1.SQL.Add(' where scc1_sr = ''R'' ');
         Query1.ExecSQL;
         StartBitBtn0Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2400.UpdateBitBtn15Click(Sender: TObject);
var
  ls_ch15 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add (' select scc1_ch01 from t2tbscc1 (nolock) where scc1_sr = ''S'' ');
      Query1.open;

      ls_ch15 := Query1.FieldByName('scc1_ch01').AsString;

      ls_chgroup[00] := ls_ch15;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch1[01].ItemIndex := li_x;
        if (pclb_ch1[01].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch1[01].ItemIndex := -1;
     end;

      ls_ch15 := ls_chgroup[00];

      if (Length(ls_ch15) = 0) then exit;

      if (ls_ch15 = '') then exit;

      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbscc1 set  ');
      Query1.SQL.Add(' scc1_ch01 = '''+ls_ch15+''' where scc1_sr = ''S'' ');
      Query1.ExecSQL;
      StartBitBtn0Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2400.UpdateBitBtn16Click(Sender: TObject);
var
  ls_ch02, ls_ch03, ls_ch04, ls_ch05 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch02 := Fby1Edit.Text;
         ls_ch03 := Flv1Edit.Text;
         ls_ch04 := Tby1Edit.Text;
         ls_ch05 := Tlv1Edit.Text;

         if  length(ls_ch02) <> 4 then Exit;
         if  length(ls_ch03) <> 4 then Exit;
         if  length(ls_ch04) <> 4 then Exit;
         if  length(ls_ch05) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc1 set  ');
         Query1.SQL.Add(' scc1_ch02 = '''+ls_ch02+''', scc1_ch03 = '''+ls_ch03+''',  ');
         Query1.SQL.Add(' scc1_ch04 = '''+ls_ch04+''', scc1_ch05 = '''+ls_ch05+''' ');
         Query1.SQL.Add(' where scc1_sr = ''S'' ');
         Query1.ExecSQL;
         StartBitBtn0Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;

end;

procedure TFrm_2400.UpdateBitBtn17Click(Sender: TObject);
var
  ls_ch06, ls_ch07 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch06 := Fst1Edit.Text;
         ls_ch07 := Tst1Edit.Text;

         if  length(ls_ch06) <> 4 then Exit;
         if  length(ls_ch07) <> 4 then Exit;  

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc1 set  ');
         Query1.SQL.Add(' scc1_ch06 = '''+ls_ch06+''', scc1_ch07 = '''+ls_ch07+'''  ');
         Query1.SQL.Add(' where scc1_sr = ''S'' ');
         Query1.ExecSQL;
         StartBitBtn0Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

////////////////////////////////////////////////////////////
procedure TFrm_2400.StartBitBtn1Click(Sender: TObject);
var
  ls_ch10, ls_ch16 : String[16];
  ls_ch11, ls_ch12, ls_ch13, ls_ch14, ls_ch15, ls_ch17, ls_ch18, ls_ch19, ls_ch20, ls_ch21, ls_ch22 : String[04];
  li_i, li_k, li_x: Integer;
  ls_chgroup: array [0..8] of String[16];
  ls_bit: String[01];
begin
  pclb_ch2[00] := CH20CLB;
  pclb_ch2[01] := CH25CLB;

  Query1.DisableControls;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add (' select scc2_ch01, scc2_ch02, scc2_ch03, scc2_ch04, scc2_ch05, scc2_ch06 ');
  Query1.SQL.Add (' from t2tbscc2 (nolock) ');
  Query1.SQL.Add (' where scc2_sr = ''R'' ');
  Query1.open;
  Query1.EnableControls;

  ls_ch10 := Query1.FieldByName('scc2_ch01').AsString;
  ls_ch11 := Query1.FieldByName('scc2_ch02').AsString;
  ls_ch12 := Query1.FieldByName('scc2_ch03').AsString;
  ls_ch13 := Query1.FieldByName('scc2_ch04').AsString;
  ls_ch14 := Query1.FieldByName('scc2_ch05').AsString;
  ls_ch15 := Query1.FieldByName('scc2_ch06').AsString;

  Query1.DisableControls;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add (' select scc2_ch01, scc2_ch02, scc2_ch03, scc2_ch04, scc2_ch05, scc2_ch06, scc2_ch07 ');
  Query1.SQL.Add (' from t2tbscc2  (nolock) ');
  Query1.SQL.Add (' where scc2_sr = ''S'' ');
  Query1.open;
  Query1.EnableControls;

  ls_ch16 := Query1.FieldByName('scc2_ch01').AsString;
  ls_ch17 := Query1.FieldByName('scc2_ch02').AsString;
  ls_ch18 := Query1.FieldByName('scc2_ch03').AsString;
  ls_ch19 := Query1.FieldByName('scc2_ch04').AsString;
  ls_ch20 := Query1.FieldByName('scc2_ch05').AsString;
  ls_ch21 := Query1.FieldByName('scc2_ch06').AsString;
  ls_ch22 := Query1.FieldByName('scc2_ch07').AsString;

  ls_chgroup[00] := ls_ch10;  ls_chgroup[01] := ls_ch16;

  for li_i := 0 to 1 do
  begin
    for li_k := 1 to 16 do
    begin
      li_x := li_k - 1;
      pclb_ch2[li_i].ItemIndex := li_x;
      ls_bit := Copy(ls_chgroup[li_i], li_k, 1);
      if ls_bit = '1' then pclb_ch2[li_i].Checked[li_x] := True
      else                 pclb_ch2[li_i].Checked[li_x] := False;
      pclb_ch2[li_i].ItemIndex := -1;
    end;
  end;

   Sby2Edit.Text := ls_ch11;     Slv2Edit.Text := ls_ch12;  Ecode2Edit.Text := ls_ch13;
   Ird2Edit.Text := ls_ch14;     Ord2Edit.Text := ls_ch15;

   Fby2Edit.Text := ls_ch17;     Flv2Edit.Text := ls_ch18;
   Tby2Edit.Text := ls_ch19;     Tlv2Edit.Text := ls_ch20;

   Fst2Edit.Text := ls_ch21;     TSt2Edit.Text := ls_ch22;
end;


procedure TFrm_2400.UpdateBitBtn20Click(Sender: TObject);
var
  ls_ch20 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add (' select scc2_ch01 from t2tbscc2 (nolock) where scc2_sr = ''R'' ');
      Query1.open;

      ls_ch20 := Query1.FieldByName('scc2_ch01').AsString;

      ls_chgroup[00] := ls_ch20;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch2[00].ItemIndex := li_x;
        if (pclb_ch2[00].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch2[00].ItemIndex := -1;
     end;

      ls_ch20 := ls_chgroup[00];

      if (Length(ls_ch20) = 0) then exit;

      if (ls_ch20 = '') then exit;

      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbscc2 set  ');
      Query1.SQL.Add(' scc2_ch01 = '''+ls_ch20+''' where scc2_sr = ''R'' ');
      Query1.ExecSQL;
      StartBitBtn1Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;

end;

procedure TFrm_2400.UpdateBitBtn21Click(Sender: TObject);
var
  ls_ch02, ls_ch03, ls_ch04 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch02 := Sby2Edit.Text;
         ls_ch03 := Slv2Edit.Text;
         ls_ch04 := ECode2Edit.Text;

         if  length(ls_ch02) <> 4 then Exit;
         if  length(ls_ch03) <> 4 then Exit;
         if  length(ls_ch04) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc2 set  ');
         Query1.SQL.Add(' scc2_ch02 = '''+ls_ch02+''', scc2_ch03 = '''+ls_ch03+''',  ');
         Query1.SQL.Add(' scc2_ch04 = '''+ls_ch04+''' ');
         Query1.SQL.Add(' where scc2_sr = ''R'' ');
         Query1.ExecSQL;
         StartBitBtn1Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2400.UpdateBitBtn22Click(Sender: TObject);
var
  ls_ch05, ls_ch06 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch05 := Ird2Edit.Text;
         ls_ch06 := Ord2Edit.Text;

         if  length(ls_ch05) <> 4 then Exit;
         if  length(ls_ch06) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc2 set  ');
         Query1.SQL.Add(' scc2_ch05 = '''+ls_ch05+''', scc2_ch06 = '''+ls_ch06+'''  ');
         Query1.SQL.Add(' where scc2_sr = ''R'' ');
         Query1.ExecSQL;
         StartBitBtn1Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2400.UpdateBitBtn25Click(Sender: TObject);
var
  ls_ch25 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add (' select scc2_ch01 from t2tbscc2 (nolock) where scc2_sr = ''S'' ');
      Query1.open;

      ls_ch25 := Query1.FieldByName('scc2_ch01').AsString;

      ls_chgroup[00] := ls_ch25;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch2[01].ItemIndex := li_x;
        if (pclb_ch2[01].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch2[01].ItemIndex := -1;
     end;

      ls_ch25 := ls_chgroup[00];

      if (Length(ls_ch25) = 0) then exit;

      if (ls_ch25 = '') then exit;

      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbscc2 set  ');
      Query1.SQL.Add(' scc2_ch01 = '''+ls_ch25+''' where scc2_sr = ''S'' ');
      Query1.ExecSQL;
      StartBitBtn1Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;

end;

procedure TFrm_2400.UpdateBitBtn26Click(Sender: TObject);
var
  ls_ch02, ls_ch03, ls_ch04, ls_ch05 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch02 := Fby2Edit.Text;
         ls_ch03 := Flv2Edit.Text;
         ls_ch04 := Tby2Edit.Text;
         ls_ch05 := Tlv2Edit.Text;

         if  length(ls_ch02) <> 4 then Exit;
         if  length(ls_ch03) <> 4 then Exit;
         if  length(ls_ch04) <> 4 then Exit;
         if  length(ls_ch05) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc2 set  ');
         Query1.SQL.Add(' scc2_ch02 = '''+ls_ch02+''', scc2_ch03 = '''+ls_ch03+''',  ');
         Query1.SQL.Add(' scc2_ch04 = '''+ls_ch04+''', scc2_ch05 = '''+ls_ch05+''' ');
         Query1.SQL.Add(' where scc2_sr = ''S'' ');
         Query1.ExecSQL;
         StartBitBtn1Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2400.UpdateBitBtn27Click(Sender: TObject);
var
  ls_ch06, ls_ch07 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch06 := Fst2Edit.Text;
         ls_ch07 := Tst2Edit.Text;

         if  length(ls_ch06) <> 4 then Exit;
         if  length(ls_ch07) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc2 set  ');
         Query1.SQL.Add(' scc2_ch06 = '''+ls_ch06+''', scc2_ch07 = '''+ls_ch07+'''  ');
         Query1.SQL.Add(' where scc2_sr = ''S'' ');
         Query1.ExecSQL;
         StartBitBtn1Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;

end;
////////////////////////////////////////////////////////////////////////////////
procedure TFrm_2400.StartBitBtn2Click(Sender: TObject);
var
  ls_ch10, ls_ch16 : String[16];
  ls_ch11, ls_ch12, ls_ch13, ls_ch14, ls_ch15, ls_ch17, ls_ch18, ls_ch19, ls_ch20, ls_ch21, ls_ch22 : String[04];
  li_i, li_k, li_x: Integer;
  ls_chgroup: array [0..8] of String[16];
  ls_bit: String[01];
begin
  pclb_ch3[00] := CH30CLB;
  pclb_ch3[01] := CH35CLB;

  Query1.DisableControls;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add (' select scc3_ch01, scc3_ch02, scc3_ch03, scc3_ch04, scc3_ch05, scc3_ch06 ');
  Query1.SQL.Add (' from t2tbscc3 (nolock) ');
  Query1.SQL.Add (' where scc3_sr = ''R'' ');
  Query1.open;
  Query1.EnableControls;

  ls_ch10 := Query1.FieldByName('scc3_ch01').AsString;
  ls_ch11 := Query1.FieldByName('scc3_ch02').AsString;
  ls_ch12 := Query1.FieldByName('scc3_ch03').AsString;
  ls_ch13 := Query1.FieldByName('scc3_ch04').AsString;
  ls_ch14 := Query1.FieldByName('scc3_ch05').AsString;
  ls_ch15 := Query1.FieldByName('scc3_ch06').AsString;

  Query1.DisableControls;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add (' select scc3_ch01, scc3_ch02, scc3_ch03, scc3_ch04, scc3_ch05, scc3_ch06, scc3_ch07 ');
  Query1.SQL.Add (' from t2tbscc3  (nolock) ');
  Query1.SQL.Add (' where scc3_sr = ''S'' ');
  Query1.open;
  Query1.EnableControls;

  ls_ch16 := Query1.FieldByName('scc3_ch01').AsString;
  ls_ch17 := Query1.FieldByName('scc3_ch02').AsString;
  ls_ch18 := Query1.FieldByName('scc3_ch03').AsString;
  ls_ch19 := Query1.FieldByName('scc3_ch04').AsString;
  ls_ch20 := Query1.FieldByName('scc3_ch05').AsString;
  ls_ch21 := Query1.FieldByName('scc3_ch06').AsString;
  ls_ch22 := Query1.FieldByName('scc3_ch07').AsString;

  ls_chgroup[00] := ls_ch10;  ls_chgroup[01] := ls_ch16;

  for li_i := 0 to 1 do
  begin
    for li_k := 1 to 16 do
    begin
      li_x := li_k - 1;
      pclb_ch3[li_i].ItemIndex := li_x;
      ls_bit := Copy(ls_chgroup[li_i], li_k, 1);
      if ls_bit = '1' then pclb_ch3[li_i].Checked[li_x] := True
      else                 pclb_ch3[li_i].Checked[li_x] := False;
      pclb_ch3[li_i].ItemIndex := -1;
    end;
  end;

   Sby3Edit.Text := ls_ch11;     Slv3Edit.Text := ls_ch12;  Ecode3Edit.Text := ls_ch13;
   Ird3Edit.Text := ls_ch14;     Ord3Edit.Text := ls_ch15;

   Fby3Edit.Text := ls_ch17;     Flv3Edit.Text := ls_ch18;
   Tby3Edit.Text := ls_ch19;     Tlv3Edit.Text := ls_ch20;

   Fst3Edit.Text := ls_ch21;     TSt3Edit.Text := ls_ch22;
end;


procedure TFrm_2400.UpdateBitBtn30Click(Sender: TObject);
var
  ls_ch30 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add (' select scc3_ch01 from t2tbscc3 (nolock) where scc3_sr = ''R'' ');
      Query1.open;

      ls_ch30 := Query1.FieldByName('scc3_ch01').AsString;

      ls_chgroup[00] := ls_ch30;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch3[00].ItemIndex := li_x;
        if (pclb_ch3[00].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch3[00].ItemIndex := -1;
     end;

      ls_ch30 := ls_chgroup[00];

      if (Length(ls_ch30) = 0) then exit;

      if (ls_ch30 = '') then exit;

      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbscc3 set  ');
      Query1.SQL.Add(' scc3_ch01 = '''+ls_ch30+''' where scc3_sr = ''R'' ');
      Query1.ExecSQL;
      StartBitBtn2Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2400.UpdateBitBtn31Click(Sender: TObject);
var
  ls_ch02, ls_ch03, ls_ch04 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch02 := Sby3Edit.Text;
         ls_ch03 := Slv3Edit.Text;
         ls_ch04 := ECode3Edit.Text;

         if  length(ls_ch02) <> 4 then Exit;
         if  length(ls_ch03) <> 4 then Exit;
         if  length(ls_ch04) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc3 set  ');
         Query1.SQL.Add(' scc3_ch02 = '''+ls_ch02+''', scc3_ch03 = '''+ls_ch03+''',  ');
         Query1.SQL.Add(' scc3_ch04 = '''+ls_ch04+''' ');
         Query1.SQL.Add(' where scc3_sr = ''R'' ');
         Query1.ExecSQL;
         StartBitBtn2Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;

end;

procedure TFrm_2400.UpdateBitBtn32Click(Sender: TObject);
var
  ls_ch05, ls_ch06 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch05 := Ird3Edit.Text;
         ls_ch06 := Ord3Edit.Text;

         if  length(ls_ch05) <> 4 then Exit;
         if  length(ls_ch06) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc3 set  ');
         Query1.SQL.Add(' scc3_ch05 = '''+ls_ch05+''', scc3_ch06 = '''+ls_ch06+'''  ');
         Query1.SQL.Add(' where scc3_sr = ''R'' ');
         Query1.ExecSQL;
         StartBitBtn1Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2400.UpdateBitBtn35Click(Sender: TObject);
var
  ls_ch35 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add (' select scc3_ch01 from t2tbscc3 (nolock) where scc3_sr = ''S'' ');
      Query1.open;

      ls_ch35 := Query1.FieldByName('scc3_ch01').AsString;

      ls_chgroup[00] := ls_ch35;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch3[01] .ItemIndex := li_x;
        if (pclb_ch3[01].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch3[01].ItemIndex := -1;
     end;

      ls_ch35 := ls_chgroup[00];

      if (Length(ls_ch35) = 0) then exit;

      if (ls_ch35 = '') then exit;

      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbscc3 set  ');
      Query1.SQL.Add(' scc3_ch01 = '''+ls_ch35+''' where scc3_sr = ''S'' ');
      Query1.ExecSQL;
      StartBitBtn2Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2400.UpdateBitBtn36Click(Sender: TObject);
var
  ls_ch02, ls_ch03, ls_ch04, ls_ch05 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch02 := Fby3Edit.Text;
         ls_ch03 := Flv3Edit.Text;
         ls_ch04 := Tby3Edit.Text;
         ls_ch05 := Tlv3Edit.Text;

         if  length(ls_ch02) <> 4 then Exit;
         if  length(ls_ch03) <> 4 then Exit;
         if  length(ls_ch04) <> 4 then Exit;
         if  length(ls_ch05) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc3 set  ');
         Query1.SQL.Add(' scc3_ch02 = '''+ls_ch02+''', scc3_ch03 = '''+ls_ch03+''',  ');
         Query1.SQL.Add(' scc3_ch04 = '''+ls_ch04+''', scc3_ch05 = '''+ls_ch05+''' ');
         Query1.SQL.Add(' where scc3_sr = ''S'' ');
         Query1.ExecSQL;
         StartBitBtn2Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2400.UpdateBitBtn37Click(Sender: TObject);
var
  ls_ch06, ls_ch07 : String[04];
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
         ls_ch06 := Fst3Edit.Text;
         ls_ch07 := Tst3Edit.Text;

         if  length(ls_ch06) <> 4 then Exit;
         if  length(ls_ch07) <> 4 then Exit;

         Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add(' update t2tbscc3 set  ');
         Query1.SQL.Add(' scc3_ch06 = '''+ls_ch06+''', scc3_ch07 = '''+ls_ch07+'''  ');
         Query1.SQL.Add(' where scc3_sr = ''S'' ');
         Query1.ExecSQL;
         StartBitBtn2Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

//////////////////////////////////////////////////////////  

procedure TFrm_2400.PageControl1Change(Sender: TObject);
begin
  if Pagecontrol1.ActivePage = TabSheet1  then
  begin
    StartBitBtn0.Visible := True;
    StartBitBtn1.Visible := False;
    StartBitBtn2.Visible := False;
    StartBitBtn0Click(Self);
  end
  else if Pagecontrol1.ActivePage = TabSheet2  then
  begin
    StartBitBtn0.Visible := False;
    StartBitBtn1.Visible := True;
    StartBitBtn2.Visible := False; ;
    StartBitBtn1Click(Self);
  end
  else if Pagecontrol1.ActivePage = TabSheet3  then
  begin
    StartBitBtn0.Visible := False;
    StartBitBtn1.Visible := False;
    StartBitBtn2.Visible := True;
    StartBitBtn2Click(Self);
  end;   
end;


procedure TFrm_2400.FormDestroy(Sender: TObject);
begin
   Frm_2400 := Nil;
end;

procedure TFrm_2400.SpeedButton1Click(Sender: TObject);
begin
  Close;
end; 


end.

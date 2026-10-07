
unit Frm2500;
 
interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, DB, DBTables, ComCtrls, CheckLst,
  ADODB;

type
  TFrm_2500 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    StartBitBtn01: TSpeedButton;
    ExitBitBtn1: TSpeedButton;
    CH06CLB: TCheckListBox;
    CH05CLB: TCheckListBox;
    CH01CLB: TCheckListBox;
    UpdateBitBtn01: TBitBtn;
    CH02CLB: TCheckListBox;
    UpdateBitBtn02: TBitBtn;
    CH03CLB: TCheckListBox;
    CH04CLB: TCheckListBox;
    UpdateBitBtn05: TBitBtn;
    UpdateBitBtn06: TBitBtn;
    UpdateBitBtn04: TBitBtn;
    UpdateBitBtn03: TBitBtn;
    TabSheet1: TTabSheet;
    SCH01CLB: TCheckListBox;
    UpdateBitBtnS01: TBitBtn;
    SCH02CLB: TCheckListBox;
    StartBitBtn02: TSpeedButton;
    ExitBitBtn2: TSpeedButton;
    UpdateBitBtnS02: TBitBtn;
    CvcQuery: TADOQuery;
    SCH03CLB: TCheckListBox;
    UpdateBitBtnS03: TBitBtn;
    procedure ExitBitBtn1Click(Sender: TObject);
    procedure StartBitBtn01Click(Sender: TObject); 
    procedure UpdateBitBtn01Click(Sender: TObject);
    procedure UpdateBitBtn02Click(Sender: TObject);
    procedure UpdateBitBtn03Click(Sender: TObject);
    procedure UpdateBitBtn04Click(Sender: TObject);
    procedure UpdateBitBtn05Click(Sender: TObject);
    procedure UpdateBitBtn06Click(Sender: TObject);    
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   
    procedure StartBitBtn02Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ExitBitBtn2Click(Sender: TObject);

    procedure UpdateBitBtnS01Click(Sender: TObject);
    procedure UpdateBitBtnS02Click(Sender: TObject);
    procedure UpdateBitBtnS03Click(Sender: TObject);
   
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_2500: TFrm_2500;

  pclb_ch0  : array [1..6] of TCheckListBox;
  pclb_Sch0 : array [1..6] of TCheckListBox;
implementation

uses WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.dfm}

procedure TFrm_2500.FormCreate(Sender: TObject);
begin
  Pagecontrol1.ActivePage := TabSheet2;
  pclb_ch0[01]  := CH01CLB;    pclb_ch0[02]   := CH02CLB;     pclb_ch0[03] := CH03CLB;
  pclb_ch0[04]  := CH04CLB;    pclb_ch0[05]   := CH05CLB;     pclb_ch0[06] := CH06CLB;


  pclb_Sch0[01] := SCH01CLB;   pclb_Sch0[02] := SCH02CLB;     pclb_Sch0[03] := SCH03CLB;  

  if (jj_kind <> '50') then
  begin
    UpdateBitBtnS01.Visible    := False;         UpdateBitBtnS02.Visible    := False;
    UpdateBitBtnS03.Visible    := False;         
  end;

  StartBitBtn01Click(self);
end;

procedure TFrm_2500.StartBitBtn01Click(Sender: TObject);
var
  ls_ch01, ls_ch02, ls_ch03,ls_ch04, ls_ch05, ls_ch06, ls_ch07 : String[16];
  li_i, li_k, li_x: Integer;
  ls_chgroup: array [1..16] of String[16];
  ls_bit: String[01];
begin

  
  CvcQuery.Close;
  CvcQuery.SQL.Clear;
  CvcQuery.SQL.Add(' Select cvc1_ch01, cvc1_ch02 From T2Tbcvc1 (NOLOCK)  ');
  CvcQuery.SQL.Add('  Where cvc1_sr = ''R'' ');
  CvcQuery.open;

  ls_ch01 := CvcQuery.FieldByName('cvc1_ch01').AsString;
  ls_ch02 := CvcQuery.FieldByName('cvc1_ch02').AsString;

  CvcQuery.Close;
  CvcQuery.SQL.Clear;
  CvcQuery.SQL.Add(' Select cvc2_ch01, cvc2_ch02 From T2Tbcvc2 (NOLOCK)  ');
  CvcQuery.SQL.Add('  Where cvc2_sr = ''R'' ');
  CvcQuery.open;

  ls_ch03 := CvcQuery.FieldByName('cvc2_ch01').AsString;
  ls_ch04 := CvcQuery.FieldByName('cvc2_ch02').AsString;

  CvcQuery.Close;
  CvcQuery.SQL.Clear;
  CvcQuery.SQL.Add(' Select cvc3_ch01, cvc3_ch02 From T2Tbcvc3 (NOLOCK)  ');
  CvcQuery.SQL.Add('  Where cvc3_sr = ''R'' ');
  CvcQuery.open;

  ls_ch05 := CvcQuery.FieldByName('cvc3_ch01').AsString;
  ls_ch06 := CvcQuery.FieldByName('cvc3_ch02').AsString;


  ls_chgroup[01] := ls_ch01;  ls_chgroup[02] := ls_ch02;  ls_chgroup[03] := ls_ch03;
  ls_chgroup[04] := ls_ch04;  ls_chgroup[05] := ls_ch05;  ls_chgroup[06] := ls_ch06;   


  for li_i := 1 to 6 do
  begin
    for li_k := 1 to 16 do
    begin
      li_x := li_k - 1;
      pclb_ch0[li_i].ItemIndex := li_x;
      ls_bit := Copy(ls_chgroup[li_i], li_k, 1);
      if ls_bit = '1' then pclb_ch0[li_i].Checked[li_x] := True
      else                 pclb_ch0[li_i].Checked[li_x] := False;
      pclb_ch0[li_i].ItemIndex := -1;
    end;
  end;
end;


procedure TFrm_2500.UpdateBitBtn01Click(Sender: TObject);
var
  ls_ch01 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc1_ch01 from T2Tbcvc1 (NOLOCK) where cvc1_sr = ''R'' ');
      CvcQuery.open;

      ls_ch01 := CvcQuery.FieldByName('cvc1_ch01').AsString;

      ls_chgroup[00] := ls_ch01;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch0[01].ItemIndex := li_x;
        if (pclb_ch0[01].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch0[01].ItemIndex := -1;
     end;

      ls_ch01 := ls_chgroup[00];

      if (Length(ls_ch01) = 0) then exit;

      if (ls_ch01 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc1 set  ');
      CvcQuery.SQL.Add(' cvc1_ch01 = '''+ls_ch01+''' where cvc1_sr = ''R'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2500.UpdateBitBtn02Click(Sender: TObject);
var
  ls_ch02 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc1_ch02 from T2Tbcvc1 (NOLOCK) where cvc1_sr = ''R'' ');
      CvcQuery.open;

      ls_ch02 := CvcQuery.FieldByName('cvc1_ch02').AsString;

      ls_chgroup[00] := ls_ch02;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch0[02].ItemIndex := li_x;
        if (pclb_ch0[02].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch0[02].ItemIndex := -1;
     end;

      ls_ch02 := ls_chgroup[00];

      if (Length(ls_ch02) = 0) then exit;

      if (ls_ch02 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc1 set  ');
      CvcQuery.SQL.Add(' cvc1_ch02 = '''+ls_ch02+''' where cvc1_sr = ''R'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2500.UpdateBitBtn03Click(Sender: TObject);
var
  ls_ch03 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc2_ch01 from T2Tbcvc2 (NOLOCK) where cvc2_sr = ''R'' ');
      CvcQuery.open;

      ls_ch03 := CvcQuery.FieldByName('cvc2_ch01').AsString;

      ls_chgroup[00] := ls_ch03;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch0[03].ItemIndex := li_x;
        if (pclb_ch0[03].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch0[03].ItemIndex := -1;
     end;

      ls_ch03 := ls_chgroup[00];

      if (Length(ls_ch03) = 0) then exit;

      if (ls_ch03 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc2 set  ');
      CvcQuery.SQL.Add(' cvc2_ch01 = '''+ls_ch03+''' where cvc2_sr = ''R'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2500.UpdateBitBtn04Click(Sender: TObject);
var
  ls_ch04 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc2_ch02 from T2Tbcvc2 (NOLOCK) where cvc2_sr = ''R'' ');
      CvcQuery.open;

      ls_ch04 := CvcQuery.FieldByName('cvc2_ch02').AsString;

      ls_chgroup[00] := ls_ch04;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch0[04].ItemIndex := li_x;
        if (pclb_ch0[04].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch0[04].ItemIndex := -1;
     end;

      ls_ch04 := ls_chgroup[00];

      if (Length(ls_ch04) = 0) then exit;

      if (ls_ch04 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc2 set  ');
      CvcQuery.SQL.Add(' cvc2_ch02 = '''+ls_ch04+''' where cvc2_sr = ''R'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2500.UpdateBitBtn05Click(Sender: TObject);
var
  ls_ch05 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc3_ch01 from T2Tbcvc3 (NOLOCK) where cvc3_sr = ''R'' ');
      CvcQuery.open;

      ls_ch05 := CvcQuery.FieldByName('cvc3_ch01').AsString;

      ls_chgroup[00] := ls_ch05;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch0[05].ItemIndex := li_x;
        if (pclb_ch0[05].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch0[05].ItemIndex := -1;
     end;

      ls_ch05 := ls_chgroup[00];

      if (Length(ls_ch05) = 0) then exit;

      if (ls_ch05 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc3 set  ');
      CvcQuery.SQL.Add(' cvc3_ch01 = '''+ls_ch05+''' where cvc3_sr = ''R'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_2500.UpdateBitBtn06Click(Sender: TObject);
var
  ls_ch06 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc3_ch02 from T2Tbcvc3 (NOLOCK) where cvc3_sr = ''R'' ');
      CvcQuery.open;

      ls_ch06 := CvcQuery.FieldByName('cvc3_ch02').AsString;

      ls_chgroup[00] := ls_ch06;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_ch0[06].ItemIndex := li_x;
        if (pclb_ch0[06].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_ch0[06].ItemIndex := -1;
     end;

      ls_ch06 := ls_chgroup[00];

      if (Length(ls_ch06) = 0) then exit;

      if (ls_ch06 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc3 set  ');
      CvcQuery.SQL.Add(' cvc3_ch02 = '''+ls_ch06+''' where cvc3_sr = ''R'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


//////////////////////////////////////////////////////////////////
procedure TFrm_2500.StartBitBtn02Click(Sender: TObject);
var
  ls_ch01, ls_ch02, ls_ch03 : String[16];
  li_i, li_k, li_x: Integer;
  ls_chgroup: array [1..6] of String[16];
  ls_bit: String[01];
begin
  CvcQuery.Close;
  CvcQuery.SQL.Clear;
  CvcQuery.SQL.Add(' Select cvc1_ch01 From T2Tbcvc1 (NOLOCK) Where cvc1_sr = ''S'' ');
  CvcQuery.open;
  ls_ch01 := CvcQuery.FieldByName('cvc1_ch01').AsString;

  CvcQuery.Close;
  CvcQuery.SQL.Clear;
  CvcQuery.SQL.Add(' Select cvc2_ch01 From T2Tbcvc2 (NOLOCK) Where cvc2_sr = ''S'' ');
  CvcQuery.open;
  ls_ch02 := CvcQuery.FieldByName('cvc2_ch01').AsString;

  CvcQuery.Close;
  CvcQuery.SQL.Clear;
  CvcQuery.SQL.Add(' Select cvc3_ch01 From T2Tbcvc3 (NOLOCK) Where cvc3_sr = ''S'' ');
  CvcQuery.open;
  ls_ch03 := CvcQuery.FieldByName('cvc3_ch01').AsString;


  ls_chgroup[01] := ls_ch01;  ls_chgroup[02] := ls_ch02;  ls_chgroup[03] := ls_ch03;

  for li_i := 1 to 3 do
  begin
    for li_k := 1 to 16 do
    begin
      li_x := li_k - 1;
      pclb_Sch0[li_i].ItemIndex := li_x;
      ls_bit := Copy(ls_chgroup[li_i], li_k, 1);
      if ls_bit = '1' then pclb_Sch0[li_i].Checked[li_x] := True
      else                 pclb_Sch0[li_i].Checked[li_x] := False;
      pclb_Sch0[li_i].ItemIndex := -1;
    end;
  end;
end;

procedure TFrm_2500.UpdateBitBtnS01Click(Sender: TObject);
var
  ls_ch01 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc1_ch01 from T2Tbcvc1 (NOLOCK) where cvc1_sr = ''S'' ');
      CvcQuery.open;

      ls_ch01 := CvcQuery.FieldByName('cvc1_ch01').AsString;

      ls_chgroup[00] := ls_ch01;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_Sch0[01].ItemIndex := li_x;
        if (pclb_Sch0[01].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_Sch0[01].ItemIndex := -1;
     end;

      ls_ch01 := ls_chgroup[00];

      if (Length(ls_ch01) = 0) then exit;

      if (ls_ch01 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc1 set  ');
      CvcQuery.SQL.Add(' cvc1_ch01 = '''+ls_ch01+''' where cvc1_sr = ''S'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2500.UpdateBitBtnS02Click(Sender: TObject);
var
  ls_ch02 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc2_ch01 from T2Tbcvc2 (NOLOCK) where cvc2_sr = ''S'' ');
      CvcQuery.open;

      ls_ch02 := CvcQuery.FieldByName('cvc2_ch01').AsString;

      ls_chgroup[00] := ls_ch02;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_Sch0[02].ItemIndex := li_x;
        if (pclb_Sch0[02].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_Sch0[02].ItemIndex := -1;
     end;

      ls_ch02 := ls_chgroup[00];

      if (Length(ls_ch02) = 0) then exit;

      if (ls_ch02 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc2 set  ');
      CvcQuery.SQL.Add(' cvc2_ch01 = '''+ls_ch02+''' where cvc2_sr = ''S'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;

end;

procedure TFrm_2500.UpdateBitBtnS03Click(Sender: TObject);
var
  ls_ch03 : String[16];
  li_k, li_x : Integer;
  ls_chgroup: array [0..0] of String[16];
  ls_bit_char: Char;
  var_Msg : String;
begin
  var_Msg := '정말로 수정 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add (' select cvc3_ch01 from T2Tbcvc3 (NOLOCK) where cvc3_sr = ''S'' ');
      CvcQuery.open;

      ls_ch03 := CvcQuery.FieldByName('cvc3_ch01').AsString;

      ls_chgroup[00] := ls_ch03;

      for li_k := 1 to 16 do
      begin
        li_x := li_k - 1;
        pclb_Sch0[03].ItemIndex := li_x;
        if (pclb_Sch0[03].Checked[li_x] = True) then ls_bit_char := '1'
        else ls_bit_char := '0';
        ls_chgroup[00][li_k] := ls_bit_char;
        pclb_Sch0[03].ItemIndex := -1;
     end;

      ls_ch03 := ls_chgroup[00];

      if (Length(ls_ch03) = 0) then exit;

      if (ls_ch03 = '') then exit;

      CvcQuery.Close;
      CvcQuery.SQL.Clear;
      CvcQuery.SQL.Add(' update T2Tbcvc3 set  ');
      CvcQuery.SQL.Add(' cvc3_ch01 = '''+ls_ch03+''' where cvc3_sr = ''S'' ');
      CvcQuery.ExecSQL;
      StartBitBtn01Click(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;

end;





procedure TFrm_2500.ExitBitBtn1Click(Sender: TObject);
begin
  close;
end;


procedure TFrm_2500.ExitBitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TFrm_2500.FormDestroy(Sender: TObject);
begin
  Frm_2500 := Nil;
end;

procedure TFrm_2500.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;   

procedure TFrm_2500.PageControl1Change(Sender: TObject);
begin
  if      Pagecontrol1.ActivePage = TabSheet1  then StartBitBtn02Click(self)
  else if Pagecontrol1.ActivePage = TabSheet2  then StartBitBtn01Click(self);
end;



end.

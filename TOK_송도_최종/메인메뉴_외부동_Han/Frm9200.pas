unit Frm9200;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, CheckLst, ComCtrls, Db, DBTables, ADODB,
  Mask;

type
  TFrm_9200 = class(TForm)
    MesgStatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    CH12CLB: TCheckListBox;
    UpdateBitBtn12: TBitBtn;
    CH11CLB: TCheckListBox;
    UpdateBitBtn11: TBitBtn;
    StartBitBtn1: TBitBtn;
    ExitBitBtn1: TBitBtn;
    TabSheet2: TTabSheet;
    CH21CLB: TCheckListBox;
    CH22CLB: TCheckListBox;
    UpdateBitBtn22: TBitBtn;
    UpdateBitBtn21: TBitBtn;
    StartBitBtn2: TBitBtn;
    ExitBitBtn2: TBitBtn;
    CH15CLB: TCheckListBox;
    UpdateBitBtn15: TBitBtn;
    CH23CLB: TCheckListBox;
    UpdateBitBtn23: TBitBtn;
    UpdtQuery: TADOQuery;
    DispQuery: TADOQuery;
    CH16CLB: TCheckListBox;
    UpdateBitBtn16: TBitBtn;
    CH24CLB: TCheckListBox;
    UpdateBitBtn24: TBitBtn;
    GroupBox4: TGroupBox;
    Panel8: TPanel;
    UpdateBitBtn13: TBitBtn;
    CH01Edit: TMaskEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ExitBitBtn1Click(Sender: TObject);
    procedure StartBitBtn1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure StartBitBtn2Click(Sender: TObject);
    procedure UpdateBitBtn11Click(Sender: TObject);
    procedure UpdateBitBtn12Click(Sender: TObject);  
    procedure UpdateBitBtn15Click(Sender: TObject);
    procedure UpdateBitBtn22Click(Sender: TObject);
    procedure UpdateBitBtn23Click(Sender: TObject);
    procedure UpdateBitBtn21Click(Sender: TObject);
    procedure UpdateBitBtn16Click(Sender: TObject);
    procedure UpdateBitBtn24Click(Sender: TObject);
    procedure UpdateBitBtn13Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_9200: TFrm_9200;

  pclb_ch1: array [1..6] of TCheckListBox;      // Stacker Crane 수신, 송신
  pclb_ch2: array [1..5] of TCheckListBox;      // Conveyor 수신, 송신

implementation

uses WinLib, FrmPrompt, FrmError, DBSet;
{$R *.DFM}

procedure TFrm_9200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TFrm_9200.FormCreate(Sender: TObject);
begin
   PageControl1Change(Self);
end;

procedure TFrm_9200.ExitBitBtn1Click(Sender: TObject);
begin
   Close;
end;

procedure TFrm_9200.PageControl1Change(Sender: TObject);
begin
  if Pagecontrol1.ActivePage = TabSheet1  then
     StartBitBtn1Click(Self)
  else if Pagecontrol1.ActivePage = TabSheet2  then
     StartBitBtn2Click(Self);
end;

procedure TFrm_9200.StartBitBtn1Click(Sender: TObject);
var
  ls_ch11, ls_ch12, ls_ch13, ls_ch14, ls_ch15, ls_ch16 : String[16];
  li_i, li_k, li_x: Integer;
  ls_chgroup: array [1..6] of String[16];
  ls_bit: String[01];
begin
   pclb_ch1[01] := CH11CLB;  pclb_ch1[02] := CH12CLB;
   pclb_ch1[03] := CH15CLB;  pclb_ch1[04] := CH16CLB;

   With DispQuery do
   begin
      Close;
      Sql.Clear;
      Sql.Add(' Select SCC1_CH01, SCC1_CH02, SCC1_CH03, SCC1_CH04, SCC1_CH05, SCC1_CH06, SCC1_EH01  ');
      Sql.Add(' From STK1_TBSCC1 (NOLOCK) Where SCC1_SR = ''R'' ');
      Open;

      ls_ch11 := FieldByname('SCC1_CH01').AsString;
      ls_ch12 := FieldByname('SCC1_CH02').AsString;
      ls_ch13 := FieldByname('SCC1_EH01').AsString;
      ls_ch14 := FieldByname('SCC1_CH04').AsString;
      ls_ch15 := FieldByname('SCC1_CH05').AsString;
      ls_ch16 := FieldByname('SCC1_CH06').AsString;

   end;

   ls_chgroup[01] := ls_ch11;  ls_chgroup[02] := ls_ch12;
   ls_chgroup[03] := ls_ch15;  ls_chgroup[04] := ls_ch16;

   for li_i := 1 to 4 do
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
   CH01Edit.Text := ls_ch13;
end;

procedure TFrm_9200.StartBitBtn2Click(Sender: TObject);
var
  ls_ch21, ls_ch22, ls_ch23, ls_ch24, ls_ch25 : String[16];
  ls_bit01, ls_bit02 : String[16];
  li_i, li_k, li_x: Integer;
  ls_chgroup: array [1..4] of String[16];
  ls_bit: String[01];
begin
   pclb_ch2[01] := CH21CLB;   pclb_ch2[02] := CH22CLB;   pclb_ch2[03] := CH23CLB;
   pclb_ch2[04] := CH24CLB;   

   With DispQuery do
   begin

      Close;
      Sql.Clear;
      Sql.Add(' Select SCC1_CH01, SCC1_CH02, SCC1_CH03, SCC1_CH04 ');
      Sql.Add('  From STK1_TBSCC1 (NOLOCK) Where SCC1_SR = ''S'' ');
      Open;


      ls_ch21 := FieldByname('SCC1_CH01').AsString;
      ls_ch22 := FieldByname('SCC1_CH02').AsString;
      ls_ch23 := FieldByname('SCC1_CH03').AsString;
      ls_ch24 := FieldByname('SCC1_CH04').AsString;

   end;

   ls_chgroup[01] := ls_ch21;  ls_chgroup[02] := ls_ch22;  ls_chgroup[03] := ls_ch23;
   ls_chgroup[04] := ls_ch24;

   for li_i := 1 to 4 do
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
end;

procedure TFrm_9200.UpdateBitBtn11Click(Sender: TObject);
var
   ls_ch01 : String[16];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
begin
   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
         DispQuery.Close;
         DispQuery.SQL.Clear;
         DispQuery.SQL.Add (' select SCC1_CH01 from STK1_tbscc1 (NOLOCK) where scc1_sr = ''R'' ');
         DispQuery.open;

         ls_ch01 := DispQuery.FieldByName('SCC1_CH01').AsString;

         ls_chgroup[01] := ls_ch01;

         for li_k := 1 to 16 do
         begin
            li_x := li_k - 1;
            pclb_ch1[01].ItemIndex := li_x;
            if (pclb_ch1[01].Checked[li_x] = True) then ls_bit_char := '1'
            else ls_bit_char := '0';
            ls_chgroup[01][li_k] := ls_bit_char;
            pclb_ch1[01].ItemIndex := -1;
         end;
         
         ls_ch01 := ls_chgroup[01];

         if (Length(ls_ch01) = 0) then exit;

         if (ls_ch01 = '') then exit; 
         
         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' SCC1_CH01 = '''+ls_ch01+''' where scc1_sr = ''R'' ');
         UpdtQuery.ExecSQL;
         StartBitBtn1Click(self);
      MesgStatusBar1.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
      except
         on E : EDBEngineError do
            if   E.Errors[1].ErrorCode = 13059 then ShowMessage('이미 제어에서 변경 되었습니다!')
            else showmessage('Tbscc1 DB Error.!!');
      end;
   end;
end;

procedure TFrm_9200.UpdateBitBtn12Click(Sender: TObject);
var
   ls_ch01 : String[16];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
begin
   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
         DispQuery.Close;
         DispQuery.SQL.Clear;
         DispQuery.SQL.Add (' select SCC1_CH02 from STK1_tbscc1 (NOLOCK) where scc1_sr = ''R'' ');
         DispQuery.open;

         ls_ch01 := DispQuery.FieldByName('SCC1_CH02').AsString;

         ls_chgroup[01] := ls_ch01;

         for li_k := 1 to 16 do
         begin
            li_x := li_k - 1;
            pclb_ch1[02].ItemIndex := li_x;
            if (pclb_ch1[02].Checked[li_x] = True) then ls_bit_char := '1'
            else ls_bit_char := '0';
            ls_chgroup[01][li_k] := ls_bit_char;
            pclb_ch1[02].ItemIndex := -1;
         end;
         
         ls_ch01 := ls_chgroup[01];

         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' SCC1_CH02 = '''+ls_ch01+''' where scc1_sr = ''R'' ');
         UpdtQuery.ExecSQL;
         StartBitBtn1Click(self);
      MesgStatusBar1.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
      except
         on E : EDBEngineError do
            if   E.Errors[1].ErrorCode = 13059 then ShowMessage('이미 제어에서 변경 되었습니다.!!')
            else showmessage('Tbscc1 DB Error.!!');
      end;
   end;
end;


procedure TFrm_9200.UpdateBitBtn13Click(Sender: TObject);
var
   ls_ch13 : String[04];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
   ch13_data, var_msg : String;
begin

   ch13_data := CH01Edit.Text;

   if (Length(ch13_data) = 0)  or  (Length(ch13_data) < 4 ) then
   begin
       WinLib_ErrorForm('Please input (S/C#1) error code! (4digit)');     Exit;
     exit;
   end;

   var_Msg := 'Do you really want to update?';   //정말로 수정 하시겠습니까?
   if WinLib_ConfirmForm( var_Msg ) then
   begin
      try

         ls_ch13 := CH01Edit.Text;

         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' scc1_EH01 = '''+ls_ch13+''' where scc1_sr = ''R'' ');
         UpdtQuery.ExecSQL;

         StartBitBtn1Click(self);

      except
      Showmessage('There is an error occurance because of error-code.');
                         //E.Message+'로 인하여 에러가 발생 하였습니다'
      end;
   end;
end;

procedure TFrm_9200.UpdateBitBtn15Click(Sender: TObject);
var
   ls_ch01 : String[16];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
begin
   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
         DispQuery.Close;
         DispQuery.SQL.Clear;
         DispQuery.SQL.Add (' select SCC1_CH05 from STK1_tbscc1 (NOLOCK) where scc1_sr = ''R'' ');
         DispQuery.open;

         ls_ch01 := DispQuery.FieldByName('SCC1_CH05').AsString;

         ls_chgroup[01] := ls_ch01;

         for li_k := 1 to 16 do
         begin
            li_x := li_k - 1;
            pclb_ch1[03].ItemIndex := li_x;
            if (pclb_ch1[03].Checked[li_x] = True) then ls_bit_char := '1'
            else ls_bit_char := '0';
            ls_chgroup[01][li_k] := ls_bit_char;
            pclb_ch1[03].ItemIndex := -1;
         end;
         ls_ch01 := ls_chgroup[01];

         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' SCC1_CH05 = '''+ls_ch01+''' where scc1_sr = ''R'' ');
         UpdtQuery.ExecSQL;
         StartBitBtn1Click(self);
      MesgStatusBar1.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
      except
         on E : EDBEngineError do
            if   E.Errors[1].ErrorCode = 13059 then ShowMessage('이미 제어에서 변경 되었습니다.!!')
            else showmessage('Tbscc1 DB Error.!!');
      end;
   end;
end;

procedure TFrm_9200.UpdateBitBtn16Click(Sender: TObject);
var
   ls_ch01 : String[16];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
begin
   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
         DispQuery.Close;
         DispQuery.SQL.Clear;
         DispQuery.SQL.Add (' select SCC1_CH06 from STK1_tbscc1 (NOLOCK) where scc1_sr = ''R'' ');
         DispQuery.open;

         ls_ch01 := DispQuery.FieldByName('SCC1_CH06').AsString;

         ls_chgroup[01] := ls_ch01;

         for li_k := 1 to 16 do
         begin
            li_x := li_k - 1;
            pclb_ch1[04].ItemIndex := li_x;
            if (pclb_ch1[04].Checked[li_x] = True) then ls_bit_char := '1'
            else ls_bit_char := '0';
            ls_chgroup[01][li_k] := ls_bit_char;
            pclb_ch1[04].ItemIndex := -1;
         end;
         ls_ch01 := ls_chgroup[01];

         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' SCC1_CH06 = '''+ls_ch01+''' where scc1_sr = ''R'' ');
         UpdtQuery.ExecSQL;
         StartBitBtn1Click(self);
      MesgStatusBar1.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
      except
         on E : EDBEngineError do
            if   E.Errors[1].ErrorCode = 13059 then ShowMessage('이미 제어에서 변경 되었습니다.!!')
            else showmessage('Tbscc1 DB Error.!!');
      end;
   end;;
end; 

procedure TFrm_9200.UpdateBitBtn21Click(Sender: TObject);
var
   ls_bit01 : String[16];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
begin
   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
         DispQuery.Close;
         DispQuery.SQL.Clear;
         DispQuery.SQL.Add (' select SCC1_CH01 from STK1_tbscc1 (NOLOCK) where scc1_sr = ''S'' ');
         DispQuery.open;

         ls_bit01 := DispQuery.FieldByName('SCC1_CH01').AsString;

         ls_chgroup[01] := ls_bit01;

         for li_k := 1 to 16 do
         begin
            li_x := li_k - 1;
            pclb_ch2[01].ItemIndex := li_x;
            if (pclb_ch2[01].Checked[li_x] = True) then ls_bit_char := '1'
            else ls_bit_char := '0';
            ls_chgroup[01][li_k] := ls_bit_char;
            pclb_ch2[01].ItemIndex := -1;
         end;
         ls_bit01 := ls_chgroup[01];

         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' SCC1_CH01 = '''+ls_bit01+''' where scc1_sr = ''S'' ');
         UpdtQuery.ExecSQL;
         StartBitBtn1Click(self);
         MesgStatusBar1.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
      except
         on E : EDBEngineError do
            if   E.Errors[1].ErrorCode = 13059 then ShowMessage('이미 제어에서 변경 되었습니다.!!')
            else showmessage('Tbscc1 DB Error.!!');
      end;
   end;
end;

procedure TFrm_9200.UpdateBitBtn22Click(Sender: TObject);
var
   ls_bit01 : String[16];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
begin
   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
         DispQuery.Close;
         DispQuery.SQL.Clear;
         DispQuery.SQL.Add (' select SCC1_CH02 from STK1_tbscc1 (NOLOCK) where scc1_sr = ''S'' ');
         DispQuery.open;

         ls_bit01 := DispQuery.FieldByName('SCC1_CH02').AsString;

         ls_chgroup[01] := ls_bit01;

         for li_k := 1 to 16 do
         begin
            li_x := li_k - 1;
            pclb_ch2[02].ItemIndex := li_x;
            if (pclb_ch2[02].Checked[li_x] = True) then ls_bit_char := '1'
            else ls_bit_char := '0';
            ls_chgroup[01][li_k] := ls_bit_char;
            pclb_ch2[02].ItemIndex := -1;
         end;
         ls_bit01 := ls_chgroup[01];

         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' SCC1_CH02 = '''+ls_bit01+''' where scc1_sr = ''S'' ');
         UpdtQuery.ExecSQL;
         StartBitBtn1Click(self);
      MesgStatusBar1.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
      except
         on E : EDBEngineError do
            if   E.Errors[1].ErrorCode = 13059 then ShowMessage('이미 제어에서 변경 되었습니다.!!')
            else showmessage('Tbscc1 DB Error.!!');
      end;
   end;
end;


procedure TFrm_9200.UpdateBitBtn23Click(Sender: TObject);
var
   ls_bit01 : String[16];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
begin
   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
         DispQuery.Close;
         DispQuery.SQL.Clear;
         DispQuery.SQL.Add (' select SCC1_CH03 from STK1_tbscc1 (NOLOCK) where scc1_sr = ''S'' ');
         DispQuery.open;

         ls_bit01 := DispQuery.FieldByName('SCC1_CH03').AsString;

         ls_chgroup[01] := ls_bit01;

         for li_k := 1 to 16 do
         begin
            li_x := li_k - 1;
            pclb_ch2[03].ItemIndex := li_x;
            if (pclb_ch2[03].Checked[li_x] = True) then ls_bit_char := '1'
            else ls_bit_char := '0';
            ls_chgroup[01][li_k] := ls_bit_char;
            pclb_ch2[03].ItemIndex := -1;
         end;
         ls_bit01 := ls_chgroup[01];

         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' SCC1_CH03 = '''+ls_bit01+''' where scc1_sr = ''S'' ');
         UpdtQuery.ExecSQL;
         StartBitBtn1Click(self);
      MesgStatusBar1.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
      except
         on E : EDBEngineError do
            if   E.Errors[1].ErrorCode = 13059 then ShowMessage('이미 제어에서 변경 되었습니다.!!')
            else showmessage('Tbscc1 DB Error.!!');
      end;
   end;
end;   

procedure TFrm_9200.UpdateBitBtn24Click(Sender: TObject);
var
   ls_bit01 : String[16];
   li_k, li_x : Integer;
   ls_chgroup: array [1..1] of String[16];
   ls_bit_char: Char;
begin
   if MessageDlg(' 정말로 수정 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
         DispQuery.Close;
         DispQuery.SQL.Clear;
         DispQuery.SQL.Add (' select SCC1_CH04 from STK1_tbscc1 (NOLOCK) where scc1_sr = ''S'' ');
         DispQuery.open;

         ls_bit01 := DispQuery.FieldByName('SCC1_CH04').AsString;

         ls_chgroup[01] := ls_bit01;

         for li_k := 1 to 16 do
         begin
            li_x := li_k - 1;
            pclb_ch2[04].ItemIndex := li_x;
            if (pclb_ch2[04].Checked[li_x] = True) then ls_bit_char := '1'
            else ls_bit_char := '0';
            ls_chgroup[01][li_k] := ls_bit_char;
            pclb_ch2[04].ItemIndex := -1;
         end;
         ls_bit01 := ls_chgroup[01];

         UpdtQuery.Close;
         UpdtQuery.SQL.Clear;
         UpdtQuery.SQL.Add(' update STK1_tbscc1 set  ');
         UpdtQuery.SQL.Add(' SCC1_CH04 = '''+ls_bit01+''' where scc1_sr = ''S'' ');
         UpdtQuery.ExecSQL;
         StartBitBtn1Click(self);
      MesgStatusBar1.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
      except
         on E : EDBEngineError do
            if   E.Errors[1].ErrorCode = 13059 then ShowMessage('이미 제어에서 변경 되었습니다.!!')
            else showmessage('Tbscc1 DB Error.!!');
      end;
   end;
end;



end.

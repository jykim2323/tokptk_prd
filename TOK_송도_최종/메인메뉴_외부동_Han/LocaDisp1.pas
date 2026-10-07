unit LocaDisp1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, Db, DBTables, Printers,
  ADODB;

type
  TFrmLoca1_f = class(TForm)
    DescPnl: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    StartBitBtn: TSpeedButton;
    ExitBitBtn: TSpeedButton;
    TitlePnl: TPanel;
    LocaQuery: TADOQuery;
    TabControl1: TTabControl;
    Panel1: TPanel;
    Label44: TLabel;
    Panel9: TPanel;
    Label46: TLabel;
    procedure StartBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure TabControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);     
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure Rack_Create;
    procedure Location_Data_Display;
    procedure LocaDblClick(Sender: TObject);
  public
    { Public declarations }
    Bank_No : Integer;
  end;

var
  FrmLoca1_f: TFrmLoca1_f;

  Rack_Pnl : Array of TPanel;
  Loca_Pnl : TPanel;
  BK_NO : String;
  BY_NO : String;
  LV_NO : String;
  StrQry : String;
implementation

uses Dbset, define, CellDisp;

{$R *.dfm}

procedure TFrmLoca1_f.FormCreate(Sender: TObject);
begin
  Bank_No := 5;
  Rack_Create;
  StartBitBtnClick(Self);
end;

procedure TFrmLoca1_f.StartBitBtnClick(Sender: TObject);
begin
  Bank_No :=  TabControl1.TabIndex + 5;
  Location_Data_Display;
end;

procedure TFrmLoca1_f.Rack_Create;
var
  StrLevl : String;
  Pos_X, Pos_Y : Integer;
  Rack_Size_X, Rack_Size_Y : Integer;
  Rack_Start_X, Rack_Start_Y : Integer;
  MaxBay, MaxLevel : Integer;
  Li_Bay, Li_Levl, Li_i : Integer;
begin
  MaxBay := 30;
  MaxLevel := 20;
  Rack_Size_X := 35;
  Rack_Size_Y := 25;
  Rack_Start_X := 0;
  Rack_Start_Y := 100;

  SetLength(Rack_Pnl, MaxBay * MaxLevel);        // 동적 배열은 0부터 시작한다.

  for Li_Bay := 30  Downto 1 do
  Begin
    for Li_Levl := 20  Downto 1 do
    Begin
      Loca_Pnl := TPanel.Create(nil);

      Pos_X := li_bay * (Rack_Size_x + 2);
      Pos_Y := Rack_Start_Y +  (MaxLevel - li_levl) * Rack_Size_Y;

      Loca_Pnl.Top    := Pos_Y;
      Loca_Pnl.left   := Pos_X;
      Loca_Pnl.Width  := Rack_Size_X;
      Loca_Pnl.Height := Rack_Size_Y;
      Loca_Pnl.Font.Size  := 9;
//      Loca_Pnl.Font.Style := [fsBold];
      Loca_Pnl.Parent :=  FrmLoca1_f;

      Loca_Pnl.Name   := 'Loca'+ format('%2.2d', [li_bay]) + format('%2.2d', [li_levl]);
      Loca_Pnl.Caption := '';
      Loca_Pnl.Font.Color := clBlack;
      Loca_Pnl.Caption := format('%2.2d', [li_bay]) + '-' + format('%2.2d', [li_levl]);
      Loca_Pnl.OnDblClick := LocaDblClick;

//     if Li_levl = 1 Then
//       TabControl1.Canvas.TextOut(130, 200, 'AAAA');
      StrLevl := IntToStr(li_levl);
      Li_i := (Li_Bay - 1) * MaxLevel + Li_Levl - 1;
      Rack_Pnl[li_i] := loca_pnl;    
    End;
  End;
end;

procedure TFrmLoca1_f.LocaDblClick;
var
   Str : String;
begin
   Str := TPanel(Sender).Name;
   BK_NO := Format('%1.1d', [TabControl1.TabIndex + 5]);
   BY_NO := Copy(Str, 5, 2);
   LV_NO := Copy(Str, 7, 2);

   CellDisp_f.ZoneEdit.Text := 'A';
   CellDisp_f.BankEdit.Text := BK_NO;
   CellDisp_f.BayEdit.Text  := BY_NO;
   CellDisp_f.LevlEdit.Text := LV_NO;

   CellDisp_f.Show;
end;

procedure TFrmLoca1_f.TabControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Bank_No :=  TabControl1.TabIndex + 4;
  StartBitBtnClick(Self);
end;

procedure TFrmLoca1_f.LocaTion_Data_Display;
var
  StrBank, StrFlag,  StrPltno, StrEPLT : String;
  IntBk, IntBy, IntLv, IntPos : Integer;
begin
  TabControl1.TabIndex := Bank_No - 1;
  TitlePnl.Caption := '[[ ' + format('%1.1d', [Bank_No]) + ' 열 조회  ]]';
  StrBank := Format('%1.1d', [BANK_NO]);

  StrQry := ' Select LSTK_LOCA, LSTK_PLTID, LSTK_BK, LSTK_BY, LSTK_LV, LSTK_FLAG ';
  StrQry := StrQry + ' From STK1_MILSTK (NOLOCK) ';
  StrQry := StrQry + ' Where LSTK_ZONE = ''A'' AND LSTK_BK = '''+StrBank+'''  ';
  StrQry := StrQry + ' Order By LSTK_LOCA ';
  With LocaQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    First;
    IntPos := 0;

    While Not Eof Do Begin
      IntBk := FieldByName('LSTK_BK').AsInteger;
      IntBy := FieldByName('LSTK_BY').AsInteger;
      IntLv := FieldByName('LSTK_LV').AsInteger;
      StrFlag := FieldByName('LSTK_FLAG').AsString;
      StrPltNo := Trim(FieldByName('LSTK_PLTID').AsString);

      IntPos := (IntBy - 1) * 20 + IntLv - 1;

      If StrFlag = '0' Then Begin Rack_Pnl[IntPos].Color := clBtnFace;     Rack_Pnl[IntPos].Font.Color := clBlack; End
      Else If StrFlag = '1' Then Begin Rack_Pnl[IntPos].Color := clYellow; Rack_Pnl[IntPos].Font.Color := clBlue; End
      Else If StrFlag = 'X' Then Begin Rack_Pnl[IntPos].Color := clLime;   Rack_Pnl[IntPos].Font.Color := clWhite; End
      Else If StrFlag = 'Y' Then Begin Rack_Pnl[IntPos].Color := clTeal;   Rack_Pnl[IntPos].Font.Color := clWhite; End
      Else If StrFlag = 'W' Then Begin Rack_Pnl[IntPos].Color := clPurple; Rack_Pnl[IntPos].Font.Color := clWhite; End
      Else If StrFlag = 'E' Then Begin Rack_Pnl[IntPos].Color := clRed;    Rack_Pnl[IntPos].Font.Color := clWhite; End
      Else If StrFlag = 'N' Then Begin Rack_Pnl[IntPos].Color := clBlack;  Rack_Pnl[IntPos].Font.Color := clWhite; End;

//      If StrPltNo <> '' Then Rack_pnl[IntPos].Caption := StrPltNO Else Rack_pnl[IntPos].Caption := '';
      Next;
    End;
  End;
end;

procedure TFrmLoca1_f.FormShow(Sender: TObject);
begin
  Location_Data_Display;
end;


procedure TFrmLoca1_f.FormDestroy(Sender: TObject);
begin
     FrmLoca1_f := Nil;
end;

procedure TFrmLoca1_f.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

end.

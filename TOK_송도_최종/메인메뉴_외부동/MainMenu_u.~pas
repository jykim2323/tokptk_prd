unit Mainmenu_u;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons, Menus, DBTables, Db, Grids,
  DBGrids, DBCtrls, Mask, jpeg, GradRoundBtn, ADODB;

type
  TMainMenu_f = class(TForm)
    MesgStatusBar: TStatusBar;
    Timer1: TTimer;
    TblQuery: TADOQuery;
    Query1: TADOQuery;
    StartBitBtn: TBitBtn;
    Query2: TADOQuery;
    DispQuery: TADOQuery;
    UpdtQuery: TADOQuery;
    Panel5: TPanel;
    DBGrid2: TDBGrid;
    DataSource2: TDataSource;
    ScheQuery: TADOQuery;
    Image3: TImage;
    DBGrid1: TDBGrid;
    Panel27: TPanel;
    DataSource1: TDataSource;
    TrakQuery: TADOQuery;
    SC2: TPanel;
    ScPlt2: TPanel;
    SC1: TPanel;
    ScPlt1: TPanel;
    Image2: TImage;
    SC3: TPanel;
    ScPlt3: TPanel;
    PLT03: TPanel;
    PLT01: TPanel;
    PLT02: TPanel;
    ImgOut09: TImage;
    ImgIn01: TImage;
    Panel3: TPanel;
    Mnu_1000: TSpeedButton;
    Mnu_2000: TSpeedButton;
    Mnu_5000: TSpeedButton;
    Mnu_4000: TSpeedButton;
    Mnu_3000: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Mnu_5000Pnl: TPanel;
    Mnu_6100: TGradRoundBtn;
    Mnu_6200: TGradRoundBtn;
    Mnu_1000Pnl: TPanel;
    Mnu_1100: TGradRoundBtn;
    Mnu_1300: TGradRoundBtn;
    Mnu_4000Pnl: TPanel;
    Mnu_4100: TGradRoundBtn;
    Mnu_4400: TGradRoundBtn;
    Mnu_4500: TGradRoundBtn;
    Mnu_2000Pnl: TPanel;
    Mnu_2100: TGradRoundBtn;
    Mnu_2200: TGradRoundBtn;
    Mnu_2400: TGradRoundBtn;
    Mnu_2500: TGradRoundBtn;
    Mnu_2700: TGradRoundBtn;
    Mnu_2300: TGradRoundBtn;
    Mnu_3000Pnl: TPanel;
    Mnu_3700: TGradRoundBtn;
    Mnu_3100: TGradRoundBtn;
    Mnu_3300: TGradRoundBtn;
    Mnu_6300: TGradRoundBtn;
    Mnu_8000: TSpeedButton;
    Mnu_8000Pnl: TPanel;
    Mnu_8100: TGradRoundBtn;
    Panel98: TPanel;
    Panel196: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel199: TPanel;
    Panel200: TPanel;
    Panel201: TPanel;
    GroupBox8: TGroupBox;
    Panel2: TPanel;
    Panel15: TPanel;
    Panel4: TPanel;
    Panel13: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel40: TPanel;
    LocaCntPnl: TPanel;
    Panel41: TPanel;
    RealPnl: TPanel;
    EmPnl: TPanel;
    Panel42: TPanel;
    ProhibitPnl: TPanel;
    Panel43: TPanel;
    ImgS01: TImage;
    ImgS09: TImage;
    ImgS17: TImage;
    TrakQueryTRAK_NO: TStringField;
    TrakQueryTRAK_INDEX: TStringField;
    TrakQueryTRAK_GUBUN: TStringField;
    TrakQueryTRAK_LOCA: TStringField;
    TrakQueryTRAK_FLAG: TStringField;
    TrakQueryTRAK_DATE: TStringField;
    TrakQueryTRAK_TIME: TStringField;
    Mnu_3400: TGradRoundBtn;
    ScheQuerySCHE_SC: TStringField;
    ScheQuerySCHE_INDEX: TStringField;
    ScheQuerySCHE_JOBGUBUN: TStringField;
    ScheQuerySCHE_LOCA: TStringField;
    ScheQuerySCHE_DATE: TStringField;
    ScheQuerySCHE_TIME: TStringField;
    ScheQuerySCHE_EMER: TStringField;
    Mnu_4300: TGradRoundBtn;
    ScheQuerySCHE_WSNO: TStringField;
    TrakQueryTRAK_HIGH: TStringField;
    Sc1HomeCmd: TSpeedButton;
    Sc3HomeCmd: TSpeedButton;
    Sc2HomeCmd: TSpeedButton;
    EcodeEdit1: TEdit;
    EcodeEdit2: TEdit;
    EcodeEdit3: TEdit;
    Panel45: TPanel;
    Panel46: TPanel;
    Panel47: TPanel;
    EmPnl1: TPanel;
    EmPnl2: TPanel;
    EmPnl3: TPanel;
    PLT04: TPanel;
    Panel16: TPanel;
    PLT05: TPanel;
    PLT06: TPanel;
    PLT07: TPanel;
    PLT08: TPanel;
    Panel21: TPanel;
    PLT09: TPanel;
    PLT10: TPanel;
    PLT11: TPanel;
    Panel26: TPanel;
    PLT12: TPanel;
    PLT16: TPanel;
    PLT15: TPanel;
    PLT14: TPanel;
    Panel36: TPanel;
    PLT13: TPanel;
    PLT20: TPanel;
    PLT19: TPanel;
    PLT18: TPanel;
    Panel53: TPanel;
    PLT17: TPanel;
    PLT24: TPanel;
    PLT23: TPanel;
    PLT22: TPanel;
    Panel59: TPanel;
    PLT21: TPanel;
    Out1Pl: TPanel;
    ScJob_Pnl1: TPanel;
    ScLoca_Pnl1: TPanel;
    Out2Pl: TPanel;
    ScJob_Pnl2: TPanel;
    ScLoca_Pnl2: TPanel;
    Out3Pl: TPanel;
    ScJob_Pnl3: TPanel;
    ScLoca_Pnl3: TPanel;
    Open01: TPanel;
    Close01: TPanel;
    Open02: TPanel;
    Close02: TPanel;
    Open03: TPanel;
    Close03: TPanel;
    Open04: TPanel;
    Close04: TPanel;
    Open05: TPanel;
    Close05: TPanel;
    Open06: TPanel;
    Close06: TPanel;
    Panel1: TPanel;
    Panel14: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ImgS05: TImage;
    ImgS13: TImage;
    ImgS21: TImage;
    Image1: TImage;
    Image4: TImage;
    ImgIn05: TImage;
    ImgIn09: TImage;
    ImgIn13: TImage;
    ImgIn17: TImage;
    ImgIn21: TImage;
    ImgOut01: TImage;
    ImgOut05: TImage;
    ImgOut13: TImage;
    ImgOut17: TImage;
    ImgOut21: TImage;
    Image5: TImage;
    Image6: TImage;
    IRdy1Pl: TPanel;
    ORdy1Pl: TPanel;
    IRdy2Pl: TPanel;
    ORdy2Pl: TPanel;
    IRdy3Pl: TPanel;
    ORdy3Pl: TPanel;
    IRdy4Pl: TPanel;
    ORdy4Pl: TPanel;
    ORdy5Pl: TPanel;
    IRdy5Pl: TPanel;
    IRdy6Pl: TPanel;
    ORdy6Pl: TPanel;
    Mnu_1500: TGradRoundBtn;
    Mnu_4101: TGradRoundBtn;
    Mnu_4102: TGradRoundBtn;
    Mnu_4103: TGradRoundBtn;
    Mnu_6400: TGradRoundBtn;
    Mnu_6500: TGradRoundBtn;
    Image15: TImage;
    Image42: TImage;
    Image43: TImage;
    Image45: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image23: TImage;
    Image21: TImage;
    OP01RedImg: TImage;
    OP02RedImg: TImage;
    OP03RedImg: TImage;
    Mnu_7100: TGradRoundBtn;
    Mnu_6700: TGradRoundBtn;
    Door01Pnl: TPanel;
    Door02Pnl: TPanel;
    Door03Pnl: TPanel;
    Door04Pnl: TPanel;
    Door05Pnl: TPanel;
    Door06Pnl: TPanel;
    OP01BlueImg: TImage;
    OP02BlueImg: TImage;
    OP03BlueImg: TImage;
    Label6: TLabel;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Mnu_6600: TGradRoundBtn;
    Mnu_6800: TGradRoundBtn;
    InPnl: TPanel;
    Mnu_6900: TGradRoundBtn;
    Bcr1lamp: TPanel;
    BCR1Lbl: TLabel;
    Bcr2lamp: TPanel;
    BCR2Lbl: TLabel;
    Bcr3lamp: TPanel;
    BCR3Lbl: TLabel;
    Query3: TADOQuery;
    Bcr1Pnl: TPanel;
    Bcr2Pnl: TPanel;
    Bcr3Pnl: TPanel;
    Label7: TLabel;
    Mnu_3800: TGradRoundBtn;
    Mnu_3810: TGradRoundBtn;
    Mnu_3200: TGradRoundBtn;
    Mnu_3130: TGradRoundBtn;
    Mnu_1600: TGradRoundBtn;
    Mnu_6450: TGradRoundBtn;
    Mnu_6550: TGradRoundBtn;
    Mnu_3900: TGradRoundBtn;
    procedure FormPaint(Sender: TObject);
    procedure MenuSelect(Sender: TObject);
    procedure Mnu_ExitClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
   
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StartBitBtnClick(Sender: TObject);
    procedure Track_Data_Display(Sender: TObject);
    procedure SC1DblClick(Sender: TObject);
   
    procedure ScheQuerySCHE_JOBGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure Mnu_3000Click(Sender: TObject);
    procedure Mnu_4000Click(Sender: TObject);
    procedure Mnu_5000Click(Sender: TObject);
    procedure Mnu_1000Click(Sender: TObject);
    procedure Mnu_2000Click(Sender: TObject);
    procedure Mnu_8000Click(Sender: TObject);
    procedure SC2DblClick(Sender: TObject);
    procedure SC3DblClick(Sender: TObject);
    procedure Sc1HomeCmdClick(Sender: TObject);
    procedure Sc2HomeCmdClick(Sender: TObject);
    procedure Sc3HomeCmdClick(Sender: TObject);   
    procedure Open01Click(Sender: TObject);
    procedure Open03Click(Sender: TObject);
    procedure Close01Click(Sender: TObject);
    procedure Close02Click(Sender: TObject);   
    procedure Open02Click(Sender: TObject);
    procedure Close03Click(Sender: TObject);
    procedure Open04Click(Sender: TObject);
    procedure Close04Click(Sender: TObject);
    procedure Open05Click(Sender: TObject);
    procedure Close05Click(Sender: TObject);
    procedure Open06Click(Sender: TObject);
    procedure Close06Click(Sender: TObject);
    procedure InPnlClick(Sender: TObject);
    procedure Bcr1lampClick(Sender: TObject);
    procedure BCR1LblClick(Sender: TObject);
    procedure BCR2LblClick(Sender: TObject);
    procedure BCR3LblClick(Sender: TObject);

  private
    { Private declarations }
    procedure Drowing_Rack;
    procedure Stacker_Status_proc;
    procedure StStatus;
    procedure trak_disp_proc;  
    procedure link_data_move_proc;
    procedure sche_disp_proc;
    procedure image_buf_move;
    procedure Error_disp_proc;
    
  public
    { Public declarations }
  end;

var
  MainMenu_f: TMainMenu_f;


   SC_Pnl : Array[1..3] of TPanel;
   SCPlt_Pnl : Array[1..3] of TPanel;

   Plt_Pos, bank_no, s_bcr1, s_bcr2, s_bcr3 : String;

   Trak_Index : Array[1..24] of String;
   Trak_Flag : Array[1..24] of String;

   pal       :  array [1..24] of Tpanel;
   mpa_plt   :  array [1..24] of Char;
   Job_Pnl   : Array[1..3] of TPanel;
   Loca_Pnl  : Array[1..3] of TPanel;

   mps_r_ch01: String[16];   mps_r_ch02: String[16];
   mps_r_ch03: String[16];   mps_r_ch04: String[16];
   mps_r_ch05: String[16];   mps_r_ch06: String[16];

   mpa_r_ch01: array [1..16] of Char;   mpa_r_ch02: array [1..16] of Char;
   mpa_r_ch03: array [1..16] of Char;   mpa_r_ch04: array [1..16] of Char;
   mpa_r_ch05: array [1..16] of Char;   mpa_r_ch06: array [1..16] of Char;

   mps_w_ch01: String[16]; mps_w_ch02: String[16];  mps_w_ch03: String[16];
   mpa_w_ch01: array [1..16] of Char;  mpa_w_ch02: array [1..16] of Char;
   mpa_w_ch03: array [1..16] of Char;

   li_x : Integer;

implementation

uses  DbSet, Convision_u, define, Frm1100, Frm1300, Frm1500, Frm1600,
      Frm2100, Frm2200, Frm2300, Frm2400, Frm2500, Frm2700, Frm3100,
      Frm3130, Frm3200, Frm3300, Frm3400, Frm3700, Frm3800, Frm3810,
      Frm4100, Frm4300, Frm4400, Frm4500, Frm4101, Frm4102, Frm4103,
      Frm3900, Frm6100, Frm6200,  Frm6300,  Frm6400,  Frm6450,  Frm6500,  Frm6550, 
      Frm6600, Frm6700, Frm6800, Frm6900,  Frm7100, Frm8100,
      LocaDisp,
      TrakDisp_u, ScrcDisp_u, CellDisp, Frm3120;

{$R *.dfm}


procedure TMainMenu_f.FormCreate(Sender: TObject);
begin
   Self.Top    := 0;
   Self.Left   := 0;

   MesgStatusBar.Panels.Items[2].Text := formatdatetime('yyyy-mm-dd hh:nn:ss', now);
   MesgStatusBar.Panels.Items[1].Text := '[[[ 물류 자동화 전문회사 -> 한국이엔엠 주식회사(T: 031-420-4710) ]]]';

   Mnu_3000Click(Self);

   image_buf_move;
   StartbitbtnClick(Self);
end;      

procedure TMainMenu_f.image_buf_move;
begin
  SC_Pnl[1]    := Sc1;
  SCPlt_Pnl[1] := ScPlt1;

  SC_Pnl[2]    := Sc2;
  SCPlt_Pnl[2] := ScPlt2;

  SC_Pnl[3]    := Sc3;
  SCPlt_Pnl[3] := ScPlt3;

  for  li_x := 1  to  24 do
  begin
     Plt_Pos := 'PLT' + Format('%2.2d',[li_x]);   pal[li_x] := TPanel(FindComponent(Plt_pos));
  end;

  Job_Pnl[1]   := ScJob_Pnl1;   Job_Pnl[2]   := ScJob_Pnl2;   Job_Pnl[3]   := ScJob_Pnl3;
  Loca_Pnl[1]  := ScLoca_Pnl1;   Loca_Pnl[2]  := ScLoca_Pnl2;  Loca_Pnl[3]  := ScLoca_Pnl3;

end;

procedure TMainMenu_f.StartBitBtnClick(Sender: TObject);
begin
   Stacker_Status_proc;
   StStatus;
   sche_disp_proc;
   
   trak_disp_proc;
   Error_disp_proc;
end;

procedure TMainMenu_f.Timer1Timer(Sender: TObject);
begin
   Timer1.Enabled := False;
   Stacker_Status_proc;
   StStatus;
   sche_disp_proc;
   trak_disp_proc;
   Error_disp_proc;

   MesgStatusBar.Panels.Items[2].Text := formatdatetime('yyyy-mm-dd hh:nn:ss', now);
   Timer1.Enabled := True;
end;

procedure TMainMenu_f.FormPaint(Sender: TObject);
begin
   Drowing_Rack;
end;

procedure TMainMenu_f.Drowing_Rack;
var
   i, Text_Pos : Integer;
   Bank, Bay, Crane : Integer;
begin
 With MainMenu_f.Canvas do
   Begin
      // 스테커 크레인 주행 레일을 그린다.
      // 시작 위치 Rack그림의 맨 좌측 상단 부터 시작 한다.
      // 주행 레일의 길이는 MaxBay*(Cell 크기 * Cell 간격) 수평 방향
      // 주행 레일의 상단 점
      //      시작 위치 + (호기-1) * (크레인 크기 + Rack간격) +(2*(호기-1)+1) * (Cell크기 + RailOffset) +
      //                  (크레인 크기 - RailHeight) div 2

      For i:= 1 to MaxSc do
      Begin

         RailWidth  := 3;
         RailHeight := size_rack_y * MaxBay + size_space_bay * (MaxBay - 1) + 1 * (RailOffset + Size_Crane_y) * 2 + 10;
         RailLeft   := Start_x +(2*(i-1)+1) * (size_rack_x + RailOffset) +
                       (i-1) * (size_space_rack + size_Crane_x) + (size_crane_x - RailWidth) div 2;
         RailTop    := Start_y -(Size_Crane_y + RailOffset) * 1 + 200;

         // 레일을 그린다.
         Brush.Color := clBlack;
         Rectangle( RailLeft, RailTop, RailLeft + RailWidth, RailTop + RailHeight);

         // End Stopper을 그린다.

         Brush.Color := clMaroon;
         Rectangle( RailLeft - 2, RailTop - 8, RailLeft + RailWidth + 2, RailTop);
         Rectangle( RailLeft - 2, RailTop + RailHeight, RailLeft + RailWidth + 2,
                    RailTop + RailHeight + 8);
      End;

// Rack 그리기 시작

      pos_x := start_x;
      pos_y := start_y + RailOffset;
// Profile Rack을 그린다.
      for Crane := 1 to MaxSc do
      Begin
         for Bank := 1 to 2 do
         Begin
            pos_x := pos_x + (bank - 1) * size_crane_x +(2*(bank-1)) * RailOffset;
            for Bay := 1 to MaxBay do
            Begin
               Brush.Color := clwhite;      // Rack 색상

               pos_y := start_y + (20 - bay) * (size_rack_y + size_space_bay);
               Rectangle(pos_x, pos_y, pos_x + size_rack_x, pos_y + size_rack_y);


                if ((bank = 1) and (crane = 1)) or
                   ((bank = 1) and (crane = 2)) or
                   ((bank = 1) and (crane = 3)) then
                begin
                  Font.Size := 8;
                  Font.Style := [fsBold];
                  Font.Name  := '굴림체';
                  Font.Color := clblack;
                  TextOut(pos_x + 3, pos_y + 3, IntToStr(Bay));
                end;

              End;

            pos_x := pos_x + (bank - 1) * size_space_rack;
            pos_x := pos_x + size_rack_x;

         End;                // End of For Bank
      End;                   // End of For Crane

      Pos_y := Start_y - MaxSc * (size_space_rack + size_crane_y) -
                         2 * MaxSc * (size_rack_y + RailOffset);

   End;                      // End of With Canvas

end;

procedure TMainMenu_f.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  showmessage( ' X -> ' + IntToStr(x) + ' Y -> ' +  IntToStr(y));

  Case Y of
      185..518:
      Begin
      Case X of
         81..122:
         begin
               bank_no := '1';
               LocaDisp_f.Loca_Status(bank_no);
               LocaDisp_f.Show;       // 1열 상태
         End;

         175..217:
         begin
               bank_no := '2';
               LocaDisp_f.Loca_Status(bank_no);
               LocaDisp_f.Show;       // 2열 상태
         End;

         221..264:
         begin
               bank_no := '3';
               LocaDisp_f.Loca_Status(bank_no);
               LocaDisp_f.Show;       // 3열 상태
         End;

         314..356:
         begin
               bank_no := '4';
               LocaDisp_f.Loca_Status(bank_no);
               LocaDisp_f.Show;       // 4열 상태
         End;

         361..403:
         begin
               bank_no := '5';
               LocaDisp_f.Loca_Status(bank_no);
               LocaDisp_f.Show;       // 5열 상태
         End;

         455..496:
         begin
               bank_no := '6';
               LocaDisp_f.Loca_Status(bank_no);
               LocaDisp_f.Show;       // 6열 상태
         End;
      End;
      End;
   End;

end;
        
procedure TMainMenu_f.Stacker_Status_proc;
var
  IntNo, IntPos : Integer;
  StrQry, StrCycle, StrError, StrLOCA, StrReady, StrDesc, StrOnline, StrScPlt, sc1_io : String;
  ls_bit01, ls_bit02 : String;
begin

  StrQry := ' Select SCRC_NO, SCRC_CYCLE, SCRC_ONLINE, SCRC_READY, SCRC_LOCA, ';
  StrQry := StrQry + '  SCRC_SCPLT, SCRC_POSBY, SCRC_POSLV, SCRC_ERROR,        ';
  StrQry := StrQry + '  SCRC_DESC ';
  StrQry := StrQry + '  From T2TBSCRC (NOLOCK) Order By SCRC_NO ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    First;
    While Not Eof Do Begin
     IntNo     := FieldByName('SCRC_NO').AsInteger;
     IntPos    := FieldByName('SCRC_POSBY').AsInteger;
     StrCycle  := FieldByName('SCRC_CYCLE').AsString;
     StrOnline := FieldByName('SCRC_ONLINE').AsString;
     StrReady  := FieldByName('SCRC_READY').AsString;
     StrLOCA   := FieldByName('SCRC_LOCA').AsString;
     StrError  := FieldByName('SCRC_ERROR').AsString;
     StrScPlt  := FieldByName('SCRC_SCPLT').AsString;
     StrDesc   := FieldByName('SCRC_DESC').AsString;
//

      if IntPos = 0 Then intPos := 0;

      Begin
         Sc_Pnl[IntNo].Top     := start_y + (21 - IntPos - 1) * (size_rack_y + size_space_rack);
         ScPlt_Pnl[IntNo].Top  := start_y + (21 - IntPos) * (size_rack_y + size_space_rack) -1;
      End;
//
      if (StrOnline = '1') then
      begin
        if      (StrReady = '1') and (StrError = '0')  then Sc_Pnl[IntNo].Color := cllime
        else if (StrReady = '0') and (StrError = '0')  then Sc_Pnl[IntNo].Color := clyellow
        else if (StrReady = '0') and (StrError <> '0') then Sc_Pnl[IntNo].Color := clred
      end
      else Sc_Pnl[IntNo].Color := clBtnFace;

      if  (StrError <> '0') then Sc_Pnl[IntNo].Color := clred;
                                                                      
      If (StrScPlt = '1') Then SCPlt_Pnl[IntNo].Color :=  clBlack  Else SCPlt_Pnl[IntNo].Color := clBtnFace;     // 파레트 유무 표시

      if Copy(StrCycle, 2,1) <> '3' Then
      Begin
          if Copy(StrCycle,1,1) = 'I' Then Job_Pnl[IntNo].Caption := '입고'
          Else   Job_Pnl[IntNo].Caption := '출고';
      End
      Else
      Begin
           Job_Pnl[IntNo].Caption := '대기';
      End;

      Loca_Pnl[IntNo].Caption := Copy(StrLoca,1,1) + '-' + Copy(StrLoca,2,2) + '-' + Copy(StrLoca,4,1);

//          SCPlt_Pnl[1].Color := $00B56F9E Else SCPlt_Pnl[1].Color := $00EEE093;     // 파레트 유무 표시
     Next;
    End;   
   End;
End;

procedure TMainMenu_f.StStatus;
var
  ls_sql : String; 
  IntCnt, li_i : Integer;
  loca_cnt, loca_total_cnt  : String;
  Prohibit_cnt, S_Percent, Empty_cnt, Real_cnt : String;
  Stok_Percent : Real;

  EmptyCell_cnt1, MoveTrak_cnt1, AvailCell_cnt1 : Integer; // 1호기 (빈셀 , 입고이동 셀, 가용셀)
  EmptyCell_cnt2, MoveTrak_cnt2, AvailCell_cnt2 : Integer; // 2호기 (빈셀 , 입고이동 셀, 가용셀)
  EmptyCell_cnt3, MoveTrak_cnt3, AvailCell_cnt3 : Integer; // 3호기 (빈셀 , 입고이동 셀, 가용셀)

begin
  ls_sql := ' Select CVC1_CH01, CVC1_CH02 From T2Tbcvc1 (NOLOCK) Where CVC1_SR = ''R''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    mps_r_ch01  := FieldByName('CVC1_CH01').AsString;   mps_r_ch02  := FieldByName('CVC1_CH02').AsString;
  End;

  ls_sql := ' Select CVC2_CH01, CVC2_CH02 From T2Tbcvc2 (NOLOCK) Where CVC2_SR = ''R''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    mps_r_ch03  := FieldByName('CVC2_CH01').AsString;   mps_r_ch04  := FieldByName('CVC2_CH02').AsString;
  End;

  ls_sql := ' Select CVC3_CH01, CVC3_CH02 From T2Tbcvc3 (NOLOCK) Where CVC3_SR = ''R''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    mps_r_ch05  := FieldByName('CVC3_CH01').AsString;   mps_r_ch06  := FieldByName('CVC3_CH02').AsString;
  End;

 
  ls_sql := ' Select CVC1_CH01 From T2Tbcvc1 (NOLOCK) Where CVC1_SR = ''S''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    mps_w_ch01  := FieldByName('CVC1_CH01').AsString;
  End;

  ls_sql := ' Select CVC2_CH01 From T2Tbcvc2 (NOLOCK) Where CVC2_SR = ''S''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    mps_w_ch02  := FieldByName('CVC2_CH01').AsString;
  End;

  ls_sql := ' Select CVC3_CH01 From T2Tbcvc3 (NOLOCK) Where CVC3_SR = ''S''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    mps_w_ch03  := FieldByName('CVC3_CH01').AsString;
  End;

  link_data_move_proc;
 
  ls_sql := ' Select TRAK_NO, TRAK_INDEX, TRAK_FLAG FROM T2TBTRAK (NOLOCK) Order By TRAK_NO ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    While Not Eof Do Begin
      IntCnt             := FieldByName('TRAK_NO').AsInteger;
      Trak_Index[IntCnt] := Trim(FieldByName('TRAK_INDEX').AsString);
      Trak_Flag[IntCnt] := Trim(FieldByName('TRAK_FLAG').AsString);   ///
      Next;
    End;
  End;

  for li_i := 1 to 24 do
   begin
    Case Li_i Of
        1..24 :
        Begin
           if (mpa_plt[li_i] = '1') and (Trak_Index[li_i] <> '') then  begin
              Pal[li_i].Color := clBlue;
              Pal[li_i].Font.Color := clwhite;
           end
           else  if (mpa_plt[li_i] = '1') and (Trak_Index[li_i] = '') then begin
               Pal[li_i].Color := clMoneyGreen;
               Pal[li_i].Font.Color := clBlack;
           end
           else if (mpa_plt[li_i] = '0') and (Trak_Index[li_i] <> '') then begin
               Pal[li_i].Color := $00A45B6B;
               Pal[li_i].Font.Color := clwhite;
           end
           else
           begin
             Pal[li_i].Color := clBtnFace;
             Pal[li_i].Font.Color := clblack;
           end;
        End;
    End;
  end;

  OP01BlueImg.Visible := False;    OP01RedImg.Visible := False;
  OP02BlueImg.Visible := False;    OP02RedImg.Visible := False;
  OP03BlueImg.Visible := False;    OP03RedImg.Visible := False;

  If (mpa_r_ch01[16] = '1')  Then  OP01BlueImg.Visible := True   else   OP01RedImg.Visible := True;
  If (mpa_r_ch03[16] = '1')  Then  OP02BlueImg.Visible := True   else   OP02RedImg.Visible := True;
  If (mpa_r_ch05[16] = '1')  Then  OP03BlueImg.Visible := True   else   OP03RedImg.Visible := True;

{
  If (mpa_r_ch02[05] = '1')  Then  Open01.BevelWidth := 3   else  Open01.BevelWidth := 1;
  If (mpa_r_ch02[06] = '1')  Then  Close01.BevelWidth := 3   else  Close01.BevelWidth := 1;
  If (mpa_r_ch02[07] = '1')  Then  Open02.BevelWidth := 3   else  Open02.BevelWidth := 1;
  If (mpa_r_ch02[08] = '1')  Then  Close02.BevelWidth := 3   else  Close02.BevelWidth := 1;

  If (mpa_r_ch04[05] = '1')  Then  Open03.BevelWidth := 3   else  Open03.BevelWidth := 1;
  If (mpa_r_ch04[06] = '1')  Then  Close03.BevelWidth := 3   else  Close03.BevelWidth := 1;
  If (mpa_r_ch04[07] = '1')  Then  Open04.BevelWidth := 3   else  Open04.BevelWidth := 1;
  If (mpa_r_ch04[08] = '1')  Then  Close04.BevelWidth := 3   else  Close04.BevelWidth := 1;

  If (mpa_r_ch06[05] = '1')  Then  Open05.BevelWidth := 3   else  Open05.BevelWidth := 1;
  If (mpa_r_ch06[06] = '1')  Then  Close05.BevelWidth := 3   else  Close05.BevelWidth := 1;
  If (mpa_r_ch06[07] = '1')  Then  Open06.BevelWidth := 3   else  Open06.BevelWidth := 1;
  If (mpa_r_ch06[08] = '1')  Then  Close06.BevelWidth := 3   else  Close06.BevelWidth := 1;

}
  If (mpa_r_ch02[05] = '1')  Then begin Door01Pnl.Caption := 'Open';  Door01Pnl.Font.Color := ClRed end;
  If (mpa_r_ch02[06] = '1')  Then begin Door01Pnl.Caption := 'Close'; Door01Pnl.Font.Color := ClBlue  end;

  If (mpa_r_ch02[07] = '1')  Then begin Door02Pnl.Caption := 'Open';  Door02Pnl.Font.Color := ClRed end;
  If (mpa_r_ch02[08] = '1')  Then begin Door02Pnl.Caption := 'Close'; Door02Pnl.Font.Color := ClBlue  end;

  If (mpa_r_ch04[05] = '1')  Then begin Door03pnl.Caption := 'Open';  Door03Pnl.Font.Color := ClRed end;
  If (mpa_r_ch04[06] = '1')  Then begin Door03Pnl.Caption := 'Close'; Door03Pnl.Font.Color := ClBlue  end;

  If (mpa_r_ch04[07] = '1')  Then begin Door04Pnl.Caption := 'Open';  Door04Pnl.Font.Color := ClRed end;
  If (mpa_r_ch04[08] = '1')  Then begin Door04Pnl.Caption := 'Close'; Door04Pnl.Font.Color := ClBlue  end;

  If (mpa_r_ch06[05] = '1')  Then begin Door05Pnl.Caption := 'Open';  Door05Pnl.Font.Color := ClRed end;
  If (mpa_r_ch06[06] = '1')  Then begin Door05Pnl.Caption := 'Close'; Door05Pnl.Font.Color := ClBlue  end;

  If (mpa_r_ch06[07] = '1')  Then begin Door06Pnl.Caption := 'Open';  Door06Pnl.Font.Color := ClRed end;
  If (mpa_r_ch06[08] = '1')  Then begin Door06Pnl.Caption := 'Close'; Door06Pnl.Font.Color := ClBlue  end;


  If (mpa_w_ch01[01] = '1')   Then  ImgS01.Visible := True  Else  ImgS01.Visible := False;
  If (mpa_w_ch01[02] = '1')   Then  ImgS05.Visible := True  Else  ImgS05.Visible := False;

  If (mpa_w_ch02[01] = '1')   Then  ImgS09.Visible := True  Else  ImgS09.Visible := False;
  If (mpa_w_ch02[02] = '1')   Then  ImgS13.Visible := True  Else  ImgS13.Visible := False;

  If (mpa_w_ch03[01] = '1')   Then  ImgS17.Visible := True  Else  ImgS17.Visible := False;
  If (mpa_w_ch03[02] = '1')   Then  ImgS21.Visible := True  Else  ImgS21.Visible := False;

  If (mpa_r_ch01[10] = '1')  Then  ImgIn01.Visible := True  Else  ImgIn01.Visible := False;
  If (mpa_r_ch01[11] = '1')  Then  ImgIn05.Visible := True  Else  ImgIn05.Visible := False;
  If (mpa_r_ch01[12] = '1')  Then  ImgOut01.Visible := True  Else  ImgOut01.Visible := False;
  If (mpa_r_ch01[13] = '1')  Then  ImgOut05.Visible := True  Else  ImgOut05.Visible := False;

  If (mpa_r_ch03[10] = '1')  Then  ImgIn09.Visible := True  Else  ImgIn09.Visible := False;
  If (mpa_r_ch03[11] = '1')  Then  ImgIn13.Visible := True  Else  ImgIn13.Visible := False;
  If (mpa_r_ch03[12] = '1')  Then  ImgOut09.Visible := True  Else  ImgOut09.Visible := False;
  If (mpa_r_ch03[13] = '1')  Then  ImgOut13.Visible := True  Else  ImgOut13.Visible := False;


  If (mpa_r_ch05[10] = '1')  Then  ImgIn17.Visible := True  Else  ImgIn17.Visible := False;
  If (mpa_r_ch05[11] = '1')  Then  ImgIn21.Visible := True  Else  ImgIn21.Visible := False;
  If (mpa_r_ch05[12] = '1')  Then  ImgOut17.Visible := True  Else  ImgOut17.Visible := False;
  If (mpa_r_ch05[13] = '1')  Then  ImgOut21.Visible := True  Else  ImgOut21.Visible := False;

  if (Trak_Index[01] = '????')  then  Pal[01].Color := clRed;
  if (Trak_Index[09] = '????')  then  Pal[09].Color := clRed;
  if (Trak_Index[17] = '????')  then  Pal[17].Color := clRed;

  If (Trak_Index[01] <> '') and (Trak_Flag[01] = '') Then
          Begin  Bcr1Pnl.Caption := '정 상';               Bcr1Pnl.Color := clBlue;    Bcr1Pnl.Font.Color := clYellow; Pal[01].Color := clNavy; End

  Else If Trak_Flag[01] = '2' Then
          Begin Bcr1Pnl.Caption := '리딩 에러';         Bcr1Pnl.Color := clLime;    Bcr1Pnl.Font.Color := clRed;    Pal[01].Color := clRed;  End

  //Else If Trak_Flag[01] > '2'  Then
  //        Begin Bcr1Pnl.Caption := 'PLT NO 정보 없음';     Bcr1Pnl.Color := clYellow;  Bcr1Pnl.Font.Color := clRed;    Pal[01].Color := clRed;  End

  Else If Trak_Flag[01] = '4'  Then
        Begin Bcr1Pnl.Caption := 'PLT NO 정보 없음';     Bcr1Pnl.Color := clYellow;  Bcr1Pnl.Font.Color := clRed;    Pal[01].Color := clRed;  End

  Else If Trak_Flag[01] = '5'  Then
        Begin Bcr1Pnl.Caption := '1 호기 입고할 랙이 없습니다...';     Bcr1Pnl.Color := clYellow;  Bcr1Pnl.Font.Color := clRed;    Pal[01].Color := clRed;  End

  Else If (Trak_Flag[01] = '0') or (Trak_Flag[01] = '')  then
          Begin
             Bcr1Pnl.Caption := '';       Bcr1Pnl.Color := clBtnFace;     Bcr1Pnl.Font.Color := clBtnFace;
          End;

 If (Trak_Index[09] <> '') and (Trak_Flag[09] = '') Then
          Begin  Bcr2Pnl.Caption := '정 상';               Bcr2Pnl.Color := clBlue;    Bcr2Pnl.Font.Color := clYellow; Pal[09].Color := clNavy; End

  Else If Trak_Flag[09] = '2' Then
          Begin Bcr2Pnl.Caption := '리딩 에러';         Bcr2Pnl.Color := clLime;    Bcr2Pnl.Font.Color := clRed;    Pal[09].Color := clRed;  End

  //Else If Trak_Flag[09] > '2'  Then
  //        Begin Bcr2Pnl.Caption := 'PLT NO 정보 없음';     Bcr2Pnl.Color := clYellow;  Bcr2Pnl.Font.Color := clRed;    Pal[09].Color := clRed;  End

  Else If Trak_Flag[09] = '4'  Then
          Begin Bcr2Pnl.Caption := 'PLT NO 정보 없음';     Bcr2Pnl.Color := clYellow;  Bcr2Pnl.Font.Color := clRed;    Pal[09].Color := clRed;  End

  Else If Trak_Flag[09] = '5'  Then
          Begin Bcr2Pnl.Caption := '2 호기 입고할 랙이 없습니다...';     Bcr2Pnl.Color := clYellow;  Bcr2Pnl.Font.Color := clRed;    Pal[09].Color := clRed;  End

  Else If (Trak_Flag[09] = '0') or (Trak_Flag[09] = '')  then
          Begin
             Bcr2Pnl.Caption := '';       Bcr2Pnl.Color := clBtnFace;     Bcr2Pnl.Font.Color := clBtnFace;
          End;

 If (Trak_Index[17] <> '') and (Trak_Flag[17] = '') Then
          Begin  Bcr3Pnl.Caption := '정 상';               Bcr3Pnl.Color := clBlue;    Bcr3Pnl.Font.Color := clYellow; Pal[17].Color := clNavy; End

  Else If Trak_Flag[17] = '2' Then
          Begin Bcr3Pnl.Caption := '리딩 에러';         Bcr3Pnl.Color := clLime;    Bcr3Pnl.Font.Color := clRed;    Pal[17].Color := clRed;  End

  //Else If Trak_Flag[17] > '2'  Then
  //        Begin Bcr3Pnl.Caption := 'PLT NO 정보 없음';     Bcr3Pnl.Color := clYellow;  Bcr3Pnl.Font.Color := clRed;    Pal[17].Color := clRed;  End

  Else If Trak_Flag[17] = '4'  Then
          Begin Bcr3Pnl.Caption := 'PLT NO 정보 없음';     Bcr3Pnl.Color := clYellow;  Bcr3Pnl.Font.Color := clRed;    Pal[17].Color := clRed;  End

  Else If Trak_Flag[17] = '5'  Then
          Begin Bcr3Pnl.Caption := '3 호기 입고할 랙이 없습니다...';     Bcr3Pnl.Color := clYellow;  Bcr3Pnl.Font.Color := clRed;    Pal[17].Color := clRed;  End

  Else If (Trak_Flag[17] = '0') or (Trak_Flag[17] = '')  then
          Begin
             Bcr3Pnl.Caption := '';       Bcr3Pnl.Color := clBtnFace;     Bcr3Pnl.Font.Color := clBtnFace;
          End;                    

  ls_sql := ' select STAT_BCR1, STAT_BCR2, STAT_BCR3 from t2TBSTAT (NOLOCK) where stat_pswd = ''JPLS'' ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    s_bcr1 := FieldByName('STAT_BCR1').AsString;
    s_bcr2 := FieldByName('STAT_BCR2').AsString;
    s_bcr3 := FieldByName('STAT_BCR3').AsString;

    if (s_bcr1 = '1') then begin Bcr1Lbl.Font.Color := clBlue; end
    else begin  Bcr1Lbl.Font.Color := clRed;   end;

    if (s_bcr2 = '1') then begin Bcr2Lbl.Font.Color := clBlue; end
    else begin  Bcr2Lbl.Font.Color := clRed;   end;

    if (s_bcr3 = '1') then begin Bcr3Lbl.Font.Color := clBlue; end
    else begin  Bcr3Lbl.Font.Color := clRed;   end;

  End;



  ls_sql := ' Select SCC1_CH05, SCC1_CH06 From T2TBSCC1 (NOLOCK) Where SCC1_SR = ''R'' ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;


    If (Copy(FieldByName('SCC1_CH05').AsString, 4, 1) = '1') then IRdy1Pl.Color := clLime  else   IRdy1Pl.Color := clwhite;
    If (Copy(FieldByName('SCC1_CH05').AsString, 4, 1) = '2') then IRdy2Pl.Color := clLime  else   IRdy2Pl.Color := clwhite;
    If (Copy(FieldByName('SCC1_CH05').AsString, 4, 1) = '3') then  begin IRdy1Pl.Color := clLime; IRdy2Pl.Color := clLime; end;

    If (Copy(FieldByName('SCC1_CH06').AsString, 4, 1) = '1') then ORdy1Pl.Color := clLime  else   ORdy1Pl.Color := clwhite;
    If (Copy(FieldByName('SCC1_CH06').AsString, 4, 1) = '2') then ORdy2Pl.Color := clLime  else   ORdy2Pl.Color := clwhite;
    If (Copy(FieldByName('SCC1_CH06').AsString, 4, 1) = '3') then begin ORdy1Pl.Color := clLime; ORdy2Pl.Color := clLime end;
  End;

  ls_sql := ' Select SCC2_CH05, SCC2_CH06 From T2TBSCC2 (NOLOCK) Where SCC2_SR = ''R'' ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;


    If (Copy(FieldByName('SCC2_CH05').AsString, 4, 1) = '1') then IRdy3Pl.Color := clLime  else   IRdy3Pl.Color := clwhite;
    If (Copy(FieldByName('SCC2_CH05').AsString, 4, 1) = '2') then IRdy4Pl.Color := clLime  else   IRdy4Pl.Color := clwhite;
    If (Copy(FieldByName('SCC2_CH05').AsString, 4, 1) = '3') then  begin IRdy3Pl.Color := clLime; IRdy4Pl.Color := clLime; end;

    If (Copy(FieldByName('SCC2_CH06').AsString, 4, 1) = '1') then ORdy3Pl.Color := clLime  else   ORdy3Pl.Color := clwhite;
    If (Copy(FieldByName('SCC2_CH06').AsString, 4, 1) = '2') then ORdy4Pl.Color := clLime  else   ORdy4Pl.Color := clwhite;
    If (Copy(FieldByName('SCC2_CH06').AsString, 4, 1) = '3') then begin ORdy3Pl.Color := clLime; ORdy4Pl.Color := clLime end;
  End;

  ls_sql := ' Select SCC3_CH05, SCC3_CH06 From T2TBSCC3 (NOLOCK) Where SCC3_SR = ''R'' ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;


    If (Copy(FieldByName('SCC3_CH05').AsString, 4, 1) = '1') then IRdy5Pl.Color := clLime  else   IRdy5Pl.Color := clwhite;
    If (Copy(FieldByName('SCC3_CH05').AsString, 4, 1) = '2') then IRdy6Pl.Color := clLime  else   IRdy6Pl.Color := clwhite;
    If (Copy(FieldByName('SCC3_CH05').AsString, 4, 1) = '3') then  begin IRdy5Pl.Color := clLime; IRdy6Pl.Color := clLime; end;

    If (Copy(FieldByName('SCC3_CH06').AsString, 4, 1) = '1') then ORdy5Pl.Color := clLime  else   ORdy5Pl.Color := clwhite;
    If (Copy(FieldByName('SCC3_CH06').AsString, 4, 1) = '2') then ORdy6Pl.Color := clLime  else   ORdy6Pl.Color := clwhite;
    If (Copy(FieldByName('SCC3_CH06').AsString, 4, 1) = '3') then begin ORdy5Pl.Color := clLime; ORdy6Pl.Color := clLime end;
  End;


  // 총 재고 현황
  ls_sql := ' Select Count(*) LSTK_CNT From T2MILSTK (NOLOCK) Where LSTK_FLAG IN (''1'', ''Y'') ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    loca_cnt := FieldByName('LSTK_CNT').AsString;
    Stok_Percent  :=   Fields[0].AsInteger;
  End;

  ls_sql := ' Select Count(*) LSTK_CNT From T2MILSTK (NOLOCK)';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    loca_total_cnt := FieldByName('LSTK_CNT').AsString;
  End;

//     빈셀
  ls_sql := ' Select Count(*) From T2MILSTK (NOLOCK) Where  LSTK_FLAG IN (''0'') ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    Empty_Cnt :=  IntToStr(Fields[0].AsInteger);
  End;

  ls_sql := ' Select Count(*) From T2MILSTK (NOLOCK) Where LSTK_FLAG IN (''1'', ''Y'')  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    Real_Cnt :=  IntToStr(Fields[0].AsInteger);
  End;

  ls_sql := ' Select Count(*) From T2MILSTK (NOLOCK) Where LSTK_FLAG = ''N''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    Prohibit_cnt  := IntToStr(Fields[0].AsInteger);
  End;

  EmPnl.Caption    := Empty_cnt;
  RealPnl.Caption  := Real_cnt;
  ProhibitPnl.Caption := Prohibit_cnt;

//  LocaCntPnl.Caption := loca_cnt  + ' / ' + loca_total_cnt;

  Stok_Percent     :=  (Stok_Percent / 702)  * 100;    
  S_Percent        := Format('%3.1f', [Stok_Percent]);

  LocaCntPnl.Caption  := S_percent + '%';
//  if Stok_Percent >= 90 then  LocaCntPnl.Font.Color := Clred;

  // 기존 1호기 빈셀 cnt
  {
  ls_sql := ' Select Count(*) From T2MILSTK (NOLOCK) Where LSTK_FLAG IN (''0'') AND LSTK_BK IN (''1'', ''2'')  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

     EmPnl1.Caption  := IntToStr(Fields[0].AsInteger);
  End;
  }

  // 1호기 빈셀
  ls_sql := ' SELECT COUNT(*) AS CNT FROM T2MILSTK (NOLOCK) ';
  ls_sql := ls_sql + ' WHERE LSTK_BK IN (''1'', ''2'') AND LSTK_FLAG = ''0'' ';
  
  With TblQuery Do Begin 
    Close;
    SQL.Clear;
    SQL.Add(ls_sql); Open;
    EmptyCell_cnt1 := Fields[0].AsInteger;
  End;

  // 1호기 이동셀
  ls_sql := ' SELECT COUNT(*) AS CNT FROM T2TBTRAK T (NOLOCK) ';
  ls_sql := ls_sql + ' WHERE ISNULL(TRAK_PLTNO, '''') <> '''' ';
  ls_sql := ls_sql + '   AND TRAK_GUBUN IN (''I'', ''R'') ';
  ls_sql := ls_sql + '   AND ( ';
  ls_sql := ls_sql + '         T.TRAK_NO IN (''01'', ''02'', ''03'', ''05'', ''06'', ''07'') ';
  ls_sql := ls_sql + '      OR ';
  // 입고 직전 구간 (04, 08) - SC 정보와 마스터 상태 크로스 체크
  ls_sql := ls_sql + '        ( T.TRAK_NO IN (''04'', ''08'') ';
  ls_sql := ls_sql + '          AND NOT EXISTS ( ';
  ls_sql := ls_sql + '              SELECT 1 FROM T2TBSCRC S (NOLOCK) ';
  ls_sql := ls_sql + '              INNER JOIN T2MILSTK M (NOLOCK) ON M.LSTK_LOCA = S.SCRC_LOCA ';
  ls_sql := ls_sql + '              WHERE S.SCRC_PLTNO = T.TRAK_PLTNO '; // PLTNO 매칭
  ls_sql := ls_sql + '                AND M.LSTK_FLAG <> ''0'' ';        // 이미 처리된 놈은 제외
  ls_sql := ls_sql + '          ) ';
  ls_sql := ls_sql + '        ) ';
  ls_sql := ls_sql + '   ) ';

  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    MoveTrak_cnt1 := Fields[0].AsInteger;
  End;

  // 1호기 가용셀
  AvailCell_cnt1 := EmptyCell_cnt1 - MoveTrak_cnt1;
  if AvailCell_cnt1 < 0 then AvailCell_cnt1 := 0; // 마이너스 방지

  EmPnl1.Caption := IntToStr(AvailCell_cnt1);


  // 기존 2호기 빈셀 cnt
  {
  ls_sql := ' Select Count(*) From T2MILSTK (NOLOCK) Where LSTK_FLAG IN (''0'') AND LSTK_BK IN (''3'', ''4'') ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    EmPnl2.Caption  := IntToStr(Fields[0].AsInteger);
  End;
  }

  // 2호기 빈셀
  ls_sql := ' SELECT COUNT(*) AS CNT FROM T2MILSTK (NOLOCK) ';
  ls_sql := ls_sql + ' WHERE LSTK_BK IN (''3'', ''4'') AND LSTK_FLAG = ''0'' ';
  
  With TblQuery Do Begin 
    Close; SQL.Clear; SQL.Add(ls_sql); Open;
    EmptyCell_cnt2 := Fields[0].AsInteger;
  End;

  // 2호기 이동셀
  ls_sql := ' SELECT COUNT(*) AS CNT FROM T2TBTRAK T (NOLOCK) ';
  ls_sql := ls_sql + ' WHERE ISNULL(TRAK_PLTNO, '''') <> '''' ';
  ls_sql := ls_sql + '   AND TRAK_GUBUN IN (''I'', ''R'') ';
  ls_sql := ls_sql + '   AND ( ';
  ls_sql := ls_sql + '         T.TRAK_NO IN (''09'', ''10'', ''11'', ''13'', ''14'', ''15'') ';
  ls_sql := ls_sql + '      OR ';
  // 입고 직전 구간 (12, 16)
  ls_sql := ls_sql + '        ( T.TRAK_NO IN (''12'', ''16'') ';
  ls_sql := ls_sql + '          AND NOT EXISTS ( ';
  ls_sql := ls_sql + '              SELECT 1 FROM T2TBSCRC S (NOLOCK) ';
  ls_sql := ls_sql + '              INNER JOIN T2MILSTK M (NOLOCK) ON M.LSTK_LOCA = S.SCRC_LOCA ';
  ls_sql := ls_sql + '              WHERE S.SCRC_PLTNO = T.TRAK_PLTNO ';
  ls_sql := ls_sql + '                AND M.LSTK_FLAG <> ''0'' ';
  ls_sql := ls_sql + '          ) ';
  ls_sql := ls_sql + '        ) ';
  ls_sql := ls_sql + '   ) ';

  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    MoveTrak_cnt2 := Fields[0].AsInteger;
  End;

  // 2호기 가용 셀
  AvailCell_cnt2 := EmptyCell_cnt2 - MoveTrak_cnt2;
  if AvailCell_cnt2 < 0 then AvailCell_cnt2 := 0;

  EmPnl2.Caption := IntToStr(AvailCell_cnt2);




  // 기존 3호기 빈셀 cnt
  {
  ls_sql := ' Select Count(*) From T2MILSTK (NOLOCK) Where LSTK_FLAG IN (''0'') AND LSTK_BK IN (''5'', ''6'')  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    EmPnl3.Caption  := IntToStr(Fields[0].AsInteger);
  End;
  }

  // 3호기 빈셀
  ls_sql := ' SELECT COUNT(*) AS CNT FROM T2MILSTK (NOLOCK) ';
  ls_sql := ls_sql + ' WHERE LSTK_BK IN (''5'', ''6'') AND LSTK_FLAG = ''0'' ';

  With TblQuery Do Begin
    Close; SQL.Clear; SQL.Add(ls_sql); Open;
    EmptyCell_cnt3 := Fields[0].AsInteger;
  End;

  // 3호기 이동셀
  ls_sql := ' SELECT COUNT(*) AS CNT FROM T2TBTRAK T (NOLOCK) ';
  ls_sql := ls_sql + ' WHERE ISNULL(TRAK_PLTNO, '''') <> '''' ';
  ls_sql := ls_sql + '   AND TRAK_GUBUN IN (''I'', ''R'') ';
  ls_sql := ls_sql + '   AND ( ';
  ls_sql := ls_sql + '         T.TRAK_NO IN (''17'', ''18'', ''19'', ''21'', ''22'', ''23'') ';
  ls_sql := ls_sql + '      OR ';
  // 입고 직전 구간 (20, 24)
  ls_sql := ls_sql + '        ( T.TRAK_NO IN (''20'', ''24'') ';
  ls_sql := ls_sql + '          AND NOT EXISTS ( ';
  ls_sql := ls_sql + '              SELECT 1 FROM T2TBSCRC S (NOLOCK) ';
  ls_sql := ls_sql + '              INNER JOIN T2MILSTK M (NOLOCK) ON M.LSTK_LOCA = S.SCRC_LOCA ';
  ls_sql := ls_sql + '              WHERE S.SCRC_PLTNO = T.TRAK_PLTNO ';
  ls_sql := ls_sql + '                AND M.LSTK_FLAG <> ''0'' ';
  ls_sql := ls_sql + '          ) ';
  ls_sql := ls_sql + '        ) ';
  ls_sql := ls_sql + '   ) ';

  With TblQuery Do Begin
    Close; SQL.Clear; SQL.Add(ls_sql); Open;
    MoveTrak_cnt3 := Fields[0].AsInteger;
  End;

  With TblQuery Do Begin
    Close; SQL.Clear; SQL.Add(ls_sql); Open;
    MoveTrak_cnt3 := Fields[0].AsInteger;
  End;

  // 3호기 가용셀
  AvailCell_cnt3 := EmptyCell_cnt3 - MoveTrak_cnt3;
  if AvailCell_cnt3 < 0 then AvailCell_cnt3 := 0;

  EmPnl3.Caption := IntToStr(AvailCell_cnt3);



  ls_sql := ' Select Count(*) From T2TISCHE (NOLOCK) Where SCHE_SC = ''1''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    Out1Pl.Caption  :=  IntToStr(Fields[0].AsInteger);
  End;

  ls_sql := ' Select Count(*) From T2TISCHE (NOLOCK) Where SCHE_SC = ''2''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    Out2Pl.Caption  :=  IntToStr(Fields[0].AsInteger);
  End;

  ls_sql := ' Select Count(*) From T2TISCHE (NOLOCK) Where SCHE_SC = ''3''  ';
  With TblQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    Out3Pl.Caption  :=  IntToStr(Fields[0].AsInteger);
  End;

end;


procedure TMainMenu_f.trak_disp_proc;
var
 ls_sql  : String;
begin
 ls_sql := '  Select  * From T2TBTRAK  (NOLOCK) Where Trak_index <> '''' Order By Trak_No ';
  With TrakQuery do Begin
    Close;
    SQL.clear;
    SQL.Add(ls_sql);
    Open;
  End;  
end;

procedure TMainMenu_f.sche_disp_proc;
var
 ls_sql : String;
begin  
  ls_sql :=  '  Select * From T2TISCHE (NOLOCK)  ';
  ls_sql :=  ls_sql +   ' Order By SCHE_INDEX ';
  With ScheQuery do Begin
    Close;
    SQL.clear;
    SQL.Add(ls_sql);
    Open;
  End;

end;


procedure TMainMenu_f.Error_disp_proc;
var
 ls_sql, ls_ecode, ls_ename : String;
begin
  ls_sql :=  '   Select SCC1_CH04, ERR_DESC From T2tbscc1 (NOLOCK)  ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN T2TBECODE (NOLOCK) ON ERR_ECODE = SCC1_CH04 ';
  ls_sql := ls_sql + ' Where SCC1_SR = ''R'' ';
  With TblQuery do Begin
    Close;
    SQL.clear;
    SQL.Add(ls_sql);
    Open;
    ls_ecode := FieldByName('scc1_ch04').AsString;
    ls_ename := FieldByName('err_desc').AsString;
    if ls_ecode = '0000' then EcodeEdit1.Text := ''
    else  EcodeEdit1.Text := ls_ecode + ' = ' + ls_ename;
  End;

//   if (ls_ecode = '0084') then  Door1Lb.Font.Color := ClRed  else  Door1Lb.Font.Color := ClBlue;
//   if (ls_ecode = '0085') then  Door2Lb.Font.Color := ClRed  else  Door2Lb.Font.Color := ClBlue;
//   if (ls_ecode = '0087') then  Door3Lb.Font.Color := ClRed  else  Door3Lb.Font.Color := ClBlue;
//   if (ls_ecode = '0088') then  Door4Lb.Font.Color := ClRed  else  Door4Lb.Font.Color := ClBlue;

  ls_sql :=  '   Select SCC2_CH04, ERR_DESC From T2tbscc2 (NOLOCK)  ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN TBECODE (NOLOCK) ON ERR_ECODE = SCC2_CH04 ';
  ls_sql := ls_sql + ' Where SCC2_SR = ''R'' ';
  With TblQuery do Begin
    Close;
    SQL.clear;
    SQL.Add(ls_sql);
    Open;
    ls_ecode := FieldByName('scc2_ch04').AsString;
    ls_ename := FieldByName('err_desc').AsString;
    if ls_ecode = '0000' then EcodeEdit2.Text := ''
    else  EcodeEdit2.Text := ls_ecode + ' = ' + ls_ename;
  End;

  ls_sql :=  '   Select SCC3_CH04, ERR_DESC From T2tbscc3 (NOLOCK)  ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN TBECODE (NOLOCK) ON ERR_ECODE = SCC3_CH04 ';
  ls_sql := ls_sql + ' Where SCC3_SR = ''R'' ';
  With TblQuery do Begin
    Close;
    SQL.clear;
    SQL.Add(ls_sql);
    Open;
    ls_ecode := FieldByName('scc3_ch04').AsString;
    ls_ename := FieldByName('err_desc').AsString;
    if ls_ecode = '0000' then EcodeEdit3.Text := ''
    else  EcodeEdit3.Text := ls_ecode + ' = ' + ls_ename;
  End;
end;


procedure TMainMenu_f.Mnu_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainMenu_f.MenuSelect(Sender: TObject);
var
  li_i : Integer;
  Var_SelForm : TForm;
  FormExist, Var_Modal : Boolean;
  var_MenuName, var_ClassName : String;
begin
  Screen.Cursor := crHourGlass;

  FormExist := False;
  Var_Modal := False;
  var_SelForm := Nil;

  var_ClassName := Sender.ClassName;

  If var_ClassName = 'TGradRoundBtn' Then
    var_MenuName := Copy( TMenuItem(Sender).Name, 5, Length( TMenuItem(Sender).Name) - 1)
  Else Begin
    ShowMessage(' 선택이 잘못 되었습니다.');
    Screen.Cursor := crDefault;
  End;

 {
// SDI 창의 수만큼 Loop
  For li_i := 0 To Screen.FormCount - 1 Do Begin
    If Screen.Forms[li_i].Name = 'Frm_' + Var_MenuName Then Begin
      With Screen.Forms[li_i] Do Begin
        BorderStyle := bsSizeable;
        BorderIcons := [biSystemMenu, biMinimize, biMaximize, biHelp];
        Screen.Forms[li_i].SetFocus;
      End;

      FormExist := True;
      Break;
    End;
  End;
}
  If Not FormExist Then Begin
    If var_MenuName = '1100' Then Begin
        Var_SelForm := Tfrm_1100.Create(Application);
    End Else If var_MenuName = '1300' Then Begin
        Var_SelForm := Tfrm_1300.Create(Application);
    End Else If var_MenuName = '1500' Then Begin
        Var_SelForm := Tfrm_1500.Create(Application);
    End Else If var_MenuName = '1600' Then Begin
        Var_SelForm := Tfrm_1600.Create(Application);
    End Else If var_MenuName = '2100' Then Begin
        Var_SelForm := Tfrm_2100.Create(Application);
    End Else If var_MenuName = '3100' Then Begin
        Var_SelForm := Tfrm_3100.Create(Application);
    End Else If var_MenuName = '3130' Then Begin
        Var_SelForm := Tfrm_3130.Create(Application);
    End Else If var_MenuName = '3200' Then Begin
        Var_SelForm := Tfrm_3200.Create(Application);
    End Else If var_MenuName = '3300' Then Begin
        Var_SelForm := Tfrm_3300.Create(Application);
    End Else If var_MenuName = '3400' Then Begin
        Var_SelForm := Tfrm_3400.Create(Application);
    End Else If var_MenuName = '3700' Then Begin
        Var_SelForm := Tfrm_3700.Create(Application);
    End Else If var_MenuName = '3800' Then Begin
        Var_SelForm := Tfrm_3800.Create(Application);
    End Else If var_MenuName = '3810' Then Begin
        Var_SelForm := Tfrm_3810.Create(Application);
    End Else If var_MenuName = '3900' Then Begin
        Var_SelForm := Tfrm_3900.Create(Application);
    End Else If var_MenuName = '4101' Then Begin
        Var_SelForm := Tfrm_4101.Create(Application);   
    End Else If var_MenuName = '4102' Then Begin
        Var_SelForm := Tfrm_4102.Create(Application);
    End Else If var_MenuName = '4103' Then Begin
        Var_SelForm := Tfrm_4103.Create(Application);
    End Else If var_MenuName = '4100' Then Begin
        Var_SelForm := Tfrm_4100.Create(Application);
    End Else If var_MenuName = '4300' Then Begin
        Var_SelForm := Tfrm_4300.Create(Application);
    End Else If var_MenuName = '4400' Then Begin
        Var_SelForm := Tfrm_4400.Create(Application);
    End Else If var_MenuName = '4500' Then Begin
        Var_SelForm := Tfrm_4500.Create(Application);
    End Else If var_MenuName = '6100' Then Begin
        Var_SelForm := Tfrm_6100.Create(Application);
    End Else If var_MenuName = '6200' Then Begin
        Var_SelForm := Tfrm_6200.Create(Application);
    End Else If var_MenuName = '6300' Then Begin
        Var_SelForm := Tfrm_6300.Create(Application);
    End Else If var_MenuName = '6400' Then Begin
        Var_SelForm := Tfrm_6400.Create(Application);
    End Else If var_MenuName = '6450' Then Begin
        Var_SelForm := Tfrm_6450.Create(Application);
    End Else If var_MenuName = '6500' Then Begin
        Var_SelForm := Tfrm_6500.Create(Application);
    End Else If var_MenuName = '6550' Then Begin
        Var_SelForm := Tfrm_6550.Create(Application);
    End Else If var_MenuName = '6600' Then Begin
        Var_SelForm := Tfrm_6600.Create(Application);
    End Else If var_MenuName = '6700' Then Begin
        Var_SelForm := Tfrm_6700.Create(Application);
    End Else If var_MenuName = '6800' Then Begin
        Var_SelForm := Tfrm_6800.Create(Application);
    End Else If var_MenuName = '6900' Then Begin
        Var_SelForm := TFrm_6900.Create(Application);
    End Else If var_MenuName = '2200' Then Begin
        Var_SelForm := Tfrm_2200.Create(Application);
    End Else If var_MenuName = '2300' Then Begin
        Var_SelForm := Tfrm_2300.Create(Application);
    End Else If var_MenuName = '2400' Then Begin
        Var_SelForm := Tfrm_2400.Create(Application);
    End Else If var_MenuName = '2500' Then Begin
        Var_SelForm := Tfrm_2500.Create(Application);  
    End Else If var_MenuName = '2700' Then Begin
        Var_SelForm := Tfrm_2700.Create(Application);
    End Else If var_MenuName = '7100' Then Begin
        Var_SelForm := Tfrm_7100.Create(Application);
    End Else If var_MenuName = '8100' Then Begin
        Var_SelForm := Tfrm_8100.Create(Application);
    End;

    if var_SelForm <> Nil then begin
             With TForm(var_SelForm) do begin
                     if var_Modal then ShowModal
                     Else
                     begin     
                    //      FormStyle   := fsStayOnTop;
                          {*
                          Left := 0;
                          Top  := 0;
                          *}
                          Show;
                     End;
             end;
          end;
  End;
  Screen.Cursor := crDefault;
end;

procedure TMainMenu_f.SC1DblClick(Sender: TObject);
var
  IntPos : Integer;
  StrPos : String;
  var_form : TScrcDisp_f;
begin

  IntPos := StrToInt(Copy(TPanel(Sender).Name,3,1));

  StrPos := Format('%1.1d', [IntPos]);
  var_form := TScrcDisp_f.Create(Application);

  var_form.SCEdit.Text := StrPos;
  TForm(var_Form).Show;
end;    

procedure TMainMenu_f.SC2DblClick(Sender: TObject);
var
  IntPos : Integer;
  StrPos : String;
  var_form : TScrcDisp_f;
begin

  IntPos := StrToInt(Copy(TPanel(Sender).Name,3,1));

  StrPos := Format('%1.1d', [IntPos]);
  var_form := TScrcDisp_f.Create(Application);

  var_form.SCEdit.Text := StrPos;
  TForm(var_Form).Show;
end;

procedure TMainMenu_f.SC3DblClick(Sender: TObject);
var 
  IntPos : Integer;
  StrPos : String;
  var_form : TScrcDisp_f;
begin

  IntPos := StrToInt(Copy(TPanel(Sender).Name,3,1));

  StrPos := Format('%1.1d', [IntPos]);
  var_form := TScrcDisp_f.Create(Application);

  var_form.SCEdit.Text := StrPos;
  TForm(var_Form).Show;
end;

procedure TMainMenu_f.Track_Data_Display(Sender: TObject);
var
  ls_pos : String;
  var_SelForm : TTrakDisp_F;
begin
  ls_pos := Copy(TPanel(Sender).Name, 4, 2);
  var_SelForm := TTrakDisp_F.Create(Application);
  var_SelForm.TrakNoEdit.Text := ls_pos;

  TForm(var_SelForm).Show;
end;

procedure TMainMenu_f.ScheQuerySCHE_JOBGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.Value = 'I'  then Text := '입고'
  else if Sender.Value = 'O'  then Text := '출고'

  else Text := '';
end;

procedure TMainMenu_f.link_data_move_proc;
var
  li_x : integer;
begin
  MV_NDATA(@mpa_r_ch01[1], @mps_r_ch01[1], 16);   MV_NDATA(@mpa_r_ch02[1], @mps_r_ch02[1], 16);
  MV_NDATA(@mpa_r_ch03[1], @mps_r_ch03[1], 16);   MV_NDATA(@mpa_r_ch04[1], @mps_r_ch04[1], 16);
  MV_NDATA(@mpa_r_ch05[1], @mps_r_ch05[1], 16);   MV_NDATA(@mpa_r_ch06[1], @mps_r_ch06[1], 16);

  MV_NDATA(@mpa_w_ch01[1], @mps_w_ch01[1], 16);   MV_NDATA(@mpa_w_ch02[1], @mps_w_ch02[1], 16);
  MV_NDATA(@mpa_w_ch03[1], @mps_w_ch03[1], 16);

  for  li_x := 1 to 24 do
  begin
     MV_NDATA(@mpa_plt[li_x], '0', 1);
  end;

  for  li_x := 1 to 8 do
  begin
     mpa_plt[li_x]      :=  mpa_r_ch01[li_x];
     mpa_plt[li_x + 8]  :=  mpa_r_ch03[li_x];
     mpa_plt[li_x + 16] :=  mpa_r_ch05[li_x];
  end;

end;  


procedure TMainMenu_f.Mnu_3000Click(Sender: TObject);
begin
   Mnu_1000Pnl.Visible := False;
   Mnu_2000Pnl.Visible := False;
   Mnu_3000Pnl.Visible := True;
   Mnu_4000Pnl.Visible := False;
   Mnu_5000Pnl.Visible := False;
   Mnu_8000Pnl.Visible := False;
end;

procedure TMainMenu_f.Mnu_4000Click(Sender: TObject);
begin
   Mnu_1000Pnl.Visible := False;
   Mnu_2000Pnl.Visible := False;
   Mnu_3000Pnl.Visible := False;
   Mnu_4000Pnl.Visible := True;
   Mnu_5000Pnl.Visible := False;
   Mnu_8000Pnl.Visible := False;
end;

procedure TMainMenu_f.Mnu_5000Click(Sender: TObject);
begin
   Mnu_1000Pnl.Visible := False;
   Mnu_2000Pnl.Visible := False;
   Mnu_3000Pnl.Visible := False;
   Mnu_4000Pnl.Visible := False;
   Mnu_5000Pnl.Visible := True;
   Mnu_8000Pnl.Visible := False;
end;

procedure TMainMenu_f.Mnu_1000Click(Sender: TObject);
begin
   Mnu_1000Pnl.Visible := True;
   Mnu_2000Pnl.Visible := False;
   Mnu_3000Pnl.Visible := False;
   Mnu_4000Pnl.Visible := False;
   Mnu_5000Pnl.Visible := False;
   Mnu_8000Pnl.Visible := False;
end;

procedure TMainMenu_f.Mnu_2000Click(Sender: TObject);
begin
   Mnu_1000Pnl.Visible := False;
   Mnu_2000Pnl.Visible := True;
   Mnu_3000Pnl.Visible := False;
   Mnu_4000Pnl.Visible := False;
   Mnu_5000Pnl.Visible := False;
   Mnu_8000Pnl.Visible := False;
end;

procedure TMainMenu_f.Mnu_8000Click(Sender: TObject);
begin
  Mnu_1000Pnl.Visible := False;
  Mnu_2000Pnl.Visible := False;
  Mnu_3000Pnl.Visible := False;
  Mnu_4000Pnl.Visible := False;
  Mnu_5000Pnl.Visible := False;
  Mnu_8000Pnl.Visible := True;
end;    

procedure TMainMenu_f.Sc1HomeCmdClick(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Stacker#1 홈복귀를 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select scc1_ch01 from T2tbscc1 (nolock) where scc1_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('scc1_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[15] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2tbscc1 set scc1_ch01 = '''+ps_w_ch01+'''  where scc1_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;

end;

procedure TMainMenu_f.Sc2HomeCmdClick(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Stacker#2 홈복귀를 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select scc2_ch01 from T2tbscc2 (nolock) where scc2_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('scc2_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[15] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2tbscc2 set scc2_ch01 = '''+ps_w_ch01+'''  where scc2_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;

end;

procedure TMainMenu_f.Sc3HomeCmdClick(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Stacker#3 홈복귀를 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select scc3_ch01 from T2tbscc3 (nolock) where scc3_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('scc3_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[15] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2tbscc3 set scc3_ch01 = '''+ps_w_ch01+'''  where scc3_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;

procedure TMainMenu_f.Open01Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#01 Door Open 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc1_ch01 from T2Tbcvc1 (nolock) where cvc1_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc1_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[05] := '1';  pa_w_ch01[06] := '0';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc1 set cvc1_ch01 = '''+ps_w_ch01+'''  where cvc1_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;

procedure TMainMenu_f.Open02Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#02 Door Open 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc1_ch01 from T2Tbcvc1 (nolock) where cvc1_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc1_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[07] := '1';  pa_w_ch01[08] := '0';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc1 set cvc1_ch01 = '''+ps_w_ch01+'''  where cvc1_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;

end;

procedure TMainMenu_f.Open03Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#03 Door Open 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
        UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc2_ch01 from T2Tbcvc2 (nolock) where cvc2_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc2_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[05] := '1';  pa_w_ch01[06] := '0';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc2 set cvc2_ch01 = '''+ps_w_ch01+'''  where cvc2_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;


procedure TMainMenu_f.Close01Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#01 Door Close 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc1_ch01 from T2Tbcvc1 (nolock) where cvc1_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc1_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[05] := '0';  pa_w_ch01[06] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc1 set cvc1_ch01 = '''+ps_w_ch01+'''  where cvc1_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;

end;

procedure TMainMenu_f.Close02Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#02 Door Close 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc1_ch01 from T2Tbcvc1 (nolock) where cvc1_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc1_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[07] := '0';  pa_w_ch01[08] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc1 set cvc1_ch01 = '''+ps_w_ch01+'''  where cvc1_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;

end;

procedure TMainMenu_f.Close03Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#03 Door Close 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc2_ch01 from T2Tbcvc2 (nolock) where cvc2_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc2_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[05] := '0';  pa_w_ch01[06] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc2 set cvc2_ch01 = '''+ps_w_ch01+'''  where cvc2_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;

end;


procedure TMainMenu_f.Open04Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#04 Door Open 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
    try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc2_ch01 from T2Tbcvc2 (nolock) where cvc2_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc2_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[07] := '1';  pa_w_ch01[08] := '0';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc2 set cvc2_ch01 = '''+ps_w_ch01+'''  where cvc2_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;

procedure TMainMenu_f.Close04Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#04 Door Close 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc2_ch01 from T2Tbcvc2 (nolock) where cvc2_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc2_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[07] := '0';  pa_w_ch01[08] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc2 set cvc2_ch01 = '''+ps_w_ch01+'''  where cvc2_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;

procedure TMainMenu_f.Open05Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#05 Door Open 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
    try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc3_ch01 from T2Tbcvc3 (nolock) where cvc3_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc3_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[05] := '1';  pa_w_ch01[06] := '0';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc3 set cvc3_ch01 = '''+ps_w_ch01+'''  where cvc3_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;

procedure TMainMenu_f.Close05Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#05 Door Close 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc3_ch01 from T2Tbcvc3 (nolock) where cvc3_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc3_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[05] := '0';  pa_w_ch01[06] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc3 set cvc3_ch01 = '''+ps_w_ch01+'''  where cvc3_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;

procedure TMainMenu_f.Open06Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#07 Door Open 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
    try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc3_ch01 from T2Tbcvc3 (nolock) where cvc3_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc3_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[07] := '1';  pa_w_ch01[08] := '0';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc3 set cvc3_ch01 = '''+ps_w_ch01+'''  where cvc3_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;

procedure TMainMenu_f.Close06Click(Sender: TObject);
var
    ps_w_ch01: String[16];
    pa_w_ch01: array [1..16] of Char;
    li_i : integer;
begin
   if MessageDlg('Door#06 Door Close 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      try
      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add (' select cvc3_ch01 from T2Tbcvc3 (nolock) where cvc3_sr = ''S'' ');
      UpdtQuery.open;

      ps_w_ch01 := UpdtQuery.FieldByName('cvc3_ch01').AsString;
      MV_NDATA(@pa_w_ch01[1], @ps_w_ch01[1], 16);


      pa_w_ch01[07] := '0';  pa_w_ch01[08] := '1';

      for li_i := 1 to 16 do
      begin
        ps_w_ch01[li_i] := pa_w_ch01[li_i];
      end;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add(' update T2Tbcvc3 set cvc3_ch01 = '''+ps_w_ch01+'''  where cvc3_sr = ''S'' ');
      UpdtQuery.ExecSQL;
    except
        ShowMessage('이미 제어에서 변경 되었습니다.!!');
    end;
  end;
end;

procedure TMainMenu_f.InPnlClick(Sender: TObject);
begin
   Bol_Data_Ok := True;
   Bol_Modal   := False;
   Var_Form    := Nil;

   Frm_3120 := TFrm_3120.Create(Application);
   Bol_Modal := True;

   Frm_3120.Rb1.Checked := True;
   Frm_3120.Rb2.Checked := False;
   Frm_3120.Rb3.Checked := False;
   //Frm_3120.Rb1.Enabled := False;

   TForm(Frm_3120).Show;
end;

procedure TMainMenu_f.Bcr1lampClick(Sender: TObject);
begin
  //
end;

procedure TMainMenu_f.BCR1LblClick(Sender: TObject);
var
  l_bcr1 : String;
begin
  Query3.Close;
  Query3.SQL.clear;
  Query3.SQL.Add (' select STAT_BCR1 from t2TBSTAT (NOLOCK) where stat_pswd = ''JPLS''');
  Query3.open;

  l_bcr1 := Query3.FieldByName('STAT_BCR1').AsString;

  if   l_bcr1 = '1'  then l_bcr1 := '0'   else  l_bcr1 := '1';

  UpdtQuery.Close;
  UpdtQuery.SQL.Clear;
  UpdtQuery.SQL.Add(' update t2TBSTAT set  ');
  UpdtQuery.SQL.Add(' STAT_BCR1 = '''+l_bcr1+'''  ');
  UpdtQuery.SQL.Add(' where stat_pswd = ''JPLS'' ');
  UpdtQuery.ExecSQL;

  StartbitbtnClick(Self)
end;

procedure TMainMenu_f.BCR2LblClick(Sender: TObject);
var
  l_bcr2 : String;
begin
  Query3.Close;
  Query3.SQL.clear;
  Query3.SQL.Add (' select STAT_BCR2 from t2TBSTAT (NOLOCK) where stat_pswd = ''JPLS''');
  Query3.open;

  l_bcr2 := Query3.FieldByName('STAT_BCR2').AsString;

  if   l_bcr2 = '1'  then l_bcr2 := '0'   else  l_bcr2 := '1';

  UpdtQuery.Close;
  UpdtQuery.SQL.Clear;
  UpdtQuery.SQL.Add(' update t2TBSTAT set  ');
  UpdtQuery.SQL.Add(' STAT_BCR2 = '''+l_bcr2+'''  ');
  UpdtQuery.SQL.Add(' where stat_pswd = ''JPLS'' ');
  UpdtQuery.ExecSQL;

  StartbitbtnClick(Self)
end;

procedure TMainMenu_f.BCR3LblClick(Sender: TObject);
var
  l_bcr3 : String;
begin
  Query3.Close;
  Query3.SQL.clear;
  Query3.SQL.Add (' select STAT_BCR3 from t2TBSTAT (NOLOCK) where stat_pswd = ''JPLS''');
  Query3.open;

  l_bcr3 := Query3.FieldByName('STAT_BCR3').AsString;

  if   l_bcr3 = '1'  then l_bcr3 := '0'   else  l_bcr3 := '1';

  UpdtQuery.Close;
  UpdtQuery.SQL.Clear;
  UpdtQuery.SQL.Add(' update t2TBSTAT set  ');
  UpdtQuery.SQL.Add(' STAT_BCR3 = '''+l_bcr3+'''  ');
  UpdtQuery.SQL.Add(' where stat_pswd = ''JPLS'' ');
  UpdtQuery.ExecSQL;

  StartbitbtnClick(Self)
end;

end.

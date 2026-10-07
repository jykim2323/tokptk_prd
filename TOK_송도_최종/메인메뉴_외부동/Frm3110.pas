unit Frm3110;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, ADODB, DB, DBTables,
  Mask, ComCtrls, Com_Var;

type
  TFrm_3110 = class(TForm)
    StockSG: TStringGrid;
    GroupBox2: TGroupBox;
    Panel11: TPanel;
    ExitBitBtn: TSpeedButton;
    Panel1: TPanel;
    Titlepl: TPanel;
    FromDate: TDateTimePicker;
    Label2: TLabel;
    ToDate: TDateTimePicker;
    Label3: TLabel;
    Panel9: TPanel;
    Panel12: TPanel;
    GuNoEdit: TEdit;
    CodeEdit: TEdit;
    ExecSb: TSpeedButton;
    StartBitBtn: TSpeedButton;
    DispQuery: TADOQuery;
    StatQuery: TADOQuery;
    UpdtQuery: TADOQuery;
    ClearSB: TSpeedButton;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject); 
    procedure ExecSbClick(Sender: TObject);       
    procedure StockSGDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);   
    procedure StartBitBtnClick(Sender: TObject);
    procedure StockSGClick(Sender: TObject);
    procedure ClearSBClick(Sender: TObject);
  private
    { Private declarations }  

    procedure Grid_Title;
    procedure Stock_Grid_Clear;    
  public
    { Public declarations }
  end;

var
  Frm_3110: TFrm_3110;

  StrQry : String;   
  StrMsg : String;
  StrDate1, StrDate2: String;
  init_sw : string;

  jjj_code    : Array[1..4] of String;
  jjj_name    : Array[1..4] of String;
  jjj_cpn     : Array[1..4] of String;
  jjj_lotno   : Array[1..4] of String;
  jjj_qty     : Array[1..4] of String;
  jjj_unit    : Array[1..4] of String;
  jjj_pgubn   : Array[1..4] of String;
implementation

uses DBSet, WinLib, FrmPrompt, FrmError, Com_Grid, Frm4300;

{$R *.dfm}


procedure TFrm_3110.FormCreate(Sender: TObject);
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  Grid_Title;   
  FromDate.Date := Now;   ToDate.Date := Now;

  ChkBoxCrt();
end;

procedure TFrm_3110.Grid_Title;
begin
  With StockSG Do Begin
     Cells[1,0] := ' 선택';
     Cells[2,0] := '구매번호';
     Cells[3,0] := '순번';
     Cells[4,0] := '이동유형';
     Cells[5,0] := '자재번호';
     Cells[6,0] := '자재내역';
     Cells[7,0] := '수량 ';
     Cells[8,0] := '평가유형';
     Cells[9,0] := '단위';
     Cells[10,0] := '납품일';
     Cells[11,0] := 'CPN';
     Cells[12,0] := '플랜트';
     Cells[13,0] := '창고';
     Cells[14,0] := '삭제';
     Cells[15,0] := '공급업체';
     Cells[16,0] := '이름';
     Cells[17,0] := '수령인';



     ColWidths[0] := 10;
     ColWidths[1] := 40;
     ColWidths[2] := 80;
     ColWidths[3] := 50;
     ColWidths[4] := 80;
     ColWidths[5] := 80;
     ColWidths[6] := 200;
     ColWidths[7] := 80;
     ColWidths[8] := 80;
     ColWidths[9] := 50;
     ColWidths[10] := 80;
     ColWidths[11] := 80;
     ColWidths[12] := 60;
     ColWidths[13] := 60;
     ColWidths[14] := 60;
     ColWidths[15] := 80;
     ColWidths[16] := 100;
     ColWidths[17] := 100;
  End;
End;

procedure TFrm_3110.Stock_Grid_Clear;
var
  IntCnt : Integer;
begin
  With StockSG Do Begin
    For IntCnt := 1 to RowCount - 1 do Begin
     Cells[1,IntCnt] := '';
     Cells[2,IntCnt] := '';
     Cells[3,IntCnt] := '';
     Cells[4,IntCnt] := '';
     Cells[5,IntCnt] := '';
     Cells[6,IntCnt] := '';
     Cells[7,IntCnt] := '';
     Cells[8,IntCnt] := '';
     Cells[9,IntCnt] := '';
     Cells[10,IntCnt] := '';
     Cells[11,IntCnt] := '';
     Cells[12,IntCnt] := '';
     Cells[13,IntCnt] := '';
     Cells[14,IntCnt] := '';
     Cells[15,IntCnt] := '';
     Cells[16,IntCnt] := '';
     Cells[17,IntCnt] := '';
    End;
  End;
  StockSG.RowCount := 2;
  StockSG.Col := 0;
end;


procedure TFrm_3110.StartBitBtnClick(Sender: TObject);
var
   ls_sql, ls_code, ls_guno : String;
   IntPos : Integer;
begin
  For IntPos := 1 to 4 do
   Begin
     jjj_code[IntPos]   := '';      jjj_name[IntPos]   := '';
     jjj_lotno[IntPos]  := '';   jjj_qty[IntPos]    := '';
     jjj_unit[IntPos]   := '';        jjj_pgubn[IntPos]  := '';
  End;    

  init_sw := '*';

  StrDate1 := FormatDateTime('yyyymmdd', FromDate.Date);
  StrDate2 := FormatDateTime('yyyymmdd', ToDate.Date);

  ls_code  := Trim(CodeEdit.Text);
  ls_guno  := Trim(GuNoEdit.Text);

  ls_sql := '  Select  HH_JPNO, HH_ITEMNO, HH_BWART, HH_EINDT, HH_CODE, MAST_NAME, MAST_CPN,  ';
  ls_Sql := ls_Sql + ' HH_FACT, HH_AREA, HH_PGUBN, HH_QTY, HH_MEINS, HH_LOEKZ, HH_LIFNR,  ';
  ls_Sql := ls_Sql + ' HH_NAME1, HH_WEMPF ';
  ls_Sql := ls_Sql + ' From STK_HHINPT (NOLOCK) ';
  ls_Sql := ls_Sql + ' LEFT OUTER JOIN STK_MIMAST (NOLOCK) ON MAST_CODE = HH_CODE ';
  ls_Sql := ls_Sql + ' Where  HH_JPNO <> '''' ';   
  if ls_code <> ''  then   ls_Sql := ls_Sql + ' And  HH_CODE LIKE '''+ls_code+'%'' ';
  if ls_guno <> ''  then   ls_Sql := ls_Sql + ' And  HH_JPNO LIKE '''+ls_guno+'%'' ';
  if (ls_code = '') And (ls_guno = '') then
  begin
      ls_Sql := ls_Sql + '  And  HH_DATE >= '''+StrDate1+''' And HH_DATE <= '''+StrDate2+''' ';
  end;               
  ls_Sql := ls_Sql + ' Order By HH_JPNO, HH_ITEMNO ';

  Stock_Grid_Clear;

  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    if RecordCount = 0 Then Begin
      StrMsg := ' 입고지시가  없습니다...... ';
      WinLib_ErrorForm( StrMsg );     Exit;
    End;

    if RecordCount = 0 then StockSG.RowCount := 2 else StockSG.RowCount := RecordCount + 1;
    IntPos := 1;
    While Not Eof Do Begin
      StockSG.Cells[1, IntPos] := '';
      StockSG.Cells[2, IntPos] := FieldByName('HH_JPNO').AsString;
      StockSG.Cells[3, IntPos] := FieldByName('HH_ITEMNO').AsString;
      StockSG.Cells[4, IntPos] := FieldByName('HH_BWART').AsString;
      StockSG.Cells[5, IntPos] := FieldByName('HH_CODE').AsString;
      StockSG.Cells[6, IntPos] := FieldByName('MAST_NAME').AsString;
      StockSG.Cells[7, IntPos] := FormatFloat('#,##0', FieldByName('HH_QTY').AsFloat);
      StockSG.Cells[8, IntPos] := FieldByName('HH_PGUBN').AsString;
      StockSG.Cells[9, IntPos] := FieldByName('HH_MEINS').AsString;
      StockSG.Cells[10, IntPos] := FieldByName('HH_EINDT').AsString;
      StockSG.Cells[11, IntPos] := FieldByName('MAST_CPN').AsString;
      StockSG.Cells[12, IntPos] := FieldByName('HH_FACT').AsString;
      StockSG.Cells[13, IntPos] := FieldByName('HH_AREA').AsString;
      StockSG.Cells[14, IntPos] := FieldByName('HH_LOEKZ').AsString;
      StockSG.Cells[15, IntPos] := FieldByName('HH_LIFNR').AsString;
      StockSG.Cells[16, IntPos] := FieldByName('HH_NAME1').AsString;
      StockSG.Cells[17, IntPos] := FieldByName('HH_WEMPF').AsString;
      Inc(IntPos);
      Next;
    End;
  End;            // End of With
end;



procedure TFrm_3110.ExecSbClick(Sender: TObject);
Var
    bCheck : Boolean;
    iRow, i : Integer;
begin
   i := 0;


   StrMsg := ' 입고제품을 확정 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin  Exit;    End;

   With StockSG Do Begin
       For iRow := 1 To RowCount - 1 Do Begin
          bCheck:= Get_Chkbox(StockSG, 1, iRow);
          If Not bCheck Then Continue;

          inc(i);
          jjj_code[i]  :=  StockSG.Cells[3, iRow];
          jjj_name[i]  :=  StockSG.Cells[4, iRow];
          jjj_qty[i]   :=  StockSG.Cells[5, iRow];
          jjj_lotno[i] :=  StockSG.Cells[7, iRow];
          jjj_pgubn[i] :=  StockSG.Cells[8, iRow];
          jjj_cpn[i]   :=  StockSG.Cells[10, iRow];
          jjj_unit[i]  :=  StockSG.Cells[11, iRow];
       End;
    End;
    
   Close;
end;


procedure TFrm_3110.StockSGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  LeftPos: Integer;
  CellStr: string;
begin
  with TStringGrid(Sender).Canvas do
  begin
    CellStr := TStringGrid(Sender).Cells[ACol, ARow];

    IF ARow = 0 Then Begin
      if ACol > 0 Then Begin
        LeftPos := ((Rect.Right-Rect.Left-TStringGrid(Sender).Canvas.TextWidth(CellStr)) div 2) + Rect.Left;  // 가운데 정렬
        With TStringGrid(Sender).Canvas.Font Do Begin
          Brush.Color := clTeal;
          Font.Color  := clWhite;
          Style := [fsBold];
        End;
        FillRect(Rect);
        TextOut(LeftPos, Rect.Top+5, CellStr);
      End;
    End;
    IF ARow > 0 Then Begin
      if (ACol = 7) Then Begin
        LeftPos := (Rect.Right-Rect.Left-TStringGrid(Sender).Canvas.TextWidth(CellStr)) + Rect.Left;  // 오른쪽 정렬
        FillRect(Rect);
        TextOut(LeftPos, Rect.Top+5, CellStr);
      End;
      if (ACol > 7) Then Begin
        LeftPos := ((Rect.Right-Rect.Left-TStringGrid(Sender).Canvas.TextWidth(CellStr)) div 2) + Rect.Left;  // 가운데
        FillRect(Rect);
        TextOut(LeftPos, Rect.Top+5, CellStr);
      End;
    End;
  End;

  ChkBoxShow(Sender,ACol, ARow,Rect, State, 1 );
 
end;


procedure TFrm_3110.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_3110.FormDestroy(Sender: TObject);
begin
  Frm_4300 := Nil;
end;

procedure TFrm_3110.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  ChkBoxFree();
  Action := caFree;
end;

procedure TFrm_3110.StockSGClick(Sender: TObject);
begin

  if  (init_sw = '*') then begin  init_sw := '';  Exit;   end;

  ChkBoxOnOff(Sender,1);
//  ChkBoxOn(Sender, 1, StockSg.Row) ;   
end;


procedure TFrm_3110.ClearSBClick(Sender: TObject);
Var
    bCheck : Boolean;
    iRow, i : Integer;
begin
    With StockSG Do Begin
       For iRow := 1 To RowCount - 1 Do Begin
          bCheck:= Get_Chkbox(StockSG, 1, iRow);
          If Not bCheck Then Continue;
          if Assigned( Objects[1, iRow] ) then  Objects[1, iRow] := Nil;
       End;
    End;   
end;

end.

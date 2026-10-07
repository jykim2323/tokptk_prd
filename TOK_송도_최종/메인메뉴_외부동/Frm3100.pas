unit Frm3100;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, DB, ADODB, Buttons, Mask, IniFiles,
  QRCtrls, QuickRpt, MMsystem;

type
  TStringArray = array of string;
  TFrm_3100 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    ConfirmPnl: TPanel;
    Panel2: TPanel;
    Panel7: TPanel;
    ReservedSB: TSpeedButton;
    WeightEdit: TEdit;
    Panel10: TPanel;
    NameEdit: TEdit;
    Panel4: TPanel;
    Query2: TADOQuery;
    UpdtQuery: TADOQuery;
    ItnbrEdit: TEdit;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    StartBitBtn: TSpeedButton;
    Titlepl: TPanel;
    DBGrid1: TDBGrid;
    ConfirmBtn: TSpeedButton;
    CancelSB: TSpeedButton;
    Panel5: TPanel;
    LotnoEdit: TEdit;
    Query1: TADOQuery;
    RecNoEdit: TEdit;
    itemEdit: TEdit;
    Query1MAST_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1MAST_UNIT: TStringField;
    Query1MAST_WEIGHT: TBCDField;
    Query1MAST_DATE: TDateTimeField;
    Panel45: TPanel;
    Panel47: TPanel;
    Panel49: TPanel;
    Em1lv1Pnl: TPanel;
    Em1lv2Pnl: TPanel;
    Em1lv3Pnl: TPanel;
    Panel3: TPanel;
    Em2lv3Pnl: TPanel;
    Em2lv2Pnl: TPanel;
    Em2lv1Pnl: TPanel;
    Panel11: TPanel;
    Em3lv3Pnl: TPanel;
    Em3lv2Pnl: TPanel;
    Em3lv1Pnl: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    BigoEdit: TEdit;
    Panel9: TPanel;
    Em1lv6Pnl: TPanel;
    Em2lv6Pnl: TPanel;
    Em3lv6Pnl: TPanel;
    Panel17: TPanel;
    Em1lv5Pnl: TPanel;
    Em2lv5Pnl: TPanel;
    Em3lv5Pnl: TPanel;
    Panel21: TPanel;
    Em1lv4Pnl: TPanel;
    Em2lv4Pnl: TPanel;
    Em3lv4Pnl: TPanel;
    Panel25: TPanel;
    Em1lv9Pnl: TPanel;
    Em2lv9Pnl: TPanel;
    Em3lv9Pnl: TPanel;
    Panel29: TPanel;
    Em1lv8Pnl: TPanel;
    Em2lv8Pnl: TPanel;
    Em3lv8Pnl: TPanel;
    Panel33: TPanel;
    Em1lv7Pnl: TPanel;
    Em2lv7Pnl: TPanel;
    Em3lv7Pnl: TPanel;
    BcrEdit: TEdit;
    Label14: TLabel;
    DataSource1: TDataSource;
    Panel16: TPanel;
    Panel8: TPanel;
    BoxNoEdit: TEdit;
    InResGrid: TStringGrid;
    Query1MAST_GUBN1: TStringField;
    Query1MAST_GUBN2: TStringField;
    Query1MAST_GUBN3: TStringField;
    Query1MAST_BCODE: TStringField;
    Query1GUBN1_NAME: TStringField;
    Query1GUBN2_NAME: TStringField;
    Query1GUBN3_NAME: TStringField;
    Panel19: TPanel;
    pltnoEdit: TEdit;
    t2SubkQry: TADOQuery;
    pltnoSrcEdit: TEdit;
    Label3: TLabel;
    delGrid: TStringGrid;
    ChkQuery: TADOQuery;
    Panel14: TPanel;
    itemNmEdit: TEdit;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);  
    procedure ConfirmBtnClick(Sender: TObject);
    procedure ReservedSBClick(Sender: TObject);
    procedure DataGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure CancelSBClick(Sender: TObject);
   
    procedure StartBitBtnClick(Sender: TObject);   
    procedure ItnbrEditKeyPress(Sender: TObject; var Key: Char); 
    procedure WeightEditChange(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure MouseWheelHandler(var Message: TMessage); override;

 
    
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure BcrEditKeyPress(Sender: TObject; var Key: Char);
    procedure pltnoEditKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure pltnoSrcEditKeyPress(Sender: TObject; var Key: Char);
    procedure WeightEditKeyPress(Sender: TObject; var Key: Char);
    procedure BoxNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure itemEditKeyPress(Sender: TObject; var Key: Char);
    procedure itemNmEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure InResGrid_Clear_Proc;
    procedure delGrid_Clear_Proc;
    procedure Check_Plt_Lock(sPltNo: String);
    function IsNumCheck(var StrData : String): Boolean;
    function f_get_sysdate_time1(): String;
    function SplitString(const fullString: string; const Delimiter: Char): TStringArray;

  public
    { Public declarations }
  end;
  
var
  Frm_3100: TFrm_3100;

  Var_Form : TForm;
  Read_ok : Boolean;
  Bol_Data_Ok : Boolean;

  StrQry : String;
  StrMsg : String;
  StrDate1, StrDate2: String;    
  StrItemCode, Ps_Bcr : String;
  sys_datetime : String;

  s_wsno, s_floor, s_high, StrItnbr,  StrLotno, StrCode, s_From : String;
implementation

uses DBSet, WinLib, FrmPrompt, FrmError, Winsock, FrmProgress;
                                                                                                 
{$R *.dfm}

function TFrm_3100.IsNumCheck(var StrData: String): Boolean;
var
  IntPos : Integer;
begin
  Result := True;
  for IntPos := 1 to Length(StrData) Do Begin
    If not (StrData[intPos] in [',', '.', '0'..'9']) Then Begin
       Result := False;
       Exit;
    End;
  End;
end; 

procedure TFrm_3100.FormCreate(Sender: TObject);
var
 li_i : integer;
begin
//   Top  := (Screen.Height - Self.Height) div 2;
//   Left := (Screen.Width - Self.Width) div 2;

  if (jj_kind <> '50') then
  begin
    ReservedSB.Visible    := False;
  end;
   InResGrid_Clear_Proc;
   delGrid_Clear_Proc;
   StartBitBtnClick(Self);
end;

procedure TFrm_3100.InResGrid_Clear_Proc;
var
  IntCnt : Integer;
begin

   InResGrid.Cells[1,0]  := 'PLT-NO';
   InResGrid.Cells[2,0]  := '제품코드';
   InResGrid.Cells[3,0]  := '제 품 명';
   InResGrid.Cells[4,0]  := 'LOT-NO';
   InResGrid.Cells[5,0]  := '적재중량';
   InResGrid.Cells[6,0]  := 'BOX NO';
   InResGrid.Cells[7,0]  := '비  고';
   InResGrid.Cells[8,0]  := '신규구분';


   InResGrid.ColWidths[0] := 4;
   InResGrid.ColWidths[1] := 100;
   InResGrid.ColWidths[2] := 100;
   InResGrid.ColWidths[3] := 200;
   InResGrid.ColWidths[4] := 150;
   InResGrid.ColWidths[5] := 80;
   InResGrid.ColWidths[6] := 100;
   InResGrid.ColWidths[7] := 200;
   InResGrid.ColWidths[8] := 0;
   InResGrid.ColWidths[9] := 0;

   InResGrid.RowCount := 2;

  With InResGrid Do Begin
    For IntCnt := 1 to RowCount - 1 do Begin
     Cells[1,IntCnt]  := '';
     Cells[2,IntCnt]  := '';
     Cells[3,IntCnt]  := '';
     Cells[4,IntCnt]  := '';
     Cells[5,IntCnt]  := '';
     Cells[6,IntCnt]  := '';
     Cells[7,IntCnt]  := '';
     Cells[8,IntCnt]  := '';
     Cells[9,IntCnt]  := '';
    End;
  End;
  InResGrid.RowCount := 2;
end;

procedure TFrm_3100.delGrid_Clear_Proc;
var
  IntCnt : Integer;
begin

   delGrid.Cells[1,0]  := 'PLT-NO';
   delGrid.Cells[2,0]  := '제품코드';
   delGrid.Cells[3,0]  := '제 품 명';
   delGrid.Cells[4,0]  := 'LOT-NO';
   delGrid.Cells[5,0]  := '적재중량';
   delGrid.Cells[6,0]  := 'BOX NO';
   delGrid.Cells[7,0]  := '비  고';
   delGrid.Cells[8,0]  := '신규구분';


   delGrid.ColWidths[0] := 4;
   delGrid.ColWidths[1] := 100;
   delGrid.ColWidths[2] := 100;
   delGrid.ColWidths[3] := 200;
   delGrid.ColWidths[4] := 150;
   delGrid.ColWidths[5] := 80;
   delGrid.ColWidths[6] := 100;
   delGrid.ColWidths[7] := 200;
   delGrid.ColWidths[8] := 80;
   delGrid.ColWidths[9] := 80;

   delGrid.RowCount := 2;

  With delGrid Do Begin
    For IntCnt := 1 to RowCount - 1 do Begin
     Cells[1,IntCnt]  := '';
     Cells[2,IntCnt]  := '';
     Cells[3,IntCnt]  := '';
     Cells[4,IntCnt]  := '';
     Cells[5,IntCnt]  := '';
     Cells[6,IntCnt]  := '';
     Cells[7,IntCnt]  := '';
     Cells[8,IntCnt]  := '';
     Cells[9,IntCnt]  := '';
    End;
  End;
  delGrid.RowCount := 2;
end;

procedure TFrm_3100.StartBitBtnClick(Sender: TObject);
var
  StrCode, ls_sql : string;
  li_stok1  : Array[1..9] of Integer;
  li_stok2  : Array[1..9] of Integer;
  li_stok3  : Array[1..9] of Integer;
  ls_lv, ls_bk : string;
  li_i, li_cnt : Integer;

begin
  StrCode := Trim(itemEdit.Text);

  ls_sql := ' Select MAST_CODE, MAST_BCODE,MAST_NAME, MAST_UNIT, MAST_WEIGHT, MAST_GUBN1,  GUBN1_NAME, ';
  ls_sql := ls_sql + ' MAST_GUBN2, GUBN2_NAME, MAST_GUBN3, GUBN3_NAME, MAST_DATE From MIMAST ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1   ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2   ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3   ';
  ls_sql := ls_sql + ' WHERE 1=1 ';
  
  if Length(StrCode) > 0 then
    ls_sql := ls_sql + ' AND MAST_CODE = '''+StrCode+''' ';
    
  if Length(Trim(itemNmEdit.Text)) > 0 then
    ls_sql := ls_sql + ' AND MAST_NAME like ''%'+Trim(itemNmEdit.Text)+'%'' ';
    
  ls_sql := ls_sql + ' Order By  MAST_CODE  ';
  
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(ls_sql);
  Query1.Open;
  Query1.First;
  
  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);


   For li_i := 1 to  9 do Begin  li_stok1[li_i] := 0; li_stok2[li_i] := 0; li_stok3[li_i] := 0; end;

  ls_sql := ' Select  LSTK_LV, LSTK_BK, Count(*) As Cnt From T2MILSTK (NOLOCK) ';
  ls_sql := ls_sql + '  Where  LSTK_FLAG = ''0'' ';
  ls_sql := ls_sql + '  GROUP BY LSTK_LV, LSTK_BK  ';
  ls_sql := ls_sql + '  ORDER BY LSTK_LV, LSTK_BK ';
  With Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    While Not Eof Do Begin
      ls_lv  := FieldByName('LSTK_LV').AsString;
      ls_bk  := FieldByName('LSTK_BK').AsString;
      li_cnt := FieldByName('Cnt').AsInteger;

      if (ls_lv = '1') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[1] :=  li_stok1[1] + li_cnt;
      if (ls_lv = '2') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[2] :=  li_stok1[2] + li_cnt;
      if (ls_lv = '3') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[3] :=  li_stok1[3] + li_cnt;
      if (ls_lv = '4') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[4] :=  li_stok1[4] + li_cnt;
      if (ls_lv = '5') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[5] :=  li_stok1[5] + li_cnt;
      if (ls_lv = '6') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[6] :=  li_stok1[6] + li_cnt;
      if (ls_lv = '7') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[7] :=  li_stok1[7] + li_cnt;
      if (ls_lv = '8') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[8] :=  li_stok1[8] + li_cnt;
      if (ls_lv = '9') And ((ls_bk = '1') or (ls_bk = '2')) then  li_stok1[9] :=  li_stok1[9] + li_cnt;

      if (ls_lv = '1') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[1] :=  li_stok2[1] + li_cnt;
      if (ls_lv = '2') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[2] :=  li_stok2[2] + li_cnt;
      if (ls_lv = '3') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[3] :=  li_stok2[3] + li_cnt;
      if (ls_lv = '4') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[4] :=  li_stok2[4] + li_cnt;
      if (ls_lv = '5') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[5] :=  li_stok2[5] + li_cnt;
      if (ls_lv = '6') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[6] :=  li_stok2[6] + li_cnt;
      if (ls_lv = '7') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[7] :=  li_stok2[7] + li_cnt;
      if (ls_lv = '8') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[8] :=  li_stok2[8] + li_cnt;
      if (ls_lv = '9') And ((ls_bk = '3') or (ls_bk = '4')) then  li_stok2[9] :=  li_stok2[9] + li_cnt;

      if (ls_lv = '1') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[1] :=  li_stok3[1] + li_cnt;
      if (ls_lv = '2') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[2] :=  li_stok3[2] + li_cnt;
      if (ls_lv = '3') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[3] :=  li_stok3[3] + li_cnt;
      if (ls_lv = '4') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[4] :=  li_stok3[4] + li_cnt;
      if (ls_lv = '5') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[5] :=  li_stok3[5] + li_cnt;
      if (ls_lv = '6') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[6] :=  li_stok3[6] + li_cnt;
      if (ls_lv = '7') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[7] :=  li_stok3[7] + li_cnt;
      if (ls_lv = '8') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[8] :=  li_stok3[8] + li_cnt;
      if (ls_lv = '9') And ((ls_bk = '5') or (ls_bk = '6')) then  li_stok3[9] :=  li_stok3[9] + li_cnt;

      Next;
    End;
  End;

  Em1lv1Pnl.Caption := IntToStr(li_stok1[1]);   Em1lv2Pnl.Caption := IntToStr(li_stok1[2]); Em1lv3Pnl.Caption := IntToStr(li_stok1[3]);
  Em1lv4Pnl.Caption := IntToStr(li_stok1[4]);   Em1lv5Pnl.Caption := IntToStr(li_stok1[5]); Em1lv6Pnl.Caption := IntToStr(li_stok1[6]);
  Em1lv7Pnl.Caption := IntToStr(li_stok1[7]);   Em1lv8Pnl.Caption := IntToStr(li_stok1[8]); Em1lv9Pnl.Caption := IntToStr(li_stok1[9]);

  Em2lv1Pnl.Caption := IntToStr(li_stok2[1]);   Em2lv2Pnl.Caption := IntToStr(li_stok2[2]); Em2lv3Pnl.Caption := IntToStr(li_stok2[3]);
  Em2lv4Pnl.Caption := IntToStr(li_stok2[4]);   Em2lv5Pnl.Caption := IntToStr(li_stok2[5]); Em2lv6Pnl.Caption := IntToStr(li_stok2[6]);
  Em2lv7Pnl.Caption := IntToStr(li_stok2[7]);   Em2lv8Pnl.Caption := IntToStr(li_stok2[8]); Em2lv9Pnl.Caption := IntToStr(li_stok2[9]);

  Em3lv1Pnl.Caption := IntToStr(li_stok3[1]);   Em3lv2Pnl.Caption := IntToStr(li_stok3[2]); Em3lv3Pnl.Caption := IntToStr(li_stok3[3]);
  Em3lv4Pnl.Caption := IntToStr(li_stok3[4]);   Em3lv5Pnl.Caption := IntToStr(li_stok3[5]); Em3lv6Pnl.Caption := IntToStr(li_stok3[6]);
  Em3lv7Pnl.Caption := IntToStr(li_stok3[7]);   Em3lv8Pnl.Caption := IntToStr(li_stok3[8]); Em3lv9Pnl.Caption := IntToStr(li_stok3[9]);

end;


procedure TFrm_3100.DBGrid1CellClick(Column: TColumn);
begin
   ItnbrEdit.Text   := Query1.FieldByName('MAST_CODE').AsString;
   NameEdit.Text    := Query1.FieldByName('MAST_NAME').AsString;
//   WeightEdit.Text  := Query1.FieldByName('MAST_WEIGHT').AsString;
   WeightEdit.Text  := ''; 
   WeightEdit.SetFocus;
end;


procedure TFrm_3100.ItnbrEditKeyPress(Sender: TObject; var Key: Char);
var
   StrQry : String;
begin
   if key <> #13 Then Exit;
   Read_ok := False;
   //ConfirmBtnClick(Self);

   StrQry := 'SELECT  * From  MIMAST (NOLOCK) WHERE MAST_CODE = '''+itnbrEdit.Text+''' ';
   With Query2 Do
   Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      Open;
      First;

      if RecordCount = 0  then
      begin
        Bol_Data_Ok := False;
        StrMsg := ' 품목 마스터에 코드가 없읍니다..' + #13#10 + ' 확인한 후 다시 하십시요!!!';
        WinLib_ErrorForm( StrMsg );
        ItnbrEdit.Text := '';
        ItnbrEdit.SetFocus;
        Exit;
      end;
      ItnbrEdit.Text   := FieldByName('MAST_CODE').AsString;
      NameEdit.Text    := FieldByName('MAST_NAME').AsString;
      //WeightEdit.Text  := FieldByName('MAST_WEIGHT').AsString;
      //WeightEdit.Text  := '';
      //WeightEdit.SetFocus;
      BoxNoEdit.SetFocus;
  end;

   BoxNoEdit.SetFocus;
end; 

procedure TFrm_3100.WeightEditChange(Sender: TObject);
var
  StrBQty, StrQry : String;
  NumQty, NumWgt : Real;
begin
  StrBQty := WeightEdit.Text;

  if Length(StrBQty) = 0  then  Exit;

  if IsNumCheck(StrBQty) = False then
  Begin
    StrMsg := '숫자를 Key-in 하세요....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  While Pos(',', StrBQty) > 0 Do Begin Delete(StrBQty, Pos(',', StrBQty), 1); End;


  NumQty := StrToFloat(StrBQty);

  if NumQty = 0 Then
  Begin
    StrMsg := '입고 작업할  중량이 없습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;    
end;

procedure TFrm_3100.ConfirmBtnClick(Sender: TObject);
var
  IntPos, IntRow : Integer;
  StrBQty : String;
  NumQty : Real;
  StrPltNo, StrLotno, StrItnbr, StrBoxNo : String;
begin
  Bol_Data_Ok := True;

  // 기본 입력값 유효성 검사 =================================================
  If Length(Trim(pltnoEdit.Text)) = 0 Then
  Begin
    StrMsg := ' PLT-NO가 없습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  If Length(Trim(ItnbrEdit.Text)) = 0  Then
  Begin
    StrMsg := ' 품목코드가 없습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  {
  If Length(Trim(LotnoEdit.Text)) = 0 Then
  Begin
    StrMsg := ' LOT-NO가 없습니다.... ';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;
  }
  
  StrPltNo := Trim(pltnoEdit.Text);
  StrItnbr := Trim(ItNbrEdit.Text);
  StrLotno := Trim(LotnoEdit.Text);
  StrBoxNo := Trim(BoxNoEdit.Text);

  // 마스터 코드 확인 =======================================================
  StrQry := 'SELECT  * From  MIMAST  (NOLOCK) WHERE MAST_CODE = '''+StrItnbr+''' ';
   With Query2 Do
   Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      Open;
      First;
      if RecordCount = 0  then
      begin
        StrMsg := ' 품목 마스터에 없는 코드입니다..' + #13#10 + ' 확인한 후 다시 하십시요!!!';
        WinLib_ErrorForm( StrMsg );
        Exit;
      end;
      ItnbrEdit.Text     := FieldByName('MAST_CODE').AsString;
      NameEdit.Text      := FieldByName('MAST_NAME').AsString;
  end;

  // 중량 확인 ==============================================================
  If Length(Trim(WeightEdit.Text)) = 0  Then
  begin
    StrMsg := ' 중량 확인....' + #13#10 + ' 선택한 후 다시 하십시요!!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  end;

  StrBQty := WeightEdit.Text;
  While Pos(',', StrBQty) > 0 Do Begin Delete(StrBQty, Pos(',', StrBQty), 1); End;

  NumQty := StrToFloat(StrBQty);

  if NumQty = 0 Then
  Begin
    StrMsg := '입고 작업할  중량이 없습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;


  // [추가됨] DB 허용 범위(numeric 7,2) 초과 검사
  // 정수 5자리 + 소수 2자리 = 최대 99999.99
if NumQty > 99999.991 Then
  Begin
    StrMsg := '입력 가능한 중량 범위를 초과했습니다.' + #13#10 + 
              '(최대 허용값: 99,999.99)';
    WinLib_ErrorForm( StrMsg );
    WeightEdit.SetFocus;
    Exit;
  End;


  // 중복 키값 체크 - (PLTNO, MAST_CODE, LOT)  
  Bol_Data_Ok := True;

  for IntRow := 1 to InResGrid.RowCount - 1 Do
  begin
    // 빈 행은 건너뜀
    if Trim(InResGrid.Cells[1, IntRow]) = '' then Continue;

    // PLTNO + 품목코드 + LOT 세 가지가 같으면 중복으로 처리
    If (Trim(InResGrid.Cells[1,IntRow]) = StrPltNo) And  // PLTNO 비교
       (Trim(InResGrid.Cells[2,IntRow]) = StrItnbr) And  // Code 비교
       (Trim(InResGrid.Cells[4,IntRow]) = StrLotno) Then // Lot 비교
    begin
       Bol_Data_Ok := False;
       Break;
    end;
  end;

  If Not Bol_Data_Ok Then Begin
    StrMsg := '해당 파레트에 동일한 품목코드,LOTNO 가 존재합니다.'+ #13#10 +
              '[PLT-NO]: ' + StrPltNo + '   [품목코드]: ' + StrItnbr + '   [LOT-NO]: ' + StrLotno;
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;


  // 5. Grid에 추가 ============================================================
  Numqty := StrToFloat(WeightEdit.Text);
   
  IntPos := InResGrid.RowCount;
  IF InResGrid.Cells[1, IntPos - 1]  <> '' then IntPos := IntPos + 1;

  InResGrid.RowCount := IntPos;

  InResGrid.Cells[1, IntPos - 1]  := StrPltNo;
  InResGrid.Cells[2, IntPos - 1]  := StrItnbr;
  InResGrid.Cells[3, IntPos - 1]  := NameEdit.text;
  InResGrid.Cells[4, IntPos - 1]  := StrLotno;
  InResGrid.Cells[5, IntPos - 1]  := FormatFloat('#,##0.00', NumQty);
  InResGrid.Cells[6, IntPos - 1]  := StrBoxNo;
  InResGrid.Cells[7, IntPos - 1]  := BigoEdit.Text;
  InResGrid.Cells[8, IntPos - 1]  := '2'; // 신규 추가 상태값

  // 6. 초기화 및 포커스 이동
  ItnbrEdit.Text    := '';
  NameEdit.Text     := '';
  LotnoEdit.Text    := '';
  WeightEdit.Text   := '';
  BoxNoEdit.Text    := '';
  BigoEdit.Text     := '';
  
  //ItnbrEdit.SetFocus;
  BcrEdit.SetFocus;
end;

procedure TFrm_3100.ReservedSBClick(Sender: TObject);
var
  IntPos : Integer;
  StrQty,  var_Sql : String;
  StrDate, StrTime, Strloca, s_gubun, StrRemark, StrBoxNo, StrPltNo : String;
  ls_gubun, ls_iseq, ls_pltno, ls_sql  : String;
  ls_code, ls_lot : String;
  Empty_Cnt, li_cnt : Integer;
  IsGridEmpty : Boolean; // 그리드가 비었는지 확인하는 플래그(True : 해당 PLT 삭제 , False : 부분 저장, 삭제) 
begin
  /// 프로세스 정리 
  ///  1. T2MISUBK INSERT  SUBK_FLAG  등록시 0,   입고 예약 X , 출고 예약 Y , 이동중 M , 재고 1, 재입고 R
  ///                          SUBK_GUBUN 등록시 '',  초기 상태 '',  불량 'Y'  정상 'N' (SFrm6120. Insert_Code)

  Empty_Cnt := 0;
  IsGridEmpty := True;

  ls_pltno := '';

  for IntPos := 1 to InResGrid.RowCount - 1 do
  begin
    if Trim(InResGrid.Cells[1, IntPos]) <> '' then
    begin
      ls_pltno := Trim(InResGrid.Cells[1, IntPos]);
      IsGridEmpty := False; // 데이터가 있음
      Break;
    end;
  end;

  // InresGrid가 비어있다면 입력창(pltnoEdit)에서 가져오기 (전체 삭제를 위함.)
  if IsGridEmpty then
  begin
    ls_pltno := Trim(pltnoEdit.Text);
  end;

  if ls_pltno = '' then
  begin
    WinLib_ErrorForm('작업할 PLT-NO가 지정되지 않았습니다.'#13#10'조회 후 다시 시도하세요!');
    Exit;
  end;

  // Grid 내 데이터가 있다면 동일 PLT-NO 검사
  if not IsGridEmpty then
  begin
    for IntPos := 1 to InResGrid.RowCount - 1 do
    begin
      if Trim(InResGrid.Cells[1, IntPos]) = '' then Break;
      if Trim(InResGrid.Cells[1, IntPos]) <> ls_pltno then
      begin
        WinLib_ErrorForm('하나의 작업에는 동일한 PLT-NO만 등록할 수 있습니다.'#13#10+
                         'Grid의 PLT-NO를 확인해 주세요.');
        Exit;
      end;
    end;  
  end;

  // T2TBTRAK 확인
  ls_sql := 'SELECT COUNT(*) AS CNT FROM T2TBTRAK WITH (NOLOCK) ' +
            ' WHERE TRAK_PLTNO = ''' + ls_pltno + ''' ';
  with ChkQuery do
  begin
    Close; SQL.Clear; SQL.Add(ls_sql); Open;
    li_cnt := Fields[0].AsInteger;
  end;
  if li_cnt > 0 then begin WinLib_ErrorForm('해당 PLT-NO는 현재 입/출고 작업이 진행 중입니다.'); Exit; end;  

  // T2MILSTK 확인
  ls_sql := 'SELECT COUNT(*) AS CNT FROM T2MILSTK WITH (NOLOCK) ' +
            ' WHERE LSTK_PLTNO = ''' + ls_pltno + ''' ';
  with ChkQuery do
  begin
    Close; SQL.Clear; SQL.Add(ls_sql); Open;
    li_cnt := Fields[0].AsInteger;
  end;
  if li_cnt > 0 then begin WinLib_ErrorForm('해당 PLT-NO는 이미 재고에 등록된 팔레트입니다.'); Exit; end;


  if IsGridEmpty then
  begin
    // =========================================================================
    // 그리드가 비어있으면 PLTNO 삭제
    // =========================================================================
    
    ls_sql := 'SELECT COUNT(*) FROM T2MISUBK WITH (NOLOCK) WHERE SUBK_PLTNO = '''+ls_pltno+''' ';
    with ChkQuery do
    begin
      Close; SQL.Clear; SQL.Add(ls_sql); Open;
      li_cnt := Fields[0].AsInteger;
    end;

    if li_cnt = 0 then
    begin
      WinLib_ErrorForm('저장할 데이터가 없습니다.'); 
      Exit;
    end;

    StrMsg := '해당 [' + ls_pltno + '] 파레트의 데이터를 삭제하시겠습니까?';
    if Not WinLib_ConfirmForm( StrMsg ) then Exit;

    ls_sql := ' DELETE FROM T2MISUBK WHERE SUBK_PLTNO = ''' + ls_pltno + ''' ';
    Try 
      With UpdtQuery Do Begin
        Close; SQL.Clear; SQL.Add(ls_sql); ExecSql;
      End;
      MessageDlg('PLT 삭제가 완료되었습니다.', mtInformation, [mbOk], 0);
    Except
       Showmessage('Delete Error'); Exit;
    End;
  end
  else
  begin

    StrMsg := ls_pltno + ' 제품을 입고 등록(저장) 하시겠습니까?...';
    if Not WinLib_ConfirmForm( StrMsg ) then Exit;

    sys_datetime  :=  f_get_sysdate_time1();
    StrDate       :=  copy(sys_datetime, 1, 8);
    StrTime       :=  copy(sys_datetime, 9, 6);

    // 삭제 처리 (delGrid에 있는 것들 삭제)
    If delGrid.RowCount > 1 then
    Begin
      For IntPos := 1 To delGrid.RowCount - 1 Do Begin
        With delGrid Do Begin
          if Cells[1, IntPos] = '' then Break;

          StrPltNo  := delGrid.Cells[1, IntPos];
          StrItnbr  := delGrid.Cells[2, IntPos];
          StrLotno  := delGrid.Cells[4, IntPos];

          StrQry := ' DELETE FROM T2MISUBK ';
          StrQry := StrQry + ' WHERE SUBK_PLTNO = '''+StrPltNo+''' AND SUBK_CODE = '''+StrItnbr+''' AND SUBK_LOTNO = '''+StrLotno+''' ';

          Try 
            With UpdtQuery Do Begin
              Close; SQL.Clear; SQL.Add(StrQry); ExecSql;
            End;
          Except
            Showmessage('Delete Error = ' + StrQry); Exit;
          End;
        end;
      end;
    End;

    // 신규/수정 처리
    For IntPos := 1 To InResGrid.RowCount - 1 Do Begin
      With InResGrid Do Begin
        If InResGrid.Cells[1, IntPos] = '' Then Break;
        
        If InResGrid.Cells[8, IntPos] = '2' Then // 신규추가만 Insert
        Begin
          StrPltNo   := InResGrid.Cells[1, IntPos];
          StrItnbr  := InResGrid.Cells[2, IntPos];
          StrLotno  := InResGrid.Cells[4, IntPos];
          StrQty    := InResGrid.Cells[5, IntPos];
          StrBoxNo  := InResGrid.Cells[6, IntPos];
          StrRemark := InResGrid.Cells[7, IntPos];

          While Pos(',', StrQty) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;

          StrQry := ' INSERT INTO T2MISUBK (SUBK_CODE, SUBK_LOTNO, SUBK_FLAG, SUBK_GUBUN ';
          StrQry := StrQry + ' , SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK ';
          StrQry := StrQry + ' , SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO, SUBK_USERID) ';
          StrQry := StrQry + ' VALUES('''+StrItnbr+''', '''+StrLotno+''', ''0'', '''' ';
          StrQry := StrQry + ' , '''+StrQty+''', ''0'', '''+StrBoxNo+''', '''+StrRemark+''' ';
          StrQry := StrQry + ' , '''+StrDate+''', '''+StrTime+''', '''+StrPltNo+''', '''+jj_id+''' ) ';

          With UpdtQuery Do Begin
            Try
              Close; SQL.Clear; SQL.Add(StrQry); ExecSql;
            Except
              Showmessage('[T2MISUBK 등록 에러!]'); Exit;
            End;
          End;
        End;
      End;
    End;

    //MessageDlg('저장이 완료되었습니다.', mtInformation, [mbOk], 0);
  end;

  // 공통 마무리 로직
  delGrid_Clear_Proc; 
  pltnoSrcEdit.Text := '';
  pltnoEdit.Text := '';
  
  SpeedButton1Click(Self); // 재조회 (비었으면 빈화면, 남았으면 남은화면)
  StartBitBtnClick(Self);

  // 입력 필드 초기화
  ItnbrEdit.Text  := '';
  NameEdit.Text   := '';
  LotnoEdit.Text  := '';
  WeightEdit.Text := '';
  BoxNoEdit.Text  := '';
  BigoEdit.Text   := '';

  pltnoSrcEdit.SetFocus;
end;

procedure TFrm_3100.CancelSBClick(Sender: TObject);
var
    m_Row, i, j : Integer;
    StrMsg : string;

    StrFlag : String;
    destRow, colNum : Integer;
    sWgt : String; // 중량 콤마 제거용 임시 변수
begin
  If InResGrid.row = 0 Then  Exit;
  If InResGrid.Cells[1, InResGrid.Row] = '' Then Begin
    StrMsg := ' 삭제할 데이타가 없습니다....' + #13#10 + '데이타를 선택한 후 다시 하십시요!!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;
  
  StrMsg := ' 현재 라인을 취소(수정) 하겠습니까 ? ';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin
    Exit;
  End;

  m_Row := InResGrid.Row;

  // ===========================================================================
  // 취소한 행 Edit Item으로 값 넘겨줌.
  // ===========================================================================
  ItnbrEdit.Text   := InResGrid.Cells[2, m_Row];  // 제품코드
  NameEdit.Text    := InResGrid.Cells[3, m_Row];  // 제품명
  LotnoEdit.Text   := InResGrid.Cells[4, m_Row];  // LOT-NO

  sWgt := InResGrid.Cells[5, m_Row];
  While Pos(',', sWgt) > 0 Do Begin Delete(sWgt, Pos(',', sWgt), 1); End;
  WeightEdit.Text  := sWgt;

  BoxNoEdit.Text   := InResGrid.Cells[6, m_Row];  // BOX NO
  BigoEdit.Text    := InResGrid.Cells[7, m_Row];  // 비고


  StrFlag := Trim(InResGrid.Cells[8, m_Row]);  // 신규구분(1:기존, 2:신규)

  if StrFlag = '1' then
  begin
    destRow := delGrid.RowCount;
    if Trim(delGrid.Cells[1, destRow-1]) <> '' then
    begin
      Inc(destRow);
      delGrid.RowCount := destRow;
    end;

    // 1..8 컬럼 복사
    for colNum := 1 to 8 do
      delGrid.Cells[colNum, destRow-1] := InResGrid.Cells[colNum, m_Row];
  end; // StrFlag 조건문 종료

  for j := m_Row to  InResGrid.RowCount-2 do
  begin
    for i := 0 to    InResGrid.ColCount-1  do
    begin
      InResGrid.Cells[i, j] := InResGrid.Cells[i, j+1];
    end;
  end;

  for j := 0 to  InResGrid.ColCount-1  do
  begin
    InResGrid.Cells[j, InResGrid.RowCount-1] := '';
  end;

  If InResGrid.RowCount > 2 Then InResGrid.RowCount := InResGrid.RowCount - 1;

  InResGrid.Col := 0;

  WeightEdit.SetFocus; // 중량 Edit Item Focus
end;


{
procedure TFrm_3100.CancelSBClick(Sender: TObject);
var
    m_Row, i, j : Integer;
    StrMsg : string;

    StrFlag : String;
    destRow, colNum : Integer;
begin
  If InResGrid.row = 0 Then  Exit;
  If InResGrid.Cells[1, InResGrid.Row] = '' Then Begin
    StrMsg := ' 삭제할 데이타가 없습니다....' + #13#10 + '데이타를 선택한 후 다시 하십시요!!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;
  StrMsg := ' 현재 라인을 삭제 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin
    Exit;
  End;

  m_Row := InResGrid.Row;
  StrFlag := Trim(InResGrid.Cells[8, m_Row]);  // 신규구분(1:기존, 2:신규)

  if StrFlag = '1' then
  begin
    destRow := delGrid.RowCount;
    if Trim(delGrid.Cells[1, destRow-1]) <> '' then
    begin
      Inc(destRow);
      delGrid.RowCount := destRow;
    end;

    // 1..8 컬럼 복사
    for colNum := 1 to 8 do
      delGrid.Cells[colNum, destRow-1] := InResGrid.Cells[colNum, m_Row];
  end; // StrFlag 조건문 종료

  for j := m_Row to  InResGrid.RowCount-2 do
  begin
    for i := 0 to    InResGrid.ColCount-1  do
    begin
      InResGrid.Cells[i, j] := InResGrid.Cells[i, j+1];
    end;
  end;

  for j := 0 to  InResGrid.ColCount-1  do
  begin
    InResGrid.Cells[j, InResGrid.RowCount-1] := '';
  end;

  If InResGrid.RowCount > 2 Then InResGrid.RowCount := InResGrid.RowCount - 1;

  InResGrid.Col := 0;

end;
}

procedure TFrm_3100.DataGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  OldAlign : Word;
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
      if (ACol = 4) Then Begin
        OldAlign := SetTextAlign (TStringGrid(Sender).Canvas.Handle, ta_right);
        TStringGrid(Sender).Canvas.TextRect(Rect, Rect.right-2, Rect.top+2, TStringGrid(Sender).Cells[ACol,ARow]);
        SetTextAlign(TStringGrid(Sender).Canvas.Handle, OldAlign);
      End;
    End;
  End;
end;



procedure TFrm_3100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_3100.FormDestroy(Sender: TObject);
begin
  Frm_3100 := Nil;
end;

procedure TFrm_3100.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_3100.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);

var
    Value : String;
    WW    : Integer;
begin  
  If DataCol = 0 Then
  begin
   with(Sender as TDBGrid).Canvas do
   begin
    Value := IntToStr(Query1.RecNo);
    WW    := Canvas.TextWidth(value);
    TextOut(Rect.Left+(Rect.Right - Rect.Left - WW) div 2, Rect.Top+2,Value);
   end;
  end;
end;
  
procedure TFrm_3100.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

{
procedure TFrm_3100.BcrEditKeyPress(Sender: TObject; var Key: Char);
var
  StrQry, ls_bcr, ls_chk : String;
  ls_SplitList : TStringArray;
  li_len, li_pos : Integer;
begin
   if key <> #13 then exit;

   ls_bcr  := Trim(BcrEdit.Text);
   
   // 빈 값이면 무시
   if ls_bcr = '' then Exit;

   // ==========================================================================
   // 1. END 커맨드 : 작업 종료 및 초기화 (버튼 잠금 해제 포함)
   // ==========================================================================
   if (ls_bcr = 'END') then
   begin
      // 모든 입력 필드 초기화
      pltnoSrcEdit.Text := '';
      pltnoEdit.Text    := '';
      ItnbrEdit.Text    := '';
      NameEdit.Text     := '';
      WeightEdit.Text   := '';
      LotnoEdit.Text    := '';
      BoxNoEdit.Text    := '';
      BigoEdit.Text     := '';

      // 바코드 입력창 초기화
      BcrEdit.Clear;

      // 그리드 초기화
      InResGrid_Clear_Proc;
      delGrid_Clear_Proc;

      // 버튼 잠금 해제
      ConfirmBtn.Enabled := True;
      CancelSB.Enabled   := True;
      ReservedSB.Enabled := True;

      // 재조회 (초기 상태로)
      StartBitBtnClick(self);

      // 포커스를 PLT 스캔 입력창으로 이동
      pltnoSrcEdit.SetFocus;

      exit;
   end;

   // ==========================================================================
   // 2. EMPTY 커맨드 : 공파레트 정보 불러오기
   // ==========================================================================
   if (ls_bcr = 'EMPTY') then
   begin
      StrQry := 'SELECT MAST_CODE, MAST_NAME, MAST_UNIT, MAST_WEIGHT ';
      StrQry := StrQry + ' FROM MIMAST WITH (NOLOCK) ';
      StrQry := StrQry + ' WHERE MAST_CODE = ''EMPTY'' ';

      with Query2 do
      begin
         Close;
         SQL.Clear;
         SQL.Add(StrQry);
         Open;

         if RecordCount > 0 then
         begin
            ItnbrEdit.Text  := FieldByName('MAST_CODE').AsString;   // 품번
            NameEdit.Text   := FieldByName('MAST_NAME').AsString;   // 품명
            WeightEdit.Text := FormatFloat('0.00', FieldByName('MAST_WEIGHT').AsFloat);  // 중량

            LotnoEdit.Text  := '';
            BoxNoEdit.Text  := '';
            BigoEdit.Text   := '';
         end
         else
         begin
            WinLib_ErrorForm('공파레트(EMPTY) 마스터 정보가 없습니다.');
            BcrEdit.Clear;
            Exit;
         end;
      end;

      BcrEdit.Clear;
      exit;
   end;

   // ==========================================================================
   // 바코드 파싱 로직 시작
   // ==========================================================================
   
   // 전역 변수 대신 지역변수 사용 (또는 기존 로직 호환을 위해 할당)
   ps_bcr := ls_bcr; 
   li_len := Length(ps_bcr);
   li_pos := Pos('$', ps_bcr);

   // --------------------------------------------------------------------------
   // [1순위 체크] '$' 구분자가 있는 경우 (레거시/특수 바코드)
   // --------------------------------------------------------------------------
   if (li_pos > 0) then
   begin
      ls_chk := Copy(ps_bcr, li_pos, 2); 
      
      // Case A: '$$' 포함 (예: BCODE$$LOTNO...)
      if (ls_chk = '$$') then
      begin
         ItnbrEdit.Text :=  '';
         LotnoEdit.Text :=  Copy(ps_bcr, li_pos + 4 , li_len); // LOTNO 추출
         
         ls_bcr := Copy(ps_bcr, 1, 8); // 앞 8자리를 바코드로 사용 (BCODE)
         
         StrQry := 'SELECT * From MIMAST (NOLOCK) WHERE MAST_BCODE = '''+ls_bcr+''' ';
         With Query2 Do
         Begin
            Close;
            SQL.Clear;
            SQL.Add(StrQry);
            Open;
            First;
            
            if RecordCount > 0 then
            begin
               ItnbrEdit.Text   := FieldByName('MAST_CODE').AsString;
               NameEdit.Text    := FieldByName('MAST_NAME').AsString;
               WeightEdit.Text  := '';
               WeightEdit.SetFocus;
            end
            else
            begin
               WinLib_ErrorForm('해당 바코드[' + ls_bcr + ']에 대한 품목 정보가 없습니다.');
            end;
         End;
      end
      // Case B: '$' 하나 포함 (예: ITEMCODE$LOTNO)
      else
      begin 
         ItnbrEdit.Text := Copy(ps_bcr, 1, li_pos - 1);
         LotnoEdit.Text := Copy(ps_bcr, li_pos + 1, li_len);
         
         StrQry := 'SELECT * From MIMAST (NOLOCK) WHERE MAST_CODE = '''+ItnbrEdit.Text+''' ';
         With Query2 Do
         Begin
            Close;
            SQL.Clear;
            SQL.Add(StrQry);
            Open;
            First;  
            
            if RecordCount > 0 then
            begin
               NameEdit.Text    := FieldByName('MAST_NAME').AsString;
               WeightEdit.Text  := '';
               WeightEdit.SetFocus;
            end
            else
            begin
               WinLib_ErrorForm('품목코드[' + ItnbrEdit.Text + ']에 대한 정보가 없습니다.');
            end;
         End;
      end;
   end
   // --------------------------------------------------------------------------
   // [2순위 체크] '$'가 없는 경우 -> '|' 정석 바코드 확인
   // --------------------------------------------------------------------------
   else if Pos('|', ls_bcr) > 0 then
   begin
      // 구분자 잘라서 배열에 넣기 (SplitString 함수 사용)
      ls_SplitList := SplitString(ls_bcr, '|');

      // 유효성 검사: 최소 6개 항목 (품번|품명|LOT|중량|BOX|비고)
      if Length(ls_SplitList) < 6 then
      begin
         WinLib_ErrorForm('바코드 형식이 올바르지 않습니다.'#13#10'형식 예) 품번|품명|LOTNO|중량|BOXNO|비고');
         BcrEdit.Clear;
         Exit;
      end;

      // 각 필드에 값 매핑
      ItnbrEdit.Text  := ls_SplitList[0];  // 품번
      NameEdit.Text   := ls_SplitList[1];  // 품명
      LotnoEdit.Text  := ls_SplitList[2];  // LOTNO
      WeightEdit.Text := ls_SplitList[3];  // 중량
      BoxNoEdit.Text  := ls_SplitList[4];  // BOX-NO
      BigoEdit.Text   := ls_SplitList[5];  // 비고
      
      // 바로 중량 입력으로 포커스 이동 (혹은 저장 로직 연결)
      WeightEdit.SetFocus;
   end
   // --------------------------------------------------------------------------
   // [3순위 체크] '$'도 없고 '|'도 없는 경우 (구형 고정길이 바코드)
   // --------------------------------------------------------------------------
   else
   begin
      ItnbrEdit.Text :=  '';
      // 7번째부터 2자리 + 12번째부터 6자리 조합을 LOT로 사용 (기존 로직 유지)
      LotnoEdit.Text :=  Copy(ps_bcr, 7 , 2) + Copy(ps_bcr, 12 , 6);
      
      ls_bcr := Copy(ps_bcr, 1, 5); // 앞 5자리를 바코드로 사용
      
      StrQry := 'SELECT * From MIMAST (NOLOCK) WHERE MAST_BCODE = '''+ls_bcr+''' ';
      With Query2 Do
      Begin
         Close;
         SQL.Clear;
         SQL.Add(StrQry);
         Open;
         First;
         
         if RecordCount > 0 then
         begin
            ItnbrEdit.Text   := FieldByName('MAST_CODE').AsString;
            NameEdit.Text    := FieldByName('MAST_NAME').AsString;
            WeightEdit.Text  := '';
            WeightEdit.SetFocus;
         end
         else
         begin
             WinLib_ErrorForm('해당 바코드[' + ls_bcr + ']에 대한 품목 정보가 없습니다.');
         end;
      End;
   end;   

   // 스캔창 비우기 (연속 스캔을 위해)
   BcrEdit.Clear;
end;
}

procedure TFrm_3100.BcrEditKeyPress(Sender: TObject; var Key: Char);
var
  StrQry, ls_bcr, ls_chk, ps_bcr : String;
  ls_SplitList : TStringArray;
  li_len, li_pos : Integer;
begin
   if key <> #13 then exit;

   ls_bcr  := Trim(BcrEdit.Text);
   
   // 빈 값이면 무시
   if ls_bcr = '' then Exit;

   // ==========================================================================
   // 1. END 커맨드 : 작업 종료 및 초기화
   // ==========================================================================
   if (ls_bcr = 'END') then
   begin
      pltnoSrcEdit.Text := '';
      pltnoEdit.Text    := '';
      ItnbrEdit.Text    := '';
      NameEdit.Text     := '';
      WeightEdit.Text   := '';
      LotnoEdit.Text    := '';
      BoxNoEdit.Text    := '';
      BigoEdit.Text     := '';

      BcrEdit.Clear;
      InResGrid_Clear_Proc;
      delGrid_Clear_Proc;

      ConfirmBtn.Enabled := True;
      CancelSB.Enabled   := True;
      ReservedSB.Enabled := True;

      StartBitBtnClick(self);
      pltnoSrcEdit.SetFocus;
      exit;
   end;

   // ==========================================================================
   // 2. EMPTY 커맨드 : 공파레트 정보 불러오기
   // ==========================================================================
   if (ls_bcr = 'EMPTY') then
   begin
      StrQry := 'SELECT MAST_CODE, MAST_NAME, MAST_UNIT, MAST_WEIGHT ';
      StrQry := StrQry + ' FROM MIMAST WITH (NOLOCK) ';
      StrQry := StrQry + ' WHERE MAST_CODE = ''EMPTY'' ';

      with Query2 do
      begin
         Close;
         SQL.Clear;
         SQL.Add(StrQry);
         Open;

         if RecordCount > 0 then
         begin
            ItnbrEdit.Text  := FieldByName('MAST_CODE').AsString;
            NameEdit.Text   := FieldByName('MAST_NAME').AsString;
            WeightEdit.Text := FormatFloat('0.00', FieldByName('MAST_WEIGHT').AsFloat);

            LotnoEdit.Text  := '';
            BoxNoEdit.Text  := '';
            BigoEdit.Text   := '';
         end
         else
         begin
            WinLib_ErrorForm('공파레트(EMPTY) 마스터 정보가 없습니다.');
            BcrEdit.Clear;
            Exit;
         end;
      end;

      BcrEdit.Clear;
      exit;
   end;

   // ==========================================================================
   // 3. 바코드 파싱 로직 (통합된 부분)
   // ==========================================================================

   // [통합] '|' 구분자 처리 (3개짜리 vs 6개짜리 자동 구분)
   if Pos('|', ls_bcr) > 0 then
   begin
      ls_SplitList := SplitString(ls_bcr, '|');
      li_len := Length(ls_SplitList); // 항목 개수 확인

      // Case A: 3단축 양식 (품목코드 | 품목명 | 중량)
      // 예시: SEC P|SEC P|1
      if li_len = 3 then
      begin
         ItnbrEdit.Text  := ls_SplitList[0];  // 품목코드
         NameEdit.Text   := ls_SplitList[1];  // 품목명
         WeightEdit.Text := ls_SplitList[2];  // 중량

         // 나머지 필드 초기화
         LotnoEdit.Text  := '';
         BoxNoEdit.Text  := '';
         BigoEdit.Text   := '';

         // 스캔 후 중량 입력창으로 포커스
         WeightEdit.SetFocus;
      end
      // Case B: 6개 표준 양식 (품목코드 | 품목명 | LOT | 중량 | BOX | 비고)
      else if li_len >= 6 then
      begin
         ItnbrEdit.Text  := ls_SplitList[0];
         NameEdit.Text   := ls_SplitList[1];
         LotnoEdit.Text  := ls_SplitList[2];
         WeightEdit.Text := ls_SplitList[3];
         BoxNoEdit.Text  := ls_SplitList[4];
         BigoEdit.Text   := ls_SplitList[5];
         
         WeightEdit.SetFocus;
      end
      // Case C: 형식 오류
      else
      begin
         WinLib_ErrorForm('바코드 형식이 올바르지 않습니다.'#13#10 +
                          '[3단축] 품목코드|품목명|중량'#13#10 +
                          '[표 준] 품목코드|품목명|LOT|중량|BOX|비고');
         BcrEdit.Clear;
         Exit;
      end;
      
      // 처리 완료 후 입력창 비우기 및 종료
      BcrEdit.Clear;
      Exit;
   end;

   // ==========================================================================
   // 4. 레거시 로직 (구형 바코드 $ 및 고정길이 처리)
   // ==========================================================================
   ps_bcr := ls_bcr;
   li_len := Length(ps_bcr);
   li_pos := Pos('$', ps_bcr);

   // [레거시 1] '$' 구분자가 있는 경우
   if (li_pos > 0) then
   begin
      ls_chk := Copy(ps_bcr, li_pos, 2);
      
      // Case A: '$$' 포함 (예: BCODE$$LOTNO...)
      if (ls_chk = '$$') then
      begin
         ItnbrEdit.Text :=  '';
         LotnoEdit.Text :=  Copy(ps_bcr, li_pos + 4 , li_len);
         ls_bcr := Copy(ps_bcr, 1, 8); // 앞 8자리를 바코드로 사용
         
         StrQry := 'SELECT * From MIMAST (NOLOCK) WHERE MAST_BCODE = '''+ls_bcr+''' ';
         With Query2 Do
         Begin
            Close; SQL.Clear; SQL.Add(StrQry); Open; First;
            if RecordCount > 0 then
            begin
               ItnbrEdit.Text   := FieldByName('MAST_CODE').AsString;
               NameEdit.Text    := FieldByName('MAST_NAME').AsString;
               WeightEdit.Text  := '';
               WeightEdit.SetFocus;
            end
            else
            begin
               WinLib_ErrorForm('해당 바코드[' + ls_bcr + ']에 대한 품목 정보가 없습니다.');
            end;
         End;
      end
      // Case B: '$' 하나 포함 (예: ITEMCODE$LOTNO)
      else
      begin 
         ItnbrEdit.Text := Copy(ps_bcr, 1, li_pos - 1);
         LotnoEdit.Text := Copy(ps_bcr, li_pos + 1, li_len);
         
         StrQry := 'SELECT * From MIMAST (NOLOCK) WHERE MAST_CODE = '''+ItnbrEdit.Text+''' ';
         With Query2 Do
         Begin
            Close; SQL.Clear; SQL.Add(StrQry); Open; First;  
            if RecordCount > 0 then
            begin
               NameEdit.Text    := FieldByName('MAST_NAME').AsString;
               WeightEdit.Text  := '';
               WeightEdit.SetFocus;
            end
            else
            begin
               WinLib_ErrorForm('품목코드[' + ItnbrEdit.Text + ']에 대한 정보가 없습니다.');
            end;
         End;
      end;
   end
   // [레거시 2] 구분자 없음 (고정 길이 방식)
   else
   begin
      ItnbrEdit.Text :=  '';
      // 7번째부터 2자리 + 12번째부터 6자리 조합을 LOT로 사용
      LotnoEdit.Text :=  Copy(ps_bcr, 7 , 2) + Copy(ps_bcr, 12 , 6);
      
      ls_bcr := Copy(ps_bcr, 1, 5); // 앞 5자리를 바코드로 사용
      
      StrQry := 'SELECT * From MIMAST (NOLOCK) WHERE MAST_BCODE = '''+ls_bcr+''' ';
      With Query2 Do
      Begin
         Close; SQL.Clear; SQL.Add(StrQry); Open; First;
         if RecordCount > 0 then
         begin
            ItnbrEdit.Text   := FieldByName('MAST_CODE').AsString;
            NameEdit.Text    := FieldByName('MAST_NAME').AsString;
            WeightEdit.Text  := '';
            WeightEdit.SetFocus;
         end
         else
         begin
             WinLib_ErrorForm('해당 바코드[' + ls_bcr + ']에 대한 품목 정보가 없습니다.');
         end;
      End;
   end;   

   // 스캔창 비우기 (연속 스캔을 위해)
   BcrEdit.Clear;
end;

procedure TFrm_3100.MouseWheelHandler(var Message: TMessage);
var
 i: SmallInt;
begin
 // inherited;
 if Message.Msg = WM_MOUSEWHEEL then
 begin
   if ActiveControl is TDBGrid then
   begin
     Message.Msg := WM_KEYDOWN;
     Message.lParam := 0;
     i := HiWord(Message.wParam);
     if i > 0 then
       Message.wParam := VK_UP
     else
       Message.wParam := VK_DOWN;
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     (ActiveControl as TDBGrid).Refresh;
   end;
 end;
end;

function TFrm_3100.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl (NOLOCK) ';
    With Query2 Do Begin
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



procedure TFrm_3100.pltnoEditKeyPress(Sender: TObject; var Key: Char);
var
  ls_pltno : String;
begin
  ls_pltno := pltnoEdit.Text;

  if key <> #13 Then Exit else SpeedButton1Click(self);
end;

procedure TFrm_3100.SpeedButton1Click(Sender: TObject);
var
  ls_sql : String;
  iRow : Integer;
begin

  InResGrid_Clear_Proc;
  delGrid_Clear_Proc;  

  ls_sql := '          SELECT ';
  ls_sql := ls_sql + '   A.SUBK_LOCA, A.SUBK_CODE, B.MAST_NAME ';
  ls_sql := ls_sql + '   , A.SUBK_LOTNO, A.SUBK_FLAG, A.SUBK_GUBUN ';
  ls_sql := ls_sql + '   , A.SUBK_WGT, A.SUBK_RWGT, A.SUBK_BOXNO ';
  ls_sql := ls_sql + '   , A.SUBK_REMARK, A.SUBK_INDATE, A.SUBK_INTIME  ';
  ls_sql := ls_sql + '   , A.SUBK_PLTNO ';
  ls_sql := ls_sql + ' FROM T2MISUBK A WITH (NOLOCK) ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN MIMAST B WITH (NOLOCK) ON A.SUBK_CODE = B.MAST_CODE ';
  ls_Sql := ls_Sql + ' WHERE A.SUBK_PLTNO = ''' + pltnoEdit.Text + ''' ';

  
  t2SubkQry.Close;
  t2SubkQry.SQL.Clear;
  t2SubkQry.SQL.Add(ls_sql);
  t2SubkQry.Open;
  t2SubkQry.First;

  if (t2SubkQry.RecordCount = 0) then
  begin
      Exit;
  end;

  iRow := 0;

  while True do
  begin
       if t2SubkQry.Eof = True then break;
       inc(iRow);

       InResGrid.Cells[1, iRow]  := t2SubkQry.FieldByName('SUBK_PLTNO').AsString; // PLTNO
       InResGrid.Cells[2, iRow]  := t2SubkQry.FieldByName('SUBK_CODE').AsString; // ITEM_CD
       InResGrid.Cells[3, iRow]  := t2SubkQry.FieldByName('MAST_NAME').AsString; // 품명
       InResGrid.Cells[4, iRow]  := t2SubkQry.FieldByName('SUBK_LOTNO').AsString; // LOTNO
       InResGrid.Cells[5, iRow]  := FormatFloat('#,##0.00', t2SubkQry.FieldByName('SUBK_WGT').AsFloat); // 중량
       InResGrid.Cells[6, iRow]  := t2SubkQry.FieldByName('SUBK_BOXNO').AsString; // BOXNO
       InResGrid.Cells[7, iRow]  := t2SubkQry.FieldByName('SUBK_REMARK').AsString; // 비고
       InResGrid.Cells[8, iRow]  := '1'; // 기존 데이터유무 1: 기존 2: 신규 추가 (Grid 내부 추가)       

       InResGrid.RowCount := iRow + 1;
       t2SubkQry.Next;
  end;

end;

procedure TFrm_3100.pltnoSrcEditKeyPress(Sender: TObject; var Key: Char);
var
  ls_pltno : String;
begin
  if key <> #13 Then Exit;

  ls_pltno := Trim(pltnosrcEdit.Text);
  
  // 빈 값이면 무시
  if ls_pltno = '' then Exit;

  // 1. 입력창 초기화 (새로운 조회 전 기존 정보 클리어)
  ItnbrEdit.Text    := '';
  NameEdit.Text     := '';
  WeightEdit.Text   := '';
  LotnoEdit.Text    := '';
  BoxNoEdit.Text    := '';
  BigoEdit.Text     := '';

  // 2. [Display] 입력받은 값을 표시 전용 에디트로 이동
  pltnoEdit.Text := ls_pltno;

  // 3. [Lock Check] 트래킹/재고 여부 확인하여 버튼(추가/삭제/저장) 잠그기
  Check_Plt_Lock(ls_pltno);

  // 4. 그리드 조회 실행 (기존 데이터 불러오기)
  SpeedButton1Click(self);

  // 5. 포커스 이동 및 초기화
  pltnosrcEdit.Text := ''; // 스캔창 비우기
  BcrEdit.SetFocus;        // 제품 바코드 입력창으로 포커스 이동
end;

function TFrm_3100.SplitString(const fullString: string; const Delimiter: Char): TStringArray;
var
  i, n: Integer;
  token: string;
begin
  SetLength(Result, 0);
  token := '';

  for i := 1 to Length(fullString) do
  begin
    if fullString[i] = Delimiter then
    begin
      // 구분자 만나면 지금까지의 토큰을 추가 (앞뒤 공백 제거)
      n := Length(Result);
      SetLength(Result, n + 1);
      Result[n] := Trim(token);
      token := '';
    end
    else
      token := token + fullString[i];
  end;

  // 마지막 토큰 추가 (문자열이 구분자로 끝나면 빈 문자열도 들어감)
  n := Length(Result);
  SetLength(Result, n + 1);
  Result[n] := Trim(token);
end;

procedure TFrm_3100.WeightEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 Then Exit;
  LotNoEdit.SetFocus;
end;

procedure TFrm_3100.BoxNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 Then Exit;
  BigoEdit.SetFocus;
end;


// [추가] 파레트 상태 체크 및 버튼 제어 (간편 버전)
procedure TFrm_3100.Check_Plt_Lock(sPltNo: String);
var
  ls_sql: String;
  IsLocked: Boolean;
  LockMsg: String;
begin
  IsLocked := False;
  LockMsg := '';

  if Trim(sPltNo) = '' then Exit;

  // 1. 트래킹(이동중) 체크
  ls_sql := 'SELECT COUNT(*) FROM T2TBTRAK WITH (NOLOCK) WHERE TRAK_PLTNO = ''' + sPltNo + '''';
  with ChkQuery do
  begin
    Close; SQL.Clear; SQL.Add(ls_sql); Open;
    if Fields[0].AsInteger > 0 then
    begin
      IsLocked := True;
    end;
  end;

  // 2. 재고(이미 입고됨) 체크
  if not IsLocked then
  begin
    ls_sql := 'SELECT COUNT(*) FROM T2MILSTK WITH (NOLOCK) WHERE LSTK_PLTNO = ''' + sPltNo + '''';
    with ChkQuery do
    begin
      Close; SQL.Clear; SQL.Add(ls_sql); Open;
      if Fields[0].AsInteger > 0 then
      begin
        IsLocked := True;
      end;
    end;
  end;

  // 3. [핵심] 버튼 3개만 제어 (입력창 등은 놔둠)
  ConfirmBtn.Enabled := not IsLocked;  // 추가 버튼
  CancelSB.Enabled   := not IsLocked;  // 삭제 버튼
  ReservedSB.Enabled := not IsLocked;  // 저장 버튼
end;

procedure TFrm_3100.itemEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    StartBitBtnClick(Self);
  end;
end;

procedure TFrm_3100.itemNmEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    StartBitBtnClick(Self);
  end;
end;

end.

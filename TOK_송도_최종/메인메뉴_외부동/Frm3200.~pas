unit Frm3200;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, DB, ADODB, DBTables,
  ComCtrls, Mask, Winsock;

type
  TFrm_3200 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    InResGrid: TStringGrid;
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
    Label1: TLabel;
    Label2: TLabel;
    Titlepl: TPanel;
    FromDate: TDateTimePicker;
    ToDate: TDateTimePicker;
    ConfirmBtn: TSpeedButton;
    CancelSB: TSpeedButton;
    Panel5: TPanel;
    LotnoEdit: TEdit;
    DataSource1: TDataSource;
    RecNoEdit: TEdit;
    SeltCB: TComboBox;
    ItemCB: TEdit;
    Panel9: TPanel;
    Panel11: TPanel;
    DateEdit: TMaskEdit;
    TimeEdit: TMaskEdit;
    Panel13: TPanel;
    OindexEdit: TEdit;
    StatQuery: TADOQuery;
    DispQuery: TADOQuery;
    HogiCB: TComboBox;
    Panel3: TPanel;
    Panel17: TPanel;
    BigoEdit: TEdit;
    Panel12: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Em3lv1Pnl: TPanel;
    Em2lv1Pnl: TPanel;
    Em1lv1Pnl: TPanel;
    Panel45: TPanel;
    Panel47: TPanel;
    Em1lv2Pnl: TPanel;
    Em2lv2Pnl: TPanel;
    Em3lv2Pnl: TPanel;
    Em3lv3Pnl: TPanel;
    Em2lv3Pnl: TPanel;
    Em1lv3Pnl: TPanel;
    Panel49: TPanel;
    Panel21: TPanel;
    Em1lv4Pnl: TPanel;
    Em2lv4Pnl: TPanel;
    Em3lv4Pnl: TPanel;
    Em3lv5Pnl: TPanel;
    Em2lv5Pnl: TPanel;
    Em1lv5Pnl: TPanel;
    Panel16: TPanel;
    Panel18: TPanel;
    Em1lv6Pnl: TPanel;
    Em2lv6Pnl: TPanel;
    Em3lv6Pnl: TPanel;
    Em3lv7Pnl: TPanel;
    Em2lv7Pnl: TPanel;
    Em1lv7Pnl: TPanel;
    Panel33: TPanel;
    Panel29: TPanel;
    Em1lv8Pnl: TPanel;
    Em2lv8Pnl: TPanel;
    Em3lv8Pnl: TPanel;
    Panel25: TPanel;
    Em1lv9Pnl: TPanel;
    Em2lv9Pnl: TPanel;
    Em3lv9Pnl: TPanel;
    Panel8: TPanel;
    BoxNoEdit: TEdit;
    pltnoEdit: TEdit;
    Panel22: TPanel;
    DBGrid2: TDBGrid;
    Query3: TADOQuery;
    Query3SUBK_BOXNO: TStringField;
    Query3SUBK_CODE: TStringField;
    Query3MAST_NAME: TStringField;
    Query3SUBK_FLAG: TStringField;
    Query3SUBK_GUBUN: TStringField;
    Query3SUBK_INDATE: TStringField;
    Query3SUBK_INTIME: TStringField;
    Query3SUBK_LOCA: TStringField;
    Query3SUBK_LOTNO: TStringField;
    Query3SUBK_PLTNO: TStringField;
    Query3SUBK_REMARK: TStringField;
    Query3SUBK_WGT: TBCDField;
    Query3SUBK_RWGT: TBCDField;
    Query3SUBK_USERID: TStringField;
    Query3OUPT_TIME: TStringField;
    Query3OUPT_INDATE: TStringField;
    Query3OUPT_INTIME: TStringField;
    Query3OUPT_HOGI: TStringField;
    Query3OUPT_DATE: TStringField;
    Query3OUPT_RLOCA: TStringField;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);  
    procedure ConfirmBtnClick(Sender: TObject);
    procedure DataGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure CancelSBClick(Sender: TObject);   
    procedure Cntl_Item_Check;
    procedure StartBitBtnClick(Sender: TObject);
    procedure ItnbrEditKeyPress(Sender: TObject; var Key: Char); 
    procedure WeightEditChange(Sender: TObject);     
    procedure SeltCBChange(Sender: TObject);
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char);

    procedure DBGrid1TitleClick(Column: TColumn);
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure ReservedSBClick(Sender: TObject);
    procedure DBGrid2TitleClick(Column: TColumn);
  private
    { Private declarations }
    function IsNumCheck(var StrData : String): Boolean; 
    procedure InResGrid_Clear_Proc;
    function f_get_sysdate_time1(): String;
    

  public
    { Public declarations }
  end;

var
  Frm_3200: TFrm_3200;

  Var_Form : TForm;
  Read_ok : Boolean;
  Bol_Data_Ok : Boolean;

  StrQry : String;
  StrMsg : String;
  StrDate1, StrDate2: String;    
  s_date, s_time : String;
  sys_datetime : String;

  StrItnbr,  StrLotno, StrCode, s_high, s_wsno, s_floor, s_gubun, s_station : String;
implementation

uses DBSet, WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.dfm}

function TFrm_3200.IsNumCheck(var StrData: String): Boolean;
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

procedure TFrm_3200.FormCreate(Sender: TObject);
begin
   if (jj_kind <> '50') then
   begin
    ReservedSB.Visible    := False;
   end;

   InResGrid.Cells[1,0]  := 'PLT-NO';
   InResGrid.Cells[2,0]  := '품목코드';
   InResGrid.Cells[3,0]  := '품 목 명';
   InResGrid.Cells[4,0]  := 'LOT-NO';
   InResGrid.Cells[5,0]  := '적재중량';
   InResGrid.Cells[6,0]  := 'BOX-NO';
   InResGrid.Cells[7,0]  := '비  고';
   InResGrid.Cells[8,0]  := '입고일자';
   InResGrid.Cells[9,0]  := '입고시간';
   InResGrid.Cells[10,0]  := '기PLT-NO';


   InResGrid.ColWidths[0] := 4;
   InResGrid.ColWidths[1] := 150;
   InResGrid.ColWidths[2] := 150;
   InResGrid.ColWidths[3] := 200;
   InResGrid.ColWidths[4] := 150;
   InResGrid.ColWidths[5] := 100;
   InResGrid.ColWidths[6] := 200;
   InResGrid.ColWidths[7] := 200;
   InResGrid.ColWidths[8] := 90;
   InResGrid.ColWidths[9] := 80;
   InResGrid.ColWidths[10] := 120;


   InResGrid.RowCount := 2;

   FromDate.Date := Now;   ToDate.Date := Now;
   SeltCB.ItemIndex := 0;
   HogiCB.ItemIndex := 0;   


   StartBitBtnClick(Self);

end;

procedure TFrm_3200.InResGrid_Clear_Proc;
var
  IntCnt : Integer;
begin
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
     Cells[10,IntCnt]  := '';     
    End;
  End;
  InResGrid.RowCount := 2;
end;

procedure TFrm_3200.StartBitBtnClick(Sender: TObject);
var
  ls_sql : String;
  li_stok1  : Array[1..9] of Integer;
  li_stok2  : Array[1..9] of Integer;
  li_stok3  : Array[1..9] of Integer;
  ls_lv, ls_bk : string;
  li_i, li_cnt : Integer;
  ls_SearchVal : String; // 검색어 공백제거용 변수
begin
  StrDate1 := FormatDateTime('yyyymmdd', FromDate.Date);
  StrDate2 := FormatDateTime('yyyymmdd', ToDate.Date);
  ls_SearchVal := Trim(ItemCB.Text);

  // 1. SELECT 절 구성
  ls_sql := ' SELECT ';
  ls_sql := ls_sql + '   A.SUBK_BOXNO, A.SUBK_CODE, B.MAST_NAME, A.SUBK_FLAG ';
  ls_sql := ls_sql + ' , A.SUBK_GUBUN, A.SUBK_INDATE, A.SUBK_INTIME, A.SUBK_LOCA ';
  ls_sql := ls_sql + ' , A.SUBK_LOTNO, A.SUBK_PLTNO, A.SUBK_REMARK, A.SUBK_WGT, A.SUBK_RWGT ';
  ls_sql := ls_sql + ' , A.SUBK_USERID ';
  
  ls_sql := ls_sql + ' , ISNULL(C.OUPT_TIME,   D.OUPT_TIME)   AS OUPT_TIME ';
  ls_sql := ls_sql + ' , ISNULL(C.OUPT_INDATE, D.OUPT_INDATE) AS OUPT_INDATE ';
  ls_sql := ls_sql + ' , ISNULL(C.OUPT_INTIME, D.OUPT_INTIME) AS OUPT_INTIME ';
  ls_sql := ls_sql + ' , ISNULL(C.OUPT_DATE,   D.OUPT_DATE)   AS OUPT_DATE ';
  ls_sql := ls_sql + ' , RIGHT(A.SUBK_PLTNO, 4) AS OUPT_RLOCA ';

  ls_sql := ls_sql + ' , CASE ';
  ls_sql := ls_sql + '     WHEN LEFT(ISNULL(C.OUPT_LOCA, RIGHT(A.SUBK_PLTNO, 4)), 1) IN (''1'', ''2'') THEN ''1'' ';
  ls_sql := ls_sql + '     WHEN LEFT(ISNULL(C.OUPT_LOCA, RIGHT(A.SUBK_PLTNO, 4)), 1) IN (''3'', ''4'') THEN ''2'' ';
  ls_sql := ls_sql + '     WHEN LEFT(ISNULL(C.OUPT_LOCA, RIGHT(A.SUBK_PLTNO, 4)), 1) IN (''5'', ''6'') THEN ''3'' ';
  ls_sql := ls_sql + '     ELSE '''' ';
  ls_sql := ls_sql + '   END AS OUPT_HOGI ';

  ls_sql := ls_sql + ' FROM T2MISUBK A WITH (NOLOCK) ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN MIMAST B WITH (NOLOCK) ON A.SUBK_CODE = B.MAST_CODE ';
  
  ls_sql := ls_sql + ' LEFT OUTER JOIN T2MIOUPT C WITH (NOLOCK) ON A.SUBK_CODE = C.OUPT_CODE ';
  ls_sql := ls_sql + '      AND A.SUBK_LOTNO = C.OUPT_LOTNO AND A.SUBK_PLTNO = C.OUPT_PLTNO ';

  ls_sql := ls_sql + ' OUTER APPLY ( ';
  ls_sql := ls_sql + '    SELECT TOP 1 OUPT_TIME, OUPT_INDATE, OUPT_INTIME, OUPT_DATE, OUPT_LOCA ';
  ls_sql := ls_sql + '    FROM T2MIOUPT WITH (NOLOCK) ';
  ls_sql := ls_sql + '    WHERE OUPT_LOCA = RIGHT(A.SUBK_PLTNO, 4) ';
  ls_sql := ls_sql + '    ORDER BY OUPT_DATE DESC, OUPT_TIME DESC ';
  ls_sql := ls_sql + ' ) D ';

  ls_sql := ls_sql + ' WHERE A.SUBK_FLAG = ''R'' AND A.SUBK_PLTNO LIKE ''T%'' ';

  ls_sql := ls_sql + ' AND ISNULL(C.OUPT_DATE, D.OUPT_DATE) >= ''' + StrDate1 + ''' ';
  ls_sql := ls_sql + ' AND ISNULL(C.OUPT_DATE, D.OUPT_DATE) <= ''' + StrDate2 + ''' ';

  if HogiCB.ItemIndex = 1 then      // 호기 1
     ls_sql := ls_sql + ' AND LEFT(ISNULL(C.OUPT_LOCA, RIGHT(A.SUBK_PLTNO, 4)), 1) IN (''1'', ''2'') '
  else if HogiCB.ItemIndex = 2 then // 호기 2
     ls_sql := ls_sql + ' AND LEFT(ISNULL(C.OUPT_LOCA, RIGHT(A.SUBK_PLTNO, 4)), 1) IN (''3'', ''4'') '
  else if HogiCB.ItemIndex = 3 then // 호기 3
     ls_sql := ls_sql + ' AND LEFT(ISNULL(C.OUPT_LOCA, RIGHT(A.SUBK_PLTNO, 4)), 1) IN (''5'', ''6'') ';

  if (SeltCB.ItemIndex > 0) and (ls_SearchVal <> '') then
  begin
      if SeltCB.ItemIndex = 1 then      // 품목코드 검색
         //ls_sql := ls_sql + ' AND A.SUBK_CODE LIKE ''%' + ls_SearchVal + '%'' '
         ls_sql := ls_sql + ' AND A.SUBK_CODE = ''' + ls_SearchVal + ''' '   // 고객사 요청사항 
      else if SeltCB.ItemIndex = 2 then // 품목명 검색
         ls_sql := ls_sql + ' AND B.MAST_NAME LIKE ''%' + ls_SearchVal + '%'' '
      else if SeltCB.ItemIndex = 3 then // LOT-NO 검색
         ls_sql := ls_sql + ' AND A.SUBK_LOTNO LIKE ''%' + ls_SearchVal + '%'' ';
  end;

  ls_sql := ls_sql + ' ORDER BY A.SUBK_BOXNO '; 

  Query3.Close;
  Query3.SQL.Clear;
  Query3.SQL.Add(ls_sql);
  Query3.Open;
  Query3.First;  

  // 건수 표시
  RecNoEdit.Text := Format('%d', [Query3.RecordCount]);


  // ==============================================================
  // 재고 현황판 Query2
  // ==============================================================
  For li_i := 1 to 9 do Begin 
    li_stok1[li_i] := 0; li_stok2[li_i] := 0; li_stok3[li_i] := 0; 
  end;

  ls_sql := ' Select LSTK_LV, LSTK_BK, Count(*) As Cnt From T2MILSTK (NOLOCK) ';
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

  Em3lv1Pnl.Caption := IntToStr(li_stok3[1]);   Em3lv2Pnl.Caption := IntToStr(li_stok2[2]); Em3lv3Pnl.Caption := IntToStr(li_stok3[3]);
  Em3lv4Pnl.Caption := IntToStr(li_stok3[4]);   Em3lv5Pnl.Caption := IntToStr(li_stok2[5]); Em3lv6Pnl.Caption := IntToStr(li_stok3[6]);
  Em3lv7Pnl.Caption := IntToStr(li_stok3[7]);   Em3lv8Pnl.Caption := IntToStr(li_stok2[8]); Em3lv9Pnl.Caption := IntToStr(li_stok3[9]);

end;

procedure TFrm_3200.SeltCBChange(Sender: TObject);
begin
   ItemCb.Text := '';
end;

procedure TFrm_3200.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 then Exit;
  StartBitBtnClick(self);
end;   


procedure TFrm_3200.ItnbrEditKeyPress(Sender: TObject; var Key: Char);
begin
   if key <> #13 Then Exit;
   Read_ok := False;
   //Cntl_Item_Check;
end;


procedure TFrm_3200.Cntl_Item_Check;
var
  IntRow, li_i : Integer;
  StrSql, ls_yy, ls_mm, ls_dd : String;
  NumQty, ls_qty : Real;
begin
  Bol_Data_Ok := True;

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
        StrMsg := ' 제품 마스터에 코드가 없읍니다..' + #13#10 + ' 확인한 후 다시 하십시요!!!';
        WinLib_ErrorForm( StrMsg );
        ItnbrEdit.Text := '';
        Exit;
      end;
      ItnbrEdit.Text   := FieldByName('MAST_CODE').AsString;
      NameEdit.Text    := FieldByName('MAST_NAME').AsString;
      WeightEdit.Text  := FieldByName('MAST_WEIGHT').AsString;
  end;
  ConfirmBtnClick(Self);
end;

procedure TFrm_3200.WeightEditChange(Sender: TObject);
var
  StrBQty, StrQry : String;
  NumQty, NumWgt : Real;
begin
  StrBQty := WeightEdit.Text;

  if (Length(StrBQty) = 0) or  (StrBQty = '0') then  Exit;

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

{
procedure TFrm_3200.ConfirmBtnClick(Sender: TObject);
var
  IntPos, IntRow : Integer;
  StrBQty, StrQry, StrLotno, StrItnbr, StrOldPlt : String;
  NumQty : Real;
begin
  // 기재고 정보 확인
  If Length(Trim(OindexEdit.Text)) = 0 Then Begin
     StrMsg := '기재고 정보(기존 PLT)가 없습니다.' + #13#10 + '왼쪽 목록에서 불출할 대상을 먼저 선택하세요.';
     WinLib_ErrorForm( StrMsg );
     Exit;
  End;

  // 신규 PLT-NO 입력 체크
  If Length(Trim(pltnoEdit.Text)) = 0 Then Begin
    StrMsg := '신규 PLT-NO가 입력되지 않았습니다.';
    WinLib_ErrorForm( StrMsg );
    pltnoEdit.SetFocus;
    Exit;
  End;

  // ===========================================================================
  // PLT-NO가 이미 DB에 존재하는지 중복 체크 (다른 기재고와 섞임 방지)
  // ===========================================================================
  StrQry := 'SELECT TOP 1 SUBK_PLTNO FROM T2MISUBK (NOLOCK) WHERE SUBK_PLTNO = ''' + pltnoEdit.Text + ''' ';
  With Query2 Do
  Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      Open;
      if RecordCount > 0 then
      begin
        StrMsg := '입력하신 신규 PLT-NO [' + pltnoEdit.Text + ']는 이미 사용 중입니다.' + #13#10 +
                  '다른 PLT 번호를 사용해 주세요.';
        WinLib_ErrorForm( StrMsg );
        pltnoEdit.SetFocus;
        Exit;
      end;
  End;
  // ===========================================================================

  // 품목코드 입력 체크
  If Length(Trim(ItnbrEdit.Text)) = 0  Then Begin
    StrMsg := '품목코드가 없습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  // 품목 마스터 체크
  StrQry := 'SELECT * From MIMAST (NOLOCK) WHERE MAST_CODE = ''' + itnbrEdit.Text + ''' ';
  With Query2 Do
  Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      Open;
      if RecordCount = 0 then
      begin
        StrMsg := '품목 마스터에 존재하지 않는 코드입니다.';
        WinLib_ErrorForm( StrMsg );
        Exit;
      end;
      ItnbrEdit.Text   := FieldByName('MAST_CODE').AsString;
      NameEdit.Text    := FieldByName('MAST_NAME').AsString;
  end;

  // 중량 체크
  StrBQty := WeightEdit.Text;
  While Pos(',', StrBQty) > 0 Do Begin Delete(StrBQty, Pos(',', StrBQty), 1); End;
  Try
    NumQty := StrToFloat(StrBQty);
  Except
    NumQty := 0;
  End;

  if NumQty <= 0 Then
  Begin
    StrMsg := '입고 작업할 중량이 0이거나 잘못되었습니다.';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  // 그리드 내 기재고(PLT) 섞임 방지 및 중복 체크
  StrLotno  := LotnoEdit.Text;
  StrItnbr  := ItNbrEdit.Text;
  StrOldPlt := OindexEdit.Text; 

  if (InResGrid.RowCount > 1) and (InResGrid.Cells[1, 1] <> '') then
  begin
      // (1) 다른 기재고 번호가 섞이지 않도록 체크
      if Trim(InResGrid.Cells[10, 1]) <> Trim(StrOldPlt) then
      begin
          StrMsg := '다른 기재고(Source PLT)가 섞일 수 없습니다!' + #13#10 +
                    '현재 목록: ' + InResGrid.Cells[10, 1] + #13#10 +
                    '입력 시도: ' + StrOldPlt;
          WinLib_ErrorForm(StrMsg);
          Exit;
      end;
      
      // 그리드 상에서 신규 PLT 번호가 바뀌었는지 체크 (한번 작업엔 하나의 신규PLT만 허용 권장)
      if Trim(InResGrid.Cells[1, 1]) <> Trim(pltnoEdit.Text) then
      begin
          StrMsg := '현재 목록에 담긴 신규 PLT 번호와 다릅니다.' + #13#10 +
                    '목록: ' + InResGrid.Cells[1, 1] + #13#10 +
                    '입력: ' + pltnoEdit.Text;
          WinLib_ErrorForm(StrMsg);
          Exit;
      end;
  end;

  Bol_Data_Ok := True;
  for IntRow := 1 to InResGrid.RowCount - 1 Do
  Begin
    if InResGrid.Cells[1, IntRow] <> '' then
    begin
        If (StrOldPlt = InResGrid.Cells[10, IntRow]) And
           (StrItnbr  = InResGrid.Cells[2,  IntRow]) And
           (StrLotno  = InResGrid.Cells[4,  IntRow]) Then
        Begin
           Bol_Data_Ok := False;
           Break; 
        End;
    end;
  End;

  If Not Bol_Data_Ok Then Begin
    StrMsg := '이미 리스트에 등록된 데이터입니다.';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  // 6. 그리드 추가
  IntPos := InResGrid.RowCount;
  IF InResGrid.Cells[1, IntPos - 1] <> '' then
  begin
     InResGrid.RowCount := IntPos + 1;
     IntPos := IntPos + 1;
  end;

  InResGrid.Cells[1, IntPos - 1]  := pltnoEdit.text;               
  InResGrid.Cells[2, IntPos - 1]  := itnbrEdit.text;               
  InResGrid.Cells[3, IntPos - 1]  := NameEdit.text;                
  InResGrid.Cells[4, IntPos - 1]  := LotnoEdit.Text;               
  InResGrid.Cells[5, IntPos - 1]  := FormatFloat('#,##0.00', NumQty); 
  InResGrid.Cells[6, IntPos - 1]  := BoxnoEdit.Text;               
  InResGrid.Cells[7, IntPos - 1]  := BigoEdit.Text;                
  InResGrid.Cells[8, IntPos - 1]  := DAteEdit.Text;                
  InResGrid.Cells[9, IntPos - 1]  := TimeEdit.Text;                
  InResGrid.Cells[10, IntPos - 1] := OindexEdit.Text;              

  // 입력창 초기화 (pltnoEdit는 유지)
  ItnbrEdit.Text    := '';
  NameEdit.Text     := '';
  LotnoEdit.Text    := '';
  WeightEdit.Text   := '';
  DAteEdit.Text     := '';
  TimeEdit.Text     := '';
  OindexEdit.Text   := ''; 
  BigoEdit.Text     := '';
  BoxnoEdit.Text    := '';
End;
}

procedure TFrm_3200.ConfirmBtnClick(Sender: TObject);
var
  IntPos, IntRow : Integer;
  StrBQty, StrQry, StrLotno, StrItnbr, StrOldPlt : String;
  NumQty : Real;
  IsUpdate : Boolean; // 수정 모드 여부 확인 변수
begin
  // 기재고 정보 확인
  If Length(Trim(OindexEdit.Text)) = 0 Then Begin
      StrMsg := '기재고 정보(기존 PLT)가 없습니다.' + #13#10 + '왼쪽 목록에서 불출할 대상을 먼저 선택하세요.';
      WinLib_ErrorForm( StrMsg );
      Exit;
  End;

  // 신규 PLT-NO 입력 체크
  If Length(Trim(pltnoEdit.Text)) = 0 Then Begin
    StrMsg := '신규 PLT-NO가 입력되지 않았습니다.';
    WinLib_ErrorForm( StrMsg );
    pltnoEdit.SetFocus;
    Exit;
  End;

  // ===========================================================================
  // PLT-NO 중복 체크 (DB에 이미 있는지)
  // ===========================================================================
  StrQry := 'SELECT TOP 1 SUBK_PLTNO FROM T2MISUBK (NOLOCK) WHERE SUBK_PLTNO = ''' + pltnoEdit.Text + ''' ';
  With Query2 Do
  Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      Open;
      if RecordCount > 0 then
      begin
        StrMsg := '입력하신 신규 PLT-NO [' + pltnoEdit.Text + ']는 이미 사용 중입니다.' + #13#10 +
                  '다른 PLT 번호를 사용해 주세요.';
        WinLib_ErrorForm( StrMsg );
        pltnoEdit.SetFocus;
        Exit;
      end;
  End;
  // ===========================================================================

  // 품목코드 입력 체크
  If Length(Trim(ItnbrEdit.Text)) = 0  Then Begin
    StrMsg := '품목코드가 없습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  // 중량 체크
  StrBQty := WeightEdit.Text;
  While Pos(',', StrBQty) > 0 Do Begin Delete(StrBQty, Pos(',', StrBQty), 1); End;
  Try
    NumQty := StrToFloat(StrBQty);
  Except
    NumQty := 0;
  End;

  if NumQty <= 0 Then
  Begin
    StrMsg := '입고 작업할 중량이 0이거나 잘못되었습니다.';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  // 그리드 내 기재고(PLT) 섞임 방지 체크
  StrLotno  := LotnoEdit.Text;
  StrItnbr  := ItNbrEdit.Text;
  StrOldPlt := OindexEdit.Text; 

  if (InResGrid.RowCount > 1) and (InResGrid.Cells[1, 1] <> '') then
  begin
      if Trim(InResGrid.Cells[10, 1]) <> Trim(StrOldPlt) then
      begin
          StrMsg := '다른 기재고(Source PLT)가 섞일 수 없습니다!' + #13#10 +
                    '현재 목록: ' + InResGrid.Cells[10, 1] + #13#10 +
                    '입력 시도: ' + StrOldPlt;
          WinLib_ErrorForm(StrMsg);
          Exit;
      end;
      
      if Trim(InResGrid.Cells[1, 1]) <> Trim(pltnoEdit.Text) then
      begin
          StrMsg := '현재 목록에 담긴 신규 PLT 번호와 다릅니다.' + #13#10 +
                    '목록: ' + InResGrid.Cells[1, 1] + #13#10 +
                    '입력: ' + pltnoEdit.Text;
          WinLib_ErrorForm(StrMsg);
          Exit;
      end;
  end;

  // [수정 기능] 이미 리스트에 있으면 수량/비고만 업데이트
  IsUpdate := False;
  IntPos := 0;

  for IntRow := 1 to InResGrid.RowCount - 1 Do
  Begin
    if InResGrid.Cells[1, IntRow] <> '' then
    begin
        If (StrOldPlt = InResGrid.Cells[10, IntRow]) And
           (StrItnbr  = InResGrid.Cells[2,  IntRow]) And
           (StrLotno  = InResGrid.Cells[4,  IntRow]) Then
        Begin
           IsUpdate := True;
           IntPos := IntRow; // 수정할 행 번호 저장
           Break; 
        End;
    end;
  End;

  // 수정 모드
  if IsUpdate then
  begin
      if WinLib_ConfirmForm('이미 목록에 있는 항목입니다. 수량과 내용을 수정하시겠습니까?') then
      begin
          // 해당 행의 데이터 갱신
          InResGrid.Cells[5, IntPos]  := FormatFloat('#,##0.00', NumQty); // 수량 수정
          InResGrid.Cells[6, IntPos]  := BoxnoEdit.Text;                
          InResGrid.Cells[7, IntPos]  := BigoEdit.Text;                 
          
          // 입력창 초기화 (일부만)
          ItnbrEdit.Text     := '';
          NameEdit.Text      := '';
          LotnoEdit.Text     := '';
          WeightEdit.Text    := '';
          DAteEdit.Text      := '';
          TimeEdit.Text      := '';
          OindexEdit.Text    := ''; 
          BigoEdit.Text      := '';
          BoxnoEdit.Text     := '';
      end;
      Exit; // 수정 후 종료
  end;

  // [신규 추가]
  IntPos := InResGrid.RowCount;
  IF InResGrid.Cells[1, IntPos - 1] <> '' then
  begin
     InResGrid.RowCount := IntPos + 1;
     IntPos := IntPos + 1;
  end;

  InResGrid.Cells[1, IntPos - 1]  := pltnoEdit.text;                
  InResGrid.Cells[2, IntPos - 1]  := itnbrEdit.text;                
  InResGrid.Cells[3, IntPos - 1]  := NameEdit.text;                 
  InResGrid.Cells[4, IntPos - 1]  := LotnoEdit.Text;                
  InResGrid.Cells[5, IntPos - 1]  := FormatFloat('#,##0.00', NumQty); 
  InResGrid.Cells[6, IntPos - 1]  := BoxnoEdit.Text;                
  InResGrid.Cells[7, IntPos - 1]  := BigoEdit.Text;                 
  InResGrid.Cells[8, IntPos - 1]  := DAteEdit.Text;                 
  InResGrid.Cells[9, IntPos - 1]  := TimeEdit.Text;                 
  InResGrid.Cells[10, IntPos - 1] := OindexEdit.Text;               

  // 입력창 초기화
  ItnbrEdit.Text     := '';
  NameEdit.Text      := '';
  LotnoEdit.Text     := '';
  WeightEdit.Text    := '';
  DAteEdit.Text      := '';
  TimeEdit.Text      := '';
  OindexEdit.Text    := ''; 
  BigoEdit.Text      := '';
  BoxnoEdit.Text     := '';
End;

{
procedure TFrm_3200.CancelSBClick(Sender: TObject);
var
    m_Row, i, j : Integer;
    StrMsg : string;
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

procedure TFrm_3200.CancelSBClick(Sender: TObject);
var
    m_Row, i, j : Integer;
    StrMsg : string;
begin
  If InResGrid.row = 0 Then  Exit;
  If InResGrid.Cells[1, InResGrid.Row] = '' Then Begin
    StrMsg := ' 삭제할 데이타가 없습니다....' + #13#10 + '데이타를 선택한 후 다시 하십시요!!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;
  
  StrMsg := ' 현재 라인을 삭제 하겠습니까 ? ';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin
    Exit;
  End;

  m_Row := InResGrid.Row;

  // [기능 추가] 삭제되는 행의 데이터를 입력창으로 복구 (Un-do)
  pltnoEdit.Text     := InResGrid.Cells[1, m_Row];  // PLT-NO
  ItnbrEdit.Text     := InResGrid.Cells[2, m_Row];  // 품목코드
  NameEdit.Text      := InResGrid.Cells[3, m_Row];  // 품명
  LotnoEdit.Text     := InResGrid.Cells[4, m_Row];  // LOT-NO
  WeightEdit.Text    := InResGrid.Cells[5, m_Row];  // 수량 (콤마 포함 그대로)
  BoxnoEdit.Text     := InResGrid.Cells[6, m_Row];  // BOX-NO
  BigoEdit.Text      := InResGrid.Cells[7, m_Row];  // 비고
  DAteEdit.Text      := InResGrid.Cells[8, m_Row];  // 입고일자
  TimeEdit.Text      := InResGrid.Cells[9, m_Row];  // 입고시간
  OindexEdit.Text    := InResGrid.Cells[10, m_Row]; // 기PLT-NO

  // -------------------------------------------------------------
  // 그리드 행 삭제 로직 (기존 유지)
  for j := m_Row to  InResGrid.RowCount-2 do
  begin
      for i := 0 to     InResGrid.ColCount-1  do
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
  
  // 포커스를 수량 입력창으로 이동 (바로 수정 가능하도록)
  WeightEdit.SetFocus;
end;

procedure TFrm_3200.DataGridDrawCell(Sender: TObject; ACol, ARow: Integer;
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
      if (ACol = 4)   Then Begin
        OldAlign := SetTextAlign (TStringGrid(Sender).Canvas.Handle, ta_right);
        TStringGrid(Sender).Canvas.TextRect(Rect, Rect.right-2, Rect.top+2, TStringGrid(Sender).Cells[ACol,ARow]);
        SetTextAlign(TStringGrid(Sender).Canvas.Handle, OldAlign);
      End;
    End;
  End;
end;



procedure TFrm_3200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_3200.FormDestroy(Sender: TObject);
begin
  Frm_3200 := Nil;
end;

procedure TFrm_3200.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;


procedure TFrm_3200.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;

end;

procedure TFrm_3200.MouseWheelHandler(var Message: TMessage);
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

function TFrm_3200.f_get_sysdate_time1(): String;
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

procedure TFrm_3200.DBGrid2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    Value, ls_hogi : String;
    WW    : Integer;
begin
  if not Query3.Active then Exit;
  If DataCol = 0 Then
  begin
   with(Sender as TDBGrid).Canvas do
   begin
    Value := IntToStr(Query3.RecNo);
    WW    := Canvas.TextWidth(value);
    TextOut(Rect.Left+(Rect.Right - Rect.Left - WW) div 2, Rect.Top+2,Value);
   end;
  end;

  ls_hogi := Query3.FieldByName('OUPT_HOGI').AsString;

  If DataCol = 3 Then
  begin
   with(Sender as TDBGrid).Canvas do
   begin
     FillRect(Rect);
     
     Value := ls_hogi;
     WW    := Canvas.TextWidth(value);
     TextOut(Rect.Left+(Rect.Right - Rect.Left - WW) div 2, Rect.Top+2,Value);
   end;
  end;
end;


procedure TFrm_3200.DBGrid2CellClick(Column: TColumn);

begin

   ItnbrEdit.Text    := Query3.FieldByName('SUBK_CODE').AsString;   // 품목코드
   NameEdit.Text     := Query3.FieldByName('MAST_NAME').AsString;   // 품명
   LotnoEdit.Text    := Query3.FieldByName('SUBK_LOTNO').AsString;  // LOT번호

   WeightEdit.Text   := FloatToStr(Query3.FieldByName('SUBK_WGT').AsFloat);

   DateEdit.Text     := Query3.FieldByName('OUPT_INDATE').AsString;
   TimeEdit.Text     := Query3.FieldByName('OUPT_INTIME').AsString;

   OindexEdit.Text  := Query3.FieldByName('SUBK_PLTNO').AsString;

   BigoEdit.Text     := Query3.FieldByName('SUBK_REMARK').AsString; // 비고
   BoxnoEdit.Text    := Query3.FieldByName('SUBK_BOXNO').AsString;  // 박스번호
end;

{
procedure TFrm_3200.ReservedSBClick(Sender: TObject);
var
  IntPos : Integer;
  StrQry : String;
  StrNewPlt, StrOldPlt, StrItnbr, StrLotno, StrQty, StrBoxNo, StrBigo : String;
  StrMsg : String;
  TargetSourcePLT : String;
  TotalSourceCnt, CurrentMoveCnt : Integer;
  SaveBookMark: TBookmark;
begin
  If (InResGrid.RowCount < 2) or (InResGrid.Cells[1, 1] = '') Then Begin
    StrMsg := '저장할 데이터가 없습니다.';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  //잔여 수량 체크
  TargetSourcePLT := Trim(InResGrid.Cells[10, 1]); 

  if (TargetSourcePLT <> '') and (Query3.Active) then
  begin
      TotalSourceCnt := 0;
      CurrentMoveCnt := InResGrid.RowCount - 1; 

      Query3.DisableControls;
      SaveBookMark := Query3.GetBookmark;
      Try
        Query3.First;
        While not Query3.Eof do
        begin
           if Trim(Query3.FieldByName('SUBK_PLTNO').AsString) = TargetSourcePLT then
           begin
              Inc(TotalSourceCnt);
           end;
           Query3.Next;
        end;
      Finally
        if Query3.BookmarkValid(SaveBookMark) then
           Query3.GotoBookmark(SaveBookMark);
        Query3.FreeBookmark(SaveBookMark);
        Query3.EnableControls;
      End;

      if TotalSourceCnt > CurrentMoveCnt then
      begin
         StrMsg := '작업 불가: 해당 기PLT(' + TargetSourcePLT + ')의 모든 항목을 이동해야 합니다.' + #13#10 + 
                   '빠진 항목을 모두 추가해주세요.';
         WinLib_ErrorForm(StrMsg);
         Exit; 
      end;
  end;
  
  StrMsg := '총 ' + IntToStr(InResGrid.RowCount - 1) + '건을 저장(PLT 변경) 하시겠습니까?';
  if Not WinLib_ConfirmForm( StrMsg ) then Exit;

  For IntPos := 1 To InResGrid.RowCount - 1 Do
  Begin
    If InResGrid.Cells[1, IntPos] = '' Then Continue;

    StrNewPlt := InResGrid.Cells[1, IntPos];
    StrItnbr  := InResGrid.Cells[2, IntPos];  
    StrLotno  := InResGrid.Cells[4, IntPos];
    StrBoxNo  := InResGrid.Cells[6, IntPos];
    StrBigo   := InResGrid.Cells[7, IntPos];
    StrOldPlt := InResGrid.Cells[10, IntPos];

    StrQry := ' UPDATE T2MISUBK SET ';
    StrQry := StrQry + '    SUBK_PLTNO = ''' + StrNewPlt + ''' ';
    StrQry := StrQry + '    , SUBK_BOXNO  = ''' + StrBoxNo  + ''' ';
    StrQry := StrQry + '    , SUBK_REMARK = ''' + StrBigo   + ''' ';
    StrQry := StrQry + ' WHERE SUBK_PLTNO = ''' + StrOldPlt + ''' '; 
    StrQry := StrQry + '   AND SUBK_CODE  = ''' + StrItnbr  + ''' '; 
    StrQry := StrQry + '   AND SUBK_LOTNO = ''' + StrLotno  + ''' ';

    Try
      With UpdtQuery Do Begin
        Close;
        SQL.Clear;
        SQL.Add(StrQry);
        ExecSql;
      End;
    Except
       Showmessage('DB 저장 오류: ' + StrQry); Exit;
    End;
  End; 

  // 저장 완료 처리
  WinLib_ErrorForm('저장이 완료되었습니다.');

  InResGrid_Clear_Proc;
  StartBitBtnClick(Self); // 재조회
  // 입력창 초기화
  pltnoEdit.Text    := '';
  ItnbrEdit.Text    := '';
  NameEdit.Text     := '';
  LotnoEdit.Text    := '';
  WeightEdit.Text   := '';
  DAteEdit.Text     := '';
  TimeEdit.Text     := '';
  OindexEdit.Text   := '';
  BigoEdit.Text     := '';
  BoxnoEdit.Text    := '';


  pltnoEdit.SetFocus;
end;
}
procedure TFrm_3200.ReservedSBClick(Sender: TObject);
var
  IntPos : Integer;
  StrQry : String;
  // [변수 추가] StrWgt 추가
  StrNewPlt, StrOldPlt, StrItnbr, StrLotno, StrBoxNo, StrBigo, StrWgt : String;
  StrMsg : String;
  TargetSourcePLT : String;
  TotalSourceCnt, CurrentMoveCnt : Integer;
  SaveBookMark: TBookmark;
begin
  If (InResGrid.RowCount < 2) or (InResGrid.Cells[1, 1] = '') Then Begin
    StrMsg := '저장할 데이터가 없습니다.';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  // 1. 잔여 수량 체크 (기존 로직 유지)
  TargetSourcePLT := Trim(InResGrid.Cells[10, 1]); 

  if (TargetSourcePLT <> '') and (Query3.Active) then
  begin
      TotalSourceCnt := 0;
      CurrentMoveCnt := InResGrid.RowCount - 1; 

      Query3.DisableControls;
      SaveBookMark := Query3.GetBookmark;
      Try
        Query3.First;
        While not Query3.Eof do
        begin
            if Trim(Query3.FieldByName('SUBK_PLTNO').AsString) = TargetSourcePLT then
            begin
               Inc(TotalSourceCnt);
            end;
            Query3.Next;
        end;
      Finally
        if Query3.BookmarkValid(SaveBookMark) then
           Query3.GotoBookmark(SaveBookMark);
        Query3.FreeBookmark(SaveBookMark);
        Query3.EnableControls;
      End;

      if TotalSourceCnt > CurrentMoveCnt then
      begin
         StrMsg := '작업 불가: 해당 기PLT(' + TargetSourcePLT + ')의 모든 항목을 이동해야 합니다.' + #13#10 + 
                   '빠진 항목을 모두 추가해주세요.';
         WinLib_ErrorForm(StrMsg);
         Exit; 
      end;
  end;
  
  StrMsg := '총 ' + IntToStr(InResGrid.RowCount - 1) + '건을 저장(PLT 변경 및 수정) 하시겠습니까?';
  if Not WinLib_ConfirmForm( StrMsg ) then Exit;

  // 2. 루프 돌면서 업데이트 실행
  For IntPos := 1 To InResGrid.RowCount - 1 Do
  Begin
    If InResGrid.Cells[1, IntPos] = '' Then Continue;

    StrNewPlt := InResGrid.Cells[1, IntPos];
    StrItnbr  := InResGrid.Cells[2, IntPos];  
    StrLotno  := InResGrid.Cells[4, IntPos];
    
    // [추가] 수량(중량) 가져오기 및 콤마 제거
    StrWgt    := InResGrid.Cells[5, IntPos];
    While Pos(',', StrWgt) > 0 Do Delete(StrWgt, Pos(',', StrWgt), 1);
    if Trim(StrWgt) = '' then StrWgt := '0';

    StrBoxNo  := InResGrid.Cells[6, IntPos];
    StrBigo   := InResGrid.Cells[7, IntPos];
    StrOldPlt := InResGrid.Cells[10, IntPos];

    StrQry := ' UPDATE T2MISUBK SET ';
    StrQry := StrQry + '    SUBK_PLTNO  = ''' + StrNewPlt + ''' ';
    
    // [중요] 수량 업데이트 구문 추가
    StrQry := StrQry + '  , SUBK_WGT    =  '  + StrWgt    + '   '; 
    // 예약수량(RWGT)도 동일하게 맞춰야 한다면 아래 주석 해제 (보통 이동시엔 같이 감)
    // StrQry := StrQry + '  , SUBK_RWGT   =  '  + StrWgt    + '   '; 
    
    StrQry := StrQry + '  , SUBK_BOXNO  = ''' + StrBoxNo  + ''' ';
    StrQry := StrQry + '  , SUBK_REMARK = ''' + StrBigo   + ''' ';
    
    // 조건절 (기존 PLT + 품목 + LOT)
    StrQry := StrQry + ' WHERE SUBK_PLTNO = ''' + StrOldPlt + ''' '; 
    StrQry := StrQry + '   AND SUBK_CODE  = ''' + StrItnbr  + ''' '; 
    StrQry := StrQry + '   AND SUBK_LOTNO = ''' + StrLotno  + ''' ';

    Try
      With UpdtQuery Do Begin
        Close;
        SQL.Clear;
        SQL.Add(StrQry);
        ExecSql;
      End;
    Except
       Showmessage('DB 저장 오류: ' + StrQry); Exit;
    End;
  End; 

  // 저장 완료 처리
  WinLib_ErrorForm('저장이 완료되었습니다.');

  InResGrid_Clear_Proc;
  StartBitBtnClick(Self); // 재조회
  
  // 입력창 초기화
  pltnoEdit.Text    := '';
  ItnbrEdit.Text    := '';
  NameEdit.Text     := '';
  LotnoEdit.Text    := '';
  WeightEdit.Text   := '';
  DAteEdit.Text     := '';
  TimeEdit.Text     := '';
  OindexEdit.Text   := '';
  BigoEdit.Text     := '';
  BoxnoEdit.Text    := '';

  pltnoEdit.SetFocus;
end;
procedure TFrm_3200.DBGrid2TitleClick(Column: TColumn);
begin
    if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

end.


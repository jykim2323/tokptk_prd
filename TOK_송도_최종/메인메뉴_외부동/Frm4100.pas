unit Frm4100;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, ADODB, DB, DBTables,
  Mask, Winsock, BaseGrid, AdvGrid;

type
  TFrm_4100 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    ResvGBox: TGroupBox;
    Shape2: TShape;
    Label1: TLabel;
    QtyEdit: TEdit;
    Panel2: TPanel;
    ItemEdit: TEdit;
    SpecNameEdit: TEdit;
    Panel4: TPanel;
    LocaEdit: TEdit;
    GroupBox2: TGroupBox;
    Panel9: TPanel;
    NameEdit: TEdit;
    ExecSb: TSpeedButton;
    ExitSP: TSpeedButton;
    Panel6: TPanel;
    RqtyEdit: TEdit;
    Panel7: TPanel;
    ItemCodeMed: TEdit;
    Query1: TADOQuery;
    UpdtQuery: TADOQuery;
    StatQuery: TADOQuery;
    Panel5: TPanel;
    Panel8: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Query2: TADOQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Query1SUBK_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1SUBK_WGT: TBCDField;
    Query1SUBK_LOTNO: TStringField;
    Query1SUBK_LOCA: TStringField;
    Query1SUBK_INDATE: TStringField;
    Query1SUBK_INTIME: TStringField;
    Query2SUBK_CODE: TStringField;
    Query2MAST_NAME: TStringField;
    Query2SUBK_WGT: TBCDField;
    Query2SUBK_LOTNO: TStringField;
    Query2SUBK_LOCA: TStringField;
    Query2SUBK_INDATE: TStringField;
    Query2SUBK_INTIME: TStringField;
    Query2SUBK_FLAG: TStringField;
    Query2SUBK_RWGT: TBCDField;
    StartBitBtn: TSpeedButton;
    Panel10: TPanel;
    LotnoEdit: TEdit;
    DispQuery: TADOQuery;
    Code_Search: TSpeedButton;
    Query1SUBK_REMARK: TStringField;
    Query2SUBK_REMARK: TStringField;
    Panel3: TPanel;
    BigoEdit: TEdit;
    Panel11: TPanel;
    BoxNoEdit: TEdit;
    Panel14: TPanel;
    CustEdit: TEdit;
    Panel12: TPanel;
    BoxNo1Edit: TEdit;
    Panel13: TPanel;
    Bigo1Edit: TEdit;
    Query1SUBK_BOXNO: TStringField;
    Query2SUBK_BOXNO: TStringField;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Panel15: TPanel;
    Edit2: TEdit;
    Panel16: TPanel;
    Edit3: TEdit;
    Rb1: TRadioButton;
    Rb2: TRadioButton;
    Rb3: TRadioButton;
    Rb4: TRadioButton;
    Rb5: TRadioButton;
    Rb6: TRadioButton;
    IO1Lbl: TLabel;
    IO2Lbl: TLabel;
    Panel17: TPanel;
    pltnoEdit: TEdit;
    Query1SUBK_PLTNO: TStringField;
    Label7: TLabel;
    Panel18: TPanel;
    ClearSB: TSpeedButton;
    ConfirmBitBtn: TSpeedButton;
    CancelSB: TSpeedButton;
    Panel19: TPanel;
    Panel20: TPanel;
    indateEdit: TEdit;
    intimeEdit: TEdit;
    sDateQuery: TADOQuery;
    Panel21: TPanel;
    realtimeQtyEdit: TEdit;
    OutSG: TAdvStringGrid;
    Panel22: TPanel;
    srcLotNoEdit: TEdit;
    baroSb: TSpeedButton;
    EmgCheckBox: TCheckBox;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExecSbClick(Sender: TObject);    
    procedure ExitSPClick(Sender: TObject);
    procedure RqtyEditChange(Sender: TObject);  
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure Query2SUBK_GUBUNGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure Code_SearchClick(Sender: TObject);

    procedure DBGrid1TitleClick(Column: TColumn);
    procedure RqtyEditKeyPress(Sender: TObject; var Key: Char);
    procedure CancelSBClick(Sender: TObject);
    procedure ClearSBClick(Sender: TObject);
    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure OutSGGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure OutSGGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure NameEditKeyPress(Sender: TObject; var Key: Char);
    procedure srcLotNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure baroSbClick(Sender: TObject);
    procedure ItemCodeMedKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    function f_get_sysdate_time(): String;

    procedure Output_Resv_Proc;    
    procedure Out_Grid_Clear_Proc;
    procedure OutLetData_Insert_Proc;
    //procedure Insert_Sche_Proc(OutIndex, OutLoca, OutGubun: String);
    procedure Insert_Sche_Proc(OutIndex, OutLoca, OutGubun, OutWsno, OutPltno: String);
    procedure Replace_Table_Flag;

    procedure MouseWheelHandler(var Message: TMessage); override;

    //procedure Data_Confirm_Proc; 1029
    procedure Pltno_Select_Proc;
    procedure Jisi_Select_Proc;
    procedure itemClear;
    //procedure ReinPut_Data_Proc(OutPltNo, OutIndex, OutLoca : String);  1029
    //procedure Insert_T2TISCHE_Proc(OutPltNo, OutIndex, OutLoca, OutType : String);  1029
    
  public
    { Public declarations }
  end;

var
  Frm_4100: TFrm_4100;

  Var_Form : TForm;
  Read_ok : Boolean;
  Bol_Data_Ok : Boolean;


  StrQry : String;
  StrMsg : String;
  S_Date, S_Time, s_loca, s_wsno : String;

  IntPos,  IntRow : integer;  
implementation

uses DbSet, WinLib, FrmPrompt, FrmError,FrmProgress, MastDisp;

{$R *.dfm}


procedure TFrm_4100.FormCreate(Sender: TObject);
begin

  if (jj_kind <> '50') then
  begin
    ExecSb.Visible    := False;
  end;
  
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;



  EmgCheckBox.Checked := False; 
  Out_Grid_Clear_Proc;
  StartBtnClick(Self);
end;

procedure TFrm_4100.Out_Grid_Clear_Proc;
var
  IntCnt : Integer;
begin
   OutSG.Cells[1,0]  := '저장위치';
   OutSG.Cells[2,0]  := 'PLTNO';
   OutSG.Cells[3,0]  := '품목코드';
   OutSG.Cells[4,0]  := '품 목 명';
   OutSG.Cells[5,0]  := 'LOT-NO';
   OutSG.Cells[6,0]  := 'BOX-NO';
   OutSG.Cells[7,0]  := '비  고';
   OutSG.Cells[8,0]  := '재고수량';
   OutSG.Cells[9,0]  := '지시수량';
   OutSG.Cells[10,0]  := '납품처';
   OutSG.Cells[11,0] := '출고 BOX-NO';
   OutSG.Cells[12,0] := '출고 비고';
   OutSG.Cells[13,0] := 's_wsno';
   OutSG.Cells[14,0] := 'subk_indate';
   OutSG.Cells[15,0] := 'subk_intime';

   OutSG.ColWidths[0] := 8;
   OutSG.ColWidths[1] := 80;   // 저장위치
   OutSG.ColWidths[2] := 80;   // PLTNO
   OutSG.ColWidths[3] := 100;  // 품목코드
   OutSG.ColWidths[4] := 200;  // 품목명
   OutSG.ColWidths[5] := 150;  // LOT-NO
   OutSG.ColWidths[6] := 100;  // BOX-NO
   OutSG.ColWidths[7] := 200;  // 비 고
   OutSG.ColWidths[8] := 80;   // 재고수량
   OutSG.ColWidths[9] := 80;   // 지시수량
   OutSG.ColWidths[10] := 100; // 납품처
   OutSG.ColWidths[11] := 120; // 출고 BOX-NO
   OutSG.ColWidths[12] := 200; // 출고 비고
   OutSG.ColWidths[13] := 0;   // s_wsno(출고대)
   OutSG.ColWidths[14] := 0;   // subk_indate 입고일
   OutSG.ColWidths[15] := 0;   // subk_intime 입고시간 

   OutSG.RowCount := 2;

  With OutSG Do Begin
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
     Cells[11,IntCnt]  := '';
    End;
  End;
  OutSG.RowCount := 2;
end;

procedure TFrm_4100.StartBtnClick(Sender: TObject);
var
  StrCode, StrCodeNm, StrLotNo : String;
begin

  StrCode := Trim(ItemCodeMed.Text);
  StrLotNo := Trim(srcLotNoEdit.Text); // [추가] LOT 검색어 가져오기
  StrCodeNm := Trim(NameEdit.Text);
           
  StrQry := ' Select   SUBK_CODE, MAST_NAME, SUBK_WGT, SUBK_LOTNO, SUBK_LOCA, SUBK_INDATE, SUBK_INTIME, SUBK_BOXNO, SUBK_REMARK, SUBK_PLTNO '; 
  StrQry := StrQry + ' From T2MISUBK (NOLOCK) ';
  StrQry := StrQry + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = subk_code ';
  StrQry := StrQry + ' LEFT OUTER JOIN T2MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA ';
  StrQry := StrQry + ' Where ISNULL(SUBK_CODE, '''') <> '''' And LSTK_FLAG = ''1''  ';
  StrQry := StrQry + ' And SUBK_FLAG = ''1'' ';


  if StrCode <> '' then
     //StrQry := StrQry + ' And SUBK_CODE like ''%' + StrCode + '%''     ';
     StrQry := StrQry + ' AND SUBK_CODE = ''' + StrCode + ''' '; // 고객사 요청사항 

  if StrCodeNm <> '' then
     StrQry := StrQry + ' And MAST_NAME like ''%' + StrCodeNm + '%''     ';

  if StrLotNo <> '' then
     StrQry := StrQry + ' And SUBK_LOTNO like ''%' + StrLotNo + '%''   ';

  StrQry := StrQry + ' Order By  SUBK_LOCA, SUBK_PLTNO, SUBK_CODE, SUBK_BOXNO, SUBK_INDATE, SUBK_INTIME, SUBK_LOTNO ';

  With Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    First;
    {
    if RecordCount = 0 Then Begin
      StrMsg := '조건에 맞는 재고가 없습니다...... ';
      WinLib_ErrorForm( StrMsg );
      Exit;
    End;
    }
  End;         // End of With
end;


procedure TFrm_4100.Jisi_Select_Proc;
var
  li_qty, bi_qty, li_bqty, bi_bqty : Real;
  ls_qty, ls_bqty : String;
  Chk_Pos : Integer;
begin
  li_qty :=0;  bi_qty :=0; li_bqty :=0;  bi_bqty :=0;
  
  for Chk_Pos := 1 to OutSG.RowCount - 1 Do
  Begin
    ls_qty := Trim(OutSG.Cells[8, Chk_Pos]);
    ls_bqty := Trim(OutSG.Cells[9, Chk_Pos]);

    While pos(',', ls_qty) > 0 Do Begin Delete(ls_qty, pos(',', ls_qty), 1); End;
    While pos(',', ls_bqty) > 0 Do Begin Delete(ls_bqty, pos(',', ls_bqty), 1); End;

    if ls_qty = '' then  bi_qty  := 0 else bi_qty  := StrToFloat(ls_qty);

    if ls_bqty = '' then  bi_bqty  := 0 else bi_bqty  := StrToFloat(ls_bqty);


    li_qty   := li_qty + bi_qty;
    li_bqty  := li_bqty + bi_bqty;
  End;

   //StockEd.caption  := FormatFloat('###,##0.##', li_qty);
   //BoxQtyEd.caption := FormatFloat('###,##0.##', li_bqty);
end;

procedure TFrm_4100.DataSource1DataChange(Sender: TObject; Field: TField);
begin
   s_loca       := Query1.FieldByName('SUBK_LOCA').AsString;
   Pltno_Select_Proc;
end;

procedure TFrm_4100.Pltno_Select_Proc;
var
  StrCode : String;
begin
  if(Trim(s_loca) = '') then exit;

  StrQry := ' Select   SUBK_CODE, MAST_NAME, SUBK_WGT, SUBK_LOTNO, SUBK_LOCA, SUBK_INDATE,  ';
  StrQry := StrQry + ' SUBK_FLAG, SUBK_RWGT, SUBK_INTIME, SUBK_REMARK, SUBK_BOXNO ';
  StrQry := StrQry + ' From T2MISUBK (NOLOCK) ';
  StrQry := StrQry + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = subk_code ';
  StrQry := StrQry + ' Where ISNULL(SUBK_CODE, '''') <> ''''  ';
  StrQry := StrQry + ' And SUBK_LOCA = '''+s_loca+'''    ';


  With Query2 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    First;
  End;
end;

 
procedure TFrm_4100.DBGrid1DblClick(Sender: TObject);
var
  ls_qty, ls_loca : String;
  li_Qty, li_bQty, li_stokQty, li_jisiQty, AmtQty : Real;

  Chk_Pos  : Integer;
  mps_r_ch01: String[16];    mps_r_ch03: String[16];      mps_r_ch05: String[16];
begin
   ls_loca    := Trim(Query1.FieldByName('SUBK_LOCA').AsString);
   //ls_loca := Copy(ls_loca,1,1) + '-' +  Copy(ls_loca,2,2) + '-' +  Copy(ls_loca,4,2) + '-' +  Copy(ls_loca,6,2);

   If ls_loca = '' Then Begin
    StrMsg := '출고 작업할 데이타가 없습니다...'+#13#10+ ' 확인후 다시 시도 하십시요';
    WinLib_ErrorForm( StrMsg );  Exit;
    Exit;
   End;

   ResvGBox.Visible := True;

   Rb1.Checked := False;     Rb2.Checked := False;      Rb3.Checked := False;
   Rb4.Checked := False;     Rb5.Checked := False;      Rb6.Checked := False;

   LocaEdit.Text        := Query1.FieldByName('SUBK_LOCA').AsString;
   PltNoEdit.Text       := Query1.FieldByName('SUBK_PLTNO').AsString;
   LOtnoEdit.Text       := Query1.FieldByName('SUBK_LOTNO').AsString;
   ItemEdit.Text        := Query1.FieldByName('SUBK_CODE').AsString;
   SpecNameEdit.Text    := Query1.FieldByName('MAST_NAME').AsString;
   BigoEdit.Text        := Query1.FieldByName('SUBK_REMARK').AsString;
   BoxnoEdit.Text       := Query1.FieldByName('SUBK_BOXNO').AsString;
   indateEdit.Text      := Query1.FieldByName('SUBK_INDATE').AsString;
   intimeEdit.Text      := Query1.FieldByName('SUBK_INTIME').AsString;

   li_Qty := Query1.FieldByName('SUBK_WGT').AsFloat;

   realtimeQtyEdit.Text := FormatFloat('###,###,##0.00', li_Qty); // 예약수량 계산하지 않은 실 재고

   li_stokQty := 0;   li_jisiQty := 0;

   for Chk_Pos := 1 to OutSG.RowCount - 1 Do
   Begin
     if (OutSG.Cells[1, Chk_Pos] = LocaEdit.Text)   and
        (OutSG.Cells[2, Chk_Pos] = PltnoEdit.Text)  and
        (OutSG.Cells[3, Chk_Pos] = ItemEdit.Text)   and
        (OutSG.Cells[5, Chk_Pos] = LotnoEdit.Text) then

     begin
        ls_qty  := OutSG.Cells[8, Chk_Pos];
        While Pos(',', ls_qty) > 0 Do Begin Delete(ls_qty, Pos(',', ls_qty), 1); End;
        li_stokQty :=  StrToFloat(ls_qty);   // 출고예약 재고 수량

        ls_qty  := OutSG.Cells[9, Chk_Pos];
        While Pos(',', ls_qty) > 0 Do Begin Delete(ls_qty, Pos(',', ls_qty), 1); End;
        li_jisiQty :=  li_jisiQty + StrToFloat(ls_qty); // 출고예약 지시 수량
     end;
   end;

   li_Qty := li_Qty - li_jisiQty; // 재고 수량 - 출고예약 지시수량 
   RQtyEdit.Text := FormatFloat('###,###,##0.00', li_Qty);

   QtyEdit.Text  := FormatFloat('###,###,##0.00', li_Qty);   // 재고 - 예약 지시수량

   if (Copy(ls_loca,1,1) = '1') or (Copy(ls_loca,1,1) = '2') then
   begin
     StrQry := ' Select CVC1_CH01 From T2TBCVC1 (NOLOCK) Where CVC1_SR = ''R'' ';
     With DispQuery Do Begin
       Close;
       SQL.Clear;
       SQL.Add(StrQry);
       Open;
       mps_r_ch01 := FieldByName('CVC1_CH01').AsString;
     End;

     if  (Copy(mps_r_ch01,10,1) = '1') then IO1Lbl.Caption := '[입고모드]'
     else if  (Copy(mps_r_ch01,12,1) = '1') then IO1Lbl.Caption := '[출고모드]'
     else IO1Lbl.Caption := '';

     if  (Copy(mps_r_ch01,11,1) = '1') then IO2Lbl.Caption := '[입고모드]'
     else  if  (Copy(mps_r_ch01,13,1) = '1') then IO2Lbl.Caption := '[출고모드]'
     else  IO2Lbl.Caption := '';
     Rb1.Enabled := True;    Rb2.Enabled := True;
     Rb2.Checked := True;    // Defualt Rb2 선택

     Rb3.Enabled := False;   Rb4.Enabled := False;
     Rb5.Enabled := False;   Rb6.Enabled := False;

     Rb1.Visible := True;    Rb2.Visible := True;
     Rb3.Visible := False;   Rb4.Visible := False;
     Rb5.Visible := False;   Rb6.Visible := False;
   end
   else if (Copy(ls_loca,1,1) = '3') or (Copy(ls_loca,1,1) = '4') then
   begin
     StrQry := ' Select CVC2_CH01  From T2TBCVC2 (NOLOCK) Where CVC2_SR = ''R'' ';
     With DispQuery Do Begin
       Close;
       SQL.Clear;
       SQL.Add(StrQry);
       Open;
       mps_r_ch03 := FieldByName('CVC2_CH01').AsString;
     End;

     if  (Copy(mps_r_ch03,10,1) = '1') then IO1Lbl.Caption := '[입고모드]'
     else  if  (Copy(mps_r_ch03,12,1) = '1') then IO1Lbl.Caption := '[출고모드]'
     else  IO1Lbl.Caption := '';

     if  (Copy(mps_r_ch03,11,1) = '1') then IO2Lbl.Caption := '[입고모드]'
     else  if  (Copy(mps_r_ch03,13,1) = '1') then IO2Lbl.Caption := '[출고모드]'
     else  IO2Lbl.Caption := '';
     Rb1.Enabled := False;   Rb2.Enabled := False;
     Rb3.Enabled := True;    Rb4.Enabled := True;
     Rb4.Checked := True;    // Defualt Rb4 선택
     Rb5.Enabled := False;   Rb6.Enabled := False;

     Rb1.Visible := False;   Rb2.Visible := False;
     Rb3.Visible := True;    Rb4.Visible := True;
     Rb5.Visible := False;   Rb6.Visible := False;
   end
   else if (Copy(ls_loca,1,1) = '5') or (Copy(ls_loca,1,1) = '6') then
   begin
     StrQry := ' Select CVC3_CH01  From T2TBCVC3 (NOLOCK) Where CVC3_SR = ''R'' ';
     With DispQuery Do Begin
       Close;
       SQL.Clear;
       SQL.Add(StrQry);
       Open;
       mps_r_ch05 := FieldByName('CVC3_CH01').AsString;
     End;

     if  (Copy(mps_r_ch05,10,1) = '1') then IO1Lbl.Caption := '[입고모드]'
     else  if  (Copy(mps_r_ch05,12,1) = '1') then IO1Lbl.Caption := '[출고모드]'
     else  IO1Lbl.Caption := '';

     if  (Copy(mps_r_ch05,11,1) = '1') then IO2Lbl.Caption := '[입고모드]'
     else  if  (Copy(mps_r_ch05,13,1) = '1') then IO2Lbl.Caption := '[출고모드]'
     else  IO2Lbl.Caption := '';
     Rb1.Enabled := False;   Rb2.Enabled := False;
     Rb3.Enabled := False;   Rb4.Enabled := False;
     Rb5.Enabled := True;    Rb6.Enabled := True;
     Rb6.Checked := True;    // Defualt Rb6 선택
     Rb1.Visible := False;   Rb2.Visible := False;
     Rb3.Visible := False;   Rb4.Visible := False;
     Rb5.Visible := True;    Rb6.Visible := True;
   end
   else Exit;
end;


procedure TFrm_4100.RqtyEditChange(Sender: TObject);
var
  StrRQty, StrQty : String;
  NumQty,  NumStockQty, li_Qty, li_EditBqty : Real;
begin
  if QtyEdit.Text = ''    Then  Exit;
  if RQtyEdit.Text = '' Then Exit;

  StrQty := QtyEdit.Text;



  While pos(',', StrQty) > 0 Do Begin Delete(StrQty, pos(',', StrQty), 1); End;
  NumQty := StrToFloat(StrQty);

  StrRQty := RQtyEdit.Text;
  While pos(',', StrRQty) > 0 Do Begin Delete(StrRQty, pos(',', StrRQty), 1); End;
  NumStockQty := StrToFloat(StrRQty);

  if NUmStockQty > NumQty   Then Begin
    StrMsg := '출고 수량이 재고수량을 초과 하였습니다..... ';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  QtyEdit.Text := FormatFloat('###,###,##0.00', Numqty);
end;
// 신규 추가 실행 버튼
// 실행시 하단 Grid에 출고할 데이터를 쌓음 후에 출고예약 버튼 클릭시 출고예약 실행
procedure TFrm_4100.ExecSbClick(Sender: TObject);
var
  IntPos, r : Integer;
  mps_r_ch01: String[16];  mps_r_ch02: String[16];  mps_r_ch03: String[16];
  mps_r_ch04: String[16];  mps_r_ch05: String[16];  mps_r_ch06: String[16];
  ls_bank, outSgWsno : String;
  numQty, numRQty, numRealTimeQty : Real;
begin
  if Query1.FieldByName('SUBK_LOCA').AsString = '' Then Begin
    StrMsg := '출고작업할 데이타가 없습니다....' + #13#10 + '출고 데이타를 입력 후 다시 시도 하십시요!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  if (QtyEdit.Text = '') or (Length(QtyEdit.Text) = 0) or (StrToFloat(QtyEdit.Text) <= 0) then
  Begin
    StrMsg := '출고 가능한 재고가 없습니다...!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  if (RQtyEdit.Text = '') or (Length(RQtyEdit.Text) = 0) or (StrToFloat(RQtyEdit.Text) <= 0) then
  Begin
    StrMsg := '지시 수량을  입력하세요...!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  if (StrToFloat(QtyEdit.Text) < StrToFloat(RQtyEdit.Text)) then
  Begin
    StrMsg := '출고 중량이 재고 중량보다 큽니다...!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  if (Rb1.Checked = False) and (Rb2.Checked = False) and (Rb3.Checked = False) and
     (Rb4.Checked = False) and (Rb5.Checked = False) and (Rb6.Checked = False) then
  begin
     StrMsg := ' 출고할 컨베어 스테이션을 선택 하세요!!';
     WinLib_ErrorForm( StrMsg );    Exit;
  end;

  ls_bank := Copy(LocaEdit.Text,1,1);
  s_wsno  := '';

  if      (Rb1.Checked = True) then   begin s_wsno := '1';   end
  else if (Rb2.Checked = True) then   begin s_wsno := '2';   end
  else if (Rb3.Checked = True) then   begin s_wsno := '3';   end
  else if (Rb4.Checked = True) then   begin s_wsno := '4';   end
  else if (Rb5.Checked = True) then   begin s_wsno := '5';   end
  else if (Rb6.Checked = True) then   begin s_wsno := '6';   end
  else Exit;

  // 추가하는 품목의 PLT가  출고예약 데이터에 존재 하는 경우 해당 PLT와 출고대가 같아야 함.
  for r := 1 to OutSG.RowCount - 1 do
  begin
    if Trim(OutSG.Cells[1, r]) = '' then
      Continue;

    if SameText(Trim(OutSG.Cells[2, r]), Trim(pltnoEdit.Text)) then
    begin
      outSgWsno := Trim(OutSG.Cells[13, r]); // 기존 출고대

      // 1) 동일 키(PLT+CODE+LOTNO+CUST) 중복 차단
      if  SameText(Trim(OutSG.Cells[2,  r]), Trim(pltnoEdit.Text))  and  // PLTNO
          SameText(Trim(OutSG.Cells[3,  r]), Trim(ItemEdit.Text)) and    // CODE
          SameText(Trim(OutSG.Cells[5,  r]), Trim(LotnoEdit.Text))  and  // LOTNO
          SameText(Trim(OutSG.Cells[10, r]), Trim(CustEdit.Text)) then   // CUST
      begin
        StrMsg := Format(
          '동일한 내용이 이미 존재합니다. ' + #13#10 +
          'PLTNO : %s / CODE : %s / LOT : %s / CUST : %s',
          [Trim(pltnoEdit.Text), Trim(ItemEdit.Text), Trim(LotnoEdit.Text), Trim(CustEdit.Text)]
        );
        WinLib_ErrorForm(StrMsg);
        Exit;
      end;
      
      if (outSgWsno <> '') and (outSgWsno <> s_wsno) then
      begin
        StrMsg := Format(
          'PLTNO [%s]는 이미 %s번 출고대에 예약되어 있습니다.' + #13#10 +
          '같은 PLT는 동일 출고대(%s)로만 추가할 수 있습니다.',
          [pltnoEdit.Text, outSgWsno, outSgWsno]
        );
        WinLib_ErrorForm(StrMsg);
        Exit;
      end;
    end;
  end;
  
  StrQry := ' Select CVC1_CH01 From T2TBCVC1 (NOLOCK) Where CVC1_SR = ''R'' ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    mps_r_ch01 := FieldByName('CVC1_CH01').AsString;
  End;

  StrQry := ' Select CVC2_CH01  From T2TBCVC2 (NOLOCK) Where CVC2_SR = ''R'' ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    mps_r_ch03 := FieldByName('CVC2_CH01').AsString;
  End;

  StrQry := ' Select CVC3_CH01  From T2TBCVC3 (NOLOCK) Where CVC3_SR = ''R'' ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    mps_r_ch05 := FieldByName('CVC3_CH01').AsString;
  End;

  If  (s_wsno = '1')  then
  Begin
    if  (Copy(mps_r_ch01,12,1) = '0') then begin
       StrMsg := '01번 컨베어가 출고모드가 아닙니다....' + #13#10 + '확인 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
    end;

    if (Copy(mps_r_ch01,16,1) = '0')  then begin
      StrMsg := '01번 컨베어가 자동모드가 아닙니다....' + #13#10 + '확인 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;

    if (ls_bank <> '1') and (ls_bank <> '2') then begin
      StrMsg := '크레인이 출고 할수 없는 스테이션 입니다.' + #13#10 + '확인 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;
  End;
  If  (s_wsno = '2')  then
  Begin
    if  (Copy(mps_r_ch01,13,1) = '0') then begin
       StrMsg := '02번 컨베어가 출고모드가 아닙니다....' + #13#10 + '확인 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
    end;

    if (Copy(mps_r_ch01,16,1) = '0')  then begin
      StrMsg := '02번 컨베어가 자동모드가 아닙니다....' + #13#10 + '확인 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;

    if (ls_bank <> '1') and (ls_bank <> '2') then begin
      StrMsg := '크레인이 출고 할수 없는 스테이션 입니다.' + #13#10 + '확인 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;
  End;

  If  (s_wsno = '3')  then
  Begin
    if  (Copy(mps_r_ch03,12,1) = '0') then begin
       StrMsg := '03번 컨베어가 출고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
    end;

    if (Copy(mps_r_ch03,16,1) = '0')  then begin
      StrMsg := '03번 컨베어가 자동모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;

    if (ls_bank <> '3') and (ls_bank <> '4') then begin
      StrMsg := '크레인이 출고 할수 없는 스테이션 입니다.' + #13#10 + '확인 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;
  End;
  If  (s_wsno = '4')  then
  Begin
    if  (Copy(mps_r_ch03,13,1) = '0') then begin
       StrMsg := '04번 컨베어가 출고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
    end;

    if (Copy(mps_r_ch03,16,1) = '0')  then begin
      StrMsg := '04번 컨베어가 자동모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;

    if (ls_bank <> '3') and (ls_bank <> '4') then begin
      StrMsg := '크레인이 출고 할수 없는 스테이션 입니다.' + #13#10 + '확인 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;
  End;

  If  (s_wsno = '5')  then
  Begin
    if  (Copy(mps_r_ch05,12,1) = '0') then begin
       StrMsg := '05번 컨베어가 출고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
    end;

    if (Copy(mps_r_ch05,16,1) = '0')  then begin
      StrMsg := '05번 컨베어가 자동모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;

    if (ls_bank <> '5') and (ls_bank <> '6') then begin
      StrMsg := '크레인이 출고 할수 없는 스테이션 입니다.' + #13#10 + '확인 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;
  End;
  If  (s_wsno = '6')  then
  Begin
    if  (Copy(mps_r_ch05,13,1) = '0') then begin
       StrMsg := '06번 컨베어가 출고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
    end;

    if (Copy(mps_r_ch05,16,1) = '0')  then begin
      StrMsg := '06번 컨베어가 자동모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;

    if (ls_bank <> '5') and (ls_bank <> '6') then begin
      StrMsg := '크레인이 출고 할수 없는 스테이션 입니다.' + #13#10 + '확인 후 다시 하십시요!!!';
      WinLib_ErrorForm( StrMsg );
      Exit;
    end;
  End;
  //////////////////////////////////////////////////////////////////////////////

  StrMsg := ' 출고 예약 데이터에 추가 하시겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin  Exit;    End;

  if (RQtyEdit.Text = '') or (Length(RQtyEdit.Text) = 0)    Then RQtyEdit.Text := '0';

  // TStringGrid (OutResGrid)에 삽입
  numQty := StrToFloat(QtyEdit.Text);
  numRQty := StrToFloat(RqtyEdit.Text);
  numRealTimeQty := StrToFloat(realtimeQtyEdit.Text);

  IntPos := OutSG.RowCount;
  IF OutSG.Cells[1, IntPos - 1]  <> '' then IntPos := IntPos + 1;

  OutSG.RowCount := IntPos;

  OutSG.Cells[1, IntPos - 1]  := LocaEdit.text;     // 저장위치
  OutSG.Cells[2, IntPos - 1]  := pltnoEdit.text;    // PLTNO
  OutSG.Cells[3, IntPos - 1]  := ItemEdit.text;     // 품목코드
  OutSG.Cells[4, IntPos - 1]  := SpecNameEdit.text; // 품목명
  OutSG.Cells[5, IntPos - 1]  := LotnoEdit.Text;    // LOTNO
  OutSG.Cells[6, IntPos - 1]  := BoxNoEdit.Text;    // BOXNO
  OutSG.Cells[7, IntPos - 1]  := BigoEdit.Text;     // 비고
  //OutSG.Cells[8, IntPos - 1]  := FormatFloat('#,##0.00', numQty);   // 재고 수량( 실재고 수량 - 예약 수량)
  OutSG.Cells[8, IntPos - 1]  := FormatFloat('#,##0.00', numRealTimeQty);   // 재고 수량 실재고 수량
  OutSG.Cells[9, IntPos - 1]  := FormatFloat('#,##0.00', numRQty);  // 지시수량
  OutSG.Cells[10, IntPos - 1]  := CustEdit.Text;     // 납품처
  OutSG.Cells[11, IntPos - 1]  := BoxNo1Edit.Text;  // 출고 BoxNo
  OutSG.Cells[12, IntPos - 1]  := Bigo1Edit.Text;   // 출고 비고
  OutSG.Cells[13, IntPos - 1]  := s_wsno; // s_wsno(출고대)
  OutSG.Cells[14, IntPos - 1]  := indateEdit.Text; // subk_indate (입고일)
  OutSG.Cells[15, IntPos - 1]  := intimeEdit.Text; // subk_intime (입고시간)


  //Showmessage('추가 완료 되었습니다...');

  ResvGBox.Visible := False;

  // Item 초기화
  itemClear;


end;

procedure TFrm_4100.ExitSPClick(Sender: TObject);
begin
  ResvGBox.Visible := False;
  
  // Item 초기화
  itemClear;
end;

procedure TFrm_4100.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_4100.FormDestroy(Sender: TObject);
begin
  Frm_4100 := Nil;
end;

procedure TFrm_4100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_4100.Query2SUBK_GUBUNGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.Value = 'N'  then Text := '정상'
  else if Sender.Value = 'Y'  then Text := '불량'
  else Text := '';
end;

procedure TFrm_4100.Code_SearchClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  Mast_Disp  := TMast_Disp.Create(Application);
  Bol_Modal := True;

  Mast_Disp.Edt_Search.Text := ItemCodeMed.Text;
  If Mast_Disp <> Nil Then
    With TForm(Mast_Disp) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      Mast_Disp.Free;
    End;

    ItemCodeMed.Text  :=  jj_code;
    NameEdit.Text  :=  jj_name;
end;



procedure TFrm_4100.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_4100.MouseWheelHandler(var Message: TMessage);
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
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     (ActiveControl as TDBGrid).Refresh;
   end;
 end;
end;

procedure TFrm_4100.RqtyEditKeyPress(Sender: TObject; var Key: Char);
var
  E: TEdit;
  decSep: Char;
begin
  E := Sender as TEdit;
  decSep := DecimalSeparator; // 보통 '.' 이지만 로캘 따라 ','일 수 있음

  if QtyEdit.Text = '' then Exit;  

  // 항상 허용: 백스페이스
  if Key = #8 then Exit;

  // 허용 문자: 숫자, 소수점
  if not (Key in ['0'..'9', decSep]) then
  begin
    Key := #0;
    Exit;
  end;

  // 소수점 처리: 이미 하나 있으면 추가로 못 찍게
  if (Key = decSep) then
  begin
    // 선택 전체 덮어쓰기면 허용
    if (E.SelLength = Length(E.Text)) then Exit;

    // 이미 소수점이 있고, 선택영역이 그 소수점을 포함하지 않으면 차단
    if (Pos(decSep, E.Text) > 0) and
       not ((E.SelLength > 0) and (Pos(decSep, Copy(E.Text, E.SelStart+1, E.SelLength)) > 0)) then
    begin
      Key := #0;
      Exit;
    end;

    // 맨 처음에 소수점을 찍으면 0. 로 보정
    if (E.SelLength = 0) and (E.SelStart = 0) and (E.Text = '') then
    begin
      E.Text := '0' + decSep;
      E.SelStart := Length(E.Text);
      Key := #0; // 이미 보정했으니 현재 Key는 소비
    end;
  end;
end;

procedure TFrm_4100.CancelSBClick(Sender: TObject);
var
  m_Row, i, j : Integer;
begin
  if OutSG.Cells[1,OutSG.Row] = '' Then Begin
    StrMsg := '삭제할 데이타가 없습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;
  StrMsg := ' 현재 라인을 삭제 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin
    Exit;
  End;

  m_Row := OutSG.Row;

  for j := m_Row to  OutSG.RowCount-2 do
  begin
    for i := 0 to    OutSG.ColCount-1  do
    begin
      OutSG.Cells[i, j] := OutSG.Cells[i, j+1];
    end;
  end;

  for j := 0 to  OutSG.ColCount-1  do
  begin
    OutSG.Cells[j, OutSG.RowCount-1] := '';
  end;

  IntRow := IntRow - 1;
  If OutSG.RowCount > 2 Then OutSG.RowCount := OutSG.RowCount - 1;
  OutSG.Col := 0;

  Jisi_Select_Proc;
end;

procedure TFrm_4100.ClearSBClick(Sender: TObject);
begin
  StrMsg := ' 전체 취소 하시겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin
    Exit;
  End;

  Out_Grid_Clear_Proc
end;

{
procedure TFrm_4100.ConfirmBitBtnClick(Sender: TObject);
var
  sys_datetime, StrDate, StrTime : String;
  ls_sql : String;
begin
  if OutSG.Cells[2,1] = '' Then Begin
    StrMsg := '☞ 출고작업할 데이타가 없습니다....' + #13#10 + '출고 데이타를 입력 후 다시 시도 하십시요!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  StrMsg := ' ☞ 수동 출고 예약을 확정 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin  Exit;    End;

  sys_datetime  :=  f_get_sysdate_time();
  StrDate       :=  copy(sys_datetime, 1, 8);
  StrTime       :=  copy(sys_datetime, 9, 6);
  S_Date        :=  copy(sys_datetime, 1, 8);
  S_Time        :=  copy(sys_datetime, 9, 6);


  // 출고 데이터 생성....
  ls_sql := ' DELETE FROM T2TIODAT2 ';
  With updtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSql;
    Except
      Showmessage('삭제에러 T2TIODAT2' ); Exit;
    End;
  End;

   Output_Resv_Proc;

   // 출고 데이터 GRID 초기화
   Out_Grid_Clear_Proc;
   StartBtnClick(Self);

   Showmessage('출고 예약 되었습니다...');
end;
 }

{ 20260122 백업
procedure TFrm_4100.ConfirmBitBtnClick(Sender: TObject);
var
  i, j : Integer;
  ProcessedList : TStringList; // 이미 처리한 PLT 번호 목록
  CurrentPlt, CurrentLoca, CurrentWsno : String;
  
  // DB 저장용 변수
  StrDate, StrTime, StrIndex, StrSeqNo : String;
  ls_sql, ls_date : String;
  
  // 상세 데이터 변수
  sCode, sLot, sCust, sBox, sRemark, sBox1, sRemark1 : String;
  nQty, nRQty : Double;
  
  // 집계용
  NumSumQty, NumSumOutQty : Double;
  StrGubun : String; // P:부분출고, T:전체출고
begin
  // 1. 유효성 검사
  if OutSG.Cells[2,1] = '' Then Begin
    WinLib_ErrorForm('☞ 출고작업할 데이타가 없습니다.');
    Exit;
  End;

  if Not WinLib_ConfirmForm('☞ 수동 출고 예약을 확정 하겠습니까?') Then Exit;

  StrDate := FormatDateTime('yyyymmdd', Now);
  StrTime := FormatDateTime('hhmmss', Now);

  ProcessedList := TStringList.Create; // 중복 체크용 리스트 생성
  try
    // =========================================================================
    // [Outer Loop] 그리드의 첫 번째 행부터 순서대로 "작업 지시(헤더)" 생성
    // =========================================================================
    for i := 1 to OutSG.RowCount - 1 do
    begin
      CurrentPlt  := Trim(OutSG.Cells[2, i]);  // PLTNO
      CurrentLoca := Trim(OutSG.Cells[1, i]);  // LOCA
      CurrentWsno := Trim(OutSG.Cells[13, i]); // WSNO (출고대)

      // 빈 행이거나, 이미 처리한 PLT라면 건너뜀 (핵심: P001 -> P002 -> P001 일 때 마지막 P001 무시)
      if (CurrentPlt = '') or (ProcessedList.IndexOf(CurrentPlt) >= 0) then Continue;

      // -----------------------------------------------------------------------
      // 2. 신규 지시 번호(StrIndex) 채번 (파렛트 1개당 1개의 Index 생성)
      // -----------------------------------------------------------------------
      ls_sql := ' Select STAT_ODATE, STAT_OINDX From T2TBSTAT (NOLOCK) Where STAT_PSWD = ''JPLS'' ';
      With StatQuery do Begin
        Close; SQL.Clear; SQL.Add(ls_sql); Open;
        ls_date := FieldByName('STAT_ODATE').AsString;
      End;

      if (ls_date = StrDate) then
      begin
        StrIndex := StrDate + 'O' + Format('%4.4d', [StatQuery.FieldByName('STAT_OINDX').AsInteger]);
        
        if StatQuery.FieldByName('STAT_OINDX').AsInteger >= 9999 then
           ls_sql := ' Update T2TBSTAT Set STAT_OINDX = 1 Where STAT_PSWD = ''JPLS'' '
        else
           ls_sql := ' Update T2TBSTAT Set STAT_OINDX = STAT_OINDX + 1 Where STAT_PSWD = ''JPLS'' ';
      end
      else
      begin
        StrIndex := StrDate + 'O' + Format('%4.4d', [1]);
        ls_sql := ' Update T2TBSTAT Set STAT_ODATE = '''+StrDate+''', STAT_OINDX = 2 Where STAT_PSWD = ''JPLS'' ';
      end;

      try
        UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;
      except
      end;

      // -----------------------------------------------------------------------
      // 3. 작업 구분(전체/부분) 판단
      // -----------------------------------------------------------------------
      // 해당 위치(파렛트)의 총 재고량과 총 출고예약량을 DB에서 조회하여 비교
      ls_sql := ' Select Sum(SUBK_WGT) SUBK_WGT, Sum(SUBK_RWGT) SUBK_RWGT ';
      ls_sql := ls_sql + ' From T2MISUBK (NOLOCK) Where SUBK_LOCA = '''+CurrentLoca+''' '; 
      
      StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
      NumSumQty    := StatQuery.FieldByName('SUBK_WGT').asFloat;
      NumSumOutQty := StatQuery.FieldByName('SUBK_RWGT').asFloat;
      
      // 재고량 <= 예약량 이면 전체출고(T), 아니면 부분출고(P)
      // (참고: 지금 추가하는 양까지 포함해야 정확하지만, 기존 로직상 RWGT를 누적 업데이트하므로 이를 따름)
      If NumSumQty <= NumSumOutQty Then StrGubun := 'T' Else StrGubun := 'P';

      // -----------------------------------------------------------------------
      // 4. 작업 지시 헤더(T2TISCHE) 생성
      // -----------------------------------------------------------------------
      Insert_Sche_Proc(StrIndex, CurrentLoca, StrGubun, CurrentWsno, CurrentPlt);
      
      // [중요] 현재 PLT를 처리 목록에 등록 (나중에 또 나오면 무시하기 위함)
      ProcessedList.Add(CurrentPlt);


      // =======================================================================
      // [Inner Loop] 해당 PLT에 속한 모든 품목 상세 처리 (T2MIOUPT, T2MISUBK)
      // =======================================================================
      for j := 1 to OutSG.RowCount - 1 do
      begin
        // 현재 처리 중인 PLTNO와 같은 행만 골라서 처리 (P001 처리 중이면 P001만)
        if Trim(OutSG.Cells[2, j]) <> CurrentPlt then Continue;

        // 변수 매핑
        sCode    := OutSG.Cells[3, j];
        sLot     := OutSG.Cells[5, j];
        sBox     := OutSG.Cells[6, j];
        sRemark  := OutSG.Cells[7, j];
        
        // 콤마 제거 및 숫자 변환
        nQty     := StrToFloatDef(StringReplace(OutSG.Cells[8, j], ',', '', [rfReplaceAll]), 0);
        nRQty    := StrToFloatDef(StringReplace(OutSG.Cells[9, j], ',', '', [rfReplaceAll]), 0);

        sCust    := OutSG.Cells[10, j];
        sBox1    := OutSG.Cells[11, j]; // 출고 BOX
        sRemark1 := OutSG.Cells[12, j]; // 출고 비고
        
        // 5-1. 상세 순번(SEQNO) 채번 (해당 Index 내에서의 순번)
        ls_sql := ' Select ISNULL(Max(OUPT_SEQNO), 0) + 1 AS NEXT_SEQ From T2MIOUPT (NOLOCK) ';
        ls_sql := ls_sql + ' Where OUPT_INDEX = '''+StrIndex+''' ';
        StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
        StrSeqNo := Format('%4.4d', [StatQuery.FieldByName('NEXT_SEQ').AsInteger]);

        // 5-2. 출고 상세(T2MIOUPT) 저장
        ls_sql := ' Insert Into T2MIOUPT(OUPT_DATE, OUPT_INDEX, OUPT_SEQNO, OUPT_PLTNO, OUPT_LOCA, OUPT_CODE, OUPT_LOTNO, ';
        ls_sql := ls_sql + '             OUPT_WGT, OUPT_OUT_WGT, OUPT_GUBUN, OUPT_JOB_FLAG, OUPT_CUST, OUPT_TIME, ';
        ls_sql := ls_sql + '             OUPT_BOXNO1, OUPT_REMARK1, OUPT_ID) ';
        ls_sql := ls_sql + ' Values ( '''+StrDate+''', '''+StrIndex+''', '''+StrSeqNo+''', '''+CurrentPlt+''', '''+CurrentLoca+''', '''+sCode+''', '''+sLot+''', ';
        ls_sql := ls_sql + '          '+FloatToStr(nQty)+', '+FloatToStr(nRQty)+', ''Y'', ''0'', '''+sCust+''', '''+StrTime+''', ';
        ls_sql := ls_sql + '          '''+sBox1+''', '''+sRemark1+''', '''+jj_id+''' ) ';
        
        try
          UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;
        except
          // 에러 발생 시 로그 처리 등 필요
        end;

        // 5-3. 재고(T2MISUBK) 업데이트 (예약량 증가, 상태 'M'으로 변경)
        // 상태 'M'은 임시 상태이며, 마지막에 Replace_Table_Flag에서 'Y'로 일괄 변경됨
        ls_sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'', ';
        ls_sql := ls_sql + ' SUBK_RWGT = ISNULL(SUBK_RWGT,0) + ' + FloatToStr(nRQty) + ' ';
        ls_sql := ls_sql + ' Where SUBK_PLTNO = '''+CurrentPlt+''' ';
        ls_sql := ls_sql + '   AND SUBK_CODE  = '''+sCode+''' ';
        ls_sql := ls_sql + '   AND SUBK_LOTNO = '''+sLot+''' ';
        
        try
          UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;
        except
        end;

      end; // End Inner Loop (Detail Items)

      // 5-4. 마스터(T2MILSTK) 업데이트 (해당 PLT 위치 'M' 상태로)
      ls_sql := ' Update T2MILSTK Set LSTK_FLAG = ''M'' Where LSTK_LOCA = '''+CurrentLoca+''' ';
      try
        UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;
      except
      end;

    end; // End Outer Loop (Grid Row)

    // 6. 마무리 (상태 플래그 정리: M -> Y)
    // 이 함수 안에서 T2MILSTK, T2MISUBK의 'M' 상태를 'Y'(예약)로 바꿉니다.
    Replace_Table_Flag;

    Showmessage('출고 예약 되었습니다.');
    
    // 화면 초기화 및 재조회
    Out_Grid_Clear_Proc;
    StartBtnClick(Self);

  finally
    ProcessedList.Free;
  end;
end;
}

procedure TFrm_4100.ConfirmBitBtnClick(Sender: TObject);
var
  i, j : Integer;
  ProcessedList : TStringList; // 이미 처리한 PLT 번호 목록
  CheckList     : TStringList; // [추가] 해당 PLT 내에서 처리된 품목(Code+Lot) 목록
  CurrentPlt, CurrentLoca, CurrentWsno : String;
  
  // DB 저장용 변수
  StrDate, StrTime, StrIndex, StrSeqNo : String;
  ls_sql, ls_date : String;
  
  // 상세 데이터 변수
  sCode, sLot, sCust, sBox, sRemark, sBox1, sRemark1 : String;
  nQty, nRQty : Double;
  sRFlag : String; // 상태값 (O:출고, R:재입고)
  
  // 미선택 품목 처리용 변수
  dbCode, dbLot, dbBox, dbRemark, dbCust, dbKey : String;
  dbWgt, dbRWgt : Double;
  
  // 집계용
  NumSumQty, NumSumOutQty : Double;
  StrGubun : String;

  //그리드 합계 계산용 변수 선언
  k : Integer;
  TotalGridReqQty : Double;

begin
  // 1. 유효성 검사
  if OutSG.Cells[2,1] = '' Then Begin
    WinLib_ErrorForm('☞ 출고작업할 데이타가 없습니다.');
    Exit;
  End;

  if Not WinLib_ConfirmForm('☞ 수동 출고 예약을 확정 하겠습니까?') Then Exit;

  StrDate := FormatDateTime('yyyymmdd', Now);
  StrTime := FormatDateTime('hhmmss', Now);

  ProcessedList := TStringList.Create; 
  CheckList     := TStringList.Create; // [추가] 품목 중복 체크용

  UpdtQuery.Connection.BeginTrans; // 트랜잭션 시작
  try
    try
      // =========================================================================
      // [Outer Loop] 그리드 순서대로 작업 지시(헤더) 생성
      // =========================================================================
      for i := 1 to OutSG.RowCount - 1 do
      begin
        CurrentPlt  := Trim(OutSG.Cells[2, i]);  // PLTNO
        CurrentLoca := Trim(OutSG.Cells[1, i]);  // LOCA
        CurrentWsno := Trim(OutSG.Cells[13, i]); // WSNO

        // 이미 처리한 PLT면 건너뜀
        if (CurrentPlt = '') or (ProcessedList.IndexOf(CurrentPlt) >= 0) then Continue;

        // -----------------------------------------------------------------------
        // 2. 신규 지시 번호(Index) 채번
        // -----------------------------------------------------------------------
        ls_sql := ' Select STAT_ODATE, STAT_OINDX From T2TBSTAT (NOLOCK) Where STAT_PSWD = ''JPLS'' ';
        With StatQuery do Begin
          Close; SQL.Clear; SQL.Add(ls_sql); Open;
          ls_date := FieldByName('STAT_ODATE').AsString;
        End;

        if (ls_date = StrDate) then
        begin
          StrIndex := StrDate + 'O' + Format('%4.4d', [StatQuery.FieldByName('STAT_OINDX').AsInteger]);
          if StatQuery.FieldByName('STAT_OINDX').AsInteger >= 9999 then
             ls_sql := ' Update T2TBSTAT Set STAT_OINDX = 1 Where STAT_PSWD = ''JPLS'' '
          else
             ls_sql := ' Update T2TBSTAT Set STAT_OINDX = STAT_OINDX + 1 Where STAT_PSWD = ''JPLS'' ';
        end
        else
        begin
          StrIndex := StrDate + 'O' + Format('%4.4d', [1]);
          ls_sql := ' Update T2TBSTAT Set STAT_ODATE = '''+StrDate+''', STAT_OINDX = 2 Where STAT_PSWD = ''JPLS'' ';
        end;
        
        UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

        // -----------------------------------------------------------------------
        // 3. 작업 구분(전체/부분) 판단 (기존 로직 유지)
        // -----------------------------------------------------------------------
        {
        ls_sql := ' Select Sum(SUBK_WGT) SUBK_WGT, Sum(SUBK_RWGT) SUBK_RWGT ';
        ls_sql := ls_sql + ' From T2MISUBK (NOLOCK) Where SUBK_LOCA = '''+CurrentLoca+''' ';

        StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
        NumSumQty    := StatQuery.FieldByName('SUBK_WGT').asFloat;
        NumSumOutQty := StatQuery.FieldByName('SUBK_RWGT').asFloat;

        If NumSumQty <= NumSumOutQty Then StrGubun := 'T' Else StrGubun := 'P';
        }

        ls_sql := ' Select Sum(SUBK_WGT) SUBK_WGT, Sum(SUBK_RWGT) SUBK_RWGT ';
        ls_sql := ls_sql + ' From T2MISUBK (NOLOCK) Where SUBK_LOCA = '''+CurrentLoca+''' '; 
        
        StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
        NumSumQty    := StatQuery.FieldByName('SUBK_WGT').asFloat;    // 총 재고량
        NumSumOutQty := StatQuery.FieldByName('SUBK_RWGT').asFloat;   // 이미 DB에 잡힌 예약량
        
        // [추가 로직] 그리드(OutSG)에서 현재 처리 중인 PLT(CurrentPlt)의 '지시수량'을 모두 합산
        TotalGridReqQty := 0;
        for k := 1 to OutSG.RowCount - 1 do
        begin
           // 현재 처리하려는 PLT와 같은 놈들만 찾아서 지시수량(9열) 더하기
           if Trim(OutSG.Cells[2, k]) = CurrentPlt then 
           begin
             TotalGridReqQty := TotalGridReqQty + 
                                StrToFloatDef(StringReplace(OutSG.Cells[9, k], ',', '', [rfReplaceAll]), 0);
           end;
        end;
        
        // 판단: (총 재고) <= (이미 예약된 양 + 이번에 신청한 양)
        // 0.001은 부동소수점 오차 방지용
        if NumSumQty <= (NumSumOutQty + TotalGridReqQty + 0.001) then 
           StrGubun := 'T'  // 전체 출고
        else 
           StrGubun := 'P'; // 부분 출고



        // -----------------------------------------------------------------------
        // 4. 작업 지시 헤더(T2TISCHE) 생성
        // -----------------------------------------------------------------------
        Insert_Sche_Proc(StrIndex, CurrentLoca, StrGubun, CurrentWsno, CurrentPlt);
        
        ProcessedList.Add(CurrentPlt); // PLT 처리 완료 등록
        CheckList.Clear;               // 품목 체크 리스트 초기화


        // =======================================================================
        // [Inner Loop 1] 그리드에 있는 "선택된 품목" 처리
        // =======================================================================
        for j := 1 to OutSG.RowCount - 1 do
        begin
          if Trim(OutSG.Cells[2, j]) <> CurrentPlt then Continue;

          sCode    := OutSG.Cells[3, j];
          sLot     := OutSG.Cells[5, j];
          sBox     := OutSG.Cells[6, j];
          sRemark  := OutSG.Cells[7, j];
          
          nQty     := StrToFloatDef(StringReplace(OutSG.Cells[8, j], ',', '', [rfReplaceAll]), 0);
          nRQty    := StrToFloatDef(StringReplace(OutSG.Cells[9, j], ',', '', [rfReplaceAll]), 0);

          sCust    := OutSG.Cells[10, j];
          sBox1    := OutSG.Cells[11, j];
          sRemark1 := OutSG.Cells[12, j];
          
          // [중요] 처리된 품목 키 저장 (Code + Lot) -> 나중에 DB 조회시 제외하기 위함
          CheckList.Add(sCode + sLot); 

          // [상태값 결정 로직 - 예전 소스 참고]
          // 출고예약량(nRQty)이 0이거나, 재고(nQty)와 다르면 'R'(부분/재입고), 같으면 'O'(전량출고)
          if (nRQty = 0) then sRFlag := 'R'
          else if (nQty <> nRQty) then sRFlag := 'R'
          else sRFlag := 'O';

          // 5-1. 상세 순번 채번
          ls_sql := ' Select ISNULL(Max(OUPT_SEQNO), 0) + 1 AS NEXT_SEQ From T2MIOUPT (NOLOCK) ';
          ls_sql := ls_sql + ' Where OUPT_INDEX = '''+StrIndex+''' ';
          StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
          StrSeqNo := Format('%4.4d', [StatQuery.FieldByName('NEXT_SEQ').AsInteger]);

          // 5-2. 출고 상세(T2MIOUPT) 저장
          ls_sql := ' Insert Into T2MIOUPT(OUPT_DATE, OUPT_INDEX, OUPT_SEQNO, OUPT_PLTNO, OUPT_LOCA, OUPT_CODE, OUPT_LOTNO, ';
          ls_sql := ls_sql + '             OUPT_WGT, OUPT_OUT_WGT, OUPT_GUBUN, OUPT_JOB_FLAG, OUPT_CUST, OUPT_TIME, ';
          ls_sql := ls_sql + '             OUPT_BOXNO1, OUPT_REMARK1, OUPT_ID, OUPT_RFLAG, OUPT_BOXNO, OUPT_REMARK) '; // BOXNO, REMARK 추가
          ls_sql := ls_sql + ' Values ( '''+StrDate+''', '''+StrIndex+''', '''+StrSeqNo+''', '''+CurrentPlt+''', '''+CurrentLoca+''', '''+sCode+''', '''+sLot+''', ';
          ls_sql := ls_sql + '          '+FloatToStr(nQty)+', '+FloatToStr(nRQty)+', ''Y'', ''0'', '''+sCust+''', '''+StrTime+''', ';
          ls_sql := ls_sql + '          '''+sBox1+''', '''+sRemark1+''', '''+jj_id+''', '''+sRFlag+''', '''+sBox+''', '''+sRemark+''' ) ';
          
          UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

          // 5-3. 재고(T2MISUBK) 업데이트 (RWGT 업데이트)
          ls_sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'', ';
          ls_sql := ls_sql + ' SUBK_RWGT = ISNULL(SUBK_RWGT,0) + ' + FloatToStr(nRQty) + ' ';
          ls_sql := ls_sql + ' Where SUBK_PLTNO = '''+CurrentPlt+''' ';
          ls_sql := ls_sql + '   AND SUBK_CODE  = '''+sCode+''' ';
          ls_sql := ls_sql + '   AND SUBK_LOTNO = '''+sLot+''' ';
          
          UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

        end; // End Inner Loop 1


        // =======================================================================
        // [Inner Loop 2] 그리드에 없는 "나머지 품목" 처리 (동반 이동)
        // =======================================================================
        // 해당 PLT의 모든 재고 조회 (기존 ReinPut_Data_Proc 참조)
        ls_sql := ' SELECT SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK FROM T2MISUBK (NOLOCK) ';
        ls_sql := ls_sql + ' WHERE SUBK_PLTNO = ''' + CurrentPlt + ''' ';
        
        DispQuery.Close; DispQuery.SQL.Text := ls_sql; DispQuery.Open;
        
        while not DispQuery.Eof do
        begin
          dbCode   := DispQuery.FieldByName('SUBK_CODE').AsString;
          dbLot    := DispQuery.FieldByName('SUBK_LOTNO').AsString;
          dbWgt    := DispQuery.FieldByName('SUBK_WGT').AsFloat;
          dbRWgt   := DispQuery.FieldByName('SUBK_RWGT').AsFloat;
          dbBox    := DispQuery.FieldByName('SUBK_BOXNO').AsString;
          dbRemark := DispQuery.FieldByName('SUBK_REMARK').AsString;
          dbKey    := dbCode + dbLot;

          // 이미 처리된(그리드에 있던) 품목이면 패스
          if CheckList.IndexOf(dbKey) >= 0 then 
          begin
            DispQuery.Next;
            Continue;
          end;

          // --- 여기서부터 미선택 품목에 대한 이력 생성 ---
          // 미선택 품목은 출고지시량(OutWgt)이 0이므로 무조건 'R'(재입고) 상태임
          sRFlag := 'R'; 
          
          // 순번 채번
          ls_sql := ' Select ISNULL(Max(OUPT_SEQNO), 0) + 1 AS NEXT_SEQ From T2MIOUPT (NOLOCK) ';
          ls_sql := ls_sql + ' Where OUPT_INDEX = '''+StrIndex+''' ';
          StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
          StrSeqNo := Format('%4.4d', [StatQuery.FieldByName('NEXT_SEQ').AsInteger]);

          // 이력 Insert (출고량 0, 상태 R)
          ls_sql := ' Insert Into T2MIOUPT(OUPT_DATE, OUPT_INDEX, OUPT_SEQNO, OUPT_PLTNO, OUPT_LOCA, OUPT_CODE, OUPT_LOTNO, ';
          ls_sql := ls_sql + '             OUPT_WGT, OUPT_OUT_WGT, OUPT_GUBUN, OUPT_JOB_FLAG, OUPT_CUST, OUPT_TIME, ';
          ls_sql := ls_sql + '             OUPT_BOXNO1, OUPT_REMARK1, OUPT_ID, OUPT_RFLAG, OUPT_BOXNO, OUPT_REMARK) ';
          ls_sql := ls_sql + ' Values ( '''+StrDate+''', '''+StrIndex+''', '''+StrSeqNo+''', '''+CurrentPlt+''', '''+CurrentLoca+''', '''+dbCode+''', '''+dbLot+''', ';
          ls_sql := ls_sql + '          '+FloatToStr(dbWgt)+', 0, ''Y'', ''0'', '''', '''+StrTime+''', '; // 출고량 0
          ls_sql := ls_sql + '          '''', '''', '''+jj_id+''', '''+sRFlag+''', '''+dbBox+''', '''+dbRemark+''' ) ';

          UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

          // 재고 상태만 M으로 변경 (수량 변화 없음)
          ls_sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'' ';
          ls_sql := ls_sql + ' Where SUBK_PLTNO = '''+CurrentPlt+''' ';
          ls_sql := ls_sql + '   AND SUBK_CODE  = '''+dbCode+''' ';
          ls_sql := ls_sql + '   AND SUBK_LOTNO = '''+dbLot+''' ';
          
          UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

          DispQuery.Next;
        end; // End Inner Loop 2


        // 5-4. 마스터(T2MILSTK) 업데이트
        ls_sql := ' Update T2MILSTK Set LSTK_FLAG = ''M'' Where LSTK_LOCA = '''+CurrentLoca+''' ';
        UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

      end; // End Outer Loop

      // 6. 마무리 (상태 플래그 정리: M -> Y)
      Replace_Table_Flag;
      
      UpdtQuery.Connection.CommitTrans; 

      Showmessage('출고 예약 되었습니다.');
      
      Out_Grid_Clear_Proc;
      StartBtnClick(Self);

    except
      UpdtQuery.Connection.RollbackTrans; 
      WinLib_ErrorForm('저장 중 오류가 발생했습니다.');
    end;

  finally
    ProcessedList.Free;
    CheckList.Free;
  end;
end;


/////////////////////////////////////////////////////////////////////////
////////////////////////// Output_Proc //////////////////////////////////
/////////////////////////////////////////////////////////////////////////
procedure TFrm_4100.Output_Resv_Proc;
var
   ls_st, ls_loca, ls_pltid, ls_code, ls_lotno, ls_boxno, ls_bigo, ls_qty, ls_rqty, ls_jqty, ls_cust : String;
   ls_outBoxNo, ls_outBigo, ls_indate, ls_intime : String;
   ls_sql : String;
begin
  IntPos := 1;

  For IntPos := 1 To OutSG.RowCount - 1 Do Begin
    With OutSG Do Begin
      If OutSG.Cells[1, IntPos] = '' Then Break;

      ls_loca      :=   OutSG.Cells[1, IntPos];
      ls_pltid     :=   OutSG.Cells[2, IntPos];
      ls_code      :=   OutSG.Cells[3, IntPos];
      ls_lotno     :=   OutSG.Cells[5, IntPos];
      ls_boxno     :=   OutSG.Cells[6, IntPos];
      ls_bigo      :=   OutSG.Cells[7, IntPos];
      ls_qty       :=   OutSG.Cells[8, IntPos];
      ls_rqty      :=   OutSG.Cells[9, IntPos];
      ls_cust      :=   OutSG.Cells[10, IntPos];
      ls_outBoxNo  :=   OutSG.Cells[11, IntPos];
      ls_outBigo   :=   OutSG.Cells[12, IntPos];
      ls_st        :=   OutSG.Cells[13, IntPos];  // 출고대
      ls_indate    :=   OutSG.Cells[14, IntPos];  // 입고일
      ls_intime    :=   OutSG.Cells[15, IntPos];  // 입고시간

      While Pos(',', ls_qty) > 0 Do Begin Delete(ls_qty, Pos(',', ls_qty), 1); End;
      While Pos(',', ls_rqty) > 0 Do Begin Delete(ls_rqty, Pos(',', ls_rqty), 1); End;
      While Pos('-', ls_Indate) > 0 Do Begin Delete(ls_Indate, Pos('-', ls_Indate), 1); End;
      While Pos(':', ls_InTime) > 0 Do Begin Delete(ls_InTime, Pos(':', ls_InTime), 1); End;
      //While Pos('-', ls_Lotno) > 0 Do Begin Delete(ls_Lotno, Pos('-', ls_Lotno), 1); End;
      While Pos('-', ls_loca) > 0 Do Begin Delete(ls_loca, Pos('-', ls_loca), 1); End;

      if(Trim(ls_qty) = '')  then ls_qty := '0';
      if(Trim(ls_rqty) = '') then ls_rqty := '0';

      ls_jqty := FormatFloat('0.00', StrToFloatDef(ls_qty,0) - StrToFloatDef(ls_rqty,0)); // 잔여 수량 계산


      ls_sql := ' Insert Into T2TIODAT2(ODAT_DATE,  ODAT_PLTNO, ODAT_CODE, ODAT_LOTNO, ODAT_CUST, ODAT_LOCA,   ';
      ls_sql :=  ls_sql + '        ODAT_INDATE, ODAT_INTIME, ODAT_BOXNO,  ODAT_REMARK,    ';
      ls_sql :=  ls_sql + '        ODAT_QTY,    ODAT_RQTY,  ODAT_JQTY, ODAT_BOXNO1,  ODAT_REMARK1, ODAT_WSNO  ) ';
      ls_sql :=  ls_sql + ' Values( '''+S_Date+''', '''+ls_pltid+''', '''+ls_code+''', '''+ls_lotno+''', '''+ls_cust+''', '''+ls_loca+''', ';
      ls_sql :=  ls_sql + '         '''+ls_Indate+''',  '''+ls_InTime+''', '''+ls_boxno+''', '''+ls_bigo+''', ';
      ls_sql :=  ls_sql + ' CONVERT(NUMERIC(7,2),'''+ls_qty+'''), CONVERT(NUMERIC(7,2),'''+ls_rqty+'''), CONVERT(NUMERIC(7,2),'''+ls_jqty+'''),  ';   // 잔여 수량
      ls_sql :=  ls_sql + '         '''+ls_outBoxNo+''', '''+ls_outBigo+''', '''+ls_st+'''  ) ';

      Try
        With UpdtQuery do Begin
          Close;
          SQL.Clear;
          SQL.Add(ls_sql);
          ExecSQL;
        End;
      Except
        ShowMessage(ls_sql);
        exit;
      End;


      ls_sql := ' Update T2MISUBK Set  SUBK_FLAG = ''M'', ';
      ls_sql := ls_sql + ' SUBK_RWGT = ISNULL(SUBK_RWGT,0) + CONVERT(NUMERIC(7,2),'''+ls_rqty+''') ';
      ls_sql := ls_sql + ' Where SUBK_LOCA   = '''+ls_loca+''' ';
      ls_sql := ls_sql + '   AND SUBK_CODE   = '''+ls_code+''' ';
      ls_sql := ls_sql + '   AND SUBK_LOTNO  = '''+ls_lotno+''' ';
      ls_sql := ls_sql + '   AND SUBK_PLTNO  = '''+ls_pltid+''' ';

      Try
        UpdtQuery.Close;
        UpdtQuery.SQL.Clear;
        UpdtQuery.SQL.Add(ls_sql);
        UpdtQuery.ExecSQL;
      Except
        ShowMessage(ls_sql);
      End;


      {
      var_sql := ' Update MIPLTNO Set PLT_FLAG = ''Y'',  ';
      var_sql := var_sql + ' PLT_RQTY = ISNULL(PLT_RQTY,0) + CONVERT(Float,'''+ls_rqty+''') ';
      var_sql := var_sql + ' Where PLT_LOCA    = '''+ls_loca+''' ';
      var_sql := var_sql + '   And PLT_PLTNO   = '''+ls_pltid+''' ';
      var_sql := var_sql + '   And PLT_CODE    = '''+ls_code+''' ';
      var_sql := var_sql + '   And PLT_LOTNO   = '''+ls_Lotno+''' ';
      Try
        With UpdtQuery do
        Begin
          Close;
          SQL.Clear;
          SQL.ADD(var_sql);
          ExecSql;
        End;

        var_sql := ' Update MILSTK Set LSTK_FLAG = ''Y'' Where LSTK_LOCA = '''+ls_loca+''' ';
        With UpdtQuery do Begin
          Close;
          SQL.Clear;
          SQL.ADD(var_sql);
          ExecSql;
        End;
       Except
            Memo1.Lines.Add(Var_Sql);
            ShowMessage(Var_Sql);
       End;
       }
    End;
  End;
  // 실제 출고 데이타를 생성한다.
  // T2MILSTK SET LSTK_FLAG = 'M'
  // INDEX 만들고 INSERT T2MIOUPT
  OutLetData_Insert_Proc;

  // 끝나고 T2MILSTK SET LSTK_FLAG = 'Y'
  // SUBK_FLAG 는 통신에서 바꿔줌
  Replace_Table_Flag;
end;

procedure TFrm_4100.OutLetData_Insert_Proc;
var
  StrDate, StrCDate, StrIndex, StrRemark, StrTime, StrGubun, StrSeqNo, StrHSeqno : String;
  StrCode, StrLoca, Strboxno, SaveLoca, StrLoTno, Strboxno1, StrRemark1: String;
  Strindate, StrinTime, StrItemNo : String;
  StrStkQty, StrOutQty, StrReinQty, ls_date, ls_Rflag : String;

  StrProddate, Strjdate, strcust, Strjuno, StrLotid, StrArea, StrCname : String;

  Strhogi, StrTo, StrRflag : String;

  StrPltno, StrWsno : String;     // 김준영 추가

  NumStkQty, NumOutQty, NumReinQty : Real;
  NumSumQty, NumSumOutQty   : Real;

  sys_datetime : String;
  ls_sql : String;
begin
  sys_datetime  :=  f_get_sysdate_time();
  StrDate       :=  copy(sys_datetime, 1, 8);
  StrTime       :=  copy(sys_datetime, 9, 6);

  ls_sql := '          SELECT   ODAT_LOCA, ODAT_CODE, ODAT_LOTNO, ODAT_CUST, ODAT_RQTY, ';
  ls_sql := ls_sql + '          MAX(ODAT_INDATE) AS ODAT_INDATE, MAX(ODAT_INTIME) AS ODAT_INTIME, ';
  ls_sql := ls_sql + '          MAX(ODAT_BOXNO) ODAT_BOXNO, MAX(ODAT_REMARK) ODAT_REMARK, SUBK_PLTNO, ';
  ls_sql := ls_sql + '          MAX(ODAT_BOXNO1) ODAT_BOXNO1, MAX(ODAT_REMARK1) ODAT_REMARK1,  MAX(SUBK_WGT) AS SUBK_WGT, ODAT_WSNO ';
  ls_sql := ls_sql + ' FROM T2TIODAT2 (NOLOCK) ';
  ls_sql := ls_sql + ' LEFT OUTER JOIN T2MISUBK (NOLOCK) ON SUBK_LOCA = ODAT_LOCA ';
  ls_sql := ls_sql + ' WHERE ODAT_LOCA = SUBK_LOCA ';
  ls_sql := ls_sql + '       AND ODAT_CODE = SUBK_CODE ';
  ls_sql := ls_sql + '       AND ODAT_LOTNO = SUBK_LOTNO ';
  ls_sql := ls_sql + ' GROUP BY ODAT_LOCA, ODAT_CODE, ODAT_LOTNO, ODAT_CUST, ODAT_RQTY, SUBK_PLTNO, ODAT_WSNO ';
  ls_sql := ls_sql + ' ORDER BY ODAT_LOCA, SUBK_PLTNO, ODAT_CODE, ODAT_LOTNO, ODAT_CUST ';

  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    First;
    SaveLoca := '';
    While Not Eof Do Begin
      StrLoca      := FieldByName('ODAT_LOCA').AsString;
      StrCode      := FieldByName('ODAT_CODE').AsString;
      Strlotno     := FieldByName('ODAT_LOTNO').AsString;
      Strcust      := FieldByName('ODAT_CUST').AsString;
      Strindate    := FieldByName('ODAT_INDATE').AsString;
      Strintime    := FieldByName('ODAT_INTIME').AsString;
      StrBoxno     := FieldByName('ODAT_BOXNO').AsString;
      StrRemark    := FieldByName('ODAT_REMARK').AsString;
      StrPltno     := FieldByName('SUBK_PLTNO').AsString;
      StrBoxno1    := FieldByName('ODAT_BOXNO1').AsString;
      StrRemark1   := FieldByName('ODAT_REMARK1').AsString;
      NumOutQty    := FieldByName('ODAT_RQTY').AsFloat;
      NumStkQty    := FieldByName('SUBK_WGT').AsFloat;
      StrWsno      := FieldByName('ODAT_WSNO').AsString;

//      if (NumOutQty) = 0   Then begin Next; Continue; end;

      if SaveLoca <> StrLoca Then          // 파레트 번호가 다르면 신규 출고 Index 번호를 생성
      Begin

        ls_sql := ' Select STAT_ODATE, STAT_OINDX From T2TBSTAT (NOLOCK) ';
        ls_sql := ls_sql + ' Where STAT_PSWD = ''JPLS'' ';
        With StatQuery do Begin
          Close;
          SQL.Clear;
          SQL.Add(ls_sql);
          Open;

          ls_date := StatQuery.FieldByName('STAT_ODATE').AsString;
        End;

        if  (ls_date = StrDate)  then
        begin
          StrIndex := StrDate + 'O' + Format('%4.4d', [StatQuery.FieldByName('STAT_OINDX').AsInteger]);
          if StatQuery.FieldByName('STAT_OINDX').AsInteger >= 9999 Then Begin
            ls_sql := ' Update T2TBSTAT Set STAT_OINDX = Convert(Numeric, ''1'') ';
          End Else Begin
            ls_sql := ' Update T2TBSTAT Set STAT_OINDX = STAT_OINDX + 1 ';
          End;
            ls_sql := ls_sql + ' Where STAT_PSWD = ''JPLS'' ';
          end
          else
         begin
          StrIndex := StrDate + 'O' + Format('%4.4d', [1]);
          ls_sql := ' Update T2TBSTAT Set STAT_ODATE = '''+StrDate+''', STAT_OINDX = Convert(Numeric,''2'') ';
          ls_sql := ls_sql + ' Where STAT_PSWD = ''JPLS'' ';
         end;

         Try
            StatQuery.Close;
            StatQuery.SQL.Clear;
            StatQuery.SQL.Add(ls_sql);
            StatQuery.ExecSQL;
         Except
            ShowMessage(ls_sql);
         End;


        ls_sql := ' Select Sum(SUBK_WGT) SUBK_WGT, Sum(SUBK_RWGT) SUBK_RWGT ';
        ls_sql := ls_sql + ' From T2MISUBK (NOLOCK) Where SUBK_LOCA = '''+StrLoca+''' ';
        StatQuery.Close;
        StatQuery.SQL.Clear;
        StatQuery.SQL.Add(ls_sql);
        StatQuery.Open;

        NumSumQty    := StatQuery.FieldByName('SUBK_WGT').asFloat;
        NumSumOutQty := StatQuery.FieldByName('SUBK_RWGT').asFloat;

        If NumSumQty = NumSumOutQty Then StrGubun := 'T' Else StrGubun := 'P';

        Insert_Sche_Proc(StrIndex, StrLoca, StrGubun, StrWsno, StrPltno);

        SaveLoca := StrLoca;
       End;

      StrStkQty := FloatToStr(NumStkQty);
      StrOutQty := FloatToStr(NumOutQty);

      if NumStkQty <> NumOutQty Then Begin
         NumReinQty := NumStkQty - NumOutQty;
         StrReinQty := FloatToStr(NumReinQty);
      End;    


     
      NumOutQty    := FieldByName('ODAT_RQTY').AsFloat;
      NumStkQty    := FieldByName('SUBK_WGT').AsFloat;

      if (NumOutQty) = 0             Then  StrRflag  := 'R'
      else if (NumStkQty <> NumOutQty)  Then  StrRflag  := 'R'
      else if (NumStkQty = NumOutQty)   Then  StrRflag  := 'O'
      else  StrRflag  := 'O';

      ls_sql := ' Select ISNULL(Max(OUPT_SEQNO), 0) OUPT_SEQNO From T2MIOUPT (NOLOCK) ';
      ls_sql := ls_sql + ' Where OUPT_INDEX = '''+StrIndex+''' And  OUPT_LOCA = '''+StrLoca+''' ';
      ls_sql := ls_sql + '   And OUPT_CODE  = '''+StrCode+'''    ';
      ls_sql := ls_sql + '   And OUPT_LOTNO  = '''+StrLOTNO+'''    ';
      ls_sql := ls_sql + '   And OUPT_CUST  = '''+StrCust+'''    ';

      StatQuery.Close;
      StatQuery.SQL.Clear;
      StatQuery.SQL.Add(ls_sql);
      StatQuery.Open;

      StrSeqNo := Format('%4.4D', [StatQuery.FieldByName('OUPT_SEQNO').AsInteger + 1]);


      ls_sql := ' Insert Into T2MIOUPT(OUPT_DATE,       OUPT_INDEX,     OUPT_CODE,      OUPT_LOTNO,   OUPT_CUST,  ';
      ls_sql := ls_sql + ' OUPT_SEQNO,   OUPT_GUBUN,   OUPT_WGT,       OUPT_OUT_WGT,    ';
      ls_sql := ls_sql + ' OUPT_RLOCA,   OUPT_LOCA,    OUPT_TIME,      OUPT_RFLAG,      OUPT_JOB_FLAG, ';
      ls_sql := ls_sql + ' OUPT_INDATE,  OUPT_INTIME,    OUPT_BOXNO,      OUPT_REMARK,      ';
      ls_sql := ls_sql + ' OUPT_LABEL,   OUPT_ID,      OUPT_BOXNO1,    OUPT_REMARK1, OUPT_PLTNO) ';  // 김준영 PLTNO 추가
      ls_sql := ls_sql + ' Values('''+StrDate+''', '''+StrIndex+''','''+StrCode+''', '''+Strlotno+''', '''+Strcust+''',';
      ls_sql := ls_sql + ' '''+StrSeqNo+''', ''Y'', '''+StrStkQty+''',  '''+StrOutQty+''', ';
      ls_sql := ls_sql + ' '''+StrLoca+''',  '''+StrLoca+''', '''+StrTime+''', '''+StrRflag+''', ''0'',    ';
      ls_sql := ls_sql + ' '''+StrIndate+''', '''+StrIntime+''', '''+StrBoxno+''',  '''+StrRemark+''', ';
      ls_sql := ls_sql + ' ''N'', '''+jj_id+''', '''+StrBoxno1+''',  '''+StrRemark1+''', '''+StrPltno+'''    )  '; // 김준영 PLTNO 추가

      Try
        UpdtQuery.Close;
        UpdtQuery.SQL.Clear;
        UpdtQuery.SQL.Add(ls_sql);
        UpdtQuery.ExecSQL;
      Except
        ShowMessage(ls_sql);
      End;

       ls_sql := 'Update T2MILSTK Set ';
       ls_sql := ls_sql + ' LSTK_FLAG = ''Y'' ';
       ls_sql := ls_sql + ' Where LSTK_LOCA = '''+StrLoca+''' ';
     Try
       UpdtQuery.Close;
       UpdtQuery.SQL.Clear;
       UpdtQuery.SQL.Add(ls_sql);
       UpdtQuery.ExecSQL;

      Except
        ShowMessage(ls_sql);
      End;  
     
      Next;
    End;
  End;
end;

procedure TFrm_4100.Insert_Sche_Proc(OutIndex, OutLoca, OutGubun, OutWsno, OutPltno : String);
var
  StrSc, Strloca, StrFrom, StrHigh, StrDate, StrTime, StrTo : String;
  ls_cv1, ls_cv2, ls_cv3, ls_cv4, ls_cv5, ls_cv6 : String;
  ls_sql, ls_wsno : String;

  StrEmg : String; // 긴급 출고 여부 변수
begin
  StrDate := FormatDateTime('yyyymmdd', Now);
  StrTime := FormatDateTime('hhmmss', Now);

  StrLoca  := OutLoca;
  OutWsno  := OutWsno[Length(OutWsno)];

  if EmgCheckBox.Checked then StrEmg := 'E'
  else StrEmg := 'N';

  if (Copy(StrLoca, 1,1) = '1') Or (Copy(StrLoca, 1,1) = '2')      Then  StrSc := '1'
  Else if (Copy(StrLoca, 1,1) = '3') Or (Copy(StrLoca, 1,1) = '4') Then  StrSc := '2'
  Else if (Copy(StrLoca, 1,1) = '5') Or (Copy(StrLoca, 1,1) = '6') Then  StrSc := '3';

  {
  if OutWsno = '01' then OutWsno := '1'
  else if OutWsno = '02' then OutWsno := '2'
  else if OutWsno = '03' then OutWsno := '3'
  else if OutWsno = '04' then OutWsno := '4'
  else if OutWsno = '05' then OutWsno := '5'
  else if OutWsno = '06' then OutWsno := '6';
  }


  If       (OutWsno = '1') or (OutWsno = '3') or (OutWsno = '5')  then ls_wsno := '1'
  Else if  (OutWsno = '2') or (OutWsno = '4') or (OutWsno = '6')  then ls_wsno := '2';





  ls_sql := ' Select STAT_CV1, STAT_CV2, STAT_CV3, STAT_CV4, STAT_CV5, STAT_CV6 From T2TBSTAT (NOLOCK) ';
  ls_sql := ls_sql + ' Where STAT_PSWD = ''JPLS'' ';
  With StatQuery do Begin
          Close;
          SQL.Clear;
          SQL.Add(ls_sql);
          Open;

          ls_cv1 := FieldByName('STAT_CV1').AsString;
          ls_cv2 := FieldByName('STAT_CV2').AsString;
          ls_cv3 := FieldByName('STAT_CV3').AsString;
          ls_cv4 := FieldByName('STAT_CV4').AsString;
          ls_cv5 := FieldByName('STAT_CV5').AsString;
          ls_cv6 := FieldByName('STAT_CV5').AsString;
   End;

  {
  If (StrSc = '1')    then  begin
     if (ls_cv1 = '1') then  StrTo := '1' else  StrTo := '2';
  end
  else If (StrSc = '2')  then  begin
          if (ls_cv3 = '1') then  StrTo := '1' else  StrTo := '2';
  end
  else If (StrSc = '3')  then  begin
          if (ls_cv5 = '1') then  StrTo := '1' else  StrTo := '2';
  end;
  }

  // 고정이 아니라 선택한 station으로 가도록 설정.
  ls_sql := ' Insert Into T2TISCHE(SCHE_SC, SCHE_INDEX, SCHE_JOBGUBUN, SCHE_LOCA, ';
  ls_sql := ls_sql + '   SCHE_WSNO, SCHE_DATE, SCHE_TIME, SCHE_EMER, SCHE_PLTNO) ';
  ls_sql := ls_sql + ' Values('''+StrSC+''', '''+OutIndex+''', '''+OutGubun+''', '''+OutLoca+''',';
  ls_sql := ls_sql + ' '''+ls_wsno+''', '''+StrDate+''', '''+StrTime+''', '''+StrEmg+''', '''+OutPltno+''')  ';
  ls_sql := ls_sql + ' ';

  Try
    UpdtQuery.Close;
    UpdtQuery.SQL.Clear;
    UpdtQuery.SQL.Add(ls_sql);
    UpdtQuery.ExecSQL;
  Except
     ShowMessage(ls_sql);
  End;   
end;

procedure TFrm_4100.Replace_Table_Flag;
var
  ls_sql : String;
begin
  ls_sql := ' Update T2MILSTK Set LSTK_FLAG = ''Y'' ';
  ls_sql := ls_sql + ' Where LSTK_FLAG = ''M'' ';
  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSql;
    End;
  Except
    ShowMessage(ls_sql);
  End;


  // 재입고시 SUBK_FLAG = ''R''
  ls_sql := ' Update T2MISUBK Set SUBK_FLAG = ''Y'' ';
  ls_sql := ls_sql + ' Where SUBK_FLAG = ''M'' ';

  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSql;
    End;
  Except
    ShowMessage(ls_sql);
  End;
end;


function TFrm_4100.f_get_sysdate_time(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl (NOLOCK) ';
    With sDateQuery Do Begin
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

procedure TFrm_4100.OutSGGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
   if ARow = 0 then // Title부분은 전부 중앙정렬한다.
        HAlign := taCenter
    else begin

    if ACol in [8,9] then // 숫자값이 들어있는 번 Field의 데이터는 오른쪽으로 정렬한다.
        HAlign := taRightJustify
    else if ACol in [1,2] then HAlign := taCenter
    else // 나머지는 왼쪽으로 정렬한다.
        HAlign := taLeftJustify;
    end;
end;

procedure TFrm_4100.OutSGGetCellColor(Sender: TObject; ARow, ACol: Integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
   If ARow > 0 Then
    begin
       If ARow Mod 2 = 0 Then ABrush.Color := $00E4E4E4; // $00F0F1EF //$00EEF2EE //$00F2F3ED //$00E4E4E4;
    end;

      If ARow > 0 Then Begin
       Case ACol Of

//          0 :

           8, 9 : Begin
                 AFont.Color := clPurple;
                 AFont.Style := [fsBold];
                 ABrush.Color := clYellow;
               end;
           11 : Begin
{
            1,2,3,4,5,6,7, 8,9,10,11,12,13 : Begin
               if  (AdvSGrid.Cells[13, ARow] = 'Y') then  begin
                  AFont.Color   :=  clPurple;
                  AFont.Style := [fsBold];
                  ABrush.Color  := clYellow;
               end
               else   Begin
                    AFont.Color  := clBlack;
                    AFont.Style := [fsBold];
               End;
}
              End;


//          2 :  if  (AdvSGrid.Cells[ACol, ARow] <> '')  then  AFont.Color  := clRed;

       End;
    End;
end;

procedure TFrm_4100.itemClear;
begin
  // Item 초기화
  LocaEdit.Text     := '';
  pltnoEdit.Text    := '';
  ItemEdit.Text     := '';
  SpecNameEdit.Text := '';
  LotnoEdit.Text    := '';
  BoxNoEdit.Text    := '';
  BigoEdit.Text     := '';
  QtyEdit.Text      := '';
  RqtyEdit.Text     := '';
  CustEdit.Text     := '';
  BoxNo1Edit.Text   := '';
  Bigo1Edit.Text    := '';
  indateEdit.Text   := '';
  intimeEdit.Text   := '';
end;

procedure TFrm_4100.NameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    StartBtnClick(Self);
  end;
end;

procedure TFrm_4100.srcLotNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    StartBtnClick(Self);
  end;
end;

procedure TFrm_4100.baroSbClick(Sender: TObject);
var
  // 기본 변수
  StrDate, StrTime, StrIndex, StrSeqNo : String;
  ls_sql, ls_date, ls_wsno : String;
  
  // 설비 관련
  StrGubun, StrSc, StrTo : String;
  mps_r_ch01, mps_r_ch03, mps_r_ch05 : String;
  ls_bank : String;

  // 데이터 변수
  CurrentPlt, CurrentLoca, CurrentCode, CurrentLot : String;
  nQty, nRQty : Double;
  sCust, sBox, sBigo, sBox1, sBigo1 : String;
  sRFlag : String;

  // 집계 및 동반 품목용
  NumSumQty, NumSumOutQty : Double;
  dbCode, dbLot, dbBox, dbRemark : String;
  dbWgt, dbRWgt : Double;

  r : Integer;
begin
  // ---------------------------------------------------------------------------
  // 1. 유효성 검사
  // ---------------------------------------------------------------------------
  if Query1.FieldByName('SUBK_LOCA').AsString = '' Then Begin
    WinLib_ErrorForm('출고작업할 데이타가 없습니다.' + #13#10 + '조회 후 다시 시도 하십시요!!');
    Exit;
  End;

  if (QtyEdit.Text = '') or (StrToFloatDef(QtyEdit.Text, 0) <= 0) then Begin
    WinLib_ErrorForm('출고 가능한 재고가 없습니다.'); Exit;
  End;
  
  if (RQtyEdit.Text = '') or (StrToFloatDef(RQtyEdit.Text, 0) <= 0) then Begin
    WinLib_ErrorForm('지시 수량을 입력하세요.'); Exit;
  End;

  // ---------------------------------------------------------------------------
  // 2. [수정됨] 중복 방지 (OutSG에 있으면 바로출고 불가)
  // ---------------------------------------------------------------------------
  CurrentPlt := Trim(pltnoEdit.Text);

  for r := 1 to OutSG.RowCount - 1 do
  begin
    if Trim(OutSG.Cells[1, r]) = '' then Continue;

    // 그리드에 같은 PLT가 존재하면 에러 처리 후 종료
    if Trim(OutSG.Cells[2, r]) = CurrentPlt then
    begin
       WinLib_ErrorForm('경고: 해당 PLT[' + CurrentPlt + ']는 이미 출고예약 데이터에 존재합니다.' + #13#10 +
                        '목록에서 삭제하거나, 목록의 [출고예약] 버튼을 사용하십시오.' + #13#10 +
                        '※ 이중 출고 방지를 위해 바로 출고를 중단합니다.');
       Exit; // 강제 종료
    end;
  end;

  // ---------------------------------------------------------------------------
  // 3. 출고대(WSNO) 및 설비 상태 체크
  // ---------------------------------------------------------------------------
  StrQry := ' Select CVC1_CH01 From T2TBCVC1 (NOLOCK) Where CVC1_SR = ''R'' ';
  With DispQuery Do Begin Close; SQL.Clear; SQL.Add(StrQry); Open; mps_r_ch01 := FieldByName('CVC1_CH01').AsString; End;

  StrQry := ' Select CVC2_CH01  From T2TBCVC2 (NOLOCK) Where CVC2_SR = ''R'' ';
  With DispQuery Do Begin Close; SQL.Clear; SQL.Add(StrQry); Open; mps_r_ch03 := FieldByName('CVC2_CH01').AsString; End;

  StrQry := ' Select CVC3_CH01  From T2TBCVC3 (NOLOCK) Where CVC3_SR = ''R'' ';
  With DispQuery Do Begin Close; SQL.Clear; SQL.Add(StrQry); Open; mps_r_ch05 := FieldByName('CVC3_CH01').AsString; End;

  ls_bank := Copy(LocaEdit.Text,1,1);
  s_wsno  := '';

  // RadioButton 체크 확인
  if      (Rb1.Checked) then s_wsno := '1'
  else if (Rb2.Checked) then s_wsno := '2'
  else if (Rb3.Checked) then s_wsno := '3'
  else if (Rb4.Checked) then s_wsno := '4'
  else if (Rb5.Checked) then s_wsno := '5'
  else if (Rb6.Checked) then s_wsno := '6';

  if s_wsno = '' then begin
      WinLib_ErrorForm('출고할 컨베어 스테이션을 선택 하세요!!');
      Exit;
  end;

  // 설비 상태 체크 (CVC 상태)
  // [1호기]
  If (s_wsno = '1') then Begin
    if (Copy(mps_r_ch01,12,1) = '0') then begin WinLib_ErrorForm('01번 컨베어가 출고모드가 아닙니다.'); Exit; end;
    if (Copy(mps_r_ch01,16,1) = '0') then begin WinLib_ErrorForm('01번 컨베어가 자동모드가 아닙니다.'); Exit; end;
    if (ls_bank <> '1') and (ls_bank <> '2') then begin WinLib_ErrorForm('크레인이 출고 할수 없는 스테이션 입니다.'); Exit; end;
  End;
  If (s_wsno = '2') then Begin
    if (Copy(mps_r_ch01,13,1) = '0') then begin WinLib_ErrorForm('02번 컨베어가 출고모드가 아닙니다.'); Exit; end;
    if (Copy(mps_r_ch01,16,1) = '0') then begin WinLib_ErrorForm('02번 컨베어가 자동모드가 아닙니다.'); Exit; end;
    if (ls_bank <> '1') and (ls_bank <> '2') then begin WinLib_ErrorForm('크레인이 출고 할수 없는 스테이션 입니다.'); Exit; end;
  End;
  // [2호기]
  If (s_wsno = '3') then Begin
    if (Copy(mps_r_ch03,12,1) = '0') then begin WinLib_ErrorForm('03번 컨베어가 출고모드가 아닙니다.'); Exit; end;
    if (Copy(mps_r_ch03,16,1) = '0') then begin WinLib_ErrorForm('03번 컨베어가 자동모드가 아닙니다.'); Exit; end;
    if (ls_bank <> '3') and (ls_bank <> '4') then begin WinLib_ErrorForm('크레인이 출고 할수 없는 스테이션 입니다.'); Exit; end;
  End;
  If (s_wsno = '4') then Begin
    if (Copy(mps_r_ch03,13,1) = '0') then begin WinLib_ErrorForm('04번 컨베어가 출고모드가 아닙니다.'); Exit; end;
    if (Copy(mps_r_ch03,16,1) = '0') then begin WinLib_ErrorForm('04번 컨베어가 자동모드가 아닙니다.'); Exit; end;
    if (ls_bank <> '3') and (ls_bank <> '4') then begin WinLib_ErrorForm('크레인이 출고 할수 없는 스테이션 입니다.'); Exit; end;
  End;
  // [3호기]
  If (s_wsno = '5') then Begin
    if (Copy(mps_r_ch05,12,1) = '0') then begin WinLib_ErrorForm('05번 컨베어가 출고모드가 아닙니다.'); Exit; end;
    if (Copy(mps_r_ch05,16,1) = '0') then begin WinLib_ErrorForm('05번 컨베어가 자동모드가 아닙니다.'); Exit; end;
    if (ls_bank <> '5') and (ls_bank <> '6') then begin WinLib_ErrorForm('크레인이 출고 할수 없는 스테이션 입니다.'); Exit; end;
  End;
  If (s_wsno = '6') then Begin
    if (Copy(mps_r_ch05,13,1) = '0') then begin WinLib_ErrorForm('06번 컨베어가 출고모드가 아닙니다.'); Exit; end;
    if (Copy(mps_r_ch05,16,1) = '0') then begin WinLib_ErrorForm('06번 컨베어가 자동모드가 아닙니다.'); Exit; end;
    if (ls_bank <> '5') and (ls_bank <> '6') then begin WinLib_ErrorForm('크레인이 출고 할수 없는 스테이션 입니다.'); Exit; end;
  End;

  // ls_wsno 설정 (1: Left, 2: Right) -> Insert_Sche_Proc 호출용
  if (Rb1.Checked) or (Rb3.Checked) or (Rb5.Checked) then ls_wsno := '1'
  else ls_wsno := '2';


  // ---------------------------------------------------------------------------
  // 4. 바로 출고 실행 (트랜잭션 시작)
  // ---------------------------------------------------------------------------
  if Not WinLib_ConfirmForm('현재 입력된 내용으로 즉시 출고하시겠습니까?') then Exit;

  StrDate := FormatDateTime('yyyymmdd', Now);
  StrTime := FormatDateTime('hhmmss', Now);
  
  // 변수 세팅
  CurrentLoca := Trim(LocaEdit.Text);
  CurrentCode := Trim(ItemEdit.Text);
  CurrentLot  := Trim(LotnoEdit.Text);
  
  nQty        := StrToFloatDef(StringReplace(QtyEdit.Text, ',', '', [rfReplaceAll]), 0);
  nRQty       := StrToFloatDef(StringReplace(RqtyEdit.Text, ',', '', [rfReplaceAll]), 0);
  
  sCust       := Trim(CustEdit.Text);
  sBox        := Trim(BoxNoEdit.Text);
  sBigo       := Trim(BigoEdit.Text);
  sBox1       := Trim(BoxNo1Edit.Text);
  sBigo1      := Trim(Bigo1Edit.Text);

  if (nRQty = 0) then sRFlag := 'R'
  else if (nQty <> nRQty) then sRFlag := 'R'
  else sRFlag := 'O';


  UpdtQuery.Connection.BeginTrans;
  try
    // A. 작업 지시 번호(Index) 채번
    ls_sql := ' Select STAT_ODATE, STAT_OINDX From T2TBSTAT (NOLOCK) Where STAT_PSWD = ''JPLS'' ';
    With StatQuery do Begin Close; SQL.Text := ls_sql; Open; ls_date := FieldByName('STAT_ODATE').AsString; End;

    if (ls_date = StrDate) then
    begin
       StrIndex := StrDate + 'O' + Format('%4.4d', [StatQuery.FieldByName('STAT_OINDX').AsInteger]);
       if StatQuery.FieldByName('STAT_OINDX').AsInteger >= 9999 then
          ls_sql := ' Update T2TBSTAT Set STAT_OINDX = 1 Where STAT_PSWD = ''JPLS'' '
       else
          ls_sql := ' Update T2TBSTAT Set STAT_OINDX = STAT_OINDX + 1 Where STAT_PSWD = ''JPLS'' ';
    end
    else
    begin
       StrIndex := StrDate + 'O' + Format('%4.4d', [1]);
       ls_sql := ' Update T2TBSTAT Set STAT_ODATE = '''+StrDate+''', STAT_OINDX = 2 Where STAT_PSWD = ''JPLS'' ';
    end;
    UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;


    // B. 작업 구분(T/P) 판단
    ls_sql := ' Select Sum(SUBK_WGT) SUBK_WGT, Sum(SUBK_RWGT) SUBK_RWGT ';
    ls_sql := ls_sql + ' From T2MISUBK (NOLOCK) Where SUBK_LOCA = '''+CurrentLoca+''' '; 
    StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
    NumSumQty    := StatQuery.FieldByName('SUBK_WGT').asFloat;
    NumSumOutQty := StatQuery.FieldByName('SUBK_RWGT').asFloat;
    
    If NumSumQty <= (NumSumOutQty + nRQty) Then StrGubun := 'T' Else StrGubun := 'P';


    // C. 작업 지시 헤더(T2TISCHE) 생성
    Insert_Sche_Proc(StrIndex, CurrentLoca, StrGubun, ls_wsno, CurrentPlt);


    // D. [타겟 품목] 이력 생성 및 재고 업데이트
    ls_sql := ' Select ISNULL(Max(OUPT_SEQNO), 0) + 1 AS NEXT_SEQ From T2MIOUPT (NOLOCK) WHERE OUPT_INDEX = '''+StrIndex+''' ';
    StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
    StrSeqNo := Format('%4.4d', [StatQuery.FieldByName('NEXT_SEQ').AsInteger]);

    ls_sql := ' Insert Into T2MIOUPT(OUPT_DATE, OUPT_INDEX, OUPT_SEQNO, OUPT_PLTNO, OUPT_LOCA, OUPT_CODE, OUPT_LOTNO, ';
    ls_sql := ls_sql + '             OUPT_WGT, OUPT_OUT_WGT, OUPT_GUBUN, OUPT_JOB_FLAG, OUPT_CUST, OUPT_TIME, ';
    ls_sql := ls_sql + '             OUPT_BOXNO1, OUPT_REMARK1, OUPT_ID, OUPT_RFLAG, OUPT_BOXNO, OUPT_REMARK) ';
    ls_sql := ls_sql + ' Values ( '''+StrDate+''', '''+StrIndex+''', '''+StrSeqNo+''', '''+CurrentPlt+''', '''+CurrentLoca+''', '''+CurrentCode+''', '''+CurrentLot+''', ';
    ls_sql := ls_sql + '          '+FloatToStr(nQty)+', '+FloatToStr(nRQty)+', ''Y'', ''0'', '''+sCust+''', '''+StrTime+''', ';
    ls_sql := ls_sql + '          '''+sBox1+''', '''+sBigo1+''', '''+jj_id+''', '''+sRFlag+''', '''+sBox+''', '''+sBigo+''' ) ';
    
    UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

    ls_sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'', ';
    ls_sql := ls_sql + ' SUBK_RWGT = ISNULL(SUBK_RWGT,0) + ' + FloatToStr(nRQty) + ' ';
    ls_sql := ls_sql + ' Where SUBK_PLTNO = '''+CurrentPlt+''' ';
    ls_sql := ls_sql + '   AND SUBK_CODE  = '''+CurrentCode+''' ';
    ls_sql := ls_sql + '   AND SUBK_LOTNO = '''+CurrentLot+''' ';

    UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;


    // E. [나머지 품목] 처리
    ls_sql := ' SELECT SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK FROM T2MISUBK (NOLOCK) ';
    ls_sql := ls_sql + ' WHERE SUBK_PLTNO = ''' + CurrentPlt + ''' ';
    ls_sql := ls_sql + '   AND NOT (SUBK_CODE = ''' + CurrentCode + ''' AND SUBK_LOTNO = ''' + CurrentLot + ''') '; 
    
    DispQuery.Close; DispQuery.SQL.Text := ls_sql; DispQuery.Open;
    
    while not DispQuery.Eof do
    begin
       dbCode   := DispQuery.FieldByName('SUBK_CODE').AsString;
       dbLot    := DispQuery.FieldByName('SUBK_LOTNO').AsString;
       dbWgt    := DispQuery.FieldByName('SUBK_WGT').AsFloat;
       dbBox    := DispQuery.FieldByName('SUBK_BOXNO').AsString;
       dbRemark := DispQuery.FieldByName('SUBK_REMARK').AsString;

       ls_sql := ' Select ISNULL(Max(OUPT_SEQNO), 0) + 1 AS NEXT_SEQ From T2MIOUPT (NOLOCK) WHERE OUPT_INDEX = '''+StrIndex+''' ';
       StatQuery.Close; StatQuery.SQL.Text := ls_sql; StatQuery.Open;
       StrSeqNo := Format('%4.4d', [StatQuery.FieldByName('NEXT_SEQ').AsInteger]);

       ls_sql := ' Insert Into T2MIOUPT(OUPT_DATE, OUPT_INDEX, OUPT_SEQNO, OUPT_PLTNO, OUPT_LOCA, OUPT_CODE, OUPT_LOTNO, ';
       ls_sql := ls_sql + '             OUPT_WGT, OUPT_OUT_WGT, OUPT_GUBUN, OUPT_JOB_FLAG, OUPT_CUST, OUPT_TIME, ';
       ls_sql := ls_sql + '             OUPT_BOXNO1, OUPT_REMARK1, OUPT_ID, OUPT_RFLAG, OUPT_BOXNO, OUPT_REMARK) ';
       ls_sql := ls_sql + ' Values ( '''+StrDate+''', '''+StrIndex+''', '''+StrSeqNo+''', '''+CurrentPlt+''', '''+CurrentLoca+''', '''+dbCode+''', '''+dbLot+''', ';
       ls_sql := ls_sql + '          '+FloatToStr(dbWgt)+', 0, ''Y'', ''0'', '''', '''+StrTime+''', '; 
       ls_sql := ls_sql + '          '''', '''', '''+jj_id+''', ''R'', '''+dbBox+''', '''+dbRemark+''' ) ';

       UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

       ls_sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'' ';
       ls_sql := ls_sql + ' Where SUBK_PLTNO = '''+CurrentPlt+''' ';
       ls_sql := ls_sql + '   AND SUBK_CODE  = '''+dbCode+''' ';
       ls_sql := ls_sql + '   AND SUBK_LOTNO = '''+dbLot+''' ';
       
       UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

       DispQuery.Next;
    end;


    // F. 마스터(T2MILSTK) 업데이트
    ls_sql := ' Update T2MILSTK Set LSTK_FLAG = ''M'' Where LSTK_LOCA = '''+CurrentLoca+''' ';
    UpdtQuery.Close; UpdtQuery.SQL.Text := ls_sql; UpdtQuery.ExecSQL;

    // G. 마무리 (상태값 M -> Y 확정)
    Replace_Table_Flag;

    UpdtQuery.Connection.CommitTrans; 

    ShowMessage('바로 출고 처리가 완료되었습니다.');
    
    // [수정됨] 화면 정리 (패널 닫기)
    ResvGBox.Visible := False; 
    itemClear;
    StartBtnClick(Self); // 재조회

  except
    UpdtQuery.Connection.RollbackTrans; 
    WinLib_ErrorForm('바로 출고 처리 중 오류가 발생했습니다.');
  end;
end;

procedure TFrm_4100.ItemCodeMedKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBtnClick(Self);
end;

end.


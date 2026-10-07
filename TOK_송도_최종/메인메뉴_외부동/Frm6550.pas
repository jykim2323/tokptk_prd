unit Frm6550;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask, QRCtrls, QuickRpt, BaseGrid, AdvGrid,   excel2000, ComObj, Variants, clisted,
  Olectrls, ComCtrls;

type
  TFrm_6550 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    DataSource1: TDataSource;
    UpdtQuery: TADOQuery;
    ItemCB: TEdit;
    Panel3: TPanel;
    SB_Search: TSpeedButton;
    ExlBtn: TSpeedButton;
    Query1: TADOQuery;
    ExitBitBtn: TSpeedButton;
    StartBitBtn: TSpeedButton;
    Query2: TADOQuery;
    GroupBox2: TGroupBox;
    Rb2: TRadioButton;
    Rb1: TRadioButton;
    Rb3: TRadioButton;
    RbA: TRadioButton;
    AdvSGrid: TAdvStringGrid;
    GroupBox3: TGroupBox;
    Label14: TLabel;
    Gubn1Cb: TComboBox;
    Label5: TLabel;
    Gubn2Cb: TComboBox;
    Label6: TLabel;
    Gubn3Cb: TComboBox;
    PrintBitBtn: TSpeedButton;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRLabel18: TQRLabel;
    QT1T: TQRLabel;
    QT2T: TQRLabel;
    QS1T: TQRLabel;
    QTotalT: TQRLabel;
    QAT: TQRLabel;
    QBT: TQRLabel;
    QCT: TQRLabel;
    QDT: TQRLabel;
    QET: TQRLabel;
    QRLabel17: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRLabel22: TQRLabel;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel25: TQRLabel;
    QRLabel26: TQRLabel;
    QRBand3: TQRBand;
    QrlNo: TQRLabel;
    QCode: TQRLabel;
    QName: TQRLabel;
    QT1: TQRLabel;
    QT2: TQRLabel;
    QS1: TQRLabel;
    QTotal: TQRLabel;
    QGB1: TQRLabel;
    QGB2: TQRLabel;
    QGB3: TQRLabel;
    QA: TQRLabel;
    QB: TQRLabel;
    QC: TQRLabel;
    QD: TQRLabel;
    QE: TQRLabel;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel3: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRBand7: TQRBand;
    QRExpr1: TQRExpr;
    DateTimePicker1: TDateTimePicker;
    ItemNmEdit2: TEdit;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);  
    procedure StartBitBtnClick(Sender: TObject);  
    procedure ItemCBChange(Sender: TObject);   
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char);      

    procedure ExlBtnClick(Sender: TObject);    
    procedure SB_SearchClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure Rb1Click(Sender: TObject);
    procedure Gubn1CbChange(Sender: TObject);
    procedure AdvSGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure AdvSGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure AdvSGridGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure AdvSGridCanSort(Sender: TObject; ACol: Integer;
      var DoSort: Boolean);
    procedure QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);    
    procedure QRBand6BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure QRBand3BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure QRBand2BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
   
  private
    { Private declarations }
    procedure Data_Grid_Clear;
    procedure GridToExel(s_title, s_date, s_seldate: string);
  public
    { Public declarations }
  end;

var
  Frm_6550: TFrm_6550;

  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;

  Var_ItemDiv : String;

  s_code, s_cvcod, s_loca,  s_lotno, s_jpno, s_qty, s_bqty, s_date,  s_time, s_gubun : String;
  s_pltno, s_flag, s_depot, s_rqty, s_awh : String;
  li_BOXQTY, li_bqty, li_qty  : Real;

  RowCnt,   i : Integer;
  sum_sqty, sum_wqty, sum_fqty, sum_tqty  : Real;
  sum_aqty, sum_bqty, sum_cqty, sum_dqty, sum_eqty  : Real;
implementation

uses DBSet, WinLib, FrmPrompt, FrmError, MastDisp;

{$R *.dfm}


procedure TFrm_6550.FormCreate(Sender: TObject);
var
  ls_sql, StrCode, ls_gubn, ls_name : String;
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  // [추가] 날짜 초기화 (오늘)
  DateTimePicker1.Date := Date;

  rbA.checked := True;

  Gubn1CB.Clear;
  Gubn1CB.Items.Add('');
  ls_sql := ' Select GUBN1_CODE, GUBN1_NAME  From MIGUBN1 (NOLOCK) ';
  ls_sql := ls_sql + ' Order by  GUBN1_CODE ';
  With Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    While Not Eof do   begin
       ls_gubn := FieldByName('GUBN1_CODE').AsString;
       ls_name := FieldByName('GUBN1_NAME').AsString;
       Gubn1CB.Items.Add(ls_gubn + '-' +  ls_name);
       Next;
    end;
  End;
  Gubn1CB.ItemIndex := -1;

  Gubn2CB.Clear;
  Gubn2CB.Items.Add('');
  ls_sql := ' Select GUBN2_CODE, GUBN2_NAME  From MIGUBN2 (NOLOCK) ';
  ls_sql := ls_sql + ' Order by  GUBN2_CODE ';
  With Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    While Not Eof do   begin
       ls_gubn := FieldByName('GUBN2_CODE').AsString;
       ls_name := FieldByName('GUBN2_NAME').AsString;
       Gubn2CB.Items.Add(ls_gubn + '-' +  ls_name);
       Next;
    end;
  End;
  Gubn2CB.ItemIndex := -1;

  Gubn3CB.Clear;
  Gubn3CB.Items.Add('');
  ls_sql := ' Select GUBN3_CODE, GUBN3_NAME  From MIGUBN3 (NOLOCK) ';
  ls_sql := ls_sql + ' Order by  GUBN3_CODE ';
  With Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    First;
    While Not Eof do   begin
       ls_gubn := FieldByName('GUBN3_CODE').AsString;
       ls_name := FieldByName('GUBN3_NAME').AsString;
       Gubn3CB.Items.Add(ls_gubn + '-' +  ls_name);
       Next;
    end;
  End;
  Gubn3CB.ItemIndex := -1;

  // StartBitBtnClick(self);
end;

procedure TFrm_6550.Data_Grid_Clear;
var
  IntCnt : Integer;
begin

  With AdvSGrid Do Begin
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
     Cells[12,IntCnt]  := '';
     Cells[13,IntCnt]  := '';
     Cells[14,IntCnt]  := '';
     Cells[15,IntCnt]  := '';
     Cells[16,IntCnt]  := '';
     Cells[17,IntCnt]  := '';
     Cells[18,IntCnt]  := '';
    End;
  End;
  AdvSGrid.RowCount := 2;
end;


procedure TFrm_6550.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
   if key <> #13 then Exit;
   StartBitBtnClick(self);
end;

procedure TFrm_6550.StartBitBtnClick(Sender: TObject);
var
   ls_gubn1,  ls_gubn2,  ls_gubn3 : String;
   iRow : Integer;
   AmtQty  : Real;
begin
  sum_sqty := 0;  sum_wqty := 0; sum_fqty := 0; sum_tqty := 0;
  sum_aqty := 0;  sum_bqty := 0; sum_cqty := 0;  sum_dqty := 0; sum_eqty := 0;

  Data_Grid_Clear;

  ls_gubn1 :=  Trim(Copy(Gubn1Cb.Text,1,1));
  ls_gubn2 :=  Trim(Copy(Gubn2Cb.Text,1,1));
  ls_gubn3 :=  Trim(Copy(Gubn3Cb.Text,1,1));

  with Query1 do Begin
    Close;
    SQL.Clear;
    
    SQL.Add(' SELECT H.STOK_ITEM, ');
    SQL.Add('        MAX(M.MAST_NAME) AS MAST_NAME, ');
    
    // 1. 장소별 수량 집계
    SQL.Add('        SUM(CASE WHEN H.STOK_WH = ''S'' THEN H.STOK_QTY ELSE 0 END) AS STOK_SQTY, '); // 생산동
    SQL.Add('        SUM(CASE WHEN H.STOK_WH = ''W'' THEN H.STOK_QTY ELSE 0 END) AS STOK_WQTY, '); // 외부동
    SQL.Add('        SUM(CASE WHEN H.STOK_WH = ''M'' THEN H.STOK_QTY ELSE 0 END) AS STOK_FQTY, '); // 수동창고(M으로 가정)

    SQL.Add('        SUM(CASE WHEN H.STOK_WH = ''A'' THEN H.STOK_QTY ELSE 0 END) AS STOK_AQTY, ');
    SQL.Add('        SUM(CASE WHEN H.STOK_WH = ''B'' THEN H.STOK_QTY ELSE 0 END) AS STOK_BQTY, ');
    SQL.Add('        SUM(CASE WHEN H.STOK_WH = ''C'' THEN H.STOK_QTY ELSE 0 END) AS STOK_CQTY, ');
    SQL.Add('        SUM(CASE WHEN H.STOK_WH = ''D'' THEN H.STOK_QTY ELSE 0 END) AS STOK_DQTY, ');
    SQL.Add('        SUM(CASE WHEN H.STOK_WH = ''E'' THEN H.STOK_QTY ELSE 0 END) AS STOK_EQTY, ');

    SQL.Add('        SUM(H.STOK_QTY) AS STOK_TQTY, '); // 전체 합계

    SQL.Add('        MAX(G1.GUBN1_NAME) AS GUBN1_NAME, ');
    SQL.Add('        MAX(G2.GUBN2_NAME) AS GUBN2_NAME, ');
    SQL.Add('        MAX(G3.GUBN3_NAME) AS GUBN3_NAME  ');

    SQL.Add(' FROM MISTOK_HIST H (NOLOCK) '); 
    SQL.Add(' LEFT OUTER JOIN MIMAST M (NOLOCK) ON H.STOK_ITEM = M.MAST_CODE ');
    SQL.Add(' LEFT OUTER JOIN MIGUBN1 G1 (NOLOCK) ON M.MAST_GUBN1 = G1.GUBN1_CODE ');
    SQL.Add(' LEFT OUTER JOIN MIGUBN2 G2 (NOLOCK) ON M.MAST_GUBN2 = G2.GUBN2_CODE ');
    SQL.Add(' LEFT OUTER JOIN MIGUBN3 G3 (NOLOCK) ON M.MAST_GUBN3 = G3.GUBN3_CODE ');

    SQL.Add(' WHERE H.CLOSE_DATE = '''+FormatDateTime('yyyymmdd', DateTimePicker1.Date)+''' ');
    SQL.Add('   AND ISNULL(H.STOK_ITEM, '''') <> '''' ');

   //if Length(Trim(ItemCb.Text)) > 0 then SQL.Add(' And  H.STOK_ITEM  LIKE '''+itemCB.Text+'%''    ');
   if Length(Trim(ItemCb.Text)) > 0 then SQL.Add(' And  H.STOK_ITEM = '''+Trim(itemCB.Text)+'''    ');

   if Length(Trim(ItemNmEdit2.Text)) > 0 then SQL.Add(' And  M.MAST_NAME LIKE ''%'+ItemNmEdit2.Text+'%''    ');
    
    // 라디오 버튼 (창고 구분)
    If rb1.Checked = True then  SQL.Add(' AND H.STOK_WH NOT IN (''S'',''W'') ');
    If rb2.Checked = True then  SQL.Add(' AND H.STOK_WH = ''S'' ');
    If rb3.Checked = True then  SQL.Add(' AND H.STOK_WH = ''W'' ');

    // 분류 조건
    if (ls_gubn1 <> '') then  SQL.Add(' AND M.MAST_GUBN1 = ''' + ls_gubn1 + ''' ');
    if (ls_gubn2 <> '') then  SQL.Add(' AND M.MAST_GUBN2 = ''' + ls_gubn2 + ''' ');
    if (ls_gubn3 <> '') then  SQL.Add(' AND M.MAST_GUBN3 = ''' + ls_gubn3 + ''' ');

    SQL.Add(' GROUP BY H.STOK_ITEM ');
    SQL.Add(' ORDER BY H.STOK_ITEM ');

    Open;
    First;
  End;

  if (Query1.RecordCount = 0) then Exit;

  iRow := 0;
  AdvSGrid.RowCount := Query1.RecordCount + 2; // 성능 확보

  while not Query1.Eof do
  begin
       inc(iRow);

       AdvSGrid.Cells[1, iRow] := IntToStr(iRow);
       AdvSGrid.Cells[2, iRow] := Query1.FieldByName('STOK_ITEM').AsString;
       AdvSGrid.Cells[3, iRow] := Query1.FieldByName('MAST_NAME').AsString;

       // 생산동(S)
       AmtQty    := Query1.FieldByName('STOK_SQTY').AsFloat;
       AdvSGrid.Cells[4, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_sqty := sum_sqty + AmtQty;

       // 외부동(W)
       AmtQty    := Query1.FieldByName('STOK_WQTY').AsFloat;
       AdvSGrid.Cells[5, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_wqty := sum_wqty + AmtQty;

       // 수동창고(M)
       AmtQty    := Query1.FieldByName('STOK_FQTY').AsFloat;
       AdvSGrid.Cells[6, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_fqty := sum_fqty + AmtQty;

       // 합계
       AmtQty    := Query1.FieldByName('STOK_TQTY').AsFloat;
       AdvSGrid.Cells[7, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_tqty := sum_tqty + AmtQty;

       // 분류명
       AdvSGrid.Cells[8, iRow]  := Query1.FieldByName('GUBN1_NAME').AsString;
       AdvSGrid.Cells[9, iRow]  := Query1.FieldByName('GUBN2_NAME').AsString;
       AdvSGrid.Cells[10, iRow] := Query1.FieldByName('GUBN3_NAME').AsString;

       // 창고 A~E
       AmtQty    := Query1.FieldByName('STOK_AQTY').AsFloat;
       AdvSGrid.Cells[11, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_aqty := sum_aqty + AmtQty;

       AmtQty    := Query1.FieldByName('STOK_BQTY').AsFloat;
       AdvSGrid.Cells[12, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_bqty := sum_bqty + AmtQty;

       AmtQty    := Query1.FieldByName('STOK_CQTY').AsFloat;
       AdvSGrid.Cells[13, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_cqty := sum_cqty + AmtQty;

       AmtQty    := Query1.FieldByName('STOK_DQTY').AsFloat;
       AdvSGrid.Cells[14, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_dqty := sum_dqty + AmtQty;

       AmtQty    := Query1.FieldByName('STOK_EQTY').AsFloat;
       AdvSGrid.Cells[15, iRow] := FormatFloat('###,##0.##', AmtQty);
       sum_eqty := sum_eqty + AmtQty;

       Query1.Next;
  end;

  // 마지막 합계 행 처리
  if (iRow > 0) then
  begin
     inc(iRow);
     AdvSGrid.RowCount := iRow + 1;

     AdvSGrid.Cells[3, iRow] := '[합 계]';
     AdvSGrid.Cells[4, iRow] := FormatFloat('###,##0.#', Sum_sqty);
     AdvSGrid.Cells[5, iRow] := FormatFloat('###,##0.#', Sum_wqty);
     AdvSGrid.Cells[6, iRow] := FormatFloat('###,##0.#', Sum_fqty);
     AdvSGrid.Cells[7, iRow] := FormatFloat('###,##0.#', Sum_tqty);
     AdvSGrid.Cells[11, iRow] := FormatFloat('###,##0.#', Sum_aqty);
     AdvSGrid.Cells[12, iRow] := FormatFloat('###,##0.#', Sum_bqty);
     AdvSGrid.Cells[13, iRow] := FormatFloat('###,##0.#', Sum_cqty);
     AdvSGrid.Cells[14, iRow] := FormatFloat('###,##0.#', Sum_dqty);
     AdvSGrid.Cells[15, iRow] := FormatFloat('###,##0.#', Sum_eqty);
  end else begin
     AdvSGrid.RowCount := 2;
  end;
end;
        

procedure TFrm_6550.ExlBtnClick(Sender: TObject);
var
  ls_date, ls_title, ls_seldate  : String;
begin
 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     ls_date  := DateTimeToStr( Now );
     // DateTimePicker1의 날짜를 문자열로 변환
     ls_seldate := FormatDateTime('yyyy-mm-dd', DateTimePicker1.Date);

     ls_title  := '수자동 재고 이력 (' + ls_seldate + ')';
     
     // GridToExel 호출 (파라미터 3개)
     GridToExel(ls_title, ls_date, ls_seldate);
 end;
end;


procedure TFrm_6550.ItemCBChange(Sender: TObject);
begin
   StartBitBtnClick(self);
end;




procedure TFrm_6550.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_6550.FormDestroy(Sender: TObject);
begin
  Frm_6550 := Nil;
end;

procedure TFrm_6550.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;  

procedure TFrm_6550.SB_SearchClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  Mast_Disp  := TMast_Disp.Create(Application);
  Bol_Modal := True;

  Mast_Disp.Edt_Search.Text := ItemCB.Text;
  If Mast_Disp <> Nil Then
    With TForm(Mast_Disp) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      Mast_Disp.Free;
    End;

    ItemCB.Text :=  jj_code;
end;

procedure TFrm_6550.PrintBitBtnClick(Sender: TObject);
begin
 if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_6550.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  RowCnt := 0;   i := 0;
end;

procedure TFrm_6550.QuickRep1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  MoreData := RowCnt < AdvSGrid.RowCount + 1;
end;

procedure TFrm_6550.QRBand3BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
   i := RowCnt + 1;
   QrlNo.Caption := IntToStr(i);
   Inc(RowCnt);

  QCode.Caption  :=  AdvSGrid.Cells[2, RowCnt];
  QName.Caption  :=  AdvSGrid.Cells[3, RowCnt];
  QT1.Caption    :=  AdvSGrid.Cells[4, RowCnt];
  QT2.Caption    :=  AdvSGrid.Cells[5, RowCnt];
  QS1.Caption    :=  AdvSGrid.Cells[6, RowCnt];
  QTotal.Caption :=  AdvSGrid.Cells[7, RowCnt];
  QGB1.Caption   :=  AdvSGrid.Cells[8, RowCnt];
  QGB2.Caption   :=  AdvSGrid.Cells[9, RowCnt];
  QGB3.Caption   :=  AdvSGrid.Cells[10, RowCnt];
  QA.Caption     :=  AdvSGrid.Cells[11, RowCnt];
  QB.Caption     :=  AdvSGrid.Cells[12, RowCnt];
  QC.Caption     :=  AdvSGrid.Cells[13, RowCnt];
  QD.Caption     :=  AdvSGrid.Cells[14, RowCnt];
  QE.Caption     :=  AdvSGrid.Cells[15, RowCnt];
end;

procedure TFrm_6550.QRBand2BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
   QT1T.Caption    := FormatFloat('###,##0.#', Sum_sqty);
   QT2T.Caption    := FormatFloat('###,##0.#', Sum_wqty);
   QS1T.Caption    := FormatFloat('###,##0.#', Sum_fqty);
   QTotalT.Caption := FormatFloat('###,##0.#', Sum_tqty);
   QAT.Caption     := FormatFloat('###,##0.#', Sum_aqty);
   QBT.Caption     := FormatFloat('###,##0.#', Sum_bqty);
   QCT.Caption     := FormatFloat('###,##0.#', Sum_cqty);
   QDT.Caption     := FormatFloat('###,##0.#', Sum_dqty);
   QET.Caption     := FormatFloat('###,##0.#', Sum_eqty);
end;

procedure TFrm_6550.QRBand6BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
   QT1T.Caption    := FormatFloat('###,##0.#', Sum_sqty);
   QT2T.Caption    := FormatFloat('###,##0.#', Sum_wqty);
   QS1T.Caption    := FormatFloat('###,##0.#', Sum_fqty);
   QTotalT.Caption := FormatFloat('###,##0.#', Sum_tqty);
   QAT.Caption     := FormatFloat('###,##0.#', Sum_aqty);
   QBT.Caption     := FormatFloat('###,##0.#', Sum_bqty);
   QCT.Caption     := FormatFloat('###,##0.#', Sum_cqty);
   QDT.Caption     := FormatFloat('###,##0.#', Sum_dqty);
   QET.Caption     := FormatFloat('###,##0.#', Sum_eqty);
end;

procedure TFrm_6550.Rb1Click(Sender: TObject);
begin
  StartBitBtnClick(self);
end;

procedure TFrm_6550.Gubn1CbChange(Sender: TObject);
begin
   StartBitBtnClick(self);
end;

procedure TFrm_6550.AdvSGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
         with (Sender as TStringGrid) do
  begin
    // Don't change color for first Column, first row
    if (ACol = 0) or (ARow = 0) then
      Canvas.Brush.Color := clBtnFace
    else
    begin
     if (ACol = 2) then
      begin
       if  (AdvSGrid.Cells[2, ARow] <> '')  then
       begin
//         Canvas.Font.Color := clBlue;
//         Canvas.Brush.Color := $00E1FFF9;
//         Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, cells[acol, arow]);
//         Canvas.FrameRect(Rect);
       end;


       end;
    end;
  end;
end;

procedure TFrm_6550.AdvSGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then // Title부분은 전부 중앙정렬한다.
        HAlign := taCenter
    else begin

    if ACol in [4,5,6,7,11,12,13,14,15] then // 숫자값이 들어있는 번 Field의 데이터는 오른쪽으로 정렬한다.
        HAlign := taRightJustify
//    else if ACol in [1,5] then HAlign := taCenter
    else // 나머지는 왼쪽으로 정렬한다.
        HAlign := taLeftJustify;
    end;
end;

procedure TFrm_6550.AdvSGridGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
   ls_wsum, ls_jsum : STring;
   li_wsum, li_jsum : Real;
begin
   If ARow > 0 Then
    begin
       If ARow Mod 2 = 0 Then ABrush.Color := $00E4E4E4; // $00F0F1EF //$00EEF2EE //$00F2F3ED //$00E4E4E4;
    end;

      If ARow > 0 Then Begin
       Case ACol Of
{
          0 :
          1 :
          2 :
          3 :
          4 :
          5 :
}
          7,9 : Begin
               AFont.Color  := clBlue;    //수량   폰트색 지정
//               ABrush.Color := clMoneyGreen;
               AFont.Style := [fsBold];
               End;

//        1 :  ABrush.Color := clLime;  //선택   바탕색 지정
          //ABrush.Color := clSilver;  //선택   바탕색 지정

//          2 :  if  (AdvSGrid.Cells[ACol, ARow] <> '')  then  AFont.Color  := clRed;

       End;
    End;


    if (ARow > 0) and (ACol in [2]) then ABrush.Color := $00A7D2FA;
    if (ARow > 0) and (ACol in [5]) then ABrush.Color := $00FFE4CA;
    if (ARow > 0) and (ACol in [7]) then ABrush.Color := $00B0FFD8;
end;

procedure TFrm_6550.AdvSGridCanSort(Sender: TObject; ACol: Integer;
  var DoSort: Boolean);
begin
   Cursor := crHourGlass;
end;

{*****************************************************************************}
{*  엑셀저장처리                                                             *}
{*****************************************************************************}
procedure TFrm_6550.GridToExel(s_title,  s_date, s_seldate: string);
var
   i,j, Row, Col, ColCnt, RowCnt, BookCount:Integer;
   V, sheet : Variant;
begin

 ColCnt:= 9;
 RowCnt:= AdvSGrid.RowCount - 1;
 J := 0;

 try
    if VarIsEmpty(V) then begin
      BookCount := 0;
      V := CreateOleObject('Excel.Application');
    end;
    V.Visible := False;
    V.WorkBooks.Add;
    BookCount := BookCount + 1;
    Sheet := V.Workbooks[BookCount].Sheets[1];
    Sheet.Name := '재고이력'; 
 except 
 end;    

  V.Cells[1,4].Value := '[[ ' + s_title + ' ]]';
  V.Cells[1,4].Font.Size := '22';
  V.Cells[1,4].Font.Name := '굴림체';
  V.Cells[1,4].Font.FontStyle := 'Bold';
  V.Cells[1,4].EntireRow.Interior.Color := $02EEEEEE;

  V.Cells[2,1].Value := '발행일시:';
  V.Cells[2,1].Font.FontStyle := 'Bold';
  V.Cells[2,2].Value := s_date;
  V.Cells[2,2].Font.FontStyle := 'Bold';

  // [수정] 단일 일자 표시
  V.Cells[3,1].Value := '조회일자:';
  V.Cells[3,1].Font.FontStyle := 'Bold';
  V.Cells[3,2].Value := s_seldate;

  for Row := 5 to RowCnt+5 do begin
    V.Cells[Row,1].Value := AdvSGrid.Cells[1, J]; 
    V.Cells[Row,2].Value := AdvSGrid.Cells[2, J]; 

    V.Cells[Row,2].NumberFormat := '@'; 
    V.Cells[Row,2].HorizontalAlignment := xlHAlignLeft;

    V.Cells[Row,3].Value := AdvSGrid.Cells[3, J]; 
    V.Cells[Row,3].NumberFormat := '@';
    V.Cells[Row,3].HorizontalAlignment := xlHAlignLeft;

    V.Cells[Row,4].Value := AdvSGrid.Cells[4, J];
    V.Cells[Row,5].Value := AdvSGrid.Cells[5, J];
    V.Cells[Row,6].Value := AdvSGrid.Cells[6, J];
    V.Cells[Row,7].Value := AdvSGrid.Cells[7, J];
    V.Cells[Row,8].Value := AdvSGrid.Cells[8, J];
    V.Cells[Row,9].Value := AdvSGrid.Cells[9, J];
    V.Cells[Row,10].Value := AdvSGrid.Cells[10, J];
    V.Cells[Row,11].Value := AdvSGrid.Cells[11, J];
    V.Cells[Row,12].Value := AdvSGrid.Cells[12, J];
    V.Cells[Row,13].Value := AdvSGrid.Cells[13, J];
    V.Cells[Row,14].Value := AdvSGrid.Cells[14, J];
    V.Cells[Row,15].Value := AdvSGrid.Cells[15, J];
    V.Cells[Row,16].Value := AdvSGrid.Cells[16, J];
    V.Cells[Row,17].Value := AdvSGrid.Cells[17, J];
    V.Cells[Row,18].Value := AdvSGrid.Cells[18, J]; 

    J := J + 1;
 end;   

 V.Columns.AutoFit;
 V.Quit;
end;





end.


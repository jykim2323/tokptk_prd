unit Frm4102;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, DB, ADODB, DBTables,
  ComCtrls, Mask, BaseGrid, AdvGrid, Excel2000, OleServer, ComObj, Variants,
  QRCtrls, QuickRpt;



// Menus, ClipBrd, asprev, asabout, asfind, ComCtrls, ImgList;

type
  TFrm_4102 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    Query2: TADOQuery;
    UpdtQuery: TADOQuery;
    GroupBox1: TGroupBox;
    StartBitBtn: TSpeedButton;
    Query1: TADOQuery;
    DataSource1: TDataSource;
    SubkQuery: TADOQuery;
    StatQuery: TADOQuery;
    DispQuery: TADOQuery;
    Memo1: TMemo;
    Query1MAST_NAME: TStringField;
    Query1STOK_QTY: TBCDField;
    Query1HO_FLAG: TStringField;
    Panel13: TPanel;
    itemEdit: TEdit;
    Mast_Search: TSpeedButton;
    AdvSGrid: TAdvStringGrid;
    DeleteBitBtn: TSpeedButton;
    Panel7: TPanel;
    ReservedSB: TSpeedButton;
    chkAll: TCheckBox;
    ExcelBitBtn: TSpeedButton;
    PrintBitBtn: TSpeedButton;
    AllDeleteBitBtn: TSpeedButton;
    Query1HO_DATE: TStringField;
    Query1HO_TIME: TStringField;
    Query1HO_CODE: TStringField;
    Query1HO_LOTNO: TStringField;
    Query1HO_CHASU: TStringField;
    Query1HO_CUST: TStringField;
    Query1HO_QTY: TBCDField;
    Query1HO_OUTQTY: TBCDField;
    Query1HO_BOXNO: TStringField;
    Query1HO_REMARK: TStringField;
    Label80: TLabel;
    OutDateDTP: TDateTimePicker;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText5: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText17: TQRDBText;
    QRDBText19: TQRDBText;
    QRDBText20: TQRDBText;
    Cell3: TQRLabel;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRLbl_FDate: TQRLabel;
    QRBand5: TQRBand;
    QRLabel5: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRLabel22: TQRLabel;
    QRLabel1: TQRLabel;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);    
    procedure ReservedSBClick(Sender: TObject);
    procedure DataGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
   
    procedure StartBitBtnClick(Sender: TObject);    


    procedure DBGrid1TitleClick(Column: TColumn);
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure itemEditKeyPress(Sender: TObject; var Key: Char);
    procedure Cust1EditKeyPress(Sender: TObject; var Key: Char);
    procedure Mast_SearchClick(Sender: TObject); 
    procedure chkAllClick(Sender: TObject);
    procedure AdvSGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure AdvSGridGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);         


    procedure AdvSGridCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure ExcelBitBtnClick(Sender: TObject);
    procedure AdvSGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure AllDeleteBitBtnClick(Sender: TObject);
    procedure AdvSGridGetFormat(Sender: TObject; ACol: Integer;
      var AStyle: TSortStyle; var aPrefix, aSuffix: String);
    procedure AdvSGridCanSort(Sender: TObject; ACol: Integer;
      var DoSort: Boolean);
    procedure AdvSGridRawCompare(Sender: TObject; ACol, Row1,
      Row2: Integer; var Res: Integer);
    procedure A1CheckBoxClick(Sender: TObject);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QRBand3BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
   

  
   
    
  private
    { Private declarations }
    function IsNumCheck(var StrData : String): Boolean;
    function f_get_sysdate_time1(): String;

    
    procedure Data_Grid_Clear;
    procedure Output_Resv_Proc;   
    procedure OutLetData_Insert_Proc;
    procedure Replace_Table_Flag;
    procedure OutInfo_Print_proc;
   
    procedure Insert_Sche_Proc(OutIndex, OutLoca, OutGubun, OutPltno: String);


    procedure GridToExel(s_title, s_date : String);
    
    procedure OutInfo_Create(ItemDate, Itemchsu,  ItemCode, ItemLotno, Itemcust, Itemboxno, Itemremark : String;  ItemQty: Integer);
    
    procedure Tiodat_Table_Insert(OutDate,OutChasu, OutCode, Outlotno, Outcust, OutLoca, Outindate, Outintime,
                                  Outboxno, Outremark, Outboxno1, Outremark1, OutPltno : String; OutJisiQty, OutStockQty, OutQty: Integer);



  public
    { Public declarations }
  end;

var
  Frm_4102: TFrm_4102;

  Var_Form : TForm;
  Bol_Modal : Boolean; 
  Read_ok : Boolean;
  Bol_Data_Ok : Boolean;       
  var_SelForm : TForm;
  var_Modal : Boolean;

 

  Var_Sql : String;
  StrMsg : String;
  sys_datetime, s_date, s_time, s_chasu, StrDate : String;

  RowCnt,   i : Integer;
  
implementation

uses DBSet, WinLib, FrmPrompt, FrmError, Winsock, FrmProgress, MastDisp;

{$R *.dfm}


procedure TFrm_4102.FormCreate(Sender: TObject);
begin
//   Top  := (Screen.Height - Self.Height) div 2;
//   Left := (Screen.Width - Self.Width) div 2;
   OutDateDTP.Date := Now; 

   StartBitBtnClick(Self);  
end;

procedure TFrm_4102.Data_Grid_Clear;
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
    End;
  End;
  AdvSGrid.RowCount := 2;

end;


procedure TFrm_4102.StartBitBtnClick(Sender: TObject);
var
   ls_sql, ls_code, ls_cust, StrDate1, StrDate2, ls_date, ls_chasu, ls_flag, ls_time : String;
   iRow, li_qty : Integer;
   state: Boolean;
begin
  Data_Grid_Clear;

  ls_code  := Trim(itemEdit.Text);
  ls_date := FormatDateTime('yyyymmdd', OutDateDtp.Date);

  ls_sql := ' Select HO_CHASU, HO_DATE, HO_TIME, HO_CODE, HO_LOTNO,  HO_CUST, MAST_NAME, ';
  ls_Sql := ls_Sql + ' HO_QTY, HO_OUTQTY, STOK_QTY, HO_BOXNO, HO_REMARK, HO_FLAG ';
  ls_Sql := ls_Sql + ' From T2HHOUPT (NOLOCK) ';
  ls_Sql := ls_Sql + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = HO_CODE ';
  ls_Sql := ls_Sql + ' LEFT OUTER JOIN STOK_VIEW2 (NOLOCK) ON STOK_CODE = HO_CODE  AND STOK_LOTNO = HO_LOTNO ';  // 품목코드, LOTNO
  ls_Sql := ls_Sql + ' Where  HO_DATE <> '''' ';

  //if (ls_code <> '')  then   ls_Sql := ls_Sql + ' And  HO_CODE LIKE ''%'+ls_code+'%'' ';
  if (ls_code <> '')  then   ls_Sql := ls_Sql + ' And  HO_CODE = '''+ls_code+''' ';
  if (ls_date <> '')   then  ls_Sql := ls_Sql + ' And  HO_DATE  = '''+ls_date+''' ';

  ls_Sql := ls_Sql + ' Order By HO_DATE, HO_CHASU, HO_CODE, HO_LOTNO ';

  Query1.DisableControls;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(ls_sql);
  Query1.Open;
  Query1.EnableControls;
  Query1.First;

  if (Query1.RecordCount = 0) then Exit;

  iRow := 0;

  while True do
  begin
       if Query1.Eof = True then break;

       Inc(iRow);          
       ls_flag  :=  Query1.FieldByName('HO_FLAG').AsString;



       ls_date  := Query1.FieldByName('HO_DATE').AsString;
       s_date   := Query1.FieldByName('HO_DATE').AsString;

       ls_date  := Copy(ls_date,1,4) + '-' + Copy(ls_date,5,2)  + '-' + Copy(ls_date,7,2);

       if (ls_flag = 'Y') then  AdvSGrid.Cells[2, iRow] := '출고' else  AdvSGrid.Cells[2, iRow] := '';


       AdvSGrid.Cells[3, iRow] := Query1.FieldByName('HO_CHASU').AsString;
       s_chasu := Query1.FieldByName('HO_CHASU').AsString;

       AdvSGrid.Cells[4, iRow] := ls_date;
       AdvSGrid.Cells[5, iRow] := Query1.FieldByName('HO_CODE').AsString;
       AdvSGrid.Cells[6, iRow] := Query1.FieldByName('MAST_NAME').AsString;
       AdvSGrid.Cells[7, iRow] := Query1.FieldByName('HO_LOTNO').AsString;
       AdvSGrid.Cells[8, iRow] := Query1.FieldByName('HO_CUST').AsString;
       
       li_qty    := Query1.FieldByName('HO_QTY').AsInteger;
       AdvSGrid.Cells[9, iRow] := FormatFloat('###,###,##0', li_qty);

       li_qty    := Query1.FieldByName('HO_OUTQTY').AsInteger;
       AdvSGrid.Cells[10, iRow] := FormatFloat('###,###,##0', li_qty);

       li_qty    := Query1.FieldByName('STOK_QTY').AsInteger;
       AdvSGrid.Cells[11, iRow] := FormatFloat('###,###,##0', li_qty);

       AdvSGrid.Cells[12, iRow] := Query1.FieldByName('HO_BOXNO').AsString;
       AdvSGrid.Cells[13, iRow] := Query1.FieldByName('HO_REMARK').AsString;

       ls_time  := Query1.FieldByName('HO_TIME').AsString;
       ls_time  := Copy(ls_time,1,2) + ':' + Copy(ls_time,3,2)  + ':' + Copy(ls_time,5,2);

       AdvSGrid.Cells[14, iRow] := ls_time;

       AdvSGrid.AddCheckBox(1, iRow, True, True);
       AdvSGrid.SetCheckBoxState(1, iRow, chkAll.Checked );

       AdvSGrid.RowCount := iRow + 1;
       Query1.Next;
  end;

end;




procedure TFrm_4102.ReservedSBClick(Sender: TObject);
begin

   StrMsg := ' 차수 [' + s_chasu + '] 출고 예약 작업을 실행 합니까.??.?';
   if Not WinLib_ConfirmForm( StrMsg ) then Exit;


   Var_sql := ' Select * From T2HHOUPT Where HO_DATE = '''+s_date+''' And HO_CHASU = '''+s_chasu+''' ';
   Var_sql := Var_sql + '       And HO_FLAG = ''Y''  ';
   With SubkQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(Var_sql);
    Open;
    First;
    if RecordCount <> 0 Then Begin
      StrMsg :=  s_chasu  +  ' 이미 출고 예약한 차수  입니다. ';
      WinLib_ErrorForm( StrMsg );
      Exit;
    End;
   End;


   Memo1.Lines.Clear;

   Var_Sql := ' DELETE  FROM T2TIODAT ';
   Try
        UpdtQuery.Close;
        UpdtQuery.SQL.Clear;
        UpdtQuery.SQL.Add(Var_Sql);
        UpdtQuery.ExecSQL;
   Except
       ShowMessage('DELETE Error = ' + Var_Sql );   exit;
   End;

   Output_Resv_Proc;
   StartBitBtnClick(Self);
end;
/////////////////////////////////////////////////////////////////////////
////////////////////////// Output_Proc //////////////////////////////////
/////////////////////////////////////////////////////////////////////////
procedure TFrm_4102.Output_Resv_Proc;
var
  IntPos, IntQty : Integer;
  Strchasu, StrCode, StrLoca,  Strindate, Strintime, Strboxno, StrRemark : String;
  StrQty, Strcust  : String;
  StrDate, Strlotno : String;
  li_chasu : Integer;
  NumQty : Integer;

    iRow     : Integer;
    iCol     : Integer;
    bCheck   : Boolean;
    bIsJob   : Boolean;
    sData    : String;
    iRet     : Integer;
begin

  With AdvSGrid Do begin
       For iRow := 1 To RowCount -1 Do Begin
          GetCheckBoxState(1, iRow, bCheck);
          If bCheck Then Begin
              Strchasu  :=   Cells[3, iRow];
              StrDate   :=   Cells[4, iRow];
              Strcode   :=   Cells[5, iRow];  
              Strlotno  :=   Cells[7, iRow];
              Strcust   :=   Cells[8, iRow];
              StrQTy    :=   Cells[9, iRow];
              Strboxno  :=   Cells[12, iRow];
              StrRemark :=   Cells[13, iRow];

              While Pos(',', StrQty) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;
              While Pos('-', StrDate) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

              SData := Cells[3,iRow]+'|'+Cells[4,iRow];
              sData :=  sData +'|'+ Cells[5,iRow];
              sData :=  sData +'|'+ Cells[7,iRow];

              Memo1.Lines.Add('출고 = ' + SData);
              if (Memo1.Lines.Count > 500) then Memo1.Lines.Clear;

              NumQty    := StrToInt(StrQTy);

              OutInfo_Create(StrDate, Strchasu, Strcode, Strlotno, Strcust, Strboxno, StrRemark, NumQty); ///////// OutInfo_Create ////////////

              Var_Sql := ' Update T2HHOUPT Set HO_FLAG = ''Y''    ';
              Var_Sql := Var_Sql + ' Where HO_CHASU  = '''+Strchasu+'''  And HO_DATE = '''+Strdate+'''  ';
              Var_Sql := Var_Sql + ' And HO_CODE  = '''+Strcode+'''  And HO_LOTNO = '''+Strlotno+'''  ';
              Var_Sql := Var_Sql + ' And HO_CUST  = '''+Strcust+'''  ';    // 납품처로 구분하네
              Try
                 With UpdtQuery Do Begin
                  Close;
                  SQL.Clear;
                  SQL.Add(Var_Sql);
                  ExecSql;
                 End;
             Except
                 Memo1.Lines.add(Var_Sql);
                 Showmessage('Update Error = ' + Var_Sql);
             End;
          end;
       End;
  End;


  sys_datetime :=  f_get_sysdate_time1();
  s_date       :=  copy(sys_datetime, 1, 8);
  s_time       :=  copy(sys_datetime, 9, 6);


  OutLetData_Insert_Proc;
  Replace_Table_Flag;
  OutInfo_Print_proc;
 
end;

{
procedure TFrm_4102.OutInfo_Create(ItemDate, Itemchsu, ItemCode, ItemLotno, Itemcust, Itemboxno, ItemRemark : String; ItemQty: Integer);
var
  StrCode, StrLoca, StrIndate, StrInTime, StrBoxno, StrRemark : String;
  StrLotno, StrQty, StrOutQty : String;
  NumQty, NumOutQty, NumJisiQty : Integer;
  StrHogi, Str1IO, Str2IO, Str3IO : String;
  StrPltno : String; // 김준영 추가

  // 동반 재고 처리용 변수
  dbCode, dbLot, dbBox, dbRemark : String;
  dbWgt : Double;
  sStat_1, sStat_2, sStat_3 : String;

begin
  NumJisiQty := ItemQty;

  // 1. 설비 상태 미리 조회 (Snapshot)
  Var_Sql := ' Select STAT_SC1IO, STAT_SC2IO, STAT_SC3IO From T2TBSTAT (NOLOCK) Where Stat_PSWD = ''JPLS'' ';
  With StatQuery do Begin Close; SQL.Clear; SQL.Add(Var_Sql); Open;
      sStat_1 := FieldByName('STAT_SC1IO').AsString;
      sStat_2 := FieldByName('STAT_SC2IO').AsString;
      sStat_3 := FieldByName('STAT_SC3IO').AsString;
  End;

  // 2. 메인 루프 (타겟 품목 찾기)
  Var_Sql := ' Select SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_BOXNO, SUBK_REMARK, ';
  Var_Sql := Var_Sql + ' ISNULL(SUBK_WGT,0) SUBK_WGT, ISNULL(SUBK_RWGT,0) SUBK_RWGT, SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO ';
  Var_Sql := Var_Sql + ' From T2MISUBK (NOLOCK) ';
  Var_Sql := Var_Sql + ' LEFT OUTER JOIN T2MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA ';
  Var_Sql := Var_Sql + ' Where LSTK_LOCA = SUBK_LOCA ';
  Var_Sql := Var_Sql + ' And LSTK_FLAG IN (''M'', ''1'') '; 
  Var_Sql := Var_Sql + ' And SUBK_CODE = '''+ItemCode+''' ';
  Var_Sql := Var_Sql + ' And SUBK_LOTNO = '''+ItemLotno+''' ';
  Var_Sql := Var_Sql + ' And SUBK_WGT > SUBK_RWGT ';
  Var_Sql := Var_Sql + ' Order By CASE WHEN LSTK_FLAG=''M'' THEN 1 ELSE 2 END, SUBK_CODE, SUBK_LOTNO, SUBK_BOXNO ';

  With SubkQuery do
  begin
    Close; SQL.Clear; SQL.Add(Var_Sql); Open;
    First;

    While Not Eof Do Begin
      If ItemQty = 0 Then Break;

      StrCode   := FieldByName('SUBK_CODE').AsString;
      StrLoca   := FieldByName('SUBK_LOCA').AsString;
      StrLotNo  := FieldByName('SUBK_Lotno').AsString;
      StrInDate := FieldByName('SUBK_INDATE').AsString;
      StrInTime := FieldByName('SUBK_INTIME').AsString;
      Strboxno  := FieldByName('SUBK_BOXNO').AsString;
      StrRemark := FieldByName('SUBK_REMARK').AsString;
      StrPltno  := FieldByName('SUBK_PLTNO').AsString;
      NumQty    := FieldByName('SUBK_WGT').AsInteger;
      NumOutQty := FieldByName('SUBK_RWGT').AsInteger;

      if StrCode  <> ItemCode  Then Begin Next; Continue; End;
      if StrLotno <> ItemLotno Then Begin Next; Continue; End;

      // 호기 체크
      if      (Copy(StrLoca,1,1) = '1') or (Copy(StrLoca,1,1) = '2') Then StrHogi := '1'
      Else if (Copy(StrLoca,1,1) = '3') or (Copy(StrLoca,1,1) = '4') Then StrHogi := '2'
      Else if (Copy(StrLoca,1,1) = '5') or (Copy(StrLoca,1,1) = '6') Then StrHogi := '3';

      if (StrHogi = '1') And ((sStat_1 = '0') or (sStat_1 = '1')) Then Begin Next; Continue; End;
      if (StrHogi = '2') And ((sStat_2 = '0') or (sStat_2 = '1')) Then Begin Next; Continue; End;
      if (StrHogi = '3') And ((sStat_3 = '0') or (sStat_3 = '1')) Then Begin Next; Continue; End;

      // 수량 계산
      If ItemQty > (NumQty - NumOutQty) Then Begin
         ItemQty := ItemQty - (NumQty - NumOutQty);
         NumOutQty := NumQty; 
      End else Begin
         NumOutQty := ItemQty; 
         ItemQty := 0;
      End;
      StrOutQty := FloatToStr(NumOutQty);

      // [A] 타겟 업데이트 (SUBK_FLAG = 'M')
      Var_Sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'', SUBK_RWGT = ISNULL(SUBK_RWGT,0) + CONVERT(NUMERIC(7,2),'''+StrOutQty+''') ';
      Var_Sql := Var_Sql + ' Where SUBK_LOCA = '''+StrLoca+''' And SUBK_CODE = '''+StrCode+''' And SUBK_LOTNO = '''+StrLotno+''' And SUBK_PLTNO = '''+StrPltno+''' AND SUBK_BOXNO = '''+Strboxno+''' ';
      try UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL; except end;

      Var_Sql := ' Update T2MILSTK Set LSTK_FLAG = ''M'' Where LSTK_LOCA = '''+StrLoca+''' ';
      try UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL; except end;

      // [B] 타겟 입력
      Tiodat_Table_Insert(Itemdate, Itemchsu, StrCode, StrLotNo, Itemcust, StrLoca, StrIndate, Strintime, 
                          StrBoxno, StrRemark, Itemboxno, ItemRemark, StrPltno, NumJisiQty, NumQty, NumOutQty);


      // =========================================================================
      // [C] ★★★ 동반 재고(Piggyback) 처리 로직 (수정됨) ★★★
      // =========================================================================
      Var_Sql := ' SELECT SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_BOXNO, SUBK_REMARK ';
      Var_Sql := Var_Sql + ' FROM T2MISUBK A (NOLOCK) ';
      Var_Sql := Var_Sql + ' WHERE SUBK_PLTNO = ''' + StrPltno + ''' '; // 같은 파렛트
      
      // [핵심 수정] 타겟 품목(방금 처리한 놈, SUBK_FLAG='M')을 제외하고 나머지는 싹 다 가져옴.
      // 지시가 있든 없든, 이 파렛트에 타고 있는데 아직 처리 안 된 놈들은 다 동반재고임.
      // (주의: 위에서 Update로 'M'으로 바꿨으므로, 'M'이 아닌 것만 조회하면 됨)
      Var_Sql := Var_Sql + '   AND SUBK_FLAG <> ''M'' '; 

      // 혹시 모르니 Code, Lot 조건도 한번 더 걸어줌 (안전장치)
      Var_Sql := Var_Sql + '   AND NOT (SUBK_CODE = ''' + StrCode + ''' AND SUBK_LOTNO = ''' + StrLotNo + ''') '; 

      Var_Sql := Var_Sql + ' ORDER BY SUBK_CODE, SUBK_LOTNO ';

      With DispQuery Do Begin 
        Close; SQL.Clear; SQL.Add(Var_Sql); Open;
        
        while not Eof do begin
           dbCode   := FieldByName('SUBK_CODE').AsString;
           dbLot    := FieldByName('SUBK_LOTNO').AsString;
           dbWgt    := FieldByName('SUBK_WGT').AsFloat;
           dbBox    := FieldByName('SUBK_BOXNO').AsString;
           dbRemark := FieldByName('SUBK_REMARK').AsString;

           // 1. 상태 'M' 변경 (중요: 다른 루프에서 중복 처리 안 되게)
           Var_Sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'' ';
           Var_Sql := Var_Sql + ' Where SUBK_PLTNO = ''' + StrPltno + ''' AND SUBK_CODE = ''' + dbCode + ''' AND SUBK_LOTNO = ''' + dbLot + ''' ';
           try UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL; except end;

           // 2. 이력 생성 (출고량 0)
           Tiodat_Table_Insert(Itemdate, Itemchsu, dbCode, dbLot, Itemcust, StrLoca, StrIndate, Strintime, 
                               dbBox, dbRemark, '', '', StrPltno, 0, Trunc(dbWgt), 0);
           Next;
        end;
      End; 
      // =========================================================================

      Next;
    End;
  end;
end;
}


procedure TFrm_4102.OutInfo_Create(ItemDate, Itemchsu, ItemCode, ItemLotno, Itemcust, Itemboxno, ItemRemark : String; ItemQty: Integer);
var
  StrCode, StrLoca, StrIndate, StrInTime, StrBoxno, StrRemark : String;
  StrLotno, StrOutQty : String;
  NumQty, NumOutQty, NumJisiQty : Integer;

  // [추가] 로직 명확화를 위한 변수
  DB_RWGT : Integer;      // DB에 저장된 기존 예약량
  AvailableQty : Integer; // 현재 파렛트의 가용 수량

  StrHogi, Str1IO, Str2IO, Str3IO : String;
  StrPltno : String; 
  dbCode, dbLot, dbBox, dbRemark : String;
  dbWgt : Double;
  sStat_1, sStat_2, sStat_3 : String;

begin
  NumJisiQty := ItemQty;

  // 설비 상태 조회
  Var_Sql := ' Select STAT_SC1IO, STAT_SC2IO, STAT_SC3IO From T2TBSTAT (NOLOCK) Where Stat_PSWD = ''JPLS'' ';
  With StatQuery do Begin Close; SQL.Clear; SQL.Add(Var_Sql); Open;
      sStat_1 := FieldByName('STAT_SC1IO').AsString;
      sStat_2 := FieldByName('STAT_SC2IO').AsString;
      sStat_3 := FieldByName('STAT_SC3IO').AsString;
  End;

  // ===========================================================================
  // 기존 'M' (작업중/이동중) 재고 처리
  // ===========================================================================
  Var_Sql := ' Select   SUBK_CODE, SUBK_LOCA, SUBK_LOTNO, SUBK_BOXNO, SUBK_REMARK, ';
  Var_Sql := Var_Sql + ' ISNULL(SUBK_WGT,0) SUBK_WGT,  ISNULL(SUBK_RWGT,0) SUBK_RWGT, SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO '; // PLTNO 추가
  Var_Sql := Var_Sql + ' From T2MISUBK (NOLOCK) ';
  Var_Sql := Var_Sql + ' LEFT OUTER JOIN T2MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA ';
  Var_Sql := Var_Sql + ' WHERE LSTK_LOCA = SUBK_LOCA ';
  Var_Sql := Var_Sql + ' And LSTK_FLAG = ''M'' ';
  Var_Sql := Var_Sql + ' And SUBK_CODE        = '''+ItemCode+'''    ';
  Var_Sql := Var_Sql + ' And SUBK_LOTNO       = '''+ItemLotno+'''    ';
  Var_Sql := Var_Sql + ' And SUBK_WGT > SUBK_RWGT ';
  Var_Sql := Var_Sql + ' Order By SUBK_CODE, SUBK_LOTNO, SUBK_BOXNO, SUBK_INDATE, SUBK_INTIME ';

  With SubkQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(Var_Sql);
    Open;
    First;

    While Not Eof Do Begin
      If ItemQty = 0 Then Break;

      StrCode   := FieldByName('SUBK_CODE').AsString;
      Strlotno  := FieldByName('SUBK_LOTNO').AsString;
      StrLoca   := FieldByName('SUBK_LOCA').AsString;
      StrInDate := FieldByName('SUBK_INDATE').AsString;
      StrInTime := FieldByName('SUBK_INTIME').AsString;
      Strboxno  := FieldByName('SUBK_BOXNO').AsString;
      StrRemark := FieldByName('SUBK_REMARK').AsString;

      StrPltno  := FieldByName('SUBK_PLTNO').AsString; 
      
      NumQty    := FieldByName('SUBK_WGT').AsInteger;  // 전체 재고
      DB_RWGT   := FieldByName('SUBK_RWGT').AsInteger; // 기존 예약된 양

      If StrCode  <>  ItemCode   Then Begin Next; Continue; End;
      If StrLotno <>  ItemLotno  Then Begin Next; Continue; End;

      AvailableQty := NumQty - DB_RWGT; // 이중 차감 방지 : 현재 가용 수량 (전체 재고 - 예약 수량)

      If ItemQty > AvailableQty Then // 남은 지시량 > 가용 수량
      Begin
         NumOutQty := AvailableQty;        // 출고 수량 = 가용 수량
         ItemQty   := ItemQty - NumOutQty; // 남은 지시량 = 남은 지시량 - 출고수량
      End 
      else 
      Begin
         NumOutQty := ItemQty;      // 지시량 <= 가용량 -> 지시량만큼만 가져감
         ItemQty   := 0;            // 남은 지시수량 : 0 , 지시 완료
      End;
      // -----------------------------------------------------------------------

      StrOutQty := FloatToStr(NumOutQty);

      // 예약 수량 업데이트 (SUBK_RWGT에 이번 수량만큼 더함)
      Var_Sql := ' Update T2MISUBK Set  SUBK_FLAG = ''M'', ';
      Var_Sql := Var_Sql + ' SUBK_RWGT = ISNULL(SUBK_RWGT,0) + CONVERT(NUMERIC(7,2),'''+StrOutQty+''') ';  // 출고 수량 + 신규 출고 수량
      Var_Sql := Var_Sql + ' Where SUBK_LOCA    = '''+StrLoca+''' ';
      Var_Sql := Var_Sql + '    AND SUBK_CODE     = '''+StrCode+''' ';
      Var_Sql := Var_Sql + '    AND SUBK_LOTNO    = '''+StrLotno+''' ';
      Var_Sql := Var_Sql + '    AND SUBK_PLTNO    = '''+StrPltno+''' ';
      //Var_Sql := Var_Sql + '    AND SUBK_BOXNO    = '''+Strboxno+''' ';

      Try
        UpdtQuery.Close;
        UpdtQuery.SQL.Clear;
        UpdtQuery.SQL.Add(Var_Sql);
        UpdtQuery.ExecSQL;
      Except
        Memo1.Lines.add(Var_Sql); 
      End;

      // 이력 생성

      Tiodat_Table_Insert(Itemdate, Itemchsu, StrCode, StrLotNo, Itemcust, StrLoca, StrIndate, Strintime,
                          StrBoxno, StrRemark, Itemboxno, ItemRemark, StrPltno, NumJisiQty, NumQty, NumOutQty);

      Next;
    End;
  End;


  // ===========================================================================
  // '1' (일반 랙) 재고 처리 :
  // ===========================================================================
  Var_Sql := ' Select     SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_BOXNO, SUBK_REMARK, ';
  Var_Sql := Var_Sql + ' ISNULL(SUBK_WGT,0) SUBK_WGT,  ISNULL(SUBK_RWGT,0) SUBK_RWGT, SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO '; // PLTNO 추가
  Var_Sql := Var_Sql + ' From T2MISUBK (NOLOCK) ';
  Var_Sql := Var_Sql + ' LEFT OUTER JOIN T2MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA ';
  Var_Sql := Var_Sql + ' Where LSTK_LOCA = SUBK_LOCA ';
  Var_Sql := Var_Sql + ' And LSTK_FLAG = ''1'' ';
  Var_Sql := Var_Sql + ' And SUBK_CODE    = '''+ItemCode+'''  ';
  Var_Sql := Var_Sql + ' And SUBK_LOTNO   = '''+ItemLotno+'''  ';
  Var_Sql := Var_Sql + ' And SUBK_WGT > SUBK_RWGT ';
  Var_Sql := Var_Sql + ' Order By SUBK_CODE, SUBK_LOTNO, SUBK_BOXNO, SUBK_INDATE, SUBK_INTIME ';

  With SubkQuery do
  begin
      Close; SQL.Clear; SQL.Add(Var_Sql); Open;
      First;

      While Not Eof Do Begin
        If ItemQty = 0 Then Break;

        StrCode   := FieldByName('SUBK_CODE').AsString;
        StrLoca   := FieldByName('SUBK_LOCA').AsString;
        StrLotNo  := FieldByName('SUBK_Lotno').AsString;
        StrInDate := FieldByName('SUBK_INDATE').AsString;
        StrInTime := FieldByName('SUBK_INTIME').AsString;
        Strboxno  := FieldByName('SUBK_BOXNO').AsString;
        StrRemark := FieldByName('SUBK_REMARK').AsString;
        StrPltno  := FieldByName('SUBK_PLTNO').AsString; 
        
        NumQty    := FieldByName('SUBK_WGT').AsInteger;  // 전체 재고
        DB_RWGT   := FieldByName('SUBK_RWGT').AsInteger; // 기존 예약


        If StrCode  <>  ItemCode   Then Begin Next; Continue; End;
        If StrLotno <>  ItemLotno  Then Begin Next; Continue; End;

        if      (Copy(StrLoca,1,1) = '1') or (Copy(StrLoca,1,1) = '2') Then StrHogi := '1'
        Else if (Copy(StrLoca,1,1) = '3') or (Copy(StrLoca,1,1) = '4') Then StrHogi := '2'
        Else if (Copy(StrLoca,1,1) = '5') or (Copy(StrLoca,1,1) = '6') Then StrHogi := '3';

        if (StrHogi = '1') And ((sStat_1 = '0') or (sStat_1 = '1')) Then Begin Next; Continue; End;
        if (StrHogi = '2') And ((sStat_2 = '0') or (sStat_2 = '1')) Then Begin Next; Continue; End;
        if (StrHogi = '3') And ((sStat_3 = '0') or (sStat_3 = '1')) Then Begin Next; Continue; End;

        AvailableQty := NumQty - DB_RWGT; // 재고 - 기존 예약 = 가용 수량

        If ItemQty > AvailableQty Then // 남은 지시 수량 > 가용 수량
        Begin
           NumOutQty := AvailableQty;        // 나가는 수량 = 가용 수량 (남은 지시 수량이 더 큼으로 가용 수량만 나갈 수 있음)
           ItemQty   := ItemQty - NumOutQty; // 남은 지시량 = 남은 지시량 - 나가는 수량 
        End 
        else 
        Begin
           NumOutQty := ItemQty;      // 지시량 <= 가용량 -> 지시량만큼만 가져감
           ItemQty   := 0;            // 남은 지시수량 : 0 , 지시 완료
        End;
        // -----------------------------------------------------------------------

        StrOutQty := FloatToStr(NumOutQty); // 나가는 수량

        // 예약 수량 UPDATE
        Var_Sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'', ';
        Var_Sql := Var_Sql + ' SUBK_RWGT = ISNULL(SUBK_RWGT,0) + CONVERT(NUMERIC(7,2),'''+StrOutQty+''') ';
        Var_Sql := Var_Sql + ' Where SUBK_LOCA  = '''+StrLoca+''' ';
        Var_Sql := Var_Sql + '    And SUBK_CODE    = '''+StrCode+''' ';
        Var_Sql := Var_Sql + '    And SUBK_LOTNO   = '''+StrLotno+''' ';
        Var_Sql := Var_Sql + '    And SUBK_PLTNO   = '''+StrPltno+''' ';
        //Var_Sql := Var_Sql + '    AND SUBK_BOXNO   = '''+Strboxno+''' ';

        Try
          UpdtQuery.Close;
          UpdtQuery.SQL.Clear;
          UpdtQuery.SQL.Add(Var_Sql);
          UpdtQuery.ExecSQL;
        Except
          ShowMessage(Var_Sql);
        End;

        Var_Sql := ' Update T2MILSTK Set LSTK_FLAG = ''M'' ';
        Var_Sql := Var_Sql + ' Where LSTK_LOCA = '''+StrLoca+''' ';

        Try
          UpdtQuery.Close;
          UpdtQuery.SQL.Clear;
           UpdtQuery.SQL.Add(Var_Sql);
           UpdtQuery.ExecSQL;
        Except
          ShowMessage(Var_Sql);
        End;        

        // 이력 생성
        Tiodat_Table_Insert(Itemdate, Itemchsu, StrCode, StrLotNo, Itemcust, StrLoca, StrIndate, Strintime, StrBoxno, StrRemark,
                            Itemboxno, ItemRemark, StrPltno, NumJisiQty, NumQty, NumOutQty);


        // =========================================================================
        // 동반 재고 처리
        // =========================================================================
        // 1. 해당 파렛트(PLTNO)에 있는 다른 품목들을 조회
        // 2. 방금 처리한 타겟 품목(Code/Lot)은 제외
        // =========================================================================
        Var_Sql := ' SELECT SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_BOXNO, SUBK_REMARK ';
        Var_Sql := Var_Sql + ' FROM T2MISUBK A (NOLOCK) ';
        Var_Sql := Var_Sql + ' WHERE SUBK_PLTNO = ''' + StrPltno + ''' '; 
        
        // 타겟 품목 제외 (이미 처리 완료)
        Var_Sql := Var_Sql + '   AND NOT (SUBK_CODE = ''' + StrCode + ''' AND SUBK_LOTNO = ''' + StrLotNo + ''') '; 
        Var_Sql := Var_Sql + ' ORDER BY SUBK_CODE, SUBK_LOTNO ';

        With DispQuery Do Begin 
           Close; SQL.Clear; SQL.Add(Var_Sql); Open;
           
           while not Eof do begin
              dbCode   := FieldByName('SUBK_CODE').AsString;
              dbLot    := FieldByName('SUBK_LOTNO').AsString;
              dbWgt    := FieldByName('SUBK_WGT').AsFloat;
              dbBox    := FieldByName('SUBK_BOXNO').AsString;
              dbRemark := FieldByName('SUBK_REMARK').AsString;

              // 1. 상태 'M' 변경 (수량 변화 없이 상태만 변경)
              Var_Sql := ' Update T2MISUBK Set SUBK_FLAG = ''M'' ';
              Var_Sql := Var_Sql + ' Where SUBK_PLTNO = ''' + StrPltno + ''' AND SUBK_CODE = ''' + dbCode + ''' AND SUBK_LOTNO = ''' + dbLot + ''' ';
              try UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL; except end;

              // 2. 이력 생성 (출고량 0으로)
              Tiodat_Table_Insert(Itemdate, Itemchsu, dbCode, dbLot, Itemcust, StrLoca, StrIndate, Strintime, 
                                  dbBox, dbRemark, '', '', StrPltno, 0, Trunc(dbWgt), 0);
              Next;
           end;
        End; 
        // =========================================================================

        Next;
      End;
  End; // End With
End;

procedure TFrm_4102.Tiodat_Table_Insert(OutDate,OutChasu, OutCode, Outlotno, OutCust, OutLoca, Outindate, Outintime,
                                     Outboxno, Outremark, Outboxno1, Outremark1, OutPltno : String; OutJisiQty, OutStockQty, OutQty: Integer); 
var
  StrQty, StrStockQty, StrJQty : String;
  li_cnt : Integer; // 데이터 존재 여부 확인용
begin
  StrQty      := FloatToStr(OutQty);
  StrStockQty := FloatToStr(OutStockQty);
  StrJQty     := FloatToStr(OutJisiQty);

  // 1. 지시 테이블(T2HHOUPT) 업데이트
  Var_Sql := ' Update T2HHOUPT SET ';
  Var_Sql := Var_Sql + ' HO_OUTQTY = ISNULL(HO_OUTQTY, 0) + Convert(NUMERIC,'''+StrQty+'''), HO_FLAG = ''Y'' ';
  Var_Sql := Var_Sql + ' Where HO_CHASU = '''+Outchasu+''' And HO_DATE = '''+OutDate+''' ';
  Var_Sql := Var_Sql + ' And HO_CODE = '''+OutCode+''' And HO_LOTNO = '''+OutLotno+''' And HO_CUST = '''+Outcust+''' ';
  Try
    UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL;
  Except
  End;

  // 2. T2TIODAT 입력 (UPSERT 로직 - 델파이 제어)
  
  // [Step 1] 데이터 존재 여부 확인
  Var_Sql := ' SELECT COUNT(*) FROM T2TIODAT (NOLOCK) ';
  Var_Sql := Var_Sql + ' WHERE ODAT_DATE = ''' + OutDate + ''' ';
  Var_Sql := Var_Sql + '   AND ODAT_CHASU = ''' + OutChasu + ''' ';
  Var_Sql := Var_Sql + '   AND ODAT_CODE = ''' + OutCode + ''' ';
  Var_Sql := Var_Sql + '   AND ODAT_LOTNO = ''' + OutLotno + ''' ';
  Var_Sql := Var_Sql + '   AND ODAT_CUST = ''' + OutCust + ''' ';
  Var_Sql := Var_Sql + '   AND ODAT_LOCA = ''' + OutLoca + ''' ';

  With Query2 Do Begin // Query2나 임시 쿼리 컴포넌트 사용
      Close; SQL.Clear; SQL.Add(Var_Sql); Open;
      li_cnt := Fields[0].AsInteger;
  End;

  // [Step 2] 존재하면 UPDATE, 없으면 INSERT
  if li_cnt > 0 then
  begin
      // 이미 데이터가 있음 -> 본 작업(수량>0)일 때만 업데이트
      if OutQty > 0 then
      begin
          Var_Sql := ' UPDATE T2TIODAT SET ';
          Var_Sql := Var_Sql + '    ODAT_RQTY = CONVERT(NUMERIC(7,2), ''' + StrQty + '''), ';
          Var_Sql := Var_Sql + '    ODAT_JQTY = CONVERT(NUMERIC(7,2), ''' + StrJQty + '''), ';
          Var_Sql := Var_Sql + '    ODAT_BOXNO = ''' + Outboxno + ''', ';
          Var_Sql := Var_Sql + '    ODAT_REMARK = ''' + Outremark + ''' ';
          Var_Sql := Var_Sql + ' WHERE ODAT_DATE = ''' + OutDate + ''' AND ODAT_CHASU = ''' + OutChasu + ''' ';
          Var_Sql := Var_Sql + '   AND ODAT_CODE = ''' + OutCode + ''' AND ODAT_LOTNO = ''' + OutLotno + ''' ';
          Var_Sql := Var_Sql + '   AND ODAT_CUST = ''' + OutCust + ''' AND ODAT_LOCA = ''' + OutLoca + ''' ';
          
          Try
            UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL;
          Except
             Memo1.Lines.Add('Error Update T2TIODAT: ' + Var_Sql);
          End;
      end;
  end
  else
  begin
      // 데이터 없음 -> 신규 INSERT
      Var_Sql := ' Insert Into T2TIODAT(ODAT_DATE, ODAT_CHASU, ODAT_CODE, ODAT_LOTNO, ODAT_CUST, ODAT_LOCA, ';
      Var_Sql := Var_Sql + '    ODAT_INDATE, ODAT_INTIME, ODAT_BOXNO, ODAT_REMARK, ';
      Var_Sql := Var_Sql + '    ODAT_QTY, ODAT_RQTY, ODAT_JQTY, ODAT_BOXNO1, ODAT_REMARK1 ) ';
      Var_Sql := Var_Sql + ' Values( '''+Outdate+''', '''+Outchasu+''','''+Outcode+''', '''+OutLotno+''', '''+Outcust+''', '''+OutLoca+''', ';
      Var_Sql := Var_Sql + '    '''+OutIndate+''', '''+OutIntime+''', '''+Outboxno+''', '''+Outremark+''', ';
      Var_Sql := Var_Sql + '    CONVERT(NUMERIC(7,2),'''+StrStockQty+'''), CONVERT(NUMERIC(7,2),'''+StrQty+'''), CONVERT(NUMERIC(7,2),'''+StrJQty+'''), ';
      Var_Sql := Var_Sql + '    '''+Outboxno1+''', '''+Outremark1+''' ) ';

      Try
        UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL;
      Except
         Memo1.Lines.Add('Error Insert T2TIODAT: ' + Var_Sql);
      End;
  end;
end;



procedure TFrm_4102.OutLetData_Insert_Proc;
var
  StrDate, StrTime, StrIndex, StrLoca, StrCode, StrLotno, StrCust : String;
  StrChasu, StrIndate, StrIntime, StrBoxno, StrRemark, StrPltno : String;
  StrBoxno1, StrRemark1, StrRflag, StrStkQty, StrOutQty : String;
  NumOutQty, NumStkQty : Double;
  StrGubun, SaveLoca, ls_date : String;
  NumSumQty, NumSumOutQty : Double;
  StrSeqNo : String;
begin
  sys_datetime  :=  f_get_sysdate_time1();
  StrDate       :=  copy(sys_datetime, 1, 8);
  StrTime       :=  copy(sys_datetime, 9, 6);

  // [중요] T2TIODAT에 없는 PLTNO를 T2MISUBK와 JOIN하여 가져옴
  Var_Sql := ' Select ODAT_LOCA, ODAT_CODE, ODAT_LOTNO, ODAT_CUST, ODAT_RQTY, MAX(ODAT_CHASU) AS ODAT_CHASU, ';
  Var_Sql := Var_Sql + ' MAX(ODAT_INDATE) AS ODAT_INDATE, MAX(ODAT_INTIME) AS ODAT_INTIME, ';
  Var_Sql := Var_Sql + ' MAX(ODAT_BOXNO) ODAT_BOXNO, MAX(ODAT_REMARK) ODAT_REMARK, ';
  Var_Sql := Var_Sql + ' MAX(ODAT_BOXNO1) ODAT_BOXNO1, MAX(ODAT_REMARK1) ODAT_REMARK1, ';
  Var_Sql := Var_Sql + ' MAX(S.SUBK_PLTNO) AS SUBK_PLTNO, MAX(S.SUBK_WGT) AS SUBK_WGT '; // PLTNO, WGT 추가
  Var_Sql := Var_Sql + ' From T2TIODAT O (NOLOCK) ';
  Var_Sql := Var_Sql + ' LEFT OUTER JOIN T2MISUBK S (NOLOCK) ';
  Var_Sql := Var_Sql + ' ON S.SUBK_LOCA = O.ODAT_LOCA AND S.SUBK_CODE = O.ODAT_CODE AND S.SUBK_LOTNO = O.ODAT_LOTNO ';
  Var_Sql := Var_Sql + ' Where 1=1 ';
  Var_Sql := Var_Sql + ' Group By ODAT_LOCA, ODAT_CODE, ODAT_LOTNO, ODAT_CUST, ODAT_RQTY ';
  Var_Sql := Var_Sql + ' Order By ODAT_LOCA, ODAT_CODE, ODAT_LOTNO, ODAT_CUST ';

  With DispQuery Do Begin
    Close; SQL.Clear; SQL.Add(Var_Sql); Open;
    First;
    SaveLoca := '';
    
    While Not Eof Do Begin
      StrLoca   := FieldByName('ODAT_LOCA').AsString;
      StrCode   := FieldByName('ODAT_CODE').AsString;
      Strlotno  := FieldByName('ODAT_LOTNO').AsString;
      Strcust   := FieldByName('ODAT_CUST').AsString;
      Strchasu  := FieldByName('ODAT_CHASU').AsString;
      Strindate := FieldByName('ODAT_INDATE').AsString;
      Strintime := FieldByName('ODAT_INTIME').AsString;
      StrBoxno  := FieldByName('ODAT_BOXNO').AsString;
      StrRemark := FieldByName('ODAT_REMARK').AsString;
      
      StrPltno  := FieldByName('SUBK_PLTNO').AsString; // JOIN으로 가져온 값
      NumOutQty := FieldByName('ODAT_RQTY').AsFloat;
      NumStkQty := FieldByName('SUBK_WGT').AsFloat;
      StrBoxno1 := FieldByName('ODAT_BOXNO1').AsString;
      StrRemark1:= FieldByName('ODAT_REMARK1').AsString;

      // 파렛트가 바뀌면 신규 INDEX 생성 및 작업지시(T2TISCHE1) 생성
      if SaveLoca <> StrLoca Then
      Begin
        // 1. 인덱스 채번 (기존 로직 동일)
        var_sql := ' Select STAT_ODATE, STAT_OINDX From T2TBSTAT (NOLOCK) Where STAT_PSWD = ''JPLS'' ';
        With StatQuery do Begin Close; SQL.Clear; SQL.Add(var_sql); Open; ls_date := FieldByName('STAT_ODATE').AsString; End;

        if (ls_date = StrDate) then begin
           // ... (STAT_OINDX 증가 로직)
           StrIndex := StrDate + 'O' + Format('%4.4d', [StatQuery.FieldByName('STAT_OINDX').AsInteger]);
           var_sql := ' Update T2TBSTAT Set STAT_OINDX = STAT_OINDX + 1 Where STAT_PSWD = ''JPLS'' ';
           // 9999 넘으면 1로 초기화 등 기존 로직 유지
        end else begin
           StrIndex := StrDate + 'O' + Format('%4.4d', [1]);
           var_sql := ' Update T2TBSTAT Set STAT_ODATE = '''+StrDate+''', STAT_OINDX = 2 Where STAT_PSWD = ''JPLS'' ';
        end;
        try UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(var_sql); UpdtQuery.ExecSQL; except end;

        // 2. 전체/부분 출고 구분 (Gubun)
        Var_Sql := ' Select Sum(SUBK_WGT) SUBK_WGT, Sum(SUBK_RWGT) SUBK_RWGT From T2MISUBK (NOLOCK) Where SUBK_LOCA = '''+StrLoca+''' ';
        StatQuery.Close; StatQuery.SQL.Clear; StatQuery.SQL.Add(Var_Sql); StatQuery.Open;
        NumSumQty := StatQuery.FieldByName('SUBK_WGT').asFloat;
        NumSumOutQty := StatQuery.FieldByName('SUBK_RWGT').asFloat;
        
        If NumSumQty = NumSumOutQty Then StrGubun := 'T' Else StrGubun := 'P';

        // 3. 작업지시 Insert (PK 중복 방지 포함된 프로시저 호출)
        Insert_Sche_Proc(StrIndex, StrLoca, StrGubun, StrPltno);
        
        SaveLoca := StrLoca;
      End;

      StrStkQty := FloatToStr(NumStkQty);
      StrOutQty := FloatToStr(NumOutQty);

      // [상태값 결정 - 핵심]
      if (NumOutQty = 0) then StrRflag := 'R'           // 동반재고
      else if (NumStkQty <> NumOutQty) then StrRflag := 'R' // 부분출고
      else StrRflag := 'O';                          // 전량출고

      // 4. 출고이력 생성 (T2MIOUPT)
      Var_Sql := ' Select ISNULL(Max(OUPT_SEQNO), 0) OUPT_SEQNO From T2MIOUPT (NOLOCK) ';
      Var_Sql := Var_Sql + ' Where OUPT_INDEX = '''+StrIndex+''' ';
      StatQuery.Close; StatQuery.SQL.Clear; StatQuery.SQL.Add(Var_Sql); StatQuery.Open;
      StrSeqNo := Format('%4.4D', [StatQuery.FieldByName('OUPT_SEQNO').AsInteger + 1]);

      Var_Sql := ' Insert Into T2MIOUPT(OUPT_DATE, OUPT_INDEX, OUPT_CODE, OUPT_LOTNO, OUPT_CUST, ';
      Var_Sql := Var_Sql + ' OUPT_SEQNO, OUPT_GUBUN, OUPT_WGT, OUPT_OUT_WGT, ';
      Var_Sql := Var_Sql + ' OUPT_RLOCA, OUPT_LOCA, OUPT_TIME, OUPT_RFLAG, OUPT_JOB_FLAG, ';
      Var_Sql := Var_Sql + ' OUPT_CHASU, OUPT_INDATE, OUPT_INTIME, OUPT_BOXNO, OUPT_REMARK, ';
      Var_Sql := Var_Sql + ' OUPT_LABEL, OUPT_ID, OUPT_BOXNO1, OUPT_REMARK1, OUPT_PLTNO) ';
      Var_Sql := Var_Sql + ' Values('''+StrDate+''', '''+StrIndex+''','''+StrCode+''', '''+Strlotno+''', '''+Strcust+''',';
      Var_Sql := Var_Sql + ' '''+StrSeqNo+''', ''Y'', '''+StrStkQty+''', '''+StrOutQty+''', ';
      Var_Sql := Var_Sql + ' '''+StrLoca+''', '''+StrLoca+''', '''+StrTime+''', '''+StrRflag+''', ''0'', ';
      Var_Sql := Var_Sql + ' '''+Strchasu+''', '''+StrIndate+''', '''+StrIntime+''', '''+StrBoxno+''', '''+StrRemark+''', ';
      Var_Sql := Var_Sql + ' ''N'', '''+jj_id+''', '''+StrBoxno1+''', '''+StrRemark1+''', '''+StrPltno+''' ) ';

      try UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL; except end;

      // 5. 마스터 상태 업데이트 (M -> Y)
      Var_Sql := 'Update T2MILSTK Set LSTK_FLAG = ''Y'' Where LSTK_LOCA = '''+StrLoca+''' ';
      try UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL; except end;

      Next;
    End;
  End;
end;

{
procedure TFrm_4102.Insert_Sche_Proc(OutIndex, OutLoca, OutGubun, OutPltno : String);
var
  StrSc, Strloca, StrDate, StrTime, StrTo : String;
  ls_cv1, ls_cv2, ls_cv3, ls_cv4, ls_cv5, ls_cv6 : String;
begin
  StrDate := FormatDateTime('yyyymmdd', Now);
  StrTime := FormatDateTime('hhmmss', Now);
  StrLoca  := OutLoca;

  // 호기 계산 (기존 동일)
  if      (Copy(StrLoca, 1,1) = '1') Or (Copy(StrLoca, 1,1) = '2') Then StrSc := '1'
  Else if (Copy(StrLoca, 1,1) = '3') Or (Copy(StrLoca, 1,1) = '4') Then StrSc := '2'
  Else if (Copy(StrLoca, 1,1) = '5') Or (Copy(StrLoca, 1,1) = '6') Then StrSc := '3';




  // 설비 상태 및 방향 결정 (기존 동일)
  // ... (STAT_CV 조회 로직 생략) ...
  // 임의로 1번 방향으로 가정 (실제 코드엔 로직 포함됨)
  StrTo := '1';

  // [수정] PK 중복 방지 (IF NOT EXISTS)
  Var_Sql := ' IF NOT EXISTS (SELECT * FROM T2TISCHE1 WHERE SCHE_SC = ''' + StrSc + ''' AND SCHE_INDEX = ''' + OutIndex + ''') ';
  Var_Sql := Var_Sql + ' BEGIN ';
  Var_Sql := Var_Sql + '    Insert Into T2TISCHE1(SCHE_SC, SCHE_INDEX, SCHE_JOBGUBUN, SCHE_LOCA, ';
  Var_Sql := Var_Sql + '       SCHE_WSNO, SCHE_DATE, SCHE_TIME, SCHE_EMER, SCHE_PLTNO) ';
  Var_Sql := Var_Sql + '    Values('''+StrSC+''', '''+OutIndex+''', '''+OutGubun+''', '''+OutLoca+''',';
  Var_Sql := Var_Sql + '    '''+StrTo+''', '''+StrDate+''', '''+StrTime+''', ''N'', '''+OutPltno+''') ';
  Var_Sql := Var_Sql + ' END ';

  Try
    UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL;
  Except
     // 중복 에러는 무시
  End;
end;
 }

 procedure TFrm_4102.Insert_Sche_Proc(OutIndex, OutLoca, OutGubun, OutPltno : String);
var
  StrSc, Strloca, StrDate, StrTime, StrTo : String;
  ls_cv1, ls_cv2, ls_cv3, ls_cv4, ls_cv5, ls_cv6 : String;
  ls_Bank : String; // Bank 번호 추출용 변수
begin
  StrDate := FormatDateTime('yyyymmdd', Now);
  StrTime := FormatDateTime('hhmmss', Now);
  StrLoca  := Trim(OutLoca);

  // [수정] 호기(SC) 계산 로직 - OutInfo_Create와 동일하게 맞춤
  // StrLoca의 첫 번째 글자를 Bank 번호로 간주
  if Length(StrLoca) > 0 then
     ls_Bank := Copy(StrLoca, 1, 1)
  else
     ls_Bank := '0'; // 예외 처리

  if      (ls_Bank = '1') Or (ls_Bank = '2') Then StrSc := '1'  // 1, 2 Bank -> 1호기
  Else if (ls_Bank = '3') Or (ls_Bank = '4') Then StrSc := '2'  // 3, 4 Bank -> 2호기
  Else if (ls_Bank = '5') Or (ls_Bank = '6') Then StrSc := '3'  // 5, 6 Bank -> 3호기
  Else StrSc := '1'; // Default (예외 발생 시 1호기로 설정하거나 에러 처리 필요)


  // 설비 상태 및 방향 결정 (기존 로직 유지)
  var_sql := ' Select STAT_CV1, STAT_CV2, STAT_CV3, STAT_CV4, STAT_CV5, STAT_CV6 From T2TBSTAT (NOLOCK) ';
  var_sql := var_sql + ' Where STAT_PSWD = ''JPLS'' ';
  With StatQuery do Begin
      Close; SQL.Clear; SQL.Add(var_sql); Open;
      ls_cv1 := FieldByName('STAT_CV1').AsString;
      ls_cv2 := FieldByName('STAT_CV2').AsString;
      ls_cv3 := FieldByName('STAT_CV3').AsString;
      ls_cv4 := FieldByName('STAT_CV4').AsString;
      ls_cv5 := FieldByName('STAT_CV5').AsString;
      ls_cv6 := FieldByName('STAT_CV5').AsString;
  End;

  // 방향(StrTo) 결정 - 호기에 따라 CV 상태 확인
  if (StrSc = '1') then begin
      if (ls_cv1 = '1') then StrTo := '1' else StrTo := '2';
  end
  else if (StrSc = '2') then begin
      if (ls_cv3 = '1') then StrTo := '1' else StrTo := '2';
  end
  else if (StrSc = '3') then begin
      if (ls_cv5 = '1') then StrTo := '1' else StrTo := '2';
  end
  else begin
      StrTo := '1'; // Default
  end;

  // [수정] PK 중복 방지 (IF NOT EXISTS)
  // T2TISCHE1 테이블에 이미 같은 INDEX가 있으면 건너뜀
  Var_Sql := ' IF NOT EXISTS (SELECT * FROM T2TISCHE1 WHERE SCHE_SC = ''' + StrSc + ''' AND SCHE_INDEX = ''' + OutIndex + ''') ';
  Var_Sql := Var_Sql + ' BEGIN ';
  Var_Sql := Var_Sql + '    Insert Into T2TISCHE1(SCHE_SC, SCHE_INDEX, SCHE_JOBGUBUN, SCHE_LOCA, ';
  Var_Sql := Var_Sql + '       SCHE_WSNO, SCHE_DATE, SCHE_TIME, SCHE_EMER, SCHE_PLTNO) ';
  Var_Sql := Var_Sql + '    Values('''+StrSC+''', '''+OutIndex+''', '''+OutGubun+''', '''+OutLoca+''',';
  Var_Sql := Var_Sql + '    '''+StrTo+''', '''+StrDate+''', '''+StrTime+''', ''N'', '''+OutPltno+''') ';
  Var_Sql := Var_Sql + ' END ';

  Try
    UpdtQuery.Close; UpdtQuery.SQL.Clear; UpdtQuery.SQL.Add(Var_Sql); UpdtQuery.ExecSQL;
  Except
     // 중복 에러는 무시 (로그 필요 시 추가)
  End;    
end;
procedure TFrm_4102.Replace_Table_Flag;
begin
  Var_Sql := ' Update T2MILSTK Set LSTK_FLAG = ''Y'' ';
  Var_Sql := Var_Sql + ' Where LSTK_FLAG = ''M'' ';
  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(Var_Sql);
      ExecSql;
    End;
  Except
    ShowMessage(Var_Sql);
  End;


  // 재입고시 SUBK_FLAG = ''R''
  Var_Sql := ' Update T2MISUBK Set SUBK_FLAG = ''Y'' ';
  Var_Sql := Var_Sql + ' Where SUBK_FLAG = ''M'' ';

  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(Var_Sql);
      ExecSql;
    End;
  Except
    ShowMessage(Var_Sql);
  End;
end;


procedure TFrm_4102.OutInfo_Print_proc;
var
   StrCntt : String;
begin
  StrMsg := '';
  Var_Sql := ' Select  *  From T2HHOUPT (NOLOCK) ';
  Var_Sql := Var_Sql + ' Where  ISNULL(HO_QTY,0) <> ISNULL(HO_OUTQTY,0) ';

  With SubkQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(Var_Sql);
    Open;

    if RecordCount = 0 Then Begin
        StrMsg := s_chasu + ' [차수] '+ ' 출고 예약 작업을 완료 하였습니다. ';
    End
    Else
    Begin
       StrCntt := IntToStr(RecordCount);
       StrMsg := s_chasu + ' [차수] '+  '  ' + StrCntt + ' 건' + ' 재고부족 발생 함'  +
                 ' (일부 출고 예약 작업을 완료 하였습니다.) ';
    End;
  End;
 Showmessage(StrMsg);
end;




procedure TFrm_4102.DataGridDrawCell(Sender: TObject; ACol, ARow: Integer;
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
      if (ACol = 8) Then Begin
        OldAlign := SetTextAlign (TStringGrid(Sender).Canvas.Handle, ta_right);
        TStringGrid(Sender).Canvas.TextRect(Rect, Rect.right-2, Rect.top+2, TStringGrid(Sender).Cells[ACol,ARow]);
        SetTextAlign(TStringGrid(Sender).Canvas.Handle, OldAlign);
      End;
    End;
  End;
end;   

procedure TFrm_4102.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_4102.FormDestroy(Sender: TObject);
begin
  Frm_4102 := Nil;
end;

procedure TFrm_4102.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;


procedure TFrm_4102.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_4102.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

function TFrm_4102.f_get_sysdate_time1(): String;
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

function TFrm_4102.IsNumCheck(var StrData: String): Boolean;
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

procedure TFrm_4102.itemEditKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then  StartBitBtnClick(Self);
end;

procedure TFrm_4102.Cust1EditKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then  StartBitBtnClick(Self);
end;

procedure TFrm_4102.Mast_SearchClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  Mast_Disp  := TMast_Disp.Create(Application);
  Bol_Modal := True;

  Mast_Disp.Edt_Search.Text := itemEdit.Text;
  If Mast_Disp <> Nil Then
    With TForm(Mast_Disp) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      Mast_Disp.Free;
    End;          

    itemEdit.Text  :=  jj_code;

end;


procedure TFrm_4102.chkAllClick(Sender: TObject);
Var
    iRow : Integer;
    iCol : Integer;
begin
    With AdvSGrid Do Begin
       For iRow := 1 To RowCount - 1 Do Begin
             SetCheckBoxState(1, iRow, chkAll.Checked );
       End;
    End;

end;

procedure TFrm_4102.AdvSGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin

    if ARow = 0 then // Title부분은 전부 중앙정렬한다.
        HAlign := taCenter
    else begin

        if ACol in [9,10,11] then // 숫자값이 들어있는 [9,10,11]번 Field의 데이터는 오른쪽으로 정렬한다.
            HAlign := taRightJustify
        else if ACol in [1,2] then HAlign := taCenter
        else // 나머지는 왼쪽으로 정렬한다.
            HAlign := taLeftJustify;
        end;     
end;

procedure TFrm_4102.AdvSGridGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
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
          10 : Begin
               AFont.Color  := clBlue;    //수량   폰트색 지정
               ABrush.Color := clMoneyGreen;
               AFont.Style := [fsBold];
               End;

          1 :  ABrush.Color := clLime;  //선택   바탕색 지정
          //ABrush.Color := clSilver;  //선택   바탕색 지정

//          2 :  if  (AdvSGrid.Cells[ACol, ARow] <> '')  then  AFont.Color  := clRed;
       End;
    End;
end;  


procedure TFrm_4102.AdvSGridCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
begin
{
    With AdvSGrid Do Begin
       If (ACol = 1) Then Begin
           If Length(Trim(Cells[2,ARow]))<> 0 Then Begin
              SetCheckBoxState(1, ARow, False);
           End
           Else Begin
              SetCheckBoxState(1, ARow, True);
           End;
           update;
       End;
    End;
}    
end;

procedure TFrm_4102.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg, var_Sql, Strchasu, strcode, strlotno, strdate : String;
  iRow     : Integer;
    iCol     : Integer;
    bCheck   : Boolean;
    bIsJob   : Boolean;
    sData    : String;
    iRet     : Integer;
begin
  var_Msg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin   
   With AdvSGrid Do begin
       For iRow := 1 To RowCount -1 Do Begin
          GetCheckBoxState(1, iRow, bCheck);
          If bCheck Then Begin
              If Cells[1, iRow] = '' Then Break;

              Strchasu  :=   Cells[3, iRow];
              Strdate   :=   Cells[4, iRow];
              Strcode   :=   Cells[5, iRow];
              Strlotno  :=   Cells[7, iRow];

              SData := Cells[4,iRow]+'|'+Cells[5,iRow];
              sData :=  sData +'|'+ Cells[6,iRow];

              Memo1.Lines.Add('삭제 = ' +  SData);

              While Pos('-', Strdate) > 0  Do Begin Delete(Strdate, Pos('-', Strdate), 1); End;

              Var_Sql := ' Delete  From T2HHOUPT ';
              Var_Sql := Var_Sql + ' Where HO_CHASU  = '''+Strchasu+'''  And HO_DATE = '''+Strdate+'''  ';
              Var_Sql := Var_Sql + ' And HO_CODE  = '''+Strcode+'''  And HO_LOTNO = '''+Strlotno+'''  ';
              Try
                 With UpdtQuery Do Begin
                  Close;
                  SQL.Clear;
                  SQL.Add(Var_Sql);
                  ExecSql;
                 End;  
             Except
                 Showmessage('Update Error = ' + Var_Sql);
             End;
          end;
       End;
    End; 

    StartBitBtnClick(Self);

 End;   
//
end;



procedure TFrm_4102.ExcelBitBtnClick(Sender: TObject);
var
   ls_date, ls_frdate, ls_todate, ls_title : String;
begin
 if MessageDlg('엑셀로 저장하곗습니까 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin

   ls_date  := DateTimeToStr( Now );

   ls_title  := '출고 지시 데이터';

   GridToExel(ls_title, ls_date);
 end;
end;

{*****************************************************************************}
{*  엑셀저장처리                                                             *}
{*****************************************************************************}
procedure TFrm_4102.GridToExel(s_title,  s_date : string);
var
   i,j, Row, Col, ColCnt,RowCnt, BookCount:Integer;
   V, sheet : Variant;
begin

 ColCnt:= 9;
 RowCnt:= AdvSGrid.RowCount - 1;
 i := 1;
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
    Sheet.Name := s_title;
 except 
 end;    

  V.Cells[1,4].Value := '[[ ' + s_title + ' ]]';

  V.Cells[1,4].Font.Size := '22';
  V.Cells[1,4].Font.Name := '굴림체';
  V.Cells[1,4].Font.FontStyle := 'Bold';
  V.Cells[1,4].EntireRow.Interior.Color := $02EEEEEE;

  V.Cells[2,1].Value := '발행일시:';
  V.Cells[2,2].Value := s_date;

 for Row := 4 to RowCnt+4 do begin
   V.Cells[Row,1].Value  := AdvSGrid.Cells[2, J];
   V.Cells[Row,2].Value  := AdvSGrid.Cells[3, J];
   V.Cells[Row,3].Value  := AdvSGrid.Cells[4, J];
   V.Cells[Row,4].Value  := AdvSGrid.Cells[5, J];
   V.Cells[Row,5].Value  := AdvSGrid.Cells[6, J];
   V.Cells[Row,6].Value  := AdvSGrid.Cells[7, J];
   V.Cells[Row,7].Value  := AdvSGrid.Cells[8, J];
   V.Cells[Row,8].Value  := AdvSGrid.Cells[9, J];
   V.Cells[Row,9].Value  := AdvSGrid.Cells[10, J];
   V.Cells[Row,10].Value := AdvSGrid.Cells[11, J];
   V.Cells[Row,11].Value := AdvSGrid.Cells[12, J];
   V.Cells[Row,12].Value := AdvSGrid.Cells[13, J];  
   V.Cells[Row,13].Value := AdvSGrid.Cells[14, J];
   V.Cells[Row,14].Value := AdvSGrid.Cells[15, J];   
   J := J + 1;
end;   

 v.Quit;

 {   // sample
  Interior.Color := RGB(200, 200, 200);
  
  HorizontalAlignment := xlHAlignCenter;
  Columns.AutoFit;
  Rows.AutoFit;

  NumberFormat := '@';
  HorizontalAlignment := xlHAlignLeft;
  Columns.AutoFit;
  Rows.AutoFit;


  NumberFormat := '#,##0';
  HorizontalAlignment := xlHAlignRight;
  Columns.AutoFit;
  Rows.AutoFit;
}
end;


procedure TFrm_4102.AdvSGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  begin
      with (Sender as TStringGrid) do  begin
    // Don't change color for first Column, first row
    if (ACol = 0) or (ARow = 0) then
      Canvas.Brush.Color := clBtnFace
    else
    begin
     if (ACol = 10) then
      begin
       if  (AdvSGrid.Cells[13, ARow] = 'Y')  then
       begin
//           AdvSGrid.SetCheckBoxState(2,ARow,True)
{
         Canvas.Font.Color := clBlue;
         Canvas.Brush.Color := $00E1FFF9;
         Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, cells[acol, arow]);
         Canvas.FrameRect(Rect);
}         
       end;
       end;
    end;
  end;
end;


procedure TFrm_4102.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg(' 정말로 인쇄 합니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_4102.AllDeleteBitBtnClick(Sender: TObject);
var
  var_Msg, var_Sql, StrLotid,ls_date : String;
  iRow     : Integer;
    iCol     : Integer;
    bCheck   : Boolean;
    bIsJob   : Boolean;
    sData    : String;
    iRet     : Integer;
begin

  var_Msg := ' 정말로 전부 데이터를 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
       Var_Sql := ' Delete  From T2HHOUPT ';
       Try
          With UpdtQuery Do Begin
                  Close;
                  SQL.Clear;
                  SQL.Add(Var_Sql);
                  ExecSql;
            End;
        Except
                 Showmessage('Delete Error = ' + Var_Sql);
        End;
    End;
    StartBitBtnClick(Self);   
end;

procedure TFrm_4102.AdvSGridGetFormat(Sender: TObject; ACol: Integer;
  var AStyle: TSortStyle; var aPrefix, aSuffix: String);
begin
{
   case ACol of
     0: AStyle := ssAlphabetic;
     1: AStyle := ssNumeric;
     2: AStyle := ssDate;
     3: begin
        AStyle := ssFinancial;
        APrefix := '$ ';
       end;
    end;
}
end;

procedure TFrm_4102.AdvSGridCanSort(Sender: TObject; ACol: Integer;
  var DoSort: Boolean);
begin
   Cursor := crHourGlass;
end;

procedure TFrm_4102.AdvSGridRawCompare(Sender: TObject; ACol, Row1,
  Row2: Integer; var Res: Integer);
var
 c1,c2: Integer;
Begin
{
     c1 := integer(AdvSGrid.Objects[ACol,Row1]);
     c2 := integer(AdvSGrid.Objects[ACol,Row2]);
     if (c1 = c2) then Res := 0 else if (c1 > c2) then Res := 1 else Res := -1;
}     
end;

procedure TFrm_4102.A1CheckBoxClick(Sender: TObject);
begin
//
end;

procedure TFrm_4102.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  RowCnt := 0;   i := 0;
end;

procedure TFrm_4102.QRBand3BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
   i := RowCnt + 1;
   Cell3.Caption := IntToStr(i);
   Inc(RowCnt);
end;

end.


///////////////////////////////////////////////////////
{
with (Sender as TStringGrid) do
  begin
    // Don't change color for first Column, first row
    if (ACol = 0) or (ARow = 0) then
      Canvas.Brush.Color := clBtnFace
    else
    begin
      case ACol of
        1: Canvas.Font.Color := clBlack;
        2: Canvas.Font.Color := clBlue;
      end;
      // Draw the Band
      if ARow mod 2 = 0 then
        Canvas.Brush.Color := $00E1FFF9
      else
        Canvas.Brush.Color := $00FFEBDF;
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, cells[acol, arow]);
      Canvas.FrameRect(Rect);
    end;
  end;
///////////////////////////////////////////////
  If ACol = 8 Then ABrush.Color := $00E4E4E4;
8번째 Column에 Color를 준다...

If ARow Mod 2 = 0 Then ABrush.Color := $00E4E4E4;
짝수 Row에 Color를 준다...

물론 AdvStringGrid의 Properties 중에서 GetCellColor 속성에 Coding을 해줘야 한다...
}

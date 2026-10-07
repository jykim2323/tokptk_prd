unit Frm3800;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, DB,
  DBTables, ADODB, QRCtrls, QuickRpt, BaseGrid, AdvGrid, ComObj, Variants, DateUtils;

type
  TFrm_3800 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Titlepl: TPanel;
    Label1: TLabel;
    ToDate: TDateTimePicker;
    Label2: TLabel;
    FromDate: TDateTimePicker;
    UpdtQuery: TADOQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    BCDField1: TBCDField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText5: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText9: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel6: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel13: TQRLabel;
    Query1: TADOQuery;
    QRLabel2: TQRLabel;
    QRDBText7: TQRDBText;
    QRLabel1: TQRLabel;
    QRDBText2: TQRDBText;
    Query1P_CODE: TWideStringField;
    Query1P_NAME: TWideStringField;
    Query1P_LOT: TWideStringField;
    Query1P_ININO: TIntegerField;
    Query1P_VOL: TIntegerField;
    Query1C_VOL: TIntegerField;
    Query1SAM_VOL: TIntegerField;
    Query1SAM_BOX: TIntegerField;
    Query1P_time: TDateTimeField;
    AdvSGrid: TAdvStringGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pLotEdit: TEdit;
    pCodeEdit: TEdit;
    pNameEdit: TEdit;
    LogicQuery: TADOQuery;
    StartBitBtn: TSpeedButton;
    AdvSGrid2: TAdvStringGrid;
    Panel6: TPanel;
    Panel7: TPanel;
    chkAll: TCheckBox;
    Label7: TLabel;
    confBitBtn: TSpeedButton;
    AllDeleteBitBtn: TSpeedButton;
    ConvertBitBtn: TSpeedButton;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);

//    procedure PrintBitBtnClick(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure SelRGClick(Sender: TObject); 
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Query1INPT_RFLAGGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure AdvSGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure AdvSGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure pCodeEditEnter(Sender: TObject);
    procedure pLotEditEnter(Sender: TObject);
    procedure pNameEditEnter(Sender: TObject);
    procedure pLotEditKeyPress(Sender: TObject; var Key: Char);
    procedure pCodeEditKeyPress(Sender: TObject; var Key: Char);
    procedure pNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure ConvertBitBtnClick(Sender: TObject);
    procedure AdvSGrid2CanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure AdvSGrid2GetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure confBitBtnClick(Sender: TObject);
    procedure chkAllClick(Sender: TObject);
    procedure AllDeleteBitBtnClick(Sender: TObject);
    procedure AdvSGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure AdvSGrid2GetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
      
  private
    { Private declarations }
    procedure Data_Grid_Clear;  // AdvsGrid
    procedure Data_Grid_Clear2; // AdvsGrid2
    procedure MouseWheelHandler(var Message: TMessage); override;

  public
    { Public declarations }
  end;

var
  Frm_3800: TFrm_3800;

  var_Sql : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate : String;
  StrDate1, StrDate2, s_index, s_code, s_lotno: String;

implementation

uses WinLib, FrmPrompt, FrmError, DbSet, FrmProgress;

{$R *.dfm} 


procedure TFrm_3800.FormCreate(Sender: TObject);
begin

  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  // sample
  //FromDate.Date := StartOfTheMonth(IncMonth(now, -6));
  //FromDate.Date := StartOfTheMonth(Now);

  FromDate.Date := Now;   ToDate.Date := Now;
  AdvSGrid2.Options := AdvSGrid2.Options - [goRowSelect] + [goEditing, goTabs];
  
  // 클릭 시 바로 에디터 열기
  AdvSGrid2.MouseActions.DirectEdit := True;

  StartBitBtnClick(Self);
end;

procedure TFrm_3800.Data_Grid_Clear;
var
  IntCnt : Integer;
Begin
  With AdvSGrid Do Begin
    Clear;
    Cells[1,0]  := 'NO';
    Cells[2,0]  := '체 크';
    Cells[3,0]  := '품 번';
    Cells[4,0]  := '품 명';
    Cells[5,0]  := 'LOT-NO';
    Cells[6,0]  := '시작번호';
    Cells[7,0]  := '계획수량';
    Cells[8,0]  := '확정수량';
    Cells[9,0]  := '샘플수량';
    Cells[10,0] := '샘플BOX';
    Cells[11,0] := '패킹일자';

  End;
  AdvSGrid.RowCount := 2;

  With AdvSGrid Do Begin
    ColWidths[0]  := 0;    // 숨김
    ColWidths[1]  := 40;   // NO
    ColWidths[2]  := 40;   // 체크
    ColWidths[3]  := 120;  // 품번
    ColWidths[4]  := 240;  // 품명
    ColWidths[5]  := 100;  // LOT-NO
    ColWidths[6]  := 80;  // 시작번호
    ColWidths[7]  := 80;  // 계획수량
    ColWidths[8]  := 80;  // 확정수량
    ColWidths[9]  := 80;  // 샘플수량
    ColWidths[10] := 80;  // 샘플BOX
    ColWidths[11] := 160;  // 패킹일자
  End;
End;

procedure TFrm_3800.Data_Grid_Clear2;
var
  IntCnt : Integer;
Begin
  With AdvSGrid2 Do Begin
    Clear;
    Cells[1, 0] := 'NO';
    Cells[2, 0] := '품목코드';
    Cells[3, 0] := '품목명';
    Cells[4, 0] := 'LOTNO';
    Cells[5, 0] := '입고중량';
    Cells[6, 0] := 'BOX-NO';
    Cells[7, 0] := '비고';
    Cells[8, 0] := '패킹일자';
    Cells[9, 0] := '시작번호'; 

  End;
  AdvSGrid2.RowCount := 2;

  With AdvSGrid2 Do Begin
    ColWidths[0] := 0;   //
    ColWidths[1] := 40;  // NO
    ColWidths[2] := 120; // 품목코드
    ColWidths[3] := 220; // 품목명
    ColWidths[4] := 100; // LOTNO
    ColWidths[5] := 80;  // 입고중량
    ColWidths[6] := 100; // BOX-NO (입력 가능)
    ColWidths[7] := 250; // 비고 (입력 가능)
    ColWidths[8] := 140; // 날짜
    ColWidths[9] := 0;   // 시작번호
  End;
End;


procedure TFrm_3800.StartBitBtnClick(Sender: TObject);
var
  iRow : Integer;
  ls_sql : String;
  ls_item, ls_name, ls_lot : String;
  ls_FromDate, ls_ToDate : String;
begin
  Data_Grid_Clear;

  ls_item  := pCodeEdit.Text;
  ls_name  := pNameEdit.Text;
  ls_lot   := pLotEdit.Text;

  ls_FromDate := FormatDateTime('yyyy-mm-dd', FromDate.Date);
  ls_ToDate   := FormatDateTime('yyyy-mm-dd', ToDate.Date);

  ls_sql := ' SELECT ';
  ls_sql := ls_sql + ' A.P_CODE, ';
  ls_sql := ls_sql + ' ISNULL(A.P_NAME, '''') AS P_NAME,';
  ls_sql := ls_sql + ' A.P_LOT, ';
  ls_sql := ls_sql + ' A.P_ININO, ';
  ls_sql := ls_sql + ' ISNULL(A.P_VOL, 0) AS P_VOL, ';
  ls_sql := ls_sql + ' A.C_VOL, ';
  ls_sql := ls_sql + ' ISNULL(A.SAM_VOL, 0) AS SAM_VOL, ';
  ls_sql := ls_sql + ' ISNULL(A.SAM_BOX, 0) AS SAM_BOX, ';
  ls_sql := ls_sql + ' A.P_time ';
  ls_sql := ls_sql + ' FROM OPCDB01.TOK.dbo.vmWorkInfoForLogi A '; // 운영
  ls_sql := ls_sql + ' LEFT JOIN T2LABELHIST B ';
  ls_sql := ls_sql + '   ON A.P_CODE  = B.P_CODE ';
  ls_sql := ls_sql + '  AND A.P_LOT   = B.P_LOT ';
  ls_sql := ls_sql + '  AND A.P_ININO = B.P_ININO ';
  ls_sql := ls_sql + ' WHERE B.P_CODE IS NULL';         // 미발행 건만 조회
  //ls_sql := ls_sql + '   AND ISNULL(A.C_VOL, 0) > 0';   // 확정수량이 NULL이 아니고 0보다 큰 것
  //ls_sql := ls_sql + '   AND A.P_time >= DATEADD(DAY, -7, GETDATE()) ';

  ls_sql := ls_sql + '   AND A.P_time >= ''' + ls_FromDate + ' 00:00:00'' ';
  ls_sql := ls_sql + '   AND A.P_time <= ''' + ls_ToDate   + ' 23:59:59'' ';

  //if length(ls_item) <> 0 then ls_Sql := ls_Sql + ' AND A.P_CODE  LIKE ''%'+ls_item+'%''   ';
  if length(ls_item) <> 0 then ls_Sql := ls_Sql + ' AND A.P_CODE = '''+ls_item+''' ';   // 고객사 요청

  if length(ls_name) <> 0 then ls_Sql := ls_Sql + ' AND A.P_NAME LIKE ''%'+ls_name+'%'' ';

  if length(ls_lot) <> 0 then ls_Sql := ls_Sql + ' AND A.P_LOT  LIKE ''%'+ls_lot+'%''   ';

  ls_sql := ls_sql + ' ORDER BY A.P_time DESC ';

  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(ls_sql);
  Query1.Open;
  Query1.First;

  iRow := 0;

  while True do
  begin
    if Query1.Eof = True then break;
    inc(iRow);
    AdvSGrid.Cells[1, iRow]  := IntToStr(iRow);
    AdvSGrid.Cells[3, iRow]  := Query1.FieldByName('P_CODE').AsString;   // 품 번
    AdvSGrid.Cells[4, iRow]  := Query1.FieldByName('P_NAME').AsString;   // 품 명
    AdvSGrid.Cells[5, iRow]  := Query1.FieldByName('P_LOT').AsString;    // LOT-NO
    AdvSGrid.Cells[6, iRow]  := Query1.FieldByName('P_ININO').AsString;  // 시작번호
    AdvSGrid.Cells[7, iRow]  := Query1.FieldByName('P_VOL').AsString;    // 계획수량
    AdvSGrid.Cells[8, iRow]  := Query1.FieldByName('C_VOL').AsString;    // 확정수량
    AdvSGrid.Cells[9, iRow]  := Query1.FieldByName('SAM_VOL').AsString;  // 샘플수량
    AdvSGrid.Cells[10, iRow] := Query1.FieldByName('SAM_BOX').AsString;  // 샘플박스
    AdvSGrid.Cells[11, iRow] := FormatDateTime('yyyy-mm-dd hh:nn:ss', Query1.FieldByName('P_TIME').AsDateTime); // 패킹일자


    // chkbox 추가
    AdvSGrid.AddCheckBox(2, iRow, True, True);
    AdvSGrid.RowCount := iRow + 1;
    Query1.Next;
  end;
end;

procedure TFrm_3800.ExlBtnClick(Sender: TObject);
var
  XL, WB, Sheet: Variant;
  iRow, iXlRow: Integer;
  bState, IsChecked: Boolean;
  
  // 변수 선언
  sCode, sName, sLot: String;
  iInino, iC_Vol, iSam_Vol, iSam_Box, iTotal_Box: Integer;
  dtP_Time: TDateTime;
  
  // 쿼리 결과 변수
  iBoxQty, iWgt: Integer;
  sBoxNo: String;
begin
  // 데이터 존재 확인
  if AdvSGrid.RowCount < 2 then
  begin
    MessageDlg('조회된 데이터가 없습니다.', mtInformation, [mbOk], 0);
    Exit;
  end;

  // 2. 체크 여부 확인
  IsChecked := False;
  for iRow := 1 to AdvSGrid.RowCount - 1 do
  begin
    if AdvSGrid.GetCheckBoxState(2, iRow, bState) and bState then
    begin
      IsChecked := True;
      Break;
    end;
  end;

  if not IsChecked then
  begin
    MessageDlg('선택된 항목이 없습니다.', mtWarning, [mbOk], 0);
    Exit;
  end;

  // 3. 실행 확인
  if MessageDlg('선택한 항목의 엑셀 생성 및 발행 이력을 저장하시겠습니까?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // 4. 엑셀 실행
  try
    XL := CreateOleObject('Excel.Application');
  except
    MessageDlg('엑셀이 설치되어 있지 않습니다.', mtError, [mbOk], 0);
    Exit;
  end;

  // 5. DB 트랜잭션 시작 (UpdtQuery의 Connection 사용)
  // LogicQuery와 UpdtQuery가 같은 ADOConnection을 쓴다고 가정합니다.
  if UpdtQuery.Connection.InTransaction then UpdtQuery.Connection.CommitTrans;
  UpdtQuery.Connection.BeginTrans;

  try
    XL.Visible := False;
    WB := XL.Workbooks.Add;
    Sheet := WB.ActiveSheet;

    // 헤더 작성
    Sheet.Cells[1, 1] := '품목코드';
    Sheet.Cells[1, 2] := '품목명';
    Sheet.Cells[1, 3] := 'LOTNO';
    Sheet.Cells[1, 4] := '입고중량';
    Sheet.Cells[1, 5] := 'BOX-NO';
    Sheet.Cells[1, 6] := '비고';
    Sheet.Range['A1:F1'].Font.Bold := True;
    Sheet.Range['A1:F1'].Interior.Color := clSilver;

    iXlRow := 2;

    // [Loop] 그리드 반복
    for iRow := 1 to AdvSGrid.RowCount - 1 do
    begin
      if AdvSGrid.GetCheckBoxState(2, iRow, bState) and bState then
      begin
        // --- A. 그리드 값 가져오기 ---
        sCode    := AdvSGrid.Cells[3, iRow];
        sName    := AdvSGrid.Cells[4, iRow];
        sLot     := AdvSGrid.Cells[5, iRow];
        iInino   := StrToIntDef(StringReplace(AdvSGrid.Cells[6, iRow], ',', '', [rfReplaceAll]), 0);
        
        // 추가 정보 (Master Insert용)
        // iPlan_Vol := StrToIntDef(StringReplace(AdvSGrid.Cells[7, iRow], ',', '', [rfReplaceAll]), 0);
        iC_Vol   := StrToIntDef(StringReplace(AdvSGrid.Cells[8, iRow], ',', '', [rfReplaceAll]), 0);
        iSam_Vol := StrToIntDef(StringReplace(AdvSGrid.Cells[9, iRow], ',', '', [rfReplaceAll]), 0);
        iSam_Box := StrToIntDef(StringReplace(AdvSGrid.Cells[10, iRow], ',', '', [rfReplaceAll]), 0);
        dtP_Time := StrToDateTimeDef(AdvSGrid.Cells[11, iRow], Now);

        // --- B. 마스터 테이블(T2LABELHIST) INSERT ---
        UpdtQuery.Close;
        UpdtQuery.SQL.Clear;
        UpdtQuery.SQL.Add('INSERT INTO T2LABELHIST ( ');
        UpdtQuery.SQL.Add('  P_CODE, P_NAME, P_LOT, P_ININO, ');
        UpdtQuery.SQL.Add('  C_VOL, SAM_VOL, SAM_BOX, P_TIME, PRINT_USER, PRINT_DT ');
        UpdtQuery.SQL.Add(') VALUES ( ');
        UpdtQuery.SQL.Add('  :P_CODE, :P_NAME, :P_LOT, :P_ININO, ');
        UpdtQuery.SQL.Add('  :C_VOL, :SAM_VOL, :SAM_BOX, :P_TIME, :PRINT_USER, GETDATE() ');
        UpdtQuery.SQL.Add(')');

        UpdtQuery.Parameters.ParamByName('P_CODE').Value  := sCode;
        UpdtQuery.Parameters.ParamByName('P_NAME').Value  := sName;
        UpdtQuery.Parameters.ParamByName('P_LOT').Value   := sLot;
        UpdtQuery.Parameters.ParamByName('P_ININO').Value := iInino;
        UpdtQuery.Parameters.ParamByName('C_VOL').Value   := iC_Vol;
        UpdtQuery.Parameters.ParamByName('SAM_VOL').Value := iSam_Vol;
        UpdtQuery.Parameters.ParamByName('SAM_BOX').Value := iSam_Box;
        
        UpdtQuery.Parameters.ParamByName('P_TIME').Value := dtP_Time;

        UpdtQuery.Parameters.ParamByName('PRINT_USER').Value := jj_id; // 로그인 ID 변수가 있다면 교체
        UpdtQuery.ExecSQL;


        // --- C. LogicQuery (CTE) 실행 ---
        LogicQuery.Close;
        // (주의) LogicQuery의 SQL 속성에는 이전에 만든 CTE 쿼리가 들어있어야 합니다.
        // 파라미터 바인딩
        LogicQuery.Parameters.ParamByName('P_CODE').Value  := sCode;
        LogicQuery.Parameters.ParamByName('P_LOT').Value   := sLot;
        LogicQuery.Parameters.ParamByName('P_ININO').Value := iInino;
        LogicQuery.Open;

        iTotal_Box := 0; // 총 박스 수 집계용

        // --- D. 디테일(T2LABELHIST_SUB) 처리 및 엑셀 쓰기 ---
        while not LogicQuery.Eof do
        begin
          // CTE 결과 값 읽기
          // (주의) CTE 쿼리의 SELECT 절에 Current_Box_Qty를 ITEM_QTY로 알리어스 주거나 인덱스로 가져와야 함.
          // 여기서는 WGT(중량)와 BOX_NO를 가져옵니다.
          
          iWgt    := LogicQuery.FieldByName('WGT').AsInteger;
          sBoxNo  := LogicQuery.FieldByName('BOX_NO').AsString;
          
          // *수정 포인트: LogicQuery SQL의 마지막 SELECT절에 'Current_Box_Qty'가 포함되어 있어야 ITEM_QTY를 넣을 수 있음.
          // 만약 없다면 WGT / 4 로 역산하거나 쿼리를 수정해야 함. (여기선 쿼리에 있다고 가정하거나 WGT 사용)
          // iBoxQty := LogicQuery.FieldByName('Current_Box_Qty').AsInteger; 
          // 만약 컬럼이 없다면 임시로 중량/4로 처리 (정확도를 위해 쿼리 수정 권장)
          if iWgt > 0 then iBoxQty := iWgt div 4 else iBoxQty := 0; 
          
          // 1. 엑셀 쓰기
          Sheet.Cells[iXlRow, 1] := sCode;
          Sheet.Cells[iXlRow, 2] := sName;
          Sheet.Cells[iXlRow, 3] := sLot;
          Sheet.Cells[iXlRow, 4] := iWgt;
          Sheet.Cells[iXlRow, 5] := sBoxNo;
          Sheet.Cells[iXlRow, 6] := ''; 

          // 2. 디테일 테이블 INSERT
          UpdtQuery.Close;
          UpdtQuery.SQL.Clear;
          UpdtQuery.SQL.Add('INSERT INTO T2LABELHIST_SUB ( ');
          UpdtQuery.SQL.Add('  P_CODE, P_LOT, P_ININO, BOX_NO, WGT, ITEM_QTY ');
          UpdtQuery.SQL.Add(') VALUES ( ');
          UpdtQuery.SQL.Add('  :P_CODE, :P_LOT, :P_ININO, :BOX_NO, :WGT, :ITEM_QTY ');
          UpdtQuery.SQL.Add(')');

          UpdtQuery.Parameters.ParamByName('P_CODE').Value   := sCode;
          UpdtQuery.Parameters.ParamByName('P_LOT').Value    := sLot;
          UpdtQuery.Parameters.ParamByName('P_ININO').Value  := iInino;
          UpdtQuery.Parameters.ParamByName('BOX_NO').Value   := sBoxNo;
          UpdtQuery.Parameters.ParamByName('WGT').Value      := iWgt;
          UpdtQuery.Parameters.ParamByName('ITEM_QTY').Value := iWgt; // 제품 수량(중량과 동일하게 처리함)

          UpdtQuery.ExecSQL;

          iTotal_Box := iTotal_Box + iBoxQty; // (옵션) 총 박스 수 누적
          
          Inc(iXlRow);
          LogicQuery.Next;
        end; // End While

        // (옵션) 마스터 테이블의 TOTAL_BOX 업데이트가 필요하면 여기서 UPDATE 수행
        // UpdtQuery.SQL.Text := 'UPDATE T2LABELHIST SET TOTAL_BOX = ...';

      end; // End If Checked
    end; // End For Grid

    Sheet.Columns.AutoFit;
    XL.Visible := True;

    // 모든 작업 성공 시 커밋
    UpdtQuery.Connection.CommitTrans;
    
    // 재조회 (리스트에서 발행된 건 사라지게 하기 위함)
    StartBitBtnClick(Self);

  except
    on E: Exception do
    begin
      // 에러 발생 시 롤백
      if UpdtQuery.Connection.InTransaction then UpdtQuery.Connection.RollbackTrans;
      
      if not VarIsEmpty(XL) then
      begin
        XL.Quit;
        XL := Unassigned;
      end;
      MessageDlg('오류 발생: ' + E.Message, mtError, [mbOk], 0);
    end;
  end;
end;



procedure TFrm_3800.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_3800.FormDestroy(Sender: TObject);
begin
  Frm_3800 := Nil;
end;

procedure TFrm_3800.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_3800.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg, var_Sql : String;
begin
  var_Msg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From T2MIINPT Where INPT_CODE    = '''+s_code+'''  ';
    var_sql := var_sql + '            And INPT_INDEX   = '''+s_index+'''    ';   

    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('입고이력 ' + s_code + ' 삭제 에러!!!! ');
      Exit;
    End;
    StartBitBtnClick(Self);
  end;
end;

procedure TFrm_3800.SelRGClick(Sender: TObject);
begin
   StartBitBtnClick(Self);
end;


procedure TFrm_3800.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    ls_use, Value, ls_rsrv : String;
    WW     : Integer;
    xDBGrid: TDBGrid;
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

procedure TFrm_3800.DBGrid1TitleClick(Column: TColumn);
begin
    if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_3800.MouseWheelHandler(var Message: TMessage);
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



procedure TFrm_3800.Query1INPT_RFLAGGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.Value = 'N'       then Text := '신규입고'
  else if Sender.Value = 'R'  then Text := '재입고'
  else Text := '';
end;

procedure TFrm_3800.AdvSGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then // Title부분은 전부 중앙정렬한다.
    HAlign := taCenter
  else begin
  if ACol in [6,7,8,9,10] then // 숫자값이 들어있는 번 Field의 데이터는 오른쪽으로 정렬한다.
    HAlign := taRightJustify
  else if ACol in [1, 2, 3, 5, 11] then HAlign := taCenter // 순번, 코드류, 날짜, 센터 정렬.

  else // 나머지는 왼쪽으로 정렬한다.
    HAlign := taLeftJustify;
  end;
end;

procedure TFrm_3800.AdvSGrid2GetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then // Title부분은 전부 중앙정렬한다.
    HAlign := taCenter
  else begin
  if ACol in [5] then // 숫자값이 들어있는 번 Field의 데이터는 오른쪽으로 정렬한다.
    HAlign := taRightJustify
  else if ACol in [1, 2, 4, 6, 8] then HAlign := taCenter // 순번, 코드류, 날짜, 센터 정렬.

  else // 나머지는 왼쪽으로 정렬한다.
    HAlign := taLeftJustify;
  end;
end;


procedure TFrm_3800.AdvSGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with (Sender as TStringGrid) do
  begin
    // Don't change color for first Column, first row
    if (ACol = 0) or (ARow = 0) then
      Canvas.Brush.Color := clBtnFace
    else
    begin
     if (ACol = 03) then
      begin
        Canvas.Font.Color := clBlue;
       end
      else if (ACol = 05) then
      begin
        Canvas.Font.Color := clBlue;
      end;
    end;
  end;
end;

procedure TFrm_3800.AdvSGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with (Sender as TStringGrid) do
  begin
    // Don't change color for first Column, first row
    if (ACol = 0) or (ARow = 0) then
      Canvas.Brush.Color := clBtnFace
    else
    begin
     if (ACol = 03) then
      begin
        Canvas.Font.Color := clBlue;
       end
      else if (ACol = 05) then
      begin
        Canvas.Font.Color := clBlue;
      end;
    end;
  end;
end;

procedure TFrm_3800.pCodeEditEnter(Sender: TObject);
begin
  StartBitBtnClick(Self);
end;

procedure TFrm_3800.pLotEditEnter(Sender: TObject);
begin
  StartBitBtnClick(Self);
end;

procedure TFrm_3800.pNameEditEnter(Sender: TObject);
begin
  StartBitBtnClick(Self);
end;

procedure TFrm_3800.pLotEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

procedure TFrm_3800.pCodeEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

procedure TFrm_3800.pNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;


procedure TFrm_3800.AdvSGrid2CanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  // [수정] 7번 컬럼(비고)만 수정 가능하도록 변경 (기존 9번 -> 7번)
  if (ARow > 0) and ((ACol = 7) or (ACol = 6) or (ACol = 5)) then
    CanEdit := True
  else
    CanEdit := False;
end;

// 1. C_VOL에 SAM_VOL 포함
{

-- 1 BOX에 4병 
-- 1 Pallet에 12box 들어가고 만약 자투리 box가 4개 이하면 마지막 Pallet에 추가해서 올라감, 5개 이상일 경우 새로운 Pallet에 올라감
WITH 
BaseData AS (
    -- BOX수 계산
    SELECT 
        P_CODE, P_NAME, P_LOT, P_ININO, C_VOL, SAM_VOL,
        (C_VOL - SAM_VOL) AS Total_Product_Qty,   -- C_VOL 에 SAM_VOL 포함 되어있음 고로 SAM_VOL은 발행 안하므로 C_VOL - SAM_VOL
        ((C_VOL - SAM_VOL) / 4) + CASE WHEN (C_VOL - SAM_VOL) % 4 > 0 THEN 1 ELSE 0 END AS Total_Box_Cnt, -- 한 box 4병으로 계산 후 나머지 생길 경우 + 1 box에 해당 병 투입
        CASE 
            WHEN (C_VOL - SAM_VOL) % 4 = 0 THEN 4
            ELSE (C_VOL - SAM_VOL) % 4 
        END AS Last_Box_Product_Qty -- 마지막 box 재품 수량 계산
    FROM OPCDB01.TOK.dbo.vmWorkInfoForLogi
      --FROM vmWorkInfoForLogi

    WHERE P_CODE  = :P_CODE 
      AND P_LOT   = :P_LOT  
      AND P_ININO = :P_ININO
),
RecursiveSplit AS (
    -- Pallet 수 , Pallet당 box수 계산 
    SELECT 
        P_CODE, P_NAME, P_LOT, P_ININO, Total_Box_Cnt, Last_Box_Product_Qty, 
        1 AS Seq, -- 첫 Pallet 
        P_ININO AS Start_No,
        CASE 
            WHEN Total_Box_Cnt < 12 THEN Total_Box_Cnt 
            WHEN (Total_Box_Cnt - 12) < 5 THEN Total_Box_Cnt
            ELSE 12 
        END AS Current_Box_Qty,
        Total_Box_Cnt - (
            CASE 
                WHEN Total_Box_Cnt < 12 THEN Total_Box_Cnt 
                WHEN (Total_Box_Cnt - 12) < 5 THEN Total_Box_Cnt
                ELSE 12 
            END
        ) AS Remaining_Qty
    FROM BaseData
    WHERE Total_Box_Cnt > 0

    UNION ALL

    SELECT 
        P_CODE, P_NAME, P_LOT, P_ININO, Total_Box_Cnt, Last_Box_Product_Qty,
        Seq + 1, -- seq+1 하고 Remaining_Qty 안남을때까지 반복
        Start_No + Current_Box_Qty,
        CASE 
            WHEN Remaining_Qty < 12 THEN Remaining_Qty 
            WHEN (Remaining_Qty - 12) < 5 THEN Remaining_Qty
            ELSE 12 
        END AS Current_Box_Qty,
        Remaining_Qty - (
            CASE 
                WHEN Remaining_Qty < 12 THEN Remaining_Qty 
                WHEN (Remaining_Qty - 12) < 5 THEN Remaining_Qty -- 5 미만 (4이하) 일 경우 기존 잔량 box에 더해서 넣음. ex) 잔량 box 16개 -> when (16-12) < 5 then 이므로 16 그대로
                ELSE 12 
            END
        ) AS Remaining_Qty    -- 남은 box수 
    FROM RecursiveSplit
    WHERE Remaining_Qty > 0
)
SELECT 
    P_CODE, P_NAME, P_LOT, 
    CASE 
        WHEN Remaining_Qty = 0 THEN ((Current_Box_Qty - 1) * 4) + Last_Box_Product_Qty 
        ELSE Current_Box_Qty * 4 
    END AS WGT,
    RIGHT('000' + CAST(Start_No AS VARCHAR), 3) + '-' + 
    RIGHT('000' + CAST(Start_No + Current_Box_Qty - 1 AS VARCHAR), 3) AS BOX_NO
FROM RecursiveSplit
ORDER BY Seq


}

// 2. C_VOL에 SAM_VOL 미포함
{
WITH BaseData AS (
    -- [수정됨] C_VOL 자체가 포장해야 할 총 수량이므로 SAM_VOL 차감 로직 제거
    SELECT 
        P_CODE, P_NAME, P_LOT, P_ININO, C_VOL, SAM_VOL,
        
        -- 1. 총 제품 수량 (그냥 C_VOL 사용)
        C_VOL AS Total_Product_Qty,  
        
        -- 2. 총 BOX 수량 계산 (C_VOL 기준)
        (C_VOL / 4) + CASE WHEN C_VOL % 4 > 0 THEN 1 ELSE 0 END AS Total_Box_Cnt,
        
        -- 3. 마지막 박스에 담길 낱개 수량 (C_VOL 기준)
        CASE 
            WHEN C_VOL % 4 = 0 THEN 4
            ELSE C_VOL % 4 
        END AS Last_Box_Product_Qty

    FROM OPCDB01.TOK.dbo.vmWorkInfoForLogi
    WHERE P_CODE  = :P_CODE 
      AND P_LOT   = :P_LOT   
      AND P_ININO = :P_ININO
),
RecursiveSplit AS (
    -- 이 아래 로직은 수정할 필요 없음 (위에서 계산된 Total_Box_Cnt를 받아 처리하므로 동일함)
    SELECT 
        P_CODE, P_NAME, P_LOT, P_ININO, Total_Box_Cnt, Last_Box_Product_Qty, 
        1 AS Seq, 
        P_ININO AS Start_No,
        CASE 
            WHEN Total_Box_Cnt < 12 THEN Total_Box_Cnt 
            WHEN (Total_Box_Cnt - 12) < 5 THEN Total_Box_Cnt
            ELSE 12 
        END AS Current_Box_Qty,
        Total_Box_Cnt - (
            CASE 
                WHEN Total_Box_Cnt < 12 THEN Total_Box_Cnt 
                WHEN (Total_Box_Cnt - 12) < 5 THEN Total_Box_Cnt
                ELSE 12 
            END
        ) AS Remaining_Qty
    FROM BaseData
    WHERE Total_Box_Cnt > 0

    UNION ALL

    SELECT 
        P_CODE, P_NAME, P_LOT, P_ININO, Total_Box_Cnt, Last_Box_Product_Qty,
        Seq + 1,
        Start_No + Current_Box_Qty,
        CASE 
            WHEN Remaining_Qty < 12 THEN Remaining_Qty 
            WHEN (Remaining_Qty - 12) < 5 THEN Remaining_Qty
            ELSE 12 
        END AS Current_Box_Qty,
        Remaining_Qty - (
            CASE 
                WHEN Remaining_Qty < 12 THEN Remaining_Qty 
                WHEN (Remaining_Qty - 12) < 5 THEN Remaining_Qty
                ELSE 12 
            END
        ) AS Remaining_Qty    
    FROM RecursiveSplit
    WHERE Remaining_Qty > 0
)
SELECT 
    P_CODE, P_NAME, P_LOT, 
    CASE 
        WHEN Remaining_Qty = 0 THEN ((Current_Box_Qty - 1) * 4) + Last_Box_Product_Qty 
        ELSE Current_Box_Qty * 4 
    END AS WGT,
    RIGHT('000' + CAST(Start_No AS VARCHAR), 3) + '-' + 
    RIGHT('000' + CAST(Start_No + Current_Box_Qty - 1 AS VARCHAR), 3) AS BOX_NO
FROM RecursiveSplit
ORDER BY Seq
}


{
procedure TFrm_3800.ConvertBitBtnClick(Sender: TObject);
var
  iRow, iGrid2Row: Integer;
  bState: Boolean;
  
  // 변수 선언
  sCode, sName, sLot: String;
  iInino, iWgt: Integer;
  sBoxNo: String;
  dtP_Time: TDateTime;
begin
  if AdvSGrid.RowCount < 2 then
  begin
    MessageDlg('조회된 데이터가 없습니다.', mtInformation, [mbOk], 0);
    Exit;
  end;

  AdvSGrid2.Clear;
  AdvSGrid2.RowCount := 2;
  Data_Grid_Clear2;

  iGrid2Row := 1;

  for iRow := 1 to AdvSGrid.RowCount - 1 do
  begin
    if AdvSGrid.GetCheckBoxState(2, iRow, bState) and bState then
    begin
      sCode    := AdvSGrid.Cells[3, iRow];
      sName    := AdvSGrid.Cells[4, iRow];
      sLot     := AdvSGrid.Cells[5, iRow];
      iInino   := StrToIntDef(StringReplace(AdvSGrid.Cells[6, iRow], ',', '', [rfReplaceAll]), 0);
      dtP_Time := StrToDateTimeDef(AdvSGrid.Cells[11, iRow], Now);

      LogicQuery.Close;
      LogicQuery.Parameters.ParamByName('P_CODE').Value  := sCode;
      LogicQuery.Parameters.ParamByName('P_LOT').Value   := sLot;
      LogicQuery.Parameters.ParamByName('P_ININO').Value := iInino;
      LogicQuery.Open;

      while not LogicQuery.Eof do
      begin
        if iGrid2Row >= AdvSGrid2.RowCount then
           AdvSGrid2.RowCount := AdvSGrid2.RowCount + 1;

        iWgt   := LogicQuery.FieldByName('WGT').AsInteger;
        sBoxNo := LogicQuery.FieldByName('BOX_NO').AsString;

        AdvSGrid2.Cells[1, iGrid2Row] := IntToStr(iGrid2Row);
        AdvSGrid2.Cells[2, iGrid2Row] := sCode;
        AdvSGrid2.Cells[3, iGrid2Row] := sName;
        AdvSGrid2.Cells[4, iGrid2Row] := sLot;
        AdvSGrid2.Cells[5, iGrid2Row] := IntToStr(iWgt);
        AdvSGrid2.Cells[6, iGrid2Row] := sBoxNo; // Box-No (사용자 수정 가능)
        AdvSGrid2.Cells[7, iGrid2Row] := ''; // 비고 (사용자 입력 가능)
        AdvSGrid2.Cells[8, iGrid2Row] := FormatDateTime('yyyy-mm-dd hh:nn:ss', dtP_Time);
        AdvSGrid2.Cells[9, iGrid2Row] := IntToStr(iInino);

        Inc(iGrid2Row);
        LogicQuery.Next;
      end;
    end;
  end;

  if iGrid2Row > 1 then
    MessageDlg('변환 완료. 비고란을 입력하세요.', mtInformation, [mbOk], 0)
  else
    MessageDlg('선택된 항목이 없습니다.', mtWarning, [mbOk], 0);
end;
}

procedure TFrm_3800.ConvertBitBtnClick(Sender: TObject);
var
  iRow, iGrid2Row: Integer;
  bState: Boolean;
  
  // 변수 선언
  sCode, sName, sLot: String;
  iInino, iWgt: Integer;
  sBoxNo, ls_sql: String; // ls_sql 추가
  dtP_Time: TDateTime;
begin
  if AdvSGrid.RowCount < 2 then
  begin
    MessageDlg('조회된 데이터가 없습니다.', mtInformation, [mbOk], 0);
    Exit;
  end;

  AdvSGrid2.Clear;
  AdvSGrid2.RowCount := 2;
  Data_Grid_Clear2;

  iGrid2Row := 1;

  for iRow := 1 to AdvSGrid.RowCount - 1 do
  begin
    if AdvSGrid.GetCheckBoxState(2, iRow, bState) and bState then
    begin
      sCode    := AdvSGrid.Cells[3, iRow];
      sName    := AdvSGrid.Cells[4, iRow];
      sLot     := AdvSGrid.Cells[5, iRow];
      iInino   := StrToIntDef(StringReplace(AdvSGrid.Cells[6, iRow], ',', '', [rfReplaceAll]), 0);
      dtP_Time := StrToDateTimeDef(AdvSGrid.Cells[11, iRow], Now);

      // [수정] 파라미터 에러 방지를 위해 SQL을 직접 구성합니다.
      // LogicQuery.SQL.Text 자체를 여기서 재작성합니다.
      LogicQuery.Close;
      LogicQuery.SQL.Clear;
      
      ls_sql := '';
      ls_sql := ls_sql + ' WITH BaseData AS ( ';
      ls_sql := ls_sql + '    SELECT ';
      ls_sql := ls_sql + '        P_CODE, P_NAME, P_LOT, P_ININO, C_VOL, SAM_VOL, ';
      
      // [요청하신 로직 적용] 병 번호(P_ININO)를 박스 시작 번호로 변환: ((병번호 - 1) / 4) + 1
      ls_sql := ls_sql + '        ((' + IntToStr(iInino) + ' - 1) / 4) + 1 AS Calculated_Start_Box_No, ';

      ls_sql := ls_sql + '        (ISNULL(NULLIF(C_VOL, 0), P_VOL) - SAM_VOL) AS Total_Product_Qty, ';
      ls_sql := ls_sql + '        ((ISNULL(NULLIF(C_VOL, 0), P_VOL) - SAM_VOL) / 4) + ';
      ls_sql := ls_sql + '        CASE WHEN (ISNULL(NULLIF(C_VOL, 0), P_VOL) - SAM_VOL) % 4 > 0 THEN 1 ELSE 0 END AS Total_Box_Cnt, ';
      ls_sql := ls_sql + '        CASE ';
      ls_sql := ls_sql + '            WHEN (ISNULL(NULLIF(C_VOL, 0), P_VOL) - SAM_VOL) % 4 = 0 THEN 4 ';
      ls_sql := ls_sql + '            ELSE (ISNULL(NULLIF(C_VOL, 0), P_VOL) - SAM_VOL) % 4 ';
      ls_sql := ls_sql + '        END AS Last_Box_Product_Qty ';
      ls_sql := ls_sql + '    FROM OPCDB01.TOK.dbo.vmWorkInfoForLogi ';
      
      // [파라미터 대신 값 직접 주입] QuotedStr은 문자열 앞뒤에 따옴표를 붙여줍니다.
      ls_sql := ls_sql + '    WHERE P_CODE  = ' + QuotedStr(sCode) + ' ';
      ls_sql := ls_sql + '      AND P_LOT   = ' + QuotedStr(sLot) + ' ';
      ls_sql := ls_sql + '      AND P_ININO = ' + IntToStr(iInino) + ' ';
      ls_sql := ls_sql + ' ), ';
      
      ls_sql := ls_sql + ' RecursiveSplit AS ( ';
      ls_sql := ls_sql + '    SELECT ';
      ls_sql := ls_sql + '        P_CODE, P_NAME, P_LOT, P_ININO, Total_Box_Cnt, Last_Box_Product_Qty, ';
      ls_sql := ls_sql + '        1 AS Seq, ';
      ls_sql := ls_sql + '        Calculated_Start_Box_No AS Start_No, '; // 계산된 박스 번호 사용
      ls_sql := ls_sql + '        CASE ';
      ls_sql := ls_sql + '            WHEN Total_Box_Cnt < 12 THEN Total_Box_Cnt ';
      ls_sql := ls_sql + '            WHEN (Total_Box_Cnt - 12) < 5 THEN Total_Box_Cnt ';
      ls_sql := ls_sql + '            ELSE 12 ';
      ls_sql := ls_sql + '        END AS Current_Box_Qty, ';
      ls_sql := ls_sql + '        Total_Box_Cnt - ( ';
      ls_sql := ls_sql + '            CASE ';
      ls_sql := ls_sql + '                WHEN Total_Box_Cnt < 12 THEN Total_Box_Cnt ';
      ls_sql := ls_sql + '                WHEN (Total_Box_Cnt - 12) < 5 THEN Total_Box_Cnt ';
      ls_sql := ls_sql + '                ELSE 12 ';
      ls_sql := ls_sql + '            END ';
      ls_sql := ls_sql + '        ) AS Remaining_Qty ';
      ls_sql := ls_sql + '    FROM BaseData ';
      ls_sql := ls_sql + '    WHERE Total_Box_Cnt > 0 ';
      
      ls_sql := ls_sql + '    UNION ALL ';
      
      ls_sql := ls_sql + '    SELECT ';
      ls_sql := ls_sql + '        P_CODE, P_NAME, P_LOT, P_ININO, Total_Box_Cnt, Last_Box_Product_Qty, ';
      ls_sql := ls_sql + '        Seq + 1, ';
      ls_sql := ls_sql + '        Start_No + Current_Box_Qty, ';
      ls_sql := ls_sql + '        CASE ';
      ls_sql := ls_sql + '            WHEN Remaining_Qty < 12 THEN Remaining_Qty ';
      ls_sql := ls_sql + '            WHEN (Remaining_Qty - 12) < 5 THEN Remaining_Qty ';
      ls_sql := ls_sql + '            ELSE 12 ';
      ls_sql := ls_sql + '        END AS Current_Box_Qty, ';
      ls_sql := ls_sql + '        Remaining_Qty - ( ';
      ls_sql := ls_sql + '            CASE ';
      ls_sql := ls_sql + '                WHEN Remaining_Qty < 12 THEN Remaining_Qty ';
      ls_sql := ls_sql + '                WHEN (Remaining_Qty - 12) < 5 THEN Remaining_Qty ';
      ls_sql := ls_sql + '                ELSE 12 ';
      ls_sql := ls_sql + '            END ';
      ls_sql := ls_sql + '        ) AS Remaining_Qty ';
      ls_sql := ls_sql + '    FROM RecursiveSplit ';
      ls_sql := ls_sql + '    WHERE Remaining_Qty > 0 ';
      ls_sql := ls_sql + ' ) ';
      
      ls_sql := ls_sql + ' SELECT ';
      ls_sql := ls_sql + '    P_CODE, P_NAME, P_LOT, ';
      ls_sql := ls_sql + '    CASE ';
      ls_sql := ls_sql + '        WHEN Remaining_Qty = 0 THEN ((Current_Box_Qty - 1) * 4) + Last_Box_Product_Qty ';
      ls_sql := ls_sql + '        ELSE Current_Box_Qty * 4 ';
      ls_sql := ls_sql + '    END AS WGT, ';
      ls_sql := ls_sql + '    RIGHT(''000'' + CAST(Start_No AS VARCHAR), 3) + ''-'' + ';
      ls_sql := ls_sql + '    RIGHT(''000'' + CAST(Start_No + Current_Box_Qty - 1 AS VARCHAR), 3) AS BOX_NO ';
      ls_sql := ls_sql + ' FROM RecursiveSplit ';
      ls_sql := ls_sql + ' ORDER BY Seq ';

      LogicQuery.SQL.Add(ls_sql);
      
      // [중요] 파라미터를 사용하지 않으므로 ParamByName 부분 삭제
      LogicQuery.Open;

      while not LogicQuery.Eof do
      begin
        if iGrid2Row >= AdvSGrid2.RowCount then
           AdvSGrid2.RowCount := AdvSGrid2.RowCount + 1;

        iWgt   := LogicQuery.FieldByName('WGT').AsInteger;
        sBoxNo := LogicQuery.FieldByName('BOX_NO').AsString;

        AdvSGrid2.Cells[1, iGrid2Row] := IntToStr(iGrid2Row);
        AdvSGrid2.Cells[2, iGrid2Row] := sCode;
        AdvSGrid2.Cells[3, iGrid2Row] := sName;
        AdvSGrid2.Cells[4, iGrid2Row] := sLot;
        AdvSGrid2.Cells[5, iGrid2Row] := IntToStr(iWgt);
        AdvSGrid2.Cells[6, iGrid2Row] := sBoxNo; 
        AdvSGrid2.Cells[7, iGrid2Row] := ''; 
        AdvSGrid2.Cells[8, iGrid2Row] := FormatDateTime('yyyy-mm-dd hh:nn:ss', dtP_Time);
        AdvSGrid2.Cells[9, iGrid2Row] := IntToStr(iInino);

        Inc(iGrid2Row);
        LogicQuery.Next;
      end;
    end;
  end;

  if iGrid2Row > 1 then
    MessageDlg('변환 완료. 비고란을 입력하세요.', mtInformation, [mbOk], 0)
  else
    MessageDlg('선택된 항목이 없습니다.', mtWarning, [mbOk], 0);
end;

procedure TFrm_3800.AdvSGrid2GetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  // box-no, 비고 수정 가능
  if ACol = 6 then
    AEditor := edNormal;
  if ACol = 7 then
    AEditor := edNormal;
end;

procedure TFrm_3800.ConfBitBtnClick(Sender: TObject);
var
  XL, WB, Sheet: Variant;
  iRow, iXlRow: Integer;
  bState: Boolean;
  sSaveFileName: String;
  SaveDlg: TSaveDialog;

  // T2LABELHIST 용 변수
  sCode, sName, sLot: String;
  iInino, iP_Vol, iC_Vol, iSam_Vol, iSam_Box, iTotal_Box, iCalcQty: Integer;
  dtP_Time: TDateTime;

  // T2LABELHIST_SUB 용 변수
  sDtlCode, sDtlName, sDtlLot, sBoxNo, sBigo: String;
  iDtlInino, iWgt: Integer;
begin

  if (AdvSGrid2.RowCount < 2) or
     ((AdvSGrid2.RowCount = 2) and (Trim(AdvSGrid2.Cells[2, 1]) = '')) then
  begin
    MessageDlg('발행할 데이터가 없습니다. [변환]을 먼저 진행해주세요.', mtWarning, [mbOk], 0);
    Exit;
  end;

  SaveDlg := TSaveDialog.Create(Self); // 저장 위치 선택 대화상자 
  try
    SaveDlg.Title := '엑셀 저장 위치 선택';
    SaveDlg.DefaultExt := 'xlsx';
    SaveDlg.Filter := 'Excel Files (*.xlsx)|*.xlsx';
    // 파일명: 년월일시분_입고엑셀발행.xlsx
    SaveDlg.FileName := FormatDateTime('yyyymmddhhnn', Now) + '_입고엑셀발행.xlsx';
    SaveDlg.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]; // 덮어쓰기 여부 

    // 취소 버튼을 누르면 종료
    if not SaveDlg.Execute then Exit;
    
    sSaveFileName := SaveDlg.FileName;
  finally
    SaveDlg.Free;
  end;

  // 엑셀 실행
  try
    XL := CreateOleObject('Excel.Application');
  except
    MessageDlg('엑셀 오류: 설치 확인 요망', mtError, [mbOk], 0); Exit;
  end;

  // T2LABELHIST , T2LABELHIST_SUB UPDATE 
  if UpdtQuery.Connection.InTransaction then UpdtQuery.Connection.CommitTrans;
  UpdtQuery.Connection.BeginTrans;

  try
    XL.Visible := False;
    XL.DisplayAlerts := False; 

    WB := XL.Workbooks.Add;
    Sheet := WB.ActiveSheet;

    Sheet.Name := '입고 엑셀 리스트';

    // 헤더 작성
    Sheet.Cells[1, 1] := '품목코드'; Sheet.Cells[1, 2] := '품목명';
    Sheet.Cells[1, 3] := 'LOTNO';    Sheet.Cells[1, 4] := '입고중량';
    Sheet.Cells[1, 5] := 'BOX-NO';   Sheet.Cells[1, 6] := '비고';
    Sheet.Range['A1:F1'].Font.Bold := True;
    Sheet.Range['A1:F1'].Interior.Color := clSilver;
    Sheet.Columns[1].NumberFormat := '@'; 
    Sheet.Columns[3].NumberFormat := '@'; 
    
    iXlRow := 2;

    // =========================================================
    // T2LABELHIST 저장 
    // =========================================================
    for iRow := 1 to AdvSGrid.RowCount - 1 do
    begin
      if AdvSGrid.GetCheckBoxState(2, iRow, bState) and bState then
      begin
        sCode    := AdvSGrid.Cells[3, iRow];
        sName    := AdvSGrid.Cells[4, iRow];
        sLot     := AdvSGrid.Cells[5, iRow];
        iInino   := StrToIntDef(StringReplace(AdvSGrid.Cells[6, iRow], ',', '', [rfReplaceAll]), 0);
        iP_Vol   := StrToIntDef(StringReplace(AdvSGrid.Cells[7, iRow], ',', '', [rfReplaceAll]), 0); 
        iC_Vol   := StrToIntDef(StringReplace(AdvSGrid.Cells[8, iRow], ',', '', [rfReplaceAll]), 0);
        iSam_Vol := StrToIntDef(StringReplace(AdvSGrid.Cells[9, iRow], ',', '', [rfReplaceAll]), 0);
        iSam_Box := StrToIntDef(StringReplace(AdvSGrid.Cells[10, iRow], ',', '', [rfReplaceAll]), 0);
        dtP_Time := StrToDateTimeDef(AdvSGrid.Cells[11, iRow], Now);

        iCalcQty := iC_Vol - iSam_Vol;
        if iCalcQty > 0 then
        begin
          iTotal_Box := iCalcQty div 4;
          if (iCalcQty mod 4) > 0 then Inc(iTotal_Box);
        end
        else
          iTotal_Box := 0;

        UpdtQuery.Close;
        UpdtQuery.SQL.Clear;
        UpdtQuery.SQL.Add('INSERT INTO T2LABELHIST (P_CODE, P_NAME, P_LOT, P_ININO, P_VOL, C_VOL, SAM_VOL, SAM_BOX, TOTAL_BOX, P_TIME, PRINT_USER, PRINT_DT)');
        UpdtQuery.SQL.Add(' VALUES (:P_CODE, :P_NAME, :P_LOT, :P_ININO, :P_VOL, :C_VOL, :SAM_VOL, :SAM_BOX, :TOTAL_BOX, :P_TIME, :PRINT_USER, GETDATE())');
        
        UpdtQuery.Parameters.ParamByName('P_CODE').Value  := sCode;
        UpdtQuery.Parameters.ParamByName('P_NAME').Value  := sName;
        UpdtQuery.Parameters.ParamByName('P_LOT').Value   := sLot;
        UpdtQuery.Parameters.ParamByName('P_ININO').Value := iInino;
        UpdtQuery.Parameters.ParamByName('P_VOL').Value   := iP_Vol;
        UpdtQuery.Parameters.ParamByName('C_VOL').Value   := iC_Vol;
        UpdtQuery.Parameters.ParamByName('SAM_VOL').Value := iSam_Vol;
        UpdtQuery.Parameters.ParamByName('SAM_BOX').Value := iSam_Box;
        UpdtQuery.Parameters.ParamByName('TOTAL_BOX').Value := iTotal_Box;
        UpdtQuery.Parameters.ParamByName('P_TIME').Value  := dtP_Time;
        UpdtQuery.Parameters.ParamByName('PRINT_USER').Value := jj_id; 
        UpdtQuery.ExecSQL;
      end;
    end;

    // =========================================================
    // T2LABELHIST_SUB & 엑셀 저장
    // =========================================================
    for iRow := 1 to AdvSGrid2.RowCount - 1 do
    begin
      sDtlCode  := AdvSGrid2.Cells[2, iRow];
      sDtlName  := AdvSGrid2.Cells[3, iRow]; 
      sDtlLot   := AdvSGrid2.Cells[4, iRow];
      iWgt      := StrToIntDef(StringReplace(AdvSGrid2.Cells[5, iRow], ',', '', [rfReplaceAll]), 0);
      sBoxNo    := AdvSGrid2.Cells[6, iRow]; 
      sBigo     := AdvSGrid2.Cells[7, iRow]; 
      iDtlInino := StrToIntDef(AdvSGrid2.Cells[9, iRow], 0);

      Sheet.Cells[iXlRow, 1] := sDtlCode;
      Sheet.Cells[iXlRow, 2] := sDtlName;
      Sheet.Cells[iXlRow, 3] := sDtlLot;
      Sheet.Cells[iXlRow, 4] := iWgt;
      Sheet.Cells[iXlRow, 5] := sBoxNo;
      Sheet.Cells[iXlRow, 6] := sBigo;

      UpdtQuery.Close;
      UpdtQuery.SQL.Clear;
      UpdtQuery.SQL.Add('INSERT INTO T2LABELHIST_SUB (P_CODE, P_NAME, P_LOT, P_ININO, BOX_NO, ITEM_QTY, BIGO)');
      UpdtQuery.SQL.Add(' VALUES (:P_CODE, :P_NAME, :P_LOT, :P_ININO, :BOX_NO, :ITEM_QTY, :BIGO)');

      UpdtQuery.Parameters.ParamByName('P_CODE').Value   := sDtlCode;
      UpdtQuery.Parameters.ParamByName('P_NAME').Value   := sDtlName; 
      UpdtQuery.Parameters.ParamByName('P_LOT').Value    := sDtlLot;
      UpdtQuery.Parameters.ParamByName('P_ININO').Value  := iDtlInino;
      UpdtQuery.Parameters.ParamByName('BOX_NO').Value   := sBoxNo; 
      UpdtQuery.Parameters.ParamByName('ITEM_QTY').Value := iWgt; 
      UpdtQuery.Parameters.ParamByName('BIGO').Value     := sBigo; 

      UpdtQuery.ExecSQL;
      
      Inc(iXlRow);
    end;

    Sheet.Columns.AutoFit;
    
    // 파일 저장 및 엑셀 프로세스 종료
    WB.SaveAs(sSaveFileName);
    XL.Quit; // 엑셀 종료
    XL := Unassigned;

    // 완료 처리
    UpdtQuery.Connection.CommitTrans;
    
    MessageDlg('생성 완료되었습니다.', mtInformation, [mbOk], 0);
    
    AdvSGrid2.Clear; 
    AdvSGrid2.RowCount := 2;

    // 검색 조건 초기화
    pCodeEdit.Text := '';
    pLotEdit.Text := '';
    pNameEdit.Text := '';
    FromDate.Date := Now;   ToDate.Date := Now;
    
    StartBitBtnClick(Self); 

  except
    on E: Exception do
    begin
      if UpdtQuery.Connection.InTransaction then UpdtQuery.Connection.RollbackTrans;
      
      if not VarIsEmpty(XL) then
      begin 
        XL.DisplayAlerts := False; 
        XL.Quit; 
        XL := Unassigned; 
      end;
      
      MessageDlg('오류 발생: ' + E.Message, mtError, [mbOk], 0);
    end;
  end;

  chkAll.Checked := false;
end;

// 1. chkAll 체크박스 클릭 시: 상단 그리드(AdvSGrid) 전체 선택/해제
procedure TFrm_3800.chkAllClick(Sender: TObject);
var
  iRow: Integer;
begin
  // 데이터 있을 경우만
  if AdvSGrid.RowCount < 2 then Exit;

  // 그리드 갱신을 멈춤
  AdvSGrid.BeginUpdate;
  try
    for iRow := 1 to AdvSGrid.RowCount - 1 do
    begin
      AdvSGrid.SetCheckBoxState(2, iRow, chkAll.Checked);
    end;
  finally
    AdvSGrid.EndUpdate; // 그리드 갱신 멈춤 해제
  end;
end;

procedure TFrm_3800.AllDeleteBitBtnClick(Sender: TObject);
begin
  if AdvSGrid2.RowCount < 2 then Exit;

  if MessageDlg('하단 변환 목록을 모두 삭제하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Data_Grid_Clear2; // grid 초기화
    MessageDlg('초기화 되었습니다.', mtInformation, [mbOk], 0);
  end;
end;

end.

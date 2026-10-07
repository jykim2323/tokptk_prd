unit Frm3810;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, DB,
  DBTables, ADODB, QRCtrls, QuickRpt, BaseGrid, AdvGrid, ComObj, Variants, DateUtils;

type
  TFrm_3810 = class(TForm)
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
    AdvSGrid: TAdvStringGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pLotEdit: TEdit;
    pCodeEdit: TEdit;
    pNameEdit: TEdit;
    StartBitBtn: TSpeedButton;
    ConfirmBitBtn: TSpeedButton;
    Panel6: TPanel;
    boxNoEdit: TEdit;
    chkAll: TCheckBox;
    Panel7: TPanel;
    pFromDate: TDateTimePicker;
    Label3: TLabel;
    pToDate: TDateTimePicker;
    Label5: TLabel;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure SelRGClick(Sender: TObject); 
    procedure DBGrid1TitleClick(Column: TColumn);
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
    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure chkAllClick(Sender: TObject);
    procedure AdvSGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure AdvSGridGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);

  private
    { Private declarations }
    procedure Data_Grid_Clear;
    procedure MouseWheelHandler(var Message: TMessage); override;

  public
    { Public declarations }
  end;

var
  Frm_3810: TFrm_3810;

  var_Sql : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate : String;
  StrDate1, StrDate2, s_index, s_code, s_lotno: String;

implementation

uses WinLib, FrmPrompt, FrmError, DbSet, FrmProgress;

{$R *.dfm} 


procedure TFrm_3810.FormCreate(Sender: TObject);
begin

  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;
  // 발행일자
  FromDate.Date := Now;
  ToDate.Date := Now;
  
  // 패킹일자
  //pFromDate.Date := Now;
  //pFromDate.Date := StartOfTheMonth(IncMonth(now, -6));
  pFromDate.Date := StartOfTheMonth(Now); // 현재월 시작일
  pToDate.Date := Now;

  AdvSGrid.Options := AdvSGrid.Options - [goRowSelect] + [goEditing, goTabs];
  AdvSGrid.MouseActions.DirectEdit := True; // 클릭 시 바로 편집 모드

  // SeltCB.ItemIndex := 0;
  StartBitBtnClick(Self);
end;

procedure TFrm_3810.Data_Grid_Clear;
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
    Cells[6,0]  := '입고중량';
    Cells[7,0]  := 'BOX-NO';
    Cells[8,0]  := '비 고';
    Cells[9,0]  := '패킹일자';
    Cells[10,0] := '발행일자';
  End;
  AdvSGrid.RowCount := 2;

  With AdvSGrid Do Begin
    ColWidths[0]  := 0;    // 숨김
    ColWidths[1]  := 40;   // NO
    ColWidths[2]  := 40;   // 체크
    ColWidths[3]  := 120;  // 품 번
    ColWidths[4]  := 240;  // 품 명
    ColWidths[5]  := 100;  // LOT-NO
    ColWidths[6]  := 75;   // 입고중량
    ColWidths[7]  := 100;  // BOX-NO
    ColWidths[8]  := 200;  // 비 고
    ColWidths[9]  := 140;  // 패킹일자
    ColWidths[10] := 140;  // 발행일자
  End;
End;



procedure TFrm_3810.StartBitBtnClick(Sender: TObject);
var
  iRow : Integer;
  ls_sql : String;
  ls_item, ls_name, ls_lot, ls_boxno : String;
  ls_FromDate, ls_ToDate : String;
  ls_pFromDate, ls_pToDate : String;
begin
  Data_Grid_Clear;

  ls_item  := Trim(pCodeEdit.Text);
  ls_name  := Trim(pNameEdit.Text);
  ls_lot   := Trim(pLotEdit.Text);
  ls_boxno := Trim(boxNoEdit.Text);

  ls_FromDate := FormatDateTime('yyyy-mm-dd', FromDate.Date);
  ls_ToDate   := FormatDateTime('yyyy-mm-dd', ToDate.Date);
  ls_pFromDate := FormatDateTime('yyyy-mm-dd', pFromDate.Date);
  ls_pToDate   := FormatDateTime('yyyy-mm-dd', pToDate.Date);

  ls_sql := '           SELECT ';
  ls_sql := ls_sql + '    A.P_CODE ';
  ls_sql := ls_sql + '    , A.P_NAME ';
  ls_sql := ls_sql + '    , A.P_LOT ';
  ls_sql := ls_sql + '    , A.P_ININO ';
  ls_sql := ls_sql + '    , A.BOX_NO ';
  ls_sql := ls_sql + '    , A.ITEM_QTY ';
  ls_sql := ls_sql + '    , A.BIGO ';
  ls_sql := ls_sql + '    , B.P_TIME ';
  ls_sql := ls_sql + '    , B.PRINT_DT ';
  ls_sql := ls_sql + '  FROM T2LABELHIST_SUB A ';
  ls_sql := ls_sql + '  LEFT OUTER JOIN T2LABELHIST B ON A.P_CODE = B.P_CODE AND A.P_LOT = B.P_LOT AND A.P_ININO = B.P_ININO ';
  ls_sql := ls_sql + '  WHERE 1=1 ';
  if length(ls_item) > 0 then
    //ls_sql := ls_sql + ' AND A.P_CODE LIKE ''%' + ls_item + '%'' ';
    ls_sql := ls_sql + ' AND A.P_CODE = ''' + ls_item + ''' '; // 고객사 요청사항

  if length(ls_name) > 0 then
    ls_sql := ls_sql + ' AND A.P_NAME LIKE ''%' + ls_name + '%'' ';

  if length(ls_lot) > 0 then 
    ls_sql := ls_sql + ' AND A.P_LOT LIKE ''%' + ls_lot + '%'' ';

  if length(ls_boxno) > 0 then
    ls_sql := ls_sql + ' AND A.BOX_NO LIKE ''%' + ls_boxno + '%'' ';

  ls_sql := ls_sql + '   AND B.PRINT_DT >= ''' + ls_FromDate + ' 00:00:00'' ';
  ls_sql := ls_sql + '   AND B.PRINT_DT <= ''' + ls_ToDate   + ' 23:59:59'' ';

  ls_sql := ls_sql + '   AND B.P_TIME >= ''' + ls_pFromDate + ' 00:00:00'' ';
  ls_sql := ls_sql + '   AND B.P_TIME <= ''' + ls_pToDate   + ' 23:59:59'' ';


  ls_sql := ls_sql + '  ORDER BY B.PRINT_DT DESC, A.P_CODE ASC, A.P_LOT ASC, A.BOX_NO ASC ';

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
    AdvSGrid.Cells[3, iRow]  := Trim(Query1.FieldByName('P_CODE').AsString);   // 품 번
    AdvSGrid.Cells[4, iRow]  := Trim(Query1.FieldByName('P_NAME').AsString);   // 품 명
    AdvSGrid.Cells[5, iRow]  := Trim(Query1.FieldByName('P_LOT').AsString);    // LOT-NO
    AdvSGrid.Cells[6, iRow]  := Trim(Query1.FieldByName('ITEM_QTY').AsString); // 입고중량
    AdvSGrid.Cells[7, iRow]  := Trim(Query1.FieldByName('BOX_NO').AsString);   // BOX-NO
    AdvSGrid.Cells[8, iRow]  := Trim(Query1.FieldByName('BIGO').AsString);     // 비고
    AdvSGrid.Cells[9, iRow] := FormatDateTime('yyyy-mm-dd hh:nn:ss', Query1.FieldByName('P_TIME').AsDateTime); // 패킹일자
    AdvSGrid.Cells[10, iRow] := FormatDateTime('yyyy-mm-dd hh:nn:ss', Query1.FieldByName('PRINT_DT').AsDateTime); // 발행일자

    // chkbox 추가
    AdvSGrid.AddCheckBox(2, iRow, True, True);
    AdvSGrid.RowCount := iRow + 1;
    Query1.Next;
  end;

end;

procedure TFrm_3810.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_3810.FormDestroy(Sender: TObject);
begin
  Frm_3810 := Nil;
end;

procedure TFrm_3810.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_3810.DeleteBitBtnClick(Sender: TObject);
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

procedure TFrm_3810.SelRGClick(Sender: TObject);
begin
   StartBitBtnClick(Self);
end;

procedure TFrm_3810.DBGrid1TitleClick(Column: TColumn);
begin
    if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_3810.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_3810.AdvSGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then // Title부분은 전부 중앙정렬한다.
    HAlign := taCenter
  else begin
  if ACol in [6] then // 숫자값이 들어있는 번 Field의 데이터는 오른쪽으로 정렬한다.
    HAlign := taRightJustify
  else if ACol in [1, 2, 3, 5, 7, 9, 10] then HAlign := taCenter // 순번, 코드류, 날짜, 센터 정렬.

  else // 나머지는 왼쪽으로 정렬한다.
    HAlign := taLeftJustify;
  end;
end;

procedure TFrm_3810.AdvSGridDrawCell(Sender: TObject; ACol, ARow: Integer;
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

procedure TFrm_3810.pCodeEditEnter(Sender: TObject);
begin
  StartBitBtnClick(Self);
end;

procedure TFrm_3810.pLotEditEnter(Sender: TObject);
begin
  StartBitBtnClick(Self);
end;

procedure TFrm_3810.pNameEditEnter(Sender: TObject);
begin
  StartBitBtnClick(Self);
end;

procedure TFrm_3810.pLotEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

procedure TFrm_3810.pCodeEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

procedure TFrm_3810.pNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

procedure TFrm_3810.ConfirmBitBtnClick(Sender: TObject);
var
  XL, WB, Sheet: Variant;
  iRow, iXlRow: Integer;
  bState, IsChecked: Boolean; 

  sSaveFileName: String;
  SaveDlg: TSaveDialog;

  sCode, sName, sLot, sBoxNo, sBigo: String;
  iWgt: Integer;
begin
  // 데이터 유무
  if AdvSGrid.RowCount < 2 then
  begin
    MessageDlg('조회된 데이터가 없습니다.', mtInformation, [mbOk], 0);
    Exit;
  end;

  // 체크박스 선택 여부
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
    MessageDlg('선택된 항목이 없습니다. 엑셀로 재발행할 항목을 선택해주세요.', mtWarning, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('선택한 항목에 대해 엑셀을 재발행(저장) 하시겠습니까?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  SaveDlg := TSaveDialog.Create(Self); //저장 대화상자
  try
    SaveDlg.Title := '엑셀 재발행 저장 위치 선택';
    SaveDlg.DefaultExt := 'xlsx';
    SaveDlg.Filter := 'Excel Files (*.xlsx)|*.xlsx';
    // 파일명 설정: 년월일시분_입고엑셀재발행.xlsx
    SaveDlg.FileName := FormatDateTime('yyyymmddhhnn', Now) + '_입고엑셀재발행.xlsx';
    SaveDlg.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]; // 덮어쓰기 여부

    // 취소 버튼 누르면 종료
    if not SaveDlg.Execute then Exit;
    
    sSaveFileName := SaveDlg.FileName;
  finally
    SaveDlg.Free;
  end;

  // 엑셀 실행
  try
    XL := CreateOleObject('Excel.Application');
  except
    MessageDlg('엑셀이 설치되어 있지 않습니다.', mtError, [mbOk], 0);
    Exit;
  end;

  try
    XL.Visible := False;
    XL.DisplayAlerts := False;

    WB := XL.Workbooks.Add;
    Sheet := WB.ActiveSheet;

    // 시트명
    Sheet.Name := '입고 엑셀 리스트';

    // Sheet 헤더 ---
    Sheet.Cells[1, 1] := '품목코드';
    Sheet.Cells[1, 2] := '품목명';
    Sheet.Cells[1, 3] := 'LOTNO';
    Sheet.Cells[1, 4] := '입고중량';
    Sheet.Cells[1, 5] := 'BOX-NO';
    Sheet.Cells[1, 6] := '비고';

    // 스타일 설정
    Sheet.Range['A1:F1'].Font.Bold := True;
    Sheet.Range['A1:F1'].Interior.Color := clSilver;

    // 텍스트 포맷 설정 (코드, LOT 등 값 그대로 보이게)
    Sheet.Columns[1].NumberFormat := '@';
    Sheet.Columns[3].NumberFormat := '@';

    // 시작 행
    iXlRow := 2;

    for iRow := 1 to AdvSGrid.RowCount - 1 do
    begin
      if AdvSGrid.GetCheckBoxState(2, iRow, bState) and bState then
      begin
        sCode  := AdvSGrid.Cells[3, iRow];
        sName  := AdvSGrid.Cells[4, iRow];
        sLot   := AdvSGrid.Cells[5, iRow];
        iWgt   := StrToIntDef(StringReplace(AdvSGrid.Cells[6, iRow], ',', '', [rfReplaceAll]), 0);
        sBoxNo := AdvSGrid.Cells[7, iRow];
        sBigo  := AdvSGrid.Cells[8, iRow];

        // 엑셀값 입력
        Sheet.Cells[iXlRow, 1] := sCode;
        Sheet.Cells[iXlRow, 2] := sName;
        Sheet.Cells[iXlRow, 3] := sLot;
        Sheet.Cells[iXlRow, 4] := iWgt;
        Sheet.Cells[iXlRow, 5] := sBoxNo;
        Sheet.Cells[iXlRow, 6] := sBigo;

        Inc(iXlRow);
      end;
    end;

    Sheet.Columns.AutoFit; // 컬럼 너비 자동 맞춤

    // 파일로 저장 후 종료
    WB.SaveAs(sSaveFileName);
    XL.Quit;
    XL := Unassigned;

    MessageDlg('엑셀 재발행이 완료되었습니다.', mtInformation, [mbOk], 0);

  except
    on E: Exception do
    begin
      if not VarIsEmpty(XL) then
      begin
        XL.DisplayAlerts := False;
        XL.Quit;
        XL := Unassigned;
      end;
      MessageDlg('엑셀 생성 중 오류가 발생했습니다.' + #13#10 + E.Message, mtError, [mbOk], 0);
    end;
  end;
end;

procedure TFrm_3810.chkAllClick(Sender: TObject);
var
  iRow: Integer;
begin
  if AdvSGrid.RowCount < 2 then Exit;

  AdvSGrid.BeginUpdate;
  try
    for iRow := 1 to AdvSGrid.RowCount - 1 do
    begin
      AdvSGrid.SetCheckBoxState(2, iRow, chkAll.Checked);
    end;
  finally
    AdvSGrid.EndUpdate;
  end;
end;

procedure TFrm_3810.AdvSGridCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  // 헤더 행은 수정 불가
  if ARow = 0 then
  begin
    CanEdit := False;
    Exit;
  end;

  // [수정] 2번(체크박스), 6번, 7번, 8번 컬럼은 편집(클릭/입력) 허용
  if (ACol = 2) or (ACol = 6) or (ACol = 7) or (ACol = 8) then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TFrm_3810.AdvSGridGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol = 6) or (ACol = 7) or (ACol = 8) then
    AEditor := edNormal;
end;

end.

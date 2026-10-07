unit SFrm6910;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, 
  Grids, AdvGrid, BaseGrid; // [중요] AdvGrid 포함

type
  TSFrm_6910 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    MesgStsBar: TStatusBar;
    BtnClose: TBitBtn;
    
    // 컴파일 에러 방지용 (폼에 남아있다면 유지, 없으면 삭제 가능)
    GroupBox1: TGroupBox; 
    GroupBox2: TGroupBox;

    UpdtQuery: TADOQuery;
    DispQuery: TADOQuery;
    
    Label7: TLabel;
    Label1: TLabel;

    LeftPltEd: TMaskEdit;
    RightPltEd: TMaskEdit;
    
    DataSource2: TDataSource;
    pltChkQuery: TADOQuery; // [중요] 중복 검사용 쿼리
    
    BtnRight: TSpeedButton;
    BtnLeft: TSpeedButton;
    BtnSave: TBitBtn;
    
    LeftGrid: TAdvStringGrid;
    RightGrid: TAdvStringGrid;

    // 이벤트 핸들러
    procedure FormCreate(Sender: TObject); 
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnRightClick(Sender: TObject);
    procedure BtnLeftClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);

  private
    { Private declarations }
    procedure InitGrid(Grid: TAdvStringGrid);
    procedure LoadPltData(sPltNo: String; Grid: TAdvStringGrid);
    procedure MoveRow(Source, Dest: TAdvStringGrid);
    function Check_Dup_Key(sTargetPlt, sCode, sLot: String): Boolean;

  public
    { Public declarations }
    procedure Execute(sPltA, sPltB: String);
  end;

var
  SFrm_6910: TSFrm_6910;

implementation

uses DBSet, WinLib, FrmPrompt, FrmError;

{$R *.dfm}

// =============================================================================
// 초기화 및 폼 관리
// =============================================================================
procedure TSFrm_6910.FormCreate(Sender: TObject);
begin
  // 버튼 캡션 설정 (화살표 방향)
  BtnRight.Caption := '▼'; // 아래로 이동 (기존 오른쪽 이동 버튼)
  BtnLeft.Caption  := '▲'; // 위로 이동 (기존 왼쪽 이동 버튼)
  
  // 폰트 크기 조정
  BtnRight.Font.Size := 12;
  BtnLeft.Font.Size  := 12;

  InitGrid(LeftGrid);
  InitGrid(RightGrid);
end;

procedure TSFrm_6910.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSFrm_6910.FormDestroy(Sender: TObject);
begin
  SFrm_6910 := Nil;
end;

procedure TSFrm_6910.BtnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel; // 취소 신호
end;

// =============================================================================
// 사용자 정의 함수
// =============================================================================

procedure TSFrm_6910.InitGrid(Grid: TAdvStringGrid);
begin
  with Grid do
  begin
    RowCount := 2;
    ColCount := 6; // 비고 포함 6개
    FixedRows := 1;
    FixedCols := 0;
    
    // 헤더 설정
    Cells[0, 0] := '품목코드';
    Cells[1, 0] := '품목명';
    Cells[2, 0] := 'LOT-NO';
    Cells[3, 0] := '중량';
    Cells[4, 0] := 'BOX-NO';
    Cells[5, 0] := '비고';

    // 컬럼 너비
    ColWidths[0] := 130;
    ColWidths[1] := 250;
    ColWidths[2] := 100;
    ColWidths[3] := 60;
    ColWidths[4] := 80;
    ColWidths[5] := 150; 
    
    Options := Options + [goRowSelect]; 
    SortSettings.Show := True;
    Look := glSoft; 
  end;
end;

procedure TSFrm_6910.Execute(sPltA, sPltB: String);
begin
  LeftPltEd.Text  := sPltA; 
  RightPltEd.Text := sPltB; 

  LoadPltData(sPltA, LeftGrid);
  LoadPltData(sPltB, RightGrid);

  // ShowModal 호출하지 않음 (메인폼 제어)
end;

procedure TSFrm_6910.LoadPltData(sPltNo: String; Grid: TAdvStringGrid);
var
  iRow: Integer;
  sSql: String;
begin
  Grid.RowCount := 2;
  Grid.ClearRows(1, Grid.RowCount - 1); 

  if Trim(sPltNo) = '' then Exit;

  sSql := ' SELECT SUBK_CODE, MAST_NAME, SUBK_LOTNO, SUBK_WGT, SUBK_BOXNO, SUBK_REMARK ' +
          ' FROM T2MISUBK A (NOLOCK) ' +
          ' LEFT JOIN MIMAST B (NOLOCK) ON A.SUBK_CODE = B.MAST_CODE ' +
          ' WHERE SUBK_PLTNO = ''' + sPltNo + ''' ' +
          ' ORDER BY SUBK_CODE, SUBK_LOTNO ';

  with DispQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sSql);
    Open;

    iRow := 0;
    while not Eof do
    begin
      Inc(iRow);
      if iRow >= Grid.RowCount then Grid.RowCount := iRow + 1;

      Grid.Cells[0, iRow] := FieldByName('SUBK_CODE').AsString;
      Grid.Cells[1, iRow] := FieldByName('MAST_NAME').AsString;
      Grid.Cells[2, iRow] := FieldByName('SUBK_LOTNO').AsString;
      Grid.Cells[3, iRow] := FieldByName('SUBK_WGT').AsString;
      Grid.Cells[4, iRow] := FieldByName('SUBK_BOXNO').AsString;
      Grid.Cells[5, iRow] := FieldByName('SUBK_REMARK').AsString;

      Next;
    end;
  end;
  
  if iRow = 0 then Grid.RowCount := 2; 
end;

procedure TSFrm_6910.MoveRow(Source, Dest: TAdvStringGrid);
var
  S_Row, D_Row, i: Integer;
begin
  if (Source.RowCount <= 1) or (Source.Cells[0, 1] = '') then Exit;
  S_Row := Source.Row;
  if S_Row < 1 then Exit; 

  if (Dest.RowCount = 2) and (Dest.Cells[0, 1] = '') then
     D_Row := 1 
  else
  begin
     D_Row := Dest.RowCount;
     Dest.RowCount := Dest.RowCount + 1;
  end;

  for i := 0 to Source.ColCount - 1 do
    Dest.Cells[i, D_Row] := Source.Cells[i, S_Row];

  Source.RemoveRows(S_Row, 1);

  if Source.RowCount < 2 then
  begin
    Source.RowCount := 2;
    Source.ClearRows(1, 1);
  end;
end;

// [중복 체크] DispQuery 대신 pltChkQuery를 재활용하여 멈춤 현상 방지
function TSFrm_6910.Check_Dup_Key(sTargetPlt, sCode, sLot: String): Boolean;
var
  sSql: String;
begin
  Result := False;
  
  sSql := ' SELECT 1 FROM T2MISUBK (NOLOCK) ' +
          ' WHERE SUBK_PLTNO = ''' + sTargetPlt + ''' ' +
          '   AND SUBK_CODE  = ''' + sCode + ''' ' +
          '   AND SUBK_LOTNO = ''' + sLot + ''' ';

  with pltChkQuery do 
  begin
    Close;
    SQL.Clear;
    SQL.Add(sSql);
    Open;
    
    if RecordCount > 0 then Result := True;
    
    Close; 
  end;
end;

// =============================================================================
// 버튼 이벤트
// =============================================================================

procedure TSFrm_6910.BtnRightClick(Sender: TObject);
begin
  MoveRow(LeftGrid, RightGrid); // 상단 -> 하단
end;

procedure TSFrm_6910.BtnLeftClick(Sender: TObject);
begin
  MoveRow(RightGrid, LeftGrid); // 하단 -> 상단
end;

{
procedure TSFrm_6910.BtnSaveClick(Sender: TObject);
var
  i: Integer;
  sSql: String;
  sCode, sLot, sPltA, sPltB: String;
  sCurrentPltInDB: String;
begin
  sPltA := Trim(LeftPltEd.Text);  
  sPltB := Trim(RightPltEd.Text); 

  // 1. 유효성 검사
  if (sPltA = '') or (sPltB = '') then
  begin
    WinLib_ErrorForm('파렛트 번호가 입력되지 않았습니다.');
    Exit;
  end;

  if sPltA = sPltB then
  begin
    WinLib_ErrorForm('상단과 하단 파렛트 번호가 동일합니다.');
    Exit;
  end;

  // 2. 중복 검사 (PK 충돌 방지)
  // ---------------------------------------------------------------------------
  // (2-1) 상단 그리드 검사
  for i := 1 to LeftGrid.RowCount - 1 do
  begin
    if LeftGrid.Cells[0, i] = '' then Continue;
    sCode := LeftGrid.Cells[0, i];
    sLot  := LeftGrid.Cells[2, i];

    // [DispQuery] DB상 현재 위치 확인
    sSql := ' SELECT SUBK_PLTNO FROM T2MISUBK (NOLOCK) ' +
            ' WHERE SUBK_CODE = ''' + sCode + ''' ' +
            '   AND SUBK_LOTNO = ''' + sLot + ''' ' +
            '   AND SUBK_PLTNO IN (''' + sPltA + ''', ''' + sPltB + ''') ';
    
    DispQuery.Close; DispQuery.SQL.Text := sSql; DispQuery.Open;
    
    if not DispQuery.IsEmpty then
    begin
        sCurrentPltInDB := Trim(DispQuery.FieldByName('SUBK_PLTNO').AsString);
        
        // DB엔 B(하단)에 있는데 화면엔 A(상단)에 있는 경우 -> 이동 대상
        if sCurrentPltInDB = sPltB then 
        begin
          // [pltChkQuery] 목적지(A)에 이미 존재하는지 체크
          if Check_Dup_Key(sPltA, sCode, sLot) then
          begin
            WinLib_ErrorForm('중복 오류: 상단 파렛트[' + sPltA + ']에 이미 동일한 품목이 있습니다.' + #13#10 +
                             '품목: ' + sCode + #13#10 + 'LOT: ' + sLot);
            DispQuery.Close; Exit;
          end;
        end;
    end;
    DispQuery.Close;
  end;

  // (2-2) 하단 그리드 검사
  for i := 1 to RightGrid.RowCount - 1 do
  begin
    if RightGrid.Cells[0, i] = '' then Continue;
    sCode := RightGrid.Cells[0, i];
    sLot  := RightGrid.Cells[2, i];

    sSql := ' SELECT SUBK_PLTNO FROM T2MISUBK (NOLOCK) ' +
            ' WHERE SUBK_CODE = ''' + sCode + ''' ' +
            '   AND SUBK_LOTNO = ''' + sLot + ''' ' +
            '   AND SUBK_PLTNO IN (''' + sPltA + ''', ''' + sPltB + ''') ';
    
    DispQuery.Close; DispQuery.SQL.Text := sSql; DispQuery.Open;
    
    if not DispQuery.IsEmpty then
    begin
        sCurrentPltInDB := Trim(DispQuery.FieldByName('SUBK_PLTNO').AsString);
        
        // DB엔 A(상단)에 있는데 화면엔 B(하단)에 있는 경우 -> 이동 대상
        if sCurrentPltInDB = sPltA then 
        begin
          // [pltChkQuery] 목적지(B)에 이미 존재하는지 체크
          if Check_Dup_Key(sPltB, sCode, sLot) then
          begin
            WinLib_ErrorForm('중복 오류: 하단 파렛트[' + sPltB + ']에 이미 동일한 품목이 있습니다.' + #13#10 +
                             '품목: ' + sCode + #13#10 + 'LOT: ' + sLot);
            DispQuery.Close; Exit;
          end;
        end;
    end;
    DispQuery.Close;
  end;
  // ---------------------------------------------------------------------------

  if not WinLib_ConfirmForm('현재 상태로 저장을 확정하시겠습니까?') then Exit;

  // 3. 실제 업데이트 (UpdtQuery)
  
  // (3-1) 상단 그리드 내용 -> 파렛트 A로 업데이트
  for i := 1 to LeftGrid.RowCount - 1 do
  begin
    if LeftGrid.Cells[0, i] = '' then Continue;
    sCode := LeftGrid.Cells[0, i];
    sLot  := LeftGrid.Cells[2, i];

    sSql := ' UPDATE T2MISUBK SET SUBK_PLTNO = ''' + sPltA + ''' ' +
            ' WHERE SUBK_CODE  = ''' + sCode + ''' ' +
            '   AND SUBK_LOTNO = ''' + sLot + ''' ' +
            '   AND SUBK_PLTNO IN (''' + sPltA + ''', ''' + sPltB + ''') ';
    try
      UpdtQuery.Close; UpdtQuery.SQL.Text := sSql; UpdtQuery.ExecSQL;
    except
    end;
  end;

  // (3-2) 하단 그리드 내용 -> 파렛트 B로 업데이트
  for i := 1 to RightGrid.RowCount - 1 do
  begin
    if RightGrid.Cells[0, i] = '' then Continue;
    sCode := RightGrid.Cells[0, i];
    sLot  := RightGrid.Cells[2, i];

    sSql := ' UPDATE T2MISUBK SET SUBK_PLTNO = ''' + sPltB + ''' ' +
            ' WHERE SUBK_CODE  = ''' + sCode + ''' ' +
            '   AND SUBK_LOTNO = ''' + sLot + ''' ' +
            '   AND SUBK_PLTNO IN (''' + sPltA + ''', ''' + sPltB + ''') ';
    try
      UpdtQuery.Close; UpdtQuery.SQL.Text := sSql; UpdtQuery.ExecSQL;
    except
    end;
  end;

  ShowMessage('저장 완료되었습니다.');
  ModalResult := mrOk; // 성공 신호 (창 닫힘)
end;
}

procedure TSFrm_6910.BtnSaveClick(Sender: TObject);
var
  i: Integer;
  sSql: String;
  sCode, sLot, sPltA, sPltB: String;
begin
  sPltA := Trim(LeftPltEd.Text);  // 상단 파렛트
  sPltB := Trim(RightPltEd.Text); // 하단 파렛트

  // 1. 기본 유효성 검사
  if (sPltA = '') or (sPltB = '') then
  begin
    WinLib_ErrorForm('파렛트 번호가 입력되지 않았습니다.');
    Exit;
  end;

  if sPltA = sPltB then
  begin
    WinLib_ErrorForm('상단과 하단 파렛트 번호가 동일합니다.');
    Exit;
  end;

  // 2. [검증 및 실행] 로직 변경
  // 무조건 Update하는 것이 아니라, "위치가 바뀐 것"만 찾아서 Update 합니다.
  
  if not WinLib_ConfirmForm('현재 상태로 저장을 확정하시겠습니까?') then Exit;

  // ---------------------------------------------------------------------------
  // (Step 1) 상단 그리드(LeftGrid -> sPltA) 처리
  // ---------------------------------------------------------------------------
  for i := 1 to LeftGrid.RowCount - 1 do
  begin
    if LeftGrid.Cells[0, i] = '' then Continue;
    sCode := LeftGrid.Cells[0, i];
    sLot  := LeftGrid.Cells[2, i];

    // 1-1. 이 품목이 이미 DB상에서 A파렛트에 있는지 확인 (있으면 아무것도 안 해도 됨)
    sSql := ' SELECT 1 FROM T2MISUBK (NOLOCK) ' +
            ' WHERE SUBK_PLTNO = ''' + sPltA + ''' ' +  // 목표 위치 A에 있는지 확인
            '   AND SUBK_CODE  = ''' + sCode + ''' ' +
            '   AND SUBK_LOTNO = ''' + sLot  + ''' ';
            
    DispQuery.Close; DispQuery.SQL.Text := sSql; DispQuery.Open;
    
    // 이미 A에 있다면? Pass (정상)
    if not DispQuery.IsEmpty then 
    begin
       DispQuery.Close;
       Continue; 
    end;
    DispQuery.Close;

    // 1-2. A에 없다면, B에 있는지 확인 (B -> A 이동 대상)
    sSql := ' SELECT 1 FROM T2MISUBK (NOLOCK) ' +
            ' WHERE SUBK_PLTNO = ''' + sPltB + ''' ' +  // 현재 위치 B 확인
            '   AND SUBK_CODE  = ''' + sCode + ''' ' +
            '   AND SUBK_LOTNO = ''' + sLot  + ''' ';
            
    DispQuery.Close; DispQuery.SQL.Text := sSql; DispQuery.Open;

    if not DispQuery.IsEmpty then
    begin
       // B에 있는데 A로 옮겨야 함. 
       // 혹시 A에 또 다른 중복 데이터가 있는지 확인 (이미 위 1-1에서 없음을 확인했으므로 안전하지만 이중 체크)
       // 바로 업데이트 실행
       sSql := ' UPDATE T2MISUBK SET SUBK_PLTNO = ''' + sPltA + ''' ' + // A로 변경
               ' WHERE SUBK_PLTNO = ''' + sPltB + ''' ' +               // B에 있는 놈을
               '   AND SUBK_CODE  = ''' + sCode + ''' ' +
               '   AND SUBK_LOTNO = ''' + sLot  + ''' ';
       try
         UpdtQuery.Close; UpdtQuery.SQL.Text := sSql; UpdtQuery.ExecSQL;
       except
         // PK 충돌 등 예외 발생 시 메시지
         WinLib_ErrorForm('이동 중 오류 발생 (상단): ' + sCode);
         Exit;
       end;
    end
    else
    begin
       // A에도 없고 B에도 없다? (삭제된 데이터거나 오류) -> 무시하거나 에러처리
    end;
    DispQuery.Close;
  end;

  // ---------------------------------------------------------------------------
  // (Step 2) 하단 그리드(RightGrid -> sPltB) 처리
  // ---------------------------------------------------------------------------
  for i := 1 to RightGrid.RowCount - 1 do
  begin
    if RightGrid.Cells[0, i] = '' then Continue;
    sCode := RightGrid.Cells[0, i];
    sLot  := RightGrid.Cells[2, i];

    // 2-1. 이 품목이 이미 DB상에서 B파렛트에 있는지 확인 (있으면 Pass)
    sSql := ' SELECT 1 FROM T2MISUBK (NOLOCK) ' +
            ' WHERE SUBK_PLTNO = ''' + sPltB + ''' ' +  // 목표 위치 B에 있는지 확인
            '   AND SUBK_CODE  = ''' + sCode + ''' ' +
            '   AND SUBK_LOTNO = ''' + sLot  + ''' ';
            
    DispQuery.Close; DispQuery.SQL.Text := sSql; DispQuery.Open;
    
    if not DispQuery.IsEmpty then 
    begin
       DispQuery.Close;
       Continue; 
    end;
    DispQuery.Close;

    // 2-2. B에 없다면, A에 있는지 확인 (A -> B 이동 대상)
    sSql := ' SELECT 1 FROM T2MISUBK (NOLOCK) ' +
            ' WHERE SUBK_PLTNO = ''' + sPltA + ''' ' +  // 현재 위치 A 확인
            '   AND SUBK_CODE  = ''' + sCode + ''' ' +
            '   AND SUBK_LOTNO = ''' + sLot  + ''' ';
            
    DispQuery.Close; DispQuery.SQL.Text := sSql; DispQuery.Open;

    if not DispQuery.IsEmpty then
    begin
       // A에 있는데 B로 옮겨야 함.
       sSql := ' UPDATE T2MISUBK SET SUBK_PLTNO = ''' + sPltB + ''' ' + // B로 변경
               ' WHERE SUBK_PLTNO = ''' + sPltA + ''' ' +               // A에 있는 놈을
               '   AND SUBK_CODE  = ''' + sCode + ''' ' +
               '   AND SUBK_LOTNO = ''' + sLot  + ''' ';
       try
         UpdtQuery.Close; UpdtQuery.SQL.Text := sSql; UpdtQuery.ExecSQL;
       except
         WinLib_ErrorForm('이동 중 오류 발생 (하단): ' + sCode);
         Exit;
       end;
    end;
    DispQuery.Close;
  end;

  ShowMessage('저장 완료되었습니다.');
  ModalResult := mrOk; 
end;

end.

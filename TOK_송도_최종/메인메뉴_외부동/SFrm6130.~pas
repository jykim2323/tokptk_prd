unit SFrm6130;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables, Frm1100;

type
  TSFrm_6130 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    MesgStsBar: TStatusBar;
    ExitBitBtn: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    FlagCB: TComboBox;
    Label8: TLabel;
    Label18: TLabel;
    Label99: TLabel;
    InDateDTP: TDateTimePicker;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    LotnoEd: TEdit;
    Label4: TLabel;
    SpecEd: TEdit;
    Label10: TLabel;
    ConfirmBitBtn: TBitBtn;
    InTimeEd: TMaskEdit;
    Label20: TLabel;
    LocaMEd: TMaskEdit;
    Label1: TLabel;
    QtyEd: TMaskEdit;
    RQtyEd: TMaskEdit;
    UpdtQuery: TADOQuery;
    DispQuery: TADOQuery;
    ItemCodeMed: TMaskEdit;
    SB_Search: TSpeedButton;
    Label5: TLabel;
    BigoEd: TEdit;
    Label6: TLabel;
    BoxNoEd: TEdit;
    Label7: TLabel;
    pltNoEd: TMaskEdit;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);    
   
    procedure ItemCodeMedChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SB_SearchClick(Sender: TObject);
   
  private
    { Private declarations }
    function IsNumCheck(var StrData : String): Boolean;
    function IsDotCheck(var StrData : String): Boolean;
    function IsDotCount(var StrData : String): Integer;
    
    procedure Insert_Code;
    procedure Update_Code;  

  public
    { Public declarations }
    Bol_insert : Boolean;
    Bol_Update : Boolean;
    Bol_Delete : Boolean;
  end;

var
  SFrm_6130: TSFrm_6130;
  Var_ItemDiv : String;
  StrQry, StrMsg, Gl_Color : String; 

implementation

uses DBSet, WinLib, FrmPrompt, FrmError, Frm6100, MastDisp;

{$R *.dfm}

function TSFrm_6130.IsNumCheck(var StrData: String): Boolean;
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

function TSFrm_6130.IsDotCheck(var StrData: String): Boolean;
var
  IntPos : Integer;
begin
  Result := False;
  for IntPos := 1 to Length(StrData) Do Begin
    If (StrData[intPos] in [ '.']) Then Begin
       Result := True;
       Exit;
    End;
  End;
end;

function TSFrm_6130.IsDotCount(var StrData: String): Integer;
var
  IntPos, IntCnt : Integer;
begin
  IntCnt := 0;
  IntPos := Pos('.', StrData);
  if IntPos = 0 then Begin Result := 0; Exit; End;
  if IntPos = length(StrData) Then  IntCnt := length(StrData) - IntPos - 1;
  if IntPos < length(StrData) Then  IntCnt := length(StrData) - IntPos;
  Result := IntCnt;
end;

procedure TSFrm_6130.FormCreate(Sender: TObject);
begin
  InDateDTP.Date := Now;      
end;


procedure TSFrm_6130.ItemCodeMedChange(Sender: TObject);
var
  Strcode : String;
begin
  Strcode := ItemCodeMed.Text;
//  While Pos('-', StrCode ) > 0 Do Begin Delete(StrCode, Pos('-', StrCode), 1); End;

  StrQry := ' Select MAST_NAME From MIMAST (NOLOCK) Where MAST_CODE = '''+StrCode+''' ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    SpecEd.Text := FieldByName('MAST_NAME').AsString;
  End;
end;


procedure TSFrm_6130.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg, s_qty, s_rqty : String;
begin
   var_Msg := ' 정말로 확정 합니까.?';
  if Not WinLib_ConfirmForm( var_Msg ) then Exit;

    IF FlagCB.Text = '' Then
  Begin
    WinLib_ErrorForm(' 재고 상태를 입력 하십시요.....' );
    FlagCB.SetFocus;   Exit;
  End;

  IF ItemCodeMed.Text = '' Then
  Begin
    WinLib_ErrorForm(' 품목코드를 입력 하십시요.....' );
    ItemCodeMed.SetFocus;   Exit;
  End;

  IF QtyEd.Text = '' Then
  Begin
    WinLib_ErrorForm(' 재고 중량을 입력 하십시요.....' );
    QtyEd.SetFocus;   Exit;
  End;


  s_qty  := Trim(QtyEd.Text);
  s_rqty := Trim(RQtyEd.Text);

  IF IsNumCheck(s_qty) = False  then
  Begin
    WinLib_ErrorForm(' 재고 중량을 입력 하십시요.....' );
    QtyEd.SetFocus;   Exit;
  End;

  IF IsNumCheck(s_rqty) = False  then
  Begin
    WinLib_ErrorForm(' 예약 중량을 입력 하십시요.....' );
    RQtyEd.SetFocus;   Exit;
  End;

  IF Trim(RQtyEd.Text) = '' Then RQtyEd.Text := '0';
  IF Trim(QtyEd.Text)  = '' Then QtyEd.Text := '0';

  If Bol_Insert Then Insert_Code
  else if Bol_Update Then Update_Code;

end;
{
procedure TSFrm_6130.Insert_Code;
var
  StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrQty, StrRQty, StrRemark, StrBoxNo : String;
  StrPltNo, StrLotNo : String;

  sys_datetime  : string[14];
  s_time : string[6];
  li_cnt : Integer;
begin
  // 1. 필수값 체크 (PLT-NO)
  StrPltNo := Trim(PltNoEd.Text);
  if StrPltNo = '' then
  begin
    WinLib_ErrorForm('파렛트 번호(PLT-NO)는 필수 입력항목입니다.');
    PltNoEd.SetFocus;
    Exit;
  end;

  // 2. 기초 변수 설정
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_time        :=  copy(sys_datetime, 9, 6);

  s_itemcode    := ItemCodeMed.Text;

  // 콤보박스 선택값 반영
  case FlagCB.ItemIndex of
    0: StrFlag := '0';
    1: StrFlag := '1';
    2: StrFlag := 'X';
    3: StrFlag := 'Y';
    4: StrFlag := 'W';
    5: StrFlag := 'E';
    6: StrFlag := 'N';
    7: StrFlag := 'R';
    else StrFlag := '1';
  end;

  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

  StrQty  := QtyEd.Text;
  StrRQty := RQtyEd.Text;
  While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;
  While Pos(',', StrRQty ) > 0 Do Begin Delete(StrRQty, Pos(',', StrRQty), 1); End;
  if Length(StrQty) = 0   then StrQty  := '0';
  if Length(StrRQty) = 0  then StrRQty := '0';

  StrRemark := Trim(BigoEd.Text);
  StrBoxNo  := Trim(BoxnoEd.Text);
  StrLoca   := LocaMEd.Text;
  StrLotNo  := Trim(LotnoEd.Text);

  // ===========================================================================
  // 3. 키값 중복 체크 (PK Violation 방지)
  // ===========================================================================
  StrQry := ' SELECT COUNT(*) FROM T2MISUBK (NOLOCK) ';
  StrQry := StrQry + ' WHERE SUBK_PLTNO = ''' + StrPltNo + ''' ';
  StrQry := StrQry + '   AND SUBK_CODE  = ''' + s_itemcode + ''' ';
  StrQry := StrQry + '   AND SUBK_LOTNO = ''' + StrLotNo + ''' ';

  With UpdtQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    li_cnt := Fields[0].AsInteger;
  End;

  if li_cnt > 0 then
  begin
    WinLib_ErrorForm('이미 동일한 키값(PLT, 품목, LOT)의 데이터가 존재합니다.' + #13#10 +
                     'PLT: ' + StrPltNo + #13#10 +
                     '품목: ' + s_itemcode + #13#10 +
                     'LOT: ' + StrLotNo);
    Exit;
  end;

  // ===========================================================================
  // 4. T2MILSTK (마스터) 업데이트
  // ===========================================================================
  StrQry := ' Update T2MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''',  ';
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''', LSTK_INTIME = '''+s_time+''' ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고위치(T2MILSTK)  ' + StrLoca + ' 상태변경 에러!!!! ');
       Exit;
    End;
  End;

  // ===========================================================================
  // 5. T2MISUBK (상세) INSERT
  // ===========================================================================
  StrQry := ' INSERT INTO T2MISUBK ';
  StrQry := StrQry + ' (  SUBK_CODE,    SUBK_LOCA,     SUBK_FLAG,  SUBK_REMARK, ';
  StrQry := StrQry + '  SUBK_WGT,     SUBK_RWGT,     SUBK_LOTNO,     SUBK_GUBUN,  ';
  StrQry := StrQry + '  SUBK_INDATE,  SUBK_INTIME, SUBK_BOXNO,   SUBK_PLTNO )  ';
  StrQry := StrQry + ' values (   '''+s_itemcode+''',   '''+StrLoca+''',     '''+StrFlag+''', '''+StrRemark+''',';
  StrQry := StrQry + '            convert(Numeric(7,2),'''+StrQty+'''),  convert(Numeric(7,2),'''+StrRQty+'''),      ';
  StrQry := StrQry + '            '''+StrLotNo+''', ''Y'',   '''+StrDate+''', '''+s_time+''', '''+StrBoxNo+''', '''+StrPltNo+''' )  ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고상세(T2MISUBK) 등록 에러!!!! ');
       Exit;
    End;
    MesgStsBar.SimpleText := '재고 등록 완료 (PLT: ' + StrPltNo + ')';
  End;

  ModalResult := mrOk;

  //Close;
end;
}

procedure TSFrm_6130.Insert_Code;
var
  StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrQty, StrRQty, StrRemark, StrBoxNo : String;
  StrPltNo, StrLotNo : String;

  sys_datetime  : string[14];
  s_time : string[6];
  li_cnt : Integer;
begin
  // 1. 필수값 체크 (PLT-NO)
  StrPltNo := Trim(PltNoEd.Text);
  if StrPltNo = '' then
  begin
    WinLib_ErrorForm('파렛트 번호(PLT-NO)는 필수 입력항목입니다.');
    PltNoEd.SetFocus;
    Exit;
  end;

  // 2. 기초 변수 설정
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_time        :=  copy(sys_datetime, 9, 6);    

  s_itemcode    := ItemCodeMed.Text;
  
  // [수정] 콤보박스 선택값 반영 (0~5 순서 적용)
  case FlagCB.ItemIndex of
    0: StrFlag := '0';  // 바닥재고
    1: StrFlag := '1';  // 입고완료 (기본)
    2: StrFlag := 'R';  // 재입고대기
    3: StrFlag := 'N';  // 금지
    else StrFlag := '0'; // 그 외는 정상 재고로 간주
  end;

  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

  StrQty  := QtyEd.Text;
  StrRQty := RQtyEd.Text;
  While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;
  While Pos(',', StrRQty ) > 0 Do Begin Delete(StrRQty, Pos(',', StrRQty), 1); End;
  if Length(StrQty) = 0   then StrQty  := '0';
  if Length(StrRQty) = 0  then StrRQty := '0';

  StrRemark := Trim(BigoEd.Text);
  StrBoxNo  := Trim(BoxnoEd.Text);
  StrLoca   := LocaMEd.Text;
  StrLotNo  := Trim(LotnoEd.Text);
  
  // ===========================================================================
  // 3. 키값 중복 체크
  // ===========================================================================
  StrQry := ' SELECT COUNT(*) FROM T2MISUBK (NOLOCK) ';
  StrQry := StrQry + ' WHERE SUBK_PLTNO = ''' + StrPltNo + ''' ';
  StrQry := StrQry + '   AND SUBK_CODE  = ''' + s_itemcode + ''' ';
  StrQry := StrQry + '   AND SUBK_LOTNO = ''' + StrLotNo + ''' ';

  With UpdtQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    li_cnt := Fields[0].AsInteger;
  End;

  if li_cnt > 0 then
  begin
    WinLib_ErrorForm('이미 동일한 키값(PLT, 품목, LOT)의 데이터가 존재합니다.' + #13#10 +
                     'PLT: ' + StrPltNo + #13#10 +
                     '품목: ' + s_itemcode + #13#10 +
                     'LOT: ' + StrLotNo);
    Exit;
  end;

  // ===========================================================================
  // 4. T2MILSTK (마스터) 업데이트
  // ===========================================================================
  StrQry := ' Update T2MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''',  ';
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''', LSTK_INTIME = '''+s_time+''' ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고위치(T2MILSTK)  ' + StrLoca + ' 상태변경 에러!!!! ');
       Exit;
    End;
  End;

  // ===========================================================================
  // 5. T2MISUBK (상세) INSERT
  // ===========================================================================
  StrQry := ' INSERT INTO T2MISUBK ';
  StrQry := StrQry + ' (  SUBK_CODE,    SUBK_LOCA,      SUBK_FLAG,  SUBK_REMARK, ';
  StrQry := StrQry + '  SUBK_WGT,     SUBK_RWGT,      SUBK_LOTNO,     SUBK_GUBUN,  ';
  StrQry := StrQry + '  SUBK_INDATE,  SUBK_INTIME, SUBK_BOXNO,    SUBK_PLTNO )  '; 
  StrQry := StrQry + ' values (   '''+s_itemcode+''',   '''+StrLoca+''',      '''+StrFlag+''', '''+StrRemark+''',';
  StrQry := StrQry + '            convert(Numeric(7,2),'''+StrQty+'''),  convert(Numeric(7,2),'''+StrRQty+'''),       ';
  StrQry := StrQry + '            '''+StrLotNo+''', ''Y'',   '''+StrDate+''', '''+s_time+''', '''+StrBoxNo+''', '''+StrPltNo+''' )  ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고상세(T2MISUBK) 등록 에러!!!! ');
       Exit;
    End;
    MesgStsBar.SimpleText := '재고 등록 완료 (PLT: ' + StrPltNo + ')';
  End;

  ModalResult := mrOk;
end;

/////////////////////////////////////////////////////////////
////           Update
/////////////////////////////////////////////////////////////

{
procedure TSFrm_6130.Update_Code;
var
  NumRQty, NumQty : Real;
  StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrRQty, StrQty : String;
  StrCode, StrLotno,  StrRemark, StrBoxNo : String;
  StrPltNo : String;

  sys_datetime  : string[14];
  s_time : string[6];
begin
  // 1. 필수값 체크 (PLT-NO)
  StrPltNo := Trim(PltNoEd.Text);
  if StrPltNo = '' then
  begin
    WinLib_ErrorForm('파렛트 번호(PLT-NO)는 필수 입력항목입니다.');
    PltNoEd.SetFocus;
    Exit;
  end;

  StrLoca   := LocaMEd.Text;
  StrCode   := ItemCodeMed.Text;

  case FlagCB.ItemIndex of
    0: StrFlag := '0';
    1: StrFlag := '1';
    2: StrFlag := 'X';
    3: StrFlag := 'Y';
    4: StrFlag := 'W';
    5: StrFlag := 'E';
    6: StrFlag := 'N';
    7: StrFlag := 'R';
    else StrFlag := '1';
  end;
  
  StrLotno  := Trim(LotnoEd.Text);


  StrRemark := Trim(BigoEd.Text);
  StrBoxNo  := Trim(BoxnoEd.Text);

  // 2. 날짜/시간 처리
  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;
  
  sys_datetime := Formatdatetime('yyyymmddhhnnss', now);
  s_time       := copy(sys_datetime, 9, 6);    

  // 3. 수량 처리
  StrRQty   := RQtyEd.Text;
  StrQty    := QtyEd.Text;
  While Pos(',', StrRQTY ) > 0 Do Begin Delete(StrRQTY, Pos(',', StrRqty), 1); End;
  While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;

  if StrQty = '' then StrQty := '0';
  if StrRQty = '' then StrRQty := '0';

  // ===========================================================================
  // 4. T2MISUBK (상세) 업데이트
  // ===========================================================================
  StrQry := ' update T2MISUBK set   ';
  StrQry := StrQry + '          subk_flag         =  '''+StrFlag+''',  ';
  StrQry := StrQry + '          subk_Rwgt         =  convert(Numeric(7,2),'''+StrRQty+'''),  ';
  StrQry := StrQry + '          subk_wgt          =  convert(Numeric(7,2),'''+StrQty +'''),  ';
  StrQry := StrQry + '          subk_remark       =  '''+StrRemark+''', ';
  StrQry := StrQry + '          subk_indate       =  '''+StrDate+''', '; 
  StrQry := StrQry + '          SUBK_BOXNO        =  '''+StrBoxNo+'''    ';

  StrQry := StrQry + ' where  SUBK_PLTNO = '''+StrPltNo+'''    '; 
  StrQry := StrQry + '   and  subk_code  = '''+StrCode+'''      ';
  StrQry := StrQry + '   and  subk_Lotno = '''+StrLotno+'''     '; // 여기가 ''이면 LOT가 없는 데이터 수정
  
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('재고상세(T2MISUBK) 수정 에러!!!! ' + #13#10 + StrQry);
      Exit;
    End;
      MesgStsBar.SimpleText := '재고(' + StrCode + ') 정보를 수정 하였습니다...';
  End;
  Close;

  // ===========================================================================
  // 5. T2MILSTK (마스터) 업데이트
  // ===========================================================================
  StrQry := ' Update T2MILSTK Set ';    
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''', LSTK_INDATE = '''+StrDate+''' ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';
  
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('재고위치(T2MILSTK) 수정 에러!!!! ');
      Exit;
    End;
  End;
  
  ModalResult := mrOk;
end;
}

procedure TSFrm_6130.Update_Code;
var
  NumRQty, NumQty : Real;
  StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrRQty, StrQty : String;
  StrCode, StrLotno,  StrRemark, StrBoxNo : String;
  StrPltNo : String; 

  sys_datetime  : string[14];
  s_time : string[6];
begin
  // 1. 필수값 체크 (PLT-NO)
  StrPltNo := Trim(PltNoEd.Text);
  if StrPltNo = '' then
  begin
    WinLib_ErrorForm('파렛트 번호(PLT-NO)는 필수 입력항목입니다.');
    PltNoEd.SetFocus;
    Exit;
  end;

  StrLoca   := LocaMEd.Text;
  StrCode   := ItemCodeMed.Text;

  // [수정] 콤보박스 선택값 반영 (0~5 순서 적용)

  case FlagCB.ItemIndex of
    0: StrFlag := '0';  // 바닥재고
    1: StrFlag := '1';  // 입고완료 (기본)
    2: StrFlag := 'R';  // 재입고대기
    3: StrFlag := 'N';  // 금지
    else StrFlag := '0'; // 그 외는 정상 재고로 간주
  end;
  
  StrLotno  := Trim(LotnoEd.Text);
  StrRemark := Trim(BigoEd.Text);
  StrBoxNo  := Trim(BoxnoEd.Text);

  // 2. 날짜/시간 처리
  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;
  
  sys_datetime := Formatdatetime('yyyymmddhhnnss', now);
  s_time       := copy(sys_datetime, 9, 6);    

  // 3. 수량 처리
  StrRQty   := RQtyEd.Text;
  StrQty    := QtyEd.Text;
  While Pos(',', StrRQTY ) > 0 Do Begin Delete(StrRQTY, Pos(',', StrRqty), 1); End;
  While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;

  if StrQty = '' then StrQty := '0';
  if StrRQty = '' then StrRQty := '0';

  // ===========================================================================
  // 4. T2MISUBK (상세) 업데이트
  // ===========================================================================
  StrQry := ' update T2MISUBK set   ';
  StrQry := StrQry + '           subk_flag         =  '''+StrFlag+''',  ';
  StrQry := StrQry + '           subk_Rwgt         =  convert(Numeric(7,2),'''+StrRQty+'''),  ';
  StrQry := StrQry + '           subk_wgt          =  convert(Numeric(7,2),'''+StrQty +'''),  ';
  StrQry := StrQry + '           subk_remark       =  '''+StrRemark+''', ';
  StrQry := StrQry + '           subk_indate       =  '''+StrDate+''', '; 
  StrQry := StrQry + '           SUBK_BOXNO        =  '''+StrBoxNo+'''    ';

  StrQry := StrQry + ' where  SUBK_PLTNO = '''+StrPltNo+'''    '; 
  StrQry := StrQry + '   and  subk_code  = '''+StrCode+'''       ';
  StrQry := StrQry + '   and  subk_Lotno = '''+StrLotno+'''      ';
  
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('재고상세(T2MISUBK) 수정 에러!!!! ' + #13#10 + StrQry);
      Exit;
    End;
      MesgStsBar.SimpleText := '재고(' + StrCode + ') 정보를 수정 하였습니다...';
  End;
  Close;

  // ===========================================================================
  // 5. T2MILSTK (마스터) 업데이트
  // ===========================================================================
  StrQry := ' Update T2MILSTK Set ';    
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''', LSTK_INDATE = '''+StrDate+''' ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';
  
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('재고위치(T2MILSTK) 수정 에러!!!! ');
      Exit;
    End;
  End;
  
  ModalResult := mrOk;
end;


procedure TSFrm_6130.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TSFrm_6130.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_6130.FormDestroy(Sender: TObject);
begin
  SFrm_6130 := Nil;
end;  

procedure TSFrm_6130.SB_SearchClick(Sender: TObject);
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

    ItemCodeMed.Text :=  jj_code;
    SpecEd.Text :=  jj_name;
    LotnoEd.SetFocus;
end;

end.


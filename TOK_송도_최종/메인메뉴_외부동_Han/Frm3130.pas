unit Frm3130;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, DB, ADODB, Buttons, Mask, IniFiles,
  QRCtrls, QuickRpt, MMsystem;

type
  TStringArray = array of string;
  TFrm_3130 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    TokStk_db: TADOConnection;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    Query2: TADOQuery;
    Query3: TADOQuery;
    ExitBitBtn: TSpeedButton;
    Timer1: TTimer;
    Query4: TADOQuery;
    StartBitBtn: TSpeedButton;
    GroupBox2: TGroupBox;
    BcrData1Med: TMaskEdit;
    Panel3: TPanel;
    Memo1: TMemo;
    StopCB: TCheckBox;
    UpdtQuery: TADOQuery;
    ChkQuery: TADOQuery;
    Query5: TADOQuery;
    GroupBox3: TGroupBox;
    CodeMed: TMaskEdit;
    NameMed: TMaskEdit;
    Panel2: TPanel;
    Panel4: TPanel;
    LotMed: TMaskEdit;
    Panel5: TPanel;
    QtyMed: TMaskEdit;
    DeleteBitBtn: TSpeedButton;
    AllDeleteBitBtn: TSpeedButton;
    EndBitBtn: TSpeedButton;
    GroupBox1: TGroupBox;
    Panel7: TPanel;
    BcrData2Med: TMaskEdit;
    Panel9: TPanel;
    BigoMed: TMaskEdit;
    Panel10: TPanel;
    Query1SUBK_LOCA: TStringField;
    Query1SUBK_PLTNO: TStringField;
    Query1SUBK_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1SUBK_LOTNO: TStringField;
    Query1SUBK_FLAG: TStringField;
    Query1SUBK_GUBUN: TStringField;
    Query1SUBK_WGT: TBCDField;
    Query1SUBK_RWGT: TBCDField;
    Query1SUBK_BOXNO: TStringField;
    Query1SUBK_REMARK: TStringField;
    Query1SUBK_INDATE: TStringField;
    Query1SUBK_INTIME: TStringField;
    Query1MAST_UNIT: TStringField;
    BoxNoMed: TMaskEdit;
    Panel6: TPanel;
    Timer2: TTimer;


    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    function f_get_sysdate_time1(): String;
    procedure Timer1Timer(Sender: TObject);   



    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);

    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure AllDeleteBitBtnClick(Sender: TObject);
    procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure BcrData1MedKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);

    procedure BcrData2MedKeyPress(Sender: TObject; var Key: Char);
    procedure EndBitBtnClick(Sender: TObject);
    procedure StopCBClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);


  private
    { Private declarations }
    procedure T2Subk_insert;
    //procedure T2MIINPT_insert;
    procedure Pltno_AllDelete;
    procedure Empty_Insert; // 공파렛트 입고
    procedure Cntl_TBDISP_Delete(p_code, p_lotno, p_pltno : String);

  public
    { Public declarations }
    function DataBaseConnect:Boolean;
    function Get_DBString: boolean;
  end;
  function SplitString(const fullString: string; const Delimiter: Char): TStringArray;


var
  Frm_3130: TFrm_3130;

  DBName  : string;
  DbConnect : boolean; //DataBase Connect Status
  DB_NAME : string;
  IniFile: TIniFile;

  jj_id   : String;
  jj_kind : String;

  RowCnt,  i   : Integer;
  s_key, s_item, s_pno, s_bodyno, s_lhseat, s_rhseat, s_lhok, s_rhok : String;
  s_proddt, s_wcode, s_dtime, s_cargbn, s_rrseat, s_rrok : String;
  s_pltno, s_code, s_lotno, s_drumsn, s_reqdts  : String;

  //s_return : String;

  Ps_Bcr1, Ps_Bcr, Ps_scan, Ps_Bcr2: String;

  s_pgubn, s_seq, s_serl, s_bserl, s_bgubun, s_area : String;

  ps_r_ch06: String[16]; ps_r_ch08: String[16];
  ps_w_ch01, ps_w_ch03: String[16];

implementation

uses WinLib, FrmPrompt, FrmError, Convision_u;

{$R *.dfm}     

procedure TFrm_3130.FormCreate(Sender: TObject);
begin
  DbConnect := DataBaseConnect;
  if DbConnect then begin
    // Showmessage('Db Connect Ok');
  end
  else
  begin
    Showmessage('DB Connect Error !!!');
    exit;
  end;

  Ps_Bcr1 := '';  Ps_Bcr := '';
  //s_return := '';
  Memo1.Lines.Clear;
  
  StartBitBtnClick(Self);
end;
 {
procedure TFrm_3130.FormActivate(Sender: TObject);
begin
  BcrData1Med.SetFocus;
end;
  }
  
procedure TFrm_3130.FormActivate(Sender: TObject);
begin
  if BcrData1Med.CanFocus then
    BcrData1Med.SetFocus;
end;

procedure TFrm_3130.StartBitBtnClick(Sender: TObject);
var
  var_sql, ls_date, ls_cnt : String;
  li_cnt, li_cnt1, li_acnt : integer;

  ps_w_ch03: String[16];
  pa_w_ch03: array [1..16] of Char;
  li_i : integer;
begin

  if Trim(BcrData1Med.Text) = '' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    {
    BcrData2Med.Text := '';
    CodeMed.Text     := '';
    NameMed.Text     := '';
    LotMed.Text      := '';
    QtyMed.Text      := '';
    BigoMed.Text     := '';
    BoxNoMed.Text    := '';
    }
    
    Exit;
  end;


  var_Sql := '';
  var_Sql := var_Sql + '  SELECT ';
  var_Sql := var_Sql + '    A.SUBK_LOCA ';
  var_Sql := var_Sql + '    , A.SUBK_PLTNO ';
  var_Sql := var_Sql + '    , A.SUBK_CODE ';
  var_Sql := var_Sql + '    , B.MAST_NAME ';
  var_Sql := var_Sql + '    , B.MAST_UNIT ';
  var_Sql := var_Sql + '    , A.SUBK_LOTNO ';
  var_Sql := var_Sql + '    , A.SUBK_FLAG ';
  var_Sql := var_Sql + '    , A.SUBK_GUBUN ';
  var_Sql := var_Sql + '    , A.SUBK_WGT ';
  var_Sql := var_Sql + '    , A.SUBK_RWGT ';
  var_Sql := var_Sql + '    , A.SUBK_BOXNO ';
  var_Sql := var_Sql + '    , A.SUBK_REMARK ';
  var_Sql := var_Sql + '    , A.SUBK_INDATE ';
  var_Sql := var_Sql + '    , A.SUBK_INTIME ';
  var_Sql := var_Sql + '  FROM T2MISUBK A WITH (NOLOCK) ';
  var_Sql := var_Sql + '  LEFT OUTER JOIN MIMAST B WITH (NOLOCK) ON A.SUBK_CODE = B.MAST_CODE ';
  var_Sql := var_Sql + '  WHERE A.SUBK_PLTNO = '''+ BcrData1Med.Text +''' ';

  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;    
    {
    CodeMed.Text  := Query1.FieldByName('SUBK_CODE').AsString;
    NameMed.Text  := Query1.FieldByName('MAST_NAME').AsString;
    LotMed.Text   := Query1.FieldByName('SUBK_LOTNO').AsString;
    QtyMed.Text   := FormatFloat('#,##0.00', Query1.FieldByName('SUBK_WGT').AsFloat);
    BoxNoMed.Text := Query1.FieldByName('SUBK_BOXNO').AsString;
    BigoMed.Text  := Query1.FieldByName('SUBK_REMARK').AsString;
    }
  End;


  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
  End;

  
  // DBGrid1 RowCount
  var_Sql := '  SELECT COUNT(*) AS Cnt FROM T2MISUBK WITH (NOLOCK) ';
  var_Sql := var_Sql + '  WHERE SUBK_PLTNO = '''+BcrData1Med.Text+''' ';

  with Query4 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    
    li_cnt :=  FieldByName('Cnt').AsInteger;
  End;
End;

procedure TFrm_3130.BcrData1MedKeyPress(Sender: TObject; var Key: Char);
var
  ls_sql, ls_assy : String;
  ps_w_ch03: String[16];
  pa_w_ch03: array [1..16] of Char;
  li_pos : integer;
  var_sql, ls_lhseat, ls_rhseat, ls_rrseat : String;
  ls_lhok, ls_rhok, ls_rrok  : String;
begin

   Memo1.Visible := False;
   Memo1.Lines.Clear;


  if  key <> #13  then   exit; // Enter Key 

  Ps_Bcr1 :=  Trim(BcrData1Med.Text);
  Ps_Bcr  :=  Trim(BcrData1Med.Text);

  var_Sql := '';
  var_Sql := var_Sql + ' SELECT SUBK_LOCA, SUBK_PLTNO from T2MISUBK ';
  var_Sql := var_Sql + ' WHERE ISNULL(SUBK_LOCA,'''') <> '''' AND SUBK_PLTNO = '''' AND SUBK_PLTNO = '''+Ps_Bcr1+''' ';

  With ChkQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;

    if RecordCount <> 0 Then Begin
      Memo1.Visible := True;
      Memo1.Font.Color := ClRed;
      Memo1.Lines.Add(Ps_Bcr1);
      Memo1.Lines.Add('해당 파레트 번호는 이미 창고에 있는 번호입니다.' + #13#10 + '확인 후 다시 입력하세요!');
      BcrData1Med.Text := '';
      BcrData1Med.SetFocus;
      SndPlaySound('ringin.WAV', snd_Async);
      sleep(2000);
      SndPlaySound('num_error.WAV', snd_Async);
      Exit;
    End;
    BcrData1Med.SetFocus;
  End;

  BcrData2Med.SetFocus;

end;
{
procedure TFrm_3130.BcrData2MedKeyPress(Sender: TObject; var Key: Char);
var
  sTxt : TStringList;
  ls_bcr, ls_chk : String;
  ls_date, ls_time : String;
  li_len, li_pos : Integer;
  ls_splitList : TStringArray;

  ls_pltno, ls_sql : String;
  li_cnt : Integer;
begin
   Memo1.Visible := False;
   Memo1.Lines.Clear;

   if key <> #13 then exit;

   Ps_Bcr2 := Trim(BcrData2Med.Text);
   ls_bcr  := Trim(BcrData2Med.Text);

   if Ps_Bcr2 = 'END' Then
   Begin
      BcrData2Med.Text := '';
      BcrData1Med.Text := '';
      CodeMed.Text := '';
      NameMed.Text := '';
      LotMed.Text  := '';
      QtyMed.Text  := '';
      BigoMed.Text := '';
      BoxNoMed.Text   := '';
      
      BcrData1Med.SetFocus;
      Exit;
   End;   

   // ==========================================================================
   //  유효성 검사 (트래킹 및 재고 여부 확인)
   // ==========================================================================
   ls_pltno := Trim(BcrData1Med.Text); // 현재 작업 중인 파레트 번호

   // 파레트 번호가 없으면 진행 불가
   if (ls_pltno = '') and (Ps_Bcr2 <> 'CANCEL') and (Ps_Bcr2 <> 'END') then 
   begin
      Memo1.Visible := True;
      Memo1.Font.Color := ClRed;
      Memo1.Lines.Add('파레트 번호(PLTNO)가 없습니다.');
      BcrData1Med.SetFocus;
      Exit;
   end;

   // 트래킹 구간(T2TBTRAK) 존재 여부 확인
   ls_sql := 'SELECT COUNT(*) FROM T2TBTRAK WITH (NOLOCK) WHERE TRAK_PLTNO = ''' + ls_pltno + '''';
   with ChkQuery do
   begin
     Close;
     SQL.Clear;
     SQL.Add(ls_sql);
     Open;
     li_cnt := Fields[0].AsInteger;
   end;

   if li_cnt > 0 then
   begin
     WinLib_ErrorForm('현재 트래킹(이동) 구간에 위치한 파레트입니다.' + #13#10 +
                      '추가 작업을 진행할 수 없습니다.');
     BcrData2Med.Text := ''; 
     Exit;
   end;

   //  재고(T2MILSTK) 존재 여부 확인
   ls_sql := 'SELECT COUNT(*) FROM T2MILSTK WITH (NOLOCK) WHERE LSTK_PLTNO = ''' + ls_pltno + '''';
   with ChkQuery do
   begin
     Close;
     SQL.Clear;
     SQL.Add(ls_sql);
     Open;
     li_cnt := Fields[0].AsInteger;
   end;

   if li_cnt > 0 then
   begin
     WinLib_ErrorForm('이미 재고로 확정 등록된 파레트입니다.' + #13#10 +
                      '추가 작업을 진행할 수 없습니다.');
     BcrData2Med.Text := '';
     Exit;
   end;
   // ==========================================================================


   BcrData2Med.Text := '';
   CodeMed.Text     := '';
   NameMed.Text     := '';
   LotMed.Text      := '';
   QtyMed.Text      := '';
   BigoMed.Text     := '';
   BoxNoMed.Text    := '';

   if Ps_Bcr2 = '' then
   begin
     Exit;
   end;



   if Ps_Bcr2 = 'EMPTY' Then
   Begin
      BcrData2Med.SetFocus;
      Empty_Insert;
      //BcrData1Med.SetFocus;
      Exit;
   End;

   if Ps_Bcr2 = 'CANCEL' then
   begin
      BcrData2Med.Text := '';
      Pltno_AllDelete;
      exit;
   end;

   // 구분자 처리
   ls_SplitList := SplitString(ls_bcr, '|');

   // 구분자 처리 데이터 6개 필수
   if Length(ls_SplitList) < 6 then
   Begin
      Memo1.Visible := True;
      Memo1.Font.Color := ClRed;
      Memo1.Lines.Add(Ps_Bcr2);
      Memo1.Lines.Add('스캔 바코드 형식 오류입니다 !');
      BcrData2Med.Text := '';
      BcrData2Med.SetFocus;
      SndPlaySound('ringin.WAV', snd_Async);
      sleep(2000);
      SndPlaySound('num_error.WAV', snd_Async);
      Exit;
   End;


   CodeMed.Text  := ls_SplitList[0];
   NameMed.Text  := ls_SplitList[1];
   LotMed.Text   := ls_SplitList[2];
   QtyMed.Text   := ls_SplitList[3];
   BoxNoMed.Text := ls_SplitList[4];
   BigoMed.Text  := ls_SplitList[5];

   T2Subk_insert;

   StartBitBtnClick(Self);

   sleep(1000);
end;
}

procedure TFrm_3130.BcrData2MedKeyPress(Sender: TObject; var Key: Char);
var
  sTxt : TStringList;
  ls_bcr, ls_chk : String;
  ls_date, ls_time : String;
  li_len, li_pos : Integer;
  ls_splitList : TStringArray;

  ls_pltno, ls_sql : String;
  li_cnt : Integer;
begin
   Memo1.Visible := False;
   Memo1.Lines.Clear;

   if key <> #13 then exit;

   Ps_Bcr2 := Trim(BcrData2Med.Text);
   ls_bcr  := Trim(BcrData2Med.Text);

   if Ps_Bcr2 = 'END' Then
   Begin
      BcrData2Med.Text := '';
      BcrData1Med.Text := '';
      CodeMed.Text := '';
      NameMed.Text := '';
      LotMed.Text  := '';
      QtyMed.Text  := '';
      BigoMed.Text := '';
      BoxNoMed.Text    := '';
      
      BcrData1Med.SetFocus;
      Exit;
   End;    

   // ==========================================================================
   //  유효성 검사 (트래킹 및 재고 여부 확인)
   // ==========================================================================
   ls_pltno := Trim(BcrData1Med.Text); // 현재 작업 중인 파레트 번호

   // 파레트 번호가 없으면 진행 불가
   if (ls_pltno = '') and (Ps_Bcr2 <> 'CANCEL') and (Ps_Bcr2 <> 'END') then 
   begin
      Memo1.Visible := True;
      Memo1.Font.Color := ClRed;
      Memo1.Lines.Add('파레트 번호(PLTNO)가 없습니다.');
      BcrData1Med.SetFocus;
      Exit;
   end;

   // 트래킹 구간(T2TBTRAK) 존재 여부 확인
   ls_sql := 'SELECT COUNT(*) FROM T2TBTRAK WITH (NOLOCK) WHERE TRAK_PLTNO = ''' + ls_pltno + '''';
   with ChkQuery do
   begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      li_cnt := Fields[0].AsInteger;
   end;

   if li_cnt > 0 then
   begin
      WinLib_ErrorForm('현재 트래킹(이동) 구간에 위치한 파레트입니다.' + #13#10 +
                       '추가 작업을 진행할 수 없습니다.');
      BcrData2Med.Text := ''; 
      Exit;
   end;

   //  재고(T2MILSTK) 존재 여부 확인
   ls_sql := 'SELECT COUNT(*) FROM T2MILSTK WITH (NOLOCK) WHERE LSTK_PLTNO = ''' + ls_pltno + '''';
   with ChkQuery do
   begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      li_cnt := Fields[0].AsInteger;
   end;

   if li_cnt > 0 then
   begin
      WinLib_ErrorForm('이미 재고로 확정 등록된 파레트입니다.' + #13#10 +
                       '추가 작업을 진행할 수 없습니다.');
      BcrData2Med.Text := '';
      Exit;
   end;
   // ==========================================================================

   // 입력 필드 초기화
   BcrData2Med.Text := '';
   CodeMed.Text     := '';
   NameMed.Text     := '';
   LotMed.Text      := '';
   QtyMed.Text      := '';
   BigoMed.Text     := '';
   BoxNoMed.Text    := '';

   if Ps_Bcr2 = '' then
   begin
      Exit;
   end;

   if Ps_Bcr2 = 'EMPTY' Then
   Begin
      BcrData2Med.SetFocus;
      Empty_Insert;
      Exit;
   End;

   if Ps_Bcr2 = 'CANCEL' then
   begin
      BcrData2Med.Text := '';
      Pltno_AllDelete;
      exit;
   end;

   // ==========================================================================
   // [수정됨] 구분자 파싱 및 데이터 매핑 (3단축 / 6표준)
   // ==========================================================================
   ls_SplitList := SplitString(ls_bcr, '|');
   li_len := Length(ls_SplitList);

   // Case A: 출하처 바코드  양식 (품목코드 | 품목명 | 수량) - 
   if li_len = 3 then
   begin
      CodeMed.Text := ls_SplitList[0]; // 품목코드
      NameMed.Text := ls_SplitList[1]; // 품목명
      QtyMed.Text  := ls_SplitList[2]; // 수량
      
      // 나머지 필드 명시적 비움 (Lot, Box, Bigo)
      LotMed.Text   := '';
      BoxNoMed.Text := '';
      BigoMed.Text  := '';
   end
   // Case B: 6개 표준 양식 (코드 | 명 | LOT | 수량 | BOX | 비고)
   else if li_len >= 6 then
   begin
      CodeMed.Text  := ls_SplitList[0];
      NameMed.Text  := ls_SplitList[1];
      LotMed.Text   := ls_SplitList[2];
      QtyMed.Text   := ls_SplitList[3];
      BoxNoMed.Text := ls_SplitList[4];
      BigoMed.Text  := ls_SplitList[5];
   end
   // Case C: 형식 오류
   else
   begin
      Memo1.Visible := True;
      Memo1.Font.Color := ClRed;
      Memo1.Lines.Add(Ps_Bcr2);
      Memo1.Lines.Add('스캔 바코드 형식 오류입니다 !' + #13#10 + 
                      '[출하처] 코드|명|수량' + #13#10 +
                      '[표 준] 코드|명|LOT|수량|BOX|비고');
      BcrData2Med.Text := '';
      BcrData2Med.SetFocus;
      SndPlaySound('ringin.WAV', snd_Async);
      sleep(2000);
      SndPlaySound('num_error.WAV', snd_Async);
      Exit;
   end;

   // DB 저장 프로시저 호출
   T2Subk_insert;

   // 화면 갱신
   StartBitBtnClick(Self);

   sleep(1000);
end;

procedure TFrm_3130.T2Subk_insert;
var
  StrIndex : String;
  ls_Sql, ls_date, ls_pltno, ls_code, ls_lot, ls_boxno, ls_bigo, ls_rqty, ls_name : String;
  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];
begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_date := copy(sys_datetime, 1, 8);
  s_time := copy(sys_datetime, 9, 6);
  //s_datetime := copy(sys_datetime, 1, 14);
  ls_pltno  := BcrData1Med.Text;

  ls_boxno  := BoxNoMed.Text;  // BOX-NO
  ls_code   := CodeMed.Text;   // 품모코드
  ls_lot    := LotMed.Text;    // LOT NO
  ls_rqty   := QtyMed.Text;    // 수량
  ls_bigo   := BigoMed.Text;   // 비고

  ls_sql := ' ';
  ls_sql := ls_Sql + ' SELECT SUBK_CODE, SUBK_LOTNO, SUBK_PLTNO FROM T2MISUBK WITH (NOLOCK) ';
  ls_sql := ls_Sql + ' WHERE SUBK_CODE = '''+ls_code+''' AND SUBK_LOTNO = '''+ls_lot+''' AND SUBK_PLTNO = '''+ls_pltno+''' ';

  With ChkQuery Do
  Begin
    Close;
    Sql.Clear;
    Sql.Add(ls_sql);
    Open;

    If recordCount <> 0 then
    Begin
       Memo1.Visible := True;
       Memo1.Font.Color := ClRed;
       Memo1.Lines.Add( ls_pltno + ' / ' + ls_code +' / ' + ls_lot);
       Memo1.Lines.Add('[T2MISUBK 등록 에러!]' + #13#10 + '확인 후 다시 하세요!');
       BcrData2Med.Text := '';
       BcrData2Med.SetFocus;
       SndPlaySound('ringin.WAV', snd_Async);
       sleep(2000);
       SndPlaySound('num_error.WAV', snd_Async);
       Exit;
    End;
    BcrData2Med.SetFocus;    
  End;


  While Pos(',', ls_rqty) > 0 Do Begin Delete(ls_rqty, Pos(',', ls_rqty), 1); End;

  ls_sql := ' INSERT INTO T2MISUBK (SUBK_CODE, SUBK_LOTNO, SUBK_FLAG, SUBK_GUBUN ';
  ls_sql := ls_sql + ' , SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK ';              
  //ls_sql := ls_sql + ' , SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO) ';
  ls_sql := ls_sql + ' , SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO, SUBK_USERID) ';
  ls_sql := ls_sql + ' VALUES('''+ls_code+''', '''+ls_lot+''', ''0'', '''' ';
  ls_sql := ls_sql + ' , '''+ls_rqty+''', ''0'', '''+ls_boxno+''', '''+ls_bigo+''' ';
  ls_sql := ls_sql + ' , '''+s_date+''', '''+s_time+''', '''+ls_pltno+''', '''+jj_id+''' ) ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSql;
    Except
      Memo1.Font.Color := ClRed;
      Memo1.Lines.Add(ls_code);
       Memo1.Lines.Add('[T2MISUBK 등록 에러!]' + #13#10 + '확인 후 다시 하세요!');
      BcrData2Med.Text := '';
      BcrData2Med.SetFocus;
      Exit;
    End;
  End;

  BcrData2Med.Text := '';
  BcrData2Med.SetFocus;
end;

{
procedure TFrm_3130.Empty_Insert;
var
  ls_Sql, ls_pltno, ls_code, ls_rqty, ls_unit, ls_name  : String;
  sys_datetime  : string[14];
  ls_date : string[8];
  ls_time : string[6];

begin
  //s_datetime := copy(sys_datetime, 1, 14);
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);  
  ls_date := copy(sys_datetime, 1, 8);
  ls_time := copy(sys_datetime, 9, 6);

  ls_pltno  := BcrData1Med.Text;
  ls_code   := BcrData2Med.Text;
  ls_rqty    := '1';
  ls_unit   := 'EA';

  ls_sql := ' INSERT INTO T2MISUBK (SUBK_CODE, SUBK_LOTNO, SUBK_FLAG, SUBK_GUBUN ';
  ls_sql := ls_sql + ' , SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK ';
  ls_sql := ls_sql + ' , SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO) ';
  ls_sql := ls_sql + ' VALUES( ''EMPTY'', '''', ''0'', '''' ';
  ls_sql := ls_sql + ' , '''+ls_rqty+''', ''0'', '''', '''' ';
  ls_sql := ls_sql + ' , '''+ls_date+''', '''+ls_time+''', '''+ls_pltno+''' ) ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSql;
    Except
        Memo1.Font.Color := ClRed;
        Memo1.Lines.Add(ls_code);
        Memo1.Lines.Add('[EMPTY 등록에러!]' + #13#10 + '확인 후 다시 하세요!');
        BcrData2Med.Text := '';
        BcrData2Med.SetFocus;
       Exit;
    End;
  End;
  BcrData2Med.Text := '';
  BcrData2Med.SetFocus;
end;
}

procedure TFrm_3130.Empty_Insert;
var
  ls_Sql, ls_pltno, ls_code, ls_name : String;
  sys_datetime  : string[14];
  ls_date : string[8];
  ls_time : string[6];
  
  d_cur_qty : Double; // 현재 수량
  d_new_qty : Double; // 업데이트될 수량 (현재+1)
begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);  
  ls_date := copy(sys_datetime, 1, 8);
  ls_time := copy(sys_datetime, 9, 6);

  ls_pltno  := BcrData1Med.Text;
  ls_code   := 'EMPTY';

  // [단계 1] DB에서 현재 해당 파렛트의 EMPTY 수량을 조회함
  ls_sql := ' SELECT ISNULL(SUM(SUBK_WGT), 0) AS CUR_QTY FROM T2MISUBK WITH (NOLOCK) ';
  ls_sql := ls_sql + ' WHERE SUBK_PLTNO = '''+ls_pltno+''' ';
  ls_sql := ls_sql + '   AND SUBK_CODE  = '''+ls_code+''' ';

  with ChkQuery do
  begin
      Close; SQL.Clear; SQL.Add(ls_sql); Open;
      d_cur_qty := FieldByName('CUR_QTY').AsFloat; // 현재 수량 가져오기 (없으면 0)
  end;

  // [단계 2] 수량 1 증가 계산
  d_new_qty := d_cur_qty + 1.0; 


  // =========================================================================
  // [UI 표시] 계산된 수량(d_new_qty)을 화면에 표시
  // =========================================================================
  
  // 1. 공파렛트 품명 조회
  ls_name := '';
  ls_sql := 'SELECT MAST_NAME FROM MIMAST WITH (NOLOCK) WHERE MAST_CODE = ''' + ls_code + '''';
  with ChkQuery do
  begin
      Close; SQL.Clear; SQL.Add(ls_sql); Open;
      if RecordCount > 0 then
          ls_name := FieldByName('MAST_NAME').AsString
      else
          ls_name := '공파렛트';
  end;

  // 2. 화면 값 채우기
  CodeMed.Text := ls_code;
  NameMed.Text := ls_name;
  LotMed.Text  := '';
  
  // [중요] 여기서 계산된 수량을 화면에 뿌려줌 (예: 1.00 -> 2.00 -> 3.00)
  QtyMed.Text  := FormatFloat('0.00', d_new_qty); 
  
  BoxNoMed.Text := '';
  BigoMed.Text := '';
  // =========================================================================


  // [단계 3] DB 저장/수정 (계산된 d_new_qty 사용)
  if d_cur_qty > 0 then
  begin
      // 3-1. 이미 존재하면 업데이트 (계산된 수량으로 덮어쓰기)
      ls_sql := ' UPDATE T2MISUBK SET ';
      ls_sql := ls_sql + '    SUBK_WGT = ''' + FloatToStr(d_new_qty) + ''' '; 
      ls_sql := ls_sql + ' WHERE SUBK_PLTNO = '''+ls_pltno+''' ';
      ls_sql := ls_sql + '   AND SUBK_CODE  = '''+ls_code+''' ';
  end
  else
  begin
      // 3-2. 없으면 신규 등록 (1개)
      ls_sql := ' INSERT INTO T2MISUBK (SUBK_CODE, SUBK_LOTNO, SUBK_FLAG, SUBK_GUBUN ';
      ls_sql := ls_sql + ' , SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK ';
      ls_sql := ls_sql + ' , SUBK_INDATE, SUBK_INTIME, SUBK_PLTNO, SUBK_USERID) ';
      ls_sql := ls_sql + ' VALUES( ''EMPTY'', '''', ''0'', '''' ';
      ls_sql := ls_sql + ' , '''+FloatToStr(d_new_qty)+''', ''0'', '''', '''' ';
      ls_sql := ls_sql + ' , '''+ls_date+''', '''+ls_time+''', '''+ls_pltno+''', '''+jj_id+''' ) ';
  end;

  With UpdtQuery Do Begin
    Try
      Close; SQL.Clear; SQL.Add(ls_sql); ExecSql;
    Except
        Memo1.Font.Color := ClRed;
        Memo1.Lines.Add(ls_code);
        Memo1.Lines.Add('[EMPTY DB처리 에러!]' + #13#10 + '확인 후 다시 하세요!');
        BcrData2Med.Text := '';
        BcrData2Med.SetFocus;
       Exit;
    End;
  End;

  // 마무리
  BcrData2Med.Text := '';
  StartBitBtnClick(Self); // 그리드 갱신
  BcrData2Med.SetFocus;
end;

procedure TFrm_3130.Pltno_AllDelete;
var
  ls_Sql, ls_pltno, ls_code, ls_lot, ls_rqty, ls_name  : String;
begin
  ls_pltno := BcrData1Med.Text;
  ls_code  := CodeMed.Text;
  ls_lot   := LotMed.Text;
  ls_rqty   := QtyMed.Text;

  ls_sql := ' Delete From T2MISUBK ';
  ls_sql := ls_sql + ' Where SUBK_PLTNO = '''+ls_pltno+''' ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSql;
    Except
        Memo1.Font.Color := ClRed;
        Memo1.Lines.Add(ls_code);
        Memo1.Lines.Add('[T2MISUBK 등록에러!]' + #13#10 + '확인 후 다시 하세요!');
        BcrData2Med.SetFocus;
       Exit;
    End;
  End;
  BcrData2Med.Text := '';
  BcrData1Med.Text := '';
  BcrData1Med.SetFocus;

  CodeMed.Text := '';
  NameMed.Text := '';
  LotMed.Text  := '';
  QtyMed.Text  := '';
  BigoMed.Text := '';
  BoxNoMed.Text   := '';
  StartBitBtnClick(Self);
end;

procedure TFrm_3130.DBGrid1TitleClick(Column: TColumn);
begin
   if not DBGrid1.DataSource.DataSet.Active then Exit;
   
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;

   if DBGrid1.DataSource.DataSet.RecordCount > 0 then
   begin
    DBGrid1.SelectedRows.Clear;
    DBGrid1.DataSource.DataSet.First;
    DBGrid1.SelectedRows.CurrentRowSelected := True;
   end;
end;

procedure TFrm_3130.ExitBitBtnClick(Sender: TObject);
begin
   Close;
end;

procedure TFrm_3130.FormDestroy(Sender: TObject);
begin
    Frm_3130 := Nil;
end;

function TFrm_3130.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl WITH (NOLOCK) ';
    With Query3 Do Begin
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

{
procedure TFrm_3130.Timer1Timer(Sender: TObject);
begin
   if StopCb.Checked = True then Exit;
   StartBitBtnClick(Self);

   if BcrData1Med.Text = '' then  BcrData1Med.SetFocus;
end;
}

procedure TFrm_3130.Timer1Timer(Sender: TObject);
begin
   if StopCb.Checked = True then Exit;
   StartBitBtnClick(Self);

   // CanFocus가 True일 때만 SetFocus 실행
   if (BcrData1Med.Text = '') and (BcrData1Med.CanFocus) then  
      BcrData1Med.SetFocus;
end;


procedure TFrm_3130.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
    RowCnt := 0;   i := 0;
end;           

procedure TFrm_3130.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
   Value, ls_lhok, ls_rhok, ls_rrok : String;
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

procedure TFrm_3130.DeleteBitBtnClick(Sender: TObject);
var
   ls_sql, var_Msg : String;
   ls_code, ls_lotno, ls_pltno, ls_flag : String;
   intPos, li_cnt : Integer;
begin
  // 버튼 누르는 순간 일단 조회 멈춤 (안전장치)
  Timer1.Enabled := False;
  StopCb.Checked := True;

  if Dbgrid1.SelectedRows.Count = 0 then
  begin
    WinLib_ErrorForm('삭제할 행을 먼저 선택해주세요.');
    
    // 선택 안 했으면 다시 조회 시작해야 함 (복귀 로직)
    Timer2.Enabled := False; // 복귀 타이머 끔
    StopCb.Checked := False;
    Timer1.Enabled := True;
    Exit;
  end;

  ls_pltno := Query1.FieldByName('SUBK_PLTNO').AsString;
  ls_code  := Trim(CodeMed.Text);
  ls_lotno := Query1.FieldByName('SUBK_LOTNO').AsString;

  // 1. 트래킹 구간(T2TBTRAK) 존재 여부 확인
  ls_sql := 'SELECT COUNT(*) FROM T2TBTRAK WITH (NOLOCK) WHERE TRAK_PLTNO = ''' + ls_pltno + '''';
  with ChkQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    li_cnt := Fields[0].AsInteger;
  end;

  if li_cnt > 0 then
  begin
    WinLib_ErrorForm('현재 트래킹 구간에 위치한 파레트입니다.' + #13#10 +
                     '데이터를 삭제할 수 없습니다.');
    // 에러 시 복귀 로직
    Timer2.Enabled := False;
    StopCb.Checked := False;
    Timer1.Enabled := True;
    Exit;
  end;

  // 2. 재고(T2MILSTK) 존재 여부 확인
  ls_sql := 'SELECT COUNT(*) FROM T2MILSTK WITH (NOLOCK) WHERE LSTK_PLTNO = ''' + ls_pltno + '''';
  with ChkQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    li_cnt := Fields[0].AsInteger;
  end;

  if li_cnt > 0 then
  begin
    WinLib_ErrorForm('이미 재고 등록된 파레트입니다.' + #13#10 +
                     '데이터를 삭제할 수 없습니다.');
    // 에러 시 복귀 로직
    Timer2.Enabled := False;
    StopCb.Checked := False;
    Timer1.Enabled := True;
    Exit;
  end;

  // 3. T2MISUBK 상태값(Flag) 확인
  ls_sql := 'SELECT TOP 1 SUBK_FLAG FROM T2MISUBK WITH (NOLOCK) ' +
            'WHERE SUBK_PLTNO = ''' + ls_pltno + ''' ' +
            '  AND SUBK_FLAG IN (''X'', ''1'', ''Y'', ''M'') ';
  with ChkQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    if RecordCount > 0 then
    begin
      ls_flag := FieldByName('SUBK_FLAG').AsString;

      if ls_flag = 'X' then WinLib_ErrorForm('현재 [입고 대기] 상태입니다.' + #13#10 + '삭제할 수 없습니다.')
      else if ls_flag = '1' then WinLib_ErrorForm('이미 [재고 등록]이 완료된 상태입니다.' + #13#10 + '삭제할 수 없습니다.')
      else if ls_flag = 'Y' then WinLib_ErrorForm('현재 [출고 예약] 상태인 파레트입니다.' + #13#10 + '삭제할 수 없습니다.')
      else if ls_flag = 'M' then WinLib_ErrorForm('현재 [작업 이동 중]인 파레트입니다.' + #13#10 + '삭제할 수 없습니다.');

      // 에러 시 복귀 로직
      Timer2.Enabled := False;
      StopCb.Checked := False;
      Timer1.Enabled := True;
      Exit;
    end;
  end;

  var_Msg := '파레트 번호 : [' + ls_pltno + ']' + #13#10 +
             '품 목 코 드 : [' + ls_code + ']' + #13#10#13#10 +
             '해당 데이터를 삭제하시겠습니까?';

  // 취소 눌렀을 때도 복귀해야 함
  If Not WinLib_ConfirmForm( var_Msg ) Then 
  Begin 
      Timer2.Enabled := False;
      StopCb.Checked := False;
      Timer1.Enabled := True;
      Exit;  
  End;

  // 실제 삭제 로직 수행
  For intPos := 1 To DBGrid1.SelectedRows.Count Do Begin
      With DBGrid1.DataSource.DataSet Do Begin
        If DBGrid1.SelectedRows.Count > 0 Then Begin
           gotobookmark(pointer(DBGrid1.SelectedRows.items[intpos -1]));
           Cntl_TBDISP_Delete(ls_code, ls_lotno, ls_pltno); // 삭제
        End;
      End;
  End;

  // 1. 대기 중이던 복귀 타이머 취소 (이미 작업 끝났으므로)
  Timer2.Enabled := False; 
  
  // 2. 조회 타이머 및 UI 원상복구
  StopCb.Checked := False; 
  Timer1.Enabled := True;  

  // 3. 데이터 갱신 및 입력창 초기화
  Query1.Requery;
  
  BcrData2Med.Text := '';
  //BcrData1Med.Text := '';
  
  CodeMed.Text := '';
  NameMed.Text := '';
  LotMed.Text  := '';
  QtyMed.Text  := '';
  BigoMed.Text := '';
  BoxNoMed.Text    := '';
  
  BcrData1Med.SetFocus;

  // 4. 즉시 재조회 실행
  StartBitBtnClick(Self); 
end;

procedure TFrm_3130.Cntl_TBDISP_Delete(p_code, p_lotno, p_pltno : String);
var
  var_Msg, var_Sql : String;
  intPos : Integer;
begin

  var_sql := ' DELETE FROM T2MISUBK WHERE SUBK_CODE  = '''+p_code+'''  ';
  var_sql := var_sql + '              AND SUBK_LOTNO = '''+p_lotno+''' ';
  var_sql := var_sql + '              AND SUBK_PLTNO = '''+p_pltno+''' ';
  With Query4 Do
  Try
    Close;
    SQL.Clear;
    SQL.Add( var_sql );
    ExecSql;
  Except
    Exit;
  End;

  BcrData2Med.Text := '';
  BcrData2Med.SetFocus;

  StartBitBtnClick(Self);
end;

procedure TFrm_3130.AllDeleteBitBtnClick(Sender: TObject);
var
  ls_sql, var_Msg: String;
  ls_receiptno, ls_drumsn: String;
  ls_pltno, ls_flag : String;
  li_cnt : Integer;
begin
  // 버튼 누르는 순간 일단 조회 멈춤 (안전장치)
  Timer1.Enabled := False;
  StopCb.Checked := True;

  ls_pltno := Trim(BcrData1Med.Text);

  if ls_pltno = '' then
  begin
    WinLib_ErrorForm('삭제할 파레트 번호가 입력되지 않았습니다.');
    
    // 에러 시 복귀 로직
    Timer2.Enabled := False;
    StopCb.Checked := False;
    Timer1.Enabled := True;
    Exit;
  end;

  // 트래킹 구간(T2TBTRAK) 확인
  ls_sql := 'SELECT COUNT(*) FROM T2TBTRAK WITH (NOLOCK) WHERE TRAK_PLTNO = ''' + ls_pltno + '''';
  with ChkQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    li_cnt := Fields[0].AsInteger;
  end;

  if li_cnt > 0 then
  begin
    WinLib_ErrorForm('트래킹 구간에 위치한 파레트입니다.' + #13#10 +
                     '삭제 할 수 없습니다.');
    // 에러 시 복귀 로직
    Timer2.Enabled := False;
    StopCb.Checked := False;
    Timer1.Enabled := True;
    Exit;
  end;

  // 재고(T2MILSTK) 여부 확인
  ls_sql := 'SELECT COUNT(*) FROM T2MILSTK WITH (NOLOCK) WHERE LSTK_PLTNO = ''' + ls_pltno + '''';
  with ChkQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    li_cnt := Fields[0].AsInteger;
  end;

  if li_cnt > 0 then
  begin
    WinLib_ErrorForm('재고 등록된 파레트입니다.' + #13#10 +
                     '삭제할 수 없습니다.');
    // 에러 시 복귀 로직
    Timer2.Enabled := False;
    StopCb.Checked := False;
    Timer1.Enabled := True;
    Exit;
  end;

  // T2MISUBK 상태값(Flag) 확인
  ls_sql := 'SELECT TOP 1 SUBK_FLAG FROM T2MISUBK WITH (NOLOCK) ' +
            'WHERE SUBK_PLTNO = ''' + ls_pltno + ''' ' +
            '  AND SUBK_FLAG IN (''X'', ''1'', ''Y'', ''M'') ';
  with ChkQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;
    
    if RecordCount > 0 then
    begin
      ls_flag := FieldByName('SUBK_FLAG').AsString;

      if ls_flag = 'X' then WinLib_ErrorForm('현재 [입고 대기] 상태입니다.' + #13#10 + '삭제할 수 없습니다.')
      else if ls_flag = '1' then WinLib_ErrorForm('이미 [재고 등록]이 완료된 상태입니다.' + #13#10 + '삭제할 수 없습니다.')
      else if ls_flag = 'Y' then WinLib_ErrorForm('현재 [출고 예약] 상태인 파레트입니다.' + #13#10 + '삭제할 수 없습니다.')
      else if ls_flag = 'M' then WinLib_ErrorForm('현재 [작업 이동 중]인 파레트입니다.' + #13#10 + '삭제할 수 없습니다.');

      // 에러 시 복귀 로직
      Timer2.Enabled := False;
      StopCb.Checked := False;
      Timer1.Enabled := True;
      Exit;
    end;
  end;

  var_Msg := '파레트 번호 [' + ls_pltno + ']의' + #13#10 +
             '모든 데이터를 삭제하시겠습니까?';

  if not WinLib_ConfirmForm(var_Msg) then
  begin
    // 취소 시 복귀 로직
    Timer2.Enabled := False;
    StopCb.Checked := False;
    Timer1.Enabled := True;
    Exit;
  end;

  ls_sql := ' DELETE FROM T2MISUBK WHERE SUBK_PLTNO = ''' + ls_pltno + ''' ';

  try
    with Query4 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    end;
  except
    Memo1.Font.Color := clRed;
    Memo1.Lines.Add('[삭제 오류] 시스템 관리자에게 문의하세요.');
  end;

  // =========================================================
  // [수정된 부분] 작업 완료 후 모니터링 즉시 재개 (Timer2 로직 포함)
  // =========================================================

  // 1. 대기 중이던 복귀 타이머 취소
  Timer2.Enabled := False;
  
  // 2. 조회 타이머 및 UI 원상복구
  StopCb.Checked := False;
  Timer1.Enabled := True;

  // 3. 데이터 갱신 및 입력창 초기화
  Query1.Requery;

  BcrData2Med.Text := '';
  BcrData1Med.Text := '';
  
  CodeMed.Text := '';
  NameMed.Text := '';
  LotMed.Text  := '';
  QtyMed.Text  := '';
  BigoMed.Text := '';
  BoxNoMed.Text    := '';
  
  BcrData1Med.SetFocus;

  // 4. 즉시 재조회 실행
  StartBitBtnClick(Self);
end;

procedure TFrm_3130.EndBitBtnClick(Sender: TObject);
begin
  BcrData2Med.Text := '';
  BcrData1Med.Text := '';

  CodeMed.Text := '';
  NameMed.Text := '';
  LotMed.Text  := '';
  QtyMed.Text  := '';
  BigoMed.Text := '';
  BoxNoMed.Text   := '';

  BcrData1Med.SetFocus;
  exit;
end;

procedure TFrm_3130.DBGrid1CellClick(Column: TColumn);
begin
  if (not Query1.Active) or (Query1.RecordCount = 0) then Exit;
  
  s_pltno := Trim(BcrData1Med.Text);
  CodeMed.Text  := Query1.FieldByName('SUBK_CODE').AsString;
  NameMed.Text  := Query1.FieldByName('MAST_NAME').AsString;
  LotMed.Text   := Query1.FieldByName('SUBK_LOTNO').AsString;
  BoxNoMed.Text := Query1.FieldByName('SUBK_BOXNO').AsString;
  QtyMed.Text   := FormatFloat('#,##0.00', Query1.FieldByName('SUBK_WGT').AsFloat);
  BigoMed.Text  := Query1.FieldByName('SUBK_REMARK').AsString;

  // 조회 타이머 일시 정지 및 복귀 타이머 가동
  if Timer1.Enabled then
  begin
    Timer1.Enabled := False; // 조회 멈춤
    StopCB.Checked := True;  // 화면에 멈췄다고 표시 (체크박스)

    // 복귀 타이머 재시작 (5초 카운트다운 시작) interval 5000
    Timer2.Enabled := False;
    Timer2.Enabled := True; // false 주고 true 줘야 다시 5초로 카운트 시작함..
  end
  else
  begin
    if Timer2.Enabled then
    begin
       Timer2.Enabled := False;
       Timer2.Enabled := True; // false 주고 true 줘야 다시 5초로 카운트 시작함..
    end;
  end;
end;

procedure TFrm_3130.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
{
   SRect := TStringGrid(Sender).CellRect(1, TRxDBGrid(Sender).Row);
   DBGrid1.SelectedRows.CurrentRowSelected := Not DBGrid1.SelectedRows.CurrentRowSelected;
   DBGrid1.Canvas.Brush.Color := clLime;
}
end;

procedure TFrm_3130.MouseWheelHandler(var Message: TMessage);
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

Function TFrm_3130.DataBaseConnect() : boolean;
begin
    if Get_Dbstring = false then begin
        showmessage('\INI\Config.ini Error!');
        result := false;
    end
    else begin
        try
            TokStk_db.Connected := False;
            sleep(200);
            TokStk_db.connectionString := DBName;
//            showmessage('DBName = ' + DBName);
            result := true;
//            Main_db.Connected := True;
        except
            result := false;
        end;
    end;  
end;

function TFrm_3130.Get_DBString: boolean;
var
  StrCon : String;

  sUSER  : String;
  sPASSWORD : String;
  sIdentify : String;
  sDB    : String;
  sIP    : String;
begin
    IniFile:= TIniFile.Create('..\INI\Config.ini');

    sDB := IniFile.ReadString('MSDB', 'DB', '');
    sIP := IniFile.ReadString('MSDB', 'DataSource', '');
    sUSER  := IniFile.ReadString('MSDB', 'USER', '');
    sPASSWORD  := IniFile.ReadString('MSDB', 'PASSWORD', '');
    sIdentify  := 'User ID=' + sUSER   + ';' ;
    If  sPASSWORD <>'' Then Begin
        sIdentify := sIdentify +  'Password='+ sPASSWORD + ';';
    End;
    StrCon      := 'Provider=SQLOLEDB.1;Persist Security Info=false;' + sIdentify +
                   'Initial Catalog='+ sDB+';'+
                   'Data Source=' + sIP;


    //DBName   := IniFile.ReadString('DB Connect', 'STK_DB', 'NOT');
    DBName   :=StrCon;
    IniFile.Destroy;

    if (DBName = 'NOT')   then  result := false
    else result := true; 
end;

procedure TFrm_3130.StopCBClick(Sender: TObject);
begin
  if StopCB.Checked then
    Timer1.Enabled := False
  else
    Timer1.Enabled := True;
end;


function SplitString(const fullString: string; const Delimiter: Char): TStringArray;
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
      n := Length(Result);
      SetLength(Result, n + 1);
      Result[n] := Trim(token);
      token := '';
    end
    else
      token := token + fullString[i];
  end;

  n := Length(Result);
  SetLength(Result, n + 1);
  Result[n] := Trim(token);
end;

procedure TFrm_3130.Timer2Timer(Sender: TObject);
begin
  // 5초 동안 아무 작업이 없었으므로 자동 조회 복귀
  Timer2.Enabled := False; // 나(복귀 타이머)는 이제 꺼짐

  StopCB.Checked := False; // 체크 해제
  Timer1.Enabled := True;  // 조회 타이머 다시 시작

  // 즉시 조회
  StartBitBtnClick(Self);
end;

procedure TFrm_3130.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  Timer1.Enabled := False;
  Timer2.Enabled := False;
  
  Action := caFree;

end;

end.

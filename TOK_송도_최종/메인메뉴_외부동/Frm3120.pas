unit Frm3120;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DBGrids, Db, DBTables,
  DBCtrls, Mask, ScktComp, ADODB, BaseGrid, AdvGrid;

type
  TFrm_3120 = class(TForm)
    HostIpEdit: TEdit;
    Panel19: TPanel;
    Shape2: TShape;
    Label1: TLabel;
    ExitBitBtn: TSpeedButton;
    Query2: TADOQuery;
    MesQuery: TADOQuery;
    GroupBox1: TGroupBox;
    SearchBitBtn: TSpeedButton;
    PLTIDEdit: TEdit;
    Panel7: TPanel;
    LotNo1Edit: TEdit;
    Panel8: TPanel;
    LotNo2Edit: TEdit;
    Label12: TLabel;
    ExecBitBtn: TSpeedButton;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Panel13: TPanel;
    Edit2: TEdit;
    Panel14: TPanel;
    Edit3: TEdit;
    Rb1: TRadioButton;
    Rb2: TRadioButton;
    DataSource1: TDataSource;
    DBGrid2: TDBGrid;
    Query1: TADOQuery;
    MesgStatusBar: TStatusBar;
    Rb3: TRadioButton;
    Query1SUBK_PLTNO: TStringField;
    Query1SUBK_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1SUBK_LOTNO: TStringField;
    Query1SUBK_WGT: TBCDField;
    Query1SUBK_GUBUN: TStringField;
    Query1SUBK_INDATE: TStringField;
    Query1SUBK_INTIME: TStringField;
    Query1SUBK_BOXNO: TStringField;
    Query1SUBK_REMARK: TStringField;
    updtQuery: TADOQuery;
    Query1SUBK_LOCA: TStringField;
    Rb4: TRadioButton;
    Rb5: TRadioButton;
    Rb6: TRadioButton;
    Query1SUBK_FLAG: TStringField;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure ExecBitBtnClick(Sender: TObject);    
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    function f_get_sysdate_time1(): String;
    procedure PLTIDEditKeyPress(Sender: TObject; var Key: Char);
    procedure SearchBitBtnClick(Sender: TObject);
    procedure ItemClear;
    procedure FormActivate(Sender: TObject);
    procedure PLTIDEditChange(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Frm_3120: TFrm_3120;

  sys_datetime  : string[14];
  s_date : String[8];
  s_time : String[6];
  ps_bcr_data, StrMsg, StrDate, StrIndex : String;


  ps_r_ch01: String[16];    ps_r_ch02: String[16];      ps_r_ch03: String[16];


  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;

  s_pltno : String;
  
implementation

Uses  DBSet, WinLib, FrmPrompt, FrmError, MastDisp, Mainmenu_u, FrmProgress;
{$R *.DFM}

procedure TFrm_3120.FormActivate(Sender: TObject);
begin
   PLTIDEdit.SetFocus;
end;  

procedure TFrm_3120.PLTIDEditKeyPress(Sender: TObject; var Key: Char);
var
  ls_sql, StrMsg : String;
  li_cnt   : Integer;
  ls_wsno, ls_sc, f_bk, t_bk : String;
begin
   if key <> #13  then Exit;
   if key = #13 then begin SearchBitBtnClick(self); exit; end;
end;


procedure TFrm_3120.SearchBitBtnClick(Sender: TObject);
var
  ls_sql, StrMsg : String;
  li_cnt   : Integer;
  ls_wsno, ls_sc, f_bk, t_bk : String;
begin
   s_pltno := Trim(PltidEdit.Text);

   // PLT 자릿수 체크
   {
   If Length(Trim(PltidEdit.Text)) <> 4  Then Begin
     WinLib_ErrorForm(' PLT-No.를 4자리 입력 하세요!! ');
     PltidEdit.SetFocus;
     exit;
   End;
   }
   // T2MILSTK 테이블 체크 LSTK_FLAG '0' 이 아닌 경우 NG
   // LSTK_FLAG : 0 비어있음, 1 제품있음, X 입고예약, Y 출고예약, W 이중입고, E 공출고, N사용금지
   ls_sql := ' SELECT COUNT(*) FROM T2MILSTK WITH (NOLOCK) WHERE LSTK_PLTNO = '''+s_pltno+''' AND LSTK_FLAG <> ''0'' ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(ls_sql);
     Open;
     li_cnt := Fields[0].AsInteger;
   End;

   if (li_cnt <> 0)  then
   begin
     ShowMessage(' 동일한 PLT ID 가 재고에 존재 합니다.==>[' + s_pltno + ']' );     //창고내 중복된 것이 존재 합니다.
     ItemClear;
     exit;
   end;

   // T2MISUBK 테이블 체크 ( 없으면 PLTNO 정보가 없음. 있는데 LOCA 정보 있으면 중복 )
   ls_sql := '          SELECT ';
   ls_sql := ls_sql + '   A.SUBK_PLTNO ';
   ls_sql := ls_sql + '   , A.SUBK_LOCA ';
   ls_sql := ls_sql + '   , A.SUBK_CODE ';
   ls_sql := ls_sql + '   , B.MAST_NAME ';
   ls_sql := ls_sql + '   , A.SUBK_LOTNO ';
   ls_sql := ls_sql + '   , A.SUBK_WGT ';
   ls_sql := ls_sql + '   , A.SUBK_BOXNO ';
   ls_sql := ls_sql + '   , A.SUBK_REMARK ';
   ls_sql := ls_sql + '   , A.SUBK_GUBUN ';
   ls_sql := ls_sql + '   , A.SUBK_INDATE ';
   ls_sql := ls_sql + '   , A.SUBK_INTIME ';
   ls_sql := ls_sql + '   , A.SUBK_FLAG ';   
   ls_sql := ls_sql + ' FROM T2MISUBK A WITH (NOLOCK) ';
   ls_sql := ls_sql + ' LEFT OUTER JOIN MIMAST B WITH (NOLOCK) ON A.SUBK_CODE = B.MAST_CODE ';
   ls_sql := ls_sql + ' WHERE SUBK_PLTNO = '''+s_pltno+''' ';

   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(ls_sql);
   Query1.Open;
   Query1.First;

   if (Query1.RecordCount = 0) then
   begin
     ShowMessage('등록된 팔레트 정보가 없습니다!!=>[' + s_pltno + ']' );
     ItemClear;
     exit;
   end;

   // SUBK_LOCA 정보가 있으면 중복 처리 예외
   if (Trim(Query1.FieldByName('SUBK_LOCA').AsString) <> '') then
   begin
     ShowMessage('이미 입고 처리중인 팔레트 정보입니다!!=>[' + s_pltno + ']' );
     ItemClear;
     exit;
   end;

   ls_sql := ' SELECT COUNT(*) FROM T2TBTRAK WITH (NOLOCK) WHERE TRAK_PLTNO = ''' + s_pltno + ''' ';

   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(ls_sql);
     Open;

     if Fields[0].AsInteger > 0 Then Begin
       StrMsg := '해당 PLT-NO [' + s_pltno + ']에 트랙킹 데이터가 존재 합니다.' + #13#10 +
                        '확인 후 다시 시도하세요!';
       ItemClear;
       WinLib_ErrorForm( StrMsg );
       Exit;
     End;
   End;

   if (Rb1.Checked = True) then  begin  ls_wsno := '01';  ls_sc := '1'; f_bk := '1';  t_bk := '2';  end
   else if (Rb2.Checked = True) then   begin ls_wsno := '09'; ls_sc := '2'; f_bk := '3';  t_bk := '4';  end
   else if (Rb3.Checked = True) then   begin ls_wsno := '17'; ls_sc := '3'; f_bk := '5';  t_bk := '6';  end
   else Exit;

   // 구간 검사
   ls_sql := ' Select Trak_index From T2TBTRAK (NOLOCK) Where TRAK_NO = '''+ls_wsno+'''  ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(ls_sql);
     Open;

     if Length(Trim(FieldByName('Trak_index').AsString)) <> 0 Then Begin
       StrMsg := ls_wsno +' 구간 컨베어에 데이터가 존재합니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       ItemClear;       
       WinLib_ErrorForm( StrMsg );
       Exit;
     End;
   End;
end;  

procedure TFrm_3120.ExecBitBtnClick(Sender: TObject); // 김준영 수정
var
{
  IntPos : Integer;

  ls_sql, ls_high, StrMsg, ls_trakno, ls_gubun, ls_date, ls_plt, ls_hogi, ls_loca, ls_index : String;
  li_syhg, li_cnt : Integer;
  ls_sc, f_bk, t_bk, ls_wsno : String;

  StrItnbr, StrLotno, StrQty, StrBoxNo, StrRemark, StrCode : String;
  StrQry, var_Sql : string;
  StrTime, StrDate : String;
}
  IntPos : Integer;

  StrIndex, StrQty, StrQry, var_Sql, ls_date, ls_plt  : String;
  StrDate, StrTime, Strloca, s_gubun, StrRemark, StrCode, StrBoxNo, StrIseq : String;
  StrItnbr, StrLotno : String;

  StrSubKFlag : String;


  ls_sc, f_bk, t_bk, ls_wsno, ls_level, ls_gubun, ls_loca, ls_high, ls_iseq, ls_rflag  : String;
  Empty_Cnt : Integer;

  mps_r_ch01: String[16];  mps_r_ch02: String[16];  mps_r_ch03: String[16];
  mps_r_ch04: String[16];  mps_r_ch05: String[16];  mps_r_ch06: String[16];
  mps_s_ch01: String[16];  

begin
   /// 프로세스 정리
   /// 수동입고 등록시
   /// 1. 각 입고 고정 BCR 구간 제품 유 체크 -> Select CVC1_CH01 From T2TBCVC1 (NOLOCK) Where CVC1_SR = 'R' -> 0101000001100001 (2번째 자리)
   /// 2. 보낼 LOCA 조회
   /// 3. 해당 T2MILSTK 상태값 입고중 상태로 변경 -> T2MILSTK Set LSTK_FLAG = ''X''  입고중  X, 재고 1, 출고예약 Y, 이동중 M
   /// 3-1.    T2MILSTK 의 LSTK_PLTNO에 PLTNO UPDATE  해야하는지 T2MISUBK의 SUBK_LOCA에 LOCA UPDATE 해야하는지 ?
   /// 4. Index 생성
   /// 5. T2MIINPT INSERT  INPT_GUBUN = 'Y'        입고 'Y', 미입고 'N' ('N'으로 update하거나 insert하는 곳은 확인되지 않음)
   ///                     INPT_JOB_FLAG = '0'     대기 '0', 완료 'C'
   /// 6. T2TBTRAK UPDATE TRAK_GUBUN = 'I'         입고 'I', 출고 'O', 재입고 'R' 

   
   //입고 스테이션 선택
   if (Rb1.Checked = False) and (Rb2.Checked = False) and (Rb3.Checked = False) and (Rb4.Checked = False) and (Rb5.Checked = False) and (Rb6.Checked = False) then
   begin
     ShowMessage(' 입고할 컨베어 스테이션을 선택 하세요!!' );
     exit;
   end;

   // PLTIDEdit.Text 빈값인지 체크
   if PLTIDEdit.Text = '' then
   begin
     ShowMessage(' PLT-NO를 입력 하세요!!' );
     PLTIDEdit.SetFocus;
     exit;

   end;

   if not Query1.Active then
   begin
     ShowMessage('PLT-NO를 먼저 조회해주세요!');
     PLTIDEdit.SetFocus;
     Exit;
   end;

   // 공파렛 체크
   {
   StrCode := '';
   Query1.First;
   while not Query1.Eof do
   begin
     IF(Query1.FieldByName('SUBK_CODE').AsString = 'EMPTY') then begin StrCode := 'EMPTY'; Break; end;
     Query1.next;
   end;
   }

   // PLTNO 유효성 체크
   {
   If Length(Trim(PLTIDEdit.Text)) <> 4  Then Begin
     WinLib_ErrorForm(' PLT-No.를 입력 하세요!! ');
     PltidEdit.SetFocus;
     exit;
   End;
   }
   
   if (Rb1.Checked = True) then begin ls_wsno := '01'; ls_sc := '1'; f_bk := '1'; t_bk := '2'; end
   else if (Rb2.Checked = True) then begin ls_wsno := '09'; ls_sc := '2'; f_bk := '3'; t_bk := '4'; end
   else if (Rb3.Checked = True) then begin ls_wsno := '17'; ls_sc := '3'; f_bk := '5'; t_bk := '6'; end
   else if (Rb4.Checked = True) then begin ls_wsno := '05'; ls_sc := '1'; f_bk := '1'; t_bk := '2'; end
   else if (Rb5.Checked = True) then begin ls_wsno := '13'; ls_sc := '2'; f_bk := '3'; t_bk := '4'; end
   else if (Rb6.Checked = True) then begin ls_wsno := '21'; ls_sc := '3'; f_bk := '5'; t_bk := '6'; end
   else Exit;

   StrQry := ' Select Trak_index From T2TBTRAK (NOLOCK) Where TRAK_NO = '''+ls_wsno+'''  ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(StrQry);
     Open;

     if Length(Trim(FieldByName('Trak_index').AsString)) <> 0 Then Begin
       StrMsg := ls_wsno +' 구간 컨베어에 데이터가 존재합니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     End;
   End;

   StrQry := ' Select CVC1_CH01, CVC1_CH02 From T2TBCVC1 (NOLOCK) Where CVC1_SR = ''R'' ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(StrQry);
     Open;
     mps_r_ch01 := FieldByName('CVC1_CH01').AsString;  mps_r_ch02 := FieldByName('CVC1_CH02').AsString;
   End;

   StrQry := ' Select CVC2_CH01, CVC2_CH02  From T2TBCVC2 (NOLOCK) Where CVC2_SR = ''R'' ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(StrQry);
     Open;
     mps_r_ch03 := FieldByName('CVC2_CH01').AsString;  mps_r_ch04 := FieldByName('CVC2_CH02').AsString;
   End;

   StrQry := ' Select CVC3_CH01, CVC3_CH02  From T2TBCVC3 (NOLOCK) Where CVC3_SR = ''R'' ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(StrQry);
     Open;
     mps_r_ch05 := FieldByName('CVC3_CH01').AsString;  mps_r_ch06 := FieldByName('CVC3_CH02').AsString;
   End;

   StrQry := ' Select CVC1_CH02 From T2TBCVC1 (NOLOCK) Where CVC1_SR = ''S'' ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(StrQry);
     Open;
     mps_s_ch01 := FieldByName('CVC1_CH02').AsString;
   End;

   If  (ls_wsno = '01')  then
   Begin
     // 제품 유
     if (Copy(mps_r_ch01,1,1) = '0') then begin
       StrMsg := '01구간 해당 구간 제품 유 상태가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 입고 모드 유무
     if (Copy(mps_r_ch01,10,1) = '0') then begin
       StrMsg := '01구간 해당 구간 입고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 이동지시 유무
     if (Copy(mps_s_ch01,1,1) = '1')  then begin
       StrMsg := '01구간 해당 구간 입고이동 지시 중입니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;
   End;

   If  (ls_wsno = '05')  then
   Begin
     // 제품 유
     if (Copy(mps_r_ch01,5,1) = '0') then begin
       StrMsg := '05구간 해당 구간 제품 유 상태가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;
     // 입고 모드 유무
     if (Copy(mps_r_ch01,11,1) = '0') then begin
       StrMsg := '05구간 해당 구간 입고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 이동지시 유무
     if (Copy(mps_s_ch01,2,1) = '1')  then begin
       StrMsg := '05구간 해당 구간 입고이동 지시 중입니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;
   End;

   StrQry := ' Select CVC2_CH02 From T2TBCVC2 (NOLOCK) Where CVC2_SR = ''S'' ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(StrQry);
     Open;
     mps_s_ch01 := FieldByName('CVC2_CH02').AsString;
   End;

   If  (ls_wsno = '09')  then
   Begin
     // 제품 유무
     if (Copy(mps_r_ch03,1,1) = '0') then begin
       StrMsg := '09구간 해당 구간 제품 유 상태가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 입고 모드 유무
     if (Copy(mps_r_ch03,10,1) = '0') then begin
       StrMsg := '09구간 해당 구간 입고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 이동지시 유무
     if (Copy(mps_s_ch01,1,1) = '1')  then begin
       StrMsg := '09구간 해당 구간 입고이동 지시 중입니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;
   End;

   If (ls_wsno = '13')  then
   Begin
     // 제품 유무
     if (Copy(mps_r_ch03,5,1) = '0') then begin
       StrMsg := '13구간 해당 구간 제품 유 상태가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 입고 모드 유무
     if (Copy(mps_r_ch03,11,1) = '0') then begin
       StrMsg := '13구간 해당 구간 입고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 이동지시 유무
     if (Copy(mps_s_ch01,2,1) = '1')  then begin
       StrMsg := '13구간 해당 구간 입고이동 지시 중입니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;
   End;

   StrQry := ' Select CVC3_CH02 From T2TBCVC3 (NOLOCK) Where CVC3_SR = ''S'' ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(StrQry);
     Open;
     mps_s_ch01 := FieldByName('CVC3_CH02').AsString;
   End;

   If  (ls_wsno = '17')  then
   Begin
     // 17구간 제품 유무
     if (Copy(mps_r_ch05,1,1) = '0') then begin
       StrMsg := '17구간 해당 구간 제품 유 상태가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 17구간 입고모드 유무
     if (Copy(mps_r_ch05,10,1) = '0') then begin
       StrMsg := '17구간 해당 구간 입고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 17구간 이동지시 유무
     if (Copy(mps_s_ch01,1,1) = '1')  then begin
       StrMsg := '17구간 해당 구간 입고이동 지시 중입니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;
   End;

   If (ls_wsno = '21')  then
   Begin
     // 제품 유무
     if (Copy(mps_r_ch05,5,1) = '0') then begin
       StrMsg := '21구간 해당 구간 제품 유 상태가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 입고모드 유무
     if (Copy(mps_r_ch05,11,1) = '0') then begin
       StrMsg := '21구간 해당 구간 입고모드가 아닙니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;

     // 이동지시 유무
     if (Copy(mps_s_ch01,2,1) = '1')  then begin
       StrMsg := '21구간 해당 구간 입고이동 지시 중입니다....' + #13#10 + '확인 한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
     end;
   End;

   ls_gubun := 'I';

   StrMsg := StrIndex + ' 제품을 입고 예약 하시겠습니까?...';
   if Not WinLib_ConfirmForm( StrMsg ) then Exit;   


   {   20251031 주석
   // To. LOCA 조회
   StrQry := ' Select * From  T2MILSTK (NOLOCK) Where (LSTK_FLAG = ''0'') ';
   StrQry := StrQry + ' And LSTK_BK  BETWEEN '''+f_bk+''' AND '''+t_bk+''' ';
   StrQry := StrQry + '  ORDER BY LSTK_LV, LSTK_BY, LSTK_BK ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(StrQry);
     Open;

   if RecordCount = 0  then
   begin
     StrMsg := 'SC= '+ ls_sc  + '호기  입고할 랙이 없습니다..' + #13#10 + ' 확인한 후 다시 하십시요!!!';
     WinLib_ErrorForm( StrMsg );
     Exit;
   end;
     ls_loca := FieldByName('lstk_loca').AsString;
   End;

   //ls_sql := ' Update T2MILSTK Set LSTK_FLAG = ''X''  Where LSTK_LOCA = '''+ls_loca+''' ';
   StrQry := ' Update T2MILSTK Set LSTK_FLAG = ''X'', LSTK_PLTNO = '''+s_pltno+'''  Where LSTK_LOCA = '''+ls_loca+''' ';   // 김준영 추가

   Try
     With UpdtQuery Do Begin
       Close;
       SQL.Clear;
       SQL.Add(StrQry);
       ExecSql;
     End;
   Except
     Showmessage('Update Error = ' + StrQry);  Exit;
   End;
   }

   // INDEX 생성
   sys_datetime  :=  f_get_sysdate_time1();
   StrDate       :=  copy(sys_datetime, 1, 8);
   StrTime       :=  copy(sys_datetime, 9, 6);

   StrQry := ' Select STAT_DATE, STAT_IINDX  From T2TBSTAT (NOLOCK) Where STAT_PSWD = ''JPLS'' ';
   Query2.Close;
   Query2.SQL.Clear;
   Query2.SQL.Add(StrQry);
   Query2.Open;

   ls_date  :=  Query2.FieldByName('Stat_DATE').AsString;
   ls_high  := Copy(ls_loca,4,1);

   //if (StrCode = 'EMPTY') then ls_plt := 'E' else ls_plt := 'I';
   ls_plt := 'I';  // 입고는 I로 통일

   if  (ls_date = StrDate)  then
   begin
     StrIndex := StrDate + ls_plt + Format('%4.4d', [Query2.FieldByName('Stat_IINDX').AsInteger]);
     if Query2.FieldByName('STAT_IINDX').AsInteger >= 9999 Then Begin
           StrQry := ' Update T2TBSTAT Set STAT_IINDX = convert(Numeric,''1'') ';
     End Else Begin
         StrQry := ' Update T2TBSTAT Set STAT_IINDX = STAT_IINDX + 1 ';
     End;
     StrQry := StrQry + ' Where STAT_PSWD = ''JPLS'' ';
   end
   else
   begin
     StrIndex := StrDate + ls_plt + Format('%4.4d', [1]);
     StrQry := ' Update T2TBSTAT Set STAT_DATE = '''+StrDate+''', STAT_IINDX = convert(Numeric,''2'') ';
     StrQry := StrQry + ' Where STAT_PSWD = ''JPLS'' ';
   end;

   UpdtQuery.Close;
   UpdtQuery.SQL.Clear;
   UpdtQuery.SQL.Add(StrQry);
   UpdtQuery.ExecSQL;

   Query1.First;
   while not Query1.Eof do
   begin
     StrItnbr  := Query1.FieldByName('SUBK_CODE').AsString;
     StrLotno  := Query1.FieldByName('SUBK_LOTNO').AsString;
     StrQty    := Query1.FieldByName('SUBK_WGT').AsString;
     StrBoxNo  := Query1.FieldByName('SUBK_BOXNO').AsString;
     StrRemark := Query1.FieldByName('SUBK_REMARK').AsString;
     StrSubKFlag := Query1.FieldByName('SUBK_FLAG').AsString;
     
     // , 제거
     while Pos(',', StrQty) > 0 do Delete(StrQty, Pos(',', StrQty), 1);

     StrQry := ' Select * from T2MIINPT (NOLOCK) Where INPT_INDATE = '''+StrDate+''' ';
     StrQry := StrQry + '   And INPT_INDEX     =  '''+StrIndex+'''  ';
     StrQry := StrQry + '   And INPT_CODE      =  '''+StrItnbr+'''  ';
     StrQry := StrQry + '   And INPT_LOTNO     =  '''+StrLotno+'''  ';
     StrQry := StrQry + '   And INPT_JOB_FLAG  =  ''0''           ';

     Query2.Close;
     Query2.SQL.Clear;
     Query2.SQL.Add(StrQry);
     Query2.Open;

     // INPT_GUBUN  - 입고 : Y , 미입고 N
     // INPT_JOB_FLAG - 대기 0, 완료 C
     if(StrSubKFlag = 'R') then
     begin
       ls_rflag := 'R';
     end
     else
     begin
       ls_rflag := 'N'
     end;
     if Query2.RecordCount = 0 then
     begin
       StrQry := ' Insert Into T2MIINPT(INPT_INDEX, INPT_CODE, INPT_GUBUN, INPT_HOGI, INPT_PLTNO, ';
       StrQry := StrQry + '    INPT_WEIGHT, INPT_LOCA, INPT_LOTNO, INPT_STATION, INPT_BOXNO, INPT_REMARK, ';
       StrQry := StrQry + '    INPT_INDATE, INPT_STIME, INPT_ETIME, INPT_RFLAG, INPT_JOB_FLAG, INPT_ID )';
       StrQry := StrQry + ' Values('''+StrIndex+''', '''+StrItnbr+''', ''Y'', '''+ls_sc+''', '''+s_pltno+''', ';
       StrQry := StrQry + '         Convert(Numeric(7,2),'''+StrQty+'''), '''+ls_loca+''', ';
       StrQry := StrQry + '        '''+StrLotno+''', '''+ls_wsno+''', '''+StrBoxNo+''', '''+StrRemark+''', ';
       //StrQry := StrQry + '        '''+StrDate+''', '''+StrTime+''',  '''', ''N'',  ''0'', '''+jj_id+''') ';
       StrQry := StrQry + '        '''+StrDate+''', '''+StrTime+''',  '''', '''+ls_rflag+''',  ''0'', '''+jj_id+''') ';
     end
     else
     begin
       StrQry := ' Update T2MIINPT Set INPT_WEIGHT = ISNULL(INPT_WEIGHT,0) + convert(Numeric(7,2),'''+StrQty+''') ';
       StrQry := StrQry + ' Where INPT_INDEX = '''+StrIndex+''' ';
       StrQry := StrQry + '   And INPT_CODE  = '''+StrItnbr+''' And INPT_LOTNO = '''+StrLotno+''' ';
       StrQry := StrQry + '   And INPT_JOB_FLAG = ''0'' AND INPT_PLTNO = '''+s_pltno+''' ';
     end;

     try
       UpdtQuery.Close;
       UpdtQuery.SQL.Clear;
       UpdtQuery.SQL.Add(StrQry);
       UpdtQuery.ExecSql;
     except
       ShowMessage('Insert Error = ' + StrQry);
       Exit;
     end;

     Query1.Next;
   end;

   { 20251031
   // UPDATE T2MISUBK SUBK_FLAG = 'X'로 상태 변경
   With UpdtQuery Do
   Begin
     Try
       var_Sql := ' Update T2MISUBK SET ';
       var_Sql := var_Sql + ' SUBK_FLAG = ''X'' '; // 입고 예약 상태로 상태 변경
       var_Sql := var_Sql + ' WHERE SUBK_PLTNO = '''+s_pltno+''' ';
       Close;
       SQL.CLEAR;
       SQL.Add(var_Sql);
       ExecSql;
     Except
       Showmessage('Insert Error = ' + var_sql);
       Exit;
     End;
   End;
   }

   // 재입고 판별 해야함...
   //  TRAK_GUBUN = 'I'   입고 'I', 출고 'O', 재입고 'R'
   With UpdtQuery Do
   Begin
     Try
       var_Sql := ' Update T2TBTRAK Set ';
       var_Sql := var_Sql + ' TRAK_INDEX = '''+StrIndex+''',   TRAK_GUBUN = ''I'', ';
       var_Sql := var_Sql + ' TRAK_LOCA  = '''+ls_loca+''',    TRAK_HIGH = '''+ls_high+''', TRAK_FLAG = '''',   ';
       var_Sql := var_Sql + ' TRAK_DATE = '''+StrDate+''',     TRAK_TIME = '''+StrTime+''', TRAK_PLTNO = '''+s_pltno+''' ';
       var_Sql := var_Sql + ' Where TRAK_NO = '''+ls_wsno+''' ';
       Close;
       SQL.Clear;
       SQL.Add(var_Sql);
       ExecSql;
       ShowMessage('수동입고 완료');
     Except
       Showmessage('Insert Error = ' + var_sql);
       Exit;
     End;
   End;

   PLTIDEdit.Text := '';
   Query1.Close;
end;


procedure TFrm_3120.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_3120.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_3120.FormDestroy(Sender: TObject);
begin
    Frm_3120 := Nil;
end;

procedure TFrm_3120.ItemClear;
begin
  PLTIDEdit.Text := '';
  Query1.Close;
end;

function TFrm_3120.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120) from dumm_tbl (NOLOCK) ';
    With Query2 Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      ls_date    := Fields[0].AsString;
    End;

    ls := trim(ls_date);
    ls_date := Copy(ls, 1, 4)  + Copy(ls, 6, 2)  + Copy(ls, 9, 2) + Copy(ls, 12, 2) + Copy(ls, 15, 2) + Copy(ls, 18, 2);

    Result :=  ls_date
end;   
 


procedure TFrm_3120.PLTIDEditChange(Sender: TObject);
begin
  Query1.Close;
end;

end.



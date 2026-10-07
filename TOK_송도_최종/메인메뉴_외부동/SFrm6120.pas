unit SFrm6120;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables, Frm1100,
  Grids, DBGrids;

type
  TSFrm_6120 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    MesgStsBar: TStatusBar;
    ExitBitBtn: TBitBtn;
    GroupBox1: TGroupBox;
    ConfirmBitBtn: TBitBtn;
    Label20: TLabel;
    LocaMEd: TMaskEdit;
    UpdtQuery: TADOQuery;
    DispQuery: TADOQuery;
    Label7: TLabel;
    pltNoEd: TMaskEdit;
    Label8: TLabel;
    FlagCB: TComboBox;
    Label99: TLabel;
    InDateDTP: TDateTimePicker;
    Label18: TLabel;
    InTimeEd: TMaskEdit;
    GroupBox2: TGroupBox;
    DBGrid2: TDBGrid;
    DataSource2: TDataSource;
    DispQuerySUBK_LOCA: TStringField;
    DispQuerySUBK_PLTNO: TStringField;
    DispQuerySUBK_CODE: TStringField;
    DispQuerySUBK_LOTNO: TStringField;
    DispQuerySUBK_WGT: TBCDField;
    DispQuerySUBK_RWGT: TBCDField;
    DispQuerySUBK_REMARK: TStringField;
    DispQuerySUBK_INDATE: TStringField;
    DispQuerySUBK_INTIME: TStringField;
    pltChkQuery: TADOQuery;
    DispQueryMAST_NAME: TStringField;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);    
   
    //procedure ItemCodeMedChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pltNoEdKeyPress(Sender: TObject; var Key: Char);
    //procedure SB_SearchClick(Sender: TObject);

  private
    { Private declarations }
    function IsNumCheck(var StrData : String): Boolean;
    function IsDotCheck(var StrData : String): Boolean;
    function IsDotCount(var StrData : String): Integer;

    procedure Insert_Code;
    procedure Update_Code;
    procedure T2MiSubk_Select_Proc;
    procedure Pltno_ChkProc(p_pltno : String);


  public
    { Public declarations }
    Bol_insert : Boolean;   // Insert Flag
    Bol_Update : Boolean;
    Bol_Delete : Boolean;
  end;

var
  SFrm_6120: TSFrm_6120;
  Var_ItemDiv : String;
  StrQry, StrMsg, Gl_Color : String; 
  StrPltno : String;
implementation

uses DBSet, WinLib, FrmPrompt, FrmError, Frm6100, MastDisp, FrmProgress;

{$R *.dfm}

function TSFrm_6120.IsNumCheck(var StrData: String): Boolean;
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

function TSFrm_6120.IsDotCheck(var StrData: String): Boolean;
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

function TSFrm_6120.IsDotCount(var StrData: String): Integer;
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

procedure TSFrm_6120.FormCreate(Sender: TObject);
begin
  InDateDTP.Date := Now;      
end;

{
procedure TSFrm_6120.ItemCodeMedChange(Sender: TObject);
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
}

procedure TSFrm_6120.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg, s_qty, s_rqty : String;
begin
  if (StrPltNo <> pltNoEd.Text) then
  begin
    WinLib_ErrorForm('PLTNO를 새로 조회 후 시도하십시오.....');
    DispQuery.Close;
    pltNoEd.SetFocus;

    Exit;
  end;
  if (not DispQuery.Active) or DispQuery.IsEmpty then
  begin
    WinLib_ErrorForm('PLTNO를 조회 후 시도하십시오.....');
    pltNoEd.SetFocus;
    Exit;
  end;

  var_Msg := ' 정말로 확정 합니까.?';
  if Not WinLib_ConfirmForm( var_Msg ) then Exit;


  IF FlagCB.Text = '' Then
  Begin
    WinLib_ErrorForm(' 재고 상태를 입력 하십시요.....' );
    FlagCB.SetFocus;
    Exit;
  End;

  IF pltNoEd.Text = '' Then
  Begin
    WinLib_ErrorForm(' PLTNO를 입력 하십시오..... ');
    pltNoEd.SetFocus;
    Exit;
  End;

  If Bol_Insert Then Insert_Code
  else if Bol_Update Then Update_Code;

end;
/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
{
procedure TSFrm_6120.Insert_Code;
var
  StrDate, StrLoca, StrFlag, s_itemcode, Strgubun : String;
  StrQty, StrRQty, StrRemark : String;
  ls_PltNo, ls_Indate, ls_InTime : String;


  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];
begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_date        :=  copy(sys_datetime, 1, 8);
  s_time        :=  copy(sys_datetime, 9, 6);

  //s_itemcode := ItemCodeMed.Text;

  StrFlag  := '1';

  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

  While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;
  While Pos(',', StrRQty ) > 0 Do Begin Delete(StrRQty, Pos(',', StrRQty), 1); End;

  if  Length(StrQty) = 0   then StrQty  := '0';
  if  Length(StrRQty) = 0  then StrRQty := '0';

  StrLoca := LocaMEd.Text;
  ls_PltNo := pltNoEd.Text;

  StrQry := ' Update T2MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''',  '; // 등록시 1 고정
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''', LSTK_INTIME = '''+s_time+''', ';
  StrQry := StrQry + ' LSTK_PLTNO = '''+ls_PltNo+''' '; // 김준영 추가 

  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고위치(T2MILSTK)  ' + StrLoca + ' 등록 에러!!!! ');
       Exit;
    End;
  End;

  StrQry := ' UPDATE T2MISUBK ';
  StrQry := StrQry + ' SET SUBK_LOCA = '''+StrLoca+''', SUBK_FLAG = '''+StrFlag+''',  SUBK_GUBUN = '''' ';  // SUBK_FLAG : 1 재고 있음, SUBK_GUBUN  : 'Y' 정상 , 'N' 불량, '' 초기상태
  StrQry := StrQry + ' WHERE SUBK_PLTNO = '''+ls_PltNo+''' ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고위치(T2MISUBK)  ' + ls_PltNo + ' 등록 에러!!!! '  );
       showmessage(StrQry);
       Exit;
    End;
    MesgStsBar.SimpleText := '재고위치에 ' + ls_PltNo + '를 등록 하였습니다...';
  End;
  Close;
end;
}

procedure TSFrm_6120.Insert_Code;
var
  StrDate, StrLoca, StrFlag, s_itemcode, Strgubun : String;
  StrQty, StrRQty, StrRemark : String;
  ls_PltNo, ls_Indate, ls_InTime : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];
begin
  // 1. 기초 변수 및 시간 설정
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_date        :=  copy(sys_datetime, 1, 8);
  s_time        :=  copy(sys_datetime, 9, 6);

  StrFlag  := '1'; // 재고 있음 상태로 변경

  // 날짜 포맷 정리 (YYYY-MM-DD -> YYYYMMDD)
  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

  // 수량 변수 초기화 (현재 로직상 화면에서 가져오지 않는다면 0으로 처리됨)
  if  Length(StrQty) = 0   then StrQty  := '0';
  if  Length(StrRQty) = 0  then StrRQty := '0';

  StrLoca := LocaMEd.Text;
  ls_PltNo := pltNoEd.Text;

  // 2. T2MILSTK (재고 마스터) 업데이트
  StrQry := ' Update T2MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''',  ';
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''', LSTK_INTIME = '''+s_time+''', ';
  StrQry := StrQry + ' LSTK_PLTNO = '''+ls_PltNo+''' ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고위치(T2MILSTK)  ' + StrLoca + ' 등록 에러!!!! ');
       Exit;
    End;
  End;

  // 3. T2MISUBK (재고 상세) 업데이트
  //    - 기존에 생성된 PLTNO 데이터에 위치정보, 확정상태, 사용자ID를 업데이트
  StrQry := ' UPDATE T2MISUBK ';
  StrQry := StrQry + ' SET SUBK_LOCA = '''+StrLoca+''', SUBK_FLAG = '''+StrFlag+''',  SUBK_GUBUN = '''' ';

  // [수정됨] 작업자 ID (jj_id) 업데이트 추가
  StrQry := StrQry + '     , SUBK_USERID = '''+jj_id+''' ';

  StrQry := StrQry + ' WHERE SUBK_PLTNO = '''+ls_PltNo+''' ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고위치(T2MISUBK)  ' + ls_PltNo + ' 등록 에러!!!! '  );
       showmessage(StrQry);
       Exit;
    End;
    MesgStsBar.SimpleText := '재고위치에 ' + ls_PltNo + '를 등록 하였습니다...';
  End;

  Close; // 폼 닫기
end;




/////////////////////////////////////////////////////////////
////           Update
/////////////////////////////////////////////////////////////
procedure TSFrm_6120.Update_Code;
var
  NumStockRQty, NumStockQty, NumRQty, NumQty : Real;
  s_div, StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrStockQty, StrStockRQty   : String;
  //StrRQty, StrQty, StrCode, StrLotno, StrRemark, StrBoxNo : String;
  StrGubun, StrJpno, Updt_sw : String;
  ls_pltno : String;
  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];

begin
  StrLoca   := LocaMEd.Text;
  //Strcode   := ItemCodeMed.Text;
  StrFlag   := Copy(FlagCB.Text, 1, 1);
  StrDate := DateToStr(InDateDTP.Date);
  ls_pltno := pltNoEd.Text;

  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;


  //StrRQty   := RQtyEd.Text;
  //StrQty    := QtyEd.Text;
  //StrLotno  := LotnoEd.Text;
  //StrRemark := Trim(BigoEd.Text);
  //StrBoxNo  := Trim(BoxnoEd.Text);

  //While Pos(',', StrRQTY ) > 0 Do Begin Delete(StrRQTY, Pos(',', StrRqty), 1); End;
  //While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;

  //NumQty := StrToFloat(StrQty);
  //NumRqty := StrToFloat(StrRqty);

  StrQry := ' update T2MISUBK set   ';
  StrQry := StrQry + '        subk_flag            =  '''+StrFlag+''',  ';
  //StrQry := StrQry + '        subk_Rwgt            =  convert(Numeric(7,2),'''+StrRQty+'''),  ';
  //StrQry := StrQry + '        subk_wgt             =  convert(Numeric(7,2),'''+StrQty +'''),  ';
  //StrQry := StrQry + '        subk_Gubun           =  ''Y'', subk_remark = '''+StrRemark+''', ';
  //StrQry := StrQry + '        subk_indate          =  '''+StrDate+''',  SUBK_BOXNO = '''+StrBoxNo+'''  ';
  StrQry := StrQry + ' WHERE  SUBK_CODE = '''+Strcode+'''  AND SUBK_PLTNO = '''+ls_pltno+'''  ';
  //StrQry := StrQry + '       and subk_loca = '''+StrLoca+'''       and  subk_Lotno = '''+StrLotno+''' ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('재고위치(T2MISUBK) ' + ls_pltno + ' 수정 에러!!!! ');
      Exit;
    End;
     MesgStsBar.SimpleText := '재고위치 ' + ls_pltno + '를 수정 하였습니다...';
  End;
  Close;


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
      WinLib_ErrorForm('재고위치(T2MILSTK) ' + StrLoca + ' 수정 에러!!!! ');
      Exit;
    End;
  End;

end;

procedure TSFrm_6120.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TSFrm_6120.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_6120.FormDestroy(Sender: TObject);
begin
  SFrm_6120 := Nil;
end;  

{
procedure TSFrm_6120.SB_SearchClick(Sender: TObject);
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
}
procedure TSFrm_6120.pltNoEdKeyPress(Sender: TObject; var Key: Char);
var
   ls_pltno : String;
begin
  if key <> #13 Then Exit;
  ls_pltno  :=  Trim(PltNoEd.Text);

  //While pos('-', ls_pltno) > 0 Do Begin Delete(ls_pltno, pos('-', ls_pltno), 1); End;
  // if Length(Trim(ls_pltno)) <> 4 then   Exit;

  Pltno_ChkProc(ls_pltno);

end;

procedure TSFrm_6120.Pltno_ChkProc(p_pltno : String);
var
    ls_sql, ls_loca, ls_pltno, StrMsg, StrFlag  : String;
    li_cnt : Integer;
begin
  // 공백 제거
  ls_pltno := Trim(p_pltno);

  // 빈값 확인
  if(ls_pltno = '') then begin
    StrMsg := ' PLT_NO를입력하세요..' + #13#10 + ' 확인한 후 다시 하십시요!!!';
    WinLib_ErrorForm(StrMsg);
    Exit;
  end;

  // 자릿수 확인
  {
  if Length(Trim(p_pltno)) <> 5 then
  begin
       StrMsg := ' PLT_NO 5자리 입력하세요 ..' + #13#10 + ' 확인한 후 다시 하십시요!!!';
       WinLib_ErrorForm( StrMsg );
       Exit;
  end;
  }

  // 양식 확인  A 시작 P 시작
  {
  if(UpCase(ls_pltno[1]) <> 'A') AND (UpCase(ls_pltno[1]) <> 'P') then
  begin
    StrMsg := ' PLT_NO 의 양식이 잘못되었습니다..' + #13#10 + ' 확인한 후 다시 하십시요!!!';
    WinLib_ErrorForm(StrMsg);
    Exit;
  end;
  }
  With pltChkQuery Do Begin

    // T2MISUBK 에 있는지 확인 없으면 등록되지않은 PLTNO , PLTNO 생성후 다시 시도
    ls_sql := ' SELECT SUBK_LOCA FROM T2MISUBK WITH (NOLOCK) ';
    ls_sql := ls_sql + ' WHERE SUBK_PLTNO = '''+ls_pltno+''' ';

    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    if(RecordCount = 0) then
    begin
      StrMsg := ' 신규 파레트 번호 입니다.. 등록후 수정 하십시요!!!' + ls_pltno;
      WinLib_ErrorForm(StrMsg);
      pltNoEd.Text := '';
      ls_pltno := '';
      pltNoEd.SetFocus;

      Exit;
    end;

    ls_loca  := FieldByName('SUBK_LOCA').AsString;

    if(Trim(ls_loca) <> '') then begin
      StrMsg := ' 이미 랙 재고에 등록되어 있는 PLTNO 입니다..' + #13#10 + ' 확인 후 다시 하십시오!!! ' + ls_pltno;
      WinLib_ErrorForm(StrMsg);
      pltNoEd.Text := '';
      ls_pltno := '';
      pltNoEd.SetFocus;
      Exit;
    end;

    ls_Sql := ' SELECT 1 FROM T2MILSTK WITH (NOLOCK) ';
    ls_Sql := ls_Sql + ' WHERE LSTK_PLTNO = '''+ls_pltno+''' ';

    Close;
    SQL.Clear;
    SQL.Add(ls_Sql);
    Open;

    if(RecordCount > 0) then
    begin
      StrMsg := ' 이미 랙 재고에 등록되어 있는 PLTNO 입니다..' + #13#10 + ' 확인 후 다시 하십시오!!! ' + ls_pltno;
      WinLib_ErrorForm(StrMsg);
      pltNoEd.Text := '';
      ls_pltno := '';
      pltNoEd.SetFocus;      
      Exit;
    end;

  end; // With pltChkQuery end;

  // 하단 SUBK_PLTNO 조회
  T2Misubk_Select_Proc;
end;

procedure TSFrm_6120.T2MiSubk_Select_Proc;
var
  ls_sql : string;
begin
   ls_sql := '           SELECT ';
   ls_sql := ls_sql + '    A.SUBK_LOCA ';
   ls_sql := ls_sql + '    , A.SUBK_PLTNO ';
   ls_sql := ls_sql + '    , A.SUBK_CODE ';
   ls_sql := ls_sql + '    , B.MAST_NAME ';
   ls_sql := ls_sql + '    , A.SUBK_LOTNO ';
   ls_sql := ls_sql + '    , A.SUBK_WGT ';
   ls_sql := ls_sql + '    , A.SUBK_RWGT ';
   ls_sql := ls_sql + '    , A.SUBK_REMARK ';
   ls_sql := ls_sql + '    , A.SUBK_INDATE ';
   ls_sql := ls_sql + '    , A.SUBK_INTIME ';
   ls_sql := ls_sql + '  FROM T2MISUBK A WITH(NOLOCK) ';
   ls_sql := ls_sql + '  LEFT OUTER JOIN MIMAST B WITH(NOLOCK) ON A.SUBK_CODE = B.MAST_CODE ';
   ls_sql := ls_sql + '  WHERE SUBK_PLTNO = '''+PltnoEd.Text+'''             ';
   ls_sql := ls_sql + '  Order By SUBK_LOCA, SUBK_CODE ';

   with DispQuery do Begin
     Close;
     SQL.Clear;
     SQL.Add(ls_sql);
     Open;
     First;
     StrPltNo := DispQuery.FieldByName('SUBK_PLTNO').AsString;
   end;  
end;

end.


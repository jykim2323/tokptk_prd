unit SFrm4200;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables, Frm1100;

type
  TSFrm_4200 = class(TForm)
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
    InTimeEd: TMaskEdit;
    Label20: TLabel;
    LocaMEd: TMaskEdit;
    UpdtQuery: TADOQuery;
    DispQuery: TADOQuery;
    Label5: TLabel;
    PltnoEd: TEdit;
    Label2: TLabel;
    CasenoEdit: TEdit;
    Label10: TLabel;
    ProdEd: TEdit;
    Label3: TLabel;
    WideEd: TEdit;
    Label11: TLabel;
    LengthEd: TEdit;
    Label12: TLabel;
    WgtEd: TEdit;
    Label7: TLabel;
    RollEd: TEdit;
    Label6: TLabel;
    CwgtEd: TEdit;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    Label15: TLabel;
    EpltEd: TEdit;
    FactEd: TEdit;
    ConfirmBitBtn: TBitBtn;
    DataSource1: TDataSource;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);  

    procedure CasenoEditChange(Sender: TObject);
   
   
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
  SFrm_4200: TSFrm_4200;
  Var_ItemDiv : String;
  StrQry, StrMsg, Gl_Color : String; 

implementation

uses DBSet, WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.dfm}

function TSFrm_4200.IsNumCheck(var StrData: String): Boolean;
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

function TSFrm_4200.IsDotCheck(var StrData: String): Boolean;
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

function TSFrm_4200.IsDotCount(var StrData: String): Integer;
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

procedure TSFrm_4200.FormCreate(Sender: TObject);
begin
  InDateDTP.Date := Now;
end;  

procedure TSFrm_4200.CasenoEditChange(Sender: TObject);
begin
  StrQry := ' Select * From UDT_WHOUTHISTORY Where CASENO = '''+CasenoEdit.Text+'''';

  With DispQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    ProdEd.Text   := FieldByName('PRODID').AsString;
    WideEd.Text   := FieldByName('PROD_WIDTH').AsString;
    LengthEd.Text := FieldByName('PROD_LENGTH').AsString;
    WgtEd.Text    := FieldByName('PROD_WEIGHT').AsString;
    CwgtEd.Text   := FieldByName('CASE_WEIGHT').AsString;
    RollEd.Text   := FieldByName('UDF_ROLLSHEET').AsString;
  End;
end;

procedure TSFrm_4200.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
   var_Msg := ' 정말로 확정 합니까.?';
  if Not WinLib_ConfirmForm( var_Msg ) then Exit;

  IF LocaMEd.Text = '' Then
  Begin
    WinLib_ErrorForm(' 저장위치를 입력 하십시요..' );
    LocaMEd.SetFocus;   Exit;
  End;

  IF PltnoEd.Text = '' Then
  Begin
    WinLib_ErrorForm(' PLT NO를 입력 하십시요..' );
    PltnoEd.SetFocus;   Exit;
  End;

  IF FlagCB.Text = '' Then
  Begin
    WinLib_ErrorForm(' 저장위치 상태를 입력 하십시요.....' );
    FlagCB.SetFocus;   Exit;
  End;


  IF CasenoEdit.Text = '' Then
  Begin
    WinLib_ErrorForm(' Case No를 선택 하십시요.' );
    CasenoEdit.SetFocus;   Exit;
  End;

  If Bol_Insert Then Insert_Code
  else if Bol_Update Then Update_Code;

end;
/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
procedure TSFrm_4200.Insert_Code;
var
  StrDate, StrLoca, StrFlag, s_Caseno, StrEPLT, StrFact : String;
  StrPltno, StrRoll, save_pltno : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];
begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_date        :=  copy(sys_datetime, 1, 8);
  s_time        :=  copy(sys_datetime, 9, 6);

  StrPltNO := PltnoEd.Text;
  s_Caseno := CasenoEdit.Text;
  StrLoca  := LocaMEd.Text;


  StrQry := ' Select * From STK_MISUBK Where SUBK_CASENO = '''+s_Caseno+''' ';
  With DispQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    IF RecordCount > 0 Then
    Begin
      WinLib_ErrorForm(' 동일한 Case No가 있습니다.' );
      CasenoEdit.SetFocus;   Exit;
    end;
  End;

  StrQry := ' Select * From STK_MISUBK Where SUBK_LOCA = '''+StrLoca+''' ';
  With DispQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    IF RecordCount > 0 Then
    Begin
      save_pltno := FieldByName('SUBK_PLTNO').AsString;
      if StrPltNO <>  save_pltno  then
      begin
         WinLib_ErrorForm(' 해당 위치의 PLT NO가 서로 틀립니다.' );      Exit;
      end;
    end;
  End;


//  StrFlag := Copy(FlagCB.Text, 1, 1);
  StrFlag  := '1';
  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

  StrLoca  := LocaMEd.Text;
  StrEPLT  := EpltEd.Text;
  StrFact  := FactEd.Text;

  StrPltno := PltnoEd.Text;
  StrRoll  := RollEd.Text;

  StrQry := ' Update STK_MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG   = '''+StrFlag+''', LSTK_PLTNO  = '''+StrPltno+''', ';
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''', LSTK_INTIME = '''+s_time+''',       ';
  StrQry := StrQry + ' LSTK_EPLT   = '''+StrEPLT+'''       ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('저장위치(MILSTK)  ' + StrLoca + ' 등록 에러!!!! ');
       Exit;
    End;
  End;


  StrQry := ' INSERT INTO STK_MISUBK ';
  StrQry := StrQry + ' (SUBK_LOCA,   SUBK_FLAG,   SUBK_PLTNO,    SUBK_ROLLSHEET, SUBK_GUBUN,  ';
  StrQry := StrQry + '  SUBK_EPLT,   SUBK_FACT,   SUBK_INDATE,   SUBK_INTIME, SUBK_CASENO  )  ';
  StrQry := StrQry + ' values ( '''+StrLoca+''', '''+StrFlag+''', '''+StrPltno+''', '''+StrRoll+''', '''', ';
  StrQry := StrQry + '          '''+StrEPLT+''', '''+StrFact+''', '''+StrDate+''',  '''+s_time+''', '''+s_Caseno+''' ) ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('저장위치(MISUBK)  ' + CasenoEdit.Text + ' 등록 에러!!!! '  ); 
       Exit;
    End;
    MesgStsBar.SimpleText := '저장위치 ' + CasenoEdit.Text + '를 등록 하였습니다...';
  End;

////////////////////////////////////////////////////////////////////////////////
  StrQry := ' Update UDT_WHOUTHISTORY Set ';
  StrQry := StrQry + ' UDT_WHAUTO_INUSERID = '''+jj_id+''', UDT_WHAUTO_LOC  = '''+StrLoca+''', ';
  StrQry := StrQry + ' UDT_WHAUTO_INTIME = '''+sys_datetime+''', UDT_WHAUTO_OUTTIME = '''', UDT_WHAUTO_OUTFLAG = ''Insert'' ';
  StrQry := StrQry + ' Where CASENO = '''+s_Caseno+'''  ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('마스터(UDT_WHO)  ' + StrLoca + ' 수정 에러!!!! ');
       Exit;
    End;
  End;
////////////////////////////////////////////////////////////////////////////////

end;
/////////////////////////////////////////////////////////////
////           Update
/////////////////////////////////////////////////////////////
procedure TSFrm_4200.Update_Code;
var
  StrDate, StrLoca, StrFlag : String;
  StrCaseno, StrLotno, StrPltno,  StrCvcod, StrGubun, s_fact, s_eplt : String;
  StrRoll, save_pltno : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];

begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_date        :=  copy(sys_datetime, 1, 8);
  s_time        :=  copy(sys_datetime, 9, 6);

  StrFlag   := Copy(FlagCB.Text, 1, 1);
  StrLoca   := LocaMEd.Text;
  StrPltNO  := PltnoEd.Text;
  StrCaseno := CasenoEdit.Text;

  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

  s_fact := FactEd.Text;
  s_eplt := EpltEd.Text;
  
  StrQry := ' update stk_misubk set   ';
  StrQry := StrQry + '        subk_flag   =  '''+StrFlag+''',   ';
  StrQry := StrQry + '        subk_fact   =  '''+s_fact+''',   subk_eplt =  '''+s_eplt+''',  ';
  StrQry := StrQry + '        subk_indate =  '''+StrDate+'''  ';
  StrQry := StrQry + ' where  subk_loca  = '''+StrLoca+'''    And subk_pltno = '''+StrPltNO+''' ';
  StrQry := StrQry + '        And  subk_caseno = '''+StrCaseno+''' ';
//  showmessage(StrQry);
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('저장위치(MISUBK) ' + StrLoca + ' 수정 에러!!!! ');
      Exit;
    End;
     MesgStsBar.SimpleText := '저장위치 ' + StrLoca + '를 수정 하였습니다...';
  End;


  StrQry := ' Update STK_MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''', LSTK_PLTNO = '''+StrPltNO+''',  ';
  StrQry := StrQry + ' LSTK_EPLT = '''+s_eplt+''',  LSTK_INDATE = '''+StrDate+''' ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('저장위치(MILSTK) ' + StrLoca + ' 수정 에러!!!! ');
      Exit;
    End;
  End;    

end;

procedure TSFrm_4200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TSFrm_4200.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_4200.FormDestroy(Sender: TObject);
begin
  SFrm_4200 := Nil;
end;



end.


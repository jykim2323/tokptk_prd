unit SFrm4120;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_4120 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    MesgStsBar: TStatusBar;
    ExitBitBtn: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    PltnoEd: TEdit;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label11: TLabel;
    Label6: TLabel;
    Label20: TLabel;
    LocaMEd: TMaskEdit;
    Label7: TLabel;
    Label12: TLabel;
    ConfirmBitBtn: TBitBtn;
    ProdEd: TEdit;
    Label10: TLabel;
    Label99: TLabel;
    InDateDTP: TDateTimePicker;
    InTimeEd: TMaskEdit;
    Label18: TLabel;
    Label8: TLabel;
    FlagCB: TComboBox;
    LengthEd: TEdit;
    Label3: TLabel;
    WideEd: TEdit;
    WgtEd: TEdit;
    CwgtEd: TEdit;
    RollEd: TEdit;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    Label15: TLabel;
    EpltEd: TEdit;
    FactEd: TEdit;
    DispQuery: TADOQuery;
    UpdtQuery: TADOQuery;
    DataSource1: TDataSource;
    CasenoEdit: TEdit;

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
//    function PdaLib_LotNoChK(LotNo: String): String;
    
    procedure Insert_Code;
    procedure Update_Code; 

  public
    { Public declarations }
    Bol_insert : Boolean;
    Bol_Update : Boolean;
    Bol_Delete : Boolean;
  end;

var
  SFrm_4120: TSFrm_4120;
  Var_ItemDiv : String;
  StrQry, StrMsg, Var_Lot : String;

implementation

uses WinLib, FrmPrompt, FrmError, Frm4100, FrmProgress;

{$R *.dfm}

function TSFrm_4120.IsNumCheck(var StrData: String): Boolean;
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

function TSFrm_4120.IsDotCheck(var StrData: String): Boolean;
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

function TSFrm_4120.IsDotCount(var StrData: String): Integer;
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

procedure TSFrm_4120.FormCreate(Sender: TObject);
begin
  InDateDTP.Date := Now;  
end;

procedure TSFrm_4120.CasenoEditChange(Sender: TObject);
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

procedure TSFrm_4120.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
   var_Msg := ' 정말로 확정 합니까.?';
  if Not WinLib_ConfirmForm( var_Msg ) then Exit;

  IF PltnoEd.Text = '' Then
  Begin
    WinLib_ErrorForm(' PLT NO를 입력 하십시요..' );
    PltnoEd.SetFocus;   Exit;
  End;

  IF Length(Trim(pltnoEd.text)) <> 4 Then
  Begin
     WinLib_ErrorForm(' PLT No 4자리를 확인하세요.....' );
     PltNoEd.SetFocus;
     Exit;
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
procedure TSFrm_4120.Insert_Code;
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
       showmessage(StrQry);
       Exit;
    End;
    MesgStsBar.SimpleText := '저장위치 ' + CasenoEdit.Text + '를 등록 하였습니다...';
  End;
  Close;
  
end;
/////////////////////////////////////////////////////////////
////           Update
/////////////////////////////////////////////////////////////
procedure TSFrm_4120.Update_Code;
var
  NumStockRQty, NumStockQty, NumRQty, NumQty : Real;
  s_div, StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrRQty, StrQty, StrStockQty, StrStockRQty   : String;
  StrCaseno, StrLotno, StrPltno,  StrCvcod, StrGubun, s_fact, s_eplt : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];

begin
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
  Close;

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

procedure TSFrm_4120.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TSFrm_4120.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_4120.FormDestroy(Sender: TObject);
begin
  SFrm_4120 := Nil;
end;


{
function TSFrm_4120.PdaLib_LotNoChK(LotNo: String): String;
var
  var_Lot, ls_yy, ls_mm, ls_dd : String;
begin
       var_Lot := Copy(LotNo,1,13);
       if  copy(var_Lot,1,1) = 'E'  then  ls_yy := '2005';
       if  copy(var_Lot,1,1) = 'F'  then  ls_yy := '2006';
       if  copy(var_Lot,1,1) = 'G'  then  ls_yy := '2007';
       if  copy(var_Lot,1,1) = 'H'  then  ls_yy := '2008';
       if  copy(var_Lot,1,1) = 'I'  then  ls_yy := '2009';
       if  copy(var_Lot,1,1) = 'J'  then  ls_yy := '2010';
       if  copy(var_Lot,1,1) = 'K'  then  ls_yy := '2011';
       if  copy(var_Lot,1,1) = 'L'  then  ls_yy := '2012';
       if  copy(var_Lot,1,1) = 'M'  then  ls_yy := '2013';
       if  copy(var_Lot,1,1) = 'N'  then  ls_yy := '2014';
       if  copy(var_Lot,1,1) = 'O'  then  ls_yy := '2015';
       if  copy(var_Lot,1,1) = 'P'  then  ls_yy := '2016';
       if  copy(var_Lot,1,1) = 'Q'  then  ls_yy := '2017';
       if  copy(var_Lot,1,1) = 'R'  then  ls_yy := '2018';

       if  copy(var_Lot,2,1) = 'A'  then  ls_mm := '01';
       if  copy(var_Lot,2,1) = 'B'  then  ls_mm := '02';
       if  copy(var_Lot,2,1) = 'C'  then  ls_mm := '03';
       if  copy(var_Lot,2,1) = 'D'  then  ls_mm := '04';
       if  copy(var_Lot,2,1) = 'E'  then  ls_mm := '05';
       if  copy(var_Lot,2,1) = 'F'  then  ls_mm := '06';
       if  copy(var_Lot,2,1) = 'G'  then  ls_mm := '07';
       if  copy(var_Lot,2,1) = 'H'  then  ls_mm := '08';
       if  copy(var_Lot,2,1) = 'I'  then  ls_mm := '09';
       if  copy(var_Lot,2,1) = 'J'  then  ls_mm := '10';
       if  copy(var_Lot,2,1) = 'K'  then  ls_mm := '11';
       if  copy(var_Lot,2,1) = 'L'  then  ls_mm := '12';

       if  copy(var_Lot,3,1) = 'A'  then  ls_dd := '01';
       if  copy(var_Lot,3,1) = 'B'  then  ls_dd := '02';
       if  copy(var_Lot,3,1) = 'C'  then  ls_dd := '03';
       if  copy(var_Lot,3,1) = 'D'  then  ls_dd := '04';
       if  copy(var_Lot,3,1) = 'E'  then  ls_dd := '05';
       if  copy(var_Lot,3,1) = 'F'  then  ls_dd := '06';
       if  copy(var_Lot,3,1) = 'G'  then  ls_dd := '07';
       if  copy(var_Lot,3,1) = 'H'  then  ls_dd := '08';
       if  copy(var_Lot,3,1) = 'I'  then  ls_dd := '09';
       if  copy(var_Lot,3,1) = 'J'  then  ls_dd := '10';
       if  copy(var_Lot,3,1) = 'K'  then  ls_dd := '11';
       if  copy(var_Lot,3,1) = 'L'  then  ls_dd := '12';
       if  copy(var_Lot,3,1) = 'M'  then  ls_dd := '13';
       if  copy(var_Lot,3,1) = 'N'  then  ls_dd := '14';
       if  copy(var_Lot,3,1) = 'O'  then  ls_dd := '15';
       if  copy(var_Lot,3,1) = 'P'  then  ls_dd := '16';
       if  copy(var_Lot,3,1) = 'Q'  then  ls_dd := '17';
       if  copy(var_Lot,3,1) = 'R'  then  ls_dd := '18';
       if  copy(var_Lot,3,1) = 'S'  then  ls_dd := '19';
       if  copy(var_Lot,3,1) = 'T'  then  ls_dd := '20';
       if  copy(var_Lot,3,1) = 'U'  then  ls_dd := '21';
       if  copy(var_Lot,3,1) = 'V'  then  ls_dd := '22';
       if  copy(var_Lot,3,1) = 'W'  then  ls_dd := '23';
       if  copy(var_Lot,3,1) = 'X'  then  ls_dd := '24';
       if  copy(var_Lot,3,1) = 'Y'  then  ls_dd := '25';
       if  copy(var_Lot,3,1) = 'Z'  then  ls_dd := '26';
       if  copy(var_Lot,3,1) = '1'  then  ls_dd := '27';
       if  copy(var_Lot,3,1) = '2'  then  ls_dd := '28';
       if  copy(var_Lot,3,1) = '3'  then  ls_dd := '29';
       if  copy(var_Lot,3,1) = '4'  then  ls_dd := '30';
       if  copy(var_Lot,3,1) = '5'  then  ls_dd := '31';

      result :=  ls_yy + ls_mm + ls_dd + copy(var_Lot,4,8);
end;
}

end.

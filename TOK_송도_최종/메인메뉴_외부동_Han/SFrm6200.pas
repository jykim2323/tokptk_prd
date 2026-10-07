 unit SFrm6200;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables, Frm1100;

type
  TSFrm_6200 = class(TForm)
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
  SFrm_6200: TSFrm_6200;
  Var_ItemDiv : String;
  StrQry, StrMsg, Gl_Color : String; 

implementation

uses DBSet, WinLib, FrmPrompt, FrmError, Frm6100, MastDisp;

{$R *.dfm}

function TSFrm_6200.IsNumCheck(var StrData: String): Boolean;
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

function TSFrm_6200.IsDotCheck(var StrData: String): Boolean;
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

function TSFrm_6200.IsDotCount(var StrData: String): Integer;
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

procedure TSFrm_6200.FormCreate(Sender: TObject);
begin
  InDateDTP.Date := Now;      
end;


procedure TSFrm_6200.ItemCodeMedChange(Sender: TObject);
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



procedure TSFrm_6200.ConfirmBitBtnClick(Sender: TObject);
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
/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
procedure TSFrm_6200.Insert_Code;
var
  StrDate, StrLoca, StrFlag, s_itemcode, Strgubun : String;
  StrQty, StrRQty : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];
begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_date        :=  copy(sys_datetime, 1, 8);
  s_time        :=  copy(sys_datetime, 9, 6);

  s_itemcode := ItemCodeMed.Text;

//  StrFlag := Copy(FlagCB.Text, 1, 1);
  StrFlag  := '1';


  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

  StrQty  := QtyEd.Text;
  StrRQty := RQtyEd.Text;

  While Pos(',', StrQty )  > 0 Do Begin Delete(StrQty,  Pos(',', StrQty), 1); End;
  While Pos(',', StrRQty ) > 0 Do Begin Delete(StrRQty, Pos(',', StrRQty), 1); End;

  if  Length(StrQty)  = 0  then StrQty  := '0';
  if  Length(StrRQty) = 0  then StrRQty := '0';

  StrLoca := LocaMEd.Text;

  StrQry := ' Select  *  from  T2MILSTK (NOLOCK) Where LSTK_LOCA = '''+StrLoca+'''   ';
  With UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      Open;
      if RecordCount = 0  then
      begin
         WinLib_ErrorForm('재고위치  ' + StrLoca + ' 틀림!!!! ');
         Exit;
      end;
  End;


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
       WinLib_ErrorForm('재고위치(T2MILSTK)  ' + StrLoca + ' 등록 에러!!!! ');
       Exit;
    End;
  End;

  StrQry := ' INSERT INTO T2misubk ';
  StrQry := StrQry + ' (SUBK_CODE,   SUBK_LOCA,    SUBK_FLAG,   ';
  StrQry := StrQry + '  SUBK_WGT,     SUBK_RWGT,   SUBK_LOTNO,   SUBK_GUBUN,  '; // N 정상,  Y 불량
  StrQry := StrQry + '  SUBK_INDATE,  SUBK_INTIME )  ';
  StrQry := StrQry + ' values (  '''+s_itemcode+''',   '''+StrLoca+''',     '''+StrFlag+''', ';
  StrQry := StrQry + '          convert(Numeric,'''+StrQty+'''),  convert(Numeric,'''+StrRQty+'''),    ';
  StrQry := StrQry + '          '''+LotnoEd.Text+''', '''',  '''+StrDate+''', '''+s_time+''' )  ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('재고위치(T2misubk)  ' + ItemCodeMed.Text + ' 등록 에러!!!! '  );
       showmessage(StrQry);
       Exit;
    End;
    MesgStsBar.SimpleText := '재고위치 ' + ItemCodeMed.Text + '를 등록 하였습니다...';
  End;
  Close;
end;
/////////////////////////////////////////////////////////////
////           Update
/////////////////////////////////////////////////////////////
procedure TSFrm_6200.Update_Code;
var
  NumStockRQty, NumStockQty, NumRQty, NumQty : Real;
  s_div, StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrRQty, StrQty, StrStockQty, StrStockRQty   : String;
  StrCode, StrLotno,  StrCvcod, StrGubun, StrJpno, Updt_sw : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];

begin
  StrLoca   := LocaMEd.Text;   
  Strcode   := ItemCodeMed.Text;
  StrFlag   := Copy(FlagCB.Text, 1, 1);
  StrDate := DateToStr(InDateDTP.Date);

  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;


  StrRQty   := RQtyEd.Text;
  StrQty    := QtyEd.Text;
  StrLotno  := LotnoEd.Text;       

  While Pos(',', StrRQTY ) > 0 Do Begin Delete(StrRQTY, Pos(',', StrRqty), 1); End;
  While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;

  NumQty := StrToFloat(StrQty);
  NumRqty := StrToFloat(StrRqty);

  StrQry := ' update T2misubk set   ';
  StrQry := StrQry + '        subk_flag            =  '''+StrFlag+''',  ';
  StrQry := StrQry + '        subk_Rwgt            =  convert(Numeric,'''+StrRQty+'''),  ';
  StrQry := StrQry + '        subk_wgt             =  convert(Numeric,'''+StrQty +'''),  ';
  StrQry := StrQry + '        subk_Gubun           =  '''', ';  // N 정상 , Y 불량, '' 초기값
  StrQry := StrQry + '        subk_indate          =  '''+StrDate+'''  ';
  StrQry := StrQry + ' where  subk_code  = '''+Strcode+'''    ';
  StrQry := StrQry + '       and subk_loca = '''+StrLoca+'''       and  subk_Lotno = '''+StrLotno+'''   ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('재고위치(T2misubk) ' + ItemCodeMed.Text + ' 수정 에러!!!! ');
      Exit;
    End;
     MesgStsBar.SimpleText := '재고위치 ' + ItemCodeMed.Text + '를 수정 하였습니다...';
  End;
  Close;


  StrQry := ' Update T2MILSTK Set ';   
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''' ';
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

procedure TSFrm_6200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TSFrm_6200.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_6200.FormDestroy(Sender: TObject);
begin
  SFrm_6200 := Nil;
end;   

procedure TSFrm_6200.SB_SearchClick(Sender: TObject);
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


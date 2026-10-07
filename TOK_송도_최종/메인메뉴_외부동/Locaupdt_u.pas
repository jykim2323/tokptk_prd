unit Locaupdt_u;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TLocaUpdt = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    MesgStsBar: TStatusBar;
    ExitBitBtn: TBitBtn;
    Panel2: TPanel;
    Label20: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ConfirmBitBtn: TBitBtn;
    LocaMEd: TMaskEdit;
    InTimeEd: TMaskEdit;
    InDateDTP: TDateTimePicker;
    QtyEdit: TMaskEdit;
    RQtyEdit: TMaskEdit;
    CodeEdit: TEdit;
    FlagCB: TComboBox;
    DispQuery: TADOQuery;
    UpdtQuery: TADOQuery;
    Query1: TADOQuery;
    Query1HH_JPNO: TStringField;
    Query1HH_ITEMNO: TStringField;
    Query1HH_BWART: TStringField;
    Query1HH_EINDT: TStringField;
    Query1HH_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1MAST_CPN: TStringField;
    Query1HH_FACT: TStringField;
    Query1HH_AREA: TStringField;
    Query1HH_PGUBN: TStringField;
    Query1HH_QTY: TIntegerField;
    Query1HH_MEINS: TStringField;
    Query1HH_LOEKZ: TStringField;
    Query1HH_LIFNR: TStringField;
    Query1HH_NAME1: TStringField;
    Query1HH_WEMPF: TStringField;
    Query1HH_FLAG: TStringField;
    Query1STOK_QTY: TBCDField;
    Query2: TADOQuery;
    NameEdit: TEdit;
    Mast_Search: TSpeedButton;
    Label8: TLabel;
    Label1: TLabel;
    LotnoEdit: TEdit;
    Label2: TLabel;
    BigoEdit: TEdit;
    Label3: TLabel;
    BoxNoEdit: TEdit;
    Label5: TLabel;
    PltnoEdit: TMaskEdit;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);    
    procedure FormCreate(Sender: TObject);
   
//    procedure Edit_InputBox(Sender: TObject);
 
    procedure CodeEditKeyPress(Sender: TObject; var Key: Char);
    procedure Mast_SearchClick(Sender: TObject);
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
  StrCode : String;
  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;
  
  LocaUpdt: TLocaUpdt;
  Var_ItemDiv : String;
  var_Sql : String;
  StrQry, StrMsg, Gl_Color : String; 

implementation

uses  Dbset, WinLib, FrmPrompt, FrmError, CellDisp, FrmProgress, CustDisp,
  MastDisp;

{$R *.dfm}

function TLocaUpdt.IsNumCheck(var StrData: String): Boolean;
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

function TLocaUpdt.IsDotCheck(var StrData: String): Boolean;
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

function TLocaUpdt.IsDotCount(var StrData: String): Integer;
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

procedure TLocaUpdt.FormCreate(Sender: TObject);
var
  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];
begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_time        :=  copy(sys_datetime, 9, 6);

  InDateDTP.Date := Now;
  InTimeEd.Text  := s_time;
  CodeEdit.Text  := '';
end;

procedure TLocaUpdt.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg, s_qty, s_rqty : String;
begin
  var_Msg := ' 정말로 확정 합니까.?';
  if Not WinLib_ConfirmForm( var_Msg ) then Exit;

  IF CodeEdit.Text = '' Then
  Begin
    WinLib_ErrorForm(' 품번코드를 입력 하세요.' );
    CodeEdit.SetFocus;   Exit;
  End;

  IF QtyEdit.Text = '' Then
  Begin
    WinLib_ErrorForm(' 재고 수량을 입력 하십시요.....' );
    QtyEdit.SetFocus;   Exit;
  End;

  s_qty  := Trim(QtyEdit.Text);
  s_rqty := Trim(RQtyEdit.Text);

  IF IsNumCheck(s_qty) = False  then
  Begin
    WinLib_ErrorForm(' 재고 중량을 입력 하십시요.....' );
    QtyEdit.SetFocus;   Exit;
  End;

  IF IsNumCheck(s_rqty) = False  then
  Begin
    WinLib_ErrorForm(' 예약 중량을 입력 하십시요.....' );
    RQtyEdit.SetFocus;   Exit;
  End;      


  IF Trim(RQtyEdit.Text) = '' Then RQtyEdit.Text := '0';
  IF Trim(QtyEdit.Text)  = '' Then QtyEdit.Text  := '0';

  If Bol_Insert Then Insert_Code
  else if Bol_Update Then Update_Code;

end;

procedure TLocaUpdt.Insert_Code;
var
  StrDate, StrTime, StrLoca, StrFlag : String;
  StrQty, StrRQty : String;
  ls_code, ls_lotno, ls_bigo, ls_cust, ls_boxno : String;
  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];
begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_date        :=  copy(sys_datetime, 1, 8);
  s_time        :=  copy(sys_datetime, 9, 6);

  InTimeEd.Text := s_time;
  StrTime       := InTimeEd.Text;

  ls_code  := Trim(CodeEdit.Text);
  ls_lotno := Trim(LotnoEdit.Text);
  ls_boxno := Trim(BoxnoEdit.Text);
  ls_bigo  := Trim(BigoEdit.Text);

  StrFlag := Copy(FlagCB.Text, 1, 1);
  if  ((StrFlag = '0') or (StrFlag = ''))then  StrFlag := '1';

  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

//  StrDate := StrDate + StrTime;
  StrDate := StrDate;

  StrQty  := Trim(QtyEdit.Text);
  StrRQty := Trim(RQtyEdit.Text);

  While Pos(',', StrQty )  > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1);   End;
  While Pos(',', StrRQty ) > 0 Do Begin Delete(StrRQty, Pos(',', StrRQty), 1); End;

  if  Length(StrQty) = 0   then StrQty  := '0';
  if  Length(StrRQty) = 0  then StrRQty := '0';

  StrLoca := LocaMEd.Text;

  StrQry := ' Update   T2MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''',   ';
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''', LSTK_INTIME = '''+StrTime+''' ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('저장위치(T2MILSTK)  ' + StrLoca + ' 등록 에러!!!! ');
       Exit;
    End;
  End;                          

  StrQry := ' INSERT INTO T2MISUBK ';
  StrQry := StrQry + ' (SUBK_LOCA,   SUBK_CODE,   SUBK_LOTNO, ';
  StrQry := StrQry + '  SUBK_WGT,    SUBK_RWGT,   ';
  StrQry := StrQry + '  SUBK_FLAG,   SUBK_REMARK, SUBK_BOXNO, SUBK_INDATE, SUBK_INTIME )';
  StrQry := StrQry + ' values('''+StrLoca+''',  '''+ls_code+''',  '''+ls_lotno+''',  ';
  StrQry := StrQry + '        Convert(Numeric(7,2),'''+StrQty+'''), Convert(Numeric(7,2),'''+StrRQty+'''),  ';
  StrQry := StrQry + '          '''+StrFlag+''', '''+ls_bigo+''', '''+ls_boxno+''', '''+StrDate+''','''+StrTime+''') ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('저장위치(T2MISUBK)  ' + CodeEdit.Text + ' 등록 에러!!!! '  );
       showmessage(StrQry);
       Exit;
    End;
    MesgStsBar.SimpleText := '저장위치 ' + CodeEdit.Text + '를 등록 하였습니다...';
  End;
  Close;
end;
/////////////////////////////////////////////////////////////
////           Update
/////////////////////////////////////////////////////////////
procedure TLocaUpdt.Update_Code;
var
  NumStockRQty, NumStockQty, NumRQty, NumQty : Real;
  StrDate, StrLoca, StrFlag  : String;
  StrRQty, StrQty, StrStockQty, StrStockRQty, StrGroup   : String;
  StrCode, StrLotno, StrCvcod, StrGubun, StrJpno, Updt_sw, ls_time : String;
  ls_lotno, ls_bigo, ls_cust, ls_boxno  : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];

begin
  StrLoca  := Trim(LocaMEd.Text);
  StrCode  := Trim(CodeEdit.Text);

  ls_lotno := Trim(LotnoEdit.Text);
  ls_boxno := Trim(BoxnoEdit.Text);
  ls_bigo  := Trim(BigoEdit.Text);

  StrFlag := Copy(FlagCB.Text, 1, 1);
  if  ((StrFlag = '0') or (StrFlag = ''))then  StrFlag := '1';

  ls_time      := Trim(InTimeEd.Text);
  StrDate      := DateToStr(InDateDTP.Date);
  StrDate      := StrDate;

  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;


  StrQry := ' Select SUBK_WGT, SUBK_RWGT From T2MISUBK (NOLOCK) ';
  StrQry := StrQry + ' Where SUBK_LOCA  = '''+StrLoca+'''  And SUBK_CODE = '''+StrCode+''' ';
  StrQry := StrQry + ' And   SUBK_LOTNO = '''+ls_lotno+'''   ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    StrStockQty  := FieldByName('SUBK_WGT').AsString;
    StrStockRQTY := FieldByName('SUBK_RWGT').AsString;

  End;

  StrRQty   := RQtyEdit.Text;
  StrQty    := QtyEdit.Text;


  While Pos(',', StrRQTY ) > 0 Do Begin Delete(StrRQTY, Pos(',', StrRqty), 1); End;
  While Pos(',', StrQty ) > 0  Do Begin Delete(StrQty,  Pos(',', StrQty), 1);  End;

  IF StrStockQty = ''  Then StrStockQty  := '0';
  IF StrStockRQty = '' Then StrStockRQty := '0';

  NumQty := StrToFloat(StrQty);
  NumRqty := StrToFloat(StrRqty);
  NumStockQty  := StrToFloat(StrStockQty);
  NumStockRqty  := StrToFloat(StrStockRQty);

  if NumStockQty >=  NumQty   then
  begin
     NumStockQty := NumStockQty - NumQty;   Updt_sw := 'M';
  end
  else
  begin
     NumStockQty :=  NumQty - NumStockQty;  Updt_sw := 'P';
  end;

  if NumStockRQty >=  NumRQty   then NumStockRQty := NumStockRQty - NumRQty else NumStockRQty :=  NumRQty - NumStockRQty;

  StrStockQty  := FloatToStr(NumStockQty);
  StrStockRQty := FloatToStr(NumStockRQty);

  StrQry := ' UPDATE         T2MISUBK SET   ';
  StrQry := StrQry + '       SUBK_WGT    = Convert(Numeric(7,2),'''+StrQty +'''),';
  StrQry := StrQry + '       SUBK_RWGT   = Convert(Numeric(7,2),'''+StrRQty+'''),';
  StrQry := StrQry + '       SUBK_FLAG     = '''+StrFlag+''',  ';
  StrQry := StrQry + '       SUBK_REMARK   = '''+ls_bigo+''',  ';
  StrQry := StrQry + '       SUBK_BOXNO    = '''+ls_Boxno+''',  ';
  StrQry := StrQry + '       SUBK_INDATE   = '''+StrDate+''',  ';
  StrQry := StrQry + '       SUBK_INTIME   = '''+ls_time+'''   ';
  StrQry := StrQry + ' Where SUBK_LOCA     = '''+StrLoca+'''   ';
  StrQry := StrQry + '   And SUBK_CODE     = '''+Strcode+'''   ';
//  StrQry := StrQry + '   And SUBK_LOTNO     = '''+ls_lotno+'''   ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSql;
    Except
      WinLib_ErrorForm('저장위치(T2MISUBK) ' + CodeEdit.Text + ' 수정 에러!!!! ');
      showmessage(StrQry);
      Exit;
    End;
     MesgStsBar.SimpleText := '저장위치 ' + CodeEdit.Text + '를 수정 하였습니다.';
  End;
  Close;

  StrQry := ' Select Sum(SUBK_RWGT) SUBK_RWGT, SUM(SUBK_WGT) SUBK_WGT From T2MISUBK (NOLOCK) Where SUBK_LOCA = '''+StrLoca+''' ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;    

    StrStockQty := FieldByName('SUBK_WGT').asString;
  End;

  StrQry := ' Update   T2MILSTK Set ';
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''', LSTK_INTIME = '''+ls_time+''' ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;                          
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('저장위치(T2MILSTK) ' + StrLoca + ' 수정 에러!!!! ');
      Exit;
    End;
  End;
end;

procedure TLocaUpdt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
          
procedure TLocaUpdt.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TLocaUpdt.FormDestroy(Sender: TObject);
begin
  LocaUpdt := Nil;
end;  

procedure TLocaUpdt.CodeEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then   
end;

procedure TLocaUpdt.Mast_SearchClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  Mast_Disp  := TMast_Disp.Create(Application);
  Bol_Modal := True;

  Mast_Disp.Edt_Search.Text := CodeEdit.Text;
  If Mast_Disp <> Nil Then
    With TForm(Mast_Disp) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      Mast_Disp.Free;
    End;           

    CodeEdit.Text  :=  jj_code;
    NameEdit.Text  :=  jj_name;        
end;

end.


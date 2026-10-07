unit SFrm5120;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_5120 = class(TForm)
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
    FlagCB: TComboBox;
    Label8: TLabel;
    Label18: TLabel;
    Label99: TLabel;
    InDateDTP: TDateTimePicker;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    NameEd: TEdit;
    Label6: TLabel;
    ConfirmBitBtn: TBitBtn;
    InTimeEd: TMaskEdit;
    ItemCodeMed: TComboBox;
    Label20: TLabel;
    LocaMEd: TMaskEdit;
    PNameEd: TEdit;
    Label1: TLabel;
    QtyEd: TMaskEdit;
    RQtyEd: TMaskEdit;
    UpdtQuery: TADOQuery;
    DispQuery: TADOQuery;
    PgubnEd: TComboBox;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);    
    procedure ItemCodeMedKeyPress(Sender: TObject; var Key: Char); 
    procedure ItemCodeMedChange(Sender: TObject);  
    procedure FormCreate(Sender: TObject);
    procedure Cntl_Code_Select;
    procedure PgubnEdChange(Sender: TObject);        

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
  SFrm_5120: TSFrm_5120;
  Var_ItemDiv : String;
  StrQry, StrMsg, Var_Lot : String;

implementation

uses Dbset, WinLib, FrmPrompt, FrmError, Frm5100;

{$R *.dfm}

function TSFrm_5120.IsNumCheck(var StrData: String): Boolean;
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

function TSFrm_5120.IsDotCheck(var StrData: String): Boolean;
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

function TSFrm_5120.IsDotCount(var StrData: String): Integer;
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

procedure TSFrm_5120.FormCreate(Sender: TObject);
begin
  InDateDTP.Date := Now;
  Cntl_Code_Select;
end;

procedure TSFrm_5120.Cntl_Code_Select;
var
  StrQry : String;
  StrCode : String;
begin
  ItemCodeMed.Clear;
  StrQry := ' Select distinct(MAST_CODE) MAST_CODE From STK_MIMAST (NOLOCK) ';
  StrQry := StrQry + '  order by   MAST_CODE ';
  With DispQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    if Recordcount = 0 Then Exit;
    While Not Eof Do Begin
      StrCode := FieldByName('MAST_CODE').AsString;
      ItemCodeMed.Items.Add(StrCode);
      Next;
    End;
  End;

  PgubnEd.Clear;
  StrQry := ' Select distinct(PG_CODE) PG_CODE From STK_PGUBN (NOLOCK) ';
  StrQry := StrQry + ' ORDER BY PG_CODE ';
  With DispQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    if Recordcount = 0 Then Exit;
    While Not Eof Do Begin
      StrCode := FieldByName('PG_CODE').AsString;
      PgubnEd.Items.Add(StrCode);
      Next;
    End;
  End;
end;

procedure TSFrm_5120.ItemCodeMedChange(Sender: TObject);
var
  Strcode : String;
begin
  Strcode := ItemCodeMed.Text;

  StrQry := ' Select MAST_NAME From STK_MIMAST (NOLOCK) Where MAST_CODE = '''+StrCode+''' ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    NAMeEd.Text := FieldByName('MAST_NAME').AsString;
  End;
end;

procedure TSFrm_5120.PgubnEdChange(Sender: TObject);
var
  Strcode : String;
begin
  Strcode := PgubnEd.Text;

  StrQry := ' Select PG_NAME FROM STK_PGUBN (NOLOCK) Where PG_CODE = '''+StrCode+''' ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    PNAMeEd.Text := FieldByName('PG_NAME').AsString;
  End;
end;    

procedure TSFrm_5120.ItemCodeMedKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then QtyEd.SetFocus;
end;

procedure TSFrm_5120.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
   var_Msg := ' 정말로 확정 합니까.?';
  if Not WinLib_ConfirmForm( var_Msg ) then Exit;

  IF PltNoEd.Text = '' Then
  Begin
    WinLib_ErrorForm(' 파레트 번호를 입력 하십시요.....' );
    PltNoEd.SetFocus;   Exit;
  End;

  IF FlagCB.Text = '' Then
  Begin
    WinLib_ErrorForm(' 저장위치 상태를 입력 하십시요.....' );
    FlagCB.SetFocus;   Exit;
  End;
        

  IF ItemCodeMed.Text = '' Then
  Begin
    WinLib_ErrorForm(' 자재코드를 입력 하십시요.....' );
    ItemCodeMed.SetFocus;   Exit;
  End;

  IF QtyEd.Text = '' Then
  Begin
    WinLib_ErrorForm(' 재고 수량을 입력 하십시요.....' );
    QtyEd.SetFocus;   Exit;
  End;

  IF RQtyEd.Text = '' Then RQtyEd.Text := '0';
  IF QtyEd.Text  = '' Then QtyEd.Text := '0';

  If Bol_Insert Then Insert_Code
  else if Bol_Update Then Update_Code;

end;
/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
procedure TSFrm_5120.Insert_Code;
var
  StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrQty, StrRQty : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];
begin
  sys_datetime  :=  Formatdatetime('yyyymmddhhnnss', now);
  s_date        :=  copy(sys_datetime, 1, 8);
  s_time        :=  copy(sys_datetime, 9, 6);   

  s_itemcode := ItemCodeMed.Text;

  StrFlag := Copy(FlagCB.Text, 1, 1);

  if  (StrFlag = '0') then  StrFlag := '1';


  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;

  StrQty := QtyEd.Text;
  StrRQty := RQtyEd.Text;

  While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;
  While Pos(',', StrRQty ) > 0 Do Begin Delete(StrRQty, Pos(',', StrRQty), 1); End;

  if  Length(StrQty) = 0   then StrQty  := '0';
  if  Length(StrRQty) = 0  then StrRQty := '0';

  StrLoca := LocaMEd.Text;

  StrQry := ' Update STK1_MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG = '''+StrFlag+''', LSTK_PLTID = '''+PltnoEd.Text+''', ';
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''', LSTK_INTIME = '''+s_time+''', ';
  StrQry := StrQry + ' LSTK_TTL_QTY = LSTK_TTL_QTY + Convert(Numeric,'''+StrQty+''') ';
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


  StrQry := ' INSERT INTO STK1_MISUBK ';
  StrQry := StrQry + ' (SUBK_PLTID,   SUBK_CODE,   SUBK_LOCA,    SUBK_FLAG,   ';
  StrQry := StrQry + '  SUBK_QTY,     SUBK_RQTY,     ';
  StrQry := StrQry + '  SUBK_PGUBN,   SUBK_INDATE,  SUBK_INTIME )  ';
  StrQry := StrQry + ' values ( '''+PltnoEd.Text+''',  '''+s_itemcode+''',   '''+StrLoca+''',     '''+StrFlag+''', ';
  StrQry := StrQry + '          Convert(Numeric,'''+StrQty+'''),  Convert(Numeric,'''+StrRQty+'''),     ';
  StrQry := StrQry + '          '''+PgubnEd.Text+''',    '''+StrDate+''', '''+s_time+''' ) ';
  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
       WinLib_ErrorForm('저장위치(MISUBK)  ' + ItemCodeMed.Text + ' 등록 에러!!!! '  );
       showmessage(StrQry);
       Exit;
    End;
    MesgStsBar.SimpleText := '저장위치 ' + ItemCodeMed.Text + '를 등록 하였습니다...';
  End;
  Close;
end;
/////////////////////////////////////////////////////////////
////           Update
/////////////////////////////////////////////////////////////
procedure TSFrm_5120.Update_Code;
var
  NumStockRQty, NumStockQty, NumRQty, NumQty : Real;
  s_div, StrDate, StrLoca, StrFlag, s_itemcode : String;
  StrRQty, StrQty, StrStockQty, StrStockRQty   : String;
  StrCode, StrLotno, StrPltno,  StrCvcod, StrGubun, StrJpno, Updt_sw, StrDepot : String;

  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];

begin
  StrLoca   := LocaMEd.Text;
  StrPltNO  := PltnoEd.Text;
  Strcode   := ItemCodeMed.Text;
  StrFlag   := Copy(FlagCB.Text, 1, 1);

  StrDate := DateToStr(InDateDTP.Date);
  While Pos('-', StrDate ) > 0 Do Begin Delete(StrDate, Pos('-', StrDate), 1); End;


  StrQry := ' Select SUBK_QTY, SUBK_RQTY From  STK1_MISUBK (NOLOCK) ';
  StrQry := StrQry + ' Where SUBK_LOCA = '''+StrLoca+''' And SUBK_PLTID = '''+StrPltNO+''' ';
  StrQry := StrQry + ' And SUBK_CODE = '''+StrCode+'''   ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    StrStockQty  := FieldByName('SUBK_QTY').AsString;
    StrStockRQTY := FieldByName('SUBK_RQTY').AsString;
  End;  


  StrRQty   := RQtyEd.Text;
  StrQty    := QtyEd.Text;
  StrGubun  := PgubnEd.Text;


  While Pos(',', StrRQTY ) > 0 Do Begin Delete(StrRQTY, Pos(',', StrRqty), 1); End;
  While Pos(',', StrQty ) > 0 Do Begin Delete(StrQty, Pos(',', StrQty), 1); End;

  IF StrStockQty = '' Then StrStockQty := '0';
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

  StrStockQty := FloatToStr(NumStockQty);
  StrStockRQty := FloatToStr(NumStockRQty);

  StrQry := ' update stk1_misubk set   ';
  StrQry := StrQry + '        subk_flag            =  '''+StrFlag+''',  ';
  StrQry := StrQry + '        subk_RQty            =  Convert(Numeric,'''+StrRQty+'''),  ';
  StrQry := StrQry + '        subk_qty             =  Convert(Numeric,'''+StrQty +'''),  ';
  StrQry := StrQry + '        subk_pgubn           =  '''+StrGubun+''', ';
  StrQry := StrQry + '        subk_indate          =  '''+StrDate+'''  ';
  StrQry := StrQry + ' where subk_pltid  = '''+PltnoEd.Text+'''    and  subk_code  = '''+Strcode+'''    ';
  StrQry := StrQry + '       and subk_loca = '''+StrLoca+'''  ';

  With UpdtQuery Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('저장위치(MISUBK) ' + ItemCodeMed.Text + ' 수정 에러!!!! ');
      Exit;
    End;
     MesgStsBar.SimpleText := '저장위치 ' + ItemCodeMed.Text + '를 수정 하였습니다...';
  End;
  Close;

  StrQry := ' Select Sum(SUBK_RQty) SUBK_RQty, SUM(SUBK_QTY) SUBK_QTY From STK1_MISUBK (NOLOCK) Where SUBK_LOCA = '''+StrLoca+''' ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;    

    StrStockQty := FieldByName('SUBK_QTY').asString;
  End;

  StrQry := ' Update STK1_MILSTK Set ';
  StrQry := StrQry + ' LSTK_TTL_QTY = Convert(NUmeric,'''+StrStockQty+'''), ';
  StrQry := StrQry + ' LSTK_INDATE = '''+StrDate+''' ';
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

procedure TSFrm_5120.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TSFrm_5120.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_5120.FormDestroy(Sender: TObject);
begin
  SFrm_5120 := Nil;
end;   

end.


unit Frm2100;

interface      

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DBGrids, Db, DBTables,
  DBCtrls, Mask, ADODB;

type
  TFrm_2100 = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    I11FRadioButton: TRadioButton;
    O11FRadioButton: TRadioButton;
    A11FRadioButton: TRadioButton;
    N11FRadioButton: TRadioButton;
    GroupBox5: TGroupBox;
    I21FRadioButton: TRadioButton;
    O21FRadioButton: TRadioButton;
    A21FRadioButton: TRadioButton;
    N21FRadioButton: TRadioButton;
    MesgStatusBar: TStatusBar;
    Panel2: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    UpdateBitBtn1: TSpeedButton;
    ExitBitBtn: TSpeedButton;
    GroupBox1: TGroupBox;
    I31FRadioButton: TRadioButton;
    O31FRadioButton: TRadioButton;
    A31FRadioButton: TRadioButton;
    N31FRadioButton: TRadioButton;
    Query1: TADOQuery;
    GroupBox8: TGroupBox;
    serialupBitBtn: TSpeedButton;
    IindexMaskEdit: TMaskEdit;
    OindexMaskEdit: TMaskEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    RindexMaskEdit: TMaskEdit;
    Panel7: TPanel;
    EindexMaskEdit: TMaskEdit;
    StartBitBtn: TSpeedButton;
    GroupBox9: TGroupBox;
    UpdateBitBtn2: TSpeedButton;
    GroupBox13: TGroupBox;
    CV1RadioButton: TRadioButton;
    CV2RadioButton: TRadioButton;
    GroupBox14: TGroupBox;
    CV3RadioButton: TRadioButton;
    CV4RadioButton: TRadioButton;
    GroupBox15: TGroupBox;
    CV5RadioButton: TRadioButton;
    CV6RadioButton: TRadioButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure UpdateBitBtn1Click(Sender: TObject);    
    procedure FormDestroy(Sender: TObject);
    procedure serialupBitBtnClick(Sender: TObject);
    procedure UpdateBitBtn2Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_2100: TFrm_2100;

implementation

USES  WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.DFM}


procedure TFrm_2100.FormCreate(Sender: TObject);
begin
  if (jj_kind <> '50') then
  begin
    UpdateBitBtn1.Visible    := False;
    serialupBitBtn.Visible   := False;
  end;
  StartBitBtnClick(self);
end;

procedure TFrm_2100.StartBitBtnClick(Sender: TObject);
begin
  Query1.Close;
  Query1.SQL.clear;
  Query1.SQL.Add (' select * from t2tbstat (nolock) ');
  Query1.SQL.Add (' where  stat_pswd = ''JPLS'' ');
  Query1.open; 

  case StrToInt(Query1.FieldByName('STAT_SC1IO').AsString) of
    1 : I11FRadioButton.Checked := True;
    2 : O11FRadioButton.Checked := True;
    3 : A11FRadioButton.Checked := True;
    0 : N11FRadioButton.Checked := True;
  end;
  case StrToInt(Query1.FieldByName('STAT_SC2IO').AsString) of
    1 : I21FRadioButton.Checked := True;
    2 : O21FRadioButton.Checked := True;
    3 : A21FRadioButton.Checked := True;
    0 : N21FRadioButton.Checked := True;
  end;
  case StrToInt(Query1.FieldByName('STAT_SC3IO').AsString) of
    1 : I31FRadioButton.Checked := True;
    2 : O31FRadioButton.Checked := True;
    3 : A31FRadioButton.Checked := True;
    0 : N31FRadioButton.Checked := True;
  end;

  case StrToInt(Query1.FieldByName('STAT_CV1').AsString) of
    1 : CV1RadioButton.Checked := True;
    0 : CV1RadioButton.Checked := True;
  end;
  case StrToInt(Query1.FieldByName('STAT_CV2').AsString) of
    1 : CV2RadioButton.Checked := True;
    0 : CV2RadioButton.Checked := False;
  end;
  case StrToInt(Query1.FieldByName('STAT_CV3').AsString) of
    1 : CV3RadioButton.Checked := True;
    0 : CV3RadioButton.Checked := False;
  end;
  case StrToInt(Query1.FieldByName('STAT_CV4').AsString) of
    1 : CV4RadioButton.Checked := True;
    0 : CV4RadioButton.Checked := False;
  end;
  case StrToInt(Query1.FieldByName('STAT_CV5').AsString) of
    1 : CV5RadioButton.Checked := True;
    0 : CV5RadioButton.Checked := False;
  end;
  case StrToInt(Query1.FieldByName('STAT_CV6').AsString) of
    1 : CV6RadioButton.Checked := True;
    0 : CV6RadioButton.Checked := False;
  end;

  IindexMaskEdit.Text  := IntToStr(Query1.FieldByName('STAT_IINDX').AsInteger);
  OindexMaskEdit.Text  := IntToStr(Query1.FieldByName('STAT_OINDX').AsInteger);
  RindexMaskEdit.Text  := IntToStr(Query1.FieldByName('STAT_RINDX').AsInteger);
  EindexMaskEdit.Text  := IntToStr(Query1.FieldByName('STAT_EINDX').AsInteger);

  MesgStatusBar.SimpleText := 'MESG:1건 조회완료 하였습니다.!!';
End;




procedure TFrm_2100.UpdateBitBtn1Click(Sender: TObject);
var
  l_sc1io, l_sc2io,l_sc3io, l_sc4io, l_sc4eo  : string[1];
  var_Msg : String;
begin
/////////  chk proc start
  if      I11FRadioButton.Checked = True then l_sc1io := '1'
  else if O11FRadioButton.Checked = True then l_sc1io := '2'
  else if A11FRadioButton.Checked = True then l_sc1io := '3'
  else if N11FRadioButton.Checked = True then l_sc1io := '0';

  if      I21FRadioButton.Checked = True then l_sc2io := '1'
  else if O21FRadioButton.Checked = True then l_sc2io := '2'
  else if A21FRadioButton.Checked = True then l_sc2io := '3'
  else if N21FRadioButton.Checked = True then l_sc2io := '0';

  if      I31FRadioButton.Checked = True then l_sc3io := '1'
  else if O31FRadioButton.Checked = True then l_sc3io := '2'
  else if A31FRadioButton.Checked = True then l_sc3io := '3'
  else if N31FRadioButton.Checked = True then l_sc3io := '0';


 /////////  chk proc end
  var_Msg := '정말 수정 하시겠습니까?';
  IF WinLib_ConfirmForm( var_Msg ) Then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbstat  set  ');
      Query1.SQL.Add(' stat_sc1io  = '''+l_sc1io+''',   stat_sc2io  = '''+l_sc2io+''',  ');
      Query1.SQL.Add(' stat_sc3io  = '''+l_sc3io+''' ');
      Query1.SQL.Add(' where stat_pswd = ''JPLS'' ');
      Query1.ExecSQL;
      StartBitBtnClick(self);
      MesgStatusBar.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2100.UpdateBitBtn2Click(Sender: TObject);
var
  l_cv1, l_cv2, l_cv3, l_cv4, l_cv5, l_cv6 : string[1];
  var_Msg : String;
begin
/////////  chk proc start

  if  Cv1RadioButton.Checked = True then   l_cv1 := '1' else  l_cv1 := '0';
  if  Cv2RadioButton.Checked = True then   l_cv2 := '1' else  l_cv2 := '0';
  if  Cv3RadioButton.Checked = True then   l_cv3 := '1' else  l_cv3 := '0';
  if  Cv4RadioButton.Checked = True then   l_cv4 := '1' else  l_cv4 := '0';
  if  Cv5RadioButton.Checked = True then   l_cv5 := '1' else  l_cv5 := '0';
  if  Cv6RadioButton.Checked = True then   l_cv6 := '1' else  l_cv6 := '0';


 /////////  chk proc end
  var_Msg := '정말 수정 하시겠습니까?';
  IF WinLib_ConfirmForm( var_Msg ) Then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbstat  set  ');
      Query1.SQL.Add(' stat_cv1  = '''+l_cv1+''',   stat_cv2  = '''+l_cv2+''',  ');
      Query1.SQL.Add(' stat_cv3  = '''+l_cv3+''',   stat_cv4  = '''+l_cv4+''', ');
      Query1.SQL.Add(' stat_cv5  = '''+l_cv5+''',   stat_cv6  = '''+l_cv6+''' ');
      Query1.SQL.Add(' where stat_pswd = ''JPLS'' ');
      Query1.ExecSQL;
      StartBitBtnClick(self);
      MesgStatusBar.SimpleText := 'MESG:수정을 완료 하였습니다.!!';
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;


procedure TFrm_2100.serialupBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  if iindexMaskEdit.Text < '0000' then
  begin
    ShowMessage('작업순번을 "0000" 이상을 입력 하십시오.!!');
    exit;
  end;

  if OindexMaskEdit.Text < '0000' then
  begin
    ShowMessage('작업순번을 "0000" 이상을 입력 하십시오.!!');
    exit;
  end;
/////////  chk proc end
  var_Msg := '정말 수정 하시겠습니까?';
  IF WinLib_ConfirmForm( var_Msg ) Then
  begin
    try
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(' update t2tbstat set  ');
      Query1.SQL.Add(' stat_iindx = Convert(Numeric,'''+iindexMaskEdit.Text+'''), ');
      Query1.SQL.Add(' stat_oindx = Convert(Numeric,'''+OindexMaskEdit.Text+'''), ');
      Query1.SQL.Add(' stat_rindx = Convert(Numeric,'''+RindexMaskEdit.Text+'''), ');
      Query1.SQL.Add(' stat_eindx = Convert(Numeric,'''+EindexMaskEdit.Text+''') ');
      Query1.SQL.Add(' where stat_pswd = ''JPLS'' ');
      Query1.ExecSQL;
      StartBitBtnClick(self);
      MesgStatusBar.SimpleText := 'MESG:Serial No 수정을 완료 하였습니다.!!';
    except
      on E : EDBEngineError do
        if   E.Errors[1].ErrorCode = 13059 then ShowMessage('기존에 삭제 되었습니다.!!')
        else showmessage('Oracle DB Error.!!');
    end;
  end;
end;



procedure TFrm_2100.PrintBitBtnClick(Sender: TObject);
begin
  PrintScale := poPrintToFit;
  Print;
end;

procedure TFrm_2100.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_2100.FormDestroy(Sender: TObject);
begin
   Frm_2100 := Nil;
end;

procedure TFrm_2100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
     



end.

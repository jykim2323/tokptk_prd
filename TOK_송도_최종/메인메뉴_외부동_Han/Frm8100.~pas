unit Frm8100;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DBGrids, Db, DBTables, DBCtrls, Mask,
  ADODB;


type
  TFrm_8100 = class(TForm)  
    Panel1: TPanel;
    Panel2: TPanel;
    ExitBitBtn: TSpeedButton;
    Panel3: TPanel;
    Memo1: TMemo;
    Panel4: TPanel;
    Query1: TADOQuery;
    Query1INPT_PLTNO: TStringField;
    Query1INPT_CODE: TStringField;
    Query1INPT_GUBUN: TStringField;
    Query1INPT_QTY: TIntegerField;
    Query1INPT_WEIGHT: TBCDField;
    Query1INPT_JOB_FLAG: TStringField;
    Query1MAST_NAME: TStringField;
    Query1MAST_UNIT: TStringField;
    Query2: TADOQuery;
    Confirm1BitBtn: TSpeedButton;
    DateTimePicker1: TDateTimePicker;
    ConfirmBitBtn1: TSpeedButton;
    Panel10: TPanel;
    DateTimePicker4: TDateTimePicker;
    DateTimePicker5: TDateTimePicker;
    ConfirmBitBtn4: TSpeedButton;
    ConfirmBitBtn5: TSpeedButton;
    Panel11: TPanel;
    ConfirmBitBtn6: TSpeedButton;
    DateTimePicker6: TDateTimePicker;
    Panel6: TPanel;
    Panel5: TPanel;
    Shape2: TShape;
    Label1: TLabel;
    Panel7: TPanel;
    DateTimePicker2: TDateTimePicker;
    ConfirmBitBtn2: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConfirmBitBtn1Click(Sender: TObject);  
    procedure ConfirmBitBtn4Click(Sender: TObject);
    procedure ConfirmBitBtn5Click(Sender: TObject);
    procedure ConfirmBitBtn6Click(Sender: TObject);
    procedure ConfirmBitBtn2Click(Sender: TObject);
    

  private
    { Private declarations }
  public

  end;

var
  Frm_8100: TFrm_8100;
  chk_ok  : integer;
  s_date, ls_date, ls_chasu  : string;

implementation

uses DBset, WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.DFM}


procedure TFrm_8100.FormCreate(Sender: TObject);
begin
  if FrmProgress.jj_kind = '50' then
  begin
   ConfirmBitBtn1.Enabled := True;  
   ConfirmBitBtn4.Enabled := True;
   ConfirmBitBtn5.Enabled := True;
   ConfirmBitBtn6.Enabled := True;
  end
  else
  begin
   ConfirmBitBtn1.Enabled := False;
   ConfirmBitBtn4.Enabled := False;
   ConfirmBitBtn5.Enabled := False;
   ConfirmBitBtn6.Enabled := False;
  end;

  DateTimePicker1.Date := Now - 90;
  DateTimePicker2.Date := Now - 90; 
  DateTimePicker4.Date := Now - 90;
  DateTimePicker5.Date := Now - 90;
  DateTimePicker6.Date := Now - 90;
end;

procedure TFrm_8100.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;


procedure TFrm_8100.FormDestroy(Sender: TObject);
begin
       Frm_8100 := Nil;
end;

procedure TFrm_8100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_8100.ConfirmBitBtn1Click(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := '자동창고입출고 작업이 없는경우에만 사용해야합니다.' + #13#10 +  #13#10 +'다시한번 확인 후 하십시요!!!';
  if Not WinLib_ConfirmForm(var_Msg) then  Exit;

  var_Msg := '재고예약 데이터를 리셋 하시겠습니까?';
  if Not WinLib_ConfirmForm(var_Msg) then  Exit;


  s_date := FormatDateTime( 'YYYYMMDD', DateTimePicker1.Date );

 try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM T2MISUBK WHERE SUBK_WGT <= 0 ');
   Query1.ExecSQL;
  except
   exit;
  end;

  try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' UPDATE T2MISUBK SET SUBK_FLAG = ''1'', SUBK_WGT = ''0'', SUBK_RWGT = ''0'' WHERE SUBK_FLAG IN (''Y'') ');
   Query1.ExecSQL;
  except
    Memo1.Font.Color := ClRed;
    Memo1.Lines.Add( 'T2MISUBK 데이터 리셋에러.!!');
   exit;
  end;
  Memo1.Font.Color := ClBlue;
  Memo1.Lines.Add( '1) 재고예약 데이터 리셋 정리를 완료하였습니다.!!');
end;


procedure TFrm_8100.ConfirmBitBtn2Click(Sender: TObject);
var
  var_Msg : String;
begin
  s_date := FormatDateTime( 'YYYY-MM-DD', DateTimePicker2.Date );
  var_Msg := s_date + '  전일재고 데이터를 삭제 하시겠습니까?';
  if Not WinLib_ConfirmForm(var_Msg) then   Exit;

  s_date := FormatDateTime( 'YYYYMMDD', DateTimePicker2.Date );


 try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM T2MIJEGO WHERE JEGO_DATE <= '''+s_date+'''  ');
   Query1.ExecSQL;

   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM T2MISTOK WHERE STOK_DATE <= '''+s_date+'''  ');
   Query1.ExecSQL;
  except
   Memo1.Font.Color := ClRed;
   Memo1.Lines.Add( 'JEGO_DATE 에러이력 삭제에러.!!');
   exit;
  end;


  Memo1.Font.Color := ClBlue;
  Memo1.Lines.Add( '2) 전일재고  데이터 정리를 완료하였습니다.!!');
end;



procedure TFrm_8100.ConfirmBitBtn4Click(Sender: TObject);
var
  var_Msg : String;
begin
  s_date := FormatDateTime( 'YYYY-MM-DD', DateTimePicker4.Date );

  var_Msg := s_date +'  이전 입고이력 데이터를 삭제 하시겠습니까?';
  if Not WinLib_ConfirmForm(var_Msg) then   Exit;

  s_date := FormatDateTime( 'YYYYMMDD', DateTimePicker4.Date );

  try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM T2MIINPT WHERE INPT_INDATE <= '''+s_date+'''  ');
   Query1.ExecSQL;
  except
    Memo1.Font.Color := ClRed;
    Memo1.Lines.Add( 'MIINPTA 에러이력 삭제에러.!!');
   exit;
  end;
  Memo1.Font.Color := ClBlue;
  Memo1.Lines.Add( '3) 입고이력 데이터 정리를 완료하였습니다.!!');
end;

procedure TFrm_8100.ConfirmBitBtn5Click(Sender: TObject);
var
  var_Msg : String;
begin
   s_date := FormatDateTime( 'YYYY-MM-DD', DateTimePicker5.Date );
  var_Msg := s_date + '  이전 출고이력 데이터를 삭제 하시겠습니까?';
  if Not WinLib_ConfirmForm(var_Msg) then   Exit;

  s_date := FormatDateTime( 'YYYYMMDD', DateTimePicker5.Date );


  try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM T2MIOUPT WHERE OUPT_DATE <= '''+s_date+'''  ');
   Query1.ExecSQL;
  except
    Memo1.Font.Color := ClRed;
    Memo1.Lines.Add( 'MIOUPTB 에러이력 삭제에러.!!');
   exit;
  end;
  Memo1.Font.Color := ClBlue;
  Memo1.Lines.Add( '4) 출고이력 데이터 정리를 완료하였습니다.!!');
end;


procedure TFrm_8100.ConfirmBitBtn6Click(Sender: TObject);
var
  var_Msg : String;
begin
  s_date := FormatDateTime( 'YYYY-MM-DD', DateTimePicker6.Date );

  var_Msg := s_date + '  이전 에러이력 데이터를 삭제 하시겠습니까?';
  if Not WinLib_ConfirmForm(var_Msg) then   Exit;

   s_date := FormatDateTime( 'YYYYMMDD', DateTimePicker6.Date );


  try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM T2TIMESG WHERE SUBSTRING(MESG_DT,1,8) <= '''+s_date+'''  ');
   Query1.ExecSQL;
  except
    Memo1.Font.Color := ClRed;
    Memo1.Lines.Add( 'T2TIMESG 에러이력 삭제에러.!!');
    exit;
  end;
  Memo1.Font.Color := ClBlue;
  Memo1.Lines.Add( '5) 에러이력 데이터 정리를 완료하였습니다.!!');
end;   

end.


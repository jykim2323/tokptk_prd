unit Frm9400;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DBGrids, Db, DBTables, DBCtrls, Mask,
  ADODB;


type
  TFrm_9400 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    Panel3: TPanel;
    Bevel1: TBevel;
    DateTimePicker1: TDateTimePicker;
    ConfirmBitBtn: TSpeedButton;
    Memo1: TMemo;
    Panel4: TPanel;
    Panel9: TPanel;
    Query1: TADOQuery;
    Query2: TADOQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miinpt_delete_proc;
    procedure mioupt_delete_proc;
    procedure timesg_delete_proc;  
  private
    { Private declarations }
  public

  end;

var
  Frm_9400: TFrm_9400;
  chk_ok  : integer;
  s_date, ls_date, ls_chasu  : string;

implementation

uses DBset, WinLib, FrmPrompt, FrmError, Frm8100;

{$R *.DFM}


procedure TFrm_9400.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := Now; 
end;

procedure TFrm_9400.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_9400.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := '입출고 이력을 삭제 하시겠습니까?';
  if WinLib_ConfirmForm(var_Msg) then
  begin
    s_date := FormatDateTime( 'YYYYMMDD', DateTimePicker1.Date );
    miinpt_delete_proc;
    mioupt_delete_proc;
    timesg_delete_proc;
  end;
end;


procedure TFrm_9400.miinpt_delete_proc;
begin
  try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM STK1_MIINPT WHERE INPT_INDATE <= '''+s_date+'''  ');
   Query1.ExecSQL;
  except
   exit;
  end;

  Memo1.Lines.Add( '1) 입고 HISTORY 정리를 완료하였습니다.!!');
end;


procedure TFrm_9400.mioupt_delete_proc;
begin
  try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM STK1_MIOUPT WHERE OUPT_DATE <= '''+s_date+''' ');
   Query1.ExecSQL;
  except
   exit;
  end;

  Memo1.Lines.Add( '2) 출고 HISTORY 정리를 완료하였습니다.!!');
end;

procedure TFrm_9400.timesg_delete_proc;
begin
  try
   Query1.Close;
   Query1.SQL.Clear;
   Query1.SQL.Add(' DELETE FROM STK1_TBMESG WHERE Substring(mesg_dt,1,8) <= '''+s_date+''' ');
   Query1.ExecSQL;
  except
   exit;
  end;

  Memo1.Lines.Add( '3) 에러이력 정리를 완료하였습니다.!!');
end;


procedure TFrm_9400.FormDestroy(Sender: TObject);
begin
       Frm_9400 := Nil;
end;

procedure TFrm_9400.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end; 

end.


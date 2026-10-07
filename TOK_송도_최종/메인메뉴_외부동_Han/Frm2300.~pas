unit Frm2300;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, Mask,
  ADODB;

type
  TFrm_2300 = class(TForm)
    Panel2: TPanel;
    Shape1: TShape;
    Label13: TLabel;
    ExitBitBtn1: TSpeedButton;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DeleteBitBtn: TSpeedButton;
    startBitBtn: TSpeedButton;
    Query1: TADOQuery;
    UpdtQuery: TADOQuery;
    Query1UPDT_INDEX: TStringField;
    Query1UPDT_LOCA: TStringField;
    Query1UPDT_JOB: TStringField;
    Query1UPDT_DATE: TStringField;
    Query1UPDT_TIME: TStringField;
    procedure ExitBitBtn1Click(Sender: TObject); 

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure StartBitBtnClick(Sender: TObject); 
    procedure DeleteBitBtnClick(Sender: TObject);

    procedure DeleteExecUpdate; 
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_2300: TFrm_2300;
  p_step: String[02];
  p_u_cnt: Integer;
  ls_index : string[13];


implementation

uses DBSet, WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.DFM}

procedure TFrm_2300.FormCreate(Sender: TObject);
begin
  if (jj_kind <> '50') then
  begin
    DeleteBitBtn.Visible    := False;   
  end;
  StartBitBtnClick(Self);
end;

procedure TFrm_2300.StartBitBtnClick(Sender: TObject);
begin
  with Query1 do
  begin
    DisableControls;
    Close;
    SQL.clear;
    SQL.Add(' SELECT   updt_index, updt_job, updt_loca,  ');
    SQL.Add('          updt_date, updt_time  FROM  t2tiupdt (nolock) ');
    SQL.Add(' order by updt_index ');
    Open;
    EnableControls;
  end;  
end;

procedure TFrm_2300.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  ls_index := Query1.FieldByName('updt_index').AsString;
end;

procedure TFrm_2300.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := '정말로 해당데이터 예약을 삭제합니까.??';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    DeleteExecUpdate;
  end;
end;

procedure TFrm_2300.DeleteExecUpdate;
var
  li_updt_cnt: Integer; 
begin
try
  p_step := '01';
  with UpdtQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' select count(*) from t2tiupdt (nolock) ');
    SQL.Add(' where  updt_index = '''+ls_index+''' ');
    SQL.Add(' order by updt_index ');
    Open;
  end;
  li_updt_cnt := UpdtQuery.Fields[0].AsInteger;
  if (li_updt_cnt <= 0) then begin WinLib_ErrorForm('이미 삭제 되었습니다..!!');  exit;  end;

  //begin ShowMessage('이미 삭제 되었습니다..!!');  exit;  end;

    p_step := '02';
    with UpdtQuery do
    begin
      SQL.Clear;
      SQL.Add(' delete from t2tiupdt where updt_index = '''+ls_index+''' ');
      ExecSQL;
    end;

    p_step := '88';
  except
    On E:Exception do
    begin
      WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
    end;
  end;
  StartBitBtnClick( Self );
end;


procedure TFrm_2300.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_2300.FormDestroy(Sender: TObject);
begin
  Frm_2300 := Nil;
end;

procedure TFrm_2300.ExitBitBtn1Click(Sender: TObject);
begin
  close;
end; 


end.

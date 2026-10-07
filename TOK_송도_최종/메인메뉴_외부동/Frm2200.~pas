unit Frm2200;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, Mask,
  ADODB;

type
  TFrm_2200 = class(TForm)
    Panel2: TPanel;
    Shape1: TShape;
    Label13: TLabel;
    ExitBitBtn1: TSpeedButton;
    Panel1: TPanel;
    Bevel1: TBevel;
    DBGrid1: TDBGrid;
    Panel7: TPanel;
    StackerCB: TComboBox;
    Panel6: TPanel;
    BQtyPanel: TPanel;
    DataSource1: TDataSource;
    DeleteBitBtn: TSpeedButton;
    startBitBtn: TSpeedButton;
    Query1: TADOQuery;
    UpdtQuery: TADOQuery;
    Query1SCHE_SC: TStringField;
    Query1SCHE_INDEX: TStringField;
    Query1SCHE_JOBGUBUN: TStringField;
    Query1SCHE_LOCA: TStringField;
    Query1SCHE_DATE: TStringField;
    Query1SCHE_TIME: TStringField;
    Query1SCHE_EMER: TStringField;
    Query1SCHE_WSNO: TStringField;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    IndexEdit: TMaskEdit;
    Label3: TLabel;
    WsnoCB: TComboBox;
    UpdateBitBtn3: TSpeedButton;
    procedure ExitBitBtn1Click(Sender: TObject); 

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure StartBitBtnClick(Sender: TObject); 
    procedure DeleteBitBtnClick(Sender: TObject);

    procedure DeleteExecUpdate; 
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure StackerCBChange(Sender: TObject);
    procedure UpdateBitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_2200: TFrm_2200;
  p_step: String[02];
  p_u_cnt: Integer;
  ls_index : string;


implementation

uses DBSet, WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.DFM}

procedure TFrm_2200.FormCreate(Sender: TObject);
begin
  StackerCB.ItemIndex := 0;

  if (jj_kind <> '50') then
  begin
    DeleteBitBtn.Visible    := False;   
  end;

  StartBitBtnClick(Self);
end;

procedure TFrm_2200.StartBitBtnClick(Sender: TObject);
begin
  with Query1 do
  begin
    DisableControls;
    Close;
    SQL.clear;
    SQL.Add(' SELECT sche_sc, sche_index, sche_jobgubun, sche_loca,  ');
    SQL.Add('        sche_wsno, sche_emer, sche_date, sche_time  FROM  t2tische  (nolock) ');
//    SQL.Add(' where  sche_sc >= '''+StackerCB.Text+''' ');
    SQL.Add(' order by sche_index ');
    Open;
    EnableControls;
  end;
  BQtyPanel.Caption := IntToStr(Query1.RecordCount);
end;

procedure TFrm_2200.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  ls_index := Query1.FieldByName('sche_index').AsString;
  IndexEdit.Text := Query1.FieldByName('sche_index').AsString;
  WsnoCB.Text    := Query1.FieldByName('sche_Wsno').AsString;
end;

procedure TFrm_2200.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := '정말로 해당데이터 예약을 삭제합니까.??';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    DeleteExecUpdate;
  end;
end;

procedure TFrm_2200.DeleteExecUpdate;
var
  li_sche_cnt: Integer;   
  ls_loca : String[07];
begin
try
  p_step := '01';
  with UpdtQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' select count(*) from t2tische (nolock) ');
    SQL.Add(' where  sche_index = '''+ls_index+''' ');     
    Open;
  end;
  li_sche_cnt := UpdtQuery.Fields[0].AsInteger;
  if (li_sche_cnt <= 0) then  begin WinLib_ErrorForm('이미 삭제 되었습니다..!!');  exit;  end;

    p_step := '02';
    with UpdtQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' select sche_loca from t2tische (nolock) where  sche_index = '''+ls_index+''' ');
      Open;
    end;

    ls_loca  := UpdtQuery.FieldByName('sche_loca').AsString;

    p_step := '03';
    with UpdtQuery do
    begin
      SQL.Clear;
      SQL.Add(' update t2milstk set lstk_flag = ''1'' where lstk_loca = '''+ls_loca+''' ');
      ExecSQL;
    end;

    with UpdtQuery do
    begin
      SQL.Clear;
      SQL.Add(' update t2misubk set subk_flag = ''1'', subk_Rwgt = Convert(Numeric,''0'') where subk_loca = '''+ls_loca+''' ');
      ExecSQL;
    end;

    p_step := '04';
    with UpdtQuery do
    begin
      SQL.Clear;
      SQL.Add(' delete from t2tische where sche_index = '''+ls_index+''' ');
      ExecSQL;
    end;

    p_step := '88';
  except
    On E:Exception do
    begin
      WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
    end;
  end;
  StackerCB.ItemIndex := 0;
  StartBitBtnClick( Self );
end;


procedure TFrm_2200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_2200.FormDestroy(Sender: TObject);
begin
  Frm_2200 := Nil;
end;

procedure TFrm_2200.ExitBitBtn1Click(Sender: TObject);
begin
  close;
end; 


procedure TFrm_2200.StackerCBChange(Sender: TObject);
begin
  with Query1 do
  begin
    DisableControls;
    Close;
    SQL.clear;
    SQL.Add(' SELECT sche_sc, sche_index, sche_jobgubun, sche_loca, ');
    SQL.Add('        sche_wsno, sche_emer, sche_date, sche_time  FROM  t2tische (nolock) ');
    SQL.Add(' where  sche_sc = '''+StackerCB.Text+''' ');
    SQL.Add(' order by sche_index ');
    Open;
    EnableControls;
  end;
  BQtyPanel.Caption := IntToStr(Query1.RecordCount);
end;

procedure TFrm_2200.UpdateBitBtn3Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 출고ST 를 수정  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(IndexEdit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 입출고순번을 선택 하십시요.');
         Exit;
      End;

      IF  Trim(WsnoCB.Text) = '' then
      Begin
         WinLib_ErrorForm(' 출고 ST를 입력 하십시요...');  
         Exit;
      End;

     var_sql := 'Update t2tische Set ';
     var_sql := var_sql + ' SCHE_WSNO   = '''+WsnoCB.Text+'''    ';
     var_sql := var_sql + ' Where  sche_index = '''+IndexEdit.Text+'''  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('입출고순번 = ' + IndexEdit.Text + ' 수정 에러!!!! ');
         Exit;
      End;
     End;

    StartBitBtnClick( Self );
  end;
end;

end.

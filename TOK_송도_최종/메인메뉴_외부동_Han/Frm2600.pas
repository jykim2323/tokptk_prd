unit Frm2600;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, Mask,
  ADODB;

type
  TFrm_2600 = class(TForm)
    Panel2: TPanel;
    Shape1: TShape;
    Label13: TLabel;
    ExitBitBtn1: TSpeedButton;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    UpdtQuery: TADOQuery;
    SelRG: TRadioGroup;
    DeleteBitBtn: TSpeedButton;
    startBitBtn: TSpeedButton;
    Panel3: TPanel;
    TraknoCB: TComboBox;
    Panel4: TPanel;
    IndexEdit: TMaskEdit;
    Panel6: TPanel;
    PickEdit: TMaskEdit;
    Panel7: TPanel;
    GubCB: TComboBox;
    Panel9: TPanel;
    HogiCB: TComboBox;
    Panel10: TPanel;
    FlagCB: TComboBox;
    Panel11: TPanel;
    DateEdit: TMaskEdit;
    InsertBitBtn: TSpeedButton;
    UpdateBitBtn: TSpeedButton;
    Panel8: TPanel;
    TimeEdit: TMaskEdit;
    Timer1: TTimer;
    StopCB: TCheckBox;
    Query1TRAK_NO: TStringField;
    Query1TRAK_INDEX: TStringField;
    Query1TRAK_HOGI: TStringField;
    Query1TRAK_GUBUN: TStringField;
    Query1TRAK_FROM: TStringField;
    Query1TRAK_TO: TStringField;
    Query1TRAK_PICKING: TStringField;
    Query1TRAK_FLAG: TStringField;
    Query1TRAK_FLOOR: TStringField;
    Query1TRAK_DATE: TStringField;
    Query1TRAK_TIME: TStringField;
    Panel12: TPanel;
    FloorCB: TComboBox;
    Panel13: TPanel;
    FromCB: TComboBox;
    Panel14: TPanel;
    ToCB: TComboBox;
    procedure ExitBitBtn1Click(Sender: TObject); 

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure StartBitBtnClick(Sender: TObject); 
    procedure DeleteBitBtnClick(Sender: TObject);

    procedure DataSource1DataChange(Sender: TObject; Field: TField); 
    procedure InsertBitBtnClick(Sender: TObject);
    function f_get_sysdate_time1(): String;
    procedure UpdateBitBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure SelRGClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_2600: TFrm_2600;
  p_step, s_trakno: String[02];
  p_u_cnt: Integer;
  ls_index : string[5];
  StrQry : String;

implementation

uses WinLib, FrmPrompt, FrmError;

{$R *.DFM}

procedure TFrm_2600.FormCreate(Sender: TObject);
begin
  StartBitBtnClick(Self);
end;

procedure TFrm_2600.StartBitBtnClick(Sender: TObject);
var
 ls_sql : String;
begin
  ls_sql :=  '  select  TRAK_NO, TRAK_INDEX, TRAK_HOGI, TRAK_GUBUN, TRAK_FROM, TRAK_TO, TRAK_PICKING, ';
  ls_sql :=  ls_sql +   ' TRAK_FLAG, TRAK_FLOOR,  TRAK_DATE, TRAK_TIME  ';
  ls_sql :=  ls_sql +   '  from tbtrak   ';
  ls_sql :=  ls_sql +   '  where TRAK_NO NOT IN (''25'', ''26'', ''27'', ''28'', ''29'', ''30'') ';

  if (SelRg.ItemIndex  = 0) then
  begin
     ls_sql :=  ls_sql +  ' And (TRAK_NO BETWEEN ''03'' AND ''74'' ) ';
  end
  else  if (SelRg.ItemIndex  = 1) then
  begin
     ls_sql :=  ls_sql +  ' And (TRAK_NO BETWEEN ''03'' AND ''24'' )';
  end
  else  if (SelRg.ItemIndex  = 2) then
  begin
     ls_sql :=  ls_sql +  ' And (TRAK_NO BETWEEN ''31'' AND ''50'' )';
  end
  else  if (SelRg.ItemIndex  = 3) then
  begin
     ls_sql :=  ls_sql +  ' And (TRAK_NO BETWEEN ''51'' AND ''60'' )';
  end
  else  if (SelRg.ItemIndex  = 4) then
  begin
     ls_sql :=  ls_sql +  ' And (TRAK_NO BETWEEN ''61'' AND ''70'' )';
  end
  else  if (SelRg.ItemIndex  = 5) then
  begin
     ls_sql :=  ls_sql +  ' And (TRAK_NO BETWEEN ''71'' AND ''74'' )';
  end;

  ls_sql :=  ls_sql +  ' Order by  trak_no  ';

  With Query1 do Begin
    Close;
    SQL.clear;
    SQL.Add(ls_sql);
    Open;
  End;
end;

procedure TFrm_2600.Timer1Timer(Sender: TObject);
begin
  if StopCb.Checked = True then Exit;
  StartBitBtnClick(Self);
end;

procedure TFrm_2600.DataSource1DataChange(Sender: TObject; Field: TField);
begin

   FloorCB.Text   :=  Query1.FieldByName('TRAK_FLOOR').AsString;
   TraknoCB.Text  :=  Query1.FieldByName('TRAK_NO').AsString;
   IndexEdit.Text :=  Query1.FieldByName('TRAK_INDEX').AsString;
   FromCB.Text    :=  Query1.FieldByName('TRAK_FROM').AsString;
   ToCB.Text      :=  Query1.FieldByName('TRAK_TO').AsString;
   PickEdit.Text  :=  Query1.FieldByName('TRAK_PICKING').AsString;
   DateEdit.Text  :=  Query1.FieldByName('TRAK_DATE').AsString;
   TimeEdit.Text  :=  Query1.FieldByName('TRAK_TIME').AsString;
   GubCB.Text     :=  Query1.FieldByName('TRAK_GUBUN').AsString;
   FlagCB.Text    :=  Query1.FieldByName('TRAK_FLAG').AsString;
   HogiCB.Text    :=  Query1.FieldByName('TRAK_HOGI').AsString;

   s_trakno       :=  Query1.FieldByName('TRAK_NO').AsString;

end;

procedure TFrm_2600.InsertBitBtnClick(Sender: TObject);
var
  ls_sql, ls_date, StrMsg : String;
begin
  Timer1.Enabled := False;

  StrMsg := TraknoCB.Text + ' 구간의 데이타를 등록 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin Timer1.Enabled := True; Exit;    End;

  ls_date := f_get_sysdate_time1();
  ls_sql := ' UpDate TBTRAK Set ';
  ls_sql :=  ls_sql + ' TRAK_FLOOR = '''+FloorCB.Text+''', TRAK_INDEX = '''+IndexEdit.Text+''',  ';
  ls_sql :=  ls_sql + ' TRAK_FROM = '''+FromCB.Text+''', TRAK_TO = '''+ToCB.Text+''', TRAK_PICKING = '''+PickEdit.Text+''', ';
  ls_sql :=  ls_sql + ' TRAK_DATE = '''+DateEdit.Text+''', TRAK_TIME = '''+TimeEdit.Text+''', TRAK_GUBUN = '''+GubCB.Text+''', ';
  ls_sql :=  ls_sql + ' TRAK_FLAG = '''+FlagCB.Text+''',  ';
  ls_sql :=  ls_sql + ' Where TRAK_NO = '''+TraknoCB.Text+''' ';
  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
   showmessage('등록에러= ' + ls_sql);
  End;
   Timer1.Enabled := True;
   Query1.Requery;
end;

procedure TFrm_2600.UpdateBitBtnClick(Sender: TObject);
var
  ls_sql, ls_date, StrMsg : String;
begin
  Timer1.Enabled := False;

  StrMsg := TraknoCB.Text + ' 구간의 데이타를 수정 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin Timer1.Enabled := True; Exit;    End;
  ls_date := f_get_sysdate_time1();
  ls_sql := ' UpDate TBTRAK Set ';
  ls_sql :=  ls_sql + ' TRAK_FLOOR = '''+FloorCB.Text+''', TRAK_INDEX = '''+IndexEdit.Text+''',  ';
  ls_sql :=  ls_sql + ' TRAK_FROM = '''+FromCB.Text+''', TRAK_TO = '''+ToCB.Text+''', TRAK_PICKING = '''+PickEdit.Text+''', ';
  ls_sql :=  ls_sql + ' TRAK_DATE = '''+DateEdit.Text+''', TRAK_TIME = '''+TimeEdit.Text+''', TRAK_GUBUN = '''+GubCB.Text+''', ';
  ls_sql :=  ls_sql + ' TRAK_FLAG = '''+FlagCB.Text+''',  ';
  ls_sql :=  ls_sql + ' Where TRAK_NO = '''+TraknoCB.Text+''' ';
  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
   showmessage('수정에러= ' + ls_sql);
  End;
   Timer1.Enabled := True;
   Query1.Requery;
end;

procedure TFrm_2600.DeleteBitBtnClick(Sender: TObject);
var
  ls_sql, StrMsg : String;
begin
  Timer1.Enabled := False;

  StrMsg := TraknoCB.Text + ' 구간의 데이타를 삭제 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin Timer1.Enabled := True; Exit;    End;

  StrQry := ' UpDate TBTRAK Set ';
  StrQry := StrQry + ' TRAK_INDEX = Null, TRAK_HOGI = Null, TRAK_GUBUN = Null, TRAK_FLOOR = Null, TRAK_HIGH = NULL, ';
  StrQry := StrQry + ' TRAK_FROM = Null, TRAK_TO = Null, TRAK_PICKING = Null,  TRAK_FLAG = Null, ';
  StrQry := StrQry + ' TRAK_DATE = Null, TRAK_TIME = Null ';
  StrQry := StrQry + ' Where TRAK_NO = '''+TraknoCB.Text+''' ';
  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      ExecSQL;
    End;
  Except
  End;
   Timer1.Enabled := True;
   Query1.Requery;
end;


function TFrm_2600.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from dumm_tbl  ';
    With UpdtQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      ls_date    := Fields[0].AsString;
    End;

    ls := trim(ls_date);
    ls_date := Copy(ls, 1, 4)  + Copy(ls, 6, 2)  + Copy(ls, 9, 2) + Copy(ls, 12, 2) + Copy(ls, 15, 2) + Copy(ls, 18, 2);

    Result :=  ls_date;
end;

procedure TFrm_2600.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_2600.FormDestroy(Sender: TObject);
begin
  Frm_2600 := Nil;
end;

procedure TFrm_2600.ExitBitBtn1Click(Sender: TObject);
begin
  close;
end; 

procedure TFrm_2600.DBGrid1TitleClick(Column: TColumn);
var
   sFieldName, StrSql: string;
begin     
 if Column.Field.DataSet is TADOQuery then
 with TADOQuery(Column.Field.DataSet) do begin
   if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
     Sort := Column.FieldName + ' ASC'
   else
     Sort := Column.FieldName + ' DESC';
 end;
end;

procedure TFrm_2600.SelRGClick(Sender: TObject);
begin
    StartBitBtnClick(Self);
end;

end.

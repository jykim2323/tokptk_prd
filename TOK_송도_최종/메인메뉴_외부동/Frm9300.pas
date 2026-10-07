unit Frm9300;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, DBGrids, ExtCtrls, Buttons, StdCtrls, DB,
  DBTables, ADODB;

type
  TFrm_9300 = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Label13: TLabel;
    ExitBitBtn: TSpeedButton;
    DeleteBitBtn: TSpeedButton;
    Panel1: TPanel;
    StartBitBtn: TSpeedButton;
    DBGrid1: TDBGrid;
    DateTimePicker1: TDateTimePicker;
    Panel5: TPanel;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    Query2: TADOQuery;
    Query1mesg_dt: TStringField;
    Query1mesg_eloca: TStringField;
    Query1mesg_desc: TStringField;
    ExlBtn: TSpeedButton;
    RecNoEdit: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DeleteBitBtnClick(Sender: TObject); 
    procedure FormDestroy(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
//    procedure ExlBtnClick(Sender: TObject);
    procedure HogiCBChange(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_9300: TFrm_9300;
  s_date: string;
  s_hogi : string[1];
  s_desc: string[40];

  var_SelForm : TForm;
  var_Modal : Boolean;

implementation

Uses  WinLib, FrmPrompt, FrmError;
{$R *.DFM}

procedure TFrm_9300.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_9300.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := Now; 
  StartBitBtnClick(self);
end;

procedure TFrm_9300.StartBitBtnClick(Sender: TObject);
var
   ls_sql : String;
begin
  s_date := FormatDateTime('yyyymmdd', DateTimePicker1.Date);
  ls_sql :=  ' select * from  STK1_TBMESG  (NOLOCK) where Substring(mesg_dt,1,8) = '''+s_date+''' ';
  ls_sql := ls_sql + '  order by mesg_dt ';

  Query1.disableControls;
  Query1.Close;
  Query1.SQL.clear;
  Query1.SQL.Add (ls_sql);
  Query1.open;

  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);

  Query1.EnableControls;
end;

procedure TFrm_9300.HogiCBChange(Sender: TObject);
begin
  StartBitBtnClick(self);
end;

procedure TFrm_9300.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  s_date   := Query1.FieldByName('mesg_dt').AsString;
end;

procedure TFrm_9300.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin 
  var_Msg := '정말로 삭제 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    try
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add(' delete from  STK1_TBMESG ');
      Query2.SQL.Add(' where mesg_dt = '''+s_date+''' ');
      Query2.ExecSQL;
      StartBitBtnClick(self);
    except
      On E:Exception do
      begin
        WinLib_ErrorForm(E.Message+'로 인하여 에러가 발생 하였습니다');
      end;
    end;
  end;
end;

procedure TFrm_9300.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_9300.FormDestroy(Sender: TObject);
begin
   Frm_9300 := Nil;
end;

procedure TFrm_9300.DateTimePicker1Change(Sender: TObject);
begin
   StartBitBtnClick(self);
end;

{
procedure TFrm_2700.ExlBtnClick(Sender: TObject);
begin
  if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '파렛트 코드 현황');
 end;
end;
}

procedure TFrm_9300.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
   Value : String;
   WW    : Integer;
begin
  If DataCol = 0 Then
  begin
   with(Sender as TDBGrid).Canvas do
   begin
    Value := IntToStr(Query1.RecNo);
    WW    := Canvas.TextWidth(value);
    TextOut(Rect.Left+(Rect.Right - Rect.Left - WW) div 2, Rect.Top+2,Value);
   end;
  end;
end;

end.

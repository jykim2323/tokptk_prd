unit Frm5400;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask, ComCtrls;

type
  TFrm_5400 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    DataSource1: TDataSource;
    PrintBitBtn: TBitBtn;
    ExitBitBtn: TBitBtn;
    StartBitBtn: TBitBtn;
    Panel4: TPanel;
    DateTimePicker1: TDateTimePicker;
    StockEd: TEdit;
    Panel2: TPanel;
    RackRG: TRadioGroup;
    SubkQuery: TADOQuery;
    SubkQuerySUBK_FLAG: TStringField;
    SubkQuerySUBK_LOCA: TStringField;
    SubkQuerySUBK_PLTID: TStringField;
    SubkQuerySUBK_CODE: TStringField;
    SubkQuerySUBK_QTY: TIntegerField;
    SubkQuerySUBK_RQTY: TIntegerField;
    SubkQuerySUBK_INDATE: TStringField;
    SubkQuerySUBK_INTIME: TStringField;
    SubkQuerySUBK_PGUBN: TStringField;
    SubkQueryMAST_NAME: TStringField;
    SubkQueryPG_NAME: TStringField;
    UpdtQuery: TADOQuery;
    DBGrid1: TDBGrid;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);  
    procedure StartBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure RackRGClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_5400: TFrm_5400;
  
  var_SelForm : TForm;
  var_Modal : Boolean;
  Var_ItemDiv : String;

implementation

uses Dbset, WinLib, FrmPrompt, FrmError;

{$R *.dfm}


procedure TFrm_5400.FormCreate(Sender: TObject);
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  DateTimePicker1.Date := Now; 
end;

procedure TFrm_5400.StartBitBtnClick(Sender: TObject);
var
  StrQry, StrDate : String;
  PltQty : Real;
begin

  StrDate := FormatDateTime('yyyymmdd', DateTimePicker1.Date);

  StrQry :=  ' SELECT  SUBK_FLAG, SUBK_LOCA, SUBK_PLTID, SUBK_CODE, SUBK_QTY,  SUBK_RQTY, SUBK_INDATE, ';
  StrQry := StrQry + '  SUBK_INTIME, SUBK_PGUBN, MAST_NAME, PG_NAME  ';
  StrQry := StrQry + '  FROM STK1_MISUBK (NOLOCK) ';
  StrQry := StrQry + '  LEFT OUTER JOIN STK_MIMAST (NOLOCK) ON MAST_CODE = SUBK_CODE ';
  StrQry := StrQry + '  LEFT OUTER JOIN STK_PGUBN (NOLOCK) ON PG_CODE = SUBK_PGUBN ';
  StrQry := StrQry + '   Where subk_indate <= '''+StrDate+''' ';
  if  (RackRg.ItemIndex = 1)  then      StrQry := StrQry + '   and substring(subk_loca,1,1) = ''1'' '
  else if  (RackRg.ItemIndex = 2)  then StrQry := StrQry + '   and substring(subk_loca,1,1) <> ''1'' ';
  StrQry := StrQry + '  Order By  subk_loca, subk_code ';

  with SubkQuery do Begin
    DisableControls;
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    First;
    EnableControls;
  End;

  StrQry := ' Select SUBK_LOCA  From STK1_MISUBK (NOLOCK) Group By SUBK_LOCA    ';
  With UpdtQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    PltQty := RecordCount;
    StockEd.Text := FormatFloat('#,###,##0',PltQty);
  End;   

end;

procedure TFrm_5400.PrintBitBtnClick(Sender: TObject);
begin
{
  var_Modal   := False;
  var_SelForm := Nil;

  var_SelForm := TPrm_6700.Create(Application);
  var_Modal := True;

  if var_SelForm <> Nil then begin
    With TForm(var_SelForm) do begin
      if var_Modal then ShowModal
      Else begin
        BorderIcons := [];
        Show;
      End;
    end;
  end;
}
end;

procedure TFrm_5400.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_5400.FormDestroy(Sender: TObject);
begin
  Frm_5400 := Nil;
end;

procedure TFrm_5400.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_5400.RackRGClick(Sender: TObject);
begin
   StartBitBtnClick(self);
end;

end.

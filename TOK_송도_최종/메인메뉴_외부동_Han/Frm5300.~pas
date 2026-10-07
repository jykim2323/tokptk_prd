unit Frm5300;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask;

type
  TFrm_5300 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    SiotGrid: TDBGrid;
    DataSource1: TDataSource;
    PrintBitBtn: TBitBtn;
    ExitBitBtn: TBitBtn;
    StartBitBtn: TBitBtn;
    Panel7: TPanel;
    ItemCB: TEdit;
    RackRG: TRadioGroup;
    UpdtQuery: TADOQuery;
    SubkQuery: TADOQuery;
    SubkQuerysubk_code: TStringField;
    SubkQuerysubk_pgubn: TStringField;
    SubkQuerypg_name: TStringField;
    SubkQuerymast_name: TStringField;
    SubkQuerysubk_qty: TBCDField;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);  
    procedure StartBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);  
    procedure ItemCBChange(Sender: TObject);
    procedure RackRGClick(Sender: TObject);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_5300: TFrm_5300;
  
  var_SelForm : TForm;
  var_Modal : Boolean;
  Var_ItemDiv : String;

implementation

uses Dbset, WinLib, FrmPrompt, FrmError;

{$R *.dfm}


procedure TFrm_5300.FormCreate(Sender: TObject);
begin  
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  RackRg.ItemIndex := 0;
  
  itemCB.Text := '0';
  StartBitBtnClick(Self);
end; 

procedure TFrm_5300.StartBitBtnClick(Sender: TObject);
var
  StrQry : String;
  li_Bqty, li_qty : Real;
begin
  StrQry :=  ' Select   subk_code, subk_pgubn, max(pg_name) pg_name,  max(mast_name) mast_name,  ';
  StrQry := StrQry + '  sum(subk_qty) subk_qty ';
  StrQry := StrQry + '  FROM STK1_MISUBK (NOLOCK) ';
  StrQry := StrQry + '  LEFT OUTER JOIN STK_MIMAST (NOLOCK) ON MAST_CODE = SUBK_CODE ';
  StrQry := StrQry + '  LEFT OUTER JOIN STK_PGUBN (NOLOCK) ON PG_CODE = SUBK_PGUBN ';
  StrQry := StrQry + '   Where SUBK_CODE >= '''+itemCB.Text+''' ';

  if  (RackRg.ItemIndex = 1)  then      StrQry := StrQry + '   and substring(subk_loca,1,1) = ''1'' '
  else if  (RackRg.ItemIndex = 2)  then StrQry := StrQry + '   and substring(subk_loca,1,1) <> ''1'' ';

  StrQry := StrQry + '  Group By  subk_code, subk_pgubn  ';
  StrQry := StrQry + '  Order By  subk_code, subk_pgubn ';

  with SubkQuery do Begin
    DisableControls;
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    First;
    EnableControls;   
  End;       

end;

procedure TFrm_5300.DataSource1DataChange(Sender: TObject; Field: TField);

begin
  itemCB.Text := SubkQuery.FieldByName('SUBK_CODE').AsString;
end;


procedure TFrm_5300.ItemCBChange(Sender: TObject);
begin
   StartBitBtnClick(self);
end;


procedure TFrm_5300.PrintBitBtnClick(Sender: TObject);
begin
{
  var_Modal   := False;
  var_SelForm := Nil;

  var_SelForm := TPrm_6500.Create(Application);
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

procedure TFrm_5300.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_5300.FormDestroy(Sender: TObject);
begin
  Frm_5300 := Nil;
end;

procedure TFrm_5300.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_5300.RackRGClick(Sender: TObject);
begin
  StartBitBtnClick(self);
end;

end.

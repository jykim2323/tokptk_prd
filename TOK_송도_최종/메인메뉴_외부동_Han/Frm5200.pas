unit Frm5200;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB, DBTables,
  Mask;

type
  TFrm_5200 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    DataSource1: TDataSource;
    PrintBitBtn: TBitBtn;
    ExitBitBtn: TBitBtn;
    StartBitBtn: TBitBtn;
    Panel7: TPanel;
    NameEd: TEdit;
    StockEd: TEdit;
    Panel3: TPanel;
    ItemCB: TEdit;
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
    SubkQueryLSTK_FLAG: TStringField;
    Panel2: TPanel;
    PltNoCb: TEdit;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);  
    procedure StartBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField); 
    procedure ItemCBChange(Sender: TObject);      
   
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_5200: TFrm_5200;
  
  var_SelForm : TForm;
  var_Modal : Boolean;
  Var_ItemDiv : String;

  s_itnbr, s_cvcod, s_loca,  s_lotno, s_jpno, s_qty, s_bqty, s_date,  s_time, s_gubun : String;
  s_pltno, s_flag, s_depot, s_rqty : String;
  li_BOXQTY, li_bqty, li_qty  : Real;

implementation

uses Dbset, WinLib, FrmPrompt, FrmError;   

{$R *.dfm}


procedure TFrm_5200.FormCreate(Sender: TObject);
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;     

end;

procedure TFrm_5200.FormActivate(Sender: TObject);
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;
  StartBitBtnClick(self);
end;

procedure TFrm_5200.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
   if key <> #13 then Exit;
   StartBitBtnClick(self);
end;


procedure TFrm_5200.StartBitBtnClick(Sender: TObject);
var
  StrQry, ls_item, ls_pltid : String;
  li_Bqty, li_qty, bi_qty, bi_bqty : Real;
begin
  li_qty := 0;  li_bqty := 0;
  ls_item  := Trim(itemCB.Text);
  ls_pltid := Trim(PltNoCB.Text);
  
  with SubkQuery do Begin
    Close;
    SQL.Clear;
    SQL.Clear;
    SQL.Add(' SELECT  SUBK_FLAG, SUBK_LOCA, SUBK_PLTID, SUBK_CODE,  ');
    SQL.Add('         SUBK_QTY,  SUBK_RQTY, SUBK_INDATE,    ');
    SQL.Add('         SUBK_INTIME, SUBK_PGUBN, MAST_NAME, PG_NAME, LSTK_FLAG   ');
    SQL.Add('  FROM STK1_MISUBK (NOLOCK)                            ');
    SQL.Add('  LEFT OUTER JOIN STK_MIMAST (NOLOCK) ON MAST_CODE = SUBK_CODE      ');
    SQL.Add('  LEFT OUTER JOIN STK_PGUBN (NOLOCK) ON PG_CODE = SUBK_PGUBN        ');
    SQL.Add('  LEFT OUTER JOIN STK1_MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA        ');
    SQL.Add('  Where SUBK_CODE <> ''''             ');

    if  length(ls_item) <> 0 then   SQL.Add(' And SUBK_code = '''+ls_item+'''     ')
    else  if  length(ls_pltid) <> 0 then SQL.Add(' And SUBK_code = '''+ls_pltid+'''    ');

    SQL.Add('        And LSTK_FLAG = ''1''                           ');
    SQL.Add('        And SUBK_FLAG = ''1''                           ');
    SQL.Add('  Order By subk_loca, subk_code                      ');
    Open;
    First;
  End;


  with UpdtQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(' Select  Sum(SUBK_QTY) SUBK_QTY FROM STK1_MISUBK (NOLOCK) ');
    SQL.Add('  LEFT OUTER JOIN STK1_MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA        ');
    SQL.Add('  Where subk_code = '''+itemCB.Text+'''             '); 
    SQL.Add('        And LSTK_FLAG = ''1''                           ');
    SQL.Add('        And SUBK_FLAG = ''1''                           ');
    Open;
    First;
    li_qty  := FieldByName('SUBK_QTY').AsFloat;
  End;

  StockEd.Text := FormatFloat('#,###,##0',li_qty);

  StrQry := ' Select MAST_NAME  From STK_MIMAST (NOLOCK) WHERE MAST_CODE = '''+itemCB.Text+'''  ';
  With UpdtQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;
    if Recordcount = 0 Then
    begin
      NameEd.Text := '';      Exit;
    end;
    NameEd.Text := FieldByName('MAST_NAME').AsString;
  End;
end;

procedure TFrm_5200.DataSource1DataChange(Sender: TObject; Field: TField);

begin
  itemCB.Text := SubkQuery.FieldByName('SUBK_CODE').AsString;
  NameEd.Text := SubkQuery.FieldByName('MAST_NAME').AsString;
 
end;


procedure TFrm_5200.ItemCBChange(Sender: TObject);
begin
   StartBitBtnClick(self);
end;


procedure TFrm_5200.PrintBitBtnClick(Sender: TObject);
begin
{
  var_Modal   := False;
  var_SelForm := Nil;

  var_SelForm := TPrm_6200.Create(Application);
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

procedure TFrm_5200.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_5200.FormDestroy(Sender: TObject);
begin
  Frm_5200 := Nil;
end;

procedure TFrm_5200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;








end.

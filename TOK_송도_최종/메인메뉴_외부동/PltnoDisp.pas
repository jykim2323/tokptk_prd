unit PltnoDisp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, Grids, DBGrids, StdCtrls, 
  Mask, DBCtrls, DB, WinLib,  DBTables, ADODB;

type
  TPltno_Disp = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    Sb_Close: TSpeedButton;
    Bevel2: TBevel;
    Label6: TLabel;
    Edt_Search: TEdit;
    SB_Search: TSpeedButton;
    SB_AllView: TSpeedButton;
    Query1: TADOQuery;
    Query1MAST_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1MAST_UNIT: TStringField;
    Query1MAST_GUBUN: TStringField;
    Query1MAST_KIND: TStringField;
    Query1MAST_VALID: TIntegerField;
    Query1MAST_CHECK: TIntegerField;
    Query1MAST_DATE: TDateTimeField;
    DataSource1: TDataSource;
    DBGrid: TDBGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Sb_CloseClick(Sender: TObject);   
    procedure SB_SearchClick(Sender: TObject);
    procedure Edt_SearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure SB_AllViewClick(Sender: TObject);   
    procedure FormCreate(Sender: TObject);           
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure DBGridCellClick(Column: TColumn);    

  private

  public
    { Public declarations }
  end;

var
   Pltno_Disp: TPltno_Disp;

  // 전역변수로 정의하여 파라미터로 사용한다
   Param_Value   : Array of String = Nil;

   pd_check_ok : Boolean;
   Bol_Modal : Boolean;

   jj_code, jj_name : String;

implementation

uses  Dbset, CellDisp;

{$R *.dfm}

procedure TPltno_Disp.FormCreate(Sender: TObject);
begin   
  SB_AllViewClick(Self);
end;

procedure TPltno_Disp.SB_AllViewClick(Sender: TObject);
var
        var_Sql : String;
Begin
        var_Sql := 'select * from MIMAST (NOLOCK) ';
        var_Sql := var_Sql + '  order by mast_code';

       try
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add(var_sql);
          Query1.Open;
          Query1.First;
      finally
          Param_Value := nil;
      end;  
End;

procedure TPltno_Disp.SB_SearchClick(Sender: TObject);
var
 StrCode : String;
begin
  StrCode := Edt_Search.Text;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(' Select * From MIMAST (NOLOCK) ');
  Query1.SQL.Add('  Where MAST_CODE LIKE ''%'+StrCode+'%'' ');
  Query1.SQL.Add('  Order By  MAST_CODE ');
  Query1.Open;      
  Query1.First;
  
end;

procedure TPltno_Disp.Edt_SearchKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then
   begin
     SB_SearchClick(Sender);
     Key := #0;
   end;
end;
      
procedure TPltno_Disp.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TPltno_Disp.Sb_CloseClick(Sender: TObject);
begin
   Close;
end;

procedure TPltno_Disp.FormDestroy(Sender: TObject);
begin
   Mast_Disp := Nil;
end; 

procedure TPltno_Disp.DBGridDrawColumnCell(Sender: TObject;
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

procedure TPltno_Disp.MouseWheelHandler(var Message: TMessage);
var
 i: SmallInt;
begin

 if Message.Msg = WM_MOUSEWHEEL then
 begin
   if ActiveControl is TDBGrid then
   begin
     Message.Msg := WM_KEYDOWN;
     Message.lParam := 0;
     i := HiWord(Message.wParam);
     if i > 0 then
       Message.wParam := VK_UP
     else
       Message.wParam := VK_DOWN;
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
     (ActiveControl as TDBGrid).Refresh;
   end;
 end;
end;

procedure TPltno_Disp.DBGridCellClick(Column: TColumn);
begin
  jj_code  := Query1.FieldByName('MAST_CODE').AsString;
  close;
end;


end.

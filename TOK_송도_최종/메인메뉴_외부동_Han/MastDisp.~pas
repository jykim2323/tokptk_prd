unit MastDisp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, Grids, DBGrids, StdCtrls, 
  Mask, DBCtrls, DB, WinLib,  DBTables, ADODB;

type
  TMast_Disp = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    Sb_Close: TSpeedButton;
    Bevel2: TBevel;
    Label6: TLabel;
    Edt_Search: TEdit;
    SB_Search: TSpeedButton;
    SB_AllView: TSpeedButton;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    DBGrid1: TDBGrid;
    Query1MAST_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1MAST_UNIT: TStringField;
    Query1MAST_WEIGHT: TBCDField;
    Query1gubn1_name: TStringField;
    Query1gubn2_name: TStringField;
    Query1gubn3_name: TStringField;
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
    procedure DBGrid1CellClick(Column: TColumn);

  private

  public
    { Public declarations }
  end;

var
   Mast_Disp: TMast_Disp;

  // 전역변수로 정의하여 파라미터로 사용한다
   Param_Value   : Array of String = Nil;

   pd_check_ok : Boolean;
   Bol_Modal : Boolean;

   jj_code, jj_name : String;

implementation

uses  Dbset, CellDisp;

{$R *.dfm}

procedure TMast_Disp.FormCreate(Sender: TObject);
begin   
  SB_AllViewClick(Self);
end;

procedure TMast_Disp.SB_AllViewClick(Sender: TObject);
var
        var_Sql : String;
Begin
        var_Sql := 'select MAST_CODE, MAST_NAME, MAST_UNIT, MAST_WEIGHT, ';
        var_Sql := var_Sql + '  gubn1_name, gubn2_name, gubn3_name from MIMAST (NOLOCK)  ';
        var_Sql := var_Sql + '  LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1  ';
        var_Sql := var_Sql + '  LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2  ';
        var_Sql := var_Sql + '  LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3  ';
        var_Sql := var_Sql + '  Order By  MAST_CODE';
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


procedure TMast_Disp.SB_SearchClick(Sender: TObject);
var
 StrCode,  var_Sql : String;
begin
   StrCode := Edt_Search.Text;

   var_Sql := 'select MAST_CODE, MAST_NAME, MAST_UNIT, MAST_WEIGHT, ';
   var_Sql := var_Sql + '  gubn1_name, gubn2_name, gubn3_name from MIMAST (NOLOCK)  ';
   var_Sql := var_Sql + '  LEFT OUTER JOIN MIGUBN1 (NOLOCK) ON GUBN1_CODE = MAST_GUBN1  ';
   var_Sql := var_Sql + '  LEFT OUTER JOIN MIGUBN2 (NOLOCK) ON GUBN2_CODE = MAST_GUBN2  ';
   var_Sql := var_Sql + '  LEFT OUTER JOIN MIGUBN3 (NOLOCK) ON GUBN3_CODE = MAST_GUBN3  ';
   var_Sql := var_Sql + '  Where MAST_CODE LIKE ''%'+StrCode+'%''  ';
   var_Sql := var_Sql + '  Order By  MAST_CODE';


  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(var_Sql);     
  Query1.Open;      
  Query1.First;
  
end;

procedure TMast_Disp.Edt_SearchKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then
   begin
     SB_SearchClick(Sender);
     Key := #0;
   end;
end;
      
procedure TMast_Disp.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TMast_Disp.Sb_CloseClick(Sender: TObject);
begin
   Close;
end;

procedure TMast_Disp.FormDestroy(Sender: TObject);
begin
   Mast_Disp := Nil;
end; 

procedure TMast_Disp.DBGridDrawColumnCell(Sender: TObject;
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

procedure TMast_Disp.MouseWheelHandler(var Message: TMessage);
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



procedure TMast_Disp.DBGrid1CellClick(Column: TColumn);
begin
  jj_code  := Query1.FieldByName('MAST_CODE').AsString;
  jj_name  := Query1.FieldByName('MAST_NAME').AsString;
  close;
end;

end.

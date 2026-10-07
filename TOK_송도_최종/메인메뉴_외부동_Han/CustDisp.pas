unit CustDisp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, DB, ADODB, DBTables,
  ComCtrls, Mask;

type
  TCust_Disp = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    GroupBox1: TGroupBox;
    Query1: TADOQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ItemEdit: TMaskEdit;
    StartBitBtn: TSpeedButton;
    Query1CUST_CODE: TStringField;
    Query1CUST_NAME: TStringField;
    Label1: TLabel;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);   
    
    procedure StartBitBtnClick(Sender: TObject);    

    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1TitleClick(Column: TColumn);
      
  private
    { Private declarations }
    procedure MouseWheelHandler(var Message: TMessage); override;

  public
    { Public declarations }
  end;

var
  Cust_Disp: TCust_Disp;

  Var_Form : TForm;
  Read_ok : Boolean;
  Bol_Data_Ok : Boolean;

  jj_ccode, jj_cname : String;

  StrMsg, StrQry : String;
  StrDate1, StrDate2: String;    


  s_wsno, s_floor, s_high, StrItnbr,  StrLotno, StrCode, s_From : String;
implementation

uses DBSet, CellDisp;

{$R *.dfm}     


procedure TCust_Disp.FormCreate(Sender: TObject);
begin
  StartBitBtnClick(Self);   
end;


procedure TCust_Disp.StartBitBtnClick(Sender: TObject);
begin
  StrCode := ItemEdit.Text;

  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(' Select * From STK_MICUST (NOLOCK) ');
  Query1.SQL.Add('  Where CUST_CODE LIKE ''%'+StrCode+'%'' ');
  Query1.SQL.Add('  Order By  CUST_CODE ');
  Query1.Open;
  Query1.First;

end;

procedure TCust_Disp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TCust_Disp.FormDestroy(Sender: TObject);
begin
  Cust_Disp := Nil;
end;

procedure TCust_Disp.ExitBitBtnClick(Sender: TObject);
begin
  close;
end;    

procedure TCust_Disp.MouseWheelHandler(var Message: TMessage);
var
 i: SmallInt;
begin
 // inherited;
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

procedure TCust_Disp.DBGrid1TitleClick(Column: TColumn);
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

procedure TCust_Disp.DBGrid1CellClick(Column: TColumn);
begin
   jj_ccode  := Query1.FieldByName('CUST_CODE').AsString;
   jj_cname  := Query1.FieldByName('CUST_NAME').AsString;

   close;
end;

end.

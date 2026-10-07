unit Frm1600;

interface

uses
  Windows, Messages, SysUtils, Classes, Variants, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ComCtrls, StdCtrls, Buttons, CheckLst, ExtCtrls, ADODB,
  Mask, Grids, DBGrids, QRCtrls, QuickRpt, ImgList, Jpeg;

 type
  TFrm_1600 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    GroupBox1: TGroupBox;
    Name1Edit: TMaskEdit;
    DBGrid1: TDBGrid;
    UpdtQuery: TADOQuery;
    InsertBitBtn1: TSpeedButton;
    UpdateBitBtn1: TSpeedButton;
    DeleteBitBtn1: TSpeedButton;
    Code1Edit: TMaskEdit;
    Label3: TLabel;
    Label1: TLabel;
    StartBitBtn1: TSpeedButton;
    Query1CUST_CODE: TStringField;
    Query1CUST_NAME: TStringField;
    Query1CUST_DATE: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction); 
    procedure FormDestroy(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);      

    procedure DBGrid1TitleClick(Column: TColumn);
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure InsertBitBtn1Click(Sender: TObject);
    procedure UpdateBitBtn1Click(Sender: TObject);
    procedure DeleteBitBtn1Click(Sender: TObject);   
  
    procedure StartBitBtn1Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private


  public
    { Public declarations }
  end;

var
  Frm_1600: TFrm_1600;

  StrCode : String;
  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;

  var_Msg   : String;

  Param_Value   : Array of String = Nil;
   pd_check_ok : Boolean;

implementation

uses DBSet, WinLib, FrmPrompt, FrmError, SFrm1100, SFrm1200;

{$R *.DFM}

procedure TFrm_1600.FormCreate(Sender: TObject);
begin
   StartBitBtn1Click(Self);
end;


procedure TFrm_1600.StartBitBtn1Click(Sender: TObject);
begin
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(' SELECT * FROM MICUST (NOLOCK) ');
  Query1.SQL.Add(' ORDER BY CUST_CODE ');
  Query1.Open;
  Query1.First;
end;


procedure TFrm_1600.DataSource1DataChange(Sender: TObject; Field: TField);
begin
   Code1Edit.Text := Query1.FieldByName('CUST_CODE').AsString;
   Name1Edit.Text := Query1.FieldByName('CUST_NAME').AsString;
end;

//////////////////////////////////////////////////////////////////////////
procedure TFrm_1600.InsertBitBtn1Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 납품처 데이터를 등록  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(Code1Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 납품처 코드를 입력 하십시요.');
         Code1Edit.SetFocus;
         Exit;
      End;

      IF  Trim(Name1Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 납품처명을 입력 하십시요...');
         Name1Edit.SetFocus;
         Exit;
      End;

    var_sql := ' Insert Into MICUST(CUST_CODE, CUST_NAME ) ';
    var_sql := var_sql + '   Values('''+Code1Edit.Text+''', '''+Name1Edit.Text+''')  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분자 코드 ' + Code1Edit.Text + ' 존재함 등록 에러!!!! ');
         Exit;
      End;
     End;

    Query1.ReQuery;
  end;  
//    StartBitBtn1Click(Self);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TFrm_1600.UpdateBitBtn1Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 납품처 데이터를 수정  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(Code1Edit.Text) = '' then
      Begin
         WinLib_ErrorForm('납품처 코드를 입력 하십시요.');
         Code1Edit.SetFocus;
         Exit;
      End;

      IF  Trim(Name1Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 납품처명을 입력 하십시요...');
         Name1Edit.SetFocus;
         Exit;
      End;

     var_sql := 'Update MICUST Set ';
     var_sql := var_sql + ' CUST_NAME   = '''+Name1Edit.Text+'''    ';
     var_sql := var_sql + ' Where  CUST_CODE = '''+Code1Edit.Text+'''  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('납품처 코드 ' + Code1Edit.Text + ' 수정 에러!!!! ');
         Exit;
      End;
     End;

    Query1.ReQuery;
  end;
end;


////////////////////////////////////////////////////////////////////
procedure TFrm_1600.DeleteBitBtn1Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 납품처 데이터를 삭제  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From MICUST Where CUST_CODE = '''+Code1Edit.Text+''' ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('납품처 코드 ' + Code1Edit.Text + ' 삭제 에러!!!! ');
         Exit;
      End;
     End;

    Query1.ReQuery;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFrm_1600.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

///////////////////////////////////////////////////////////////////

procedure TFrm_1600.MouseWheelHandler(var Message: TMessage);
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


procedure TFrm_1600.FormDestroy(Sender: TObject);
begin
   Frm_1600 := Nil;
end;


procedure TFrm_1600.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_1600.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;




end.

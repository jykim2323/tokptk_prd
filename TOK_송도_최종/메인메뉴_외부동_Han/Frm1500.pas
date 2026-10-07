unit Frm1500;

interface

uses
  Windows, Messages, SysUtils, Classes, Variants, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ComCtrls, StdCtrls, Buttons, CheckLst, ExtCtrls, ADODB,
  Mask, Grids, DBGrids, QRCtrls, QuickRpt, ImgList, Jpeg;

 type
  TFrm_1500 = class(TForm)
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
    Query1GUBN1_CODE: TStringField;
    Query1GUBN1_NAME: TStringField;
    Query1GUBN1_DATE: TDateTimeField;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Name2Edit: TMaskEdit;
    Code2Edit: TMaskEdit;
    DBGrid2: TDBGrid;
    DataSource2: TDataSource;
    Query2: TADOQuery;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Name3Edit: TMaskEdit;
    Code3Edit: TMaskEdit;
    DBGrid3: TDBGrid;
    InsertBitBtn2: TSpeedButton;
    UpdateBitBtn2: TSpeedButton;
    DeleteBitBtn2: TSpeedButton;
    InsertBitBtn3: TSpeedButton;
    UpdateBitBtn3: TSpeedButton;
    DeleteBitBtn3: TSpeedButton;
    DataSource3: TDataSource;
    Query3: TADOQuery;
    Query2GUBN2_CODE: TStringField;
    Query2GUBN2_NAME: TStringField;
    Query2GUBN2_DATE: TDateTimeField;
    Query3GUBN3_CODE: TStringField;
    Query3GUBN3_NAME: TStringField;
    Query3GUBN3_DATE: TDateTimeField;
    StartBitBtn1: TSpeedButton;
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
    procedure DataSource2DataChange(Sender: TObject; Field: TField);
    procedure DataSource3DataChange(Sender: TObject; Field: TField);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure InsertBitBtn2Click(Sender: TObject);
    procedure InsertBitBtn3Click(Sender: TObject);
    procedure UpdateBitBtn2Click(Sender: TObject);
    procedure UpdateBitBtn3Click(Sender: TObject);
    procedure DeleteBitBtn2Click(Sender: TObject);
    procedure DeleteBitBtn3Click(Sender: TObject);

  private


  public
    { Public declarations }
  end;

var
  Frm_1500: TFrm_1500;

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

procedure TFrm_1500.FormCreate(Sender: TObject);
begin
   StartBitBtn1Click(Self);
end;


procedure TFrm_1500.StartBitBtn1Click(Sender: TObject);
begin
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(' Select * From MIGUBN1 (NOLOCK) ');
  Query1.SQL.Add('  Order By  GUBN1_CODE ');
  Query1.Open;
  Query1.First;

  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Add(' Select * From MIGUBN2 (NOLOCK) ');
  Query2.SQL.Add('  Order By  GUBN2_CODE ');
  Query2.Open;
  Query2.First;

  Query3.Close;
  Query3.SQL.Clear;
  Query3.SQL.Add(' Select * From MIGUBN3 (NOLOCK) ');
  Query3.SQL.Add('  Order By  GUBN3_CODE ');
  Query3.Open;
  Query3.First;
end;


procedure TFrm_1500.DataSource1DataChange(Sender: TObject; Field: TField);
begin
   Code1Edit.Text := Query1.FieldByName('GUBN1_CODE').AsString;
   Name1Edit.Text := Query1.FieldByName('GUBN1_NAME').AsString;
end;

procedure TFrm_1500.DataSource2DataChange(Sender: TObject; Field: TField);
begin
   Code2Edit.Text := Query2.FieldByName('GUBN2_CODE').AsString;
   Name2Edit.Text := Query2.FieldByName('GUBN2_NAME').AsString;
end;

procedure TFrm_1500.DataSource3DataChange(Sender: TObject; Field: TField);
begin
  Code3Edit.Text := Query3.FieldByName('GUBN3_CODE').AsString;
  Name3Edit.Text := Query3.FieldByName('GUBN3_NAME').AsString;
end;

//////////////////////////////////////////////////////////////////////////
procedure TFrm_1500.InsertBitBtn1Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#1 데이터를 등록  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(Code1Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#1 코드를 입력 하십시요.');
         Code1Edit.SetFocus;
         Exit;
      End;

      IF  Trim(Name1Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#1 구분명을 입력 하십시요...');
         Name1Edit.SetFocus;
         Exit;
      End;

    var_sql := ' Insert Into MIGUBN1(GUBN1_CODE, GUBN1_NAME ) ';
    var_sql := var_sql + '   Values('''+Code1Edit.Text+''', '''+Name1Edit.Text+''')  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#1 코드 ' + Code1Edit.Text + ' 존재함 등록 에러!!!! ');
         Exit;
      End;
     End;

    Query1.ReQuery;
  end;  
//    StartBitBtn1Click(Self);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TFrm_1500.UpdateBitBtn1Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#1 데이터를 수정  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(Code1Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#1 코드를 입력 하십시요.');
         Code1Edit.SetFocus;
         Exit;
      End;

      IF  Trim(Name1Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#1 구분명을 입력 하십시요...');
         Name1Edit.SetFocus;
         Exit;
      End;

     var_sql := 'Update MIGUBN1 Set ';
     var_sql := var_sql + ' GUBN1_NAME   = '''+Name1Edit.Text+'''    ';
     var_sql := var_sql + ' Where  GUBN1_CODE = '''+Code1Edit.Text+'''  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#1 코드 ' + Code1Edit.Text + ' 수정 에러!!!! ');
         Exit;
      End;
     End;

    Query1.ReQuery;
  end;
end;


////////////////////////////////////////////////////////////////////
procedure TFrm_1500.DeleteBitBtn1Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#1 데이터를 삭제  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From MIGUBN1 Where GUBN1_CODE = '''+Code1Edit.Text+''' ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#1 코드 ' + Code1Edit.Text + ' 삭제 에러!!!! ');
         Exit;
      End;
     End;

    Query1.ReQuery;
  end;
end;



procedure TFrm_1500.InsertBitBtn2Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#2 데이터를 등록  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(Code2Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#2 코드를 입력 하십시요.');
         Code2Edit.SetFocus;
         Exit;
      End;

      IF  Trim(Name2Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#2 구분명을 입력 하십시요...');
         Name2Edit.SetFocus;
         Exit;
      End;

    var_sql := ' Insert Into MIGUBN2(GUBN2_CODE, GUBN2_NAME ) ';
    var_sql := var_sql + '   Values('''+Code2Edit.Text+''', '''+Name2Edit.Text+''')  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#2 코드 ' + Code2Edit.Text + ' 존재함 등록 에러!!!! ');
         Exit;
      End;
     End;

    Query2.ReQuery;
  end;
end;

procedure TFrm_1500.InsertBitBtn3Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#3 데이터를 등록  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(Code3Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#3 코드를 입력 하십시요.');
         Code3Edit.SetFocus;
         Exit;
      End;

      IF  Trim(Name3Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#1 구분명을 입력 하십시요...');
         Name3Edit.SetFocus;
         Exit;
      End;

    var_sql := ' Insert Into MIGUBN3(GUBN3_CODE, GUBN3_NAME ) ';
    var_sql := var_sql + '   Values('''+Code3Edit.Text+''', '''+Name3Edit.Text+''')  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#3 코드 ' + Code3Edit.Text + ' 존재함 등록 에러!!!! ');
         Exit;
      End;
     End;

    Query3.ReQuery;
  end;
end;

procedure TFrm_1500.UpdateBitBtn2Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#2 데이터를 수정  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(Code2Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#2 코드를 입력 하십시요.');
         Code2Edit.SetFocus;
         Exit;
      End;

      IF  Trim(Name2Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#2 구분명을 입력 하십시요...');
         Name2Edit.SetFocus;
         Exit;
      End;

     var_sql := 'Update MIGUBN2 Set ';
     var_sql := var_sql + ' GUBN2_NAME   = '''+Name2Edit.Text+'''    ';
     var_sql := var_sql + ' Where  GUBN2_CODE = '''+Code2Edit.Text+'''  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#2 코드 ' + Code2Edit.Text + ' 수정 에러!!!! ');
         Exit;
      End;
     End;

    Query2.ReQuery;
  end;
end;

procedure TFrm_1500.UpdateBitBtn3Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#3 데이터를 수정  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
      IF Trim(Code3Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#3 코드를 입력 하십시요.');
         Code3Edit.SetFocus;
         Exit;
      End;

      IF  Trim(Name3Edit.Text) = '' then
      Begin
         WinLib_ErrorForm(' 구분#3 구분명을 입력 하십시요...');
         Name3Edit.SetFocus;
         Exit;
      End;

     var_sql := 'Update MIGUBN3 Set ';
     var_sql := var_sql + ' GUBN3_NAME   = '''+Name3Edit.Text+'''    ';
     var_sql := var_sql + ' Where  GUBN3_CODE = '''+Code3Edit.Text+'''  ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#3 코드 ' + Code3Edit.Text + ' 수정 에러!!!! ');
         Exit;
      End;
     End;

    Query3.ReQuery;
  end;
end;

procedure TFrm_1500.DeleteBitBtn2Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#2 데이터를 삭제  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From MIGUBN2 Where GUBN2_CODE = '''+Code2Edit.Text+''' ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#2 코드 ' + Code2Edit.Text + ' 삭제 에러!!!! ');
         Exit;
      End;
     End;

    Query2.ReQuery;
  end;
end;

procedure TFrm_1500.DeleteBitBtn3Click(Sender: TObject);
var
  var_Msg, var_sql : String;
begin
  var_Msg := ' 구분#3 데이터를 삭제  합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From MIGUBN3 Where GUBN3_CODE = '''+Code3Edit.Text+''' ';
    With UpdtQuery Do
     Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
     Except
      Begin
         WinLib_ErrorForm('구분#3 코드 ' + Code3Edit.Text + ' 삭제 에러!!!! ');
         Exit;
      End;
     End;

    Query3.ReQuery;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFrm_1500.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;


procedure TFrm_1500.DBGrid2TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_1500.DBGrid3TitleClick(Column: TColumn);
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

procedure TFrm_1500.MouseWheelHandler(var Message: TMessage);
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


procedure TFrm_1500.FormDestroy(Sender: TObject);
begin
   Frm_1500 := Nil;
end;


procedure TFrm_1500.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_1500.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;




end.

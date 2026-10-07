unit Frm1300;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, Grids, DBGrids, StdCtrls, 
  Mask, DBCtrls, DB, WinLib,  DBTables, ADODB;

type
  TFrm_1300 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Sb_Insert: TSpeedButton;
    Sb_Delete: TSpeedButton;
    Label4: TLabel;
    Notebook: TNotebook;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    SB_Search: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    SB_AllView: TSpeedButton;
    Edt_Search: TEdit;
    Sb_Update: TSpeedButton;
    Sb_Close: TSpeedButton;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Edt_ID: TEdit;
    Edt_PW: TEdit;
    Edt_RePw: TEdit;
    Label21: TLabel;
    Edt_Name: TEdit;
    Cbo_Power: TComboBox;
    Label22: TLabel;
    Shape2: TShape;
    Bevel3: TBevel;
    IdEdit: TEdit;
    PwEdit: TEdit;
    NMEdit: TEdit;
    KindEdit: TEdit;
    WdateEdit: TEdit;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Query1: TADOQuery;
    Query2: TADOQuery;
    Query3: TADOQuery;
    Query1USER_ID: TStringField;
    Query1USER_PW: TStringField;
    Query1USER_NM: TStringField;
    Query1USER_WDATE: TDateTimeField;
    Query1USER_KIND: TIntegerField;
    Query1USER_USES: TStringField;
    Label8: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Sb_CloseClick(Sender: TObject);
    procedure Sb_InsertClick(Sender: TObject);
    procedure Sb_UpdateClick(Sender: TObject);
    procedure Sb_DeleteClick(Sender: TObject);
    procedure SB_SearchClick(Sender: TObject);
    procedure Edt_SearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure SB_AllViewClick(Sender: TObject);   
    procedure FormCreate(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure IdEditKeyPress(Sender: TObject; var Key: Char);    
    procedure PwEditKeyPress(Sender: TObject; var Key: Char);
    procedure NMEditKeyPress(Sender: TObject; var Key: Char);
    procedure Cntl_Code_Check;
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure Query1USER_KINDGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private

  public
    { Public declarations }
  end;

var
  Frm_1300: TFrm_1300;

  // 전역변수로 정의하여 파라미터로 사용한다
  Param_Value   : Array of String = Nil;
   pd_check_ok : Boolean;

implementation

uses DBset, FrmProgress;

{$R *.dfm}



procedure TFrm_1300.FormCreate(Sender: TObject);
begin
  if (jj_kind <> '50') then
  begin
    Sb_Insert.Visible    := False;
    Sb_Update.Visible    := False;
    Sb_Delete.Visible    := False;
  end;
  SB_AllViewClick(Self);
end;

procedure TFrm_1300.SB_AllViewClick(Sender: TObject);
var
        var_Sql : String;
Begin
        var_Sql := 'SELECT user_id, user_pw, user_nm, user_jno, user_wdate, user_kind, user_uses ';
        var_Sql := var_Sql + ' from userid';
        var_Sql := var_Sql + '  order by user_id';

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

procedure TFrm_1300.SB_SearchClick(Sender: TObject);
var
  var_data, var_Sql : String;
begin
  var_data := Trim(Edt_Search.Text);
  IF ( var_data = '' ) Then WinLib_ErrorForm('사용자ID를 입력하세요 ! ?')
  Else
  Begin
        try  
             var_Sql := 'SELECT user_id, user_pw, user_nm, user_wdate, user_kind, user_uses ';
             var_Sql := var_Sql + ' from userid';
             var_Sql := var_Sql + ' where  user_id  >= '''+Edt_Search.Text+''' ';
             var_Sql := var_Sql + '  order by user_id';
             Query1.Close;
             Query1.SQL.Clear;
             Query1.SQL.Add( var_Sql);
             Query1.Open;
             Query1.First;
             if Query1.RecordCount = 0 then WinLib_ErrorForm('조회할 데이터가 없습니다..!');
        finally
             Param_Value := nil;
        end;
  End;
end;

procedure TFrm_1300.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin   
    Edt_Search.Text :=  Query1.FieldByName('user_id').AsString;
    idEdit.Text     :=  Query1.FieldByName('user_id').AsString;
    pwEdit.Text     :=  Query1.FieldByName('user_pw').AsString;
    nmEdit.Text     :=  Query1.FieldByName('user_nm').AsString;
    kindEdit.Text   :=  Query1.FieldByName('user_kind').AsString; 
    wdateEdit.Text  :=  Query1.FieldByName('user_wdate').AsString;
end;


procedure TFrm_1300.Sb_InsertClick(Sender: TObject);
var
   var_Sql  : String;
   var_Msg  : String;
begin

  Cntl_Code_Check;
  if (pd_check_ok = False) then exit;

  var_Msg := '사용자ID를 등록합니까 ?';

  IF WinLib_ConfirmForm( var_Msg ) Then
  Begin
  try
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add(' insert into userid ( USER_ID, USER_PW, USER_NM,  USER_KIND )');
    Query2.SQL.Add(' values('''+idEdit.Text+''', '''+pwEdit.Text+''',  '''+nmEdit.Text+''',  '''+kindEdit.Text+''' ) ');
    Query2.ExecSQL;

    Edt_Search.Text := idEdit.Text;

    SB_SearchClick(self);
   Except
      On E:Exception do
      begin
           WinLib_ErrorForm(' User-Id ' + idEdit.Text + ' Insert Error!!!');
           pd_check_ok := False;
      end;
   end;
  end;
end;

// 기존에 사용한 아이디가 있은지를 조사한다
procedure TFrm_1300.Cntl_Code_Check;
var
   var_sql, var_Name : String;
   var_Result : Boolean;
Begin
   var_sql := 'select * from userid where user_id = '''+idEdit.Text+''' ';

   Try
       with Query2 do
       Begin
           Close;
           Sql.Clear;
           Sql.Add( var_sql );
           Open;
           var_Name := Trim( FieldByName('user_id').AsString );
       End;

       if ( var_Name <> '' ) then begin
           WinLib_ErrorForm('이미 사용자ID를 사용하고 있습니다...!');
           pd_check_ok := False;
       end
       Else pd_check_ok := True;
   Except
      pd_check_ok := False;
   End;
End;

procedure TFrm_1300.Sb_UpdateClick(Sender: TObject);
var
   var_Sql : String;
 var
   var_Msg: String;
   var_Result : Boolean;
begin
  var_Msg := '사용자ID를 수정합니까 ?';
  IF WinLib_ConfirmForm( var_Msg ) Then
  Begin
    try
      Query3.Close;
      Query3.SQL.Clear;
      Query3.SQL.Add(' update userid set ');
      Query3.SQL.Add(' USER_ID = '''+IDEdit.Text+''' ,  USER_PW   = '''+PWEdit.Text+''', ');
      Query3.SQL.Add(' USER_NM = '''+NMEdit.Text+''' ,  USER_KIND = '''+KINDEdit.Text+''' ');
      Query3.SQL.Add(' where USER_ID = '''+idEdit.Text+''' ');
      Query3.ExecSQL;

      SB_SearchClick(self);
    Except
      On E:Exception do
      begin
           WinLib_ErrorForm('User-ID  Code=  ' + idEdit.Text + ' Update Error!!!! ');
           pd_check_ok := False;
      end;
    end;
  end;
end;

procedure TFrm_1300.Sb_DeleteClick(Sender: TObject);
var
   var_Msg : String;
begin
   var_Msg := '사용자ID를 삭제합니까 ?';
   IF WinLib_ConfirmForm( var_Msg ) Then
   Begin
     try
       Query3.Close;
       Query3.SQL.Clear;
       Query3.SQL.Add(' delete from userid ');
       Query3.SQL.Add(' where USER_ID = '''+idEdit.Text+''' ');
       Query3.ExecSQL;
       SB_SearchClick(self);
     Except
      On E:Exception do
      begin
           WinLib_ErrorForm('User-ID = ' + idEdit.Text + ' Delete Error!! ');
           pd_check_ok := False;
      end;
    end;
   end;
end;


procedure TFrm_1300.Edt_SearchKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then
   begin
     SB_SearchClick(Sender);
     Key := #0;
   end;
end;

procedure TFrm_1300.IdEditKeyPress(Sender: TObject; var Key: Char);
var
   var_Data : String;
begin
   if Key = #13 then begin
        var_Data := Trim( IdEdit.Text );
        if ( var_Data = '' ) then  begin
            WinLib_ErrorForm('사용자 ID를 입력하세요...!');
        End
        Else pwEdit.SetFocus;

        Key := #0;
   End;
end;


procedure TFrm_1300.PwEditKeyPress(Sender: TObject; var Key: Char);
var
   var_Data : String;
begin
   if Key = #13 then begin
        var_Data := Trim( PWEdit.Text );
        if ( var_Data = '' ) then  begin
            WinLib_ErrorForm('비밀번호를 입력하세요...!');
        End
        Else NMEdit.SetFocus;

        Key := #0;
   End;
end;

procedure TFrm_1300.NMEditKeyPress(Sender: TObject; var Key: Char);
var
   var_Data : String;
begin
   if Key = #13 then
   begin
        var_Data := Trim( NMEdit.Text );
//        if ( var_Data = '' ) then   WinLib_ErrorForm('사용하실 성명를 입력하여 주세요!')
        if ( var_Data = '' ) then   WinLib_ErrorForm('사용하실 성명를 입력하여 주세요!')
        Else KiNDEdit.SetFocus;
        Key := #0;
   End;
end;

procedure TFrm_1300.DBGrid1TitleClick(Column: TColumn);
begin
  if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
  end;
end;

procedure TFrm_1300.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_1300.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TFrm_1300.Sb_CloseClick(Sender: TObject);
begin
   Close;
end;

procedure TFrm_1300.FormDestroy(Sender: TObject);
begin
   Frm_1300 := Nil;
end; 


procedure TFrm_1300.Query1USER_KINDGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   if Sender.Value = '50'  then Text := 'Super'
   else Text := 'General';
end;

end.

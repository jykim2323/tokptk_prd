unit FrmProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, OleCtrls, SHDocVw, ActiveX, jpeg,
  ComCtrls, DB, Buttons, DBTables, ADODB, IniFiles;


type
  TFrm_Progress = class(TForm)
    Lbl_Loading: TLabel;
    Label4: TLabel;
    Edt_ID: TEdit;
    Edt_Passwd: TEdit;
    Sb_OK: TSpeedButton;
    Sb_Cancel: TSpeedButton;
    Query1: TADOQuery;
    MesgStatusBar: TStatusBar;
    Image2: TImage;

    Function AllowAccess : Boolean;
    Function Lib_UserCheck( var_id, var_Passwd : String ): Boolean;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Sb_CancelClick(Sender: TObject);
    procedure Sb_OKClick(Sender: TObject);
    procedure Edt_PasswdKeyPress(Sender: TObject; var Key: Char);
    procedure Edt_IDKeyPress(Sender: TObject; var Key: Char);  
    
  private
    { Private declarations }
//    procedure AppMessage(var Msg: TMsg; var Handled : Boolean);
  public
    GD : string;  //정상 values '0'
    NG : string;  //에러 Values '1'
    DB_NAME : string;
    ErrMsg : string;
    LogCheckFG : String;
    ReConnDbTm : string;
    ReConnDbPd : string;
    StartDate : string;
  end;

var
  Frm_Progress: TFrm_Progress;
  Chk_Count   : Integer;
  jj_kind, jj_id     : STring;


implementation

uses Dbset; 


{$R *.dfm}

{*
procedure Tfrm_progress.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
    if (Msg.message = WM_KEYDOWN) then
       if (Msg.wParam = 13) then Msg.wParam := 9
end;
*}

procedure TFrm_Progress.FormCreate(Sender: TObject);
begin
     Chk_Count := 0;
end;

procedure TFrm_Progress.Sb_OKClick(Sender: TObject);
begin
//     ModalResult := mrOK;

     if AllowAccess then ModalResult := mrOK
     Else
     Begin
          if Chk_Count = 2 Then
               ModalResult := mrCancel
          Else
               Inc( Chk_Count );
     End;
end;

Function Tfrm_progress.AllowAccess : Boolean;
var
        var_ID, var_Passwd : String;
        var_result : Boolean;
Begin
        Screen.Cursor := crHourGlass;

        var_ID     := Trim(Edt_ID.Text);
        var_Passwd := Trim(Edt_Passwd.Text);

        var_result := Lib_UserCheck( var_id, var_Passwd );
        Screen.Cursor := crDefault;

        Result := var_result;
End;

Function TFrm_Progress.Lib_UserCheck( var_id, var_Passwd : String ) : Boolean;
var
   var_sql, var_nm, var_jno  : string;
   var_Result : Boolean;
begin
   var_sql := 'select * from userid where user_id=';
   var_sql := var_sql + '''' + var_id + '''' + ' and user_pw=';
   var_sql := var_sql + '''' + var_Passwd + '''';

   with Query1 do
   Begin
       Close;
       Sql.Clear;
       Sql.Add( var_sql );
       Open;

       var_nm  :=  FieldByName('USER_NM').AsString;
       var_jno :=  FieldByName('USER_JNO').AsString;
       jj_kind :=  FieldByName('USER_KIND').AsString;
       jj_id   :=  FieldByName('USER_ID').AsString;
       if  RecordCount = 0 then
       begin
           MesgStatusBar.SimpleText := '해당 사용자가 없습니다..다시 시도하여 주세요!';
//           MesgStatusBar.SimpleText := 'No such User! Please try again!';
           var_Result := False;
       end
       Else
       Begin  
         var_Result := True;
       end;
   End;

   Result := var_Result; 
end;

procedure TFrm_Progress.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := caFree;
end;

procedure TFrm_Progress.FormDestroy(Sender: TObject);
begin
     Frm_Progress := Nil;
end;

procedure TFrm_Progress.Sb_CancelClick(Sender: TObject);
begin
     ModalResult := mrCancel;
end;    

procedure TFrm_Progress.Edt_PasswdKeyPress(Sender: TObject; var Key: Char);
begin
       if Key = #13 then  begin
             if ( Trim(Edt_Passwd.Text ) = '' ) then begin
                     MesgStatusBar.SimpleText := '****【 비밀번호를 입력하여 주세요! 】****';
//                     MesgStatusBar.SimpleText := '****【 Please enter your password! 】****';
                     Edt_Passwd.SetFocus;
             End
             else Sb_OKClick(Sender);

             Key := #0;             
       End;
end;

procedure TFrm_Progress.Edt_IDKeyPress(Sender: TObject; var Key: Char);
begin
       if Key = #13 then begin
             if ( Trim(Edt_ID.Text ) = '' ) then begin
                     MesgStatusBar.SimpleText := '****【 아이디를 입력하여 주세요! 】****';
//                     MesgStatusBar.SimpleText := '****【 Please enter your ID! 】****';
                     Edt_ID.SetFocus;
             End
             else Edt_Passwd.SetFocus;

             Key := #0;
       End;
end;



end.

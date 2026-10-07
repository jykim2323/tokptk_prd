unit SFrm4110;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_4110 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    MesgStsBar: TStatusBar;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LocaMed: TMaskEdit;
    PltnoEd: TEdit;
    DateEd: TEdit;
    TimeEd: TEdit;
    ExitBitBtn: TBitBtn;
    ConfirmBitBtn: TBitBtn;
    FlagEd: TComboBox;
    LstkUpdateQuery: TADOQuery;
    EpltEd: TEdit;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocaMedKeyPress(Sender: TObject; var Key: Char);
    procedure FlagEdKeyPress(Sender: TObject; var Key: Char);
    procedure PltnoEdKeyPress(Sender: TObject; var Key: Char);    
    procedure DateEdKeyPress(Sender: TObject; var Key: Char);
    procedure TimeEdKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    procedure Update_Code;


  public
    { Public declarations }
    Bol_insert : Boolean;
    Bol_Update : Boolean;
    Bol_Delete : Boolean;
  end;

var
  SFrm_4110: TSFrm_4110;
  var_sql : String;

implementation

uses WinLib, FrmPrompt, FrmError, Frm4100;

{$R *.dfm}

procedure TSFrm_4110.FormCreate(Sender: TObject);
begin
  If Bol_Update Then Begin
     LocaMed.Enabled := False;
  End;

  If Bol_Delete Then Begin
     FlagEd.Enabled  := False;
     PltnoEd.Enabled := False;
     DateEd.Enabled  := False;
     TimeEd.Enabled  := False;
     EpltEd.Enabled  := False;
  End;
end;


procedure TSFrm_4110.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
   var_Msg := ' 정말로 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    If FlagEd.Text = '' then
    Begin
      WinLib_ErrorForm(' 상태를 등록 하십시요...');
      FlagEd.SetFocus;
      Exit;
    End;
    IF EpltEd.Text = '' Then
    Begin
       WinLib_ErrorForm(' PLT 종류를 입력 하십시요.....' );
       EpltEd.SetFocus;
       Exit;
    End;
    IF Length(Trim(pltnoEd.text)) <> 4 Then
    Begin
       WinLib_ErrorForm(' PLT No 4자리를 확인하세요.....' );
       PltNoEd.SetFocus;
       Exit;
    End;

   Update_Code;
   Close;
 end;
end;

procedure TSFrm_4110.Update_Code;
var
  StrFlag, StrLoca, StrPltNO  : String;
begin

  StrFlag := Copy(FlagEd.Text, 1, 1);

  var_sql := 'Update STK_MILSTK Set ';
  var_sql := var_sql + ' LSTK_FLAG       = '''+StrFlag+''',     LSTK_PLTNO = '''+PltnoEd.Text+''', ';
  var_sql := var_sql + ' LSTK_INDATE     = '''+DateEd.Text+''', LSTK_INTIME  = '''+TimeEd.Text+''', ';
  var_sql := var_sql + ' LSTK_EPLT       = '''+EpltEd.Text+'''           ';
  var_sql := var_sql + ' Where LSTK_LOCA = '''+LocaMEd.Text+'''          ';

  With LstkUpdateQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('저장위치 ' + LocaMEd.Text + ' 수정 에러!!!! ');
      Exit;
    End;
     MesgStsBar.SimpleText := '저장위치 ' + LocaMEd.Text + '를 수정 하였습니다...';

end;


procedure TSFrm_4110.LocaMedKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then FlagEd.SetFocus;
end;

procedure TSFrm_4110.FlagEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then PltnoEd.SetFocus;
end;

procedure TSFrm_4110.PltnoEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then DateEd.SetFocus;
end;

procedure TSFrm_4110.DateEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then TimeEd.SetFocus;
end;

procedure TSFrm_4110.TimeEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then EpltEd.SetFocus;
end;



procedure TSFrm_4110.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_4110.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSFrm_4110.FormDestroy(Sender: TObject);
begin
  SFrm_4110 := Nil;
end;


end.


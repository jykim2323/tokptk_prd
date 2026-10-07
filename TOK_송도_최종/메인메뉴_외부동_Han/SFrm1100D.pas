unit SFrm1100D;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_1100D = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    MesgStsBar: TStatusBar;
    MastUpdateQuery: TADOQuery;
    ConfirmBitBtn: TBitBtn;
    ExitBitBtn: TBitBtn;
    Query1: TADOQuery;
    Label8: TLabel;
    CodeEdit: TEdit;
    Label2: TLabel;
    NameEdit: TEdit;
    Label9: TLabel;
    BigoEdit: TEdit;
    Label3: TLabel;
    DateEdit: TMaskEdit;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }

    procedure Delete_code;

  public
    { Public declarations }
    Bol_insert : Boolean;
    Bol_Update : Boolean;
    Bol_Delete : Boolean;
  end;

var
  SFrm_1100D: TSFrm_1100D;
  var_sql, s_user : String;
  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];


implementation

uses DBSet,WinLib, FrmPrompt, FrmError, Frm2100;

{$R *.dfm}


procedure TSFrm_1100D.FormCreate(Sender: TObject);
begin
//   Cntl_MaterSelect_proc;
//   MaterCB.ItemIndex := -1;
end;     

procedure TSFrm_1100D.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
   var_Msg := ' 정말로 삭제 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    Delete_Code;
    Close;
  end;
end;

procedure TSFrm_1100D.Delete_code;
begin
 var_sql := ' Delete From MIMAST Where MAST_CODE = '''+codeEdit.Text+'''  ';
  With MastUpdateQuery Do
  begin
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      Begin
        WinLib_ErrorForm('부품코드  ' + CodeEdit.Text + ' 삭제 에러!!!! ');
        Exit;
      End;
    End;
  end;
    MesgStsBar.SimpleText := '부품코드 ' + CodeEdit.Text + '를 삭제 하였습니다.';
end;

procedure TSFrm_1100D.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_1100D.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSFrm_1100D.FormDestroy(Sender: TObject);
begin
  SFrm_1100D := Nil;
end;

end.


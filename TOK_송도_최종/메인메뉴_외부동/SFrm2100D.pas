unit SFrm2100D;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_2100D = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label8: TLabel;
    MesgStsBar: TStatusBar;
    NameEdit: TEdit;
    MastUpdateQuery: TADOQuery;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CaseEdit: TEdit;
    UnitEdit: TEdit;
    ConfirmBitBtn: TBitBtn;
    Label1: TLabel;
    GubnCB: TComboBox;
    Label3: TLabel;
    MaterCB: TComboBox;
    Label9: TLabel;
    Label10: TLabel;
    HotCB: TComboBox;
    BigoEdit: TEdit;
    ExitBitBtn: TBitBtn;
    PieEdit: TEdit;
    Query1: TADOQuery;
    CodeEdit: TMaskEdit;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }

    procedure Delete_code;
    procedure Cntl_MaterSelect_proc;

  public
    { Public declarations }
    Bol_insert : Boolean;
    Bol_Update : Boolean;
    Bol_Delete : Boolean;
  end;

var
  SFrm_2100D: TSFrm_2100D;
  var_sql, s_user : String;
  sys_datetime  : string[14];
  s_date : string[8];
  s_time : string[6];


implementation

uses DBSet,WinLib, FrmPrompt, FrmError, Frm2100;

{$R *.dfm}


procedure TSFrm_2100D.FormCreate(Sender: TObject);
begin
   Cntl_MaterSelect_proc;
   MaterCB.ItemIndex := -1;
end;

procedure TSFrm_2100D.Cntl_MaterSelect_proc;
begin
  MaterCB.Items.Clear;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(' select Matter_code, Matter_Name from MatterKind ');
  Query1.Open;
  Query1.First;

  While True do
  begin
    if Query1.Eof = True then break;
    MaterCB.Items.Add(Query1.Fields[0].AsString + '-' + Query1.Fields[1].AsString);
    Query1.Next;
  end;
end;

procedure TSFrm_2100D.ConfirmBitBtnClick(Sender: TObject);
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

procedure TSFrm_2100D.Delete_code;
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
        WinLib_ErrorForm('품목코드  ' + CodeEdit.Text + ' 삭제 에러!!!! ');
        Exit;
      End;
    End;
  end;
    MesgStsBar.SimpleText := '품목코드 ' + CodeEdit.Text + '를 삭제 하였습니다.';
end;

procedure TSFrm_2100D.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_2100D.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSFrm_2100D.FormDestroy(Sender: TObject);
begin
  SFrm_2100D := Nil;
end;

end.


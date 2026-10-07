unit SFrm6110;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB, ComCtrls, DBTables;

type
  TSFrm_6110 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    TitleLbl: TLabel;
    MesgStsBar: TStatusBar;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LocaMed: TMaskEdit;
    DateEd: TEdit;
    TimeEd: TEdit;
    ExitBitBtn: TBitBtn;
    ConfirmBitBtn: TBitBtn;
    FlagEd: TComboBox;
    LstkUpdateQuery: TADOQuery;
    Label1: TLabel;
    pltNoEd: TEdit;

    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocaMedKeyPress(Sender: TObject; var Key: Char);
    procedure FlagEdKeyPress(Sender: TObject; var Key: Char);     
    procedure QtyEdKeyPress(Sender: TObject; var Key: Char);
    procedure DateEdKeyPress(Sender: TObject; var Key: Char);
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
  SFrm_6110: TSFrm_6110;
  var_sql : String;

implementation

uses WinLib, FrmPrompt, FrmError, Frm6100;

{$R *.dfm}

procedure TSFrm_6110.FormCreate(Sender: TObject);
begin
  If Bol_Update Then Begin
     LocaMed.Enabled := False;
  End;

  If Bol_Delete Then Begin
     FlagEd.Enabled := False;          
     DateEd.Enabled := False;
     TimeEd.Enabled := False; 
  End;
end;


procedure TSFrm_6110.ConfirmBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
   var_Msg := ' 정말로 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    // Valitaion Check
    If FlagEd.Text = '' then
    Begin
      WinLib_ErrorForm(' 상태를 등록 하십시요...');
      FlagEd.SetFocus;
      Exit;
    End;


   Update_Code;
   Close;
 end;
end;

procedure TSFrm_6110.Update_Code;
var
  StrFlag : String;
  StrInDate, StrInTime, StrPltNo, StrLoca : String;
begin

  StrFlag := Copy(FlagEd.Text, 1, 1);
  StrInDate := DateEd.Text;
  StrInTime := TimeEd.Text;
  StrPltNo  := PltNoEd.Text;
  StrLoca   := LocaMEd.Text;


  While Pos('-', StrInDate) > 0 Do Begin Delete(StrInDate, Pos('-', StrInDate), 1); End;
  While Pos(':', StrInTime) > 0 Do Begin Delete(StrInTime, Pos(':', StrInTime), 1); End;
  While Pos('-', StrLoca) > 0 Do Begin Delete(StrLoca, Pos('-', StrLoca), 1); End;

  {
  var_sql := 'Update T2MILSTK Set ';
  var_sql := var_sql + ' LSTK_FLAG       = '''+StrFlag+''',  '; // 0 - 비어 있슴, 1 - 재품 있슴, X - 입고 예약, Y - 출고 예약, W - 이중 입고, E - 공 출고, N - 사용 금지
  var_sql := var_sql + ' LSTK_INDATE     = '''+DateEd.Text+''', LSTK_INTIME  = '''+TimeEd.Text+''', LSTK_PLTNO = '''+PltNoEd.Text+''' ';
  var_sql := var_sql + ' Where LSTK_LOCA = '''+LocaMEd.Text+''' ';
  }
  var_sql := 'Update T2MILSTK Set ';
  var_sql := var_sql + ' LSTK_FLAG       = '''+StrFlag+''',  '; // 0 - 비어 있슴, 1 - 재품 있슴, X - 입고 예약, Y - 출고 예약, W - 이중 입고, E - 공 출고, N - 사용 금지
  var_sql := var_sql + ' LSTK_INDATE     = '''+StrInDate+''', LSTK_INTIME  = '''+StrInTime+''' ';
  var_sql := var_sql + ' Where LSTK_LOCA = '''+StrLoca+''' ';

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


procedure TSFrm_6110.LocaMedKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then FlagEd.SetFocus;
end;

procedure TSFrm_6110.FlagEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then DateEd.SetFocus;
end; 

procedure TSFrm_6110.QtyEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then DateEd.SetFocus;
end;

procedure TSFrm_6110.DateEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then TimeEd.SetFocus;
end; 

procedure TSFrm_6110.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSFrm_6110.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSFrm_6110.FormDestroy(Sender: TObject);
begin
  SFrm_6110 := Nil;
end;


end.


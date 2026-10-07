unit TrakDisp_u;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Db, DBTables, Mask, ADODB;

type
  TTrakDisp_F = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    ExitBitBtn: TBitBtn;
    InsertBitBtn: TBitBtn;
    DeleteBitBtn: TBitBtn;
    DispBitBtn: TBitBtn;
    indexCB: TComboBox;
    Panel8: TPanel;
    TraknoEdit: TComboBox;
    Panel9: TPanel;
    DateEdit: TEdit;
    TimeEdit: TEdit;
    Panel10: TPanel;
    GubunCB: TComboBox;
    Panel4: TPanel;
    FlagEdit: TComboBox;
    TrakQuery: TADOQuery;
    Panel2: TPanel;
    LocaEdit: TMaskEdit;
    Panel11: TPanel;
    HighEdit: TEdit;
    MoveTrakNoCB: TComboBox;
    MoveBitBtn: TBitBtn;
    Panel5: TPanel;
    pltNoEdit: TEdit;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure TraknoEditChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DispBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject); 
    procedure InsertBitBtnClick(Sender: TObject);
    procedure MoveBitBtnClick(Sender: TObject);   
    procedure MoveTrakNoCBChange(Sender: TObject);
  private
    { Private declarations }
    procedure TrakNo_ComboBox_Insert;
  public
    { Public declarations }
  end;

var
  TrakDisp_F: TTrakDisp_F;

  StrQry : String;

implementation

uses Dbset, WinLib, FrmPrompt, FrmError;

{$R *.DFM}



procedure TTrakDisp_F.FormActivate(Sender: TObject);
begin
  MoveTrakNoCB.Visible := False;
  TrakNo_ComboBox_Insert;

  StrQry := ' Select TRAK_INDEX, TRAK_LOCA,  ';
  StrQry := StrQry +'  TRAK_GUBUN, TRAK_HIGH, TRAK_FLAG, TRAK_DATE, TRAK_TIME, TRAK_PLTNO ';
  StrQry := StrQry +'  From T2TBTRAK (NOLOCK)  Where TRAK_NO = '''+TraknoEdit.Text+''' ';

  With TrakQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    IndexCB.Text   := FieldByName('TRAK_INDEX').AsString;

    LocaEdit.TExt  := FieldByName('TRAK_LOCA').AsString;
    GubunCB.Text   := FieldByName('TRAK_GUBUN').AsString;
    FlagEdit.TExt  := FieldByName('TRAK_FLAG').AsString;
    HighEdit.TExt  := FieldByName('TRAK_HIGH').AsString;
    DateEdit.TExt  := FieldByName('TRAK_DATE').AsString;
    TimeEdit.TExt  := FieldByName('TRAK_TIME').AsString;
    pltNoEdit.Text := FieldByName('TRAK_PLTNO').AsString;
  End;
end;

procedure TTrakDisp_F.TrakNo_ComboBox_Insert;
var
  IntPos : Integer;
  StrPos, SavePos, StrPos1 : String;
begin
  SavePos := TraknoEdit.Text;
  StrQry := ' Select TRAK_NO From T2TBTRAK (NOLOCK) ';
  StrQry := StrQry + ' Order By TRAK_NO ';

  With TrakQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    TraknoEdit.Clear;
    MoveTrakNoCB.Clear;
    
    While Not Eof Do Begin
      IntPos := FieldByName('TRAK_NO').ASInteger;
      StrPos := Format('%2.2d', [IntPos]);
      TraknoEdit.Items.Add(StrPos);
      MoveTrakNoCB.Items.Add(StrPos);
      Next;
    End;
  End;
  TraknoEdit.Text := SavePos;
end;

procedure TTrakDisp_F.TraknoEditChange(Sender: TObject);
begin

  StrQry := ' Select TRAK_INDEX,  TRAK_LOCA,  ';
  StrQry := StrQry +'  TRAK_GUBUN, TRAK_HIGH, TRAK_FLAG, TRAK_DATE, TRAK_TIME, TRAK_PLTNO ';
  StrQry := StrQry +'  From T2TBTRAK (NOLOCK)  Where TRAK_NO = '''+TraknoEdit.Text+''' ';

  With TrakQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    IndexCB.Text   := FieldByName('TRAK_INDEX').AsString;

    LocaEdit.TExt  := FieldByName('TRAK_LOCA').AsString;
    GubunCB.Text   := FieldByName('TRAK_GUBUN').AsString;
    FlagEdit.TExt  := FieldByName('TRAK_FLAG').AsString;
    HighEdit.TExt  := FieldByName('TRAK_HIGH').AsString;
    DateEdit.TExt  := FieldByName('TRAK_DATE').AsString;
    TimeEdit.TExt  := FieldByName('TRAK_TIME').AsString;
    pltNoEdit.TExt := FieldByName('TRAK_PLTNO').AsString;

  End;
end;


procedure TTrakDisp_F.DispBitBtnClick(Sender: TObject);
begin
  StrQry := ' Select TRAK_INDEX, TRAK_LOCA,  ';
  StrQry := StrQry +'  TRAK_GUBUN, TRAK_HIGH, TRAK_FLAG, TRAK_DATE, TRAK_TIME, TRAK_PLTNO ';
  StrQry := StrQry +'  From T2TBTRAK (NOLOCK)  Where TRAK_NO = '''+TraknoEdit.Text+''' ';

  With TrakQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    IndexCB.Text   := FieldByName('TRAK_INDEX').AsString;
 
    LocaEdit.TExt  := FieldByName('TRAK_LOCA').AsString;
    GubunCB.Text   := FieldByName('TRAK_GUBUN').AsString;
    FlagEdit.TExt  := FieldByName('TRAK_FLAG').AsString;
    HighEdit.TExt  := FieldByName('TRAK_HIGH').AsString;
    DateEdit.TExt  := FieldByName('TRAK_DATE').AsString;
    TimeEdit.TExt  := FieldByName('TRAK_TIME').AsString;
    pltnoEdit.Text := FieldByName('TRAK_PLTNO').AsString;
  End;
end;  

procedure TTrakDisp_F.DeleteBitBtnClick(Sender: TObject);
var
  StrMsg, ls_loca : String;
begin
  StrMsg := TraknoEdit.Text + ' 구간의 데이타를 삭제 하겠습니까?';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin  Exit;    End;

  StrQry := ' UpDate T2TBTRAK Set ';
  StrQry := StrQry + ' TRAK_INDEX = '''', ';
  StrQry := StrQry + ' TRAK_LOCA  = '''', TRAK_GUBUN = '''', TRAK_HIGH = '''',   ';
  StrQry := StrQry + ' TRAK_FLAG  = '''', TRAK_DATE    = '''',  TRAK_TIME  = '''', TRAK_PLTNO = ''''  ';
  StrQry := StrQry + ' Where TRAK_NO = '''+TraknoEdit.Text+''' ';
  Try
    With TrakQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSQL;
    End;
  Except
  End;

  StrQry := ' Delete From T2MIINPT Where INPT_INDEX = '''+IndexCb.Text+''' ';
  Try
    With TrakQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSQL;
    End;
  Except
  End;

  ls_loca := Trim(LocaEdit.Text);
  if (Length(ls_loca) <> 4) then exit;

  StrQry := 'Update T2MILSTK Set ';
  StrQry := StrQry + ' LSTK_FLAG = ''0''                ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+ls_loca+'''  ';
  Try
    With TrakQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSQL;
    End;
  Except
  End;

  Close;
end;

procedure TTrakDisp_F.InsertBitBtnClick(Sender: TObject);
begin

  StrQry := ' Update T2TBTRAK Set ';
  StrQry := StrQry + ' TRAK_INDEX = '''+indexCB.Text+''',  TRAK_HIGH   = '''+HighEdit.Text+''', ';
  StrQry := StrQry + ' TRAK_LOCA  = '''+LocaEdit.Text+''', TRAK_GUBUN   = '''+GubunCB.Text+''',  ';
  StrQry := StrQry + ' TRAK_FLAG  = '''+FlagEdit.Text+''', TRAK_DATE    = '''+DateEdit.Text+''',  ';
  StrQry := StrQry + ' TRAK_TIME  = '''+TimeEdit.Text+''', TRAK_PLTNO = '''+pltNoEdit.Text+'''      ';
  StrQry := StrQry + ' Where TRAK_NO = '''+TraknoEdit.Text+''' ';
  Try
    With TrakQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSQL;
    End;
  Except
   showmessage(StrQry);

  End;

  Close;
end;

procedure TTrakDisp_F.ExitBitBtnClick(Sender: TObject);
begin

  Close;
end;

procedure TTrakDisp_F.MoveBitBtnClick(Sender: TObject);
begin
  MoveTrakNoCB.Text := TraknoEdit.Text;
  MoveTrakNoCB.Visible := True;
end;

procedure TTrakDisp_F.MoveTrakNoCBChange(Sender: TObject);
var
   StrIndex, Strhigh,  StrLoca, StrGubun, StrFlag, StrDate, StrTime, StrPltno : string; // StrPltno 추가

begin
  StrQry := ' Select * From T2TBTRAK (NOLOCK) Where Trak_no = '''+TraknoEdit.Text+''' ';

  With TrakQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    StrIndex   := FieldByName('TRAK_INDEX').AsString;
    StrGubun   := FieldByName('TRAK_GUBUN').AsString;
    StrLoca    := FieldByName('TRAK_LOCA').AsString;
    StrDate    := FieldByName('TRAK_DATE').AsString;
    StrTime    := FieldByName('TRAK_TIME').AsString;
    StrFlag    := FieldByName('TRAK_FlAG').AsString;
    Strhigh    := FieldByName('TRAK_HIGH').AsString;
    StrPltno   := FieldByName('TRAK_PLTNO').AsString;   // 김준영 추가 
  End;


  StrQry := ' Update T2TBTRAK Set ';
  StrQry := StrQry + ' TRAK_INDEX = '''+indexCB.Text+''',  TRAK_HIGH   = '''+HighEdit.Text+''', ';
//
  if  (StrGubun = 'I')   then  StrQry := StrQry + ' TRAK_LOCA  = '''', '
  else  StrQry := StrQry + ' TRAK_LOCA  = '''+LocaEdit.Text+''', ';
//
  StrQry := StrQry + ' TRAK_GUBUN = '''+GubunCB.Text+''',  ';
  StrQry := StrQry + ' TRAK_FLAG  = '''+FlagEdit.Text+''', TRAK_DATE    = '''+DateEdit.Text+''',  ';
  StrQry := StrQry + ' TRAK_TIME  = '''+TimeEdit.Text+''', TRAK_PLTNO = '''+pltNoEdit.Text+''' ';  // 김준영 추가
  StrQry := StrQry + ' Where TRAK_NO = '''+MoveTraknoCB.Text+''' ';
  Try
    With TrakQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSQL;
    End;
  Except
  End;
//
 StrQry := ' Update T2MILSTK Set LSTK_FLAG = ''0''  Where LSTK_LOCA = '''+StrLoca+''' ';
 Try
    With TrakQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSQL;
    End;
  Except
  End;
//

  StrQry := ' UpDate T2TBTRAK Set ';
  StrQry := StrQry + ' TRAK_INDEX   = '''', TRAK_GUBUN = '''', ';
  StrQry := StrQry + ' TRAK_LOCA  = '''', TRAK_DATE  = '''', ';
  StrQry := StrQry + ' TRAK_HIGH    = '''',  ';
  StrQry := StrQry + ' TRAK_TIME    = '''', TRAK_FlAG  = '''', TRAK_PLTNO = ''''   ';
  StrQry := StrQry + ' Where TRAK_NO = '''+TraknoEdit.Text+''' ';
  Try
    With TrakQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      ExecSQL;
    End;
  Except
  End;
  MoveTrakNoCB.Visible := False;
  TraknoEdit.Text := MoveTrakNoCB.Text;
  Showmessage('이동완료 !!!');
end;

end.

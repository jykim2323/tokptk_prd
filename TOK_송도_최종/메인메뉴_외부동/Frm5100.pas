unit Frm5100;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, DB,
  DBTables, ADODB, QRCtrls, QuickRpt;

type
  TFrm_5100 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    PrintBitBtn: TSpeedButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Query1: TADOQuery;
    ExlBtn: TSpeedButton;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText8: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel6: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel7: TQRLabel;
    DeleteBitBtn: TSpeedButton;
    UpdtQuery: TADOQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    BCDField1: TBCDField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    Query1INPT_LOCA: TStringField;
    Query1INPT_JOB_FLAG: TStringField;
    RecNoEdit: TEdit;
    QRLabel3: TQRLabel;
    QRDBText5: TQRDBText;
    Query1INPT_INDEX: TStringField;
    Query1INPT_INDATE: TStringField;
    Query1INPT_STIME: TStringField;
    Query1INPT_TRAINNO: TStringField;
    Query1INPT_WSNO: TStringField;
    GroupBox1: TGroupBox;
    Rb2: TRadioButton;
    Rb1: TRadioButton;
    Rb3: TRadioButton;
    Panel2: TPanel;
    StartBitBtn: TSpeedButton;
    Label1: TLabel;
    Panel9: TPanel;
    FromDate: TDateTimePicker;
    ToDate: TDateTimePicker;
    Panel4: TPanel;
    TrnoEdit: TMaskEdit;
    QRLabel1: TQRLabel;
    QRDBText1: TQRDBText;
    Btn_Kpad: TSpeedButton;
    PnlKeyPad: TPanel;
    BtnNum7: TButton;
    BtnNum8: TButton;
    BtnNum9: TButton;
    BtnNum6: TButton;
    BtnNum5: TButton;
    BtnNum4: TButton;
    BtnNum1: TButton;
    BtnNum2: TButton;
    BtnNum3: TButton;
    BtnBS: TButton;
    BtnClear: TButton;
    BtnNum0: TButton;
    Btn_Enter: TButton;
    BtnExit: TButton;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);  
    procedure PrintBitBtnClick(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
    procedure Query1INPT_GUBUNGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure SelRGClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Query1INPT_JOB_FLAGGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure RbClick(Sender: TObject);
    procedure Btn_KpadClick(Sender: TObject);
    procedure BtnNum0Click(Sender: TObject);
    procedure BtnNum1Click(Sender: TObject);
    procedure BtnNum2Click(Sender: TObject);
    procedure BtnNum3Click(Sender: TObject);
    procedure BtnNum4Click(Sender: TObject);
    procedure BtnNum5Click(Sender: TObject);
    procedure BtnNum6Click(Sender: TObject);
    procedure BtnNum7Click(Sender: TObject);
    procedure BtnNum8Click(Sender: TObject);
    procedure BtnNum9Click(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnBSClick(Sender: TObject);
    procedure Btn_EnterClick(Sender: TObject);
    procedure TrnoEditClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    
  private
    { Private declarations }
    procedure MouseWheelHandler(var Message: TMessage); override;

    function GetAKeyPad(nNum : string ): string;
    procedure Focusset;
  public
    { Public declarations }
  end;

var
  Frm_5100: TFrm_5100;

  var_Sql : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate : String;
  StrDate1, StrDate2, s_index, s_trno : String;

  g_focus : integer;
implementation

uses WinLib, FrmPrompt, FrmError, DbSet;

{$R *.dfm} 


procedure TFrm_5100.FormCreate(Sender: TObject);
begin   
  FromDate.Date := Now;   ToDate.Date := Now;
  rb1.checked := True;                       
  StartBitBtnClick(Self);
end;

procedure TFrm_5100.StartBitBtnClick(Sender: TObject);
begin
  StrDate1 := FormatDateTime('yyyymmdd', FromDate.Date);
  StrDate2 := FormatDateTime('yyyymmdd', ToDate.Date);

  var_Sql := ' Select INPT_INDEX, INPT_INDATE, INPT_STIME, INPT_TRAINNO, ';
  var_Sql := var_Sql + ' INPT_LOCA, INPT_JOB_FLAG, INPT_WSNO  ';
  var_Sql := var_Sql + ' From STK1_MIINPT (NOLOCK) ';
  var_Sql := var_Sql + ' Where  INPT_INDATE >= '''+StrDate1+'''  And INPT_INDATE <= '''+StrDate2+''' ';
  var_Sql := var_Sql + '  And INPT_TRAINNO  like ''%'+TrnoEdit.Text+'%'' ';

  If rb2.Checked = True then  var_Sql := var_Sql + ' AND  INPT_WSNO = ''1'' ';
  If rb3.Checked = True then  var_Sql := var_Sql + ' AND  INPT_WSNO = ''2'' ';

  var_Sql := var_Sql + '  Order by  INPT_INDEX,  INPT_TRAINNO  ';

  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
  end;

  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);

end;

procedure TFrm_5100.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    s_index := Query1.FieldByName('INPT_INDEX').AsString;
    s_trno  := Query1.FieldByName('INPT_TRAINNO').AsString;
end;   

procedure TFrm_5100.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '입고 이력 현황');
 end;
end;

procedure TFrm_5100.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg('정말로 인쇄 합니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_5100.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_5100.FormDestroy(Sender: TObject);
begin
  Frm_5100 := Nil;
end;

procedure TFrm_5100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_5100.Query1INPT_GUBUNGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   if Sender.Value = 'N'  then Text := '정상'
   else if Sender.Value = 'Y'  then Text := '불량'
   else Text := '';
end;

procedure TFrm_5100.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg, var_Sql : String;
begin
  var_Msg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From STK1_MIINPT  Where INPT_TRAINNO    = '''+s_trno+'''  ';
    var_sql := var_sql + '            And INPT_INDEX   = '''+s_index+'''    ';   

    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('입고이력 ' + s_trno + ' 삭제 에러!!!! ');
      Exit;
    End;
    StartBitBtnClick(Self);
  end;
end;

procedure TFrm_5100.SelRGClick(Sender: TObject);
begin
   StartBitBtnClick(Self);
end;

procedure TFrm_5100.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_5100.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    Value : String;
    WW    : Integer;
begin
  If DataCol = 0 Then
  begin
   with(Sender as TDBGrid).Canvas do
   begin
    Value := IntToStr(Query1.RecNo);
    WW    := Canvas.TextWidth(value);
    TextOut(Rect.Left+(Rect.Right - Rect.Left - WW) div 2, Rect.Top+2,Value);
   end;
  end;   
end;

procedure TFrm_5100.DBGrid1TitleClick(Column: TColumn);
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

procedure TFrm_5100.Query1INPT_JOB_FLAGGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   if Sender.Value = 'N'  then Text := '대기'
   else if Sender.Value = '*'  then Text := '완료'
   else Text := '';
end;

procedure TFrm_5100.RbClick(Sender: TObject);
begin
   StartBitBtnClick(Self);
end;

/////////////////////////////KeyPad/////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFrm_5100.Btn_KpadClick(Sender: TObject);
begin
  PnlKeyPad.Visible := True;
end;

procedure TFrm_5100.BtnNum0Click(Sender: TObject);
begin
  GetAKeyPad('0');
end;

procedure TFrm_5100.BtnNum1Click(Sender: TObject);
begin
  GetAKeyPad('1');
end;

procedure TFrm_5100.BtnNum2Click(Sender: TObject);
begin
  GetAKeyPad('2');
end;

procedure TFrm_5100.BtnNum3Click(Sender: TObject);
begin
  GetAKeyPad('3');
end;

procedure TFrm_5100.BtnNum4Click(Sender: TObject);
begin
  GetAKeyPad('4');
end;

procedure TFrm_5100.BtnNum5Click(Sender: TObject);
begin
  GetAKeyPad('5');
end;

procedure TFrm_5100.BtnNum6Click(Sender: TObject);
begin
  GetAKeyPad('6');
end;

procedure TFrm_5100.BtnNum7Click(Sender: TObject);
begin
  GetAKeyPad('7');
end;

procedure TFrm_5100.BtnNum8Click(Sender: TObject);
begin
  GetAKeyPad('8');
end;

procedure TFrm_5100.BtnNum9Click(Sender: TObject);
begin
  GetAKeyPad('9');
end;

procedure TFrm_5100.BtnClearClick(Sender: TObject);
begin
  GetAKeyPad('CL');
end;
        
procedure TFrm_5100.BtnBSClick(Sender: TObject);
begin
  GetAKeyPad('Bk');
end;

procedure TFrm_5100.Btn_EnterClick(Sender: TObject);
begin
  Focusset();
    case g_focus of
        //--- 입고 터미널
        1:
        begin
            TrnoEdit.Color := $0080FF80 ;
            TrnoEdit.SetFocus;
        end;
    end;
end;

procedure TFrm_5100.Focusset;
begin
    TrnoEdit.Color  := clInfoBk;
end;

procedure TFrm_5100.BtnExitClick(Sender: TObject);
begin
  PnlKeyPad.Visible := false;
end;

procedure TFrm_5100.TrnoEditClick(Sender: TObject);
begin
  g_focus := 1;
  Btn_EnterClick(Self);
end;

function TFrm_5100.GetAKeyPad(nNum: string): string;
begin
    case g_focus of
    //---입고터미널
        1:
        begin
            if nNum='Bk' then
                TrnoEdit.Text := copy(TrnoEdit.Text,1,Length(TrnoEdit.Text)-1)
            else if nNum='CL' then
                TrnoEdit.Text := ''
            else if Length(TrnoEdit.Text) <5 then
                TrnoEdit.Text := TrnoEdit.Text + nNum
            else
                TrnoEdit.Text :=  nNum;
        end;

    end;
end;

end.

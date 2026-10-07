unit Frm4400;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Mask, ComCtrls, Buttons, ExtCtrls, Db,
  DBTables, ADODB, QRCtrls, QuickRpt;

type
  TFrm_4400 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    Panel2: TPanel;
    StartBitBtn: TSpeedButton;
    Panel9: TPanel;
    DataSource1: TDataSource;
    DeleteBitBtn: TSpeedButton;
    UpdtQuery: TADOQuery;
    ExlBtn: TSpeedButton;
    SeltCB: TComboBox;
    ItemCB: TEdit;
    FromDate: TDateTimePicker;
    Label1: TLabel;
    ToDate: TDateTimePicker;
    Label2: TLabel;
    RecNoEdit: TEdit;
    PrintBitBtn: TSpeedButton;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText6: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel12: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel13: TQRLabel;
    QRDBText7: TQRDBText;
    Query1: TADOQuery;
    Query1OUPT_DATE: TStringField;
    Query1OUPT_TIME: TStringField;
    Query1OUPT_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1OUPT_LOTNO: TStringField;
    Query1OUPT_LOCA: TStringField;
    Query1OUPT_WGT: TBCDField;
    Query1OUPT_OUT_WGT: TBCDField;
    Query1OUPT_INDEX: TStringField;
    Query1OUPT_REMARK: TStringField;
    Query1OUPT_BOXNO: TStringField;
    Query1OUPT_SEQNO: TIntegerField;
    Query1OUPT_CHASU: TStringField;
    Query1OUPT_JOB_FLAG: TStringField;
    Query1OUPT_ID: TStringField;
    DBGrid1: TDBGrid;
    Query1OUPT_CUST: TStringField;
    QRLabel2: TQRLabel;
    QRLabel6: TQRLabel;
    QRDBText8: TQRDBText;
    Query1OUPT_REMARK1: TStringField;
    Query1OUPT_BOXNO1: TStringField;
    QRLabel8: TQRLabel;
    QRLabel14: TQRLabel;
    QRDBText10: TQRDBText;
    QRDBText13: TQRDBText;
    Query1OUPT_PLTNO: TStringField;
    custCB: TComboBox;
    Panel3: TPanel;
    procedure StartBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure ExlBtnClick(Sender: TObject);
   
    procedure SelRGClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure ItemCBKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure SetCustComboBox;
  public
    { Public declarations }
  end;

var
  Frm_4400: TFrm_4400;

  var_Sql, s_index, s_code, s_lotno : String;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrDate1, StrDate2: String;
  
implementation

uses DbSet, WinLib, FrmPrompt, FrmError, FrmProgress;
{$R *.dfm}

procedure TFrm_4400.FormCreate(Sender: TObject);
begin

  if (jj_kind <> '50') then
  begin
    DeleteBitBtn.Visible    := False;   
  end;

  FromDate.Date := Now;   ToDate.Date := Now;

  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  //거래처 콤보박스
  SetCustComboBox;

  SeltCB.ItemIndex := 0;
  StartBitBtnClick(Self);

end;

procedure TFrm_4400.StartBitBtnClick(Sender: TObject);
begin

  StrDate1 := FormatDateTime('yyyymmdd', FromDate.Date);
  StrDate2 := FormatDateTime('yyyymmdd', ToDate.Date); 

  var_Sql := ' Select OUPT_DATE, OUPT_INDEX, OUPT_CODE, MAST_NAME,  OUPT_LOTNO, OUPT_SEQNO, ';
  var_Sql := var_Sql + ' OUPT_GUBUN,  OUPT_WGT, OUPT_OUT_WGT,  OUPT_LOCA, ';
  var_Sql := var_Sql + ' OUPT_TIME,   OUPT_JOB_FLAG,  OUPT_REMARK, OUPT_ID, OUPT_BOXNO, OUPT_CHASU, OUPT_CUST, ';
  var_Sql := var_Sql + ' OUPT_REMARK1, OUPT_BOXNO1, OUPT_PLTNO ';
  var_Sql := var_Sql + ' From T2MIOUPT (NOLOCK) ';
  var_Sql := var_Sql + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = OUPT_CODE  ';
  var_Sql := var_Sql + ' Where ISNULL(OUPT_CODE, '''') <> ''''  ';
  var_Sql := var_Sql + '  and OUPT_DATE  >= '''+StrDate1+'''  and   OUPT_DATE  <= '''+StrDate2+'''  ';
  var_Sql := var_Sql + '   And  OUPT_JOB_FLAG   <> ''0''           ';
  //var_Sql := var_Sql + '   AND   OUPT_OUT_WGT   <> Convert(Numeric,''0'') ';

  // 공란이 아닐 경우에만 실행, 대소문자 구분 없이(UPPER), 양쪽 % 포함 검색
  if Length(Trim(custCB.Text)) > 0 then
  begin
     var_Sql := var_Sql + ' AND UPPER(OUPT_CUST) LIKE ''%' + UpperCase(Trim(custCB.Text)) + '%'' ';
  end;

  {
  if  SeltCB.ItemIndex = 1      then   begin
      //var_Sql := var_Sql + '  And OUPT_CODE   LIKE '''+itemCB.Text+'%'' ';
      var_Sql := var_Sql + '  And OUPT_CODE   = '''+itemCB.Text+''' ';
      var_Sql := var_Sql + '   Order by OUPT_CODE,  OUPT_INDEX     '
  end
  else if SeltCB.ItemIndex = 2  then   begin
      var_Sql := var_Sql + '  And MAST_NAME  LIKE ''%'+itemCB.Text+'%'' ';
      var_Sql := var_Sql + '   Order by OUPT_LOTNO,  OUPT_INDEX     '
  end
  }
  if SeltCB.ItemIndex = 1 then begin
      if Trim(itemCB.Text) <> '' then
          var_Sql := var_Sql + '  And OUPT_CODE = '''+Trim(itemCB.Text)+''' ';
      var_Sql := var_Sql + '   Order by OUPT_CODE,  OUPT_INDEX     ';
  end
  else if SeltCB.ItemIndex = 2 then begin
      if Trim(itemCB.Text) <> '' then
          var_Sql := var_Sql + '  And MAST_NAME LIKE ''%'+Trim(itemCB.Text)+'%'' ';
      var_Sql := var_Sql + '   Order by OUPT_LOTNO,  OUPT_INDEX     ';
  end

  else if SeltCB.ItemIndex = 3  then   begin
      var_Sql := var_Sql + '  And OUPT_LOTNO  = '''+itemCB.Text+''' ';
      var_Sql := var_Sql + '   Order by OUPT_LOTNO,  OUPT_INDEX     '
  end
  else if SeltCB.ItemIndex = 4  then   begin
      var_Sql := var_Sql + '  And OUPT_LOCA   = '''+itemCB.Text+''' ';
      var_Sql := var_Sql + '   Order by OUPT_LOCA,  OUPT_INDEX     '
  end
  else
  begin
      var_Sql := var_Sql + '   Order by  OUPT_INDEX,  OUPT_CODE  ';
  end;

  with Query1 Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
  end;
  RecNoEdit.Text := Format('%d',[Query1.RecordCount]);
end;

procedure TFrm_4400.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
  var_Msg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From T2MIOUPT Where OUPT_INDEX  = '''+s_index+'''  ';
    var_sql := var_sql + ' And  OUPT_CODE  = '''+s_code+''' ';
    var_sql := var_sql + ' And  OUPT_LOTNO = '''+s_lotno+''' ';
    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('출고예약 ' + s_index  + ' 삭제 에러!!!! ');
      Exit;
    End;
    StartBitBtnClick(Self);
  end;
end;

procedure TFrm_4400.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    s_index  := Query1.FieldByName('OUPT_Index').AsString;
    s_code   := Query1.FieldByName('OUPT_code').AsString;
    s_lotno  := Query1.FieldByName('OUPT_lotno').AsString;
end;


procedure TFrm_4400.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_4400.FormDestroy(Sender: TObject);
begin
  Frm_4400 := Nil;
end;

procedure TFrm_4400.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TFrm_4400.ExlBtnClick(Sender: TObject);
begin
 if Query1.Active = False then Exit;

 if Query1.RecordCount <= 0 then
 begin
    MessageDlg('액셀로 저장할 데이타가 없습니다.!!! ', mtInformation,[mbOk], 0);
    Exit;
 end;

 if MessageDlg('해당 조회건을 액셀로 저장할까요 ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
     DM1.GridToExel(query1, '출고 이력 현황');
 end;
end;


procedure TFrm_4400.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_4400.SelRGClick(Sender: TObject);
begin
   StartBitBtnClick(Self);
end;

procedure TFrm_4400.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
    ls_use, Value, ls_rsrv : String;
    WW     : Integer;
    xDBGrid: TDBGrid;
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

procedure TFrm_4400.DBGrid1TitleClick(Column: TColumn);
begin
   if Column.Field.DataSet is TADOQuery then
   with TADOQuery(Column.Field.DataSet) do begin
     if (Pos(Column.FieldName + ' DESC', Sort) > 0) or ( Sort = '' ) then
       Sort := Column.FieldName + ' ASC'
     else
       Sort := Column.FieldName + ' DESC';
   end;
end;

procedure TFrm_4400.MouseWheelHandler(var Message: TMessage);
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

procedure TFrm_4400.SetCustComboBox;
var
  ls_sql, ls_code, ls_name, ls_display : String;
begin
  custCB.Items.Clear;
  custCB.Items.Add(''); // 전체 조회를 위해 첫 줄은 빈칸으로

  ls_sql := ' SELECT CUST_CODE, CUST_NAME FROM MICUST (NOLOCK) ';
  ls_sql := ls_sql + ' ORDER BY CUST_CODE ';

  with UpdtQuery do begin
    Close;
    SQL.Clear;
    SQL.Add(ls_sql);
    Open;

    while Not Eof do begin
      ls_name := FieldByName('CUST_NAME').AsString;
      custCB.Items.Add(ls_name);

      Next;
    end;
    Close;
  end;
  
  custCB.ItemIndex := 0; // 첫번째 아이템(빈칸) 선택
end;

procedure TFrm_4400.ItemCBKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then StartBitBtnClick(Self);
end;

end.

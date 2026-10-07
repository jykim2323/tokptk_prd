unit Frm3434;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Mask, Buttons, ExtCtrls, DB, ADODB,
  DBTables, QRCtrls, QuickRpt;

type
  TFrm_3434 = class(TForm)
    GroupBox1: TGroupBox;
    Panel12: TPanel;
    PLtNoEd: TMaskEdit;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    Shape2: TShape;
    Label1: TLabel;
    Panel4: TPanel;
    Panel1: TPanel;
    StartSpdBtn: TBitBtn;
    lstkDeleteBitBtn: TBitBtn;
    iohtQuery: TADOQuery;
    UpdtQuery: TADOQuery;
    OuptQuery: TADOQuery;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRBand4: TQRBand;
    QRLbl_DateTime: TQRLabel;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRLbl_Code: TQRLabel;
    QRBand5: TQRBand;
    QRLabel6: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel4: TQRLabel;
    QRDBText10: TQRDBText;
    DeleteBitBtn: TBitBtn;
    PrintBitBtn: TBitBtn;
    ExitBitBtn: TBitBtn;
    iohtQueryIOHT_INDEX: TStringField;
    iohtQueryIOHT_PLTNO: TStringField;
    iohtQueryIOHT_GUBUN: TStringField;
    iohtQueryIOHT_FROM: TStringField;
    iohtQueryIOHT_TO: TStringField;
    iohtQueryIOHT_PICKING: TStringField;
    iohtQueryIOHT_EPLT: TStringField;
    iohtQueryIOHT_ROLLSHEET: TStringField;
    iohtQueryIOHT_DATE: TStringField;
    iohtQueryIOHT_TIME: TStringField;
    iohtQueryIOHT_FLAG: TStringField;
    iohtQueryIOHT_FACT: TStringField;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel3: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRDBText11: TQRDBText;
    OuptQueryOUPT_DATE: TStringField;
    OuptQueryOUPT_INDEX: TStringField;
    OuptQueryOUPT_PLTNO: TStringField;
    OuptQueryOUPT_CASENO: TStringField;
    OuptQueryOUPT_EPLT: TStringField;
    OuptQueryOUPT_GUBUN: TStringField;
    OuptQueryOUPT_FACT: TStringField;
    OuptQueryOUPT_RLOCA: TStringField;
    OuptQueryOUPT_LOCA: TStringField;
    OuptQueryOUPT_STATION: TStringField;
    OuptQueryOUPT_TIME: TStringField;
    OuptQueryOUPT_RFLAG: TStringField;
    OuptQueryOUPT_JOB_FLAG: TStringField;
    OuptQueryOUPT_INDATE: TStringField;
    OuptQueryOUPT_INTIME: TStringField;
    OuptQueryOUPT_USERID: TStringField;
    OuptQueryPRODID: TStringField;
    OuptQueryPROD_LENGTH: TBCDField;
    OuptQueryPROD_WIDTH: TBCDField;
    OuptQueryPROD_WEIGHT: TBCDField;
    OuptQueryCASE_WEIGHT: TBCDField;
    OuptQueryUDF_ROLLSHEET: TStringField;
    DataSource2: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure StartSpdBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure Mioupt_Select_Proc;
    procedure PLtNoEdEnter(Sender: TObject);    
    procedure lstkDeleteBitBtnClick(Sender: TObject);
    procedure DataSource2DataChange(Sender: TObject; Field: TField);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure LstkMoveBitBtnClick(Sender: TObject);
    procedure MoveLocaMedChange(Sender: TObject);   
    procedure CloseBitBtnClick(Sender: TObject);
    procedure PLtNoEdKeyPress(Sender: TObject; var Key: Char);    
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_3434: TFrm_3434;

  StrCode : String;
  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;

  s_lotno, s_pltno, s_index : String;
  s_indate2, s_index2, s_pltno2, s_caseno2  : String;
  lk_qty, lk_amt, sk_qty, sk_amt : Real;

implementation

uses DbSet, WinLib, FrmPrompt, FrmError;

{$R *.dfm}



procedure TFrm_3434.FormCreate(Sender: TObject);
begin
  PLtNoEd.Text := ' ';
  StartSpdBtnClick(self)
end;


procedure TFrm_3434.StartSpdBtnClick(Sender: TObject);
begin
  with IohtQuery do Begin
    DisableControls;
    Close;
    SQL.Clear;
    SQL.Add(' Select * From STK_MIIOHT');
    SQL.Add(' Where IOHT_PLTNO >= '''+PLtNoEd.Text+''' And IOHT_GUBUN = ''O'' And IOHT_FLAG = ''0'' ');
    SQL.Add(' Order By IOHT_INDEX ');
    Open;
    EnableControls;
    First;
  end;  
end;

procedure TFrm_3434.DataSource1DataChange(Sender: TObject; Field: TField);
begin
    s_pltno       := IohtQuery.FieldByName('ioht_pltno').AsString;
    s_index       := IohtQuery.FieldByName('ioht_index').AsString;
end;

procedure TFrm_3434.DBGrid1DblClick(Sender: TObject);
begin
  Mioupt_Select_Proc;
end;

procedure TFrm_3434.Mioupt_Select_Proc;
begin
    with OuptQuery do Begin
     Close;
     SQL.Clear;
     SQL.Add(' Select OUPT_DATE, OUPT_INDEX, OUPT_PLTNO, OUPT_CASENO,  ');
     SQL.Add('        OUPT_EPLT, OUPT_GUBUN, OUPT_FACT,  OUPT_RLOCA,  ');
     SQL.Add('        OUPT_LOCA, OUPT_STATION, OUPT_TIME, OUPT_RFLAG,  ');
     SQL.Add('        OUPT_JOB_FLAG, OUPT_INDATE, OUPT_INTIME, OUPT_USERID,  ');
     SQL.Add('        PRODID, PROD_WIDTH, PROD_LENGTH, PROD_WEIGHT, CASE_WEIGHT, UDT_ROLLSHEET ');
     SQL.Add('  From STK_MIOUPT, STK_UDT_WHS                                  ');
     SQL.Add('  Where OUPT_CASENO = CASENO(+) And OUPT_PLTNO = '''+s_pltno+''' And OUPT_INDEX = '''+s_index+'''    ');
     SQL.Add('  Order By OUPT_DATE,   OUPT_INDEX        ');
     Open;
     First;
     While Not Eof Do Begin
      Next;
    End;
   End;
end;


procedure TFrm_3434.PLtNoEdEnter(Sender: TObject);
begin
    StartSpdBtnClick(Self);
end;


procedure TFrm_3434.lstkDeleteBitBtnClick(Sender: TObject);
var
  var_Msg, var_Sql : String;
begin
  var_sql := 'Select * From STK_TBTRAK Where TRAK_PLTNO = '''+s_pltno+'''  ';
  With UpdtQuery Do
  Begin
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      Open;
      if RecordCount > 0   then
      begin
        WinLib_ErrorForm('작업중인 파레트 입니다. 확인 후 진행 하세요.');
        Exit;
      end;
  End;

  var_sql := 'Select * From STK_TBSCRC Where SCRC_PLTNO = '''+s_pltno+'''  ';
  With UpdtQuery Do
  Begin
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      Open;
      if RecordCount > 0   then
      begin
        WinLib_ErrorForm('스택커 작업중인 파레트 입니다. 삭제는 불가능합니다.');
        Exit;
      end;
  End;          

  var_Msg := ' 정말로 삭제 확정 합니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := 'Select * From STK_MIIOHT Where IOHT_PLTNO = '''+s_pltno+'''  ';
    With UpdtQuery Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      Open;
      if RecordCount <> 0   then
      Begin
         var_sql := ' Delete From STK_MIIOHT Where IOHT_PLTNO = '''+s_pltno+'''   ';
         var_sql := var_sql + '   And IOHT_INDEX  = '''+s_index+'''  ';
       Try
        Close;
        SQL.Clear;
        SQL.Add( var_sql );
        ExecSql;
       Except
        WinLib_ErrorForm('입출고순번 ' + s_index+ ' 삭제 에러!!!! ');
        Exit;
       End;
        OuptQuery.ReQuery;
      End;
    End;

    var_sql := 'Delete From STK_MIOUPT Where OUPT_PLTNO  = '''+s_pltno+'''   ';
    var_sql := var_sql + '               And OUPT_INDEX  = '''+s_index+'''   ';
    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('PLT NO(OUPT) ' + s_pltno + ' 삭제 에러!!!! ');
      Exit;
    End;


    iohtQuery.ReQuery;
//    StartSpdBtnClick(Self);
  End;
end;

procedure TFrm_3434.DataSource2DataChange(Sender: TObject; Field: TField);
begin
   s_indate2  := OuptQuery.FieldByName('OUPT_DATE').AsString;
   s_index2   := OuptQuery.FieldByName('OUPT_INDEX').AsString;
   s_pltno2   := OuptQuery.FieldByName('OUPT_PLTNO').AsString;
   s_caseno2  := OuptQuery.FieldByName('OUPT_CASENO').AsString;
end;

procedure TFrm_3434.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_3434.FormDestroy(Sender: TObject);
begin
  Frm_3400 := Nil;
end;
       

procedure TFrm_3434.DeleteBitBtnClick(Sender: TObject);
var
  var_Msg : String;
begin
{
  var_Msg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    var_sql := ' Delete From MISUBK Where SUBK_LOCA   = '''+s_loca+'''   and ';
    var_sql := var_sql + '                SUBK_CODE   = '''+s_code+'''   and ';
    var_sql := var_sql + '                SUBK_lotno  = '''+s_lotno+'''  ';
    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      ExecSql;
    Except
      WinLib_ErrorForm('재고위치 ' + s_loca + ' 삭제 에러!!!! ');
      Exit;
    End;

    var_sql := ' Select * From MISUBK Where SUBK_LOCA   = '''+s_loca+''' ';
    With UpdtQuery Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add( var_sql );
      Open;
      if RecordCount = 0   then
      Begin
         var_sql := 'Update MILSTK Set ';
         var_sql := var_sql + ' LSTK_FLAG = ''0'',                ';
         var_sql := var_sql + ' LSTK_INDATE  = Null,             LSTK_INTIME  = Null ';
         var_sql := var_sql + ' Where LSTK_LOCA = '''+LocaMEd.Text+''' ';
       Try
        Close;
        SQL.Clear;
        SQL.Add( var_sql );
        ExecSql;
       Except
        WinLib_ErrorForm('재고위치 ' + s_loca+ ' 삭제 에러!!!! ');
        Exit;
       End;
        IohtQuery.ReQuery;
      End;  
    End;    
    SubkQuery.ReQuery;
  End;
}    
end;

procedure TFrm_3434.PrintBitBtnClick(Sender: TObject);
begin
  if MessageDlg(' 정말로 인쇄 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      QRLbl_DateTime.Caption := DateTimeToStr( Now );
      QuickRep1.Preview;
//    QuickRep1.Print;
  end;
end;

procedure TFrm_3434.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;


procedure TFrm_3434.LstkMoveBitBtnClick(Sender: TObject);
begin
//  MovePnl.Visible := True;
end;

procedure TFrm_3434.MoveLocaMedChange(Sender: TObject);
var
  StrLoca, StrQry,  StrMsg, StrFlag : String;
begin
{
  StrLoca := Trim(MoveLocaMed.Text);
  if Length(StrLoca) <> 7 Then Exit;
  StrQry := ' Select LSTK_FLAG Where LSTK_LOCA = '''+StrLoca+''' ';

  With UpdtQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    If RecordCount = 0 Then Begin
      StrMsg := '재고위치 선택 에러...... ';
      WinLib_ErrorForm(StrMsg);
      StrLoca := '';  MoveLocaMed.Text := '';
      Exit;
    End;

    StrFlag := FieldByName('LSTK_FLAG').AsString;

    if StrFlag <> '0' Then Begin
      StrMsg := '해당 위치에 제품이 존재 합니다... ' + #13#10 + '비어 있는 곳으로 선택하여 주십시요...';
      WinLib_ErrorForm(StrMsg);
      StrLoca := '';  MoveLocaMed.Text := '';
      Exit;
    End;
  End;

  If (Copy(LocaMEd.Text,1,1) <> '2')  Then Begin
    StrMsg := '자재를 이동 할 수 없는 위치를  선택 하였습니다....... ';
    WinLib_ErrorForm(StrMsg);
    StrLoca := '';  MoveLocaMed.Text := '';
    Exit;
  End;

  If (Copy(LocaMEd.Text,2,2) < '01') And (Copy(MoveLocaMed.Text,2,2) > '08') Then Begin
    StrMsg := '자재를 이동 할 수 없는 위치를  선택 하였습니다....... ';
    WinLib_ErrorForm(StrMsg);
    StrLoca := '';  MoveLocaMed.Text := '';
    Exit;
  End;
}  
end;



procedure TFrm_3434.CloseBitBtnClick(Sender: TObject);
begin
//  MoveLocaMed.Text := '';
//  MovePnl.Visible := False;
end;

procedure TFrm_3434.PLtNoEdKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then StartSpdBtnClick(Self);
end;
      

end.

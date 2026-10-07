unit Frm1200;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, comobj, StdCtrls, Grids, DB, ADODB, ExtCtrls, QRCtrls,
  QuickRpt, DBGrids;

type
  TFrm_1200 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    DataSource1: TDataSource;
    Query1: TADOQuery;
    Query2: TADOQuery;
    Query1MAST_CODE: TStringField;
    Query1MAST_NAME: TStringField;
    Query1MAST_UNIT: TStringField;
    Query1MAST_WEIGHT: TBCDField;
    Query1MAST_DATE: TDateTimeField;
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText9: TQRDBText;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel12: TQRLabel;
    PageHeaderBand1: TQRBand;
    QRLbl_DateTime: TQRLabel;
    Query1MAST_CASENO: TStringField;
    Query1MAST_BUNJA: TStringField;
    Query1MAST_BMIN: TBCDField;
    Query1MAST_BMAX: TBCDField;
    Query1MAST_NOCHUL: TStringField;
    Query1MAST_DOGSUNG: TStringField;
    Query1MAST_INHWA: TBCDField;
    Query1MAST_BALHWA: TBCDField;
    Query1MAST_JGI: TStringField;
    Query1MAST_BUSIK: TStringField;
    Query1MAST_STATUS: TStringField;
    Query1MAST_ISANG: TStringField;
    Query1MAST_BIGO: TStringField;
    Query1MAST_ORIGIAL: TStringField;
    ExlBtn: TSpeedButton;
    UpdateBitBtn: TSpeedButton;
    DeleteBitBtn: TSpeedButton;
    CancelSB: TSpeedButton;
    StringGrid1: TStringGrid;
    OpenDialog1: TOpenDialog;
    Panel3: TPanel;
    LineEd: TEdit;
    Edit1: TEdit;
    UpdtQuery: TADOQuery;
    procedure ExitBitBtnClick(Sender: TObject);    
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction); 
   
    procedure UpdateBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);  
    procedure ExlBtnClick(Sender: TObject); 
    procedure CancelSBClick(Sender: TObject);


  private
     procedure Grid_Title;
    { Private declarations }
  
  public
    { Public declarations }
  end;

var
  Frm_1200: TFrm_1200;

  StrCode : String;
  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;

  s_wcode, s_code,s_name,s_remark, s_unit, s_weight :String;
  wr_cnt, li_RecNo : Integer;

implementation

uses DBSet, WinLib, FrmPrompt, FrmError;


{$R *.dfm}


procedure TFrm_1200.FormCreate(Sender: TObject);
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;
  Grid_Title;
end;

procedure TFrm_1200.Grid_Title;
begin
  With StringGrid1 Do Begin
     Cells[1,0] := '순번';
     Cells[2,0] := '품번코드';
     Cells[3,0] := '품 번 명';
     Cells[4,0] := '단 위';
     Cells[5,0] := '단위 중량';
  End;
End;

procedure TFrm_1200.ExlBtnClick(Sender: TObject);
var
 v : Variant ;
 iRow, iCol, eRow : integer ;
 CNT : integer;
 lf_time, lf_Min  : Real;
 ls_time, ls_min, ls_hhmm : String;

 ss_time, ls_seq : String;

 li_line, li_Seqno : Integer;

begin
  If StringGrid1.Cells[1, 1] <> '' Then Exit;

  if Length(Trim(LineEd.Text)) = 0   then  exit;

  li_line   := StrToInt(Trim(LineEd.Text));

  try
      v:= CreateOleObject('Excel.application');
  except
     ShowMessage('Excel Not Install');
     Exit;
 end;

 IF OpenDialog1.Execute then
 begin
 v.WorkBooks.open(OpenDialog1.FileName);
 end
 else Exit;

 cnt := strToint(v.ActiveSheet.UsedRange.Rows.Count);

// StringGrid1.ColCount := 12;
 StringGrid1.RowCount := cnt;

 For iRow := 2 to cnt do
 begin
     eRow := iRow + li_line;

     ls_seq :=  Trim(v.cells[eRow, li_Seqno]);

//     StringGrid1.Cells[1 , iRow -1] := Trim(v.cells[eRow, li_Seqno]);
     StringGrid1.Cells[1 , iRow -1] := Trim(ls_seq);
     StringGrid1.Cells[2 , iRow -1] := Trim(v.cells[eRow, 1]);
     StringGrid1.Cells[3 , iRow -1] := Trim(v.cells[eRow, 2]);
     StringGrid1.Cells[4 , iRow -1] := Trim(v.cells[eRow, 3]);
     StringGrid1.Cells[5 , iRow -1] := Trim(v.cells[eRow, 4]);

      ss_time := StringGrid1.Cells[9 , iRow -1];
{
      if  (ss_time <> '')  And (eRow >= li_line + 2)  then
      begin
       lf_time := StrToFloat(Trim(ss_time));
       lf_time := lf_time * 24;
       ls_time := FloatToSTr(Trunc(lf_time));
       lf_min :=  Round((lf_time - StrToFloat(ls_time)) * 60);
       ls_min  := FloatToStr(lf_min);
       ls_min  := copy(ls_min,1,2);
       ls_hhmm := Format('%2.2d', [StrToInt(ls_time)]) + ':' +  Format('%2.2d', [StrToInt(ls_min)]) + ':' + '00';
       StringGrid1.Cells[9 , iRow -1] := ls_hhmm ;
     end;
}
 end;

 Edit1.Text:= ('Total = ' + IntTostr(Cnt - 1) + ' Conversion Complete.');

 V.WorkBooks.Close;
 V.quit ;
 V:=unassigned;
// ShowMessage('Load Complited To Excel.');

end;

procedure TFrm_1200.UpdateBitBtnClick(Sender: TObject);
var
 MRow, i_seq, i, int_cnt, Plt_Qty, j, k : integer ;
 s_seq, s_model, s_Bodyno, s_wcode, s_Nation, s_Desc, s_Grade, ls_onum : String;
 s_Seat, s_Indate, s_Intime, s_Line, s_yy, s_mm, s_dd, var_sql : String;
 s_name : String[40];
 ls_pcode    : Array[1..3] of String;
begin

 if MessageDlg('DB Insert To Excel ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then  Exit;
 int_cnt := 0;

 For MRow := 1 to StringGrid1.RowCount - 1 do
 begin
     If StringGrid1.Cells[1, MRow] = '' Then Break;

     s_seq    := Copy(Trim(StringGrid1.cells[1, MRow]),1,4);
     i_seq    := StrToInt(s_seq);
     s_seq    := Format('%4.4d', [i_seq]);
     s_code   := Copy(Trim(StringGrid1.cells[2, MRow]),1,18);
     s_name   := Copy(Trim(StringGrid1.cells[3, MRow]),1,100);
     s_unit   := Copy(Trim(StringGrid1.cells[4, MRow]),1,4);
     s_weight := Copy(Trim(StringGrid1.cells[5, MRow]),1,10);

     if Length(Trim(s_weight)) = 0  then  s_weight := '0';

     While Pos(',', s_weight) > 0  Do Begin Delete(s_weight, Pos(',', s_weight), 1); End;


      Var_sql := ' Select * from MIMAST (NOLOCK) Where MAST_CODE = '''+s_code+''' ';

      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add(Var_sql);
      Query2.Open;
      if  Query2.RecordCount = 0  then
      begin
        Var_sql := ' Insert Into MIMAST(MAST_CODE, MAST_NAME, MAST_UNIT, ';
        Var_sql := Var_sql + '    MAST_WEIGHT, MAST_DATE )';
        Var_sql := Var_sql + ' Values('''+s_code+''', '''+s_name+''',  '''+s_unit+''', ';
        Var_sql := Var_sql + '         Convert(Numeric,'''+s_weight+'''), getdate() ) ';
      end
      else
      begin
        var_sql := 'Update MIMAST Set ';
        var_sql := var_sql + ' MAST_NAME   = '''+s_name+''',   MAST_UNIT = '''+s_unit+''',    ';
        var_sql := var_sql + ' MAST_WEIGHT = Convert(Numeric,'''+s_weight+'''),    ';
        var_sql := var_sql + ' MAST_DATE   =   getdate()  ';;
        Var_sql := Var_sql + ' Where MAST_CODE = '''+s_code+'''  ';
      end;

      Try
        With UpdtQuery Do Begin
          Close;
          SQL.Clear;
          SQL.Add(Var_sql);
          ExecSql;
        End;
      Except
          Showmessage('Insert Error = ' + Var_sql);           Exit;
      End;    
  End;                  // End of While


 DeleteBitBtnClick(Self);
 ShowMessage('Complete Insert Data = ' + IntToStr(int_cnt));
end;

procedure TFrm_1200.DeleteBitBtnClick(Sender: TObject);
var
   IntCnt : Integer;
begin
   With  StringGrid1 Do Begin
      For  Intcnt := 1  to    StringGrid1.RowCount do  Begin
           Cells[1, Intcnt] := '';
           Cells[2, Intcnt] := '';
           Cells[3, Intcnt] := '';
           Cells[4, Intcnt] := '';
           Cells[5, Intcnt] := '';
      end;
      StringGrid1.RowCount := 2;
   End;
   Edit1.Text:= '';
end;    


procedure TFrm_1200.CancelSBClick(Sender: TObject);
var
    m_Row, i, j : Integer;
    StrMsg : string;
begin
  If StringGrid1.Cells[1, StringGrid1.Row] = '' Then Begin
//    StrMsg := ' 삭제할 데이타가 없습니다....' + #13#10 + '데이타를 선택한 후 다시 하십시요!!!';
    StrMsg := ' The data is exist....' + #13#10 + 'Please try again after selecting data!!!';
    if MessageDlg( StrMsg, mtConfirmation, [mbYes, mbNo], 0) = mrNo then  Exit;
  End;
  StrMsg := ' Do you really want to delete select line?? .';
  if MessageDlg( StrMsg, mtConfirmation, [mbYes, mbNo], 0) = mrNo then  Exit;

  m_Row := StringGrid1.Row;

  for j := m_Row to  StringGrid1.RowCount-2 do
  begin
    for i := 0 to    StringGrid1.ColCount-1  do
    begin
      StringGrid1.Cells[i, j] := StringGrid1.Cells[i, j+1];
    end;
  end;

  for j := 0 to  StringGrid1.ColCount-1  do
  begin
    StringGrid1.Cells[j, StringGrid1.RowCount-1] := '';
  end;

  If StringGrid1.RowCount > 2 Then StringGrid1.RowCount := StringGrid1.RowCount - 1;
  StringGrid1.Col := 0;
end;


procedure TFrm_1200.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_1200.FormDestroy(Sender: TObject);
begin
  Frm_1200 := Nil;
end;

procedure TFrm_1200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.

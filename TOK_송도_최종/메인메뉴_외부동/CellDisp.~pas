unit CellDisp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, StdCtrls, ExtCtrls, Buttons, Db, DBTables, ComCtrls, Spin, Grids,
  ADODB;

type
  TCellDisp_f = class(TForm)
    TiTlePnl: TPanel;
    Panel9: TPanel;
    Panel2: TPanel;
    FlagEdit: TEdit;
    Panel1: TPanel;
    ExitBitBtn: TBitBtn;
    CellQuery: TADOQuery;
    UpdateBitBtn: TBitBtn;
    DeleteBitBtn: TBitBtn;
    UpdtQuery: TADOQuery;
    InsertBitBtn: TBitBtn;
    NrackBitBtn: TBitBtn;
    irackBitBtn: TBitBtn;
    BankEdit: TEdit;
    BayEdit: TEdit;
    LevlEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LabelPrintBitBtn: TSpeedButton;
    CellGrid: TStringGrid;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject); 
    procedure FormDestroy(Sender: TObject);
    procedure CellGrid_Clear_Proc;
    procedure CellGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure UpdateBitBtnClick(Sender: TObject);
    procedure Cntl_LocationSelect_proc;
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure InsertBitBtnClick(Sender: TObject);
    procedure NrackBitBtnClick(Sender: TObject);
    procedure irackBitBtnClick(Sender: TObject);
    procedure LabelPrintBitBtnClick(Sender: TObject);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  CellDisp_f: TCellDisp_f;
  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  var_SelForm : TForm;
  var_Modal : Boolean;
  StrLoca, StrPlt : String;

implementation

uses  Dbset, define, WinLib, FrmPrompt, FrmError, LocaUpdt_u, FrmProgress;

{$R *.DFM}

procedure TCellDisp_f.FormCreate(Sender: TObject);
begin
  With CellGrid Do Begin
     {
     Cells[1,0]  := '예약';
     Cells[2,0]  := '품번코드';
     Cells[3,0]  := '품번명';
     Cells[4,0]  := 'LOT-NO';
     Cells[5,0]  := '재고수량';
     Cells[6,0]  := '예약수량';
     Cells[7,0]  := 'BOX-NO';
     Cells[8,0]  := '비 고';
     Cells[9,0]  := '입고일자';
     Cells[10,0] := '입고시간';

     ColWidths[0]  := 10;
     ColWidths[1]  := 30;
     ColWidths[2]  := 100;
     ColWidths[3]  := 300;
     ColWidths[4]  := 100;
     ColWidths[5]  := 100;
     ColWidths[6]  := 100;
     ColWidths[7]  := 100;
     ColWidths[8]  := 250;
     ColWidths[9]  := 100;
     ColWidths[10]  := 100;
     }

     Cells[1,0]  := '예약';
     Cells[2,0]  := 'PLT-NO'; // PLTNO
     Cells[3,0]  := '품번코드';
     Cells[4,0]  := '품번명';
     Cells[5,0]  := 'LOT-NO';
     Cells[6,0]  := '재고수량';
     Cells[7,0]  := '예약수량';
     Cells[8,0]  := 'BOX-NO';
     Cells[9,0]  := '비 고';
     Cells[10,0] := '입고일자';
     Cells[11,0] := '입고시간';

     ColWidths[0]  := 10;
     ColWidths[1]  := 30;   // 예약
     ColWidths[2]  := 100;   // PLTNO
     ColWidths[3]  := 100;  // 품번코드
     ColWidths[4]  := 300;  // 품번명
     ColWidths[5]  := 100;  // LOT-NO
     ColWidths[6]  := 100;  // 재고수량
     ColWidths[7]  := 100;  // 예약수량
     ColWidths[8]  := 100;  // Box-NO
     ColWidths[9]  := 250;  // 비고
     ColWidths[10] := 100; // 입고일자
     ColWidths[11] := 100; // 입고 시간
  End;
end;

procedure TCellDisp_f.FormActivate(Sender: TObject);
var
  IntRow :Integer;
  StrQry,  StrDate, StrTime, StrGubun, StrRemark : String;
begin
  CellGrid_Clear_Proc;


  StrLoca :=  BankEdit.Text + BayEdit.Text + LevlEdit.Text;

  StrQry := ' Select  CASE LSTK_FLAG WHEN ''0'' then ''제품없슴'' ';
  StrQry := StrQry + '               WHEN ''1'' then ''제품있슴'' ';
  StrQry := StrQry + '               WHEN ''X'' then ''입고예약'' ';
  StrQry := StrQry + '               WHEN ''Y'' then ''출고예약'' ';
  StrQry := StrQry + '               WHEN ''W'' then ''이중입고'' ';
  StrQry := StrQry + '               WHEN ''E'' then ''공출고''   ';
  StrQry := StrQry + '               WHEN ''N'' then ''사용금지'' ELSE '''' END  AS LSTK_FLAG, LSTK_INDATE, LSTK_INTIME  ';
  StrQry := StrQry + ' From  T2MILSTK (NOLOCK) ';
  StrQry := StrQry + ' Where LSTK_LOCA = '''+StrLoca+''' ';
   With CellQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    FlagEdit.Text  := FieldByName('LSTK_FLAG').AsString;

  End;


  StrQry := ' Select  CASE LSTK_FLAG WHEN ''0'' then ''제품없슴'' ';
  StrQry := StrQry + '               WHEN ''1'' then ''제품있슴'' ';
  StrQry := StrQry + '               WHEN ''X'' then ''입고예약'' ';
  StrQry := StrQry + '               WHEN ''Y'' then ''출고예약'' ';
  StrQry := StrQry + '               WHEN ''W'' then ''이중입고'' ';
  StrQry := StrQry + '               WHEN ''E'' then ''공출고''   ';
  StrQry := StrQry + '               WHEN ''N'' then ''사용금지'' ELSE '''' END  AS LSTK_FLAG, ';
  StrQry := StrQry + ' SUBK_LOCA, SUBK_CODE,   SUBK_LOTNO,  ';
  StrQry := StrQry + ' SUBK_GUBUN, SUBK_WGT,  SUBK_RWGT,    ';
  StrQry := StrQry + ' SUBK_FLAG, SUBK_REMARK, SUBK_BOXNO, SUBK_INDATE, SUBK_INTIME, ';
  StrQry := StrQry + ' MAST_NAME ';
  StrQry := StrQry + ' , SUBK_PLTNO ';// 김준영 추가
  StrQry := StrQry + ' FROM T2MISUBK (NOLOCK) ';
  StrQry := StrQry + ' LEFT OUTER JOIN T2MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA ';
  StrQry := StrQry + ' LEFT OUTER JOIN MIMAST (NOLOCK) ON MAST_CODE = SUBK_CODE ';
  StrQry := StrQry + ' Where SUBK_LOCA = LSTK_LOCA    ';
  StrQry := StrQry + '   And SUBK_LOCA = '''+StrLoca+''' ';
  StrQry := StrQry + ' Order By SUBK_LOCA, SUBK_CODE ';

  With CellQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(StrQry);
    Open;

    if RecordCount = 0 then Exit;

    FlagEdit.Text  := FieldByName('LSTK_FLAG').AsString;

    CellGrid.RowCount := RecordCount + 1;

    IntRow := 1;
    While Not Eof Do Begin

      StrDate   := FieldByName('SUBK_INDATE').AsString;
      StrTime   := FieldByName('SUBK_INTIME').AsString;



      StrDate   := Copy(StrDate,1,4) + '-' +  Copy(StrDate,5,2)  + '-' +  Copy(StrDate,7,2);
      StrTime   := Copy(StrTime,1,2) + ':' +  Copy(StrTime,3,2) + ':' +  Copy(StrTime,5,2);
      {
      CellGrid.Cells[1, IntRow]  := FieldByName('SUBK_FLAG').AsString;
      CellGrid.Cells[2, IntRow]  := FieldByName('SUBK_CODE').AsString;
      CellGrid.Cells[3, IntRow]  := FieldByName('MAST_NAME').AsString;
      CellGrid.Cells[4, IntRow]  := FieldByName('SUBK_LOTNO').AsString;
      CellGrid.Cells[5, IntRow]  := FormatFloat('#,###,##0.00', FieldByName('SUBK_WGT').AsFloat);
      CellGrid.Cells[6, IntRow]  := FormatFloat('#,###,##0.00', FieldByName('SUBK_RWGT').AsFloat);
      CellGrid.Cells[7, IntRow]  := FieldByName('SUBK_BOXNO').AsString;
      CellGrid.Cells[8, IntRow]  := FieldByName('SUBK_REMARK').AsString;
      CellGrid.Cells[9, IntRow]  := StrDate;
      CellGrid.Cells[10, IntRow]  := StrTime;
      }

      CellGrid.Cells[1, IntRow]  := FieldByName('SUBK_FLAG').AsString;
      CellGrid.Cells[2, IntRow]  := FieldByName('SUBK_PLTNO').AsString;
      CellGrid.Cells[3, IntRow]  := FieldByName('SUBK_CODE').AsString;
      CellGrid.Cells[4, IntRow]  := FieldByName('MAST_NAME').AsString;
      CellGrid.Cells[5, IntRow]  := FieldByName('SUBK_LOTNO').AsString;
      CellGrid.Cells[6, IntRow]  := FormatFloat('#,###,##0.00', FieldByName('SUBK_WGT').AsFloat);
      CellGrid.Cells[7, IntRow]  := FormatFloat('#,###,##0.00', FieldByName('SUBK_RWGT').AsFloat);
      CellGrid.Cells[8, IntRow]  := FieldByName('SUBK_BOXNO').AsString;
      CellGrid.Cells[9, IntRow]  := FieldByName('SUBK_REMARK').AsString;
      CellGrid.Cells[10, IntRow]  := StrDate;
      CellGrid.Cells[11, IntRow]  := StrTime;

      inc(IntRow);
      Next;
    End;
  End;
 
end;

procedure TCellDisp_f.CellGrid_Clear_Proc;
var
  IntCnt : Integer;
begin
  FlagEdit.Text := '';  

  With CellGrid Do Begin
    For IntCnt := 1 to RowCount - 1 do Begin
     Cells[1,IntCnt] := '';
     Cells[2,IntCnt] := '';
     Cells[3,IntCnt] := '';
     Cells[4,IntCnt] := '';
     Cells[5,IntCnt] := '';
     Cells[6,IntCnt] := '';
     Cells[7,IntCnt] := '';
     Cells[8,IntCnt] := '';
     Cells[9,IntCnt] := '';
     Cells[10,IntCnt] := '';
     Cells[11,IntCnt] := '';     
    End;
  End;
  CellGrid.RowCount := 2;
end;

procedure TCellDisp_f.CellGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  LeftPos: Integer;
  CellStr: string;
begin
  with TStringGrid(Sender).Canvas do
  begin
    CellStr := TStringGrid(Sender).Cells[ACol, ARow];

    IF ARow = 0 Then Begin
      if ACol > 0 Then Begin
        LeftPos := ((Rect.Right-Rect.Left-TStringGrid(Sender).Canvas.TextWidth(CellStr)) div 2) + Rect.Left;  // 가운데 정렬
        With TStringGrid(Sender).Canvas.Font Do Begin
          Brush.Color := clSkyBlue;
          Font.Color  := clBlue;
          Style := [fsBold];
       End;
        FillRect(Rect);
        TextOut(LeftPos, Rect.Top+5, CellStr);
      End;
    End;

    IF ARow > 0 Then Begin
      if (ACol = 5) Or (ACol = 6) Then Begin
        LeftPos := (Rect.Right-Rect.Left-TStringGrid(Sender).Canvas.TextWidth(CellStr)) + Rect.Left;  // 오른쪽 정렬
        FillRect(Rect);
        TextOut(LeftPos-3, Rect.Top+3, CellStr);
      End;
    End;

  End;
end;


procedure TCellDisp_f.FormDestroy(Sender: TObject);
begin
    CellDisp_f := Nil;
end;

procedure TCellDisp_f.ExitBitBtnClick(Sender: TObject);
begin
   Close;
end;

procedure TCellDisp_f.InsertBitBtnClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  LocaUpdt  := TLocaUpdt.Create(Application);
  Bol_Modal := True;

  LocaUpdt.Bol_Insert := True;
  LocaUpdt.Bol_Update := False;

//  Cntl_LocationSelect_proc;

  LocaUpdt.LocaMed.Text    := StrLoca;
  LocaUpdt.LocaMed.Enabled := False;

  LocaUpdt.QtyEdit.Text    := '0';
  LocaUpdt.RQtyEdit.Text   := '0';

  LocaUpdt.TitleLbl.Caption := '재고 등록';

  If LocaUpdt <> Nil Then
    With TForm(LocaUpdt) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      LocaUpdt.Free;
    End;
    FormActivate(Self);
end;


procedure TCellDisp_f.UpdateBitBtnClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  LocaUpdt  := TLocaUpdt.Create(Application);
  Bol_Modal := True;

  LocaUpdt.Bol_Insert := False;
  LocaUpdt.Bol_Update := True;
  LocaUpdt.TitleLbl.Caption := '재고 수정';

  LocaUpdt.LocaMEd.Text := StrLoca;

  LocaUpdt.LocaMed.Enabled   := False;
  LocaUpdt.CodeEdit.Enabled  := False;
  LocaUpdt.NameEdit.Enabled  := False;
  LocaUpdt.LotnoEdit.Enabled := False;   

  Cntl_LocationSelect_proc;

  If LocaUpdt <> Nil Then
    With TForm(LocaUpdt) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      LocaUpdt.Free;
    End;
    FormActivate(Self);
end;

procedure TCellDisp_f.Cntl_LocationSelect_proc;
var
  ls_date, ls_pdate, ls_fdate, StrTime, ls_gubun, ls_pltno, s_isfill, ls_time : string;
  sys_datetime  : string;
begin
  sys_datetime := FormatDateTime('YYYYMMDDHHNNSS', Now);

  StrTime := copy(sys_datetime, 9, 6);
  //기존
  {
  LocaUpdt.FlagCB.Text     := Trim(CellGrid.Cells[1,CellGrid.Row]);
  LocaUpdt.CodeEdit.Text   := Trim(CellGrid.Cells[2,CellGrid.Row]);
  LocaUpdt.NameEdit.Text   := Trim(CellGrid.Cells[3,CellGrid.Row]);
  LocaUpdt.LotnoEdit.Text  := Trim(CellGrid.Cells[4,CellGrid.Row]);
  LocaUpdt.QtyEdit.Text    := Trim(CellGrid.Cells[5,CellGrid.Row]);
  LocaUpdt.RQtyEdit.Text   := Trim(CellGrid.Cells[6,CellGrid.Row]);
  LocaUpdt.BoxnoEdit.Text  := Trim(CellGrid.Cells[7,CellGrid.Row]);
  LocaUpdt.BigoEdit.Text   := Trim(CellGrid.Cells[8,CellGrid.Row]);
  }

  LocaUpdt.FlagCB.Text     := Trim(CellGrid.Cells[1,CellGrid.Row]);
  LocaUpdt.PltnoEdit.Text  := Trim(CellGrid.Cells[2,CellGrid.Row]); // PLTNO 추가 김준영 
  LocaUpdt.CodeEdit.Text   := Trim(CellGrid.Cells[3,CellGrid.Row]);
  LocaUpdt.NameEdit.Text   := Trim(CellGrid.Cells[4,CellGrid.Row]);
  LocaUpdt.LotnoEdit.Text  := Trim(CellGrid.Cells[5,CellGrid.Row]);
  LocaUpdt.QtyEdit.Text    := Trim(CellGrid.Cells[6,CellGrid.Row]);
  LocaUpdt.RQtyEdit.Text   := Trim(CellGrid.Cells[7,CellGrid.Row]);
  LocaUpdt.BoxnoEdit.Text  := Trim(CellGrid.Cells[8,CellGrid.Row]);
  LocaUpdt.BigoEdit.Text   := Trim(CellGrid.Cells[9,CellGrid.Row]);

//  LocaUpdt.InDateDTP.Date := Trim(CellGrid.Cells[11,CellGrid.Row]);
//  LocaUpdt.InTimeEd.Text  := Trim(CellGrid.Cells[12,CellGrid.Row]);


  if Trim(CellGrid.Cells[10,CellGrid.Row]) <> '' Then
  begin
    ls_date := Trim(CellGrid.Cells[10,CellGrid.Row]);
    ls_date := Copy(ls_date, 1, 10);
    LocaUpdt.InDateDTP.Date := StrToDate(ls_date);
  end
  else LocaUpdt.InDateDTP.Date := Now;


  if Trim(CellGrid.Cells[11,CellGrid.Row]) <> '' Then
  begin
    ls_time := Trim(CellGrid.Cells[11,CellGrid.Row]);
    ls_time := Copy(ls_time, 1, 2)+ Copy(ls_time, 4, 2)+Copy(ls_time, 7, 2);
    LocaUpdt.InTimeEd.Text := ls_time;
  end
  else LocaUpdt.InTimeEd.Text := StrTime;


end;

procedure TCellDisp_f.DeleteBitBtnClick(Sender: TObject);
var
  StrQry, var_Msg, s_loca, s_code, s_lotno : String;
begin

  var_Msg := ' 정말로 삭제 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    s_loca   := BankEdit.Text + BayEdit.Text + LevlEdit.Text;
    s_code   := Trim(CellGrid.Cells[3,CellGrid.Row]);
    s_lotno  := Trim(CellGrid.Cells[5,CellGrid.Row]);

    StrQry := ' Delete From T2MISUBK Where SUBK_LOCA = '''+s_loca+'''      ';
    StrQry := StrQry + '                  And SUBK_CODE = '''+s_code+'''      ';
    StrQry := StrQry + '                  And SUBK_LOTNO = '''+s_lotno+'''      ';
    With UpdtQuery Do
    Try
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      ExecSql;
    Except
      WinLib_ErrorForm('재고위치 ' + s_loca + ' 삭제 에러!!!! ');
      Exit;
    End;

    StrQry := ' Select * From T2MISUBK Where SUBK_LOCA   = '''+s_loca+''' ';
    With UpdtQuery Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      Open;
      if RecordCount = 0   then
      Begin
         StrQry := 'Update T2MILSTK Set ';
         StrQry := StrQry + ' LSTK_FLAG = ''0'',    ';
         StrQry := StrQry + ' LSTK_INDATE  = '''',  LSTK_INTIME  = ''''   ';
         StrQry := StrQry + ' , LSTK_PLTNO = '''' ';         // 김준영 추가 
         StrQry := StrQry + ' Where LSTK_LOCA = '''+s_loca+''' ';
       Try
        Close;
        SQL.Clear;
        SQL.Add( StrQry );
        ExecSql;
       Except
        WinLib_ErrorForm('재고위치 ' + s_loca+ ' 삭제 에러!!!! ');
        Exit;
       End;
      End;
    End;
    FormActivate(Self);
  End;
end;

procedure TCellDisp_f.NrackBitBtnClick(Sender: TObject);
var
  StrQry, var_Msg, s_loca, s_code, s_lotno : String;
begin
 var_Msg := ' 정말로 금지Cell 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
     s_loca   :=  BankEdit.Text + BayEdit.Text + LevlEdit.Text;
     StrQry := 'Update T2MILSTK Set ';
     StrQry := StrQry + ' LSTK_FLAG = ''N''         ';
     StrQry := StrQry + ' Where LSTK_LOCA = '''+s_loca+''' ';
     With UpdtQuery Do
     Begin
     Try
        Close;
        SQL.Clear;
        SQL.Add( StrQry );
        ExecSql;
       Except
        WinLib_ErrorForm('재고위치 ' + s_loca+ ' 금지 에러!!!! ');
        Exit;
       End;
      End;

     StrQry := 'Update T2MISUBK Set ';
     StrQry := StrQry + ' SUBK_FLAG = ''N''         ';
     StrQry := StrQry + ' Where SUBK_LOCA = '''+s_loca+''' ';

     With UpdtQuery Do
     Begin
     Try
        Close;
        SQL.Clear;
        SQL.Add( StrQry );
        ExecSql;
       Except
        WinLib_ErrorForm('재고위치 ' + s_loca+ ' 금지 에러!!!! ');
        Exit;
       End;
      End;


     FormActivate(Self);
  End;
End;  

procedure TCellDisp_f.irackBitBtnClick(Sender: TObject);
var
  StrQry, var_Msg, s_loca, s_code, s_lotno : String;
begin
 var_Msg := ' 정말로 Cell 사용 확정 합니까.?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    s_loca   :=  BankEdit.Text + BayEdit.Text + LevlEdit.Text;
    StrQry := ' Select * From T2MISUBK Where SUBK_LOCA   = '''+s_loca+''' ';
    With UpdtQuery Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add( StrQry );
      Open;
      if RecordCount = 0   then
      Begin
         StrQry := 'Update T2MILSTK Set ';
         StrQry := StrQry + ' LSTK_FLAG = ''0'', LSTK_INDATE = '''', ';
         StrQry := StrQry + ' LSTK_INTIME = ''''  ';
         StrQry := StrQry + ' , LSTK_PLTNO = '''' ';    // 김준영 추가
         StrQry := StrQry + ' Where LSTK_LOCA = '''+s_loca+''' ';
      End
      else
      Begin
        StrQry := 'Update T2MILSTK Set ';
        StrQry := StrQry + ' LSTK_FLAG = ''1''               ';
        StrQry := StrQry + ' Where LSTK_LOCA = '''+s_loca+''' ';
      End;  

       Try
        Close;
        SQL.Clear;
        SQL.Add( StrQry );
        ExecSql;
       Except
        WinLib_ErrorForm('재고위치 ' + s_loca+ ' 수정 에러!!!! ');
        Exit;
       End;
     

     StrQry := 'Update T2MISUBK Set ';
     StrQry := StrQry + ' SUBK_FLAG = ''1''         ';
     StrQry := StrQry + ' Where SUBK_LOCA = '''+s_loca+''' ';

     Try
        Close;
        SQL.Clear;
        SQL.Add( StrQry );
        ExecSql;
       Except
        WinLib_ErrorForm('재고위치 ' + s_loca+ ' 수정 에러!!!! ');
        Exit;
       End;
      End;

      FormActivate(Self);
    End;
end;


procedure TCellDisp_f.LabelPrintBitBtnClick(Sender: TObject);
var
  StrQry, var_Msg, s_loca : String;
  ls_date, ls_time, ls_rack, ls_name, ls_code, ls_lotno, ls_boxno, ls_qty, ls_bigo, ls_bcrno, ls_pltno  : String;
begin

  var_Msg := ' 라벨 재발행을 하시겠습니까?';
  if WinLib_ConfirmForm( var_Msg ) then
  begin
    s_loca    :=  BankEdit.Text + BayEdit.Text + LevlEdit.Text;
                                     {
    ls_code   := Trim(CellGrid.Cells[2,CellGrid.Row]);
    ls_name   := Trim(CellGrid.Cells[3,CellGrid.Row]);
    ls_lotno  := Trim(CellGrid.Cells[4,CellGrid.Row]);
    ls_boxno  := Trim(CellGrid.Cells[7,CellGrid.Row]);
    ls_qty    := Trim(CellGrid.Cells[5,CellGrid.Row]);
    ls_bigo   := Trim(CellGrid.Cells[8,CellGrid.Row]);
    ls_date   := Trim(CellGrid.Cells[9,CellGrid.Row]);
    ls_time   := Trim(CellGrid.Cells[10,CellGrid.Row]);
                                      }
    ls_pltno  := Trim(CellGrid.Cells[2,CellGrid.Row]); // PLTNO 추가 김준영  
    ls_code   := Trim(CellGrid.Cells[3,CellGrid.Row]);
    ls_name   := Trim(CellGrid.Cells[4,CellGrid.Row]);
    ls_lotno  := Trim(CellGrid.Cells[5,CellGrid.Row]);
    ls_boxno  := Trim(CellGrid.Cells[8,CellGrid.Row]);
    ls_qty    := Trim(CellGrid.Cells[6,CellGrid.Row]);
    ls_bigo   := Trim(CellGrid.Cells[9,CellGrid.Row]);
    ls_date   := Trim(CellGrid.Cells[10,CellGrid.Row]);
    ls_time   := Trim(CellGrid.Cells[11,CellGrid.Row]);


    While Pos('-', ls_date ) > 0 Do Begin Delete(ls_date, Pos('-', ls_date), 1); End;
    While Pos(':', ls_time ) > 0 Do Begin Delete(ls_time, Pos(':', ls_time), 1); End;

    StrQry := ' Select   INPT_INDEX,  INPT_CODE, INPT_LOTNO, INPT_BOXNO, ';
    StrQry := StrQry + ' INPT_INDATE, INPT_STIME From  T2MIINPT (NOLOCK) ';
    StrQry := StrQry + ' Where INPT_LOCA  = '''+s_loca+'''   And INPT_CODE = '''+ls_code+''' ';
    StrQry := StrQry + '   And INPT_LOTNO = '''+ls_lotno+''' And INPT_BOXNO = '''+ls_boxno+''' ';
    StrQry := StrQry + '   And INPT_INDATE = '''+ls_date+''' And INPT_ETIME = '''+ls_time+''' ';
     With CellQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(StrQry);
      Open;                                                  
      ls_bcrno := Trim(FieldByName('INPT_INDEX').AsString);
//      showmessage(s_loca +'/'+ ls_code +'/'+ ls_lotno +'/'+ ls_boxno +'/'+ ls_date +'/'+ ls_time   );
//      showmessage(ls_bcrno);
    End;


    StrQry := ' INSERT INTO T2TILABL ';
    StrQry := StrQry + ' (LABL_INDEX,   LABL_CODE,   LABL_NAME, ';
    StrQry := StrQry + '  LABL_LOTNO,   LABL_QTY,    LABL_LOCA, ';
    StrQry := StrQry + '  LABL_BOXNO,   LABL_DATE,   LABL_TIME, ';
    StrQry := StrQry + '  LABL_REMARK,  UPDATE_YN )';
    StrQry := StrQry + ' values('''+ls_bcrno+''', '''+ls_code+''',  '''+ls_name+''',  ';
    StrQry := StrQry + '        '''+ls_lotno+''', Convert(Numeric(7,2),'''+ls_qty+'''), '''+s_loca+''',  ';
    StrQry := StrQry + '        '''+ls_boxno+''', '''+ls_date+''',  '''+ls_time+''',  ';
    StrQry := StrQry + '        '''+ls_bigo+''',  ''N'' )';
    With UpdtQuery Do Begin
      Try
        Close;
        SQL.Clear;
        SQL.Add( StrQry );
        ExecSql;
      Except
        WinLib_ErrorForm('라벨 발행 ' + ls_code + ' 등록 에러!!!! '  );
        showmessage(StrQry);
        Exit;
      End;
    End;
    SHOWMESSAGE('라벨 전송 완료!!');
  End;
end;

end.

unit Frm4200;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, ADODB, DB, DBTables,
  Mask;

type
  TFrm_4200 = class(TForm)
    v: TPanel;
    Shape1: TShape;
    Label4: TLabel;
    ExitBitBtn: TSpeedButton;
    ResvGBox: TGroupBox;
    Shape2: TShape;
    Label1: TLabel;
    Panel17: TPanel;
    Panel19: TPanel;
    QtyEdit: TEdit;
    Panel2: TPanel;
    ItemEdit: TEdit;
    Name1Edit: TEdit;
    Panel4: TPanel;
    LocaEdit: TEdit;
    StockSG: TStringGrid;
    PltidEdit: TEdit;
    GroupBox2: TGroupBox;
    Startbitbtn: TSpeedButton;
    Panel9: TPanel;
    CodeCB: TComboBox;
    ExecSb: TSpeedButton;
    ExitSP: TSpeedButton;
    Label2: TLabel;
    LblSumQty: TLabel;
    Panel5: TPanel;
    RqtyEdit: TEdit;
    DIspQuery: TADOQuery;
    StatQuery: TADOQuery;
    UpdtQuery: TADOQuery;
    Panel1: TPanel;
    PgubnEdit: TEdit;
    SB_Search: TSpeedButton;
    NameEdit: TEdit;
    OutSG: TStringGrid;
    Query2: TADOQuery;
    Panel3: TPanel;
    Panel6: TPanel;
    DateEdit: TEdit;
    TimeEdit: TEdit;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel10: TPanel;
    ClearSB: TSpeedButton;
    EmgCheckBox: TCheckBox;
    ConfirmBitBtn: TSpeedButton;
    CancelSB: TSpeedButton;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CodeCBChange(Sender: TObject);
    procedure ExecSbClick(Sender: TObject);    
    procedure StockSGDblClick(Sender: TObject);
    procedure QtyEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StockSGDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ExitSPClick(Sender: TObject);   
    procedure StartbitbtnClick(Sender: TObject);
    procedure SB_SearchClick(Sender: TObject);
    procedure CancelSBClick(Sender: TObject);
    procedure ConfirmBitBtnClick(Sender: TObject);
    procedure ClearSBClick(Sender: TObject);
  private
    { Private declarations }
    function f_get_sysdate_time1(): String;    
    
    procedure Item_Code_Select;
    procedure Grid_Title;
    procedure Stock_Grid_Clear;
    procedure Out_Grid_Clear;
    procedure Output_Resv_Proc;
    procedure OutLetData_Insert_Proc;

    procedure OutInfo_Create(Outpltid, Outloca, Outcode, Outqty, Outrqty, OutPgubn, OutInDate, OutInTime : String);
    procedure ReinPut_Data_Proc(OutPLTID, OutLoca, OutCode : String);
    procedure Insert_TiSche_Proc(OutPltID, OutIndex, OutLoca, OutType : String);

  public
    { Public declarations }
  end;

var
  Frm_4200: TFrm_4200;

  Var_Form : TForm;
  Bol_Modal : Boolean;
  Bol_Data_Ok : Boolean;

  Var_Sql : String;
  StrMsg : String;  
  S_Date, s_sw : String;
  S_Time, sys_datetime, SAVE_PltID : String;
  S_PltID, s_index : String;

  IntPos,  IntRow : integer;      
  IntCnt, i, IntSumQty : Integer;
  NumQty,  NumOutQty   : Real;

  StrCode, StrLotno, StrLoca,  StrInDate, StrInTime, STrPLTid : String;
  StrDate, StrTime, StrQty, StrRQty  : String;

implementation

uses Dbset, WinLib, FrmPrompt, FrmError, MastDisp;

{$R *.dfm}


procedure TFrm_4200.FormCreate(Sender: TObject);
begin
  Top  := (Screen.Height - Self.Height) div 2;
  Left := (Screen.Width - Self.Width) div 2;

  Grid_Title;
  Item_Code_Select;
end;

procedure TFrm_4200.Grid_Title;
begin
  With StockSG Do Begin
     Cells[1,0] := '저장위치';
     Cells[2,0] := '자재번호';
     Cells[3,0] := '자재 내역';
     Cells[4,0] := '평가유형';
     Cells[5,0] := '재고수량 ';
     Cells[6,0] := 'PLT-ID ';
     Cells[7,0] := '입고일자';
     Cells[8,0] := '입고시간';

     ColWidths[0] := 10;
     ColWidths[1] := 100;
     ColWidths[2] := 100;
     ColWidths[3] := 250;
     ColWidths[4] := 80;
     ColWidths[5] := 80;
     ColWidths[6] := 120;
     ColWidths[7] := 120;
     ColWidths[8] := 120;

     With OutSG Do Begin
     Cells[1,0] := '저장위치';
     Cells[2,0] := '자재번호';
     Cells[3,0] := '자재 내역';
     Cells[4,0] := '재고수량 ';
     Cells[5,0] := '출고수량 ';
     Cells[6,0] := '평가유형';
     Cells[7,0] := 'PLT-ID ';
     Cells[8,0] := '입고일자';
     Cells[9,0] := '입고시간';

     ColWidths[0] := 10;
     ColWidths[1] := 100;
     ColWidths[2] := 100;
     ColWidths[3] := 250;
     ColWidths[4] := 80;
     ColWidths[5] := 80;
     ColWidths[6] := 120;
     ColWidths[7] := 120;
     ColWidths[8] := 120;
     ColWidths[9] := 120;
  End;
  End;
End;

procedure TFrm_4200.Stock_Grid_Clear;
begin
  With StockSG Do Begin
    For IntCnt := 1 to RowCount - 1 do Begin
        For i := 1 to 8 do Begin
           Cells[i,IntCnt] := '';
        End;
    End;
  End;
  StockSG.RowCount := 2;
  StockSG.Col := 0;
end;

procedure TFrm_4200.Out_Grid_Clear;
begin
  With OutSG Do Begin
    For IntCnt := 1 to RowCount - 1 do Begin
      For i := 1 to 9 do Begin
           Cells[i,IntCnt] := '';
      End;
    End;
  End;
  OutSG.RowCount := 2;
  OutSG.Col := 0;
end;

procedure TFrm_4200.Item_Code_Select;
begin
  CodeCB.Clear;

  Var_Sql := ' Select SUBK_CODE FROM STK1_MISUBK (NOLOCK) ';
  Var_Sql := Var_Sql + ' Where SUBK_FLAG = ''1'' ';
  Var_Sql := Var_Sql + ' Group By SUBK_CODE ';

  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(Var_Sql);
    Open;
    First;

    While Not Eof Do Begin
      StrCode := FieldByName('SUBK_CODE').AsString;
      CodeCB.Items.Add(StrCode);
      Next;
    End;          // End of While
  End;           // End of With    
end;

procedure TFrm_4200.StartbitbtnClick(Sender: TObject);
begin
   CodeCBChange(Self);
end;

procedure TFrm_4200.CodeCBChange(Sender: TObject);  
begin
  StrCode := CodeCb.Text;
//  While Pos('-', StrCode) > 0 Do Begin  Delete(StrCode, pos('-', StrCode), 1); End;
//  If Length(StrCode) <> 10 Then Exit;

  Var_Sql := ' Select SUBK_PLTID, SUBK_CODE, SUBK_QTY, MAST_NAME, SUBK_PGUBN,';
  Var_Sql := Var_Sql + ' SUBK_LOCA, SUBK_INDATE, SUBK_INTIME, LSTK_FLAG ';
  Var_Sql := Var_Sql + ' FROM STK1_MISUBK (NOLOCK) ';
  Var_Sql := Var_Sql + ' LEFT OUTER JOIN STK_MIMAST (NOLOCK)  ON MAST_CODE = SUBK_CODE ';
  Var_Sql := Var_Sql + ' LEFT OUTER JOIN STK1_MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA ';
  Var_Sql := Var_Sql + ' Where SUBK_CODE <> ''''  ';
  if  (StrCode <> '') then   Var_Sql := Var_Sql + ' And SUBK_CODE = '''+StrCode+'''      ';
  Var_Sql := Var_Sql + ' And SUBK_FLAG = ''1'' And LSTK_FLAG = ''1'' ';
  Var_Sql := Var_Sql + ' Order By SUBK_LOCA, SUBK_CODE ';   

  Stock_Grid_Clear;

  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(Var_Sql);
    Open;

    if RecordCount = 0 Then Begin
      StrMsg := CodeCb.Text + ' 재고가 없습니다...... ';
      WinLib_ErrorForm( StrMsg );
      Exit;
    End;

    First;

    IntPos := 1;  IntRow :=  1;

    if RecordCount = 0 then StockSG.RowCount := 2 else StockSG.RowCount := RecordCount + 1;
    
    IntSumQty := 0;
    While Not Eof Do Begin
      StrLoca := FieldByName('SUBK_LOCA').AsString;
      StrDate := FieldByName('SUBK_INDATE').AsString;
      StrTime := FieldByName('SUBK_INTIME').AsString;

      StrDate := Copy(StrDate,1,4) + '-' + Copy(StrDate,5,2) + '-' + Copy(StrDate,7,2);
      StrTime := Copy(StrTime,1,2) + ':' + Copy(StrTime,3,2) + ':' + Copy(StrTime,5,2);
      StrLoca := Copy(StrLoca,1,1) + '-' + Copy(StrLoca,2,1) + '-' + Copy(StrLoca,3,2) + '-' + Copy(StrLoca,5,2);

      StockSG.Cells[1, IntPos] := StrLoca;
      StockSG.Cells[2, IntPos] := FieldByName('SUBK_CODE').AsString;
      StockSG.Cells[3, IntPos] := FieldByName('MAST_NAME').AsString;
      StockSG.Cells[4, IntPos] := FieldByName('SUBK_PGUBN').AsString;
      StockSG.Cells[5, IntPos] := FormatFloat('#,###,##0', FieldByName('SUBK_QTY').AsFloat);
      StockSG.Cells[6, IntPos] := FieldByName('SUBK_PLTID').AsString;
      StockSG.Cells[7, IntPos] := StrDate;
      StockSG.Cells[8, IntPos] := StrTime;

      IntSumQty := IntSumQty + FieldByName('SUBK_QTY').AsInteger;
      Inc(IntPos);
      Next;
    End;
    LblSumQty.Caption := Formatfloat('#,###,##0',  StrToFloat(IntToStr(IntSumQty)));
  End;           // End of With

end;

procedure TFrm_4200.StockSGDblClick(Sender: TObject);
begin
  If StockSG.Cells[2, StockSG.Row] = '' Then Begin
    StrMsg := '출고 작업할 데이타가 없습니다...'+#13#10+ ' 확인후 다시 시도 하십시요';
    WinLib_ErrorForm( StrMsg );  Exit;
    Exit;
  End;

  ResvGBox.Visible := True;

  LocaEdit.Text      := StockSG.Cells[1, StockSG.Row];
  ItemEdit.Text      := StockSG.Cells[2, StockSG.Row];
  Name1Edit.Text     := StockSG.Cells[3, StockSG.Row];
  PgubnEdit.Text     := StockSG.Cells[4, StockSG.Row];
  QtyEdit.Text       := StockSG.Cells[5, StockSG.Row];
  PltIDEdit.Text     := StockSG.Cells[6, StockSG.Row];
  DateEdit.Text      := StockSG.Cells[7, StockSG.Row];
  TimeEdit.Text      := StockSG.Cells[8, StockSG.Row];

  RQtyEdit.Text := '0';
end;

procedure TFrm_4200.QtyEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  StrRQty, StrQty : String;
  NumQty,  NumStockQty : Real;
begin
  if RQtyEdit.Text = ''     Then  Exit;
  if FloatToStr(Key) = '13' Then  Exit;

  StrQty := QtyEdit.Text;
  While pos(',', StrQty) > 0 Do Begin Delete(StrQty, pos(',', StrQty), 1); End;
  NumQty := StrToFloat(StrQty);

  StrRQty := RQtyEdit.Text;
  While pos(',', StrRQty) > 0 Do Begin Delete(StrRQty, pos(',', StrRQty), 1); End;
  NumStockQty := StrToFloat(StrRQty);

  if NUmStockQty > NumQty   Then Begin
    StrMsg := '출고 수량이 재고수량을 초과 하였습니다..... ';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;   
end;

procedure TFrm_4200.ExecSbClick(Sender: TObject);
var
   Bol_Data_Ok : Boolean;
   Chk_Pos     : Integer;
   Str1IO, Str2IO, Str3IO,  Str4IO : string;
begin         
  Bol_Data_Ok := True;
  if StockSG.Cells[1,1] = '' Then Begin
    StrMsg := '출고작업할 데이타가 없습니다....' + #13#10 + '출고 데이타를 입력 후 다시 시도 하십시요!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

   if (RQtyEdit.Text = '') or (Length(RQtyEdit.Text) = 0) then
  Begin
    StrMsg := '출고  수량을 입력하세요...!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  for Chk_Pos := 1 to OutSG.RowCount - 1 Do
  Begin
    if (OutSG.Cells[1, Chk_Pos] = LocaEdit.Text)   and
       (OutSG.Cells[2, Chk_Pos] = ItemEdit.Text)   and
       (OutSG.Cells[7, Chk_Pos] = PltIDEdit.Text)  then  Bol_Data_Ok := False;
  End;

  If Not Bol_Data_Ok Then Begin
    StrMsg := ' 동일한 자재번호를 선택 하였습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  OutSg.RowCount :=  IntRow + 1;

  OutSG.Cells[1, IntRow] := LocaEdit.Text;
  OutSG.Cells[2, IntRow] := ItemEdit.Text;
  OutSG.Cells[3, IntRow] := Name1Edit.Text;
  OutSG.Cells[4, IntRow] := QtyEdit.Text;
  OutSG.Cells[5, IntRow] := RQtyEdit.Text;
  OutSG.Cells[6, IntRow] := PgubnEdit.Text;
  OutSG.Cells[7, IntRow] := PltIDEdit.Text;
  OutSG.Cells[8, IntRow] := DateEdit.Text;
  OutSG.Cells[9, IntRow] := TimeEdit.Text;

  Inc(IntRow);

  LocaEdit.Text      := '';
  QtyEdit.Text       := '';
  RQtyEdit.Text      := '';
  ItemEdit.Text      := '';
  Name1Edit.Text     := '';
  QtyEdit.Text       := '';
  PltIDEdit.Text     := '';
  DateEdit.Text      := '';
  TimeEdit.Text      := '';
  RQtyEdit.Text      := '0';             
  ResvGBox.Visible := False;
end;

procedure TFrm_4200.ConfirmBitBtnClick(Sender: TObject); 
begin
  if OutSG.Cells[1,1] = '' Then Begin
    StrMsg := '출고작업할 데이타가 없습니다....' + #13#10 + '출고 데이타를 입력 후 다시 시도 하십시요!!';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;

  StrMsg := ' 수동 출고 예약을 확정 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin  Exit;    End;    

  sys_datetime  :=  f_get_sysdate_time1();
  StrDate       := copy(sys_datetime, 1, 8);
  StrTime       :=  copy(sys_datetime, 9, 6);
  S_Date        :=  copy(sys_datetime, 1, 8);
  S_Time        :=  copy(sys_datetime, 9, 6);

   Var_Sql := ' TRUNCATE TABLE STK1_TIODAT ';
   With Query2 Do Begin
    Try
      Close;
      SQL.Clear;
      SQL.Add(Var_Sql);
      ExecSql;
     Except
       Showmessage('삭제에러 TIODAT' ); Exit;
     End;
   End;

   Output_Resv_Proc;
end;
/////////////////////////////////////////////////////////////////////////
////////////////////////// Output_Proc //////////////////////////////////
/////////////////////////////////////////////////////////////////////////
procedure TFrm_4200.Output_Resv_Proc;
var
   ls_loca, ls_code, ls_qty, ls_rqty,ls_pgubn, ls_pltid,  ls_Indate,  ls_Intime : String;
begin

  IntPos := 1;

   For IntPos := 1 To OutSG.RowCount - 1 Do Begin
    With OutSG Do Begin
      If OutSG.Cells[1, IntPos] = '' Then Break;

      ls_loca    :=   OutSG.Cells[1, IntPos];
      ls_code    :=   OutSG.Cells[2, IntPos];
      ls_qty     :=   OutSG.Cells[4, IntPos];
      ls_rqty    :=   OutSG.Cells[5, IntPos];
      ls_pgubn   :=   OutSG.Cells[6, IntPos];
      ls_pltid   :=   OutSG.Cells[7, IntPos];
      ls_Indate  :=   OutSG.Cells[8, IntPos];
      ls_Intime  :=   OutSG.Cells[9, IntPos];

      While Pos(',', ls_qty) > 0 Do Begin Delete(ls_qty, Pos(',', ls_qty), 1); End;
      While Pos(',', ls_rqty) > 0 Do Begin Delete(ls_rqty, Pos(',', ls_rqty), 1); End;
      While Pos('-', ls_Indate) > 0 Do Begin Delete(ls_Indate, Pos('-', ls_Indate), 1); End;
      While Pos('-', ls_loca) > 0 Do Begin Delete(ls_loca, Pos('-', ls_loca), 1); End;
      While Pos(':', ls_InTime) > 0 Do Begin Delete(ls_InTime, Pos(':', ls_InTime), 1); End;   

      OutInfo_Create(ls_pltid, ls_loca, ls_code, ls_qty, ls_rqty, ls_pgubn, ls_InDate, ls_InTime);
     End;
   End;

// 실제 출고 데이타를 생성한다. 
  OutLetData_Insert_Proc;
  Showmessage( '◁ 전체 출고 예약이 완료 되었습니다. ▷  = ' + IntToStr(IntCnt) );

  Out_Grid_Clear;
  Stock_Grid_Clear;
  LblSumQty.Caption := '';
end;

procedure TFrm_4200.OutInfo_Create(Outpltid, Outloca, Outcode, Outqty, Outrqty, OutPgubn, OutInDate, OutInTime : String);
begin
  var_sql := ' Insert Into STK1_TIODAT(ODAT_PLTID, ODAT_LOCA, ODAT_CODE, ODAT_QTY, ';
  var_sql :=  var_sql + '             ODAT_RQTY,   ODAT_PGUBN, ODAT_INDATE, ODAT_INTIME )';
  var_sql :=  var_sql + '    Values('''+Outpltid+''', '''+Outloca+''', '''+Outcode+''', '''+Outqty+''', ';
  var_sql :=  var_sql + '           '''+Outrqty+''',  '''+OutPgubn+''', '''+OutInDate+''', '''+OutInTime+''' )';
  Try
    With UpdtQuery do Begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      ExecSQL;
    End;
  Except
    Showmessage('등록에러 TIODAT' + var_sql );
  End;
end;

procedure TFrm_4200.OutLetData_Insert_Proc;
begin 
  s_sw := '0';
  var_sql := ' Select  *  From STK1_TIODAT (NOLOCK)';
  var_sql := var_sql + ' Order By  ODAT_PltID, ODAT_LOCA, ODAT_CODE ';
  With DispQuery Do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_sql);
    Open;
    First;

    if (RecordCount = 0 ) Then Exit;  

    Save_PltID := '';     IntCnt := 0;

   While True do
   Begin
      if Eof  then
      begin
         ReinPut_Data_Proc(SAVE_PltID, StrLoca, Strcode);
         Exit;
      end;

      if s_sw =  '0'  then    Save_PltID :=  FieldByName('ODAT_PLTID').AsString;

      s_PltID   := FieldByName('ODAT_PLTID').AsString;

      if ( S_PltID <> SAVE_PltID)  then
      begin
         ReinPut_Data_Proc(SAVE_PltID, StrLoca,  StrCode);
         Save_PltID := S_PltID;
      end;

      s_sw := '1';
      StrPltID      := FieldByName('ODAT_PLTID').AsString;
      StrLoca       := FieldByName('ODAT_LOCA').AsString;
      StrCode       := FieldByName('ODAT_CODE').AsString;
      StrRQTY       := FieldByName('ODAT_RQTY').AsString;
      StrIndate     := FieldByName('ODAT_INDATE').AsString;
      StrIntime     := FieldByName('ODAT_INTIME').AsString;

      Inc(IntCnt);

      var_sql := ' Update STK1_MISUBK Set SUBK_FLAG = ''Y'',  ';
      var_sql := var_sql + ' SUBK_RQTY = Convert(Numeric,'''+StrRQty+''') ';
      var_sql := var_sql + ' Where SUBK_LOCA    = '''+StrLoca+''' ';
      var_sql := var_sql + '   And SUBK_PLTID   = '''+StrPltID+''' ';
      var_sql := var_sql + '   And SUBK_CODE    = '''+Strcode+''' ';
      Try
        With UpdtQuery do
        Begin
          Close;
          SQL.Clear;
          SQL.ADD(var_sql);
          ExecSql;
        End;

        var_sql := ' Update STK1_MILSTK Set LSTK_FLAG = ''Y'' Where LSTK_LOCA = '''+StrLoca+''' ';
        With UpdtQuery do Begin
          Close;
          SQL.Clear;
          SQL.ADD(var_sql);
          ExecSql;
        End;
      Except
          showmessage(var_sql);  Exit;
      End;
      Next;
    End;
  End;   
end;



procedure TFrm_4200.ReinPut_Data_Proc(OutPLTID, OutLoca, OutCode : String);
var
  ls_From, ls_to, ls_Date, ls_time, ls_Loca, ls_code, ls_PLTID, ls_pgubn : String;
  ls_InDate,  ls_InTime,  ls_Flag, ls_Rflag, ls_Qty, ls_RQty : String;
begin
  Try

   sys_datetime :=  f_get_sysdate_time1();
   StrDate       :=  copy(sys_datetime, 1, 8);
   StrTime       :=  copy(sys_datetime, 9, 6);
   S_Date        :=  copy(sys_datetime, 1, 8);
   S_Time        :=  copy(sys_datetime, 9, 6);       

   var_sql := ' Select STAT_ODATE, STAT_OINDX From STK1_TBSTAT (NOLOCK) ';
   var_sql := var_sql + ' Where STAT_PSWD = ''JPLS'' ';
   With StatQuery do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_sql);
    Open;

    ls_date := StatQuery.FieldByName('STAT_ODATE').AsString;
   End;

   if  (ls_date = StrDate)  then
   begin
     s_index := StrDate + 'O' + Format('%4.4d', [StatQuery.FieldByName('STAT_OINDX').AsInteger]);
    if StatQuery.FieldByName('STAT_OINDX').AsInteger >= 9999 Then Begin
     var_sql := ' Update STK1_TBSTAT Set STAT_OINDX = Convert(Numeric, ''1'') ';
    End Else Begin
     var_sql := ' Update STK1_TBSTAT Set STAT_OINDX = STAT_OINDX + 1 ';
    End;
     var_sql := var_sql + ' Where STAT_PSWD = ''JPLS'' ';
   end
   else
   begin
     s_index := StrDate + 'O' + Format('%4.4d', [1]);
     var_sql := ' Update STK1_TBSTAT Set STAT_ODATE = '''+StrDate+''', STAT_OINDX = Convert(Numeric,''2'') ';
     var_sql := var_sql + ' Where STAT_PSWD = ''JPLS'' ';
   end;
   StatQuery.Close;
   StatQuery.SQL.Clear;
   StatQuery.SQL.Add(var_sql);
   StatQuery.ExecSQL;

   var_sql := ' Select   * From  STK1_MISUBK (NOLOCK)';
   var_sql := var_sql + '  Where SUBK_LOCA = '''+OutLoca+''' ';
   var_sql := var_sql + '   And  ISNULL(SUBK_QTY, 0) <> ISNULL(SUBK_RQTY, 0) ';
//   var_sql := var_sql + '   And  SUBK_FLAG = ''Y'' ';
   With UpdtQuery Do Begin
     Close;
     SQL.Clear;
     SQL.Add(var_sql);
     Open;

     if RecordCount = 0 Then  Insert_TiSche_Proc(OutPLTID, s_index, OutLoca, 'T')
     else Insert_TiSche_Proc(OutPLTID, s_index, OutLoca,  'P');
   End;

   var_sql := ' Select  * From STK1_MISUBK (NOLOCK) ';
   var_sql := var_sql + ' Where SUBK_LOCA  = '''+OutLoca+''' ';
   var_sql := var_sql + ' And   SUBK_PLTID = '''+OutPLTID+''' ';
   With Query2 Do Begin
     Close;
     SQL.Clear;
     SQL.Add(var_sql);
     Open;
     First;
     While Not Eof Do
     Begin
       ls_Loca    := FieldByName('SUBK_LOCA').AsString;
       ls_code    := FieldByName('SUBK_CODE').AsString;
       ls_pltid   := FieldByName('SUBK_PLTID').AsString;
       ls_pgubn   := FieldByName('SUBK_PGUBN').AsString;
       ls_qty     := FieldByName('SUBK_QTY').AsString;
       ls_rqty    := FieldByName('SUBK_RQTY').AsString;
       ls_InDate  := FieldByName('SUBK_INDATE').AsString;
       ls_InTime  := FieldByName('SUBK_INTIME').AsString;
       ls_Flag    := FieldByName('SUBK_FLAG').AsString;

       NumQty     := FieldByName('SUBK_QTY').AsFloat;
       NumOutQty  := FieldByName('SUBK_RQTY').AsFloat;
       ls_Qty := FloatToStr(NumQty);
       ls_RQty := FloatToStr(NumOutQty);

       if (NumOutQty) = 0             Then  ls_Rflag  := 'A'
       else if (NumQty <> NumOutQty)  Then  ls_Rflag  := 'R'
       else if (NumQty = NumOutQty)   Then  ls_Rflag  := 'O'
       else  ls_Rflag  := 'O';

       var_sql := ' Insert Into STK1_MIOUPT(OUPT_DATE, OUPT_INDEX,  OUPT_PLTID,  OUPT_CODE,  OUPT_SEQNO, ';
       var_sql := var_sql + '              OUPT_QTY, OUPT_OUT_QTY, OUPT_RLOCA,  OUPT_LOCA,  OUPT_PGUBN, ';
       var_sql := var_sql + '              OUPT_JOB_FLAG,  OUPT_TIME,   OUPT_RFLAG,   OUPT_INDATE, OUPT_INTIME ) ';
       var_sql := var_sql + ' Values('''+S_Date+''',   '''+s_index+''',  '''+OutPLTID+''', '''+ls_code+''', ''1'', ';
       var_sql := var_sql + '     '''+ls_Qty+''', '''+ls_Rqty+''', '''+ls_Loca+''',  '''', '''+ls_pgubn+''', ';
       var_sql := var_sql + '     ''0'',  '''+S_Time+''',  '''+ls_Rflag+''',  '''+ls_Indate+''', '''+ls_InTime+''' ) ';
       With UpdtQuery Do Begin
          Close;
          SQL.Clear;
          SQL.Add(var_sql);
          ExecSQL;
       End;
      Next;
     End;                  // End of While
   End;
   Except
     showmessage(var_sql);  Exit;
   End;
end;


procedure TFrm_4200.Insert_TiSche_Proc(OutPltID, OutIndex, OutLoca, OutType : String);
var
  ls_From, ls_To, ls_High, ls_Sc, ls_Emg, ls_Eplt, ls_Fact : String;
begin
//  if (Copy(OutLoca, 1,1) = '2')  then Exit;

  if EmgCheckBox.Checked = True  then  ls_Emg  := 'E'  else  ls_Emg  := 'N';

  if (Copy(OutLoca, 2,1) = '1') Or (Copy(OutLoca, 2,1) = '2')      Then  ls_Sc := '1'
  Else if (Copy(OutLoca, 2,1) = '3') Or (Copy(OutLoca, 2,1) = '4')      Then  ls_Sc := '2'
  Else if (Copy(OutLoca, 2,1) = '5') Or (Copy(OutLoca, 2,1) = '6')      Then  ls_Sc := '3';

  var_sql := ' Insert Into STK1_TBSCHE(SCHE_SC,    SCHE_INDEX, SCHE_JOB, SCHE_LOCA,  SCHE_PLTID, ';
  var_sql := var_sql + '               SCHE_EMER,  SCHE_DATE,  SCHE_TIME  ) ';
  var_sql := var_sql + ' Values('''+ls_Sc+''', '''+OutIndex+''', '''+OutType+''',  '''+OutLoca+''', '''+OutPltID+''', ';
  var_sql := var_sql + '        '''+ls_Emg+''', '''+S_Date+''', '''+S_Time+''' ) ';
 Try
    With StatQuery Do Begin
      Close;
      SQL.Clear;
      SQL.Add(var_sql);
      ExecSql;
    End;
 Except
    showmessage(var_sql);  Exit;
 End;   
end;


procedure TFrm_4200.StockSGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
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
          Font.Color  := clBlack;
          Style := [fsBold];
        End;
        FillRect(Rect);
        TextOut(LeftPos, Rect.Top+5, CellStr);
      End;
    End;
    IF ARow > 0 Then Begin
      if (ACol = 5) Then Begin
        LeftPos := (Rect.Right-Rect.Left-TStringGrid(Sender).Canvas.TextWidth(CellStr)) + Rect.Left;  // 오른쪽 정렬
        FillRect(Rect);
        TextOut(LeftPos, Rect.Top+5, CellStr);
      End;
      if (ACol > 5) Then Begin
        LeftPos := ((Rect.Right-Rect.Left-TStringGrid(Sender).Canvas.TextWidth(CellStr)) div 2) + Rect.Left;  // 가운데
        FillRect(Rect);
        TextOut(LeftPos, Rect.Top+5, CellStr);
      End;
    End;
  End;

end;

procedure TFrm_4200.ExitSPClick(Sender: TObject);
begin
  ResvGBox.Visible := False;
end;

procedure TFrm_4200.ExitBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_4200.FormDestroy(Sender: TObject);
begin
  Frm_4200 := Nil;
end;

procedure TFrm_4200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;   

procedure TFrm_4200.SB_SearchClick(Sender: TObject);
begin
  Bol_Data_Ok := True;
  Bol_Modal   := False;
  Var_Form    := Nil;

  Mast_Disp  := TMast_Disp.Create(Application);
  Bol_Modal := True;

  Mast_Disp.Edt_Search.Text := CodeCb.Text;
  If Mast_Disp <> Nil Then
    With TForm(Mast_Disp) Do Begin
      if Bol_Modal Then ShowModal
      Else Begin
        BorderIcons := [];
        Show;
      End;
      Mast_Disp.Free;
    End;

    CodeCb.Text :=  jj_code;
    NameEdit.Text :=  jj_name;
end;

procedure TFrm_4200.CancelSBClick(Sender: TObject);
var
  m_Row, i, j : Integer;
begin
  if OutSG.Cells[1,OutSG.Row] = '' Then Begin
    StrMsg := '삭제할 데이타가 없습니다....';
    WinLib_ErrorForm( StrMsg );
    Exit;
  End;
  StrMsg := ' 현재 라인을 삭제 하겠습니까 ? .';
  If Not WinLib_ConfirmForm( StrMsg ) Then Begin
    Exit;
  End;

  m_Row := OutSG.Row;

  for j := m_Row to  OutSG.RowCount-2 do
  begin
    for i := 0 to    OutSG.ColCount-1  do
    begin
      OutSG.Cells[i, j] := OutSG.Cells[i, j+1];
    end;
  end;

  for j := 0 to  OutSG.ColCount-1  do
  begin
    OutSG.Cells[j, OutSG.RowCount-1] := '';
  end;

  IntRow := IntRow - 1; 
  If OutSG.RowCount > 2 Then OutSG.RowCount := OutSG.RowCount - 1;
  OutSG.Col := 0;
end;

function TFrm_4200.f_get_sysdate_time1(): String;
var
  ls, ls_date, ls_sql : String;
Begin
    ls_sql := ' select convert(char(19), getdate(), 120)  from stk_dumm_tbl (NOLOCK) ';
    With Query2 Do Begin
      Close;
      SQL.Clear;
      SQL.Add(ls_sql);
      Open;
      ls_date    := Fields[0].AsString;
    End;

    ls := trim(ls_date);
    ls_date := Copy(ls, 1, 4)  + Copy(ls, 6, 2)  + Copy(ls, 9, 2) + Copy(ls, 12, 2) + Copy(ls, 15, 2) + Copy(ls, 18, 2);

    Result :=  ls_date;
end;


procedure TFrm_4200.ClearSBClick(Sender: TObject);
begin
    Out_Grid_Clear;
end;

end.

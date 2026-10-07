unit Frm7100;

interface      

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DBGrids, Db, DBTables,
  DBCtrls, Mask, ADODB, GradRoundBtn;

type
  TFrm_7100 = class(TForm)
    Panel6: TPanel;
    GroupBox10: TGroupBox;
    Query1: TADOQuery;
    Query2: TADOQuery;
    Panel3: TPanel;
    CloseBtn: TSpeedButton;
    Shape1: TShape;
    Query3: TADOQuery;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Panel7: TPanel;
    Panel2: TPanel;
    jaegoSb: TSpeedButton;
    DateTimePicker1: TDateTimePicker;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
                                               
    procedure CloseBtnClick(Sender: TObject);    
    procedure jaegoSbClick(Sender: TObject);

  private
    { Private declarations }
    function IsDate(Str : String) : Boolean;
    procedure lstkjago_insert_proc;
    procedure lstkjagoP_insert_proc;
    procedure StokjagoP_insert_proc;
    procedure Cntl_MISUBK_Insert;
    procedure Mistok_Insert_Proc;

  public
    { Public declarations }
  end;

var
  Frm_7100: TFrm_7100;
  io_date, lo_yyyy, lo_mm, lo_dd   :String;

  s_date, s_wh, s_code, s_lotno, s_sqty, s_wqty : String;
  s_Aqty, s_Bqty,  s_Cqty,  s_Dqty,  s_Eqty, s_Fqty, s_Tqty : String;

  li_cnt : Integer;

implementation

Uses  DBSet, WinLib, FrmPrompt, FrmError, FrmProgress;

{$R *.DFM}


procedure TFrm_7100.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := Now;
end;

procedure TFrm_7100.jaegoSbClick(Sender: TObject);
var
  var_Msg, ls_sql : String;
begin
  var_Msg := ' 전일재고 작성을 하시곘습니까? [실행확인]';
  if WinLib_ConfirmForm(var_Msg) then
  begin

    s_date  := FormatDateTime( 'YYYYMMDD', DateTimePicker1.Date );
    lstkjago_insert_proc; // 전일 재고 현황
    Mistok_Insert_Proc;   // 수자동 재고 현황

  end;
end;

procedure TFrm_7100.lstkjago_insert_proc;
var
   ls_sql, ls_date : String;
begin
  Try
    ls_SQL := ' Delete  From  T2MIJEGO WHERE JEGO_DATE  = '''+s_date +''' ';

    Query3.Close;
    Query3.SQL.Clear;
    Query3.SQL.Add(ls_SQL);
    Query3.ExecSql;

    ls_SQL := ' Delete  From  T2MISTOK WHERE STOK_DATE  = '''+s_date +''' ';

    Query3.Close;
    Query3.SQL.Clear;
    Query3.SQL.Add(ls_SQL);
    Query3.ExecSql;


    lstkjagoP_insert_proc;
    StokjagoP_insert_proc;

    ls_date := Copy(s_date,1,4) + '-'  + Copy(s_date,5,2) + '-'  + Copy(s_date,7,2);
    Showmessage(ls_date + ' = ' + IntTostr(li_cnt) +   ' 건 전일재고 작성을 완료하였습니다.');
 Except
    //
 end;
end;

procedure TFrm_7100.Mistok_Insert_Proc;
var
  ls_sql : String;
begin
  Try
    // 1. 기존 마감 데이터 삭제 (중복 방지)
    ls_SQL := ' DELETE FROM MISTOK_HIST WHERE CLOSE_DATE = ''' + s_date + ''' ';
    
    Query3.Close;
    Query3.SQL.Clear;
    Query3.SQL.Add(ls_SQL);
    Query3.ExecSql;

    // 2. 신규 마감 데이터 입력
    ls_SQL := ' INSERT INTO MISTOK_HIST ( ';
    ls_SQL := ls_SQL + '    CLOSE_DATE, ';
    ls_SQL := ls_SQL + '    STOK_WH, STOK_ITEM, MAST_NAME, STOK_LOTNO, STOK_LOCA, ';
    ls_SQL := ls_SQL + '    STOK_QTY, STOK_BOXNO, STOK_REMARK, STOK_INDATE, STOK_INTIME, ';
    ls_SQL := ls_SQL + '    STOK_FLAG, GUBN1_CODE, GUBN2_CODE, GUBN3_CODE ';
    ls_SQL := ls_SQL + ' ) ';
    ls_SQL := ls_SQL + ' SELECT ';
    ls_SQL := ls_SQL + '    ''' + s_date + ''', ';  // 전역변수 s_date 사용 (YYYYMMDD)
    ls_SQL := ls_SQL + '    A.STOK_WH, ';
    ls_SQL := ls_SQL + '    A.STOK_ITEM, ';
    ls_SQL := ls_SQL + '    B.MAST_NAME, ';
    ls_SQL := ls_SQL + '    A.STOK_LOTNO, ';
    ls_SQL := ls_SQL + '    A.STOK_LOCA, ';
    ls_SQL := ls_SQL + '    A.STOK_QTY, ';
    ls_SQL := ls_SQL + '    A.STOK_BOXNO, ';
    ls_SQL := ls_SQL + '    A.STOK_REMARK, ';
    ls_SQL := ls_SQL + '    A.STOK_INDATE, ';
    ls_SQL := ls_SQL + '    A.STOK_INTIME, ';
    ls_SQL := ls_SQL + '    A.STOK_FLAG, ';
    ls_SQL := ls_SQL + '    B.MAST_GUBN1, ';  // 코드값 저장
    ls_SQL := ls_SQL + '    B.MAST_GUBN2, ';
    ls_SQL := ls_SQL + '    B.MAST_GUBN3 ';
    ls_SQL := ls_SQL + ' FROM MISTOK A (NOLOCK) ';
    ls_SQL := ls_SQL + ' LEFT OUTER JOIN MIMAST B (NOLOCK) ON B.MAST_CODE = A.STOK_ITEM ';
    ls_SQL := ls_SQL + ' WHERE ISNULL(A.STOK_ITEM, '''') <> '''' ';
    // 필요시 창고 조건 추가 가능하지만, 전체 마감이므로 조건 없이 진행
    ls_SQL := ls_SQL + ' ORDER BY A.STOK_ITEM, A.STOK_LOCA ';

    Query3.Close;
    Query3.SQL.Clear;
    Query3.SQL.Add(ls_SQL);
    Query3.ExecSql;

  Except
    On E: Exception do
      ShowMessage('수/자동 재고 마감 중 오류 발생: ' + E.Message);
  End;
end;


procedure TFrm_7100.lstkjagoP_insert_proc;
var
   ls_sql, ls_sysdate : String;
begin
   li_cnt := 0;
   Try
     ls_SQL := '  SELECT STK_WH, STK_CODE,  STK_LOTNO, SUM(STK_WQTY) STK_WQTY,   ';
     ls_SQL := ls_SQL + ' SUM(STK_SQTY) STK_SQTY,  SUM(STK_AQTY) STK_AQTY, SUM(STK_BQTY) STK_BQTY,   SUM(STK_CQTY) STK_CQTY, ';
     ls_SQL := ls_SQL + ' SUM(STK_DQTY) STK_DQTY,  SUM(STK_EQTY) STK_EQTY, SUM(STK_FQTY) STK_FQTY, SUM(STK_TQTY) STK_TQTY ';
     ls_SQL := ls_SQL + ' FROM SUBK_ALL (NOLOCK) ';
     ls_SQL := ls_SQL + ' WHERE  ISNULL(STK_CODE, '''') <> ''''    ';
     ls_SQL := ls_SQL + ' GROUP BY  STK_WH, STK_CODE,  STK_LOTNO    ';
     ls_SQL := ls_SQL + ' ORDER BY  STK_WH, STK_CODE,  STK_LOTNO    ';

     Query2.Close;
     Query2.SQL.Clear;
     Query2.SQL.Add(ls_sql);
     Query2.Open;

     If Query2.Recordcount = 0 Then Exit;

     while True do
     begin
     if Query2.Eof = True then break;
        s_wh      := Query2.FieldByName('STK_WH').AsString;
        s_code    := Query2.FieldByName('STK_CODE').AsString;
        s_lotno   := Query2.FieldByName('STK_LOTNO').AsString;
        s_sqty    := Query2.FieldByName('STK_SQTY').AsString;
        s_wqty    := Query2.FieldByName('STK_WQTY').AsString;
        s_Aqty    := Query2.FieldByName('STK_AQTY').AsString;
        s_Bqty    := Query2.FieldByName('STK_BQTY').AsString;
        s_Cqty    := Query2.FieldByName('STK_CQTY').AsString;
        s_Dqty    := Query2.FieldByName('STK_DQTY').AsString;
        s_Eqty    := Query2.FieldByName('STK_EQTY').AsString;
        s_Fqty    := Query2.FieldByName('STK_FQTY').AsString;
        s_Tqty    := Query2.FieldByName('STK_TQTY').AsString;
        Cntl_MISUBK_Insert;
        Query2.Next;
     end;

   Except 
       Showmessage('lstkjago_insert_proc Error = ' +  ls_sql);
   End;
end;



procedure TFrm_7100.Cntl_MISUBK_Insert;
var
   ls_model, ls_model1, ls_name, ls_bubun, ls_fser, ls_LTotal, ls_RTotal, ls_Total, ls_prod : String;
   li_start, li_count, li_loca, li_insert : Integer;
   li_LTotal, li_RTotal, li_Total : Integer;
   ls_sysdate : String;
   ls_Agubn, ls_flag, ls_sql : String;
begin 
   Try
       ls_SQL := ' Insert Into T2MIJEGO ';
       ls_SQL := ls_SQL  + ' (JEGO_DATE, JEGO_WH, JEGO_CODE, JEGO_LOTNO, JEGO_SQTY, JEGO_WQTY,  ';
       ls_SQL := ls_SQL  + ' JEGO_AQTY, JEGO_BQTY, JEGO_CQTY, JEGO_DQTY, JEGO_EQTY, JEGO_FQTY, JEGO_TQTY ) ';
       ls_SQL := ls_SQL  + ' Values('''+s_date+''', '''+s_wh+''', '''+s_code+''', '''+s_lotno+''', '''+s_sqty+''', '''+s_wqty+''', ';
       ls_SQL := ls_SQL  + '        '''+s_Aqty+''', '''+s_Bqty+''', '''+s_Cqty +''', '''+s_Dqty+''', '''+s_Eqty+''', '''+s_Fqty +''', '''+s_Tqty +''')  ';

       Query3.Close;
       Query3.SQL.Clear;
       Query3.SQL.Add(ls_SQL);
       Query3.ExecSql;
       INC(li_cnt);
     Except 
       Showmessage(ls_sql);
     End;   
end;

procedure TFrm_7100.stokjagoP_insert_proc;
var
  var_Sql : String;
  li_qty, li_sum, li_esum, li_tsum, li_total, li_oldqty : Integer;
  Empt_Cnt, S_percent : String;
  Stok_Percent : Real;
  Stok_cnt, Stok_cnt1, Stok_cnt2,  Stok_cnt3 : integer;
  StrQty1, StrQty2, StrQty3 : String;

  T1_Qty1, T1_Qty2,  T1_Qty3,  T1_Qty4,  T1_Qty5,  T1_Qty6,  T1_Qty7,  T1_Qty8  : Real;
  T1_Qty9, T1_Qty10, T1_Qty11, T1_Qty12, T1_Qty13, T1_Qty14, T1_Qty15, T1_Qty16 : Real;
  T2_Qty1, T2_Qty2,  T2_Qty3,  T2_Qty4,  T2_Qty5,  T2_Qty6,  T2_Qty7,  T2_Qty8  : Real;
  T2_Qty9, T2_Qty10, T2_Qty11, T2_Qty12, T2_Qty13, T2_Qty14, T2_Qty15, T2_Qty16 : Real;
  S1_Qty1, S1_Qty2,  S1_Qty3,  S1_Qty4,  S1_Qty5,  S1_Qty6,  S1_Qty7,  S1_Qty8  : Real;
  S1_Qty9, S1_Qty10, S1_Qty11, S1_Qty12, S1_Qty13, S1_Qty14, S1_Qty15, S1_Qty16 : Real;
  TT_Qty1, TT_Qty2,  TT_Qty3,  TT_Qty4,  TT_Qty5,  TT_Qty6,  TT_Qty7,  TT_Qty8  : Real;
  TT_Qty9, TT_Qty10, TT_Qty11, TT_Qty12, TT_Qty13, TT_Qty14, TT_Qty15, TT_Qty16 : Real;

  ST1_Qty1, ST1_Qty2, ST1_Qty3, ST1_Qty4, ST1_Qty5, ST1_Qty6, ST1_Qty7, ST1_Qty8 : String;
  ST1_Qty9, ST1_Qty10, ST1_Qty11, ST1_Qty12, ST1_Qty13, ST1_Qty14, ST1_Qty15, ST1_Qty16 : String;
  ST2_Qty1, ST2_Qty2, ST2_Qty3, ST2_Qty4, ST2_Qty5, ST2_Qty6, ST2_Qty7, ST2_Qty8 : String;
  ST2_Qty9, ST2_Qty10, ST2_Qty11, ST2_Qty12, ST2_Qty13, ST2_Qty14, ST2_Qty15, ST2_Qty16 : String;

  SS1_Qty1, SS1_Qty2, SS1_Qty3, SS1_Qty4, SS1_Qty5, SS1_Qty6, SS1_Qty7, SS1_Qty8 : String;
  SS1_Qty9, SS1_Qty10, SS1_Qty11, SS1_Qty12, SS1_Qty13, SS1_Qty14, SS1_Qty15, SS1_Qty16 : String;

  STT_Qty1, STT_Qty2, STT_Qty3, STT_Qty4, STT_Qty5, STT_Qty6, STT_Qty7, STT_Qty8 : String;
  STT_Qty9, STT_Qty10, STT_Qty11, STT_Qty12, STT_Qty13, STT_Qty14, STT_Qty15, STT_Qty16 : String;
begin

//  생산동자동창고;

  li_sum := 0;  li_total := 0;   li_oldqty := 0;  li_esum := 0;  li_tsum:= 0;


/////////////  Auto /////////////////////////////////////////////
  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''CG'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty1:= RecordCount;

  end;


  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''PG'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty2 := RecordCount;
  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RM'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty3 := RecordCount;
  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RD'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty4 := RecordCount;
  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''MF'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty5 := RecordCount;
  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''SA'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty6 := RecordCount;
  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''QC'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty7 := RecordCount;
  end;

  var_Sql := ' SELECT     Count(*) As Cnt   ';
  var_Sql := var_Sql + ' FROM   MILSTK ';
  var_Sql := var_Sql + ' WHERE  LSTK_FLAG = ''0'' ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    li_sum := Fields[0].AsInteger;
    li_esum := li_sum;

    T1_Qty8 := li_sum;
  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''EM'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    li_sum := RecordCount;
    li_esum := li_esum + li_sum;
    T1_Qty9 := li_sum;
  end;

  T1_Qty10 := li_esum;


  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE  (SUBK_CODE <> '''') ';
//  var_Sql := var_Sql + '    And (SUBSTRING(SUBK_CODE, 1, 2) <> ''EM'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty11 := RecordCount;

  end;
/////////////////////////////////////////////////////////////////////////////////

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''CG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty12 := Fields[0].AsInteger;
  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''PG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty13 := Fields[0].AsInteger;
  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       MISUBK  ';
  var_Sql := var_Sql + ' WHERE     SUBSTRING(SUBK_CODE, 1, 2) IN (''CG'', ''PG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty14 := Fields[0].AsInteger;
  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RM'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T1_Qty15 := Fields[0].AsInteger;
  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''EM'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;

    Stok_cnt          := 342 - RecordCount;
  end;
{
  var_Sql := ' SELECT     Count(*) As Cnt   ';
  var_Sql := var_Sql + ' FROM   MILSTK ';
  var_Sql := var_Sql + ' WHERE  LSTK_FLAG = ''0'' ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    Stok_cnt := Stok_cnt - Fields[0].AsInteger;
  end;

  T1_Qty16     :=  (Stok_cnt / 342)  * 100;
}
  var_Sql := ' SELECT    SUBK_LOCA  FROM   MISUBK';
  var_Sql := var_Sql + ' WHERE (SUBSTRING(SUBK_CODE, 1, 2) IN ';
  var_Sql := var_Sql + ' (''CG'', ''PG'', ''RM'', ''RD'', ''MF'', ''SA'', ''QC'')) ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;

    Stok_cnt := RecordCount;

    T1_Qty16     :=  (Stok_cnt / 342)  * 100;
  end;

  //  외부동 자동창고;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''CG'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty1 := RecordCount;
  end;


  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''PG'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty2 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RM'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty3 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RD'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty4 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''MF'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty5 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''SA'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty6 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''QC'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty7 := RecordCount;

  end;

  var_Sql := ' SELECT     Count(*) As Cnt   ';
  var_Sql := var_Sql + ' FROM   T2MILSTK ';
  var_Sql := var_Sql + ' WHERE  LSTK_FLAG = ''0'' ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;

    li_sum := Fields[0].AsInteger;
    li_esum := li_sum;
    T2_Qty8 := li_sum;

  end;

  var_Sql := ' SELECT    SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE  (ISNULL(SUBK_CODE, '''')  <> '''') ';
  var_Sql := var_Sql + '    And (SUBSTRING(SUBK_CODE, 1, 2) = ''EM'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    li_sum := RecordCount;

    li_esum := li_esum + li_sum;

    T2_Qty9 := li_sum;
  end;


  T2_Qty10 := li_esum;

  var_Sql := ' SELECT     Count(*) As Cnt   ';
  var_Sql := var_Sql + ' FROM   T2MILSTK ';
  var_Sql := var_Sql + ' WHERE  LSTK_FLAG <> ''0'' ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty11 := Fields[0].AsInteger;

  end;     
/////////////////////////////////////////////////////////////////////////////////

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''CG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty12 := Fields[0].AsInteger;

  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''PG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty13 := Fields[0].AsInteger;
  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     SUBSTRING(SUBK_CODE, 1, 2) IN (''CG'', ''PG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty14 := Fields[0].AsInteger;
  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       T2MISUBK  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RM'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    T2_Qty15 := Fields[0].AsInteger;
  end;
{
  var_Sql := ' SELECT     Count(*) As Cnt   ';
  var_Sql := var_Sql + ' FROM   T2MILSTK ';
  var_Sql := var_Sql + ' WHERE  LSTK_FLAG = ''0'' ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;

    li_sum := Fields[0].AsInteger;

    Stok_cnt         := 702 - li_sum;
    T2_Qty16     :=  (Stok_cnt / 702)  * 100;

  end;
}
  var_Sql := ' SELECT    SUBK_LOCA  FROM   T2MISUBK';
  var_Sql := var_Sql + ' WHERE (SUBSTRING(SUBK_CODE, 1, 2) IN ';
  var_Sql := var_Sql + ' (''CG'', ''PG'', ''RM'', ''RD'', ''MF'', ''SA'', ''QC'')) ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;

    Stok_cnt := RecordCount;

    T2_Qty16     :=  (Stok_cnt / 702)  * 100;
  end;

//////////////////////// 수동창고  /////////////////////////////////////////////
  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''CG'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty1 := RecordCount;

  end;


  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''PG'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty2 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RM'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty3 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RD'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty4 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''MF'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty5 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''SA'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty6 := RecordCount;

  end;

  var_Sql := ' SELECT     SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''QC'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty7 := RecordCount;

  end;


  var_Sql := ' SELECT     Count(*) As Cnt   ';
  var_Sql := var_Sql + ' FROM      MILSTK1  ';
  var_Sql := var_Sql + ' WHERE     LSTK_FLAG = ''0'' ';
  var_Sql := var_Sql + ' And LSTK_LOCA Not In (''A1171'', ''A1172'', ''A1173'', ';
  var_Sql := var_Sql + '                       ''A1181'', ''A1182'', ''A1183'', ';
  var_Sql := var_Sql + '                       ''B1321'', ''B1322'', ''B1323'', ';
  var_Sql := var_Sql + '                       ''C1321'', ''C1322'', ''C1323'', ';
  var_Sql := var_Sql + '                       ''D1321'', ''D1322'', ''D1323'', ';
  var_Sql := var_Sql + '                       ''E1321'', ''E1322'', ''E1323'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    li_sum := Fields[0].AsInteger;
    li_esum := li_sum;

    S1_Qty8 := li_sum;

  end;

  var_Sql := ' SELECT    SUBK_LOCA   ';
  var_Sql := var_Sql + ' FROM         MISUBK1  ';
  var_Sql := var_Sql + ' WHERE  (ISNULL(SUBK_CODE, '''')  <> '''') ';
  var_Sql := var_Sql + '  And (SUBSTRING(SUBK_CODE, 1, 2) = ''EM'') ';
  var_Sql := var_Sql + '  And SUBK_LOCA Not In (''A1171'', ''A1172'', ''A1173'', ';
  var_Sql := var_Sql + '                        ''A1181'', ''A1182'', ''A1183'', ';
  var_Sql := var_Sql + '                        ''B1321'', ''B1322'', ''B1323'', ';
  var_Sql := var_Sql + '                        ''C1321'', ''C1322'', ''C1323'', ';
  var_Sql := var_Sql + '                        ''D1321'', ''D1322'', ''D1323'', ';
  var_Sql := var_Sql + '                        ''E1321'', ''E1322'', ''E1323'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    li_sum := RecordCount;
    li_esum := li_esum  +  li_sum;

    S1_Qty9 := li_sum;
  end;

  S1_Qty10 := li_esum;


  var_Sql := ' SELECT     Count(*) As Cnt   ';
  var_Sql := var_Sql + ' FROM      MILSTK1  ';
  var_Sql := var_Sql + ' WHERE     LSTK_FLAG <> ''0'' ';
  var_Sql := var_Sql + ' And LSTK_LOCA Not In (''A1171'', ''A1172'', ''A1173'', ';
  var_Sql := var_Sql + '                       ''A1181'', ''A1182'', ''A1183'', ';
  var_Sql := var_Sql + '                       ''B1321'', ''B1322'', ''B1323'', ';
  var_Sql := var_Sql + '                       ''C1321'', ''C1322'', ''C1323'', ';
  var_Sql := var_Sql + '                       ''D1321'', ''D1322'', ''D1323'', ';
  var_Sql := var_Sql + '                       ''E1321'', ''E1322'', ''E1323'') ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty11 := Fields[0].AsInteger;

  end;
/////////////////////////////////////////////////////////////////////////////////

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''CG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty12 := Fields[0].AsInteger;

  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''PG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty13 := Fields[0].AsInteger;

  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     SUBSTRING(SUBK_CODE, 1, 2) IN (''CG'', ''PG'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty14 := Fields[0].AsInteger;

  end;

  var_Sql := ' SELECT     SUM(SUBK_WGT) As  SUBK_WGT  ';
  var_Sql := var_Sql + ' FROM       MISUBK1  ';
  var_Sql := var_Sql + ' WHERE     (SUBSTRING(SUBK_CODE, 1, 2) = ''RM'') ';

  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    S1_Qty15 := Fields[0].AsInteger;

  end;
{
  var_Sql := ' SELECT     Count(*) As Cnt   ';
  var_Sql := var_Sql + ' FROM      MILSTK1  ';
  var_Sql := var_Sql + ' WHERE     LSTK_FLAG = ''0'' ';
  var_Sql := var_Sql + ' And LSTK_LOCA Not In (''A1171'', ''A1172'', ''A1173'', ';
  var_Sql := var_Sql + '                       ''A1181'', ''A1182'', ''A1183'', ';
  var_Sql := var_Sql + '                       ''B1321'', ''B1322'', ''B1323'', ';
  var_Sql := var_Sql + '                       ''C1321'', ''C1322'', ''C1323'', ';
  var_Sql := var_Sql + '                       ''D1321'', ''D1322'', ''D1323'', ';
  var_Sql := var_Sql + '                       ''E1321'', ''E1322'', ''E1323'') ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;
    li_sum := Fields[0].AsInteger;

    Stok_cnt          := 299 - li_sum;
    S1_Qty16     :=  (Stok_cnt / 299)  * 100;

  end;
}
  var_Sql := ' SELECT    SUBK_LOCA  FROM   MISUBK1';
  var_Sql := var_Sql + ' WHERE (SUBSTRING(SUBK_CODE, 1, 2) IN ';
  var_Sql := var_Sql + ' (''CG'', ''PG'', ''RM'', ''RD'', ''MF'', ''SA'', ''QC'')) ';
  var_Sql := var_Sql + ' And SUBK_LOCA Not In (''A1171'', ''A1172'', ''A1173'', ';
  var_Sql := var_Sql + '                       ''A1181'', ''A1182'', ''A1183'', ';
  var_Sql := var_Sql + '                       ''B1321'', ''B1322'', ''B1323'', ';
  var_Sql := var_Sql + '                       ''C1321'', ''C1322'', ''C1323'', ';
  var_Sql := var_Sql + '                       ''D1321'', ''D1322'', ''D1323'', ';
  var_Sql := var_Sql + '                       ''E1321'', ''E1322'', ''E1323'') ';
  var_Sql := var_Sql + ' GROUP BY SUBK_LOCA  ';
  with Query2 do Begin
    Close;
    SQL.Clear;
    SQL.Add(var_Sql);
    Open;

    Stok_cnt := RecordCount;

    S1_Qty16     :=  (Stok_cnt / 299)  * 100;
  end;




  TT_Qty1  := T1_Qty1 + T2_Qty1 + S1_Qty1;
  TT_Qty2  := T1_Qty2 + T2_Qty2 + S1_Qty2;
  TT_Qty3  := T1_Qty3 + T2_Qty3 + S1_Qty3;
  TT_Qty4  := T1_Qty4 + T2_Qty4 + S1_Qty4;
  TT_Qty5  := T1_Qty5 + T2_Qty5 + S1_Qty5;
  TT_Qty6  := T1_Qty6 + T2_Qty6 + S1_Qty6;
  TT_Qty7  := T1_Qty7 + T2_Qty7 + S1_Qty7;
  TT_Qty8  := T1_Qty8 + T2_Qty8 + S1_Qty8;
  TT_Qty9  := T1_Qty9 + T2_Qty9 + S1_Qty9;
  TT_Qty10 := T1_Qty10 + T2_Qty10 + S1_Qty10;
  TT_Qty11 := T1_Qty11 + T2_Qty11 + S1_Qty11;
  TT_Qty12 := T1_Qty12 + T2_Qty12 + S1_Qty12;
  TT_Qty13 := T1_Qty13 + T2_Qty13 + S1_Qty13;
  TT_Qty14 := T1_Qty14 + T2_Qty14 + S1_Qty14;
  TT_Qty15 := T1_Qty15 + T2_Qty15 + S1_Qty15;

////////////////////////////////////////////////////////////////
 
//  TT_Qty16     :=  (TT_Qty11 / 1343)  * 100;
 TT_Qty16  :=   TT_Qty1 + TT_Qty2 + TT_Qty3 + TT_Qty4 + TT_Qty5 + TT_Qty6 + TT_Qty7;
 TT_Qty16  :=  (TT_Qty16 / 1343)  * 100;

 ST1_Qty1  := FloatToStr(T1_Qty1);    ST1_Qty2  := FloatToStr(T1_Qty2);    ST1_Qty3  := FloatToStr(T1_Qty3);
 ST1_Qty4  := FloatToStr(T1_Qty4);    ST1_Qty5  := FloatToStr(T1_Qty5);    ST1_Qty6  := FloatToStr(T1_Qty6);
 ST1_Qty7  := FloatToStr(T1_Qty7);    ST1_Qty8  := FloatToStr(T1_Qty8);    ST1_Qty9  := FloatToStr(T1_Qty9);
 ST1_Qty10 := FloatToStr(T1_Qty10);   ST1_Qty11 := FloatToStr(T1_Qty11);   ST1_Qty12 := FloatToStr(T1_Qty12);
 ST1_Qty13 := FloatToStr(T1_Qty13);   ST1_Qty14 := FloatToStr(T1_Qty14);   ST1_Qty15 := FloatToStr(T1_Qty15);
 ST1_Qty16 := Format('%3.1f', [T1_Qty16]);

 ST2_Qty1  := FloatToStr(T2_Qty1);    ST2_Qty2  := FloatToStr(T2_Qty2);    ST2_Qty3  := FloatToStr(T2_Qty3);
 ST2_Qty4  := FloatToStr(T2_Qty4);    ST2_Qty5  := FloatToStr(T2_Qty5);    ST2_Qty6  := FloatToStr(T2_Qty6);
 ST2_Qty7  := FloatToStr(T2_Qty7);    ST2_Qty8  := FloatToStr(T2_Qty8);    ST2_Qty9  := FloatToStr(T2_Qty9);
 ST2_Qty10 := FloatToStr(T2_Qty10);   ST2_Qty11 := FloatToStr(T2_Qty11);   ST2_Qty12 := FloatToStr(T2_Qty12);
 ST2_Qty13 := FloatToStr(T2_Qty13);   ST2_Qty14 := FloatToStr(T2_Qty14);   ST2_Qty15 := FloatToStr(T2_Qty15);
 ST2_Qty16 := Format('%3.1f', [T2_Qty16]);

 SS1_Qty1  := FloatToStr(S1_Qty1);    SS1_Qty2  := FloatToStr(S1_Qty2);    SS1_Qty3  := FloatToStr(S1_Qty3);
 SS1_Qty4  := FloatToStr(S1_Qty4);    SS1_Qty5  := FloatToStr(S1_Qty5);    SS1_Qty6  := FloatToStr(S1_Qty6);
 SS1_Qty7  := FloatToStr(S1_Qty7);    SS1_Qty8  := FloatToStr(S1_Qty8);    SS1_Qty9  := FloatToStr(S1_Qty9);
 SS1_Qty10 := FloatToStr(S1_Qty10);   SS1_Qty11 := FloatToStr(S1_Qty11);   SS1_Qty12 := FloatToStr(S1_Qty12);
 SS1_Qty13 := FloatToStr(S1_Qty13);   SS1_Qty14 := FloatToStr(S1_Qty14);   SS1_Qty15 := FloatToStr(S1_Qty15);
 SS1_Qty16 := Format('%3.1f', [S1_Qty16]);

 STT_Qty1  := FloatToStr(TT_Qty1);    STT_Qty2  := FloatToStr(TT_Qty2);    STT_Qty3  := FloatToStr(TT_Qty3);
 STT_Qty4  := FloatToStr(TT_Qty4);    STT_Qty5  := FloatToStr(TT_Qty5);    STT_Qty6  := FloatToStr(TT_Qty6);
 STT_Qty7  := FloatToStr(TT_Qty7);    STT_Qty8  := FloatToStr(TT_Qty8);    STT_Qty9  := FloatToStr(TT_Qty9);
 STT_Qty10 := FloatToStr(TT_Qty10);   STT_Qty11 := FloatToStr(TT_Qty11);   STT_Qty12 := FloatToStr(TT_Qty12);
 STT_Qty13 := FloatToStr(TT_Qty13);   STT_Qty14 := FloatToStr(TT_Qty14);   STT_Qty15 := FloatToStr(TT_Qty15);
 STT_Qty16 := Format('%3.1f', [TT_Qty16]);  

   Try
       var_sql := ' Insert Into T2MISTOK ';
       var_sql := var_sql  + ' (STOK_DATE,    STOK_T1QTY1,  STOK_T1QTY2,  STOK_T1QTY3,  STOK_T1QTY4,  ';
       var_sql := var_sql  + '  STOK_T1QTY5,  STOK_T1QTY6,  STOK_T1QTY7,  STOK_T1QTY8,  STOK_T1QTY9,  ';
       var_sql := var_sql  + '  STOK_T1QTY10, STOK_T1QTY11, STOK_T1QTY12, STOK_T1QTY13, STOK_T1QTY14, ';
       var_sql := var_sql  + '  STOK_T1QTY15, STOK_T1QTY16,    ';
       var_sql := var_sql  + '  STOK_T2QTY1,  STOK_T2QTY2,  STOK_T2QTY3,  STOK_T2QTY4,  STOK_T2QTY5,  ';
       var_sql := var_sql  + '  STOK_T2QTY6,  STOK_T2QTY7,  STOK_T2QTY8,  STOK_T2QTY9,  STOK_T2QTY10, ';
       var_sql := var_sql  + '  STOK_T2QTY11, STOK_T2QTY12, STOK_T2QTY13, STOK_T2QTY14, STOK_T2QTY15, ';
       var_sql := var_sql  + '  STOK_T2QTY16, ';
       var_sql := var_sql  + '  STOK_S1QTY1,  STOK_S1QTY2,  STOK_S1QTY3,  STOK_S1QTY4,  STOK_S1QTY5,  ';
       var_sql := var_sql  + '  STOK_S1QTY6,  STOK_S1QTY7,  STOK_S1QTY8,  STOK_S1QTY9,  STOK_S1QTY10, ';
       var_sql := var_sql  + '  STOK_S1QTY11, STOK_S1QTY12, STOK_S1QTY13, STOK_S1QTY14, STOK_S1QTY15, ';
       var_sql := var_sql  + '  STOK_S1QTY16, ';
       var_sql := var_sql  + '  STOK_TTQTY1,  STOK_TTQTY2,  STOK_TTQTY3,  STOK_TTQTY4, STOK_TTQTY5,   ';
       var_sql := var_sql  + '  STOK_TTQTY6,  STOK_TTQTY7,  STOK_TTQTY8,  STOK_TTQTY9, STOK_TTQTY10,  ';
       var_sql := var_sql  + '  STOK_TTQTY11, STOK_TTQTY12, STOK_TTQTY13, STOK_TTQTY14, STOK_TTQTY15, ';
       var_sql := var_sql  + '  STOK_TTQTY16  )';

       var_sql := var_sql  + ' Values('''+s_date+''',    '''+ST1_Qty1+''',  '''+ST1_Qty2+''',  '''+ST1_Qty3+''',  '''+ST1_Qty4+''',  ';
       var_sql := var_sql  + '        '''+ST1_Qty5+''',  '''+ST1_Qty6+''',  '''+ST1_Qty7+''',  '''+ST1_Qty8+''',  '''+ST1_Qty9+''',  ';
       var_sql := var_sql  + '        '''+ST1_Qty10+''', '''+ST1_Qty11+''', '''+ST1_Qty12+''', '''+ST1_Qty13+''', '''+ST1_Qty14+''', ';
       var_sql := var_sql  + '        '''+ST1_Qty15+''', '''+ST1_Qty16+''', ';
       var_sql := var_sql  + '        '''+ST2_Qty1+''',  '''+ST2_Qty2+''',  '''+ST2_Qty3+''',  '''+ST2_Qty4+''',  '''+ST2_Qty5+''',  ';
       var_sql := var_sql  + '        '''+ST2_Qty6+''',  '''+ST2_Qty7+''',  '''+ST2_Qty8+''',  '''+ST2_Qty9+''',  '''+ST2_Qty10+''', ';
       var_sql := var_sql  + '        '''+ST2_Qty11+''', '''+ST2_Qty12+''', '''+ST2_Qty13+''', '''+ST2_Qty14+''', '''+ST2_Qty15+''', ';
       var_sql := var_sql  + '        '''+ST2_Qty16+''', ';
       var_sql := var_sql  + '        '''+SS1_Qty1+''',  '''+SS1_Qty2+''',  '''+SS1_Qty3+''',  '''+SS1_Qty4+''',  '''+SS1_Qty5+''',  ';
       var_sql := var_sql  + '        '''+SS1_Qty6+''',  '''+SS1_Qty7+''',  '''+SS1_Qty8+''',  '''+SS1_Qty9+''',  '''+SS1_Qty10+''', ';
       var_sql := var_sql  + '        '''+SS1_Qty11+''', '''+SS1_Qty12+''', '''+SS1_Qty13+''', '''+SS1_Qty14+''', '''+SS1_Qty15+''', ';
       var_sql := var_sql  + '        '''+SS1_Qty16+''', ';
       var_sql := var_sql  + '        '''+STT_Qty1+''',  '''+STT_Qty2+''',  '''+STT_Qty3+''',  '''+STT_Qty4+''',  '''+STT_Qty5+''',  ';
       var_sql := var_sql  + '        '''+STT_Qty6+''',  '''+STT_Qty7+''',  '''+STT_Qty8+''',  '''+STT_Qty9+''',  '''+STT_Qty10+''', ';
       var_sql := var_sql  + '        '''+STT_Qty11+''', '''+STT_Qty12+''', '''+STT_Qty13+''', '''+STT_Qty14+''', '''+STT_Qty15+''', ';
       var_sql := var_sql  + '        '''+STT_Qty16+'''  )';


//       memo1.Lines.Add(var_sql);
       Query3.Close;
       Query3.SQL.Clear;
       Query3.SQL.Add(var_sql);
       Query3.ExecSql;

     Except
       Showmessage(var_sql);
     End;
end;

function TFrm_7100.IsDate(Str : String) : Boolean;
const   days: array[0..11] of Integer =(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var
   iyear,imm,idd : integer;
begin
   if length(Str) <> 8 then begin
     result := False;
     exit;
   end;
   iyear := StrtoInt(copy(Str,1,4));
   imm := StrtoInt(copy(Str,5,2));
   idd := StrtoInt(copy(Str,7,8));
//  현재년도가 윤년인지를 먼저 구해서 2월말일을 구한다.
//   if (iyear mod 4=0) and ((iyear mod 100>0) or (iyear mod 400=0)) then  days[1] := 29;

   if (imm > 0) and (imm < 13) then
     if (idd > 0) and (idd <= days[imm-1]) then
       result := True
     else
       result := False
   else
     result := False;
end;



procedure TFrm_7100.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_7100.FormDestroy(Sender: TObject);
begin
  Frm_7100 := Nil;
end;

procedure TFrm_7100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.

unit WinInpt;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     ComCtrls, StdCtrls, ExtCtrls, Db, DBTables, Winsock, Registry, Module;

     // 입고의 중복여부 확인
     Function WinInpt_ChkDbl( var_Query : TQuery; var_MRN, var_MSN, var_HSN  : String ) : Boolean;
     // 사고구분 RELOAD
     Function WinInpt_ReLoad_Trouble( var var_Query : TQuery ) : Boolean;
     // 포장종류 RELOAD
     Function WinInpt_ReLoad_PackCode( var_Query : TQuery ) : Boolean;
     // 반입명칭 RELOAD
     Function WinInpt_ReLoad_InOutCode( var_Query : TQuery ) : Boolean;

     Function WinInpt_Record_Miinpt_Insert( var_Query : TQuery ) : TMiINPUT;

     //------------------------------------------------------------------------------
     //
     //     반입 정보 Record 에 INSERT, UPDATE
     //
     //------------------------------------------------------------------------------
     Function WinInpt_Record_DB_Insert( var_Query : TQuery; var_miinpt : TMiINPUT ) : Boolean;
     // 반입 정보 Record 에 UPDATE
     Function WinInpt_Record_DB_Update( var_Query : TQuery; var_miinpt : TMiINPUT ) : Boolean;
     // var_Sel <== HBL, MBL, MRN 구분으로 조회하여 반입정보 RETURN
     Function WinInpt_Inpt_State( var_Query : TQuery; var_Sel, var_code : String ) : TMiINPUT;
     //

     //------------------------------------------------------------------------------
     //
     //     장치위치 반입 예약 함수 모음
     //
     //------------------------------------------------------------------------------
     // 해당장치에 대한 여유공간이 있는지을 체크한다
     Function WinLoc_MilChk_PreSpace_Check( var_Query : TQuery;
                                           var_Loc1, var_Loc2 : String;
                                           var_Qty, var_Weight, var_Cap : Double ) : TMilChk_State;

     // 해당 장치( Location )에 사용한 예상 수량 및 용량만큼을 + 하여준다
     Function WinLoc_MilChk_PreSpace_Plus( var_Query : TQuery;
                                           var_MilChk_State : TMilChk_State;
                                           var_Qty, var_Weight, var_Cap : String ) : Boolean;


     // 만약 예정등록에서 에러가 발생하였다면 반입정보에 저장위치를 빈공란으로
     // 만들어준다..다른 자료는 그대로 놓아둔다
     Function WinLoc_MilChk_PreSpace_Prev_Loc( var_Query : TQuery;
                                                MiINPUT_ETC : TMiINPUT_ETC ) : Boolean;

     // 장치위치 통계 테이블에서 예정정보(중량,수량) 값을 MINUS 하여준다
     Function WinLoc_Minus_Prev_Set( var_Query : TQuery;
                                     var_LOCA, INPT_INQTY, INPT_INWEIGHT : String ) : Boolean;

     // 기존에 예약 저장 위치값에서 새로운 값으로 계산하여 Update 하여준다 [ 수량,중량만 틀린경우 ]
     Function WinLoc_Change_Prev_PrdData( var_Query : TQuery;
                                        var_Loc,
                                        prev_Qty,      // 기존 수량
                                        prev_Weight,   // 기존 중량
                                        var_Qty,
                                        var_Weight : String ) : Boolean;

     // Location 이 틀린 경우
     Function WinLoc_Change_Prev_Data( var_Query : TQuery;
                                      var_Loc   : String;
                                      var_MiINPUT : TMiINPUT;
                                      var_Qty,
                                      var_Weight : String ) : Boolean;

     // 반입시에 저장 예약 위치에서 중량, 수량값을 MINUS 하여준다
     Function WinLoc_Plus_PrevLoc_Set( var_Query : TQuery;
                                       var_LOCA, INPT_INQTY, INPT_INWEIGHT : String ) : Boolean;

     //------------------------------------------------------------------------------
     //
     //     반입 상태 정보 ( 조회 / 변경 )
     //
     //------------------------------------------------------------------------------
     //  반입 상태 정보 변경
     Function WinLoc_Change_Flag_Update( var_Query : TQuery;
                                         var_MiINPUT : TMiINPUT;
                                         var_Flag  : String ) : Boolean;

     //------------------------------------------------------------------------------
     //
     //                            장치위치 - 반입확정
     //
     //------------------------------------------------------------------------------
     // 같은 장치 위치에서 수량과 중량만 틀린 경우
     Function WinLoc_Change_Loc_SetData( var_Query : TQuery;
                                          var_Loc   : String;
                                          var_MiINPUT : TMiINPUT;
                                          var_Qty,
                                          var_Weight : String ) : Boolean;

     // 반입확정 위치에서 예약위치와 다른 경우에 확정
     Function WinLoc_Change_Loc_Move_SetData(  var_Query : TQuery;
                                               var_Loc   : String;
                                               var_MiINPUT : TMiINPUT;
                                               var_Qty,
                                               var_Weight : String ) : Boolean;


     // 장치위치(MILSTK) 에 LIINPT 내용 그대로 복사하여 붙여넣고
     // 장치위치 및 입고일자 및 입고시간을 같이 등록 하여 준다
     Function WinLoc_Insert_MILSTK( var_Query : TQuery;
                                     var_MiINPUT : TMiINPUT ) : Boolean;

     // 반입시에 저장 확정 위치에서 중량, 수량값을 PLUS 하여준다
     Function WinLoc_PLUS_Use_Set( var_Query : TQuery;
                                    var_LOCA, INPT_INQTY, INPT_INWEIGHT : String ) : Boolean;

     // 반입시에 저장확정위치에서 중량, 수량값을 MINUS 하여준다
     Function WinLoc_Minus_Use_Set( var_Query : TQuery;
                                    var_LOCA, INPT_INQTY, INPT_INWEIGHT : String ) : Boolean;

     // 장치위치 정보에 대한 CLASS RETURN
     // [ 인자 ] var_Sel <== HBL, MBL 구분으로 조회한다
     // 조회의 일치는  TMiINPUT.INPT_ENTER 의 값에 -1, O, X 값으로 구분한다 ;
     Function WinLoc_LSTK_State( var_Query : TQuery;
                                 var_Sel, var_code : String ) : TMiLSTK;

     // 장치위치에 선택제품에 대한 정보을  TMiLSTK CLASS 에 저장하여 RETURN
     Function WinLoc_Record_MiLSTK_Insert( var_Query : TQuery ) : TMiLSTK;

     //------------------------------------------------------------------------------
     //
     //                           장치위치 관련함수
     //
     //------------------------------------------------------------------------------
     // 옮길 위치에 장치 위치가 사용 가능한 상태인지 파악한다
     //     1 : 비어있음 ( 기본값 ) / 2 : 저장가능 / 3 : FULL / 9 : 불량
     Function WinLoc_Location_LSTK_Status( var_Query : TQuery;
                                           var_Loc   : String ) : TMilChk;

     // 장치위치에 적재가 가능한지와 제품을 적재시에 기존 수량, 중량과 함하여
     // 범위가 초과가 되지 않은지를 조사한다
     Function WinLoc_Location_LSTK_Extent_Status( var_Query : TQuery;
                                                 var_Loc   : String;
                                                 var_Qty,
                                                 var_Weight : String ) : TMilChk;

     // ( 장치위치 확정된 제품 ) 장치위치 통계 테이블에서 사용 정보(중량,수량) 값을 MINUS 하여준다
     Function WinLoc_Minus_Location_Uses_Set( var_Query : TQuery;
                                               var_LOCA,
                                               USES_QTY,
                                               USES_WEIGHT : String ) : Boolean;

     // ( 장치위치 확정된 제품 ) 장치위치 통계 테이블에서 사용 정보(중량,수량) 값을 PLUS 하여준다
     Function WinLoc_Plus_Location_Uses_Set( var_Query : TQuery;
                                             var_LOCA,
                                             USES_QTY,
                                             USES_WEIGHT : String ) : Boolean;

     // ( 장치위치확정제품 )
     //  기존에 확정된 저장 위치값에서 새로운 값으로 계산하여 Update 하여준다 [ 수량 또는 중량만 틀린경우 ]
     Function WinLoc_Change_Location_Data( var_Query : TQuery;
                                            var_Loc,
                                            prev_Qty,      // 기존 수량
                                            prev_Weight,   // 기존 중량
                                            var_Qty,
                                            var_Weight : String ) : String;

     // ( 장치위치확정제품 )
     // Location 이 틀린 경우
     // 기존에 예약수량, 중량 삭제
     // 새로운 장치위치에 + 예약수량, 중량
     Function WinLoc_Change_Location_Change_Data( var_Query  : TQuery;
                                                  var_Loc    : String;
                                                  var_MiLSTK : TMiLSTK;
                                                  var_Qty,
                                                  var_Weight : String ) : String;

     //------------------------------------------------------------------------------
     //
     //                                   반출 정보
     //
     //------------------------------------------------------------------------------
     // 이미 반출 예약이나 반출 확정이 되어 있는지을 CHECK 한다
     // var_Sel <== HBL, MBL, MRN 구분으로 조회하여 반출정보 RETURN
     Function WinInpt_Oupt_State( var_Query : TQuery; var_Sel, var_code : String ) : TMiOUPUT;
     // 반출 Class 안에 저장한다
     Function WinInpt_Record_Mioupt_Insert( var_Query : TQuery ) : TMiOUPUT;

     // 반출 정보 Record 에 저장 ( FTP 다운로드 프로그램에서 사용 )
     Function WinOupt_Record_DB_Insert( var_Query : TQuery;
                                        var_mioupt : TMiOUPUT ) : Boolean;


     // 반출정보 Record 에 UpDATE
     Function WinOupt_Record_DB_UpDate( var_Query : TQuery; var_mioupt : TMiOUPUT ) : Boolean;

implementation

Uses WinLib, WinDB;

//==============================================================================
// 입고의 중복여부 확인
Function WinInpt_ChkDbl( var_Query : TQuery; var_MRN, var_MSN, var_HSN  : String ) : Boolean;
var
  var_Result : Boolean;
  var_sql : String;
Begin
  var_Result := False;

  var_Sql := 'select INPT_MRN from miinpt ';
  var_Sql := var_Sql + ' where INPT_MRN = :INPT_MRN';
  var_Sql := var_Sql + '   and INPT_MSN = :INPT_MSN';
  var_Sql := var_Sql + '   and INPT_HSN = :INPT_HSN';

  With var_Query Do Begin
      Try
        Close;
        Sql.Clear;
        Sql.Add( var_Sql );
        Prepare;
        ParamByName('INPT_MRN').AsString := var_MRN;
        ParamByName('INPT_MSN').AsString := var_MSN;
        ParamByName('INPT_HSN').AsString := var_HSN;
        Open;
        FetchAll;
        IF RecordCount > 0 Then var_Result := True;
      Except
        On E:Exception do
        begin
           WinLib_ErrorForm( '◀ 개발자에게 문의 ▶' + E.Message+'로 인한 에러');
           var_Result := False;
        end;
      End;
  End;

  Result := var_Result;
End;

//==============================================================================
// 사고구분 RELOAD
Function WinInpt_ReLoad_Trouble( var var_Query : TQuery ) : Boolean;
var
  var_Result : Boolean;
  var_sql : String;
Begin
  var_Sql := 'Select * from mitroublecode ';
  var_Sql := var_Sql + ' order by trd_name ';
  
  // 기본 SQL 문 실행
  var_Result := WinDB_SelectQuery( var_Query, var_Sql );

  Result := var_Result;
End;



//==============================================================================
// 포장종류 RELOAD
Function WinInpt_ReLoad_PackCode( var_Query : TQuery ) : Boolean;
var
  var_Result : Boolean;
  var_sql : String;
Begin
  var_Sql := 'select * ';
  var_Sql := var_Sql + ' from mipackcode ';
  var_Sql := var_Sql + ' order by pak_name ';

  // 기본 SQL 문 실행
  var_Result := WinDB_SelectQuery( var_Query, var_Sql );
  
  Result := var_Result;
End;

//==============================================================================
// 반입명칭 RELOAD
Function WinInpt_ReLoad_InOutCode( var_Query : TQuery ) : Boolean;
var
  var_Result : Boolean;
  var_sql : String;
Begin
  var_Sql := 'select * ';
  var_Sql := var_Sql + ' from miinoutcode ';
  var_Sql := var_Sql + ' order by inout_name ';

  var_Result := WinDB_SelectQuery( var_Query, var_Sql );

  Result := var_Result;
End;

//==============================================================================
// 반입 정보을  TMiINPUT CLASS 에 저장하여 RETURN
Function WinInpt_Record_Miinpt_Insert( var_Query : TQuery ) : TMiINPUT;
var
  var_MiINPUT : TMiINPUT;
begin
  With var_Query Do Begin
      With var_MiINPUT Do
      Begin
        INPT_YEAR     := Trim(FieldByName('INPT_YEAR').AsString);
        INPT_INDEX    := Trim(FieldByName('INPT_INDEX').AsString);
        INPT_SCODE    := Trim(FieldByName('INPT_SCODE').AsString);
        INPT_MRN      := Trim(FieldByName('INPT_MRN').AsString);
        INPT_MSN      := Trim(FieldByName('INPT_MSN').AsString);
        INPT_HSN      := Trim(FieldByName('INPT_HSN').AsString);
        INPT_GROUP    := Trim(FieldByName('INPT_GROUP').AsString);
        INPT_INDATE   := Trim(FieldByName('INPT_INDATE').AsString);
        INPT_HOUSE    := Trim(FieldByName('INPT_HOUSE').AsString);
        INPT_CUSTCODE := Trim(FieldByName('INPT_CUSTCODE').AsString);
        INPT_CUSTNAME := Trim(FieldByName('INPT_CUSTNAME').AsString);
        INPT_PRDCODE  := Trim(FieldByName('INPT_PRDCODE').AsString);
        INPT_PRDNAME  := Trim(FieldByName('INPT_PRDNAME').AsString);
        INPT_MBL      := Trim(FieldByName('INPT_MBL').AsString);
        INPT_HBL      := Trim(FieldByName('INPT_HBL').AsString);
        INPT_AIRNO      := Trim(FieldByName('INPT_AIRNO').AsString);
        INPT_IOCODE     := Trim(FieldByName('INPT_IOCODE').AsString);
        INPT_HFROM      := Trim(FieldByName('INPT_HFROM').AsString);
        INPT_HTO        := Trim(FieldByName('INPT_HTO').AsString);
        INPT_HLIC       := Trim(FieldByName('INPT_HLIC').AsString);
        INPT_HCOMPANY   := Trim(FieldByName('INPT_HCOMPANY').AsString);
        INPT_PAKCODE    := Trim(FieldByName('INPT_PAKCODE').AsString);
        INPT_TROCODE    := Trim(FieldByName('INPT_TROCODE').AsString);
        INPT_INQTY      := Trim(FieldByName('INPT_INQTY').AsString);
        INPT_OUTQTY     := Trim(FieldByName('INPT_OUTQTY').AsString);
        INPT_STOCKQTY   := Trim(FieldByName('INPT_STOCKQTY').AsString);
        INPT_INWEIGHT   := Trim(FieldByName('INPT_INWEIGHT').AsString);
        INPT_OUTWEIGHT  := Trim(FieldByName('INPT_OUTWEIGHT').AsString);
        INPT_STOCKWEIGHT := Trim(FieldByName('INPT_STOCKWEIGHT').AsString);
        INPT_INCAP    := Trim(FieldByName('INPT_INCAP').AsString);
        INPT_OUTCAP   := Trim(FieldByName('INPT_OUTCAP').AsString);
        INPT_STOCKCAP := Trim(FieldByName('INPT_STOCKCAP').AsString);
        INPT_LOCA     := Trim(FieldByName('INPT_LOCA').AsString);
        INPT_CHKDATE  := Trim(FieldByName('INPT_CHKDATE').AsString);
        INPT_CHKUSER  := Trim(FieldByName('INPT_CHKUSER').AsString);
        INPT_STO      := Trim(FieldByName('INPT_STO').AsString);
        INPT_STONO    := Trim(FieldByName('INPT_STONO').AsString);
        INPT_STODATE  := Trim(FieldByName('INPT_STODATE').AsString);
        INPT_CREMODE  := Trim(FieldByName('INPT_CREMODE').AsString);
        INPT_USERID   := Trim(FieldByName('INPT_USERID').AsString);
        INPT_USERPW   := Trim(FieldByName('INPT_USERPW').AsString);
        INPT_JOBDATE  := Trim(FieldByName('INPT_JOBDATE').AsString);
        INPT_PDANO    := Trim(FieldByName('INPT_PDANO').AsString);
        INPT_TRADE    := Trim(FieldByName('INPT_TRADE').AsString);
        INPT_FREIGHT  := Trim(FieldByName('INPT_FREIGHT').AsString);
        INPT_FLAG     := Trim(FieldByName('INPT_FLAG').AsString);
     End;
  End;
  
  Result := var_MiINPUT;
End;

//==============================================================================
// 반입 정보 Record 에 저장
Function WinInpt_Record_DB_Insert( var_Query : TQuery; var_miinpt : TMiINPUT ) : Boolean;
var
  var_Sql, var_Msg : String;
  var_Result : Boolean;
Begin
  var_Result := True;
  
  var_Sql := 'Insert into miinpt (';
  var_Sql := var_Sql + 'INPT_YEAR, INPT_INDEX, INPT_SCODE, INPT_MRN, INPT_MSN, INPT_HSN ';
  With var_miinpt Do Begin
      IF INPT_INDATE <> ''   Then var_Sql := var_Sql + ' ,INPT_HOUSE ';
      IF INPT_INDATE <> ''   Then var_Sql := var_Sql + ' ,INPT_INDATE ';
      IF INPT_CUSTCODE <> '' Then var_Sql := var_Sql + ' ,INPT_CUSTCODE ';
      IF INPT_CUSTNAME <> '' Then var_Sql := var_Sql + ' ,INPT_CUSTNAME ';
      IF INPT_PRDCODE <> ''  Then var_Sql := var_Sql + ' ,INPT_PRDCODE ';
      IF INPT_PRDNAME <> ''  Then var_Sql := var_Sql + ' ,INPT_PRDNAME ';
      IF INPT_MBL <> ''      Then var_Sql := var_Sql + ' ,INPT_MBL ';
      IF INPT_HBL <> ''      Then var_Sql := var_Sql + ' ,INPT_HBL ';
      IF INPT_AIRNO <> ''    Then var_Sql := var_Sql + ' ,INPT_AIRNO ';
      IF INPT_IOCODE <> ''   Then var_Sql := var_Sql + ' ,INPT_IOCODE ';
      IF INPT_TROCODE <> ''  Then var_Sql := var_Sql + ' ,INPT_TROCODE ';
      IF INPT_INQTY <> ''    Then var_Sql := var_Sql + ' ,INPT_INQTY ';
      IF INPT_OUTQTY <> ''   Then var_Sql := var_Sql + ' ,INPT_OUTQTY ';
      IF INPT_STOCKQTY <> '' Then var_Sql := var_Sql + ' ,INPT_STOCKQTY ';
      IF INPT_INCAP <> ''    Then var_Sql := var_Sql + ' ,INPT_INCAP ';
      IF INPT_OUTCAP <> ''   Then var_Sql := var_Sql + ' ,INPT_OUTCAP ';
      IF INPT_STOCKCAP <> '' Then var_Sql := var_Sql + ' ,INPT_STOCKCAP ';
      IF INPT_INWEIGHT <> '' Then var_Sql := var_Sql + ' ,INPT_INWEIGHT ';
      IF INPT_OUTWEIGHT <> ''   Then var_Sql := var_Sql + ' ,INPT_OUTWEIGHT ';
      IF INPT_STOCKWEIGHT <> '' Then var_Sql := var_Sql + ' ,INPT_STOCKWEIGHT ';
      IF INPT_GROUP <> ''    Then var_Sql := var_Sql + ' ,INPT_GROUP ';
      IF INPT_HFROM <> ''    Then var_Sql := var_Sql + ' ,INPT_HFROM ';
      IF INPT_HTO   <> ''    Then var_Sql := var_Sql + ' ,INPT_HTO ';
      IF INPT_HLIC  <> ''    Then var_Sql := var_Sql + ' ,INPT_HLIC ';
      IF INPT_HCOMPANY <> '' Then var_Sql := var_Sql + ' ,INPT_HCOMPANY ';
      IF INPT_PAKCODE <> ''  Then var_Sql := var_Sql + ' ,INPT_PAKCODE ';
      IF INPT_CHKDATE <> ''  Then var_Sql := var_Sql + ' ,INPT_CHKDATE ';
      IF INPT_CHKUSER <> ''  Then var_Sql := var_Sql + ' ,INPT_CHKUSER ';
      IF INPT_STO     <> ''  Then var_Sql := var_Sql + ' ,INPT_STO ';
      IF INPT_STONO <> ''    Then var_Sql := var_Sql + ' ,INPT_STONO ';
      IF INPT_STODATE <> ''  Then var_Sql := var_Sql + ' ,INPT_STODATE ';
      IF INPT_CREMODE <> ''  Then var_Sql := var_Sql + ' ,INPT_CREMODE ';
      IF INPT_USERID  <> ''  Then var_Sql := var_Sql + ' ,INPT_USERID ';
      IF INPT_USERPW  <> ''  Then var_Sql := var_Sql + ' ,INPT_USERPW ';
      IF INPT_JOBDATE <> ''  Then var_Sql := var_Sql + ' ,INPT_JOBDATE ';
      IF INPT_PDANO   <> ''  Then var_Sql := var_Sql + ' ,INPT_PDANO ';
      IF INPT_TRADE   <> ''  Then var_Sql := var_Sql + ' ,INPT_TRADE ';
      IF INPT_FREIGHT <> ''  Then var_Sql := var_Sql + ' ,INPT_FREIGHT ';
      IF INPT_LOCA <> ''     Then var_Sql := var_Sql + ' ,INPT_LOCA ';
  End;
  var_Sql := var_Sql + ' ,INPT_FLAG ';
  var_Sql := var_Sql + ' ) ';
  var_Sql := var_Sql + ' values (  ';
  var_Sql := var_Sql + '    :INPT_YEAR ';
  var_Sql := var_Sql + '   ,:INPT_INDEX ';
  var_Sql := var_Sql + '   ,:INPT_SCODE ';
  var_Sql := var_Sql + '   ,:INPT_MRN, :INPT_MSN, :INPT_HSN ';
  With var_miinpt Do Begin
      IF INPT_INDATE <> ''   Then var_Sql := var_Sql + ' ,:INPT_HOUSE ';
      IF INPT_INDATE <> ''   Then var_Sql := var_Sql + ' ,:INPT_INDATE ';
      IF INPT_CUSTCODE <> '' Then var_Sql := var_Sql + ' ,:INPT_CUSTCODE ';
      IF INPT_CUSTNAME <> '' Then var_Sql := var_Sql + ' ,:INPT_CUSTNAME ';
      IF INPT_PRDCODE <> ''  Then var_Sql := var_Sql + ' ,:INPT_PRDCODE ';
      IF INPT_PRDNAME <> ''  Then var_Sql := var_Sql + ' ,:INPT_PRDNAME ';
      IF INPT_MBL <> ''      Then var_Sql := var_Sql + ' ,:INPT_MBL ';
      IF INPT_HBL <> ''      Then var_Sql := var_Sql + ' ,:INPT_HBL ';
      IF INPT_AIRNO <> ''    Then var_Sql := var_Sql + ' ,:INPT_AIRNO ';
      IF INPT_IOCODE <> ''   Then var_Sql := var_Sql + ' ,:INPT_IOCODE ';
      IF INPT_TROCODE <> ''  Then var_Sql := var_Sql + ' ,:INPT_TROCODE ';
      IF INPT_INQTY <> ''    Then var_Sql := var_Sql + ' ,:INPT_INQTY ';
      IF INPT_OUTQTY <> ''   Then var_Sql := var_Sql + ' ,:INPT_OUTQTY ';
      IF INPT_STOCKQTY <> '' Then var_Sql := var_Sql + ' ,:INPT_STOCKQTY ';
      IF INPT_INCAP <> ''    Then var_Sql := var_Sql + ' ,:INPT_INCAP ';
      IF INPT_OUTCAP <> ''   Then var_Sql := var_Sql + ' ,:INPT_OUTCAP ';
      IF INPT_STOCKCAP <> '' Then var_Sql := var_Sql + ' ,:INPT_STOCKCAP ';
      IF INPT_INWEIGHT <> ''    Then var_Sql := var_Sql + ' ,:INPT_INWEIGHT ';
      IF INPT_OUTWEIGHT <> ''   Then var_Sql := var_Sql + ' ,:INPT_OUTWEIGHT ';
      IF INPT_STOCKWEIGHT <> '' Then var_Sql := var_Sql + ' ,:INPT_STOCKWEIGHT ';
      IF INPT_GROUP <> ''    Then var_Sql := var_Sql + ' ,:INPT_GROUP ';
      IF INPT_HFROM <> ''    Then var_Sql := var_Sql + ' ,:INPT_HFROM ';
      IF INPT_HTO   <> ''    Then var_Sql := var_Sql + ' ,:INPT_HTO ';
      IF INPT_HLIC  <> ''    Then var_Sql := var_Sql + ' ,:INPT_HLIC ';
      IF INPT_HCOMPANY <> '' Then var_Sql := var_Sql + ' ,:INPT_HCOMPANY ';
      IF INPT_PAKCODE <> ''  Then var_Sql := var_Sql + ' ,:INPT_PAKCODE ';
      IF INPT_CHKDATE <> ''  Then var_Sql := var_Sql + ' ,:INPT_CHKDATE ';
      IF INPT_CHKUSER <> ''  Then var_Sql := var_Sql + ' ,:INPT_CHKUSER ';
      IF INPT_STO     <> ''  Then var_Sql := var_Sql + ' ,:INPT_STO ';
      IF INPT_STONO <> ''    Then var_Sql := var_Sql + ' ,:INPT_STONO ';
      IF INPT_STODATE <> ''  Then var_Sql := var_Sql + ' ,:INPT_STODATE ';
      IF INPT_CREMODE <> ''  Then var_Sql := var_Sql + ' ,:INPT_CREMODE ';
      IF INPT_USERID  <> ''  Then var_Sql := var_Sql + ' ,:INPT_USERID ';
      IF INPT_USERPW  <> ''  Then var_Sql := var_Sql + ' ,:INPT_USERPW ';
      IF INPT_JOBDATE <> ''  Then var_Sql := var_Sql + ' ,:INPT_JOBDATE ';
      IF INPT_PDANO   <> ''  Then var_Sql := var_Sql + ' ,:INPT_PDANO ';
      IF INPT_TRADE   <> ''  Then var_Sql := var_Sql + ' ,:INPT_TRADE ';
      IF INPT_FREIGHT <> ''  Then var_Sql := var_Sql + ' ,:INPT_FREIGHT ';
      IF INPT_LOCA <> ''     Then var_Sql := var_Sql + ' ,:INPT_LOCA ';
  End;
  var_Sql := var_Sql + ' ,:INPT_FLAG ';
  var_Sql := var_Sql + ' ) ';

  Try
       With var_Query Do Begin
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          Prepare;
          With var_miinpt Do Begin
              ParamByName('INPT_YEAR').AsString        := Trim(INPT_YEAR);
              ParamByName('INPT_INDEX').AsString       := Trim(INPT_INDEX);
              ParamByName('INPT_MRN').AsString         := Trim(INPT_MRN);
              ParamByName('INPT_MSN').AsString         := Trim(INPT_MSN);
              ParamByName('INPT_HSN').AsString         := Trim(INPT_HSN);
              ParamByName('INPT_INDATE').AsString      := Trim(INPT_INDATE);

              // 입항세관의 값이 비어 있다면
              IF Trim(INPT_HOUSE) = '' Then INPT_HOUSE := GLB_INPT_HOUSE;
              ParamByName('INPT_HOUSE').AsString       := Trim(INPT_HOUSE);
              
              ParamByName('INPT_CUSTCODE').AsString    := Trim(INPT_CUSTCODE);
              ParamByName('INPT_CUSTNAME').AsString    := Trim(INPT_CUSTNAME);
              ParamByName('INPT_PRDCODE').AsString     := Trim(INPT_PRDCODE);
              ParamByName('INPT_PRDNAME').AsString     := Trim(INPT_PRDNAME);
              ParamByName('INPT_MBL').AsString         := Trim(INPT_MBL);
              ParamByName('INPT_HBL').AsString         := Trim(INPT_HBL);
              ParamByName('INPT_AIRNO').AsString       := Trim(INPT_AIRNO);
              ParamByName('INPT_IOCODE').AsString      := Trim(INPT_IOCODE);
              ParamByName('INPT_TROCODE').AsString     := Trim(INPT_TROCODE);

              IF Trim(INPT_SCODE) = '' Then INPT_SCODE := GLB_SCODE;
              ParamByName('INPT_SCODE').AsString := Trim(INPT_SCODE);

              With var_miinpt Do Begin
                  IF INPT_INQTY <> ''    Then ParamByName('INPT_INQTY').AsString      := Trim(INPT_INQTY);
                  IF INPT_OUTQTY <> ''   Then ParamByName('INPT_OUTQTY').AsString     := Trim(INPT_OUTQTY);
                  IF INPT_STOCKQTY <> '' Then ParamByName('INPT_STOCKQTY').AsString   := Trim(INPT_STOCKQTY);
                  IF INPT_INCAP <> ''    Then ParamByName('INPT_INCAP').AsString         := Trim(INPT_INCAP);
                  IF INPT_OUTCAP <> ''   Then ParamByName('INPT_OUTCAP').AsString        := Trim(INPT_OUTCAP);
                  IF INPT_STOCKCAP <> '' Then ParamByName('INPT_STOCKCAP').AsString      := Trim(INPT_STOCKCAP);
                  IF INPT_INWEIGHT <> ''    Then ParamByName('INPT_INWEIGHT').AsFloat    := StrToFloat(INPT_INWEIGHT);
                  IF INPT_OUTWEIGHT <> ''   Then ParamByName('INPT_OUTWEIGHT').AsFloat   := StrToFloat(INPT_OUTWEIGHT);
                  IF INPT_STOCKWEIGHT <> '' Then ParamByName('INPT_STOCKWEIGHT').AsFloat := StrToFloat(INPT_STOCKWEIGHT);                  
                  IF INPT_GROUP <> ''    Then ParamByName('INPT_GROUP').AsString    := Trim(INPT_GROUP);
                  IF INPT_HFROM <> ''    Then ParamByName('INPT_HFROM').AsString    := Trim(INPT_HFROM);
                  IF INPT_HTO <> ''      Then ParamByName('INPT_HTO').AsString      := Trim(INPT_HTO);
                  IF INPT_HLIC <> ''     Then ParamByName('INPT_HLIC').AsString     := Trim(INPT_HLIC);
                  IF INPT_HCOMPANY <> '' Then ParamByName('INPT_HCOMPANY').AsString := Trim(INPT_HCOMPANY);
                  IF INPT_PAKCODE <> ''  Then ParamByName('INPT_PAKCODE').AsString  := Trim(INPT_PAKCODE);
                  IF INPT_CHKDATE <> ''  Then ParamByName('INPT_CHKDATE').AsString  := Trim(INPT_CHKDATE);
                  IF INPT_CHKUSER <> ''  Then ParamByName('INPT_CHKUSER').AsString  := Trim(INPT_CHKUSER);
                  IF INPT_STO <> ''      Then ParamByName('INPT_STO').AsString      := Trim(INPT_STO);
                  IF INPT_STONO <> ''    Then ParamByName('INPT_STONO').AsString    := Trim(INPT_STONO);
                  IF INPT_STODATE <> ''  Then ParamByName('INPT_STODATE').AsString  := Trim(INPT_STODATE);
                  IF INPT_CREMODE <> '' Then ParamByName('INPT_CREMODE').AsString   := Trim(INPT_CREMODE);
                  IF INPT_USERID <> ''  Then ParamByName('INPT_USERID').AsString    := Trim(INPT_USERID);
                  IF INPT_USERPW <> ''  Then ParamByName('INPT_USERPW').AsString    := Trim(INPT_USERPW);
                  IF INPT_JOBDATE <> '' Then ParamByName('INPT_JOBDATE').AsString   := Trim(INPT_JOBDATE);
                  IF INPT_PDANO <> ''   Then ParamByName('INPT_PDANO').AsString     := Trim(INPT_PDANO);
                  IF INPT_TRADE <> ''   Then ParamByName('INPT_TRADE').AsString     := Trim(INPT_TRADE);
                  IF INPT_FREIGHT <> '' Then ParamByName('INPT_FREIGHT').AsString   := Trim(INPT_FREIGHT);
                  IF INPT_LOCA <> ''    Then ParamByName('INPT_LOCA').AsString      := Trim(INPT_LOCA);
              End;
              ParamByName('INPT_FLAG').AsString     := INPT_FLAG;
              
              {*
              ParamByName('INPT_SENDDATE').AsString :=   ;
              ParamByName('INPT_SENDTIME').AsString :=   ;
              *}
          End;

          ExecSql;
        End;
   Except
        On E:Exception do
        begin
              if pos('Key violation', E.Message) > 0 then begin
                    var_Msg := 'YEAR : ' + var_miinpt.INPT_YEAR + ' / INDEX' + var_miinpt.INPT_INDEX;
                    WinLib_ErrorForm( var_Msg + ' 이미 입력하신 자료가 존재합니다');
                    var_Result := False;
              End
              else if pos('Update failed', E.Message) > 0 then Begin
                    WinLib_ErrorForm('데이타 베이스에 저장 실패..네트워크가 이상이 없는지 확인하여 주세요!');
                    var_Result := False;
              end
              else begin
                    WinLib_ErrorForm( E.Message+' 로 인한 에러');
                    var_Result := False;
              End;
        end;
   End;

   Result := var_Result;
End;

//------------------------------------------------------------------------------
// 반입 정보 Record 에 UPDATE
Function WinInpt_Record_DB_Update( var_Query  : TQuery;
                                   var_miinpt : TMiINPUT ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
Begin
  var_Result := true;
  
  With var_miinpt Do
  Begin
      var_Sql := 'update miinpt set ';
      {*
      var_Sql := var_Sql + '  INPT_GROUP    = ' + '''' + Trim(INPT_GROUP) + '''';
      var_Sql := var_Sql + ' ,INPT_INDATE   = ' + '''' + Trim(INPT_INDATE) + '''';
      var_Sql := var_Sql + ' ,INPT_HOUSE    = ' + '''' + Trim(INPT_HOUSE) + '''';
      var_Sql := var_Sql + ' ,INPT_CUSTCODE = ' + '''' + Trim(INPT_CUSTCODE) + '''';
      var_Sql := var_Sql + ' ,INPT_CUSTNAME = ' + '''' + Trim(INPT_CUSTNAME) + '''';
      var_Sql := var_Sql + ' ,INPT_PRDCODE  = ' + '''' + Trim(INPT_PRDCODE) + '''';
      var_Sql := var_Sql + ' ,INPT_PRDNAME  = ' + '''' + Trim(INPT_PRDNAME) + '''';
      var_Sql := var_Sql + ' ,INPT_MBL      = ' + '''' + Trim(INPT_MBL) + '''';
      var_Sql := var_Sql + ' ,INPT_HBL      = ' + '''' + Trim(INPT_HBL) + '''';
      var_Sql := var_Sql + ' ,INPT_AIRNO    = ' + '''' + Trim(INPT_AIRNO) + '''';
      var_Sql := var_Sql + ' ,INPT_IOCODE   = ' + '''' + Trim(INPT_IOCODE) + '''';
      var_Sql := var_Sql + ' ,INPT_HFROM    = ' + '''' + Trim(INPT_HFROM) + '''';
      var_Sql := var_Sql + ' ,INPT_HTO      = ' + '''' + Trim(INPT_HTO) + '''';
      var_Sql := var_Sql + ' ,INPT_HLIC     = ' + '''' + Trim(INPT_HLIC) + '''';
      var_Sql := var_Sql + ' ,INPT_HCOMPANY = ' + '''' + Trim(INPT_HCOMPANY) + '''';
      var_Sql := var_Sql + ' ,INPT_PAKCODE  = ' + '''' + Trim(INPT_PAKCODE) + '''';
      var_Sql := var_Sql + ' ,INPT_TROCODE  = ' + '''' + Trim(INPT_TROCODE) + '''';
      *}
      var_Sql := var_Sql + '  INPT_INQTY    = ' + '''' + Trim(INPT_INQTY) + '''';
      {*
      var_Sql := var_Sql + ' ,INPT_OUTQTY   = ' + '''' + Trim(INPT_OUTQTY) + '''';
      *}
      var_Sql := var_Sql + ' ,INPT_STOCKQTY = ' + '''' + Trim(INPT_STOCKQTY) + '''';
      var_Sql := var_Sql + ' ,INPT_INWEIGHT = ' + '''' + Trim(INPT_INWEIGHT) + '''';
      {*
      var_Sql := var_Sql + ' ,INPT_OUTWEIGHT   = ' + '''' + Trim(INPT_OUTWEIGHT) + '''';
      var_Sql := var_Sql + ' ,INPT_STOCKWEIGHT = ' + '''' + Trim(INPT_STOCKWEIGHT) + '''';
      var_Sql := var_Sql + ' ,INPT_INCAP    = ' + '''' + Trim(INPT_INCAP) + '''';
      var_Sql := var_Sql + ' ,INPT_OUTCAP   = ' + '''' + Trim(INPT_OUTCAP) + '''';
      var_Sql := var_Sql + ' ,INPT_STOCKCAP = ' + '''' + Trim(INPT_STOCKCAP) + '''';
      *}
      var_Sql := var_Sql + ' ,INPT_LOCA     = ' + '''' + Trim(INPT_LOCA) + '''';
      var_Sql := var_Sql + ' ,INPT_CHKDATE  = ' + '''' + Trim(INPT_CHKDATE) + '''';
      var_Sql := var_Sql + ' ,INPT_CHKUSER  = ' + '''' + Trim(INPT_CHKUSER) + '''';
      var_Sql := var_Sql + ' ,INPT_STO      = ' + '''' + Trim(INPT_STO) + '''';
      var_Sql := var_Sql + ' ,INPT_STONO    = ' + '''' + Trim(INPT_STONO) + '''';
      var_Sql := var_Sql + ' ,INPT_STODATE  = ' + '''' + Trim(INPT_STODATE) + '''';
      var_Sql := var_Sql + ' ,INPT_CREMODE  = ' + '''' + Trim(INPT_CREMODE) + '''';
      var_Sql := var_Sql + ' ,INPT_USERID   = ' + '''' + Trim(INPT_USERID) + '''';
      var_Sql := var_Sql + ' ,INPT_USERPW   = ' + '''' + Trim(INPT_USERPW) + '''';
      var_Sql := var_Sql + ' ,INPT_JOBDATE  = ' + '''' + Trim(INPT_JOBDATE) + '''';
      var_Sql := var_Sql + ' ,INPT_PDANO    = ' + '''' + Trim(INPT_PDANO) + '''';
      var_Sql := var_Sql + ' ,INPT_TRADE    = ' + '''' + Trim(INPT_TRADE) + '''';
      var_Sql := var_Sql + ' ,INPT_FREIGHT  = ' + '''' + Trim(INPT_FREIGHT) + '''';
      var_Sql := var_Sql + ' ,INPT_FLAG     = ' + '''' + Trim(INPT_FLAG) + '''';      

      var_Sql := var_Sql + ' where INPT_YEAR  = ' + '''' + Trim(INPT_YEAR) + '''';
      var_Sql := var_Sql + ' and   INPT_INDEX = ' + '''' + Trim(INPT_INDEX) + '''';
      var_Sql := var_Sql + ' and   INPT_SCODE = ' + '''' + Trim(INPT_SCODE) + '''';
      var_Sql := var_Sql + ' and   INPT_MRN   = ' + '''' + Trim(INPT_MRN) + '''';
      var_Sql := var_Sql + ' and   INPT_MSN   = ' + '''' + Trim(INPT_MSN) + '''';
      var_Sql := var_Sql + ' and   INPT_HSN   = ' + '''' + Trim(INPT_HSN) + '''';

      With var_Query Do
      Begin
       Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          ExecSql;
       Except
          On E:Exception do
          begin
               var_Result := False;
          end;
       End;
     End;

  End;  // MIINPT CLASS 의 끝
  
  Result := var_Result;
End;

//------------------------------------------------------------------------------
// 반출정보 Record 에 UpDATE
Function WinOupt_Record_DB_UpDate( var_Query  : TQuery;
                                   var_mioupt : TMiOUPUT ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
Begin
  var_Result := true;
  
  With var_mioupt Do
  Begin
      var_Sql := 'update mioupt set ';
      var_Sql := var_Sql + '  OUPT_INYEAR    = :OUPT_INYEAR';
      var_Sql := var_Sql + ' ,OUPT_ININDEX   = :OUPT_ININDEX';
      var_Sql := var_Sql + ' ,OUPT_GROUP     = :OUPT_GROUP';
      var_Sql := var_Sql + ' ,OUPT_OUTDATE   = :OUPT_OUTDATE';
      var_Sql := var_Sql + ' ,OUPT_JDATE     = :OUPT_JDATE';
      var_Sql := var_Sql + ' ,OUPT_CUSTCODE  = :OUPT_CUSTCODE';
      var_Sql := var_Sql + ' ,OUPT_CUSTNAME  = :OUPT_CUSTNAME';
      var_Sql := var_Sql + ' ,OUPT_CUSTJUMIN = :OUPT_CUSTJUMIN';
      var_Sql := var_Sql + ' ,OUPT_MBL       = :OUPT_MBL';
      var_Sql := var_Sql + ' ,OUPT_HBL       = :OUPT_HBL';
      var_Sql := var_Sql + ' ,OUPT_APNO      = :OUPT_APNO';
      var_Sql := var_Sql + ' ,OUPT_APDATE    = :OUPT_APDATE';
      var_Sql := var_Sql + ' ,OUPT_DECLAUSER = :OUPT_DECLAUSER';
      var_Sql := var_Sql + ' ,OUPT_IOCODE    = :OUPT_IOCODE';
      var_Sql := var_Sql + ' ,OUPT_TROCODE   = :OUPT_TROCODE';
      var_Sql := var_Sql + ' ,OUPT_QTY       = :OUPT_QTY';
      var_Sql := var_Sql + ' ,OUPT_WEIGHT    = :OUPT_WEIGHT';
      var_Sql := var_Sql + ' ,OUPT_PRDCODE   = :OUPT_PRDCODE';
      var_Sql := var_Sql + ' ,OUPT_CHKINSUR  = :OUPT_CHKINSUR';
      var_Sql := var_Sql + ' ,OUPT_SANGCHA   = :OUPT_SANGCHA';
      var_Sql := var_Sql + ' ,OUPT_RMONEY    = :OUPT_RMONEY';
      var_Sql := var_Sql + ' ,OUPT_GMONEY    = :OUPT_GMONEY';
      var_Sql := var_Sql + ' ,OUPT_DMONEY    = :OUPT_DMONEY';
      var_Sql := var_Sql + ' ,OUPT_JMONEY    = :OUPT_JMONEY';
      var_Sql := var_Sql + ' ,OUPT_IMONEY    = :OUPT_IMONEY';
      var_Sql := var_Sql + ' ,OUPT_AMONEY    = :OUPT_AMONEY';
      var_Sql := var_Sql + ' ,OUPT_TMONEY    = :OUPT_TMONEY';
      var_Sql := var_Sql + ' ,OUPT_CREMODE   = :OUPT_CREMODE';
      var_Sql := var_Sql + ' ,OUPT_USERID    = :OUPT_USERID';
      var_Sql := var_Sql + ' ,OUPT_USERPW    = :OUPT_USERPW';
      var_Sql := var_Sql + ' ,OUPT_JOBDATE   = :OUPT_JOBDATE';
      var_Sql := var_Sql + ' ,OUPT_PDANO     = :OUPT_PDANO';
      var_Sql := var_Sql + ' ,OUPT_FLAG      = :OUPT_FLAG';      
      var_Sql := var_Sql + ' where OUPT_YEAR  = :OUPT_YEAR';
      var_Sql := var_Sql + ' and   OUPT_INDEX = :OUPT_INDEX';
      var_Sql := var_Sql + ' and   OUPT_SCODE = :OUPT_SCODE';
      
      With var_Query Do
      Begin
       Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          Prepare;

          ParamByName('OUPT_INYEAR').AsString    := Trim( OUPT_INYEAR );
          ParamByName('OUPT_ININDEX').AsString   := Trim( OUPT_ININDEX );
          ParamByName('OUPT_GROUP').AsString     := Trim( OUPT_GROUP );
          ParamByName('OUPT_OUTDATE').AsString   := Trim( OUPT_OUTDATE );
          ParamByName('OUPT_JDATE').AsString     := Trim( OUPT_JDATE );
          ParamByName('OUPT_CUSTCODE').AsString  := Trim( OUPT_CUSTCODE );
          ParamByName('OUPT_CUSTNAME').AsString  := Trim( OUPT_CUSTNAME );
          ParamByName('OUPT_CUSTJUMIN').AsString := Trim( OUPT_CUSTJUMIN );
          ParamByName('OUPT_MBL').AsString       := Trim( OUPT_MBL );
          ParamByName('OUPT_HBL').AsString       := Trim( OUPT_HBL );
          ParamByName('OUPT_APNO').AsString      := Trim( OUPT_APNO );
          ParamByName('OUPT_APDATE').AsString    := Trim( OUPT_APDATE );
          ParamByName('OUPT_DECLAUSER').AsString := Trim( OUPT_DECLAUSER );
          ParamByName('OUPT_IOCODE').AsString    := Trim( OUPT_IOCODE );
          ParamByName('OUPT_TROCODE').AsString   := Trim( OUPT_TROCODE );
          ParamByName('OUPT_QTY').AsString       := Trim( OUPT_QTY );
          ParamByName('OUPT_WEIGHT').AsString    := Trim( OUPT_WEIGHT );
          ParamByName('OUPT_PRDCODE').AsString   := Trim( OUPT_PRDCODE );
          ParamByName('OUPT_CHKINSUR').AsString  := Trim( OUPT_CHKINSUR );
          ParamByName('OUPT_SANGCHA').AsString   := Trim( OUPT_SANGCHA );

          ParamByName('OUPT_RMONEY').AsString    := Trim( OUPT_RMONEY );
          ParamByName('OUPT_GMONEY').AsString    := Trim( OUPT_GMONEY );
          ParamByName('OUPT_DMONEY').AsString    := Trim( OUPT_DMONEY );
          ParamByName('OUPT_JMONEY').AsString    := Trim( OUPT_JMONEY );
          ParamByName('OUPT_IMONEY').AsString    := Trim( OUPT_IMONEY );
          ParamByName('OUPT_AMONEY').AsString    := Trim( OUPT_AMONEY );
          ParamByName('OUPT_TMONEY').AsString    := Trim( OUPT_TMONEY );

          ParamByName('OUPT_CREMODE').AsString   := Trim( OUPT_CREMODE );
          ParamByName('OUPT_USERID').AsString    := Trim( OUPT_USERID );
          ParamByName('OUPT_USERPW').AsString    := Trim( OUPT_USERPW );
          ParamByName('OUPT_JOBDATE').AsString   := Trim( OUPT_JOBDATE );
          ParamByName('OUPT_PDANO').AsString     := Trim( OUPT_PDANO );
          ParamByName('OUPT_FLAG').AsString      := Trim( OUPT_FLAG );
          ParamByname('OUPT_YEAR').AsString      := Trim( OUPT_YEAR );
          ParamByname('OUPT_INDEX').AsString     := Trim( OUPT_INDEX );
          ParamByname('OUPT_SCODE').AsString     := Trim( OUPT_SCODE );
          
          ExecSql;
       Except
          On E:Exception do
          begin
               var_Result := False;
          end;
       End;
     End;

  End;  // MIOUPT CLASS 의 끝

  Result := var_Result;
End;        


//------------------------------------------------------------------------------
//
//         반입 정보 RETURN  ( 반입백업 테이블제외 : MMINPT 제외한것 ) 
//
//------------------------------------------------------------------------------
// [ 인자 ] var_Sel <== HBL, MBL 구분으로 조회한다
//
// 조회의 일치는  TMiINPUT.INPT_ENTER 의 값에 -1, O, X 값으로 구분한다 ;
Function WinInpt_Inpt_State( var_Query : TQuery;
                             var_Sel, var_code : String ) : TMiINPUT;
var
  var_Result : TMiINPUT;
  var_Sql : String;
Begin
  var_Sql := 'select * from miinpt';
  IF var_Sel = 'HBL' Then var_Sql := var_Sql + ' where INPT_HBL = ' + '''' + var_code + ''''
  Else IF var_Sel = 'MBL' Then var_Sql := var_Sql + ' where INPT_MBL = ' + '''' + var_code + '''';

  With var_Query Do
  Begin
    Try
       Close;
       Sql.Clear;
       Sql.Add( var_Sql );
       Open;
    Except
       var_Result.INPT_ENTER := 'X';
    End;
  End;

  IF var_Result.INPT_ENTER <> 'X' Then
  Begin
      // 기존 반입정보를 CLASS 에 저장
      var_Result := WinInpt_Record_Miinpt_Insert( var_Query );
      var_Result.INPT_ENTER := 'O';
  End;
  
  Result := var_Result;
End; 

//------------------------------------------------------------------------------
//
//                       장치위치 예약 함수모음
//
//------------------------------------------------------------------------------
// 해당장치에 대한 여유공간이 있는지을 체크한다
{*
    1) ZONE 영역안에 사용 가능하면서 여유공간이 있는 ZONE 를 구한다
    2) 중량이 넘치지 않은 영역을 구한다
    3) ZOne 영역안에 여유 공간이 없는 경우 바닥으로 내려간다   
*}
Function WinLoc_MilChk_PreSpace_Check( var_Query : TQuery;
                                       var_Loc1, var_Loc2 : String;
                                       var_Qty, var_Weight, var_Cap : Double ) : TMilChk_State;
var
  var_Sql : String;
  var_MilChk_State : TMilChk_State; 
//  Loc_State  : String;

//  var_Count : integer;
//  var_Loc_State_Value : Smallint;
  
  // 수량과 중량 체크 ( 0 : 용량 제한에 걸림, -1 : 중량 제한에 걸림, 1 : 예정 등록 가능  )
  Function Func_Loc_Calc( var_MAX_QTY,                          // 최대수량
                          var_MAX_Weight,                       // 최대중량
                          var_Qty,                              // 신청수량
                          var_Weight,                           // 신청중량
                          Uses_Qty,                             // 현재 사용된 수량
                          Uses_Weight,                          // 현재 사용된 중량
                          Field_Qty,                            // 현재 예정 수량
                          Field_Weight : Double ) : Smallint;   // 현재 예정 중량
  var
      var_Result : Smallint;
      var_Calc   : Double;
  Begin
      var_Result := 1;

      // 현재 예정중량 + 신청중량 + 현재 사용된 수량
      var_Calc := var_MAX_QTY - Field_Qty + var_Qty + Uses_Qty;
      IF ( var_Calc <= 0 ) Then
              var_Result := 0;

      IF var_Result > 0 Then
          // 중량 계산
          IF ( var_MAX_Weight - ( Field_Weight + var_Weight + Uses_Weight ) ) < 0 Then
                var_Result := -1;

      Result := var_Result;
  End;

Begin
  var_Sql := 'select * from ';
  var_Sql := var_Sql + '   ( Select LCHK_LOCA from milchk ';
  var_Sql := var_Sql + '     Where LCHK_CHKAPPLY = ' + '''' + 'Y' + '''';
  var_Sql := var_Sql + '       and LCHK_ZONE >= ' + '''' + var_Loc1 + '''';
  var_Sql := var_Sql + '       and LCHK_ZONE <= ' + '''' + var_Loc2 + '''';
  var_Sql := var_Sql + '       and ( LCHK_MAX_WEIGHT >= LCHK_USE_WEIGHT + ' + FloatToStr(var_Weight) + ' ) ';
  var_Sql := var_Sql + '       and LCHK_LV <> 0 ';
  var_Sql := var_Sql + '       and LCHK_BY <> 0 ';
  var_Sql := var_Sql + '     Order By LCHK_LOCA ';
  var_Sql := var_Sql + '   ) ';
  
  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          Open;
          FetchAll;

          // 여유공간이 있다면 
          IF RecordCount > 0 Then
          Begin
             With var_MilChk_State Do
             Begin
                Loc1_State := True;
                Loc1_Apply := True;
                Loc2_State := False;
             End;
          End
          Else
          Begin
             With var_MilChk_State Do
             Begin
                Loc1_State := False;
                Loc1_Apply := False;
                Loc2_State := False;
                Loc2_Apply := False;
                Loc1_Why   := -1;
                Loc2_Why   := -1;
             End;
          End;


          {*
          With var_MilChk_State Do Begin
            Loc1 := var_Loc1;   // 장치위치 -1
            Loc2 := var_Loc2;   // 장치위치 -2

            IF RecordCount > 0 Then Begin
                For var_Count := 0 To RecordCount-1 Do Begin
                     Rec_Check := True;

                     Loc_MAX_QTY    := FieldByName('LCHK_MAX_QTY').AsFloat;         // 쵀대한계수량
                     Loc_MAX_Weight := FieldByName('LCHK_MAX_WEIGHT').AsFloat;      // 쵀대한계중량
                     Loc_State      := FieldByName('LCHK_STATE').AsString;          // 현재 셀의 상태
                     Loc_Qty        := FieldByName('LCHK_USE_QTY').AsFloat;         // 사용 수량
                     Loc_Weight     := FieldByName('LCHK_USE_WEIGHT').AsFloat;      // 사용 중량
                     Loc_PRE_WEIGHT := FieldByName('LCHK_PRE_WEIGHT').AsFloat;      // 예약 중량
                     Loc_PRE_Qty    := FieldByName('LCHK_PRE_QTY').AsFloat;         // 예약 수량
                     Loc_Apply      := FieldByName('LCHK_CHKAPPLY').AsString;       // 제한 적용 여부  ( 'Y' : 제한함, 'N' : 제한안함 )

                     IF Loc_Apply = 'Y' Then Begin
                         // 실제 예약중량과 수량 계산
                         //  ( 0 : 용량 제한에 걸림, -1 : 중량 제한에 걸림, 1 : 예정 등록 가능  )
                         var_Loc_State_Value := Func_Loc_Calc( Loc_MAX_QTY, Loc_MAX_Weight, var_Qty, var_Weight, Loc_Qty, Loc_Weight, Loc_PRE_Qty, Loc_PRE_WEIGHT );
                         IF var_Loc_State_Value > 0 Then
                         Begin
                           IF var_Count = 0 Then Begin
                                var_MilChk_State.Loc1_State := True;
                                var_MilChk_State.Loc1_Apply := True;
                                var_MilChk_State.Loc2_State := False;
                                Break;
                           End
                           Else Begin
                                var_MilChk_State.Loc1_State := False;
                                var_MilChk_State.Loc2_State := True;
                                var_MilChk_State.Loc2_Apply := True;
                           End;
                         End
                         // 사용 못하게 된 사유 부분 저장
                         //    ( 0 : 용량 제한에 걸림, -1 : 중량 제한에 걸림, 1 : 예정 등록 가능  )
                         Else Begin
                           IF var_Count = 0 Then Begin
                                var_MilChk_State.Loc1_State := False;
                                var_MilChk_State.Loc1_Apply := False;
                                var_MilChk_State.Loc1_Why   := var_Loc_State_Value;
                           End
                           Else Begin
                                var_MilChk_State.Loc2_State := False;
                                var_MilChk_State.Loc2_Apply := False;
                                var_MilChk_State.Loc2_Why   := var_Loc_State_Value;
                           End;
                         End;
                     End
                     // 제한을 하지 않은경우
                     Else Begin
                           IF var_Count = 0 Then Begin
                                var_MilChk_State.Loc1_Apply := False;   // 제한 적용하지 않음
                                var_MilChk_State.Loc1_State := True;    
                                var_MilChk_State.Loc2_State := False;
                                Break;
                           End
                           Else Begin
                                var_MilChk_State.Loc1_State := False;   // 사용못함
                                var_MilChk_State.Loc2_Apply := False;   // 제한 적용하지 않음
                                var_MilChk_State.Loc2_State := True;    // 사용가능
                                Break;
                           End;
                     End;

                     Next;
                End;
            End
            Else Rec_Check := False;       // 저장장치가 2개다 존재하지 않음
          End;
          *}          
      Except
          On E:Exception do
          begin
             With var_MilChk_State Do Begin
               Rec_Err   := E.Message;
               Rec_Check := False;
             End;
          end;
      End;
  End;

  Result := var_MilChk_State;
End;

//------------------------------------------------------------------------------
// 해당 장치에 대한 예약 여유 공간에 사용한 만큼을 PLUS 하여준다
Function WinLoc_MilChk_PreSpace_Plus( var_Query : TQuery;
                                      var_MilChk_State : TMilChk_State;
                                      var_Qty, var_Weight, var_Cap : String ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;                                     
Begin
  var_Result := True;

  var_Sql := 'update milchk set ';
  var_Sql := var_Sql + '  LCHK_PRE_QTY = ' + var_Qty;
  var_Sql := var_Sql + ' ,LCHK_PRE_WEIGHT = ' + var_Weight;
  With var_MilChk_State Do Begin
     IF Loc1_State Then var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + Loc1 + ''''
     Else var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + Loc2 + '''';
  End;

  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          ExecSql;
      Except
          On E:Exception do
          begin
             With var_MilChk_State Do Begin
               var_Result := False;
             End;
          end;
      End;
  End;

  Result := var_Result;

End;

// 만약 예정등록에서 에러가 발생하였다면 반입정보에 저장위치를 빈공란으로
// 만들어준다..다른 자료는 그대로 놓아둔다  
Function WinLoc_MilChk_PreSpace_Prev_Loc( var_Query : TQuery;
                                          MiINPUT_ETC : TMiINPUT_ETC ) : Boolean;
var
  var_Result : Boolean;
  var_INPT_YEAR,
  var_INPT_SCODE,
  var_INPT_MRN,
  var_INPT_MSN,
  var_INPT_HSN,
  var_INPT_MBL,
  var_INPT_HBL : String;
  var_Sql : String;
Begin
  var_Result := true;
  
  With MiINPUT_ETC Do Begin
      var_INPT_YEAR   := INPT.INPT_YEAR;
      var_INPT_SCODE  := INPT.INPT_SCODE;
      var_INPT_MRN  := INPT.INPT_MRN;
      var_INPT_MSN  := INPT.INPT_MSN;
      var_INPT_HSN  := INPT.INPT_HSN;
      var_INPT_MBL  := INPT.INPT_MBL;
      var_INPT_HBL  := INPT.INPT_HBL;
  End;

  // 반입정보 (miinpt) DB 에 저장위치를 NULL 로 만들어준다
  var_Sql := 'update miinpt set ';
  var_Sql := var_Sql + ' INPT_LOCA is NULL ';
  var_Sql := var_Sql + ' where INPT_YEAR  =' + '''' + var_INPT_YEAR  + '''';
  var_Sql := var_Sql + ' and   INPT_SCODE =' + '''' + var_INPT_SCODE + '''';
  var_Sql := var_Sql + ' and   INPT_MRN   =' + '''' + var_INPT_MRN   + '''';
  var_Sql := var_Sql + ' and   INPT_MSN   =' + '''' + var_INPT_MSN   + '''';
  var_Sql := var_Sql + ' and   INPT_HSN   =' + '''' + var_INPT_HSN   + '''';
  var_Sql := var_Sql + ' and   INPT_MBL   =' + '''' + var_INPT_MBL   + '''';
  var_Sql := var_Sql + ' and   INPT_HBL   =' + '''' + var_INPT_HBL   + '''';

  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          ExecSql;
      Except
          On E:Exception do
          begin
               var_Result := False;
          end;
      End;
  End;

  Result := var_Result;
End;


//------------------------------------------------------------------------------
//
//  반입 상태 정보 ( 조회 / 변경 )
//
//------------------------------------------------------------------------------
//  상태 정보 변경
Function WinLoc_Change_Flag_Update( var_Query   : TQuery;
                                    var_MiINPUT : TMiINPUT;
                                    var_Flag    : String ) : Boolean;
var
    var_Sql : String;
    var_Result : Boolean;
Begin
    var_Result := True; 

    With var_MiINPUT Do
    Begin
      var_Sql := 'update miinpt Set ';
      var_Sql := var_Sql + ' INPT_FLAG = :INPT_FLAG ';
      var_Sql := var_Sql + ' where INPT_YEAR  = :INPT_YEAR';
      var_Sql := var_Sql + '   and INPT_INDEX = :INPT_INDEX';
      var_Sql := var_Sql + '   and INPT_MRN = :INPT_MRN';
      var_Sql := var_Sql + '   and INPT_MSN = :INPT_MSN';
      var_Sql := var_Sql + '   and INPT_HSN = :INPT_HSN';
      var_Sql := var_Sql + '   and INPT_HBL = :INPT_HBL';
      var_Sql := var_Sql + '   and INPT_MBL = :INPT_MBL';

      With var_Query Do Begin
          Try
            Close;
            Sql.Clear;
            Sql.Add( var_Sql );
            Prepare;
            ParamByName('INPT_FLAG').AsString := var_Flag;
            ParamByName('INPT_YEAR').AsString  := INPT_YEAR;
            ParamByName('INPT_INDEX').AsString := INPT_INDEX;
            ParamByName('INPT_MRN').AsString := INPT_MRN;
            ParamByName('INPT_MSN').AsString := INPT_MSN;
            ParamByName('INPT_HSN').AsString := INPT_HSN;
            ParamByName('INPT_HBL').AsString := INPT_HBL;
            ParamByName('INPT_MBL').AsString := INPT_MBL;
            ExecSql;
          Except
            On E:Exception do
            begin
               var_Result := False;
            end;
          End;
      End;
      
    End;
    
    Result := var_Result;
End;

//------------------------------------------------------------------------------
//
//                            장치위치 - 반입확정
//
//------------------------------------------------------------------------------

// 같은 장치 위치에서 수량과 중량만 틀린 경우 
Function WinLoc_Change_Loc_SetData( var_Query : TQuery;
                                    var_Loc   : String;
                                    var_MiINPUT : TMiINPUT;
                                    var_Qty,
                                    var_Weight : String ) : Boolean;
var
  var_Result : Boolean;
begin
  var_Result := True;
  
  // 장치위치 통계 테이블에서 예약정보(중량,수량) 값을 MINUS 하여준다
  IF WinLoc_Minus_Prev_Set( var_Query, var_Loc, var_MiINPUT.INPT_INQTY, var_MiINPUT.INPT_INWEIGHT ) Then Begin
       // 사용 하려고 하는 확정 수량, 중량에 PLUS 하여준다
       IF NOT WinLoc_PLUS_Use_Set( var_Query, var_Loc, var_Qty, var_Weight ) Then var_Result := False;
  End
  Else var_Result := False;

  Result := var_Result;
End;

// 반입확정 위치에서 예약위치와 다른 경우에 확정
Function WinLoc_Change_Loc_Move_SetData(  var_Query : TQuery;
                                          var_Loc   : String;
                                          var_MiINPUT : TMiINPUT;
                                          var_Qty,
                                          var_Weight : String ) : Boolean;
var
  var_Result: Boolean;
Begin
  var_Result := WinLoc_Change_Loc_SetData( var_Query, var_Loc, var_MiINPUT, var_Qty, var_Weight );
  Result := var_Result;
End;


// 반입시에 저장 확정 위치에서 중량, 수량값을 PLUS 하여준다
Function WinLoc_PLUS_Use_Set( var_Query : TQuery;
                              var_LOCA, INPT_INQTY, INPT_INWEIGHT : String ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
Begin
  var_Result := True;

  var_Sql := 'update milchk set ';
  var_Sql := var_Sql + '   LCHK_USE_QTY    = LCHK_USE_QTY + '    + INPT_INQTY;
  var_Sql := var_Sql + '  ,LCHK_USE_WEIGHT = LCHK_USE_WEIGHT + ' + INPT_INWEIGHT;
  var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_LOCA + '''';

  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          ExecSql;
      Except
          On E:Exception do
          begin
               var_Result := False;
          end;
      End;
  End;  

  Result := var_Result;
End;

// 반입시에 저장 확정 위치에서 중량, 수량값을 MINUS 하여준다
Function WinLoc_Minus_Use_Set( var_Query : TQuery;
                                var_LOCA, INPT_INQTY, INPT_INWEIGHT : String ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
Begin
  var_Result := True;

  var_Sql := 'update milchk set ';
  var_Sql := var_Sql + '   LCHK_USE_QTY    = LCHK_USE_QTY-'    + INPT_INQTY;
  var_Sql := var_Sql + '  ,LCHK_USE_WEIGHT = LCHK_USE_WEIGHT-' + INPT_INWEIGHT;
  var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_LOCA + '''';

  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          ExecSql;
      Except
          On E:Exception do
          begin
               var_Result := False;
          end;
      End;
  End;  

  Result := var_Result;
End;

// 장치위치(MILSTK) 에 LIINPT 내용 그대로 복사하여 붙여넣고
// 장치위치 및 입고일자 및 입고시간을 같이 등록 하여 준다 
Function WinLoc_Insert_MILSTK( var_Query : TQuery;
                               var_MiINPUT : TMiINPUT ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
Begin
  var_Result := True;

  var_Sql := var_Sql + 'insert into MILSTK      ';
  var_Sql := var_Sql + '  Select INPT_YEAR,     ';
  var_Sql := var_Sql + '         INPT_INDEX,    ';
  var_Sql := var_Sql + '         INPT_SCODE,    ';
  var_Sql := var_Sql + '         INPT_MRN,      ';
  var_Sql := var_Sql + '         INPT_MSN,      ';
  var_Sql := var_Sql + '         INPT_HSN,      ';
  var_Sql := var_Sql + '         INPT_GROUP,    ';
  var_Sql := var_Sql + '         to_char(sysdate,' + '''' + 'yyyymmddHH24miss' + '''' + '), ';  // 실제 반입일자로 변경하여 저장한다
  var_Sql := var_Sql + '         INPT_HOUSE,    ';
  var_Sql := var_Sql + '         INPT_CUSTCODE, ';
  var_Sql := var_Sql + '         INPT_CUSTNAME, ';
  var_Sql := var_Sql + '         INPT_PRDCODE,  ';
  var_Sql := var_Sql + '         INPT_PRDNAME,  ';
  var_Sql := var_Sql + '         INPT_MBL,      ';
  var_Sql := var_Sql + '         INPT_HBL,      ';
  var_Sql := var_Sql + '         INPT_AIRNO,    ';
  var_Sql := var_Sql + '         INPT_IOCODE,   ';
  var_Sql := var_Sql + '         INPT_HFROM,    ';
  var_Sql := var_Sql + '         INPT_HTO,      ';
  var_Sql := var_Sql + '         INPT_HLIC,     ';
  var_Sql := var_Sql + '         INPT_HCOMPANY, ';
  var_Sql := var_Sql + '         INPT_PAKCODE,  ';
  var_Sql := var_Sql + '         INPT_TROCODE,  ';
  var_Sql := var_Sql + '         INPT_INQTY,    ';
  var_Sql := var_Sql + '         INPT_OUTQTY,   ';
  var_Sql := var_Sql + '         INPT_STOCKQTY, ';
  var_Sql := var_Sql + '         INPT_INWEIGHT,    ';
  var_Sql := var_Sql + '         INPT_OUTWEIGHT,   ';
  var_Sql := var_Sql + '         INPT_STOCKWEIGHT, ';
  var_Sql := var_Sql + '         INPT_INCAP,       ';
  var_Sql := var_Sql + '         INPT_OUTCAP,      ';
  var_Sql := var_Sql + '         INPT_STOCKCAP,    ';
  var_Sql := var_Sql + '         INPT_LOCA,        ';
  var_Sql := var_Sql + '         INPT_CHKDATE,     ';
  var_Sql := var_Sql + '         INPT_CHKUSER,     ';
  var_Sql := var_Sql + '         INPT_STO,         ';
  var_Sql := var_Sql + '         INPT_STONO,       ';
  var_Sql := var_Sql + '         INPT_STODATE,     ';
  var_Sql := var_Sql + '         :INPT_CREMODE,    ';      // 데이타을 처음에 등록하는 경우이므로 (I) 로한다
  var_Sql := var_Sql + '         :INPT_USERID,     ';
  var_Sql := var_Sql + '         :INPT_USERPW,     ';
  var_Sql := var_Sql + '         :INPT_JOBDATE,    ';      // 저장 장치 위치에 저장한 일자 ( 장치 확정일자 )
  var_Sql := var_Sql + '         :INPT_PDANO,      ';
  var_Sql := var_Sql + '         INPT_TRADE,       ';
  var_Sql := var_Sql + '         INPT_FREIGHT,     ';
  var_Sql := var_Sql + '         INPT_FLAG,        ';
  var_Sql := var_Sql + '         :INPT_SENDDATE,   ';     // 입고일자
  var_Sql := var_Sql + '         :INPT_SENDTIME,   ';     // 입고시간
  var_Sql := var_Sql + '         ' + '''' + '0' + '''';   // 상태 FLAG
  var_Sql := var_Sql + ' from MIINPT ';
  With var_MiINPUT Do
  Begin
      var_Sql := var_Sql + ' where INPT_YEAR  = :INPT_YEAR';
      var_Sql := var_Sql + '   and INPT_INDEX = :INPT_INDEX';
      var_Sql := var_Sql + '   and INPT_MRN = :INPT_MRN';
      var_Sql := var_Sql + '   and INPT_MSN = :INPT_MSN';
      var_Sql := var_Sql + '   and INPT_HSN = :INPT_HSN';
      var_Sql := var_Sql + '   and INPT_HBL = :INPT_HBL';
      var_Sql := var_Sql + '   and INPT_MBL = :INPT_MBL';

      With var_Query Do Begin
          Try
            Close;
            Sql.Clear;
            Sql.Add( var_Sql );
            Prepare;

            ParamByName('INPT_CREMODE').AsString  := 'I';
            ParamByName('INPT_USERID').AsString   := INPT_USERID;
            ParamByName('INPT_USERPW').AsString   := INPT_USERPW;
            ParamByName('INPT_JOBDATE').AsString  := WinLib_DateOnlyStr(Now);
            ParamByName('INPT_PDANO').AsString    := INPT_PDANO;
            ParamByName('INPT_SENDDATE').AsString := WinLib_DateOnlyStr(Now);
            ParamByName('INPT_SENDTIME').AsString := WinLib_TimeOnlyStr(Now);
            
            ParamByName('INPT_YEAR').AsString   := INPT_YEAR;
            ParamByName('INPT_INDEX').AsString  := INPT_INDEX;
            ParamByName('INPT_MRN').AsString    := INPT_MRN;
            ParamByName('INPT_MSN').AsString    := INPT_MSN;
            ParamByName('INPT_HSN').AsString    := INPT_HSN;
            ParamByName('INPT_HBL').AsString    := INPT_HBL;
            ParamByName('INPT_MBL').AsString    := INPT_MBL;
            ExecSql;
          Except
            On E:Exception do
            begin
               var_Result := False;
            end;
          End;
      End;
  End;

  Result := var_Result;
End;                               


//------------------------------------------------------------------------------
//
//                           장치위치 ( 예약 )
//
//------------------------------------------------------------------------------
// ( 예약 ) 기존에 예약 저장 위치값에서 새로운 값으로 계산하여 Update 하여준다 [ 수량,중량만 틀린경우 ]
Function WinLoc_Change_Prev_PrdData( var_Query : TQuery;
                                  var_Loc,
                                  prev_Qty,      // 기존 수량
                                  prev_Weight,   // 기존 중량
                                  var_Qty,
                                  var_Weight : String ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
Begin
  var_Result := True;

  // 기존자료를 MINUX 하여 준다
  IF WinLoc_Minus_Prev_Set( var_Query, var_Loc, prev_Qty, prev_Weight ) Then
  Begin
      // 새로운 예정 수량, 중량을 더하여 준다
      var_Sql := 'update milchk set ';
      var_Sql := var_Sql + '   LCHK_PRE_QTY    = ' + '''' + var_Qty + '''';
      var_Sql := var_Sql + '  ,LCHK_PRE_WEIGHT = ' + '''' + var_Weight + '''';
      var_Sql := var_Sql + '   where LCHK_LOCA = ' + '''' + var_Loc + '''';
      With var_Query Do
      Begin
         Try
              Close;
              Sql.Clear;
              Sql.Add( var_Sql );
              ExecSql;
          Except
              On E:Exception do
              begin
                   var_Result := False;
              end;
          End;
      End;
  End
  Else var_Result := False;
  
  Result := var_Result;
End;


// ( 예약 )
// Location 이 틀린 경우
// 기존에 예약수량, 중량 삭제
// 새로운 장치위치에 + 예약수량, 중량
Function WinLoc_Change_Prev_Data( var_Query : TQuery;
                                  var_Loc   : String;
                                  var_MiINPUT : TMiINPUT;
                                  var_Qty,
                                  var_Weight : String ) : Boolean;
var
  var_Result : Boolean;
Begin
  var_Result := True;

  // 기존에 예약한 수량, 중량을 빼어준다
  IF WinLoc_Minus_Prev_Set( var_Query, var_MiINPUT.INPT_LOCA, var_MiINPUT.INPT_INQTY, var_MiINPUT.INPT_INWEIGHT ) Then
  Begin
      // 새로운 장치 위치에 예약 수량, 예약 중량을 더하여준다
      IF Not WinLoc_Plus_PrevLoc_Set( var_Query, var_Loc, var_Qty, var_Weight ) Then
               var_Result := False;
  End
  Else var_Result := False;

  Result := var_Result;
End;

// ( 예약 ) 장치위치 통계 테이블에서 예약정보(중량,수량) 값을 MINUS 하여준다
Function WinLoc_Minus_Prev_Set( var_Query : TQuery;
                                var_LOCA, INPT_INQTY, INPT_INWEIGHT : String ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
  var_LCHK_PRE_QTY, var_LCHK_PRE_WEIGHT, var_Calc : Double;
Begin
  var_Result := True;
  var_LCHK_PRE_QTY := 0;
  var_LCHK_PRE_WEIGHT := 0;

  // 예약정보 필드의 내용을 구하여 온다
  var_Sql := 'select LCHK_PRE_QTY, LCHK_PRE_WEIGHT from milchk ';
  var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_LOCA + '''';  
  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          Open;
          FetchAll;
          IF RecordCount > 0 Then
          Begin
             var_LCHK_PRE_QTY    := FieldByName('LCHK_PRE_QTY').AsFloat;
             var_LCHK_PRE_WEIGHT := FieldByName('LCHK_PRE_WEIGHT').AsFloat;
          End
          Else var_Result := False;
      Except
          On E:Exception do
          begin
               var_Result := False;
          end;
      End;
  End;

  IF var_Result Then
  Begin
     var_LCHK_PRE_QTY    := var_LCHK_PRE_QTY - StrtoFloat( INPT_INQTY );
     var_Calc := var_LCHK_PRE_WEIGHT - StrtoFloat( INPT_INWEIGHT );
     var_LCHK_PRE_WEIGHT := StrToFloat( FormatFloat('###0.00', var_Calc ) );

     // -  해 주었를때에 - 값이 아닌경우에만 장치위치 총괄정보에 UPDATE 하여주지 않는다
     IF ( ( var_LCHK_PRE_QTY >= 0 ) and ( var_LCHK_PRE_WEIGHT >= 0 ) ) Then
     Begin
          var_Sql := 'update milchk set ';
          var_Sql := var_Sql + '   LCHK_PRE_QTY    = ' + FloatToStr(var_LCHK_PRE_QTY);
          var_Sql := var_Sql + '  ,LCHK_PRE_WEIGHT = ' + FloatToStr(var_LCHK_PRE_WEIGHT);
          var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_LOCA + '''';
          With var_Query Do
          Begin
             Try
                  Close;
                  Sql.Clear;
                  Sql.Add( var_Sql );
                  ExecSql;
              Except
                  On E:Exception do
                  begin
                       var_Result := False;
                  end;
              End;
          End;
     End;
  End;

  Result := var_Result;
End;

// ( 예약 ) 반입시에 저장 예약 위치에서 중량, 수량값을 PLUS 하여준다
Function WinLoc_Plus_PrevLoc_Set( var_Query : TQuery;
                                var_LOCA, INPT_INQTY, INPT_INWEIGHT : String ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
Begin
  var_Result := True;

  var_Sql := 'update milchk set ';
  var_Sql := var_Sql + '   LCHK_PRE_QTY    = LCHK_USE_QTY + '    + INPT_INQTY;
  var_Sql := var_Sql + '  ,LCHK_PRE_WEIGHT = LCHK_USE_WEIGHT + ' + INPT_INWEIGHT;
  var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_LOCA + '''';

  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          ExecSql;
      Except
          On E:Exception do
          begin
               var_Result := False;
          end;
      End;
  End;  

  Result := var_Result;
End;

//------------------------------------------------------------------------------
//
//                     장치위치 정보에 대한 CLASS RETURN 
//
//------------------------------------------------------------------------------
// [ 인자 ] var_Sel <== HBL, MBL 구분으로 조회한다
//
// 조회의 일치는  TMiINPUT.INPT_ENTER 의 값에 -1, O, X 값으로 구분한다 ;
Function WinLoc_LSTK_State( var_Query : TQuery;
                             var_Sel, var_code : String ) : TMiLSTK;
var
  var_Result : TMiLSTK;
  var_Sql : String;
Begin
  var_Sql := 'select * from MILSTK';
  IF var_Sel = 'HBL' Then var_Sql := var_Sql + ' where LSTK_HBL = ' + '''' + var_code + ''''
  Else IF var_Sel = 'MBL' Then var_Sql := var_Sql + ' where LSTK_MBL = ' + '''' + var_code + '''';

  With var_Query Do
  Begin
    Try
       Close;
       Sql.Clear;
       Sql.Add( var_Sql );
       Open;
    Except
       var_Result.INPT.INPT_ENTER := 'X';
    End;
  End;

  IF var_Result.INPT.INPT_ENTER <> 'X' Then
  Begin
      // 기존 반입정보를 CLASS 에 저장
      var_Result := WinLoc_Record_MiLSTK_Insert( var_Query );
      var_Result.INPT.INPT_ENTER := 'O';
  End;
  
  Result := var_Result;
End;

// 장치위치에 선택제품에 대한 정보을 TMiLSTK CLASS 에 저장하여 RETURN
Function WinLoc_Record_MiLSTK_Insert( var_Query : TQuery ) : TMiLSTK;
var
  var_MiLSTK : TMiLSTK;
begin
  With var_Query Do
  Begin
      With var_MiLSTK.INPT Do
      Begin
        INPT_YEAR     := Trim(FieldByName('LSTK_YEAR').AsString);
        INPT_INDEX    := Trim(FieldByName('LSTK_INDEX').AsString);
        INPT_SCODE    := Trim(FieldByName('LSTK_SCODE').AsString);
        INPT_MRN      := Trim(FieldByName('LSTK_MRN').AsString);
        INPT_MSN      := Trim(FieldByName('LSTK_MSN').AsString);
        INPT_HSN      := Trim(FieldByName('LSTK_HSN').AsString);
        INPT_GROUP    := Trim(FieldByName('LSTK_GROUP').AsString);
        INPT_INDATE   := Trim(FieldByName('LSTK_INDATE').AsString);
        INPT_HOUSE    := Trim(FieldByName('LSTK_HOUSE').AsString);
        INPT_CUSTCODE := Trim(FieldByName('LSTK_CUSTCODE').AsString);
        INPT_CUSTNAME := Trim(FieldByName('LSTK_CUSTNAME').AsString);
        INPT_PRDCODE  := Trim(FieldByName('LSTK_PRDCODE').AsString);
        INPT_PRDNAME  := Trim(FieldByName('LSTK_PRDNAME').AsString);
        INPT_MBL      := Trim(FieldByName('LSTK_MBL').AsString);
        INPT_HBL      := Trim(FieldByName('LSTK_HBL').AsString);
        INPT_AIRNO      := Trim(FieldByName('LSTK_AIRNO').AsString);
        INPT_IOCODE     := Trim(FieldByName('LSTK_IOCODE').AsString);
        INPT_HFROM      := Trim(FieldByName('LSTK_HFROM').AsString);
        INPT_HTO        := Trim(FieldByName('LSTK_HTO').AsString);
        INPT_HLIC       := Trim(FieldByName('LSTK_HLIC').AsString);
        INPT_HCOMPANY   := Trim(FieldByName('LSTK_HCOMPANY').AsString);
        INPT_PAKCODE    := Trim(FieldByName('LSTK_PAKCODE').AsString);
        INPT_TROCODE    := Trim(FieldByName('LSTK_TROCODE').AsString);
        INPT_INQTY      := Trim(FieldByName('LSTK_INQTY').AsString);
        INPT_OUTQTY     := Trim(FieldByName('LSTK_OUTQTY').AsString);
        INPT_STOCKQTY   := Trim(FieldByName('LSTK_STOCKQTY').AsString);
        INPT_INWEIGHT   := Trim(FieldByName('LSTK_INWEIGHT').AsString);
        INPT_OUTWEIGHT  := Trim(FieldByName('LSTK_OUTWEIGHT').AsString);
        INPT_STOCKWEIGHT := Trim(FieldByName('LSTK_STOCKWEIGHT').AsString);
        INPT_INCAP       := Trim(FieldByName('LSTK_INCAP').AsString);
        INPT_OUTCAP      := Trim(FieldByName('LSTK_OUTCAP').AsString);
        INPT_STOCKCAP    := Trim(FieldByName('LSTK_STOCKCAP').AsString);
        INPT_LOCA        := Trim(FieldByName('LSTK_LOCA').AsString);
        INPT_CHKDATE     := Trim(FieldByName('LSTK_CHKDATE').AsString);
        INPT_CHKUSER     := Trim(FieldByName('LSTK_CHKUSER').AsString);
        INPT_STO         := Trim(FieldByName('LSTK_STO').AsString);
        INPT_STONO       := Trim(FieldByName('LSTK_STONO').AsString);
        INPT_STODATE     := Trim(FieldByName('LSTK_STODATE').AsString);
        INPT_CREMODE     := Trim(FieldByName('LSTK_CREMODE').AsString);
        INPT_USERID      := Trim(FieldByName('LSTK_USERID').AsString);
        INPT_USERPW      := Trim(FieldByName('LSTK_USERPW').AsString);
        INPT_JOBDATE     := Trim(FieldByName('LSTK_JOBDATE').AsString);
        INPT_PDANO       := Trim(FieldByName('LSTK_PDANO').AsString);
        INPT_TRADE       := Trim(FieldByName('LSTK_TRADE').AsString);
        INPT_FREIGHT     := Trim(FieldByName('LSTK_FREIGHT').AsString);
        INPT_FLAG        := Trim(FieldByName('LSTK_FLAG').AsString);
     End;
  End;
  
  Result := var_MiLSTK;
End;

//------------------------------------------------------------------------------
//
//                           장치위치 ( 확정된 제품 )
//
//------------------------------------------------------------------------------

// ( 장치위치 확정된 제품 ) 장치위치 통계 테이블에서 사용 정보(중량,수량) 값을 MINUS 하여준다
Function WinLoc_Minus_Location_Uses_Set( var_Query : TQuery;
                                         var_LOCA,
                                         USES_QTY,
                                         USES_WEIGHT : String ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
  var_LCHK_USE_QTY, var_LCHK_USE_WEIGHT, var_Calc : Double;
Begin
  var_Result := True;
  var_LCHK_USE_QTY := 0;
  var_LCHK_USE_WEIGHT := 0;

  // 예약정보 필드의 내용을 구하여 온다
  var_Sql := 'select LCHK_USE_QTY, LCHK_USE_WEIGHT from MILCHK ';
  var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_LOCA + '''';  
  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          Open;
          FetchAll;
          IF RecordCount > 0 Then
          Begin
             var_LCHK_USE_QTY    := FieldByName('LCHK_USE_QTY').AsFloat;
             var_LCHK_USE_WEIGHT := FieldByName('LCHK_USE_WEIGHT').AsFloat;
          End
          Else var_Result := False;
      Except
          On E:Exception do
          begin
               var_Result := False;
          end;
      End;
  End;

  IF var_Result Then
  Begin
     var_LCHK_USE_QTY    := var_LCHK_USE_QTY - StrtoFloat( USES_QTY );
     var_Calc := var_LCHK_USE_WEIGHT - StrtoFloat( USES_WEIGHT );
     var_LCHK_USE_WEIGHT := StrToFloat( FormatFloat('###0.00', var_Calc ) );

     // -  해 주었를때에 - 값이 아닌경우에만 장치위치 총괄정보에 UPDATE 하여주지 않는다
     IF ( ( var_LCHK_USE_QTY >= 0 ) and ( var_LCHK_USE_WEIGHT >= 0 ) ) Then
     Begin
          var_Sql := 'update milchk set ';
          var_Sql := var_Sql + '   LCHK_USE_QTY    = ' + FloatToStr(var_LCHK_USE_QTY);
          var_Sql := var_Sql + '  ,LCHK_USE_WEIGHT = ' + FloatToStr(var_LCHK_USE_WEIGHT);
          var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_LOCA + '''';
          With var_Query Do
          Begin
             Try
                  Close;
                  Sql.Clear;
                  Sql.Add( var_Sql );
                  ExecSql;
              Except
                  On E:Exception do
                  begin
                       var_Result := False;
                  end;
              End;
          End;
     End;
  End;

  Result := var_Result;
End;

// ( 장치위치 확정된 제품 ) 장치위치 통계 테이블에서 사용 정보(중량,수량) 값을 PLUS 하여준다
Function WinLoc_Plus_Location_Uses_Set( var_Query : TQuery;
                                        var_LOCA,
                                        USES_QTY,
                                        USES_WEIGHT : String ) : Boolean;
var
  var_Result : Boolean;
  var_Sql : String;
Begin
  var_Result := True;

  // 새로운 예정 수량, 중량을 더하여 준다
  var_Sql := 'update milchk set ';
  var_Sql := var_Sql + '   LCHK_USE_QTY    = LCHK_USE_QTY +' + '''' + USES_QTY + '''';
  var_Sql := var_Sql + '  ,LCHK_USE_WEIGHT = LCHK_USE_WEIGHT +' + '''' + USES_WEIGHT + '''';
  var_Sql := var_Sql + '   where LCHK_LOCA = ' + '''' + var_LOCA + '''';
  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          ExecSql;
      Except
          On E:Exception do
          begin
               var_Result := False;
          end;
      End;
  End;

  Result := var_Result;
End;

// ( 장치위치확정제품 )
//  기존에 확정된 저장 위치값에서 새로운 값으로 계산하여 Update 하여준다 [ 수량 또는 중량만 틀린경우 ]
Function WinLoc_Change_Location_Data( var_Query : TQuery;
                                      var_Loc,
                                      prev_Qty,      // 기존 수량
                                      prev_Weight,   // 기존 중량
                                      var_Qty,
                                      var_Weight : String ) : String;
var
  var_Result : String;
  var_MilChk : TMilChk;
  va_Calc_Qty, va_Calc_Weight : Double; 
Begin
  va_Calc_Qty    := StrToFloat(var_Qty) - StrToFloat(prev_Qty);
  va_Calc_Weight := StrToFloat(var_Weight) - StrToFloat(prev_Weight);
  va_Calc_Weight := StrToFloat( FormatFloat('###0.00', va_Calc_Weight ) );

  // 기존 장치 위치에 수량과 중량이 넘치지 않는가를 조회한다
  // 옮길 위치에 장치위치가 사용 가능한 상태인지 파악한다
  var_MilChk := WinLoc_Location_LSTK_Extent_Status( var_Query, var_Loc, FloatToStr(va_Calc_Qty), FloatToStr(va_Calc_Weight) );
  With var_MilChk Do
  begin

{*
(case
 WHEN lchk_state = '0' THEN '비어있음'
 WHEN lchk_state = '1' THEN '물건존재'
 WHEN lchk_state = 'N' THEN '금지'
end) AS bg_lchk_state,
*}

      IF ( STATE = 'N' ) Then var_Result := '금지'
//      Else IF ( STATE = '9' ) Then var_Result := '불량'
      Else IF ( STATE = 'X' ) Then var_Result := '장치위치없음'
      Else IF ( STATE = 'E' ) Then var_Result := '장치위치조회중에러'
      Else var_Result := 'OK';   // 값이 N (제한 사용안함) 인경우
  End;



  
  // 옮길 장치 위치 사용가능
  IF var_Result = 'OK' Then
  Begin
        // 기존 자료를 MINUS 하여 준다
        IF WinLoc_Minus_Location_Uses_Set( var_Query, var_Loc, prev_Qty, prev_Weight ) Then
        Begin
           IF Not WinLoc_Plus_Location_Uses_Set( var_Query,
                                                 var_Loc,
                                                 var_Qty,
                                                 var_Weight ) Then
           Begin
              var_Result := '장치통계-제품에대한수량중량변경중에러';
           End;
        End
        Else var_Result := '장치통계-수량및중량정보 삭제중 에러';
  End;

  Result := var_Result;
End;


// ( 장치위치확정제품 )
// Location 이 틀린 경우
// 기존에 예약수량, 중량 삭제
// 새로운 장치위치에 + 예약수량, 중량
Function WinLoc_Change_Location_Change_Data( var_Query  : TQuery;
                                             var_Loc    : String;
                                             var_MiLSTK : TMiLSTK;
                                             var_Qty,
                                             var_Weight : String ) : String;
var
  var_Result : String;
  var_MilChk : TMilChk;
Begin
  // 옮길 위치에 장치위치가 사용 가능한 상태인지 파악한다
  var_MilChk := WinLoc_Location_LSTK_Extent_Status( var_Query, var_Loc, var_Qty, var_Weight );
  With var_MilChk Do
  begin
      IF ( STATE = 'N' ) Then      var_Result := '금지'
//      Else IF ( STATE = '9' ) Then var_Result := '불량'
      Else IF ( STATE = 'X' ) Then var_Result := '장치위치없음'
      Else IF ( STATE = 'E' ) Then var_Result := '장치위치조회중에러'
      Else var_Result := 'OK';   // 값이 2 거나 N (제한 사용안함) 인경우
  End;


{*
(case
 WHEN lchk_state = '0' THEN '비어있음'
 WHEN lchk_state = '1' THEN '물건존재'
 WHEN lchk_state = 'N' THEN '금지'
end) AS bg_lchk_state,
*}


  // 옮길 장치 위치 사용가능
  IF var_Result = 'OK' Then
  Begin
      // 기존에 사용한 수량, 중량을 빼어준다
      IF WinLoc_Minus_Location_Uses_Set( var_Query,
                                         var_MiLSTK.INPT.INPT_LOCA,
                                         var_MiLSTK.INPT.INPT_INQTY,
                                         var_MiLSTK.INPT.INPT_INWEIGHT ) Then
      Begin
         // 새로운 장치 위치에 예약 수량, 예약 중량을 더하여준다
         IF Not WinLoc_Plus_Location_Uses_Set( var_Query,
                                               var_Loc,
                                               var_Qty,
                                               var_Weight ) Then
         Begin
            var_Result := '장치위치통계수정중 에러';
         End;
      End
      Else var_Result := '기존통계 수량, 중량 정보에서 삭제중 에러';
  End;

  Result := var_Result;
End;


// 장치위치에 적재가 가능한지와 제품을 적재시에 기존 수량, 중량과 함하여
// 범위가 초과가 되지 않은지를 조사한다
Function WinLoc_Location_LSTK_Extent_Status( var_Query : TQuery;
                                             var_Loc   : String;
                                             var_Qty,
                                             var_Weight : String ) : TMilChk;
var
  var_Result : TMilChk;
  var_Sql    : String;
  var_State  : String;

  var_Loc_Max_Qty, var_Loc_Max_Weight,      // 최대 수량, 최대중량
  var_Loc_Qty, var_Loc_Weight, var_Calc : Double;
Begin
  var_Sql := 'select * from milchk ';
  var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_Loc + '''';
  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          Open;
          FetchAll;
          IF RecordCount > 0 Then
          Begin
              var_State := FieldByName('LCHK_CHKAPPLY').AsString;
              IF var_State = 'Y' Then       // 장치 제한 사용함
              Begin
                  var_State  := FieldByName('LCHK_STATE').AsString;

                  IF ( var_State = 'N' ) Then  // N : 사용금지
                      var_Result.STATE := var_State
                  Else
                  Begin
                      var_Loc_Max_Qty    := FieldByName('LCHK_MAX_QTY').AsFloat;
                      var_Loc_Max_Weight := FieldByName('LCHK_MAX_WEIGHT').AsFloat;
                      var_Loc_Qty        := FieldByName('LCHK_USE_QTY').AsFloat;
                      var_Loc_Weight     := FieldByName('LCHK_USE_WEIGHT').AsFloat;

                      var_Calc := var_Loc_Qty + StrToFloat(var_Qty);
                      IF var_Calc >= var_Loc_Max_Qty Then                          // 최대 수량 보다 크다면
                            var_Result.STATE := '3';

                      var_Calc := var_Loc_Weight + StrtoFloat( var_Weight );       // 최대 중량 보다 크다면
                      var_Calc := StrToFloat( FormatFloat('###0.00', var_Calc ) );
                      IF var_Calc >= var_Loc_Max_Weight Then
                            var_Result.STATE := '3';

                      IF var_Result.STATE <> '3' Then
                             var_State := '2';        // 장치 사용 가능
                  End;
              End
              Else var_State := 'N'          // 장치 제한 사용하지 않음
          End
          Else var_Result.STATE := 'X';     // 장치위치가 존재하지 않음
      Except
          On E:Exception do
          begin
             With var_Result Do
               STATE := 'E';
          end;
      End;
  End;

  Result := var_Result;
End;

// 장치위치에 적재가 가능한 상태인지의 조회
// 1 : 비어있음 ( 기본값 ) / 2 : 저장가능 / 3 : FULL / 9 : 불량
Function WinLoc_Location_LSTK_Status( var_Query : TQuery;
                                      var_Loc   : String ) : TMilChk;
var
  var_Result : TMilChk;
  var_Sql    : String;
Begin
  var_Sql := 'select * from milchk ';
  var_Sql := var_Sql + ' where LCHK_LOCA = ' + '''' + var_Loc + '''';
  With var_Query Do
  Begin
     Try
          Close;
          Sql.Clear;
          Sql.Add( var_Sql );
          Open;
          FetchAll;
          IF RecordCount > 0 Then var_Result.STATE := '2'
          Else var_Result.STATE := 'X';     // 장치위치가 존재하지 않음
      Except
          On E:Exception do
          begin
             With var_Result Do
               STATE := 'E';                // 장치 위치 조회 에러
          end;
      End;
  End;

  Result := var_Result;
End;


//------------------------------------------------------------------------------
//
//                                   반출 정보
//
//------------------------------------------------------------------------------
// [ 인자 ] var_Sel <== HBL, MBL 구분으로 조회한다
//
// 조회의 일치는  TMiINPUT.INPT_ENTER 의 값에 -1, O, X 값으로 구분한다 ;
Function WinInpt_Oupt_State( var_Query : TQuery;
                             var_Sel, var_code : String ) : TMiOUPUT;
var
  var_Result : TMiOUPUT;
  var_Sql : String;
Begin
  var_Sql := 'select * from miouptview';
  IF var_Sel = 'HBL' Then var_Sql := var_Sql + ' where OUPT_HBL = ' + '''' + var_code + ''''
  Else IF var_Sel = 'MBL' Then var_Sql := var_Sql + ' where OUPT_MBL = ' + '''' + var_code + '''';

  With var_Query Do
  Begin
    Try
       Close;
       Sql.Clear;
       Sql.Add( var_Sql );
       Open;
       Fetchall;
       IF RecordCount > 0 Then var_Result.OUPT_ENTER := '0'
       Else var_Result.OUPT_ENTER := '-1';  // 존재하지 않음
    Except
       var_Result.OUPT_ENTER := 'X';
    End;
  End;

  // 반출 Record 가 존재하는 경우에만 실행
  IF var_Result.OUPT_ENTER = '0' Then
  Begin
      // 기존 반출정보를 CLASS 에 저장
      var_Result := WinInpt_Record_Mioupt_Insert( var_Query );
      var_Result.OUPT_ENTER := '0';
  End;
  
  Result := var_Result;
End;

//==============================================================================
// 반출 정보을  TMiOUPT CLASS 에 저장하여 RETURN
Function WinInpt_Record_Mioupt_Insert( var_Query : TQuery ) : TMiOUPUT;
var
  var_MiOUPT : TMiOUPUT;
begin
  With var_Query Do Begin
      With var_MiOUPT Do
      Begin
        OUPT_SCODE         := Trim(FieldByName('OUPT_SCODE').AsString);
        OUPT_YEAR          := Trim(FieldByName('OUPT_YEAR').AsString);
        OUPT_INDEX         := Trim(FieldByName('OUPT_INDEX').AsString);
        OUPT_INYEAR        := Trim(FieldByName('OUPT_INYEAR').AsString);
        OUPT_ININDEX       := Trim(FieldByName('OUPT_ININDEX').AsString);
        OUPT_GROUP         := Trim(FieldByName('OUPT_GROUP').AsString);
        OUPT_OUTDATE       := Trim(FieldByName('OUPT_OUTDATE').AsString);
        OUPT_JDATE         := Trim(FieldByName('OUPT_JDATE').AsString);
        OUPT_CUSTCODE      := Trim(FieldByName('OUPT_CUSTCODE').AsString);
        OUPT_CUSTNAME      := Trim(FieldByName('OUPT_CUSTNAME').AsString);
        OUPT_CUSTJUMIN     := Trim(FieldByName('OUPT_CUSTJUMIN').AsString);
        OUPT_MBL           := Trim(FieldByName('OUPT_MBL').AsString);
        OUPT_HBL           := Trim(FieldByName('OUPT_HBL').AsString);
        OUPT_APNO          := Trim(FieldByName('OUPT_APNO').AsString);
        OUPT_APDATE        := Trim(FieldByName('OUPT_APDATE').AsString);
        OUPT_DECLAUSER     := Trim(FieldByName('OUPT_DECLAUSER').AsString);
        OUPT_IOCODE        := Trim(FieldByName('OUPT_IOCODE').AsString);
        OUPT_TROCODE       := Trim(FieldByName('OUPT_TROCODE').AsString);
        OUPT_QTY           := Trim(FieldByName('OUPT_QTY').AsString);
        OUPT_WEIGHT        := Trim(FieldByName('OUPT_WEIGHT').AsString);
        OUPT_PRDCODE       := Trim(FieldByName('OUPT_PRDCODE').AsString);
        OUPT_CHKINSUR      := Trim(FieldByName('OUPT_CHKINSUR').AsString);
        OUPT_SANGCHA       := Trim(FieldByName('OUPT_SANGCHA').AsString);
        OUPT_RMONEY        := Trim(FieldByName('OUPT_RMONEY').AsString);
        OUPT_GMONEY        := Trim(FieldByName('OUPT_GMONEY').AsString);
        OUPT_DMONEY        := Trim(FieldByName('OUPT_DMONEY').AsString);
        OUPT_JMONEY        := Trim(FieldByName('OUPT_JMONEY').AsString);
        OUPT_IMONEY        := Trim(FieldByName('OUPT_IMONEY').AsString);
        OUPT_AMONEY        := Trim(FieldByName('OUPT_AMONEY').AsString);
        OUPT_TMONEY        := Trim(FieldByName('OUPT_TMONEY').AsString);
        OUPT_CREMODE       := Trim(FieldByName('OUPT_CREMODE').AsString);
        OUPT_USERID        := Trim(FieldByName('OUPT_USERID').AsString);
        OUPT_USERPW        := Trim(FieldByName('OUPT_USERPW').AsString);
        OUPT_JOBDATE       := Trim(FieldByName('OUPT_JOBDATE').AsString);
        OUPT_PDANO         := Trim(FieldByName('OUPT_PDANO').AsString);
        OUPT_FLAG          := Trim(FieldByName('OUPT_FLAG').AsString);
        OUPT_SENDDATE      := Trim(FieldByName('OUPT_SENDDATE').AsString);
        OUPT_SENDTIME      := Trim(FieldByName('OUPT_SENDTIME').AsString);
     End;
  End;
  
  Result := var_MiOUPT;
End;


//==============================================================================
// 반출 정보 Record 에 저장 ( FTP 다운로드에서 사용합니다 )
Function WinOupt_Record_DB_Insert( var_Query : TQuery;
                                   var_mioupt : TMiOUPUT ) : Boolean;
var
  var_Sql : String;
  var_Result : Boolean;
Begin
  var_Result := True;

   // 실제로 Query 로 DB 에 저장한다
   With var_Query Do
   Begin
        var_Sql := 'insert into mioupt ( ';
        var_Sql := var_Sql + '        OUPT_YEAR,  ';
        var_Sql := var_Sql + '        OUPT_INDEX,  ';
        var_Sql := var_Sql + '        OUPT_SCODE,  ';
        var_Sql := var_Sql + '        OUPT_INYEAR,  ';
        var_Sql := var_Sql + '        OUPT_ININDEX,  ';
        var_Sql := var_Sql + '        OUPT_GROUP,  ';
        var_Sql := var_Sql + '        OUPT_OUTDATE,  ';
        var_Sql := var_Sql + '        OUPT_JDATE,  ';
        var_Sql := var_Sql + '        OUPT_CUSTCODE,  ';
        var_Sql := var_Sql + '        OUPT_CUSTNAME,  ';
        var_Sql := var_Sql + '        OUPT_CUSTJUMIN,  ';
        var_Sql := var_Sql + '        OUPT_MBL,  ';
        var_Sql := var_Sql + '        OUPT_HBL,  ';
        var_Sql := var_Sql + '        OUPT_APNO,  ';
        var_Sql := var_Sql + '        OUPT_APDATE,  ';
        var_Sql := var_Sql + '        OUPT_DECLAUSER,  ';
        var_Sql := var_Sql + '        OUPT_IOCODE,  ';
        var_Sql := var_Sql + '        OUPT_TROCODE,  ';
        var_Sql := var_Sql + '        OUPT_QTY,  ';
        var_Sql := var_Sql + '        OUPT_WEIGHT,  ';
        var_Sql := var_Sql + '        OUPT_PRDCODE,  ';
        var_Sql := var_Sql + '        OUPT_CHKINSUR,  ';
        var_Sql := var_Sql + '        OUPT_SANGCHA,  ';             
        var_Sql := var_Sql + '        OUPT_RMONEY,  ';
        var_Sql := var_Sql + '        OUPT_GMONEY,  ';
        var_Sql := var_Sql + '        OUPT_DMONEY,  ';
        var_Sql := var_Sql + '        OUPT_JMONEY,  ';
        var_Sql := var_Sql + '        OUPT_IMONEY,  ';
        var_Sql := var_Sql + '        OUPT_AMONEY,  ';
        var_Sql := var_Sql + '        OUPT_TMONEY,  ';
        var_Sql := var_Sql + '        OUPT_CREMODE,  ';
        var_Sql := var_Sql + '        OUPT_USERID,  ';
        var_Sql := var_Sql + '        OUPT_USERPW,  ';
        var_Sql := var_Sql + '        OUPT_JOBDATE,  ';
        var_Sql := var_Sql + '        OUPT_PDANO,  ';
        var_Sql := var_Sql + '        OUPT_FLAG,  ';
        var_Sql := var_Sql + '        OUPT_SENDDATE,  ';
        var_Sql := var_Sql + '        OUPT_SENDTIME  ';
        var_Sql := var_Sql + ' ) values ( ';
        var_Sql := var_Sql + '        :OUPT_YEAR,  ';
        var_Sql := var_Sql + '        :OUPT_INDEX,  ';
        var_Sql := var_Sql + '        :OUPT_SCODE,  ';
        var_Sql := var_Sql + '        :OUPT_INYEAR,  ';
        var_Sql := var_Sql + '        :OUPT_ININDEX,  ';
        var_Sql := var_Sql + '        :OUPT_GROUP,  ';
        var_Sql := var_Sql + '        :OUPT_OUTDATE,  ';
        var_Sql := var_Sql + '        :OUPT_JDATE,  ';
        var_Sql := var_Sql + '        :OUPT_CUSTCODE,  ';
        var_Sql := var_Sql + '        :OUPT_CUSTNAME,  ';
        var_Sql := var_Sql + '        :OUPT_CUSTJUMIN,  ';
        var_Sql := var_Sql + '        :OUPT_MBL,  ';
        var_Sql := var_Sql + '        :OUPT_HBL,  ';
        var_Sql := var_Sql + '        :OUPT_APNO,  ';
        var_Sql := var_Sql + '        :OUPT_APDATE,  ';
        var_Sql := var_Sql + '        :OUPT_DECLAUSER,  ';
        var_Sql := var_Sql + '        :OUPT_IOCODE,  ';
        var_Sql := var_Sql + '        :OUPT_TROCODE,  ';
        var_Sql := var_Sql + '        :OUPT_QTY,  ';
        var_Sql := var_Sql + '        :OUPT_WEIGHT,  ';
        var_Sql := var_Sql + '        :OUPT_PRDCODE,  ';
        var_Sql := var_Sql + '        :OUPT_CHKINSUR,  ';
        var_Sql := var_Sql + '        :OUPT_SANGCHA,  ';           
        var_Sql := var_Sql + '        :OUPT_RMONEY,  ';
        var_Sql := var_Sql + '        :OUPT_GMONEY,  ';
        var_Sql := var_Sql + '        :OUPT_DMONEY,  ';
        var_Sql := var_Sql + '        :OUPT_JMONEY,  ';
        var_Sql := var_Sql + '        :OUPT_IMONEY,  ';
        var_Sql := var_Sql + '        :OUPT_AMONEY,  ';
        var_Sql := var_Sql + '        :OUPT_TMONEY,  ';
        var_Sql := var_Sql + '        :OUPT_CREMODE,  ';
        var_Sql := var_Sql + '        :OUPT_USERID,  ';
        var_Sql := var_Sql + '        :OUPT_USERPW,  ';
        var_Sql := var_Sql + '        :OUPT_JOBDATE,  ';
        var_Sql := var_Sql + '        :OUPT_PDANO,  ';
        var_Sql := var_Sql + '        :OUPT_FLAG,  ';
        var_Sql := var_Sql + '        :OUPT_SENDDATE,  ';
        var_Sql := var_Sql + '        :OUPT_SENDTIME  ';
        var_Sql := var_Sql + ' )';

        Try
            Close;
            Sql.Clear;
            Sql.Add( var_Sql );
            Prepare;
            With var_mioupt Do
            Begin
               ParamByName('OUPT_SCODE').AsString     := Trim(OUPT_SCODE);
               ParamByName('OUPT_YEAR').AsString      := Trim(OUPT_YEAR);
               ParamByName('OUPT_INDEX').AsString     := Trim(OUPT_INDEX);
               ParamByName('OUPT_INYEAR').AsString    := Trim(OUPT_INYEAR);
               ParamByName('OUPT_ININDEX').AsString   := Trim(OUPT_ININDEX);
               ParamByName('OUPT_GROUP').AsString     := Trim(OUPT_GROUP);
               ParamByName('OUPT_OUTDATE').AsString   := Trim(OUPT_OUTDATE);     
               ParamByName('OUPT_JDATE').AsString     := Trim(OUPT_JDATE);
               ParamByName('OUPT_CUSTCODE').AsString  := Trim(OUPT_CUSTCODE);
               ParamByName('OUPT_CUSTNAME').AsString  := Trim(OUPT_CUSTNAME);
               ParamByName('OUPT_CUSTJUMIN').AsString := Trim(OUPT_CUSTJUMIN);
               ParamByName('OUPT_MBL').AsString       := Trim(OUPT_MBL);
               ParamByName('OUPT_HBL').AsString       := Trim(OUPT_HBL);
               ParamByName('OUPT_APNO').AsString      := Trim(OUPT_APNO);
               ParamByName('OUPT_APDATE').AsString    := Trim(OUPT_APDATE);
               ParamByName('OUPT_DECLAUSER').AsString := Trim(OUPT_DECLAUSER);
               ParamByName('OUPT_IOCODE').AsString    := Trim(OUPT_IOCODE);
               ParamByName('OUPT_TROCODE').AsString   := Trim(OUPT_TROCODE);
               ParamByName('OUPT_QTY').AsString       := Trim(OUPT_QTY);
               ParamByName('OUPT_WEIGHT').AsString    := Trim(OUPT_WEIGHT);
               ParamByName('OUPT_PRDCODE').AsString   := Trim(OUPT_PRDCODE);
               ParamByName('OUPT_CHKINSUR').AsString  := Trim(OUPT_CHKINSUR);
               ParamByName('OUPT_SANGCHA').AsString   := Trim(OUPT_SANGCHA);
               ParamByName('OUPT_RMONEY').AsString    := Trim(OUPT_RMONEY);
               ParamByName('OUPT_GMONEY').AsString    := Trim(OUPT_GMONEY);
               ParamByName('OUPT_DMONEY').AsString    := Trim(OUPT_DMONEY);
               ParamByName('OUPT_JMONEY').AsString    := Trim(OUPT_JMONEY);
               ParamByName('OUPT_IMONEY').AsString    := Trim(OUPT_IMONEY);
               ParamByName('OUPT_AMONEY').AsString    := Trim(OUPT_AMONEY);
               ParamByName('OUPT_TMONEY').AsString    := Trim(OUPT_TMONEY);
               ParamByName('OUPT_CREMODE').AsString   := Trim(OUPT_CREMODE);
               ParamByName('OUPT_USERID').AsString    := Trim(OUPT_USERID);
               ParamByName('OUPT_USERPW').AsString    := Trim(OUPT_USERPW);
               ParamByName('OUPT_JOBDATE').AsString   := Trim(OUPT_JOBDATE);
               ParamByName('OUPT_PDANO').AsString     := Trim(OUPT_PDANO);
               ParamByName('OUPT_FLAG').AsString      := Trim(OUPT_FLAG);
               ParamByName('OUPT_SENDDATE').AsString  := Trim(OUPT_SENDDATE);
               ParamByName('OUPT_SENDTIME').AsString  := Trim(OUPT_SENDTIME);
            End;
            ExecSql;
        Except
          On E:Exception do
          begin
                var_Result := False;
          end;
        End;
   End;

   Result := var_Result;
End;

end.

unit WinDB;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     ComCtrls, StdCtrls, ExtCtrls, Db, DBTables, WinLib;

        //------------------------------------------------------------------------------
        //   DATA 에 관계된 처리 함수 모음 ( select / delete / update / search )
        Procedure Win_DB_SetParam( var_Query : TQuery; Param_Value : Array of String; var_OQuery : TQuery );


        Function WinDB_SelectData( var_Query : TQuery;
                                   var_Sql : String;
                                   Param_Value : Array of String ) : Boolean;

        // [ DATA ] 일반적인 SQL SELECT
        Function WinDB_SelectQuery( var_Query : TQuery;
                                    var_Sql : String ) : Boolean;

        Function WinDB_InsertData( var_Query      : TQuery;
                                   var_Sql        : String;
                                   Param_Value    : Array of String ) : Boolean;

        Function WinDB_UpdateData( var_Query      : TQuery;
                                   var_Sql        : String;
                                   Param_Value    : Array of String ) : Boolean;


        // Field 하나만를 Return 한다
        Function WinDB_FieldOne( var_Table, var_Field, var_WField, var_WData : String ) : String;

        //------------------------------------------------------------------------------
        // TABLE 안에 내용을 전부 삭제한다
        Function WinDB_EmptyTable( const DatabaseName; TableName : string ): Boolean;

implementation

uses DM_01;

//------------------------------------------------------------------------------
// [ DATA ] SELECT
{*
    Param_Field : 조건에 사용될 Field
    Param_Value : 조건에 사용될 파라메타 값
    Param_Data  : 조건에 입력될 실제 값
*}
//------------------------------------------------------------------------------
Function WinDB_SelectData( var_Query : TQuery;
                           var_Sql : String;
                           Param_Value : Array of String ) : Boolean;
Begin
        With var_Query Do
        Begin
           DisableControls;
           Try
              Close;
              Sql.Clear;
              Sql.Add( var_Sql );
              Prepare;
              iF Length(Param_Value) > 0 Then
                   Win_DB_SetParam( var_Query, Param_Value, var_Query );
              Open;
           finally
              EnableControls;
           end;
        End;

        Result := True;
End;

//------------------------------------------------------------------------------
// [ DATA ] 일반적인 SQL SELECT
//------------------------------------------------------------------------------
Function WinDB_SelectQuery( var_Query : TQuery;
                           var_Sql : String ) : Boolean;
var
    var_Result : Boolean;
Begin
    var_Result := True;
    With var_Query Do
    Begin
      DisableControls;
      Try
         Try
              Close;
              Sql.Clear;
              Sql.Add( var_Sql );
              Open;
         Except
              On E:Exception do
              begin
                 WinLib_ErrorForm(E.Message+'로 인한 에러');
                 var_Result := False;
              end;
         End;
      finally
        EnableControls;
      end;
   End;
   Result := var_Result;
End;


// [ DATA ] INSERT
Function WinDB_InsertData( var_Query      : TQuery;
                           var_Sql        : String;
                           Param_Value    : Array of String ) : Boolean;
var
        var_Result : Boolean;                           
Begin
        var_Result := True;
        
        if Length(Param_Value) = 0 Then begin
                ShowMessage('프로그래머를 불러 주세요!..버그가 있습니다.');
                Result := False;
                Exit;
        End;

        // DB 에 저장한다
        var_Query.Updateobject := DM01.UpdateSQL;
        With DM01.UpdateSQL Do begin
              DataSet:= var_Query;
              try
                 InsertSql.Clear;
                 InsertSql.Add( var_Sql );

                 with Query[ukInsert] do begin
                   iF Query[ukInsert].ParamCount > 0 Then Begin
                          Win_DB_SetParam( Query[ukInsert], Param_Value, var_Query );
                   End;
                 end;

                 ExecSql(ukInsert); 
                 var_Query.ApplyUpdates;
                 var_Query.CommitUpdates;
              except
                  On E:Exception do
                  begin
                        if pos('Key violation', E.Message) > 0 then begin
                              WinLib_ErrorForm('이미 입력하신 자료가 존재합니다');
                              var_Result := False;
                        End
                        else if pos('Update failed', E.Message) > 0 then Begin
                              WinLib_ErrorForm('데이타 베이스에 저장 실패..네트워크가 이상이 없는지 확인하여 주세요!');
                              var_Result := False;
                        end
                        else begin
                              WinLib_ErrorForm(E.Message+'로 인한 에러');
                              var_Result := False;                              
                        End;
                  end;
             end;

        End;

        Result := var_Result;
End;


// [ DATA ] Update
Function WinDB_UpdateData( var_Query      : TQuery;
                           var_Sql        : String;
                           Param_Value    : Array of String ) : Boolean;
var
        var_Result : Boolean;                              
Begin
        var_Result := True;
        
        if Length(Param_Value) = 0 Then begin
                ShowMessage('프로그래머를 불러 주세요!..버그가 있습니다.');
                Result := False;
                Exit;
        End;

        // DB 에 저장한다
        var_Query.Updateobject := DM01.UpdateSQL;
        With DM01.UpdateSQL Do begin

              DataSet:= var_Query;

              try
                 ModifySQL.Clear;
                 ModifySQL.Add( var_Sql );
                 Win_DB_SetParam( Query[ukModify], Param_Value, var_Query );
                 ExecSql(ukModify);

                 var_Query.ApplyUpdates;
                 var_Query.CommitUpdates;
              except
                  On E:Exception do
                  begin
                        if pos('Key violation', E.Message) > 0 then begin
                              ShowMessage('이미 입력하신 자료가 존재합니다');
                              var_Result := False;
                        End
                        else if pos('Update failed', E.Message) > 0 then Begin
                              ShowMessage('Error : 데이타 베이스에 저장 실패..네트워크가 이상이 없는지 확인하여 주세요!');
                              var_Result := False;
                        end
                        else begin
                              ShowMessage(E.Message+'로 인하여 데이타베이스를 최종저장하기 전상태로 환원합니다');
                              var_Result := False;
                        End;
                  end;
             end;

        End;

        Result := var_Result;
End;

//------------------------------------------------------------------------------
// Field 하나만를 Return 한다
Function WinDB_FieldOne( var_Table, var_Field, var_WField, var_WData : String ) : String;
var
        var_Result, var_Sql : String;
begin
        With DM01.Qry_Temp Do Begin
                var_Sql := 'select ' + var_Field + ' from ' + var_Table;
                var_Sql := var_Sql + ' where ' + var_WField + '=:var_WData';
                
                Close;
                Sql.Clear;
                Sql.Add( var_Sql );
                Prepare;
                ParamByName('var_WData').AsString := var_WData;
                Open;                

                var_Result := FieldByName( var_Field ).AsString;
        End;

        Result := var_Result;
End;


//------------------------------------------------------------------------------

// [ DATA ] 전체를 삭제한다
Function WinDB_EmptyTable( const DatabaseName; TableName : string ): Boolean;
var
        var_Query : TQuery;
begin
        var_Query := TQuery.Create(nil);
        Try
            With var_Query Do begin
                    DatabaseName := DatabaseName;
                    SQL.Clear;
                    SQL.Add('DELETE FROM '+TableName);
                    ExecSQL;
            End;
            Result := True;
        finally
            var_Query.Free;
        end;
end;

//------------------------------------------------------------------------------
// [ DATA ] PARAMETER 에 대한 처리를 한다
{*
    var_Query   : Query  ( INSERt / UPDATE 시에는 Update Sql 문으로 대체된다)
    Param_Value : Parameter 에 들어갈 값
    var_OQuery  : 실제사용하는 Query
*}
//------------------------------------------------------------------------------

Procedure Win_DB_SetParam( var_Query : TQuery; Param_Value : Array of String; var_OQuery : TQuery );
var
        var_Count, var_ParamNum : Smallint;
        var_Data : String;
        Param_Info_Name : Array Of String;
        Param_Info_Type : Array Of TFieldType;
Begin
        With var_Query Do Begin
             var_ParamNum := ParamCount;
             Try
                  SetLength( Param_Info_Name, var_ParamNum );
                  SetLength( Param_Info_Type, var_ParamNum );

                  for var_Count := 0 to var_ParamNum - 1 do begin
                       Param_Info_Name[var_Count] := Params.Items[var_Count].Name;
                       Param_Info_Type[var_Count] := var_OQuery.FieldByName( Param_Info_Name[var_Count] ).DataType;
                  End;

                  Params.clear;
                  for var_Count := 0 to var_ParamNum - 1 do
                  begin
                        var_Data := Param_Value[var_Count];                       
                        with Params.CreateParam( Param_Info_Type[var_Count], Param_Info_Name[var_Count], ptInput) do
                          case Params[var_Count].DataType of
                                ftString   : Params[var_Count].AsString   := var_Data;
                                ftSmallInt : Params[var_Count].AsSmallInt := StrToIntDef(var_Data, 0);
                                ftInteger  : Params[var_Count].AsInteger  := StrToIntDef(var_Data, 0);
                                ftWord     : Params[var_Count].AsWord     := StrToIntDef(var_Data, 0);
                                ftBoolean  : Begin
                                                 if var_Data = 'True' then Params[var_Count].AsBoolean := True
                                                 Else Params[var_Count].AsBoolean := False;
                                             End;
                                ftFloat    : Params[var_Count].AsFloat    := StrToFloat(var_Data);
                                ftCurrency : Params[var_Count].AsCurrency := StrToFloat(var_Data);
                                ftBCD      : Params[var_Count].AsBCD      := StrToCurr(var_Data);
                                ftDate     : Params[var_Count].AsDate     := StrToDate(var_Data);
                                ftTime     : Params[var_Count].AsTime     := StrToTime(var_Data);
                                ftDateTime : Params[var_Count].AsDateTime := StrToDateTime(var_Data);
                                ftMemo     : Params[var_Count].AsMemo     := var_Data;
                                ftGraphic  : Params[var_Count].LoadFromFile( var_Data, ftGraphic );
                                
                                {*

ftBytes	Fixed number of bytes (binary storage)

ftVarBytes	Variable number of bytes (binary storage)
ftAutoInc	Auto-incrementing 32-bit integer counter field
ftBlob	Binary Large OBject field

ftFmtMemo	Formatted text memo field
ftTypedBinary	Typed binary field
ftCursor	Output cursor from an Oracle stored procedure (TParam only)
ftFixedChar	Fixed character field
ftWideString	Wide string field
ftLargeint	Large integer field

ftADT	Abstract Data Type field
ftArray	Array field
ftReference	REF field
ftDataSet	DataSet field
ftVariant	Data of unknown or undetermined type
ftInterface	References to interfaces (IUnknown)
ftIDispatch	References to IDispatch interfaces
ftGuid	globally unique identifier (GUID) values
ftTimeStamp	Date and time field accessed through dbExpress
ftFMTBcd	Binary-Coded Decimal field that is too large for ftBCD.
                                *}

                           else
                                ShowMessage('해당하는 필드타입이 없습니다..개발자에게 연락하여 주세요');
                           end;
                  End;              

             Finally
                  Param_Info_Name := nil;
                  Param_Info_Type := nil;
             End;
        End;
End;

end.

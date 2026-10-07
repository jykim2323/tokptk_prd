unit DBSet;

interface

uses
  SysUtils, Classes, Dialogs, DB, ADODB, Windows, Messages, Graphics, Controls, Forms,
  DBTables, Variants, Excel2000,  ComObj, OleServer,IniFiles;

type
  TDM1 = class(TDataModule)
    Main_db: TADOConnection;
    SaveDialog: TSaveDialog;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function DataBaseConnect:Boolean;
    function Get_DBString: boolean;
    procedure GridToExel(const Query: TADOQuery; s_title: string);
  end;

var
  DM1: TDM1;
  DBName  : string;
  DbConnect : boolean; //DataBase Connect Status
  DB_NAME : string;  
  IniFile: TIniFile;

implementation

{$R *.dfm}



procedure TDM1.DataModuleCreate(Sender: TObject);
begin
   DbConnect := DataBaseConnect;
   if DbConnect then begin
//       Showmessage('Db Connect Ok');
    end
    else
    begin
        Showmessage('DB Connect Error !!!');
    end;
end;


{*****************************************************************************}
{*  엑셀저장처리                                                             *}
{*****************************************************************************}
procedure TDM1.GridToExel(const Query: TADOQuery; s_title: string);
var
   i,j, Row, Col, ColCnt,RowCnt, BookCount:Integer;
   V, sheet : Variant;
//   ExlSaveName : string;
begin
{
  SaveDialog.InitialDir := 'c:\';                 // 데이타를 저장할 장소지정
  if SaveDialog.Execute then
     ExlSaveName := SaveDialog.Filename + '.xls'
  else
     exit;
}
// Screen.Cursor := crHourGlass;

 ColCnt:=Query.FieldCount;
 RowCnt:=Query.RecordCount;
 i := 1;
 J := 1;

// Query.DisableControls;

 Query.First;
 try
    if VarIsEmpty(V) then begin
      BookCount := 0;
      V := CreateOleObject('Excel.Application');
    end;
    V.Visible := False;
    V.WorkBooks.Add;
    BookCount := BookCount + 1;
    Sheet := V.Workbooks[BookCount].Sheets[1];
    Sheet.Name := s_title;
 except
    V := unAssigned;
    Sheet := unAssigned;

    BookCount := 0;
    V :=CreateOleObject('Excel.Application');
    V.WorkBooks.Add;
    BookCount := BookCount + 1;
    Sheet := V.Workbooks[BookCount].Sheets[1];
    Sheet.Name := SaveDialog.Filename;
 end;

 Query.DisableControls;

 for Col := 1 to ColCnt do
 begin
   if Query.Fields[Col-1].Visible then
   begin
      V.Cells[1,i].Value := Query.Fields[Col-1].DisplayName;
      i := i + 1;
   end;
 end;

 for Row := 2 to RowCnt+1 do begin
   for Col := 1 to ColCnt do begin
     if Query.Fields[Col-1].Visible then begin
       if Query.Fields[Col-1].DataType=ftString then begin
         V.Cells[Row,j].Value:=''''+Query.Fields[Col-1].AsString;
       end
       else begin
         V.Cells[Row,j].Value := Query.Fields[Col-1].AsString;
       end;
       j := J + 1;
     end;
   end;
   j := 1;
   Query.Next;
 end;

 Query.EnableControls;

// V.Visible := True;         // 엑셀시트를 안보이게

 v.Quit;

 // Screen.Cursor := crDefault;

end;


Function TDM1.DataBaseConnect() : boolean;
begin
    if Get_Dbstring = false then begin
        showmessage('\INI\Config.ini Error!');
        result := false;
    end
    else begin
        try    
            Main_db.Connected := False;
            Main_db.ConnectionString := DBName;
//            Main_db.Connected := True;
//            showmessage('DBName = ' + DBName);
            result := true;

        except
            result := false;
        end;
    end;  
end;

function TDM1.Get_DBString: boolean;
var
  StrCon : String;

  sUSER  : String;
  sPASSWORD : String;
  sIdentify : String;
  sDB    : String;
  sIP    : String;
begin
    IniFile:= TIniFile.Create('..\INI\Config.ini');

    sDB := IniFile.ReadString('MSDB', 'DB', '');
    sIP := IniFile.ReadString('MSDB', 'DataSource', '');
    sUSER  := IniFile.ReadString('MSDB', 'USER', '');
    sPASSWORD  := IniFile.ReadString('MSDB', 'PASSWORD', '');
    sIdentify  := 'User ID=' + sUSER   + ';' ;
    If  sPASSWORD <>'' Then Begin
        sIdentify := sIdentify +  'Password='+ sPASSWORD + ';';
    End;
    StrCon      := 'Provider=SQLOLEDB.1;Persist Security Info=false;' + sIdentify +
                   'Initial Catalog='+ sDB+';'+
                   'Data Source=' + sIP;


    //DBName   := IniFile.ReadString('DB Connect', 'STK_DB', 'NOT');
    DBName   :=StrCon;
    IniFile.Destroy;

    if (DBName = 'NOT')   then  result := false
    else result := true; 
end;

end.

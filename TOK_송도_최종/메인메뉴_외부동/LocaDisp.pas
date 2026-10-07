unit LocaDisp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Db, DBTables, StdCtrls, Buttons, ADODB;

type
  TLocaDisp_f = class(TForm)
    Loca11: TPanel;
    Loca12: TPanel;
    Loca13: TPanel;
    Loca21: TPanel;
    Loca22: TPanel;
    Loca23: TPanel;
    Loca31: TPanel;
    Loca32: TPanel;
    Loca33: TPanel;
    Loca41: TPanel;
    Loca42: TPanel;
    Loca43: TPanel;
    Loca51: TPanel;
    Loca52: TPanel;
    Loca53: TPanel;
    Loca61: TPanel;
    Loca62: TPanel;
    Loca63: TPanel;
    Loca71: TPanel;
    Loca72: TPanel;
    Loca73: TPanel;
    Loca81: TPanel;
    Loca82: TPanel;
    Loca83: TPanel;
    Loca91: TPanel;
    Loca92: TPanel;
    Loca93: TPanel;
    Loca101: TPanel;
    Loca102: TPanel;
    Loca103: TPanel;
    Loca111: TPanel;
    Loca112: TPanel;
    Loca113: TPanel;
    Loca121: TPanel;
    Loca122: TPanel;
    Loca123: TPanel;
    Loca131: TPanel;
    Loca132: TPanel;
    Loca133: TPanel;
    LocaQuery: TADOQuery;
    StartBitBtn: TSpeedButton;
    ExitBitBtn: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel4: TPanel;
    Label3: TLabel;
    Panel6: TPanel;
    Label5: TLabel;
    Panel7: TPanel;
    Label6: TLabel;
    Panel5: TPanel;
    Label4: TLabel;
    Panel8: TPanel;
    Label7: TLabel;
    LocaPnl: TPanel;
    locaCB: TComboBox;
    Loca14: TPanel;
    Loca15: TPanel;
    Loca16: TPanel;
    Loca24: TPanel;
    Loca25: TPanel;
    Loca26: TPanel;
    Loca34: TPanel;
    Loca35: TPanel;
    Loca36: TPanel;
    Loca44: TPanel;
    Loca45: TPanel;
    Loca46: TPanel;
    Loca54: TPanel;
    Loca55: TPanel;
    Loca56: TPanel;
    Loca64: TPanel;
    Loca65: TPanel;
    Loca66: TPanel;
    Loca74: TPanel;
    Loca75: TPanel;
    Loca76: TPanel;
    Loca84: TPanel;
    Loca85: TPanel;
    Loca86: TPanel;
    Loca94: TPanel;
    Loca95: TPanel;
    Loca96: TPanel;
    Loca104: TPanel;
    Loca105: TPanel;
    Loca106: TPanel;
    Loca114: TPanel;
    Loca115: TPanel;
    Loca116: TPanel;
    Loca124: TPanel;
    Loca125: TPanel;
    Loca126: TPanel;
    Loca134: TPanel;
    Loca135: TPanel;
    Loca136: TPanel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Loca17: TPanel;
    Loca18: TPanel;
    Loca19: TPanel;
    Loca27: TPanel;
    Loca28: TPanel;
    Loca29: TPanel;
    Loca37: TPanel;
    Loca38: TPanel;
    Loca39: TPanel;
    Loca47: TPanel;
    Loca48: TPanel;
    Loca49: TPanel;
    Loca57: TPanel;
    Loca58: TPanel;
    Loca59: TPanel;
    Loca67: TPanel;
    Loca68: TPanel;
    Loca69: TPanel;
    Loca77: TPanel;
    Loca78: TPanel;
    Loca79: TPanel;
    Loca87: TPanel;
    Loca88: TPanel;
    Loca89: TPanel;
    Loca97: TPanel;
    Loca98: TPanel;
    Loca99: TPanel;
    Loca107: TPanel;
    Loca108: TPanel;
    Loca109: TPanel;
    Loca117: TPanel;
    Loca118: TPanel;
    Loca119: TPanel;
    Loca127: TPanel;
    Loca128: TPanel;
    Loca129: TPanel;
    Loca137: TPanel;
    Loca138: TPanel;
    Loca139: TPanel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure LocaDblClick(Sender: TObject);
    procedure LocaCBChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Image_buf_move;
    procedure Location_flag_move(var Bkno: String);
    procedure Location_Status_Display;
    procedure Loca_Status(var Bkno: String);
  end;

var
  LocaDisp_f: TLocaDisp_f;

  Loca_Pnl  : array [1..117] of TPanel;
  Loca_flag : array [1..117] of String;
  BK_NO, BY_NO, LV_NO : String;
implementation

uses CellDisp;

{$R *.DFM}


procedure TLocaDisp_f.FormActivate(Sender: TObject);
var
   Bank_no: String;
begin
   Bank_no := locaCB.Text;
   Location_flag_move(Bank_no);
end;

procedure TLocaDisp_f.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//   Action := caFree;
end;

procedure TLocaDisp_f.FormCreate(Sender: TObject);
var
   Bank_no: String;
begin
   Image_buf_move;
   Bank_no := '1';
   Location_flag_move(Bank_No);
end;

procedure TLocaDisp_f.ExitBitBtnClick(Sender: TObject);
begin
   Close;
end;

procedure TLocaDisp_f.StartBitBtnClick(Sender: TObject);
begin
   Location_flag_move(BK_NO);
end;

procedure TLocaDisp_f.Loca_Status(var Bkno: String);
begin
   Location_flag_move(Bkno);       //  메인화면에서 Click하여 Rack상태를 보여준다.
   locaCB.Text := Bkno;
//   LOcation_Status_Display;
end;

procedure TLocaDisp_f.Image_buf_move;
var
   i: Integer;
   j, k, m : Integer;
   str, str1, str2 : String;
begin
   i := 0;
 i := 0;
   repeat            //  Panel name을 Loca_pnl 배열에 move 한다.
      if Components[i] is TPanel then
      begin
         for j := 1 to 13 do
         begin
            for k := 1 to 9 do
            begin
               str := 'Loca' + IntToStr(j) + IntToStr(k);
               str1 := TPanel(Components[i]).name;
               if j < 10 then
                  str2 := '0' + IntToStr(j)
               else
                  str2 := IntToStr(j);
               str2 := str2 + '-' + IntToStr(k);

               m := ( j - 1 ) * 9 + k;

               if StrComp(@str1[1],@str[1]) = 0 then
               begin
                  Loca_Pnl[m] := TPanel(Components[i]);
                  Loca_Pnl[m].Caption := Str2;
               end;

            end;    // End of for k := 1
         end;       // End of for j := 1
      end;          // End of if Components
      inc(i);
   until( i = ComponentCount);     //  End of Repeat

end;

procedure TLocaDisp_f.Location_flag_move(var Bkno: String);
var
   i : integer;
   IntBk, IntBy, IntLv, IntPos, IntQty, li_x : Integer;
begin
   i := 1;
   BK_NO := Bkno;
   LocaDisp_f.Caption := Bkno + ' 열';
   LocaPnl.Caption    := Bkno + ' 열 상태';
   with LocaQuery do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' Select LSTK_BK, LSTK_BY, LSTK_LV, LSTK_FLAG from T2MILSTK  (NOLOCK)');
      SQL.Add('  where lstk_bk = '''+Bkno+''' ');
      SQL.Add('  order by lstk_by, lstk_lv ');
      Open;
      First;

      While True do
      begin
         if LocaQuery.Eof then break;

         IntBk    := FieldByName('LSTK_BK').AsInteger;
         IntBy    := FieldByName('LSTK_BY').AsInteger;
         IntLv    := FieldByName('LSTK_LV').AsInteger;

         li_x        := (IntBy - 1) * 9 + IntLv;


         Loca_flag[li_x] := FieldByName('lstk_flag').AsString;

           if      loca_flag[li_x] = '0' then
           begin Loca_pnl[li_x].Color := clBtnface; Loca_Pnl[li_x].Font.Color := clBlack; end
           else if loca_flag[li_x] = '1' then
           begin Loca_Pnl[li_x].Color := clBlue;    Loca_Pnl[li_x].Font.Color := clWhite; end
           else if loca_flag[li_x] = 'X' then
           begin Loca_Pnl[li_x].Color := clLime;    Loca_Pnl[li_x].Font.Color := clWhite; end
           else if loca_flag[li_x] = 'Y' then
           begin Loca_Pnl[li_x].Color := clTeal;    Loca_Pnl[li_x].Font.Color := clWhite; end
           else if loca_flag[li_x] = 'W' then
           begin Loca_Pnl[li_x].Color := clPurple;  Loca_Pnl[li_x].Font.Color := clWhite; end
           else if loca_flag[li_x] = 'E' then
           begin Loca_Pnl[li_x].Color := clRed;     Loca_Pnl[li_x].Font.Color := clWhite; end
          else if loca_flag[li_x] = 'N' then
           begin Loca_Pnl[li_x].Color := clBlack;   Loca_Pnl[li_x].Font.Color := clWhite; end;

         Next;
      end;
   end;


end;

procedure TLocaDisp_f.Location_Status_Display;
var
   li_x : Integer;
begin
   for li_x := 1 to 117 do
   begin
      if      loca_flag[li_x] = '0' then
           begin Loca_pnl[li_x].Color := clBtnface; Loca_Pnl[li_x].Font.Color := clBlack; end
      else if loca_flag[li_x] = '1' then
           begin Loca_Pnl[li_x].Color := clBlue;    Loca_Pnl[li_x].Font.Color := clWhite; end
      else if loca_flag[li_x] = 'X' then
           begin Loca_Pnl[li_x].Color := clLime;    Loca_Pnl[li_x].Font.Color := clWhite; end
      else if loca_flag[li_x] = 'Y' then
           begin Loca_Pnl[li_x].Color := clTeal;    Loca_Pnl[li_x].Font.Color := clWhite; end
      else if loca_flag[li_x] = 'W' then
           begin Loca_Pnl[li_x].Color := clPurple;  Loca_Pnl[li_x].Font.Color := clWhite; end
      else if loca_flag[li_x] = 'E' then
           begin Loca_Pnl[li_x].Color := clRed;     Loca_Pnl[li_x].Font.Color := clWhite; end
      else if loca_flag[li_x] = 'N' then
           begin Loca_Pnl[li_x].Color := clBlack;   Loca_Pnl[li_x].Font.Color := clWhite; end;
   end;
end;

procedure TLocaDisp_f.LocaDblClick(Sender: TObject);
var
   Str : String;
begin
   Str := TPanel(Sender).Caption;
   BY_NO := Copy(Str, 1, 2);
   LV_NO := Copy(Str, 4, 1);

   CellDisp_f.BankEdit.Text := BK_NO;
   CellDisp_f.BayEdit.Text  := BY_NO;
   CellDisp_f.LevlEdit.Text := LV_NO;

   CellDisp_f.Show;

end;

procedure TLocaDisp_f.LocaCBChange(Sender: TObject);  
begin
   Bk_no := locacb.Text;
   Location_flag_move(bk_NO);
 //  LOcation_Status_Display;
end;

procedure TLocaDisp_f.FormShow(Sender: TObject);
begin
//   locaCB.Text := '';
end;



end.

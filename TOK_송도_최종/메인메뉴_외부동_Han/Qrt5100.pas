unit Qrt5100;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, QRCtrls, ExtCtrls, DB, DBTables;

type
  TQrt_5100 = class(TForm)
    QuickReport: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRLabel3: TQRLabel;
    QRLbl_Code: TQRLabel;
    QRLbl_DateTime: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel7: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRGroup1: TQRGroup;
    QRLabel9: TQRLabel;
    QRDBText12: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel1: TQRLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject); 
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Qrt_5100: TQrt_5100;

implementation

USES Prm5100, ComCtrls;

{$R *.dfm}

procedure TQrt_5100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TQrt_5100.FormDestroy(Sender: TObject);
begin
  Qrt_5100 := Nil;
end;   

end.

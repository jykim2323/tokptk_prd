unit Qrt1700;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, QRCtrls, ExtCtrls, DB, DBTables;

type
  TQrt_1700 = class(TForm)
    QuickReport: TQuickRep;
    QRBand2: TQRBand;
    QRExpr1: TQRExpr;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRBand5: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel3: TQRLabel;
    QRLbl_Code: TQRLabel;
    QRLbl_DateTime: TQRLabel;
    QRLabel5: TQRLabel;
    QRDBText6: TQRDBText;
    QRLabel8: TQRLabel;
    QRLabel1: TQRLabel;
    QRDBText1: TQRDBText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Qrt_1700: TQrt_1700;

implementation

USES Prm1700, ComCtrls;

{$R *.dfm}

procedure TQrt_1700.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TQrt_1700.FormDestroy(Sender: TObject);
begin
  Qrt_1700 := Nil;
end;

end.

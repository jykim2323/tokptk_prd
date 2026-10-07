unit FrmError;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls;

type
  TFrm_Error = class(TForm)
    Lbl_Error: TLabel;
    SB_OK: TBitBtn;
    Bevel1: TBevel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SB_OKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Error: TFrm_Error;

implementation

{$R *.dfm}

procedure TFrm_Error.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action := caFree;
end;

procedure TFrm_Error.FormDestroy(Sender: TObject);
begin
        Frm_Error := Nil;
end;

procedure TFrm_Error.SB_OKClick(Sender: TObject);
begin
        Close;
end;

end.

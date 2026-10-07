unit FrmChkExit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls; 

type
  TFrm_ChkExit = class(TForm)
    Pnl: TPanel;
    Label1: TLabel;
    Shape1: TShape;
    Bevel1: TBevel;
    SBtn_Close: TSpeedButton;
    SBtn_Cancel: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SBtn_CloseClick(Sender: TObject);
    procedure SBtn_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
     procedure AppMessage(var Msg: TMsg; var Handled : Boolean);  
  public
    { Public declarations }
  end;

var
  Frm_ChkExit: TFrm_ChkExit;

implementation

{$R *.dfm}

procedure TFrm_ChkExit.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message = WM_KEYDOWN) then
    if (Msg.wParam = 13) then SBtn_CloseClick(Self)
    else if (Msg.wParam = 27) then SBtn_CancelClick(Self);
end;

procedure TFrm_ChkExit.FormCreate(Sender: TObject);
begin
  Application.OnMessage := AppMessage;
end;

procedure TFrm_ChkExit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_ChkExit.FormDestroy(Sender: TObject);
begin
  Frm_ChkExit := Nil;
end;

procedure TFrm_ChkExit.SBtn_CloseClick(Sender: TObject);
begin
   ModalResult := mrOK;
end;

procedure TFrm_ChkExit.SBtn_CancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

end.

unit FrmPrompt;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls;

type
  TFrm_Prompt = class(TForm)
    Bevel1: TBevel;
    Lbl_Text: TLabel;
    SB_OK: TSpeedButton;
    SB_Cancel: TSpeedButton;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SB_OKClick(Sender: TObject);
    procedure SB_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Prompt: TFrm_Prompt;

implementation

{$R *.dfm}

procedure TFrm_Prompt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action := caFree;
end;

procedure TFrm_Prompt.FormDestroy(Sender: TObject);
begin
        Frm_Prompt := Nil;
end;

procedure TFrm_Prompt.SB_OKClick(Sender: TObject);
begin
        ModalResult := mrOK;
end;

procedure TFrm_Prompt.SB_CancelClick(Sender: TObject);
begin
        ModalResult := mrCancel;
end;

end.

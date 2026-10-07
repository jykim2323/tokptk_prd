unit ahcomm_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, ADODB, ScktComp,
  ahcvc1_u, ahcvc2_u, ahcvc3_u, ahsrc1_u, ahsrc2_u, ahsrc3_u, ahupdt_u,
  ahbcr1_u, ahbcr2_u, ahbcr3_u;

type
  Tahcomm_f = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    CVC1Edit: TEdit;
    CVC2Edit: TEdit;
    SRC1Edit: TEdit;
    SRC2Edit: TEdit;
    SubmitBitBtn: TBitBtn;
    StopBitBtn: TBitBtn;
    ExitBitBtn: TBitBtn;
    Memo1: TMemo;
    CVC1ADOConn: TADOConnection;
    SRC1ADOConn: TADOConnection;
    SRC2ADOConn: TADOConnection;
    SRC2Query: TADOQuery;
    SRC1Query: TADOQuery;
    CVC1Query: TADOQuery;
    CVC1UpdtQuery: TADOQuery;
    SRC1UpdtQuery: TADOQuery;
    SRC2UpdtQuery: TADOQuery;
    UpdtEdit: TEdit;
    UpdtImg: TImage;
    GroupBox2: TGroupBox;
    AllBitBtn: TBitBtn;
    Cvc1CheckBox: TCheckBox;
    Src1CheckBox: TCheckBox;
    Src2CheckBox: TCheckBox;
    UpdtCheckBox: TCheckBox;
    UpdtADOConn: TADOConnection;
    SelQuery: TADOQuery;
    UpdtQuery: TADOQuery;
    Src3CheckBox: TCheckBox;
    SRC3Edit: TEdit;
    SRC3ADOConn: TADOConnection;
    SRC3Query: TADOQuery;
    SRC3UpdtQuery: TADOQuery;
    Cvc2CheckBox: TCheckBox;
    Cvc3CheckBox: TCheckBox;
    CVC3Edit: TEdit;
    Src3RedImg: TImage;
    Src3BlueImg: TImage;
    Src2BlueImg: TImage;
    Src2RedImg: TImage;
    Src1BlueImg: TImage;
    Src1RedImg: TImage;
    Cvc1BlueImg: TImage;
    Cvc1RedImg: TImage;
    Cvc2BlueImg: TImage;
    Cvc2RedImg: TImage;
    Cvc3BlueImg: TImage;
    Cvc3RedImg: TImage;
    CVC2ADOConn: TADOConnection;
    CVC2Query: TADOQuery;
    CVC2UpdtQuery: TADOQuery;
    CVC3ADOConn: TADOConnection;
    CVC3Query: TADOQuery;
    CVC3UpdtQuery: TADOQuery;
    Bcr1CheckBox: TCheckBox;
    Bcr2CheckBox: TCheckBox;
    Bcr3CheckBox: TCheckBox;
    BCR1Edit: TEdit;
    BCR2Edit: TEdit;
    BCR3Edit: TEdit;
    Bcr1BlueImg: TImage;
    Bcr2RedImg: TImage;
    Bcr3BlueImg: TImage;
    Bcr1RedImg: TImage;
    Bcr2BlueImg: TImage;
    Bcr3RedImg: TImage;
    Bcr1ADOConn: TADOConnection;
    Bcr1Query: TADOQuery;
    Bcr1UpdtQuery: TADOQuery;
    Bcr2ADOConn: TADOConnection;
    Bcr2Query: TADOQuery;
    Bcr2UpdtQuery: TADOQuery;
    Bcr3ADOConn: TADOConnection;
    Bcr3Query: TADOQuery;
    Bcr3UpdtQuery: TADOQuery;
    procedure AllBitBtnClick(Sender: TObject);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SubmitBitBtnClick(Sender: TObject);
    procedure StopBitBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ahcomm_f: Tahcomm_f;

  bcr1_T : ahbcr1_T;
  bcr2_T : ahbcr2_T;
  bcr3_T : ahbcr3_T;

  CVC1_T : ahcvc1_T;
  CVC2_T : ahcvc2_T;
  CVC3_T : ahcvc3_T;
  SRC1_T : ahsrc1_T;
  SRC2_T : ahsrc2_T;
  SRC3_T : ahsrc3_T;
  UPDT_T : ahupdt_T;

  Bcr1_Socket  : TClientSocket;
  Bcr2_Socket  : TClientSocket;
  Bcr3_Socket  : TClientSocket;

  Cvc1_Socket  : TClientSocket;
  Cvc2_Socket  : TClientSocket;
  Cvc3_Socket  : TClientSocket;
  SRC1_Socket  : TClientSocket;
  SRC2_Socket  : TClientSocket;
  SRC3_Socket  : TClientSocket;


implementation

{$R *.dfm}


procedure Tahcomm_f.FormCreate(Sender: TObject);
begin
 ExitBitBtn.Enabled := True;

 Bcr1_Socket := TClientSocket.Create(Nil); // Socket 생성  ///
 Bcr2_Socket := TClientSocket.Create(Nil); // Socket 생성  ///
 Bcr3_Socket := TClientSocket.Create(Nil); // Socket 생성  ///

 Cvc1_Socket := TClientSocket.Create(Nil); // Socket 생성  ///
 Cvc2_Socket := TClientSocket.Create(Nil); // Socket 생성  ///
 Cvc3_Socket := TClientSocket.Create(Nil); // Socket 생성  ///

 Src1_Socket := TClientSocket.Create(Nil); // Socket 생성  ///
 Src2_Socket := TClientSocket.Create(Nil); // Socket 생성  ///
 Src3_Socket := TClientSocket.Create(Nil); // Socket 생성  ///

 CVC1CheckBox.Checked := True;  ///
 CVC2CheckBox.Checked := True;  ///
 CVC3CheckBox.Checked := True;  ///

 SRC1CheckBox.Checked := True;  ///
 SRC2CheckBox.Checked := True;  ///
 SRC3CheckBox.Checked := True;  ///
 UpdtCheckBox.Checked := True;  ///

end;

procedure Tahcomm_f.AllBitBtnClick(Sender: TObject);
begin

    bcr1CheckBox.Checked  := True;
    bcr2CheckBox.Checked  := True;
    bcr3CheckBox.Checked  := True;

    CVC1CheckBox.Checked  := True;
    CVC2CheckBox.Checked  := True;
    CVC3CheckBox.Checked  := True;

    SRC1CheckBox.Checked := True;
    SRC2CheckBox.Checked := True;
    SRC3CheckBox.Checked := True;
    UpdtCheckBox.Checked := True;
end;

procedure Tahcomm_f.SubmitBitBtnClick(Sender: TObject);
begin
  If MessageDlg(' 정말로 개시 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then Begin



    If (Bcr1CheckBox.Checked) and (Bcr1_pgm = 'T') Then
    Bcr1Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (Bcr1CheckBox.Checked) Then
    Begin
      Bcr1ADOConn.Connected := True;
      sleep(300);
      ///
      If Bcr1_Socket.Active then Bcr1_Socket.Active := False;
        Bcr1_Socket.Host   :=   '172.16.139.172';
        Bcr1_Socket.Port   := StrToInt('2112');
        Bcr1_Socket.Active := True;

        Bcr1_T := ahbcr1_T.Create(False);
    End;


    If (Bcr2CheckBox.Checked) and (Bcr2_pgm = 'T') Then
    Bcr2Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (Bcr2CheckBox.Checked) Then
    Begin
      Bcr2ADOConn.Connected := True;
      sleep(300);
      ///
      If Bcr2_Socket.Active then Bcr2_Socket.Active := False;
        Bcr2_Socket.Host   :=   '172.16.139.173';
        Bcr2_Socket.Port   := StrToInt('2112');
        Bcr2_Socket.Active := True;

        Bcr2_T := ahbcr2_T.Create(False);
    End;


    If (Bcr3CheckBox.Checked) and (Bcr3_pgm = 'T') Then
    Bcr3Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (Bcr3CheckBox.Checked) Then
    Begin
      Bcr3ADOConn.Connected := True;
      sleep(300);

      ///
      If Bcr3_Socket.Active then Bcr3_Socket.Active := False;
        Bcr3_Socket.Host   :=   '172.16.139.174';
        Bcr3_Socket.Port   := StrToInt('2112');
        Bcr3_Socket.Active := True;

        Bcr3_T := ahbcr3_T.Create(False);
    End;

    If (CVC1CheckBox.Checked) and (CVC1_pgm = 'T') Then
       Cvc1Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (CVC1CheckBox.Checked) Then
    Begin
      CVC1ADOConn.Connected := True;
      sleep(300);
      ///
      If Cvc1_Socket.Active then Cvc1_Socket.Active := False;

        Cvc1_Socket.Host   :=   '172.16.139.181';
        Cvc1_Socket.Port   := StrToInt('$601');
        Cvc1_Socket.Active := True;

        CVC1_T := ahcvc1_T.Create(False);
    End;

    If (CVC2CheckBox.Checked) and (CVC2_pgm = 'T') Then
       Cvc2Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (CVC2CheckBox.Checked) Then
    Begin
      CVC2ADOConn.Connected := True;
      sleep(300);

      ///
      If Cvc2_Socket.Active then Cvc2_Socket.Active := False;

        Cvc2_Socket.Host   :=   '172.16.139.182';
        Cvc2_Socket.Port   := StrToInt('$601');
        Cvc2_Socket.Active := True;

        CVC2_T := ahcvc2_T.Create(False);
    End;

    If (CVC3CheckBox.Checked) and (CVC3_pgm = 'T') Then
       Cvc3Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (CVC3CheckBox.Checked) Then
    Begin
      CVC3ADOConn.Connected := True;
      sleep(300);

      ///
      If Cvc3_Socket.Active then Cvc3_Socket.Active := False;

        Cvc3_Socket.Host   :=   '172.16.139.183';
        Cvc3_Socket.Port   := StrToInt('$601');
        Cvc3_Socket.Active := True;

        CVC3_T := ahcvc3_T.Create(False);
    End;


    If (SRC1CheckBox.Checked) and (Src1_pgm = 'T') Then
      SRC1Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (SRC1CheckBox.Checked) Then
    Begin
      SRC1ADOConn.Connected := True;
      sleep(300);
      
      ///
      If SRC1_Socket.Active then SRC1_Socket.Active := False;

        SRC1_Socket.Host   := '172.16.139.181';
        SRC1_Socket.Port   := StrToInt('$600');
        SRC1_Socket.Active := True;
      
        SRC1_T := ahsrc1_T.Create(False);
    End;

    If (SRC2CheckBox.Checked) and (Src2_pgm = 'T') Then
      SRC2Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (SRC2CheckBox.Checked) Then
    Begin
      SRC2ADOConn.Connected := True;
      sleep(300);

      ///
      If SRC2_Socket.Active then SRC2_Socket.Active := False;

        SRC2_Socket.Host   :=   '172.16.139.182';
        SRC2_Socket.Port   := StrToInt('$600');
        SRC2_Socket.Active := True;
      
        SRC2_T := ahsrc2_T.Create(False);
    End;

    If (SRC3CheckBox.Checked) and (Src3_pgm = 'T') Then
      SRC3Edit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (SRC3CheckBox.Checked) Then
    Begin
      SRC3ADOConn.Connected := True;
      sleep(300);

      ///
      If SRC3_Socket.Active then SRC3_Socket.Active := False;

        SRC3_Socket.Host   :=   '172.16.139.183';
        SRC3_Socket.Port   := StrToInt('$600');
        SRC3_Socket.Active := True;
      
        SRC3_T := ahsrc3_T.Create(False);
    End;


    If (UpdtCheckBox.Checked) and (Updt_pgm = 'T') Then
      UpdtEdit.Text := '이미 통신개시 작업을 하였습니다.!!'
    Else If (UpdtCheckBox.Checked) Then
    Begin
      UPDTADOConn.Connected := True;
      sleep(300);
      UPDT_T := ahupdt_T.Create(False);
    End;

    ExitBitBtn.Enabled := False;
  End;
end;

procedure Tahcomm_f.StopBitBtnClick(Sender: TObject);
begin
  If MessageDlg(' 정말로 중지 합니까.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then Begin


    If (BCR1CheckBox.Checked) And (Bcr1_pgm = 'F') Then
      BCR1Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (BCR1CheckBox.Checked) Then Begin
      Bcr1_pgm := 'F';
      BCR1_T.Terminate;
      BCR1_T.Destroy;
      BCR1ADOConn.Connected := False;
    End;

    If (BCR2CheckBox.Checked) And (Bcr2_pgm = 'F') Then
      BCR2Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (BCR2CheckBox.Checked) Then Begin
      Bcr2_pgm := 'F';
      BCR2_T.Terminate;
      BCR2_T.Destroy;
      BCR2ADOConn.Connected := False;
    End;

    If (BCR3CheckBox.Checked) And (Bcr3_pgm = 'F') Then
      BCR3Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (BCR3CheckBox.Checked) Then Begin
      Bcr3_pgm := 'F';
      BCR3_T.Terminate;
      BCR3_T.Destroy;
      BCR3ADOConn.Connected := False;
    End;
    
    If (CvC1CheckBox.Checked) And (CvC1_pgm = 'F') Then
      CvC1Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (CvC1CheckBox.Checked) Then Begin
      CvC1_pgm := 'F';
      CvC1_T.Terminate;
      CvC1_T.Destroy;
      CvC1ADOConn.Connected := False;
    End;

    If (CvC2CheckBox.Checked) And (CvC2_pgm = 'F') Then
      CvC2Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (CvC2CheckBox.Checked) Then Begin
      CvC2_pgm := 'F';
      CvC2_T.Terminate;
      CvC2_T.Destroy;
      CvC2ADOConn.Connected := False;
    End;

    If (CvC3CheckBox.Checked) And (CvC3_pgm = 'F') Then
      CvC3Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (CvC3CheckBox.Checked) Then Begin
      CvC3_pgm := 'F';
      CvC3_T.Terminate;
      CvC3_T.Destroy;
      CvC3ADOConn.Connected := False;
    End; 


    If (SRC1CheckBox.Checked) And (Src1_pgm = 'F') Then
      SRC1Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (SRC1CheckBox.Checked) Then Begin
      Src1_pgm := 'F';
      SRC1_T.Terminate;
      SRC1_T.Destroy;
      SRC1ADOConn.Connected := False;
    End;

    If (SRC2CheckBox.Checked) And (Src2_pgm = 'F') Then
      SRC2Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (SRC2CheckBox.Checked) Then Begin
      Src2_pgm := 'F';
      SRC2_T.Terminate;
      SRC2_T.Destroy;
      SRC2ADOConn.Connected := False;
    End;

    If (SRC3CheckBox.Checked) And (Src3_pgm = 'F') Then
      SRC3Edit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (SRC3CheckBox.Checked) Then Begin
      Src3_pgm := 'F';
      SRC3_T.Terminate;
      SRC3_T.Destroy;
      SRC3ADOConn.Connected := False; 
    End;

    If (UpdtCheckBox.Checked) And (Updt_pgm = 'F') Then
      UpdtEdit.Text := '이미 통신종료 작업을 하였습니다.!!'
    Else If (UpdtCheckBox.Checked) Then Begin
      Updt_pgm := 'F';
      Updt_T.Terminate;
      Updt_T.Destroy;
      UpdtADOConn.Connected := False;
      UpdtImg.Visible := False;
    End;

    ExitBitBtn.Enabled := True;
  End;
end;

procedure Tahcomm_f.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tahcomm_f.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If ExitBitBtn.Enabled = False Then CanClose := False;
end;

procedure Tahcomm_f.FormDestroy(Sender: TObject);
begin
  ahcomm_f := Nil;
end;

procedure Tahcomm_f.ExitBitBtnClick(Sender: TObject);
begin
  Sleep(1000);
  Close;
end;


end.

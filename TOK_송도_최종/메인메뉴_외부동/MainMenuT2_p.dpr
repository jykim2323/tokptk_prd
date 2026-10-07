program MainMenuT2_p;

uses
  Forms,
  WinProcs,
  SysUtils,
  Controls,
  ActiveX,
  Mainmenu_u in 'MainMenu_u.pas' {MainMenu_f},
  DBSet in 'DBSet.pas' {DM1: TDataModule},
  Frm2100 in 'Frm2100.pas' {Frm_2100},
  Frm6100 in 'Frm6100.pas' {Frm_6100},
  LocaDisp in 'LocaDisp.pas' {LocaDisp_f},
  CellDisp in 'CellDisp.pas' {CellDisp_f},
  Convision_u in 'Convision_u.pas',
  TrakDisp_u in 'TrakDisp_u.pas' {TrakDisp_F},
  ScrcDisp_u in 'ScrcDisp_u.pas' {ScrcDisp_f},
  winlib in '..\FrmLib\winlib.pas',
  FrmPrompt in '..\FrmLib\FrmPrompt.pas' {Frm_Prompt},
  FrmError in '..\FrmLib\FrmError.pas' {Frm_Error},
  Frm3100 in 'Frm3100.pas' {Frm_3100},
  SFrm7100 in 'SFrm7100.pas' {SFrm_7100},
  MastDisp in 'MastDisp.pas' {Mast_Disp},
  Define in 'Define.pas',
  FrmProgress in 'FrmProgress.pas' {Frm_Progress},
  Frm1100 in 'Frm1100.pas' {Frm_1100},
  Frm1300 in 'Frm1300.pas' {Frm_1300},
  SFrm1100 in 'SFrm1100.pas' {SFrm_1100},
  Frm3700 in 'Frm3700.pas' {Frm_3700},
  Frm3300 in 'Frm3300.pas' {Frm_3300},
  Frm4500 in 'Frm4500.pas' {Frm_4500},
  Frm4100 in 'Frm4100.pas' {Frm_4100},
  Frm4400 in 'Frm4400.pas' {Frm_4400},
  SFrm6120 in 'SFrm6120.pas' {SFrm_6120},
  SFrm6110 in 'SFrm6110.pas' {SFrm_6110},
  Frm6200 in 'Frm6200.pas' {Frm_6200},
  SFrm6200 in 'SFrm6200.pas' {SFrm_6200},
  Frm6300 in 'Frm6300.pas' {Frm_6300},
  Frm6400 in 'Frm6400.pas' {Frm_6400},
  Frm8100 in 'Frm8100.pas' {Frm_8100},
  Frm2700 in 'Frm2700.pas' {Frm_2700},
  Frm2200 in 'Frm2200.pas' {Frm_2200},
  Frm2300 in 'Frm2300.pas' {Frm_2300},
  Frm2400 in 'Frm2400.pas' {Frm_2400},
  Frm2500 in 'Frm2500.pas' {Frm_2500},
  Frm3400 in 'Frm3400.pas' {Frm_3400},
  Frm3200 in 'Frm3200.pas' {Frm_3200},
  Frm4300 in 'Frm4300.pas' {Frm_4300},
  Locaupdt_u in 'Locaupdt_u.pas' {LocaUpdt},
  Frm1200 in 'Frm1200.pas' {Frm_1200},
  Frm1500 in 'Frm1500.pas' {Frm_1500},
  Frm4101 in 'Frm4101.pas' {Frm_4101},
  Frm4102 in 'Frm4102.pas',
  Frm4103 in 'Frm4103.pas' {Frm_4103},
  Frm6500 in 'Frm6500.pas' {Frm_6500},
  Frm7100 in 'Frm7100.pas' {Frm_7100},
  Frm6700 in 'Frm6700.pas' {Frm_6700},
  Frm6600 in 'Frm6600.pas' {Frm_6600},
  Frm3120 in 'Frm3120.pas' {Frm_3120},
  Frm6800 in 'Frm6800.pas' {Frm_6800},
  Frm6900 in 'Frm6900.pas' {Frm_6900},
  Frm3800 in 'Frm3800.pas' {Frm_3800},
  LocaAdd_u in 'LocaAdd_u.pas' {LocaAdd},
  Frm3810 in 'Frm3810.pas' {Frm_3810},
  Frm3130 in 'Frm3130.pas' {Frm_3130},
  SFrm6910 in 'SFrm6910.pas' {SFrm_6910},
  SFrm6130 in 'SFrm6130.pas' {SFrm_6130},
  Frm1600 in 'Frm1600.pas' {Frm_1600},
  Frm6450 in 'Frm6450.pas' {Frm_6450},
  Frm6550 in 'Frm6550.pas' {Frm_6550},
  Frm3900 in 'Frm3900.pas' {Frm_3900};

{$R *.res}

var Mutex_Check : THandle;

begin
  Mutex_Check :=  CreateMutex(nil, True, 'MainMenuT2_p');
  if (Mutex_Check <> 0) and (GetLastError = 0) then
  begin
    CoInitialize(nil);
    Application.Initialize;
    DM1 := TDM1.Create(Application);
    Frm_Progress := TFrm_Progress.Create(Application);
    if Frm_Progress.ShowModal = mrOK  Then
    Begin
        Frm_Progress.Hide;
        Frm_Progress.Free;
        Application.Initialize;
        Application.Title := '메인메뉴';
        Application.CreateForm(TMainMenu_f, MainMenu_f);
  Application.CreateForm(TLocaDisp_f, LocaDisp_f);
  Application.CreateForm(TCellDisp_f, CellDisp_f);
  Application.CreateForm(TLocaAdd, LocaAdd);
  Application.Run;
    End    // mrOK
    Else
    Begin
         Frm_Progress.Hide;
         Frm_Progress.Free;
    End;
    if (Mutex_Check <> 0)  then CloseHandle(Mutex_Check);
  end;
end.


program AsrsCommT2_p;

uses
  Forms,
  Windows,
  ahcomm_u in 'ahcomm_u.pas' {ahcomm_f},
  Convision_u in 'Convision_u.pas',
  ahsrc1_u in 'ahsrc1_u.pas',
  ahsrc2_u in 'ahsrc2_u.pas',
  ahsrc3_u in 'ahsrc3_u.pas',
  ahupdt_u in 'ahupdt_u.pas',
  ahcvc1_u in 'ahcvc1_u.pas',
  ahcvc2_u in 'ahcvc2_u.pas',
  ahcvc3_u in 'ahcvc3_u.pas',
  ahbcr1_u in 'ahbcr1_u.pas',
  ahbcr2_u in 'ahbcr2_u.pas',
  ahbcr3_u in 'ahbcr3_u.pas';

{$R *.res}
var Mutex  : THandle;

begin
  Mutex := CreateMutex(nil, True, 'AsrsCommT2_p');
  if (Mutex <> 0) and (GetLastError = 0) then
  begin
    Application.Initialize;
    Application.Title := '외부동자동창고통신';
    Application.CreateForm(Tahcomm_f, ahcomm_f);
  Application.Run;
    if Mutex <> 0 then CloseHandle(Mutex);
  end;
end.

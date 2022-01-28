program basic_maybe;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  DFE.Maybe in '..\..\..\src\DFE.Maybe.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

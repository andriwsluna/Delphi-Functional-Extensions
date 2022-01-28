program result_basic_example;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {Form1},
  DFE.Result in '..\..\..\src\DFE.Result.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

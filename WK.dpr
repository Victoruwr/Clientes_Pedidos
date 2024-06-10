program WK;

uses
  Vcl.Forms,
  Unit4 in 'Unit4.pas' {Form4},
  uModelLog in 'uModelLog.pas',
  uModelException in 'uModelException.pas',
  uModelConfiguracao in 'uModelConfiguracao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

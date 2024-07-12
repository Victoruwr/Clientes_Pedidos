program WK;
uses
  Vcl.Forms,
  uView in 'uView.pas' {FMain},
  uModelLog in 'uModelLog.pas',
  uModelException in 'uModelException.pas',
  uModelConfiguracao in 'uModelConfiguracao.pas',
  uModelConexaoFiredac in 'uModelConexaoFiredac.pas',
  uModelSQL in 'uModelSQL.pas',
  uControllerPedido in 'uControllerPedido.pas',
  uModelPedido in 'uModelPedido.pas',
  uModelprodutos in 'uModelprodutos.pas';

{$R *.res}
begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.

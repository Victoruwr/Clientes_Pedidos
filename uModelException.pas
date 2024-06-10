unit uModelException;

interface
  uses
  System.SysUtils,
  System.Classes,
  Forms,
  Vcl.Dialogs,
  uModelLog ;

  type
   TModelException  = class
   private
   public
      constructor create;
      Destructor Destroy; override;
      procedure ProcException(sender: Tobject; E:exception=nil);
   end;

var
  ModelException: TModelException;

implementation

 { TModelException }

constructor TModelException.create;
begin
  Application.OnException := ProcException;
end;

destructor TModelException.Destroy;
begin

  inherited;
end;

procedure TModelException.ProcException(sender: Tobject; E: exception);
begin
  with  TModelLog.GetInstance do
  begin
    if Tcomponent(sender) is TForm then
    begin
      Gravarlog('Form    : ' + TForm(sender).Name);
      Gravarlog('Caption : ' + TForm(sender).Caption);
      Gravarlog('Caption : ' + E.ClassName);
      Gravarlog('Erros   : ' + E.Message);
      Gravarlog(sLineBreak);
    end
    else
    begin
      Gravarlog('Form    : ' + TForm(TComponent(sender).Owner).Name);
      Gravarlog('Caption : ' + TForm(TComponent(sender).Owner).Caption);
      Gravarlog('Caption : ' + E.ClassName);
      Gravarlog('Erros   : ' + E.Message);
      Gravarlog(sLineBreak);
    end;
  end;

  MessageDlg(E.Message, mtError, [mbok], 0);
end;


initialization
  ModelException := TModelException.create;

finalization
  ModelException.Destroy;


end.

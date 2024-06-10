unit uModelConfiguracao;

interface
   uses
   System.SysUtils,
   System.IniFiles,
   System.JSON,
   System.classes;

Type TmodelConfiguracao =class
 private
   FINI  : TInifile;
   FDatabase: string;
   FUserName: string;
   FServer: string;
   FPort: string;
   FPassword: string;
   FCaminhoDLL: string;
   class procedure ReleaseInstance();
   class var F_Instance :  TmodelConfiguracao;
   procedure SetDatabase(const Value: string);
   procedure SetUserName(const Value: string);
   procedure SetServer(const Value: string);
   procedure SetPort(const Value: string);
   procedure SetPassword(const Value: string);
   procedure SetCaminhoDLL(const Value: string);
 public
   constructor Create;
   Destructor Destroy; Override;
   Class function GetInstance():TmodelConfiguracao;
   property Database :string  read FDatabase write SetDatabase;
   property UserName :string  read FUserName write SetUserName;
   property Server :string read FServer write SetServer;
   property Port :string read FPort write SetPort;
   property Password :string read FPassword write SetPassword;
   property CaminhoDLL:string  read FCaminhoDLL write SetCaminhoDLL;
end;


implementation

{ TmodelConfiguracao }

constructor TmodelConfiguracao.Create;
begin
  if not assigned(FINI)
     then FINI := TIniFile.Create(ChangeFileExt(ParamStr(0), '.INI'));
end;

destructor TmodelConfiguracao.Destroy;
begin
  if assigned(FINI)
     then FINI.Free;
  inherited;
end;

class function TmodelConfiguracao.GetInstance: TmodelConfiguracao;
begin
  if not assigned(F_Instance)
     then  F_Instance := self.Create;

  Result := F_Instance;
end;

class procedure TmodelConfiguracao.ReleaseInstance;
begin
   if Assigned(Self.F_Instance)
     then Self.F_Instance.Free;
end;


procedure TmodelConfiguracao.SetCaminhoDLL(const Value: string);
begin
  FCaminhoDLL := Value;
end;

procedure TmodelConfiguracao.SetDatabase(const Value: string);
begin
  FDatabase := Value;
end;

procedure TmodelConfiguracao.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TmodelConfiguracao.SetPort(const Value: string);
begin
  FPort := Value;
end;

procedure TmodelConfiguracao.SetServer(const Value: string);
begin
  FServer := Value;
end;

procedure TmodelConfiguracao.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

Initialization
Finalization
  TmodelConfiguracao.ReleaseInstance;
end.

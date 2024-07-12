unit uModelConfiguracao;
interface
   uses
   uModelException,
   System.SysUtils,
   System.IniFiles,
   System.classes,
   Forms;

Type TmodelConfiguracao =class
 private
   FINI  : TInifile;
   FDriverID: String;
   FDatabase: string;
   FUserName: string;
   FServer: string;
   FPort: Integer;
   FPassword: string;
   FCaminhoDLL: string;
   class procedure ReleaseInstance();
   class var F_Instance :  TmodelConfiguracao;
   procedure SetDatabase(const Value: string);
   procedure SetUserName(const Value: string);
   procedure SetServer(const Value: string);
   procedure SetPort(const Value: Integer);
   procedure SetPassword(const Value: string);
   procedure SetCaminhoDLL(const Value: string);
    procedure SetDriverID(const Value: String);
 public
   constructor Create;
   Destructor Destroy; Override;
   Class function GetInstance():TmodelConfiguracao;
   procedure carregaINI;
   property DriverID : String read FDriverID write SetDriverID;
   property Database :string  read FDatabase write SetDatabase;
   property UserName :string  read FUserName write SetUserName;
   property Server :string read FServer write SetServer;
   property Port :integer read FPort write SetPort;
   property Password :string read FPassword write SetPassword;
   property CaminhoDLL:string  read FCaminhoDLL write SetCaminhoDLL;
//   const MYSQLDLL = 'LIBMYSQL.DLL';
end;
implementation
{ TmodelConfiguracao }
procedure TmodelConfiguracao.carregaINI;
begin
  FDriverID   :=  FINI.readString('Conexao','DriverID','');
  FCaminhoDLL :=  FINI.readString('Conexao','CaminhoDLL','');
  FDatabase   :=  FINI.readString('Conexao','Database','');
  FPassword   :=  FINI.readString('Conexao','Password','');
  FPort       :=  FINI.readinteger('Conexao','Port',3306);
  FServer     :=  FINI.readString('Conexao','Server','');
  FUserName   :=  FINI.readString('Conexao','UserName','');
end;

constructor TmodelConfiguracao.Create;
var ini:string ;
begin
  ini := ChangeFileExt(ParamStr(0), '.INI');

  if not FileExists(ini) then halt(0);

  if not assigned(FINI)
     then FINI := TIniFile.Create(ini);
  carregaINI;
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
  FINI.WriteString('Conexao','CaminhoDLL',Value);
  FCaminhoDLL :=  FINI.readString('Conexao','CaminhoDLL','');
end;
procedure TmodelConfiguracao.SetDatabase(const Value: string);
begin
  FINI.WriteString('Conexao','Database',Value);
  FDatabase :=  FINI.readString('Conexao','Database','');
end;
procedure TmodelConfiguracao.SetDriverID(const Value: String);
begin
  FINI.WriteString('Conexao','DriverID',Value);
  FDriverID :=  FINI.readString('Conexao','DriverID','');
end;

procedure TmodelConfiguracao.SetPassword(const Value: string);
begin
  FINI.WriteString('Conexao','Password',Value);
  FPassword :=  FINI.readString('Conexao','Password','');
end;
procedure TmodelConfiguracao.SetPort(const Value: Integer);
begin
  FINI.WriteInteger('Conexao','Port',Value);
  FPort :=  FINI.readinteger('Conexao','Port',3306);
end;
procedure TmodelConfiguracao.SetServer(const Value: string);
begin
  FINI.WriteString('Conexao','Server',Value);
  FServer :=  FINI.readString('Conexao','Server','');
end;
procedure TmodelConfiguracao.SetUserName(const Value: string);
begin
  FINI.WriteString('Conexao','UserName',Value);
  FUserName :=  FINI.readString('Conexao','UserName','');
end;
Initialization
Finalization
  TmodelConfiguracao.ReleaseInstance;
end.

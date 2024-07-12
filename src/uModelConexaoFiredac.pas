unit uModelConexaoFiredac;

interface
    uses
     uModelConfiguracao,
     uModelException,
     uModelLog,
     Data.DB,
     System.SysUtils,
     FireDAC.Phys.MySQL,
     FireDAC.Stan.Intf,
     FireDAC.Stan.Option,
     FireDAC.Stan.Error,
     FireDAC.Comp.Client;

 Type TModelFiredacConexao = class
    private
     FConfiguracao: TmodelConfiguracao;
     FMysqlDriverLink : TFDPhysMySQLDriverLink;
     FConexao: TFDConnection;
     class   procedure ReleaseInstance();
     class var F_Instance :  TModelFiredacConexao;
    public
      constructor create;
      destructor Destroy;override;
      Class function GetInstance():TModelFiredacConexao;
      procedure FechaConexao;
      Function AbrirConexao:boolean;
      property Conexao : TFDConnection read FConexao;
      property MysqlDriverLink :TFDPhysMySQLDriverLink read FMysqlDriverLink;
 end;
implementation

{ TModelFiredacConexao }

Function TModelFiredacConexao.AbrirConexao:Boolean;
begin

  Result:= true;
  FConfiguracao.carregaINI;
  try
    FConexao.Params.Clear;
    FConexao.DriverName := 'MySQL';
    with FConexao.Params,FConfiguracao  do
     Begin
       Add('DriverID=' + DriverID);
       Add('Server=' + Server);
       Add('Port=' + inttostr(Port));
       Add('Database=' + Database);
       Add('User_Name=' + UserName);
       Add('Password=' + Password);
     end;

    with MysqlDriverLink,FConfiguracao  do
     begin
       DriverID  :=  DriverID;
       VendorLib := CaminhoDLL;
     end;

    FConexao.Connected :=True;
  except
    On E: Exception do
    begin
      Result:=false;
      raise Exception.Create('Não foi possível relizar a Conexão com o Banco de dados Mysql.'+#13#10+E.Message);
    end;
  end;
end;


constructor TModelFiredacConexao.create;
begin
  FConfiguracao :=  TmodelConfiguracao.GetInstance;
  FConexao      := TFDConnection.Create(nil);
  FMysqlDriverLink := TFDPhysMySQLDriverLink.Create(nil);

  FConexao.TxOptions.AutoCommit:=false;
  FConexao.TxOptions.AutoStart:=FALSE;
  FConexao.TxOptions.AutoStop:=FALSE;
  FConexao.UpdateOptions.AutoCommitUpdates:=FALSE;
end;

destructor TModelFiredacConexao.Destroy;
begin
  FConexao.free;
  FMysqlDriverLink.Free;
  inherited;
end;

procedure TModelFiredacConexao.FechaConexao;
begin
  FConexao.Connected:=false;

end;

class function TModelFiredacConexao.GetInstance: TModelFiredacConexao;
begin
  if not assigned(F_Instance)
     then  F_Instance := self.Create;
  Result := F_Instance;
end;

class procedure TModelFiredacConexao.ReleaseInstance;
begin
  if Assigned(Self.F_Instance)
     then Self.F_Instance.Free;
end;



end.

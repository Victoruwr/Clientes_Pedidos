unit uModelSQL;

interface
  uses
  uModelConexaoFiredac,
  uModelException,
  Data.DB,
  DBClient,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

  Type TSQL = class
    private
      FConexao  :TModelFiredacConexao;
      Fquery    :TFDQuery;
      class procedure ReleaseInstance();
      class var F_Instance :  TSQL;
    public
     constructor create;
     destructor  Destroy;override;
     Class function GetInstance():TSQL;
     function NewDataSQL(aSQL : String) : TClientDataset;
     procedure ExecSQL(aSQL:String) ;
     procedure RollbackTransaction;
     procedure CommitTransaction;
     procedure StartTransaction;
  end;
implementation

uses
  System.SysUtils;

{ TModelSQL }

procedure TSQL.CommitTransaction;
begin
  if FConexao.Conexao.Connected then
  begin
    FConexao.Conexao.Commit;
    FConexao.FechaConexao;
  end;
end;

constructor TSQL.create;
begin
  FConexao :=  TModelFiredacConexao.GetInstance;
  Fquery  := TFDQuery.Create(nil);
  Fquery.Connection :=  FConexao.Conexao;
end;

destructor TSQL.Destroy;
begin
  Fquery.Free;
  FConexao.Destroy;
  inherited;
end;

procedure TSQL.ExecSQL(aSQL: String);
begin
  if not FConexao.Conexao.Connected
     then StartTransaction;

  Fquery.ExecSQL(aSQL);
end;

class function TSQL.GetInstance: TSQL;
begin
  if not assigned(F_Instance)
     then  F_Instance := self.Create;
  Result := F_Instance;
end;

class procedure TSQL.ReleaseInstance;
begin
  if Assigned(Self.F_Instance)
     then Self.F_Instance.Free;
end;

procedure TSQL.RollbackTransaction;
begin
  if FConexao.Conexao.Connected then
  begin
    FConexao.Conexao.Rollback;
    FConexao.FechaConexao;
  end;
end;

procedure TSQL.StartTransaction;
begin
  if not FConexao.Conexao.Connected
     then FConexao.AbrirConexao;
  FConexao.Conexao.StartTransaction;
end;

function TSQL.NewDataSQL(aSQL: String): TClientDataset;
 var i:integer;
begin
  Result := TClientDataSet.Create(nil);

  if not FConexao.Conexao.Connected
     then  StartTransaction;
  try
    Fquery.Open(aSQL);
    Fquery.FetchAll;

    for i:= 0 to pred(Fquery.FieldCount) do
    begin
      with Result.FieldDefs.AddFieldDef do
      begin
        Name:=Fquery.Fields[i].FieldName;
        DataType:=Fquery.Fields[i].DataType;
        if (Fquery.Fields[i].DataType =ftString) then Size := 250;
      end;
    end;

    Result.CreateDataSet;

    Result.Active:=true;
    while not FQuery.Eof do
     begin
       Result.Append;
       for I := 0 to pred(FQuery.fields.count) do
        Result.Fields[i].Value := FQuery.Fields[i].Value;
       Result.Post;

       FQuery.Next;
     end;

    Result.First;
    FConexao.FechaConexao;
 except
   On E:exception do
   begin
     freeandnil(Result);
   end;

  end;

end;

end.

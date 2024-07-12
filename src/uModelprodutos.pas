unit uModelProdutos;

interface
uses System.Classes;
 Type
   TProduto = class;
   Tprodutos = class;

   TProdutos = class(TCollection)
    private
    function GetItem(Index: integer): TProduto;
    procedure SetItem(Index: integer; const Value: TProduto);
    public
      constructor Create;
      function Add:TProduto;
      property Items[Index: integer]: TProduto read GetItem write SetItem; default;
   end;

   TProduto = class(TCollectionItem)
    private
    FCodigo: Longint;
    FQuantidade: Double;
    FVlr_Unitario: currency;
    FValor_Total: currency;
    procedure SetQuantidade(const Value: Double);
    procedure SetVlr_Unitario(const Value: currency);
    procedure SetValor_Total(const Value: currency);
    procedure SetCodigo(const Value: Longint);
    public
       constructor Create(AOwner:TCollection);override;
       destructor Destroy; override;
       property Codigo : Longint read FCodigo write SetCodigo;
       property Quantidade : Double read FQuantidade write SetQuantidade;
       property Vlr_Unitario: currency read FVlr_Unitario write SetVlr_Unitario;
       property Valor_Total : currency read FValor_Total write SetValor_Total;
  end;

implementation

constructor TProduto.Create(AOwner: TCollection);
begin
  inherited Create(AOwner);
end;

destructor TProduto.Destroy;
begin

  inherited Destroy;
end;

procedure TProduto.SetCodigo(const Value: Longint);
begin
  FCodigo := Value;
end;

procedure TProduto.SetQuantidade(const Value: Double);
begin
  FQuantidade := Value;
end;

procedure TProduto.SetValor_Total(const Value: currency);
begin
  FValor_Total := Value;
end;

procedure TProduto.SetVlr_Unitario(const Value: currency);
begin
  FVlr_Unitario := Value;
end;

{ TModelProdutos }

function TProdutos.Add: TProduto;
begin
  Result := TProduto(inherited Add);
end;

constructor TProdutos.Create;
begin
  inherited Create(TProduto);
end;

function TProdutos.GetItem(Index: integer): TProduto;
begin
  Result := TProduto(inherited GetItem(Index));
end;

procedure TProdutos.SetItem(Index: integer; const Value: TProduto);
begin
  inherited SetItem(index,value);
end;

end.

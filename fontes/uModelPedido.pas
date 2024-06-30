unit uModelPedido;

interface
   uses
    uModelprodutos,
    uModelException,
    System.SysUtils,
    System.Classes;


   Type TPedido = class
    private
    FNum_Pedido: longint;
    FValor_Total: Currency;
    FDt_Emissao: Tdatetime;
    FCod_Cliente: longInt;
    FProdutos: Tprodutos;
    procedure SetNum_Pedido(const Value: longint);
    procedure SetCod_Cliente(const Value: longInt);
    procedure SetDt_Emissao(const Value: Tdatetime);
    procedure SetProdutos(const Value: Tprodutos);
    procedure SetValor_Total(const Value: Currency);
     public
        constructor create;
        destructor Destroy ;override;
        property Num_Pedido : longint read FNum_Pedido write SetNum_Pedido;
        property Produtos : Tprodutos read FProdutos write SetProdutos;
        property Cod_Cliente: longInt read FCod_Cliente write SetCod_Cliente;
        property Dt_Emissao : Tdatetime read FDt_Emissao write SetDt_Emissao;
        property Valor_Total: Currency read FValor_Total write SetValor_Total;
   end;

implementation

{ TPedido }

constructor TPedido.create;
begin
  Produtos := TProdutos.Create;
end;

destructor TPedido.Destroy;
begin
  Produtos.Destroy;
end;


procedure TPedido.SetCod_Cliente(const Value: longInt);
begin
  FCod_Cliente := Value;
end;

procedure TPedido.SetDt_Emissao(const Value: Tdatetime);
begin
  FDt_Emissao := Value;
end;

procedure TPedido.SetNum_Pedido(const Value: longint);
begin
  FNum_Pedido := Value;
end;

procedure TPedido.SetProdutos(const Value: Tprodutos);
begin
  FProdutos := Value;
end;

procedure TPedido.SetValor_Total(const Value: Currency);
begin
  FValor_Total := Value;
end;

end.

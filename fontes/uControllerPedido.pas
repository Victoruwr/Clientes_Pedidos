unit uControllerPedido;

interface
     uses
     uModelException,
     uModelSQL,
     uModelPedido,
     DBClient;

Type
  pTypeEntitySQL = (tSQLClientes,tSQLProdutos,tSQLPedidos,tSQLPedidoProdutos,tNewPedidoProduto);
//  pSearchMaxPK   = (tSQLMaxCliente,tSQLMaxProduto,tSQLMaxPedido);
  TControllerPP  = class
  private
    FSQL: TSQL;
    FPedido: TPedido;
     { Algumas Funções de Formatação}
    function formataValues(value:currency):string; overload;
    function formataValues(value:Double):string; overload;
    Function FormatarDate(Data:TDateTime):string;
  public
     constructor create;
     destructor destroy ;override;
     Function NewDataset(Tipo:pTypeEntitySQL;aWhereParams : string=''):TClientDataset;
     Function MaxPK(Tipo:pTypeEntitySQL):LongInt;
     Function GravaPedido:LongInt;
     Function ApagaPedido(NPedido:string):boolean;
     property Pedido: TPedido  read FPedido ;
end;

implementation

uses
  System.SysUtils;

{ TControllerPP }

function TControllerPP.ApagaPedido(Npedido:string): boolean;
begin
  Result:=true;
  try
    FSQL.StartTransaction;
    FSQL.ExecSQL('DELETE FROM PEDIDOS_PRODUTOS WHERE NUMERO_PEDIDO ='+Npedido);
    FSQL.ExecSQL('DELETE FROM PEDIDOS_DADOS_GERAIS WHERE NUMPEDIDO ='+Npedido);
    FSQL.CommitTransaction;
  except
    On E:exception do
    begin
      Result:=false;
      FSQL.RollbackTransaction;
      raise Exception.Create('Erro apagar pedido'+sLineBreak+E.Message);
    end;
  end;
end;

constructor TControllerPP.create;
begin
 FSQL  := TSQL.GetInstance;
 FPedido := TPedido.create;
end;

destructor TControllerPP.destroy;
begin
  FSQL.Destroy;
  FPedido.Destroy;
  inherited;
end;

function TControllerPP.formataValues(value: currency): string;
begin
  Result := StringReplace(CurrToStr(value),',','.',[rfReplaceAll]);
end;

function TControllerPP.FormatarDate(Data: TDateTime): string;
begin
  Result := FormatDateTime('YYYY-MM-DD HH:MM:SS',Data);
end;

function TControllerPP.formataValues(value: Double): string;
begin
  Result := StringReplace(FloatToStr(value),',','.',[rfReplaceAll]);
end;

function TControllerPP.GravaPedido: LongInt;
var I:integer;
Max:LongInt;
begin
  Result:=0;
  IF Pedido.Produtos.Count = 0 then exit;
  try
    FSQL.StartTransaction;
    FSQL.ExecSQL('INSERT INTO PEDIDOS_DADOS_GERAIS '+
                 '(Data_Emissao,Cod_Cliente,Valor_Total) '+
                 'VALUES ('+
                 quotedstr(FormatarDate(Pedido.Dt_Emissao))+', '+
                 inttostr(Pedido.Cod_Cliente)+', '+
                 formataValues(Pedido.Valor_Total)+')');

    max := MaxPK(tSQLPedidos);

    for I := 0 to pred(Pedido.Produtos.Count) do
    begin
      FSQL.ExecSQL('INSERT INTO PEDIDOS_PRODUTOS '+
                   '(Numero_pedido,Cod_Produto,Quantidade,Vlr_Unitario,Vlr_Total) '+
                   'VALUES ('+
                   IntToStr(max)+', '+
                   inttostr(Pedido.Produtos.Items[I].Codigo)+', '+
                   formataValues(Pedido.Produtos.Items[I].Quantidade)+', '+
                   formataValues(Pedido.Produtos.Items[I].Vlr_Unitario)+', '+
                   formataValues(Pedido.Produtos.Items[I].Valor_Total)+')');
    end;

    FSQL.CommitTransaction;
    result := max;
  except
    On E:exception do
    begin
      Result:=0;
      FSQL.RollbackTransaction;
      raise Exception.Create('Erro ao gravar pedido'+sLineBreak+E.Message);
    end;
  end;
end;

function TControllerPP.MaxPK(Tipo: pTypeEntitySQL): LongInt;
var Dt: TClientDataset;
Max:LongInt;
begin
  case Tipo of
    tSQLPedidos :
    begin
      Dt := FSQL.NewDataSQL('SELECT COALESCE(MAX(NUMPEDIDO),0) '+
                            'FROM PEDIDOS_DADOS_GERAIS');

      Max :=Dt.Fields[0].AsInteger;
      Dt.Free;
    end;
  end;
  result := Max;
end;

function TControllerPP.NewDataset(Tipo: pTypeEntitySQL;
  aWhereParams: string): TClientDataset;
var Params:string;
begin
  Params :=  aWhereParams;

  if Params <> emptystr
     then Params :=  ' WHERE '+ Params  ;

  case Tipo of
    tSQLClientes:
    begin
      result := FSQL.NewDataSQL('SELECT '+
                                'CODIGO, '+
                                'NOME, '+
                                'CIDADE, '+
                                'UF '+
                                'FROM CLIENTES '+
                                Params);
    end;

    tSQLProdutos:
    begin
      result := FSQL.NewDataSQL('SELECT '+
                                'CODIGO, '+
                                'DESC_PRODUTO, '+
                                'PRECO_VENDA '+
                                'FROM PRODUTOS '+
                                Params);
    end;

    tSQLPedidos:
    begin
//
    end;

    tNewPedidoProduto:
    begin
      result := FSQL.NewDataSQL('SELECT '+
                                'PP.COD_PRODUTO, '+
                                'P.DESC_PRODUTO, '+
                                'PP.QUANTIDADE, '+
                                'PP.VLR_UNITARIO, '+
                                'PP.VLR_TOTAL '+
                                'FROM PEDIDOS_PRODUTOS PP '+
                                'JOIN PRODUTOS P ON (PP.COD_PRODUTO = P.CODIGO) '+
                                'WHERE PP.ID = NULL');
    end;

    tSQLPedidoProdutos:
    begin
      result := FSQL.NewDataSQL('SELECT '+
                                'PP.NUMERO_PEDIDO, '+
                                'PDG.COD_CLIENTE, '+
                                'C.NOME, '+
                                'PP.COD_PRODUTO, '+
                                'P.DESC_PRODUTO, '+
                                'PP.QUANTIDADE, '+
                                'PP.VLR_UNITARIO, '+
                                'PP.VLR_TOTAL '+
                                'FROM PEDIDOS_PRODUTOS PP '+
                                'JOIN PRODUTOS P ON (PP.COD_PRODUTO = P.CODIGO) '+
                                'JOIN PEDIDOS_DADOS_GERAIS PDG ON (PDG.NUMPEDIDO = PP.NUMERO_PEDIDO) '+
                                'JOIN CLIENTES C ON (C.CODIGO = PDG.COD_CLIENTE) '+
                                Params);
    end;


  end;
end;

end.

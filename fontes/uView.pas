unit uView;
interface
uses
  uControllerPedido,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Datasnap.DBClient, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.TabNotBk, Vcl.NumberBox;
type
  TFMain = class(TForm)
    Pg: TPageControl;
    TSCliente: TTabSheet;
    TsPedidoVenda: TTabSheet;
    DsClientes: TDataSource;
    PnlRodape: TPanel;
    BtnVoltar: TButton;
    BtnSeguir: TButton;
    PnlProdDispo: TPanel;
    PnlPedido: TPanel;
    GridPedidoProduto: TDBGrid;
    Splitter1: TSplitter;
    PnlProdDispCabecalho: TPanel;
    PnlPedidocabecalho: TPanel;
    PnlInsereproduto: TPanel;
    DsProdutos: TDataSource;
    NEditCodigoProd: TNumberBox;
    PnlInsereProdutosCab: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    NEditQuantidade: TNumberBox;
    Label4: TLabel;
    NEditVlrUnitario: TNumberBox;
    BtnInsere: TButton;
    DsPedidoProduto: TDataSource;
    PnlCleinteCabecalho: TPanel;
    PnlCentral: TPanel;
    BtnSelecionar: TButton;
    SHapeCleinte: TShape;
    GridClentes: TDBGrid;
    Panel1: TPanel;
    BtnGravar: TButton;
    NEditCodigoCli: TNumberBox;
    Label7: TLabel;
    PnlInf: TPanel;
    Label1: TLabel;
    LbCliente: TLabel;
    Label5: TLabel;
    LbTotpedido: TLabel;
    BtnPedidoAnt: TButton;
    BtnApagaPedido: TButton;
    GridProdutos: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure BtnVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnSeguirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnSelecionarClick(Sender: TObject);
    procedure PgChange(Sender: TObject);
    procedure BtnInsereClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure GridPedidoProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridPedidoProdutoColExit(Sender: TObject);
    procedure GridprodutosCellClick(Column: TColumn);
    procedure GridClentesCellClick(Column: TColumn);
    procedure GridClentesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnPedidoAntClick(Sender: TObject);
    procedure BtnApagaPedidoClick(Sender: TObject);
    procedure NEditCodigoCliChange(Sender: TObject);
    procedure GridProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FControllerPP : TControllerPP;
    Reaproveitamento_pedido:boolean;
     procedure PesquisaCliente;
     procedure AfterScrollCliente(DataSet: TDataSet);
     procedure PesquisaProdutos;
     procedure AfterScrollprodutos(DataSet: TDataSet);
     procedure AbrirDatasetPedidoProduto;
     procedure BeforePostPedidoProduto(DataSet: TDataSet);
     procedure AfterPostPedidoProduto(DataSet: TDataSet);
     procedure AfterDeletePedidoProduto(DataSet: TDataSet);
     function ValidarComponente(var objeto: Tcomponent):boolean;
     procedure CalculaVlrTotPeiddo;
     procedure LimpaObjetos;
     procedure LimpaCampos;
     procedure EditaGridProdutospedido(aVale:boolean);
     procedure ConfiguraGrid(var objeto: Tcomponent);
     function GridProdutospedidoEdicao:boolean;
     procedure CarregaPedidoPorNumero(aValue: string);
     procedure ApagarPedidoPorNumero(aValue: string);
  public

  end;
var
  FMain: TFMain;
implementation

uses
  Vcl.Dialogs;
{$R *.dfm}


procedure TFMain.AbrirDatasetPedidoProduto;
var dt : TClientDataSet;
begin
  with GridPedidoProduto.DataSource, FControllerPP do
  begin
    if assigned(DataSet)
     then DataSet.DisposeOf;
    dt:= NewDataset(tNewPedidoProduto);
    dt.EmptyDataSet;
    DataSet := dt;
    Dataset.BeforePost := BeforePostPedidoProduto;
    Dataset.AfterPost  := AfterPostPedidoProduto;
    Dataset.AfterDelete := AfterDeletePedidoProduto;
  end;
  CalculaVlrTotPeiddo;
end;

procedure TFMain.AfterDeletePedidoProduto(DataSet: TDataSet);
begin
  CalculaVlrTotPeiddo;
end;

procedure TFMain.AfterPostPedidoProduto(DataSet: TDataSet);
begin
  CalculaVlrTotPeiddo;
end;

procedure TFMain.AfterScrollCliente(DataSet: TDataSet);
begin
  NEditCodigoCli.ValueInt := DataSet.FieldByName('CODIGO').asinteger;
end;

procedure TFMain.AfterScrollprodutos(DataSet: TDataSet);
begin
  NEditCodigoProd.ValueInt       := DataSet.FieldByName('CODIGO').asinteger;
  NEditQuantidade.ValueFloat     := 1;
  NEditVlrUnitario.ValueCurrency := DataSet.FieldByName('PRECO_VENDA').AsCurrency;
end;

procedure TFMain.ApagarPedidoPorNumero(aValue: string);
var dados:TClientDataSet;
begin
  try
    with GridPedidoProduto.DataSource,FControllerPP do
    begin
      if assigned(DataSet) then DataSet.DisposeOf;
      dados := NewDataset(tSQLPedidoProdutos,'PP.NUMERO_PEDIDO='+aValue+' ORDER BY PP.COD_PRODUTO');
      if dados.IsEmpty then
      begin
        Reaproveitamento_pedido:=false;
        showmessage('Não existe pedido informado!');
        exit;
      end;

      if ApagaPedido(aValue) then showmessage('Pedido: '+aValue+' apagado com sucesso!');
    end;
  finally
    if assigned(dados) then dados.DisposeOf;
  end;
end;

procedure TFMain.BtnApagaPedidoClick(Sender: TObject);
var NPedido:string;
    ClickedOK,okConvert: Boolean;
begin
  repeat
     ClickedOK := InputQuery('Cancelamento de Pedido','Entre com o Nº de um pedido:',NPedido);
     if ClickedOK then
     try
       try
         if NPedido ='0' then raise Exception.Create('Não é permitido informar número zerado!');
         strtoint(Npedido);
         okConvert :=true;
       except
          raise Exception.Create('Somente valores numéricos!');
       end;
     except
     end;
  until ((okConvert)or(not ClickedOK));

  if ClickedOK and okConvert then ApagarPedidoPorNumero(Npedido);
end;

procedure TFMain.BtnGravarClick(Sender: TObject);
var I:integer;
Total:currency;
NPedidoGravado:longint;
begin
  NPedidoGravado :=0;
  Total := 0 ;
  I:=0;
  with FControllerPP,GridPedidoProduto.DataSource do
   begin
     Pedido.Cod_Cliente := GridClentes.DataSource.DataSet.FieldByName('CODIGO').AsLargeInt;
     Pedido.Dt_Emissao := Now;

     Dataset.First;
     while not Dataset.Eof do
     begin
       Pedido.Produtos.Add;
       Pedido.Produtos[i].Codigo :=GridPedidoProduto.DataSource.dataset.FieldByName('COD_PRODUTO').AsLargeInt;
       Pedido.Produtos[i].Quantidade := GridPedidoProduto.DataSource.dataset.FieldByName('QUANTIDADE').AsFloat;
       Pedido.Produtos[i].Vlr_Unitario :=  dataset.FieldByName('VLR_UNITARIO').AsCurrency;
       Pedido.Produtos[i].Valor_Total :=  dataset.FieldByName('VLR_TOTAL').AsCurrency;
       Total := Total +  Pedido.Produtos[i].Valor_Total;
       Dataset.Next;
       inc(i);
     end;
     Pedido.Valor_Total := Total ;

     if Pedido.Produtos.Count = 0 then
     begin
       ShowMessage('Não existem Produtos inseridos.') ;
       exit;
     end;

     NPedidoGravado := GravaPedido ;
     if NPedidoGravado<> 0 then
     begin
       ShowMessage('Pedido: '+inttostr(NPedidoGravado)+' gravado com sucesso.') ;
       LimpaObjetos;
       LimpaCampos;
       CalculaVlrTotPeiddo;
       LbCliente.Caption := 'Nenhum';
       Pg.ActivePage := TSCliente;
       PgChange(sender);
     end;
   end;
end;

procedure TFMain.BtnInsereClick(Sender: TObject);
var i:integer;
begin
  if ValidarComponente(Tcomponent(NEditCodigoProd))  and
     ValidarComponente(Tcomponent(NEditQuantidade))  and
     ValidarComponente(Tcomponent(NEditVlrUnitario)) then
  begin
    with GridPedidoProduto.DataSource do
    begin
      Gridprodutos.DataSource.DataSet.AfterScroll := nil;
      if Gridprodutos.DataSource.DataSet.Locate('CODIGO',NEditCodigoProd.ValueInt,[]) then
      begin
        DataSet.Append;
        DataSet.FieldByName('COD_PRODUTO').AsInteger   := NEditCodigoProd.ValueInt ;
        DataSet.FieldByName('DESC_PRODUTO').Asstring   := Gridprodutos.DataSource.DataSet.FieldByName('DESC_PRODUTO').Asstring;
        DataSet.FieldByName('QUANTIDADE').AsFloat      := NEditQuantidade.ValueFloat;
        DataSet.FieldByName('VLR_UNITARIO').AsCurrency := NEditVlrUnitario.ValueCurrency;
        DataSet.post;

        NEditCodigoProd.SetFocus;
      end
      else
      begin
        NEditCodigoProd.SetFocus;
        raise Exception.Create('Código de Produto não Encontrado!');
      end;
      Gridprodutos.DataSource.DataSet.AfterScroll := AfterScrollprodutos;
    end;
  end;
end;

procedure TFMain.BtnPedidoAntClick(Sender: TObject);
var NPedido:string;
    ClickedOK,okConvert: Boolean;
begin
  NPedido:= '0';
  okConvert:= false;

  repeat
     ClickedOK := InputQuery('Pedidos Gravados Anteriormente','Entre com o Nº de um pedido:',NPedido);
     if ClickedOK then
     try
       try
         if NPedido ='0' then raise Exception.Create('Não é permitido informar número zerado!');
         strtoint(Npedido);
         okConvert :=true;
       except
          raise Exception.Create('Somente valores numéricos!');
       end;
     except
     end;
  until ((okConvert)or(not ClickedOK));

  if ClickedOK and okConvert
     then CarregaPedidoPorNumero(Npedido);
end;

procedure TFMain.BtnSelecionarClick(Sender: TObject);
begin
 if ValidarComponente(Tcomponent(NEditCodigoCli)) then
  begin
    with  GridClentes.DataSource do
    begin
      BtnSeguir.Enabled:= DataSet.Locate('CODIGO',NEditCodigoCli.ValueInt,[]);
      if BtnSeguir.Enabled then
      begin
        LbCliente.Caption := DataSet.FieldByName('NOME').asstring;
        showmessage('Cliente Selecionado: '+LbCliente.Caption);
      end
      else
      begin
        NEditCodigoCli.SetFocus;
        LbCliente.Caption := 'Nenhum';
        raise Exception.Create('Cliente não Encontrado!');
      end ;
    end;
  end ;
end;

procedure TFMain.BtnVoltarClick(Sender: TObject);
begin
  LimpaObjetos;
  LimpaCampos;
  LbCliente.Caption := 'Nenhum';
  pg.ActivePage := TSCliente;
  PgChange(sender);
end;

procedure TFMain.CalculaVlrTotPeiddo;
var tot:currency;
BM: TBookmark;
begin
  tot:=0;
  with GridPedidoProduto.DataSource.DataSet do
  begin
    DisableControls;
    BM :=  GetBookmark;
    First;
    while not eof do
    begin
      tot := tot + FieldByName('VLR_TOTAL').AsCurrency;
      next;
    end;
    GotoBookmark(BM);
    EnableControls;
  end;
  LbTotpedido.Caption  :=  FormatCurr('R$ #,##0.00', tot);
end;

procedure TFMain.CarregaPedidoPorNumero(aValue: string);
var dados:TClientDataSet;
begin
  try
    with GridPedidoProduto.DataSource,FControllerPP do
    begin
      if assigned(DataSet) then DataSet.DisposeOf;
      dados := NewDataset(tSQLPedidoProdutos,'PP.NUMERO_PEDIDO='+aValue+' ORDER BY PP.COD_PRODUTO');
      if dados.IsEmpty then
      begin
        Reaproveitamento_pedido:=false;
        showmessage('Não existe pedido informado!');
        exit;
      end;

      GridClentes.DataSource.DataSet.Locate('CODIGO',dados.FieldByName('COD_CLIENTE').AsLargeInt,[]);
      PesquisaProdutos;
      AbrirDatasetPedidoProduto;
      Gridprodutos.DataSource.DataSet.AfterScroll := nil;

      while not dados.eof do
      begin
        Gridprodutos.DataSource.DataSet.Locate('CODIGO',dados.FieldByName('COD_PRODUTO').AsLargeInt,[]) ;
        DataSet.Append;
        DataSet.FieldByName('COD_PRODUTO').AsInteger   := dados.FieldByName('COD_PRODUTO').AsLargeInt;
        DataSet.FieldByName('DESC_PRODUTO').Asstring   := dados.FieldByName('DESC_PRODUTO').Asstring;
        DataSet.FieldByName('QUANTIDADE').AsFloat      := dados.FieldByName('QUANTIDADE').AsFloat;
        DataSet.FieldByName('VLR_UNITARIO').AsCurrency := dados.FieldByName('VLR_UNITARIO').AsCurrency;
        DataSet.post;
        dados.Next;
      end;

       LbCliente.Caption := dados.FieldByName('NOME').asstring;
       Gridprodutos.DataSource.DataSet.AfterScroll := AfterScrollprodutos;
       Gridprodutos.DataSource.DataSet.AfterScroll(Gridprodutos.DataSource.DataSet);
    end;

    Reaproveitamento_pedido:=true;
    pg.ActivePage := TsPedidoVenda;
    BtnVoltar.Enabled:=true;
    BtnSeguir.Enabled:= false;
    BtnGravar.Enabled:=true;
    PgChange(SELF);

  finally
    if assigned(dados) then dados.DisposeOf;
  end;
end;

procedure TFMain.ConfiguraGrid(var objeto: Tcomponent);
begin
  if Tcomponent(objeto) is TDBGrid then
  begin
    if Tcomponent(objeto).Name = GridClentes.Name then
    begin
      TDBgrid(objeto).FixedColor         := $00525252;
      TDBgrid(objeto).DrawingStyle       := gdsGradient;
      TDBgrid(objeto).GradientStartColor := $00525252;
      TDBgrid(objeto).GradientEndColor   := $00525252;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[0].FieldName := 'CODIGO';
      TDBgrid(objeto).Columns[0].Title.caption := 'Código';
      TDBgrid(objeto).Columns[0].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[0].Width := 80;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[1].FieldName := 'NOME';
      TDBgrid(objeto).Columns[1].Title.caption := 'Nome';
      TDBgrid(objeto).Columns[1].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[1].Width := 200;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[2].FieldName := 'CIDADE';
      TDBgrid(objeto).Columns[2].Title.caption := 'Cidade';
      TDBgrid(objeto).Columns[2].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[2].Width := 150;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[3].FieldName := 'UF';
      TDBgrid(objeto).Columns[3].Title.caption := 'Uf';
      TDBgrid(objeto).Columns[3].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[3].Width := 50;

    end;

    if Tcomponent(objeto).Name = Gridprodutos.Name then
    begin
      TDBgrid(objeto).FixedColor         := $00525252;
      TDBgrid(objeto).DrawingStyle       := gdsGradient;
      TDBgrid(objeto).GradientStartColor := $00525252;
      TDBgrid(objeto).GradientEndColor   := $00525252;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[0].FieldName := 'CODIGO';
      TDBgrid(objeto).Columns[0].Title.caption := 'Código';
      TDBgrid(objeto).Columns[0].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[0].Width := 80;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[1].FieldName := 'DESC_PRODUTO';
      TDBgrid(objeto).Columns[1].Title.caption := 'Desc_Produto';
      TDBgrid(objeto).Columns[1].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[1].Width := 600;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[2].FieldName := 'PRECO_VENDA';
      TDBgrid(objeto).Columns[2].Title.caption := 'Preço de Venda';
      TDBgrid(objeto).Columns[2].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[2].Width := 90;
    end;

    if Tcomponent(objeto).Name = GridPedidoProduto.Name then
    begin
      TDBgrid(objeto).FixedColor         := $00525252;
      TDBgrid(objeto).DrawingStyle       := gdsGradient;
      TDBgrid(objeto).GradientStartColor := $00525252;
      TDBgrid(objeto).GradientEndColor   := $00525252;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[0].FieldName := 'COD_PRODUTO';
      TDBgrid(objeto).Columns[0].Title.caption := 'Cod Produto';
      TDBgrid(objeto).Columns[0].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[0].Width := 80;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[1].FieldName := 'DESC_PRODUTO';
      TDBgrid(objeto).Columns[1].Title.caption := 'Desc_Produto';
      TDBgrid(objeto).Columns[1].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[1].Width := 600;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[2].FieldName := 'QUANTIDADE';
      TDBgrid(objeto).Columns[2].Title.caption := 'Quantidade';
      TDBgrid(objeto).Columns[2].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[2].Width := 90;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[3].FieldName := 'VLR_UNITARIO';
      TDBgrid(objeto).Columns[3].Title.caption := 'Vlr Unitário';
      TDBgrid(objeto).Columns[3].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[3].Width := 70;

      TDBgrid(objeto).Columns.Add;
      TDBgrid(objeto).Columns[4].FieldName := 'VLR_TOTAL';
      TDBgrid(objeto).Columns[4].Title.caption := 'Vlr Total';
      TDBgrid(objeto).Columns[4].Title.Font.Color := clWindow;
      TDBgrid(objeto).Columns[4].Width := 90;


    end;
  end;
end;

procedure TFMain.EditaGridProdutospedido(aVale:boolean);
begin
  if aVale
     then GridPedidoProduto.Options := [dgEditing,dgTitles,dgIndicator,dgColumnResize,dgColLines,dgRowLines,dgTabs,dgConfirmDelete,dgCancelOnExit,dgTitleClick,dgTitleHotTrack]
     else GridPedidoProduto.Options := [dgTitles,dgIndicator,dgColumnResize,dgColLines,dgRowLines,dgTabs,dgConfirmDelete,dgCancelOnExit,dgTitleClick,dgTitleHotTrack] ;
end;

procedure TFMain.BtnSeguirClick(Sender: TObject);
begin
  pg.ActivePage := TsPedidoVenda;
  PgChange(sender);
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if assigned(GridClentes.DataSource.DataSet)
    then GridClentes.DataSource.DataSet.DisposeOf;
 if assigned(Gridprodutos.DataSource.DataSet)
    then Gridprodutos.DataSource.DataSet.DisposeOf;
 if assigned(GridPedidoProduto.DataSource.DataSet)
    then GridPedidoProduto.DataSource.DataSet.DisposeOf;
 FControllerPP.Destroy;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  FControllerPP:= TControllerPP.create;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  pg.Pages[0].TabVisible :=false;
  pg.Pages[1].TabVisible :=false;
  pg.ActivePage := TSCliente;
  PgChange(sender);
end;

procedure TFMain.GridClentesCellClick(Column: TColumn);
begin
  if not Assigned(GridClentes.DataSource.DataSet.AfterScroll) then
  begin
    GridClentes.DataSource.DataSet.AfterScroll := AfterScrollCliente;
    AfterScrollCliente(GridClentes.DataSource.DataSet);
  end
end;

procedure TFMain.GridClentesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Assigned(GridClentes.DataSource.DataSet.AfterScroll) then
  begin
    GridClentes.DataSource.DataSet.AfterScroll := AfterScrollCliente;
    AfterScrollCliente(GridClentes.DataSource.DataSet);
  end
end;

procedure TFMain.GridPedidoProdutoColExit(Sender: TObject);
begin
  if GridPedidoProduto.SelectedIndex in [2,3] then
  begin
    if GridPedidoProduto.DataSource.DataSet.State in [dsedit,dsBrowse] then 
    begin
      EditaGridProdutospedido(false);
      if GridPedidoProduto.DataSource.DataSet.State = dsedit then GridPedidoProduto.DataSource.DataSet.post;
    end;
  end
  else
  begin
    if GridPedidoProduto.DataSource.DataSet.State = dsedit then 
    begin
      GridPedidoProduto.DataSource.DataSet.Cancel;
      EditaGridProdutospedido(false);
    end;
  end;
end;

procedure TFMain.GridPedidoProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key =VK_RETURN then
  begin
    if GridPedidoProduto.SelectedIndex in [2,3] then
    begin
      if GridPedidoProduto.DataSource.DataSet.IsEmpty 
         then exit;
      
      EditaGridProdutospedido(not GridProdutospedidoEdicao);
      if not GridProdutospedidoEdicao
         then GridPedidoProdutoColExit(sender);
    end;
  end;

  if key =VK_ESCAPE then
  begin
    EditaGridProdutospedido(false);
    GridPedidoProduto.DataSource.DataSet.cancel;
  end;
end;

procedure TFMain.GridprodutosCellClick(Column: TColumn);
begin
  if not Assigned(Gridprodutos.DataSource.DataSet.AfterScroll) then
  begin
    Gridprodutos.DataSource.DataSet.AfterScroll := AfterScrollprodutos;
    AfterScrollprodutos(Gridprodutos.DataSource.DataSet);
  end
end;

procedure TFMain.GridProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Assigned(GridProdutos.DataSource.DataSet.AfterScroll) then
  begin
    GridProdutos.DataSource.DataSet.AfterScroll := AfterScrollCliente;
    AfterScrollprodutos(GridProdutos.DataSource.DataSet);
  end
end;

function TFMain.GridProdutospedidoEdicao: boolean;
begin
  result := (dgEditing in GridPedidoProduto.Options  );
end;

procedure TFMain.LimpaCampos;
begin
  NEditCodigoCli.Valueint        := 0;
  NEditCodigoprod.ValueInt       := 0;
  NEditQuantidade.ValueFloat     := 0;
  NEditVlrUnitario.ValueCurrency := 0;
end;

procedure TFMain.LimpaObjetos;
var Dt: TClientDataSet;
begin
  GridClentes.Columns.Clear;
  Gridprodutos.Columns.Clear;
  GridPedidoProduto.Columns.Clear;
  Tdataset(Dt) := GridClentes.DataSource.DataSet;
  Dt.EmptyDataSet;
  Tdataset(Dt) := Gridprodutos.DataSource.DataSet;
  Dt.EmptyDataSet;
  Tdataset(Dt) := GridPedidoProduto.DataSource.DataSet;
  Dt.EmptyDataSet;
  FControllerPP.Pedido.Produtos.Clear;
end;

procedure TFMain.NEditCodigoCliChange(Sender: TObject);
begin
  BtnPedidoAnt.Visible := (NEditCodigoCli.Text =emptystr)or (NEditCodigoCli.Valueint = 0);
  BtnApagaPedido.Visible := (NEditCodigoCli.Text =emptystr)or (NEditCodigoCli.Valueint = 0);
end;

procedure TFMain.PesquisaCliente;
begin
  with GridClentes.DataSource, FControllerPP do
  begin
    if assigned(DataSet)
     then DataSet.DisposeOf;
    DataSet:= NewDataset(tSQLClientes);
    DataSet.AfterScroll :=AfterScrollCliente;
    DataSet.AfterScroll :=nil;
  end;
  ConfiguraGrid(Tcomponent(GridClentes));

end;

procedure TFMain.PesquisaProdutos;
begin
  with Gridprodutos.DataSource, FControllerPP do
  begin
    if assigned(DataSet)
     then DataSet.DisposeOf;
    DataSet:= NewDataset(tSQLProdutos);
    DataSet.AfterScroll := nil;
  end;
  ConfiguraGrid(Tcomponent(Gridprodutos));
  ConfiguraGrid(Tcomponent(GridPedidoProduto));
end;

procedure TFMain.PgChange(Sender: TObject);
begin
  case pg.ActivePageIndex of
   0:begin
       BtnVoltar.Enabled:=false;
       BtnSeguir.Enabled:= false;
       BtnGravar.Enabled:=false;
       BtnPedidoAnt.Visible:=false;
       BtnApagaPedido.Visible:=false;
       PesquisaCliente;
     end;

   1:begin
       BtnVoltar.Enabled:=true;
       BtnSeguir.Enabled:= false;
       BtnGravar.Enabled:=true;
       PesquisaProdutos;
       if not Reaproveitamento_pedido then AbrirDatasetPedidoProduto;
       EditaGridProdutospedido(false);
     end;
  end;
end;


procedure TFMain.BeforePostPedidoProduto(DataSet: TDataSet);
begin
  DataSet.FieldByName('VLR_TOTAL').AsCurrency := DataSet.FieldByName('QUANTIDADE').AsFloat *
                                                 DataSet.FieldByName('VLR_UNITARIO').AsCurrency ;
end;

function TFMain.ValidarComponente(var objeto: Tcomponent): boolean;
begin
 { objeto Tedit }
  Result := true;
  if Tcomponent(objeto) is TEdit then
  begin
    Result :=  (TEdit(objeto).Text <> EmptyStr);

    if Result then
    begin
      TEdit(objeto).Color  :=clWindow;
    end
    else
    begin
      if TEdit(objeto).CanFocus
         then TEdit(objeto).SetFocus;
      TEdit(objeto).Color  :=clSkyBlue;
    end;
  end;
 {TNumberBox}
  if Tcomponent(objeto) is TNumberBox then
  begin
    Result :=  (TNumberBox(objeto).Text <> EmptyStr) and
               (TNumberBox(objeto).ValueInt<>0)      and
               (TNumberBox(objeto).ValueFloat<>0)    and
               (TNumberBox(objeto).ValueCurrency<>0);

    if TNumberBox(objeto).name = NEditCodigoCli.Name then
    begin
      BtnPedidoAnt.Visible  := (TNumberBox(objeto).Text='') or (TNumberBox(objeto).ValueInt=0);
      BtnApagaPedido.Visible:= (TNumberBox(objeto).Text='') or (TNumberBox(objeto).ValueInt=0);
      if True then
      
    end;

    if Result then
    begin
      TNumberBox(objeto).Color  :=clWindow;
    end
    else
    begin
      if TNumberBox(objeto).CanFocus
         then TNumberBox(objeto).SetFocus;
      TNumberBox(objeto).Color  :=clSkyBlue;
    end;
  end;


  { Pode-se colocar outros objetos }
  if not Result then raise Exception.Create('Valor Incorreto!');
end;

end.

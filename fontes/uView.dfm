object FMain: TFMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pedido de Venda'
  ClientHeight = 584
  ClientWidth = 997
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Pg: TPageControl
    Left = 0
    Top = 0
    Width = 997
    Height = 514
    ActivePage = TSCliente
    Align = alClient
    TabOrder = 0
    OnChange = PgChange
    ExplicitWidth = 889
    ExplicitHeight = 513
    object TSCliente: TTabSheet
      Caption = 'Sele'#231#227'o Cliente'
      object PnlCleinteCabecalho: TPanel
        Left = 0
        Top = 0
        Width = 989
        Height = 91
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 885
        object SHapeCleinte: TShape
          Left = 1
          Top = 31
          Width = 987
          Height = 59
          Align = alClient
          Brush.Color = clBtnFace
          Pen.Color = clWhite
          ExplicitLeft = 353
          ExplicitTop = 4
        end
        object Label7: TLabel
          Left = 15
          Top = 31
          Width = 39
          Height = 15
          Caption = 'C'#243'digo'
        end
        object BtnSelecionar: TButton
          Left = 116
          Top = 46
          Width = 87
          Height = 25
          Cursor = crHandPoint
          Caption = 'Selecionar'
          TabOrder = 0
          OnClick = BtnSelecionarClick
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 981
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          Caption = 'Selecione um cliente e clique em "Seguir"'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          ExplicitLeft = 1
          ExplicitTop = 1
          ExplicitWidth = 883
        end
        object NEditCodigoCli: TNumberBox
          Left = 15
          Top = 47
          Width = 90
          Height = 23
          TabOrder = 2
          OnChange = NEditCodigoCliChange
        end
        object BtnPedidoAnt: TButton
          Left = 215
          Top = 46
          Width = 162
          Height = 25
          Cursor = crHandPoint
          Caption = 'Carregar Pedido Gravado'
          TabOrder = 3
          OnClick = BtnPedidoAntClick
        end
        object BtnApagaPedido: TButton
          Left = 388
          Top = 46
          Width = 162
          Height = 25
          Cursor = crHandPoint
          Caption = 'Apagar Pedido Gravado'
          TabOrder = 4
          OnClick = BtnApagaPedidoClick
        end
      end
      object PnlCentral: TPanel
        Left = 0
        Top = 91
        Width = 989
        Height = 393
        Align = alClient
        TabOrder = 1
        ExplicitWidth = 885
        object GridClentes: TDBGrid
          Left = 1
          Top = 1
          Width = 987
          Height = 391
          Align = alClient
          DataSource = DsClientes
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnCellClick = GridClentesCellClick
          OnKeyDown = GridClentesKeyDown
        end
      end
    end
    object TsPedidoVenda: TTabSheet
      Caption = 'Sele'#231#227'o Produtos'
      ImageIndex = 1
      object Splitter1: TSplitter
        Left = 0
        Top = 154
        Width = 989
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitLeft = -3
        ExplicitTop = 96
        ExplicitWidth = 885
      end
      object PnlProdDispo: TPanel
        Left = 0
        Top = 0
        Width = 989
        Height = 154
        Align = alTop
        Caption = 'PnlProdDispo'
        TabOrder = 0
        ExplicitWidth = 881
        object PnlProdDispCabecalho: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 981
          Height = 23
          Align = alTop
          Alignment = taLeftJustify
          Caption = 'Produtos Dispon'#237'veis'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          ExplicitLeft = 1
          ExplicitTop = 1
          ExplicitWidth = 879
        end
        object GridProdutos: TDBGrid
          Left = 1
          Top = 30
          Width = 987
          Height = 123
          Align = alClient
          DataSource = DsProdutos
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnCellClick = GridProdutosCellClick
          OnKeyDown = GridProdutosKeyDown
        end
      end
      object PnlPedido: TPanel
        Left = 0
        Top = 246
        Width = 989
        Height = 238
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 1
        ExplicitWidth = 881
        ExplicitHeight = 237
        object GridPedidoProduto: TDBGrid
          Left = 1
          Top = 25
          Width = 987
          Height = 212
          Align = alClient
          DataSource = DsPedidoProduto
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnColExit = GridPedidoProdutoColExit
          OnKeyDown = GridPedidoProdutoKeyDown
        end
        object PnlPedidocabecalho: TPanel
          Left = 1
          Top = 1
          Width = 987
          Height = 24
          Align = alTop
          Caption = 'Produtos Selecionados'
          TabOrder = 1
          ExplicitWidth = 879
        end
      end
      object PnlInsereproduto: TPanel
        Left = 0
        Top = 157
        Width = 989
        Height = 89
        Align = alTop
        TabOrder = 2
        ExplicitWidth = 881
        object Label2: TLabel
          Left = 16
          Top = 31
          Width = 39
          Height = 15
          Caption = 'C'#243'digo'
        end
        object Label3: TLabel
          Left = 125
          Top = 31
          Width = 62
          Height = 15
          Caption = 'Quantidade'
        end
        object Label4: TLabel
          Left = 233
          Top = 31
          Width = 59
          Height = 15
          Caption = 'Vlr Unit'#225'rio'
        end
        object NEditCodigoProd: TNumberBox
          Left = 16
          Top = 47
          Width = 90
          Height = 23
          TabOrder = 0
        end
        object PnlInsereProdutosCab: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 981
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          Caption = 'Inserir Produtos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          ExplicitLeft = 1
          ExplicitTop = 1
          ExplicitWidth = 879
        end
        object NEditQuantidade: TNumberBox
          Left = 125
          Top = 47
          Width = 90
          Height = 23
          Decimal = 3
          Mode = nbmFloat
          TabOrder = 2
        end
        object NEditVlrUnitario: TNumberBox
          Left = 233
          Top = 47
          Width = 90
          Height = 23
          Mode = nbmCurrency
          TabOrder = 3
        end
        object BtnInsere: TButton
          Left = 345
          Top = 45
          Width = 75
          Height = 25
          Cursor = crHandPoint
          Caption = 'Inserir'
          TabOrder = 4
          OnClick = BtnInsereClick
        end
      end
    end
  end
  object PnlRodape: TPanel
    Left = 0
    Top = 543
    Width = 997
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 542
    ExplicitWidth = 889
    object BtnVoltar: TButton
      Left = 5
      Top = 9
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = 'Voltar'
      TabOrder = 0
      OnClick = BtnVoltarClick
    end
    object BtnSeguir: TButton
      Left = 87
      Top = 9
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = 'Seguir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = BtnSeguirClick
    end
    object BtnGravar: TButton
      Left = 171
      Top = 9
      Width = 117
      Height = 25
      Cursor = crHandPoint
      Caption = 'Gravar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = BtnGravarClick
    end
  end
  object PnlInf: TPanel
    Left = 0
    Top = 514
    Width = 997
    Height = 29
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 513
    ExplicitWidth = 889
    object Label1: TLabel
      Left = 11
      Top = 6
      Width = 117
      Height = 17
      Caption = 'Cliente Selecionado:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LbCliente: TLabel
      Left = 137
      Top = 6
      Width = 53
      Height = 17
      Caption = 'Nenhum'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label5: TLabel
      Left = 817
      Top = 6
      Width = 76
      Height = 17
      Caption = 'Total Pedido:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LbTotpedido: TLabel
      Left = 978
      Top = 6
      Width = 7
      Height = 17
      Alignment = taRightJustify
      Caption = '0'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object DsClientes: TDataSource
    Left = 804
    Top = 66
  end
  object DsProdutos: TDataSource
    Left = 644
    Top = 66
  end
  object DsPedidoProduto: TDataSource
    Left = 720
    Top = 63
  end
end

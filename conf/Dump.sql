-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: wk
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `Codigo` bigint NOT NULL AUTO_INCREMENT,
  `Nome` varchar(150) NOT NULL,
  `Cidade` varchar(100) DEFAULT NULL,
  `UF` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'José Carlos da Silva','Rio de Janiero','RJ'),(2,'Henrique Fajardo','São Paulo','SP'),(3,'Ramon Oliveira','Belo Horizonte','BH'),(4,'Geraldo Luiz','Montes Claros','MG'),(5,'Bernardo Samuel','Recife','BA'),(6,'Hermínia Lorenzedo','Santa Catarina','RS'),(7,'Alexandre da Costa','Brasília','DF'),(8,'Paulo Sérgio','Rio Branco','AC'),(9,'Henrique Fajardo','São Paulo','SP'),(10,'Mavery Vargas','Cataguases','MG'),(11,'Patrícia Gonçalves','Aracajú','SE'),(12,'Pedro Paulo','Muriaé','MG'),(13,'Dorival Júnior','São Paulo','SP'),(14,'Filomena Bernardes','São Gonçalo','RJ'),(15,'Wilian de Almeida','Boa Vista','RR'),(16,'Jéssica Farias','Água Fria','MT'),(17,'João Carlos','São Paulo','SP'),(18,'Fernanda Amoedo','Vila Velha','ES'),(19,'Emanuel Mendes','Uberlândia','MG'),(20,'Joel Vieira','Laranjal','MG');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_dados_gerais`
--

DROP TABLE IF EXISTS `pedidos_dados_gerais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_dados_gerais` (
  `NumPedido` bigint NOT NULL AUTO_INCREMENT,
  `Data_Emissao` datetime NOT NULL,
  `Cod_Cliente` bigint NOT NULL,
  `Valor_Total` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`NumPedido`),
  KEY `pdg_cod_cliente_fk` (`Cod_Cliente`),
  CONSTRAINT `pdg_cod_cliente_fk` FOREIGN KEY (`Cod_Cliente`) REFERENCES `clientes` (`Codigo`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_dados_gerais`
--

LOCK TABLES `pedidos_dados_gerais` WRITE;
/*!40000 ALTER TABLE `pedidos_dados_gerais` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos_dados_gerais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_produtos` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `Numero_pedido` bigint NOT NULL,
  `Cod_Produto` bigint NOT NULL,
  `Quantidade` decimal(10,3) DEFAULT '0.000',
  `Vlr_Unitario` decimal(10,2) DEFAULT '0.00',
  `Vlr_Total` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`ID`),
  KEY `pp_Cod_Produto_fk` (`Cod_Produto`),
  KEY `pp_Numero_pedido_fk` (`Numero_pedido`),
  CONSTRAINT `pp_Cod_Produto_fk` FOREIGN KEY (`Cod_Produto`) REFERENCES `produtos` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `PP_Numero_pedido_fk` FOREIGN KEY (`Numero_pedido`) REFERENCES `pedidos_dados_gerais` (`NumPedido`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_produtos`
--

LOCK TABLES `pedidos_produtos` WRITE;
/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `Codigo` bigint NOT NULL AUTO_INCREMENT,
  `Desc_produto` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Preco_Venda` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Controle Joystick Console Sem Fio Compatível Vídeo Game Pc Cor Preto',79.90),(2,'Cartão de memória SanDisk Ultra com adaptador SD 64GB - Modelo SDSQUNS-064G',18.50),(3,'Microfone De Lapela Sem Fio Duplo Profissional Gravação Ios Cor Iphone ios',34.90),(4,'SSD Kingston 480gb - Sa400s37/480g',235.00),(5,'Liquidificador Mondial L-99 500w 2,2l C/ Jarra San Pt - 110v',112.99),(6,'Electrolux Powerspeed STK15 aspirador de pó vertical com fio 1450w 2 em 1 ultra filtro hepa cor cinza 127v',229.90),(7,'Fritadeira Air Fryer New Pratic Af-31 Preto Mondial 127v',249.00),(8,'Parafusadeira Furadeira Sem Fio Bateria 12v P/ Madeira Metal Cor Amarelo/Preto Frequência 60 110V/220V',157.70),(9,'Samsung Galaxy A15 4G Dual SIM 128 GB Azul escuro 4 GB RAM',839.00),(10,'Fone De Ouvido Bluetooth Sem Fio Tws Microfone Todos Celular',38.66),(11,'Maquina Acabamento Recarregável Detalhe Cabelo Barba Sem Fio',26.90),(12,'Repetidor Wifi Sinal Wireless Amplificador Extensor Potente',50.99),(13,'Modulo Taramps Ts400x4 400w 2 Ohms Rca Ts 400x4 4 Canais 100w Amplificador 400rms T400 4 Canais Potencia',187.90),(14,'Par Luva Motoqueiro Motociclista Impermeável Proteção Moto Tamanho Único',35.87),(15,'Panos Scott Duramax com 58 unidades',11.17),(16,'Bateria Moto Titan Fan Biz Bros Fazer 125 150 160 Mix Flex',145.90),(17,'Short Praia Masculino Bermuda Verão Academia Treino Corrida',32.99),(18,'Camiseta Térmica Segunda Pele Proteção Uv Extreme Premium',36.55),(19,'Smart Tv LG 50 Led 4k Uhd Wi-fi Bluetooth Hdr10 50ur871c0sa Preto',2179.00),(20,'Monitor Gamer Samsung T350 24” FHD, Tela Plana, 75Hz, 5ms, HDMI, FreeSync, Game Mode',621.00);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-30 18:15:34

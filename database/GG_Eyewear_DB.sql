-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: ecommerce_db
-- ------------------------------------------------------
-- Server version	8.4.10

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
-- Table structure for table `colore`
--

DROP TABLE IF EXISTS `colore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colore` (
  `codice` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colore`
--

--
-- Table structure for table `disponibile`
--

DROP TABLE IF EXISTS `disponibile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disponibile` (
  `colore_codice` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `occhiale_id` int NOT NULL,
  `quantita` int NOT NULL,
  PRIMARY KEY (`colore_codice`,`occhiale_id`),
  KEY `occhiale_id` (`occhiale_id`),
  CONSTRAINT `disponibile_ibfk_1` FOREIGN KEY (`colore_codice`) REFERENCES `colore` (`codice`) ON UPDATE CASCADE,
  CONSTRAINT `disponibile_ibfk_2` FOREIGN KEY (`occhiale_id`) REFERENCES `occhiale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `disponibile_chk_1` CHECK ((`quantita` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disponibile`
--

--
-- Table structure for table `immagine`
--

DROP TABLE IF EXISTS `immagine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `immagine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `path_Img` varchar(255) NOT NULL,
  `id_occhiale` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_occhiale` (`id_occhiale`),
  CONSTRAINT `immagine_ibfk_1` FOREIGN KEY (`id_occhiale`) REFERENCES `occhiale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `immagine`
--

--
-- Table structure for table `occhiale`
--

DROP TABLE IF EXISTS `occhiale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occhiale` (
  `id` int NOT NULL AUTO_INCREMENT,
  `attivo` tinyint(1) NOT NULL DEFAULT '1',
  `tipologia` enum('DA_LETTURA','DA_VISTA','DA_SOLE','FOTOCROMATICO','PROGRESSIVO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occhiale`
--

--
-- Table structure for table `ordine`
--

DROP TABLE IF EXISTS `ordine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `metodo_pagamento` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `data_ordine` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `stato` enum('IN_LAVORAZIONE','SPEDITO','IN_CONSEGNA','CONSEGNATO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `totale` decimal(10,2) NOT NULL,
  `utente_email` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `utente_email` (`utente_email`),
  CONSTRAINT `ordine_ibfk_1` FOREIGN KEY (`utente_email`) REFERENCES `utente` (`email`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8003 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordine`
--
--
-- Table structure for table `prodotto_acquistato`
--

DROP TABLE IF EXISTS `prodotto_acquistato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodotto_acquistato` (
  `ordine_id` int NOT NULL,
  `numero` int NOT NULL,
  `quantita` int NOT NULL,
  `occhiale_id` int NOT NULL,
  `versione_codice` int NOT NULL,
  `colore_codice` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`ordine_id`,`numero`),
  KEY `cod_versione` (`versione_codice`,`occhiale_id`),
  KEY `colore_codice` (`colore_codice`,`occhiale_id`),
  CONSTRAINT `prodotto_acquistato_ibfk_1` FOREIGN KEY (`ordine_id`) REFERENCES `ordine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotto_acquistato_ibfk_2` FOREIGN KEY (`versione_codice`, `occhiale_id`) REFERENCES `versione_occhiale` (`codice`, `occhiale_id`) ON UPDATE CASCADE,
  CONSTRAINT `prodotto_acquistato_ibfk_3` FOREIGN KEY (`colore_codice`, `occhiale_id`) REFERENCES `disponibile` (`colore_codice`, `occhiale_id`) ON UPDATE CASCADE,
  CONSTRAINT `prodotto_acquistato_chk_1` CHECK ((`quantita` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodotto_acquistato`
--

--
-- Table structure for table `recensisce`
--

DROP TABLE IF EXISTS `recensisce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recensisce` (
  `utente_email` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `occhiale_id` int NOT NULL,
  `descrizione` text,
  `voto` int DEFAULT NULL,
  PRIMARY KEY (`utente_email`,`occhiale_id`),
  KEY `occhiale_id` (`occhiale_id`),
  CONSTRAINT `recensisce_ibfk_1` FOREIGN KEY (`utente_email`) REFERENCES `utente` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `recensisce_ibfk_2` FOREIGN KEY (`occhiale_id`) REFERENCES `occhiale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_voto` CHECK (((`voto` >= 1) and (`voto` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recensisce`
--

LOCK TABLES `recensisce` WRITE;
/*!40000 ALTER TABLE `recensisce` DISABLE KEYS */;
/*!40000 ALTER TABLE `recensisce` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utente` (
  `email` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cognome` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `PASSWORD` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `indirizzo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `data_nascita` date NOT NULL,
  `ruolo` enum('AMMINISTRATORE','CLIENTE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES ('adminGE@email.it','Gennaro','Esposito','password','3331112222','Via Carducci 12, 80121 Napoli','2005-28-06','AMMINISTRATORE'),('adminGV@email.it','Gerardo','Vertolomo','password','3339876543','Via Toledo 150, 80132 Napoli','2006-10-03','AMMINISTRATORE');
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versione_occhiale`
--

DROP TABLE IF EXISTS `versione_occhiale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `versione_occhiale` (
  `codice` int NOT NULL,
  `occhiale_id` int NOT NULL,
  `marca` varchar(50) NOT NULL,
  `modello` varchar(50) NOT NULL,
  `genere` enum('UOMO','DONNA','UNISEX','BAMBINI') NOT NULL,
  `taglia` varchar(15) NOT NULL,
  `montatura` varchar(50) NOT NULL,
  `forma` varchar(30) NOT NULL,
  `materiale` varchar(50) NOT NULL,
  `prezzo` decimal(10,2) NOT NULL,
  `corrente` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`codice`,`occhiale_id`),
  KEY `occhiale_id` (`occhiale_id`),
  CONSTRAINT `versione_occhiale_ibfk_1` FOREIGN KEY (`occhiale_id`) REFERENCES `occhiale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `versione_occhiale`
--


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-21 23:21:20

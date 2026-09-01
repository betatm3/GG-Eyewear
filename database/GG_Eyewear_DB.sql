-- ==========================================
-- SCRIPT CREAZIONE STRUTTURA DATABASE
-- Database: ecommerce_db
-- ==========================================

CREATE DATABASE IF NOT EXISTS `ecommerce_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ecommerce_db`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Drop tabelle se esistenti (ordine inverso delle dipendenze)
DROP TABLE IF EXISTS `prodotto_acquistato`;
DROP TABLE IF EXISTS `ordine`;
DROP TABLE IF EXISTS `recensisce`;
DROP TABLE IF EXISTS `immagine`;
DROP TABLE IF EXISTS `disponibile`;
DROP TABLE IF EXISTS `versione_occhiale`;
DROP TABLE IF EXISTS `colore`;
DROP TABLE IF EXISTS `occhiale`;
DROP TABLE IF EXISTS `utente`;

-- ------------------------------------------------------
-- Table structure for table `utente`
-- ------------------------------------------------------
CREATE TABLE `utente` (
  `email` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cognome` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `PASSWORD` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `indirizzo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `data_nascita` date NOT NULL,
  `ruolo` enum('ADMIN','USER') COLLATE utf8mb4_general_ci NOT NULL,
  `attivo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- Table structure for table `occhiale`
-- ------------------------------------------------------
CREATE TABLE `occhiale` (
  `id` int NOT NULL AUTO_INCREMENT,
  `attivo` tinyint(1) NOT NULL DEFAULT '1',
  `tipologia` enum('DA_LETTURA','DA_VISTA','DA_SOLE','FOTOCROMATICO','PROGRESSIVO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- Table structure for table `colore`
-- ------------------------------------------------------
CREATE TABLE `colore` (
  `id_colore` int NOT NULL AUTO_INCREMENT,
  `codice` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nome` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `hex` varchar(7) COLLATE utf8mb4_general_ci DEFAULT '#000000',
  PRIMARY KEY (`id_colore`),
  UNIQUE KEY `unique_codice` (`codice`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- Table structure for table `versione_occhiale`
-- ------------------------------------------------------
CREATE TABLE `versione_occhiale` (
  `codice` int NOT NULL AUTO_INCREMENT,
  `occhiale_id` int NOT NULL,
  `marca` varchar(50) NOT NULL,
  `modello` varchar(50) NOT NULL,
  `genere` enum('UOMO','DONNA','UNISEX','BAMBINI') NOT NULL,
  `taglia` varchar(15) NOT NULL,
  `montatura` varchar(50) NOT NULL,
  `forma` enum('RETTANGOLARE','QUADRATO','ROTONDO','OVALE','AVIATOR','CAT_EYE','BROWLINE','FARFALLA','PANTO','CUORE','POLIGONO','ESAGONALE','OTTAGONALE','GEOMETRICO','MASCHERINA','AVVOLGENTE','ASIMMETRICO') DEFAULT NULL,
  `materiale` varchar(50) NOT NULL,
  `prezzo` decimal(10,2) NOT NULL,
  `corrente` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`codice`,`occhiale_id`),
  KEY `occhiale_id` (`occhiale_id`),
  CONSTRAINT `versione_occhiale_ibfk_1` FOREIGN KEY (`occhiale_id`) REFERENCES `occhiale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------
-- Table structure for table `disponibile`
-- ------------------------------------------------------
CREATE TABLE `disponibile` (
  `colore_codice` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `occhiale_id` int NOT NULL,
  `quantita` int NOT NULL,
  PRIMARY KEY (`colore_codice`,`occhiale_id`),
  KEY `occhiale_id` (`occhiale_id`),
  CONSTRAINT `disponibile_ibfk_1` FOREIGN KEY (`colore_codice`) REFERENCES `colore` (`codice`) ON UPDATE CASCADE,
  CONSTRAINT `disponibile_ibfk_2` FOREIGN KEY (`occhiale_id`) REFERENCES `occhiale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `disponibile_chk_1` CHECK ((`quantita` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- Table structure for table `immagine`
-- ------------------------------------------------------
CREATE TABLE `immagine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `path_Img` varchar(255) NOT NULL,
  `id_occhiale` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_occhiale` (`id_occhiale`),
  CONSTRAINT `immagine_ibfk_1` FOREIGN KEY (`id_occhiale`) REFERENCES `occhiale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------
-- Table structure for table `ordine`
-- ------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=829205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- Table structure for table `prodotto_acquistato`
-- ------------------------------------------------------
CREATE TABLE `prodotto_acquistato` (
  `ordine_id` int NOT NULL,
  `numero` int NOT NULL AUTO_INCREMENT,
  `quantita` int NOT NULL,
  `occhiale_id` int NOT NULL,
  `versione_codice` int NOT NULL,
  `colore_codice` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`numero`,`ordine_id`),
  KEY `cod_versione` (`versione_codice`,`occhiale_id`),
  KEY `colore_codice` (`colore_codice`,`occhiale_id`),
  KEY `prodotto_acquistato_ibfk_1` (`ordine_id`),
  CONSTRAINT `prodotto_acquistato_colore_fk` FOREIGN KEY (`colore_codice`) REFERENCES `colore` (`codice`) ON UPDATE CASCADE,
  CONSTRAINT `prodotto_acquistato_ibfk_1` FOREIGN KEY (`ordine_id`) REFERENCES `ordine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotto_acquistato_ibfk_2` FOREIGN KEY (`versione_codice`, `occhiale_id`) REFERENCES `versione_occhiale` (`codice`, `occhiale_id`) ON UPDATE CASCADE,
  CONSTRAINT `prodotto_acquistato_chk_1` CHECK ((`quantita` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=755817 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- Table structure for table `recensisce`
-- ------------------------------------------------------
CREATE TABLE `recensisce` (
  `utente_email` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `occhiale_id` int NOT NULL,
  `descrizione` text,
  `voto` int DEFAULT NULL,
  PRIMARY KEY (`utente_email`,`occhiale_id`),
  KEY `occhiale_id` (`occhiale_id`),
  CONSTRAINT `recensisce_ibfk_1` FOREIGN KEY (`utente_email`) REFERENCES `utente` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `recensisce_ibfk_2` FOREIGN KEY (`occhiale_id`) REFERENCES `occhiale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_voto` CHECK (((`voto` >= 1) and (`voto` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
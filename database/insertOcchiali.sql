-- ====================================================================================
-- SCRIPT SQL POPOLAMENTO DATABASE - ECOMMERCE OCCHIALI (GG EYEWEAR)
-- Contiene: 
-- 1. Colori
-- 2. 21 Occhiali + Versioni + Disponibilità (11 DA_SOLE e 10 DA_VISTA)
-- 3. Utenti (Clienti ed Amministratore)
-- 4. Ordini Storici e Prodotti Acquistati
-- 5. Recensioni con Voti e Commenti
-- 6. Galleria Immagini Prodotte
-- ====================================================================================

USE `ecommerce_db`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- 1. Popolamento `utente`
LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES 
('adminGE@email.it','Gennaro','Esposito','$2a$10$ErRuNfFEozV/haCW1Iicu./Jg1.ZuuePoE6cJNpuA4M4dZgXgblgu','333 111 2222','Via Carducci 12, 80121 Napoli','2005-06-28','ADMIN',1),
('adminGV@email.it','Gerardo','Vertolomo','$2a$10$NgltC7tPuQP0lHNXv/WHR.6.qifWZ.fWPiffU4y2LzGq/aW5nXASe','333 987 6543','Via Toledo 150, 80132 Napoli','2006-03-10','ADMIN',1),
('ciro.esposito@email.it','Ciro','Esposito','$2a$10$Fi4c9.pb8mj7PoGayf1L4On.idNjxYujiJBB5kSSZKOLLeDNMeQRG','333 111 2223','Via Toledo 148, 80132 Napoli','2004-06-10','USER',1),
('cliente@email.it','Mario','Rossi','$2a$10$Xtr9FzgVBc6QbdyPMSuZZ.fZj8sNEtjHESvgia9ohMKB.WxDxM8dG','333 987 6543','Via Toledo 150, 80132 Napoli','1990-01-01','USER',1),
('francesca.neri@email.it','Francesca','Neri','$2a$10$sdzcn2f7xxydUt8rRa/d../It3yYg2NgJ3ECcVXqMuLjRYoOp3yl.','339 876 5432','Corso Vittorio Emanuele 88, 20121 Milano','1995-09-23','USER',1),
('giuseppe.verdi@email.it','Giuseppe','Verdi','$2a$10$X/dE9vEmZD/lfcw.FV4KyOBBI2WSzv.eBRtOYrh5AYkJ6uzURsoSq','340 123 4567','Via Roma 45, 00100 Roma','1992-04-12','USER',1),
('marco.gialli@email.it','Marco','Gialli','$2a$10$OHpDCuzRNWYBV/3wTLsWMOnf1GD07NGgrs5lhyegnHJuBcpJLw7DW','335 112 2334','Via Garibaldi 12, 50100 Firenze','1988-11-05','USER',1);
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

-- 2. Popolamento `occhiale`
LOCK TABLES `occhiale` WRITE;
/*!40000 ALTER TABLE `occhiale` DISABLE KEYS */;
INSERT INTO `occhiale` VALUES 
(201,1,'DA_SOLE'),(202,1,'DA_SOLE'),(203,1,'DA_SOLE'),(204,1,'DA_SOLE'),(205,1,'DA_SOLE'),
(206,1,'DA_SOLE'),(207,1,'DA_SOLE'),(208,1,'DA_SOLE'),(209,1,'DA_SOLE'),(210,1,'DA_SOLE'),
(221,1,'DA_VISTA'),(222,1,'DA_VISTA'),(223,1,'DA_VISTA'),(224,1,'DA_VISTA'),(225,1,'DA_VISTA'),
(226,1,'DA_VISTA'),(227,1,'DA_VISTA'),(228,1,'DA_VISTA'),(229,1,'DA_VISTA'),(230,1,'DA_VISTA'),
(233,1,'DA_SOLE');
/*!40000 ALTER TABLE `occhiale` ENABLE KEYS */;
UNLOCK TABLES;

-- 3. Popolamento `colore`
LOCK TABLES `colore` WRITE;
/*!40000 ALTER TABLE `colore` DISABLE KEYS */;
INSERT INTO `colore` VALUES 
(1,'C_ARGENTO_SAT_A1B','Argento Satinato','#8A8D8F'),
(2,'C_BLU_NOTTE_K2M','Blu Notte','#191970'),
(3,'C_NERO_OPACO_P3N','Nero Opaco','#000000'),
(4,'C_ORO_LUCIDO_R4L','Oro Lucido','#D4AF37'),
(5,'C_ROSA_CIPRIA_S5C','Rosa Cipria','#F3D1C8'),
(6,'C_ROSSO_CORSA_T6C','Rosso Corsa','#D40000'),
(7,'C_TARTARUGATO_U7T','Tartarugato Classico','#5C3A21'),
(8,'C_VERDE_MILIT_V8M','Verde Militare','#4B5320'),
(9,'C_VERDE_SALVIA_QDA','Verde Salvia','#8A9A86');
/*!40000 ALTER TABLE `colore` ENABLE KEYS */;
UNLOCK TABLES;

-- 4. Popolamento `versione_occhiale`
LOCK TABLES `versione_occhiale` WRITE;
/*!40000 ALTER TABLE `versione_occhiale` DISABLE KEYS */;
INSERT INTO `versione_occhiale` VALUES 
(1,201,'Tom Ford','Snowdon FT0237','UNISEX','L','SPESSA','QUADRATO','Acetato',295.00,0),
(1,202,'Gucci','GG0061S Web','DONNA','M','SPESSA','CAT_EYE','Acetato',340.00,0),
(1,203,'Prada','PR 17WS Symbole','DONNA','M','SPESSA','RETTANGOLARE','Acetato',360.00,0),
(1,204,'Oliver Peoples','Gregory Peck Sun','UNISEX','S','SPESSA','ROTONDO','Acetato',380.00,1),
(1,205,'Persol','714 SM Steve McQueen','UOMO','L','SPESSA','AVIATOR','Acetato',390.00,1),
(1,206,'Saint Laurent','SL 276 Mica','DONNA','M','SPESSA','CAT_EYE','Acetato',310.00,1),
(1,207,'Dior','Dioright Mask','UNISEX','L','SENZA','MASCHERINA','Metallo',420.00,1),
(1,208,'Giorgio Armani','AR6099 Frames','UOMO','M','MEZZA','ROTONDO','Titanio',280.00,1),
(1,209,'Police','Origins 1 SPLC04','UOMO','L','SPESSA','QUADRATO','Acetato',139.00,1),
(1,210,'Vogue Eyewear','VO5338S Hailey Bieber','DONNA','S','SPESSA','CAT_EYE','Acetato',99.00,1),
(1,221,'Oliver Peoples','O Malley OV5183','UNISEX','S','SPESSA','ROTONDO','Acetato',315.00,1),
(1,222,'Tom Ford','FT5634-B Blue Block','UOMO','M','SPESSA','RETTANGOLARE','Acetato',270.00,1),
(1,223,'Prada','PR 11RV Journal','DONNA','M','SPESSA','CAT_EYE','Acetato',245.00,1),
(1,224,'Lindberg','Air Titanium Morten','UNISEX','M','SENZA','ROTONDO','Filo di Titanio',490.00,1),
(1,225,'Moscot','Miltzen Classic','UNISEX','S','SPESSA','ROTONDO','Acetato',290.00,1),
(1,226,'Ray-Ban','RX5154 Clubmaster Optic','UNISEX','M','MEZZA','QUADRATO','Acetato e Metallo',140.00,1),
(1,227,'Giorgio Armani','AR7004 Executive','UOMO','L','SPESSA','RETTANGOLARE','Acetato',230.00,1),
(1,228,'Gucci','GG0396O Metal Gold','DONNA','M','SPESSA','OTTAGONALE','Metallo Dorato',320.00,1),
(1,229,'Silhouette','TMA Must 5515','UNISEX','M','SENZA','RETTANGOLARE','Titanio Ultra-Light',345.00,1),
(1,230,'Persol','PO3007V Vintage','UOMO','M','SPESSA','QUADRATO','Acetato',215.00,1),
(1,233,'Ray-Ban','Aviator Classic','UOMO','L','MEZZA','AVIATOR','metallo',150.00,0),
(2,202,'Gucci','GG0061S Web','DONNA','M','SPESSA','CAT_EYE','Acetato',300.00,0),
(3,233,'Ray-Ban','Aviator Classic','UOMO','L','MEZZA','AVIATOR','metallo',150.00,0),
(4,202,'Gucci','GG0061S Web','DONNA','M','SPESSA','CAT_EYE','Acetato',290.00,0);

/*!40000 ALTER TABLE `versione_occhiale` ENABLE KEYS */;
UNLOCK TABLES;

-- 5. Popolamento `disponibile`
LOCK TABLES `disponibile` WRITE;
/*!40000 ALTER TABLE `disponibile` DISABLE KEYS */;
INSERT INTO `disponibile` VALUES 
('C_ARGENTO_SAT_A1B',207,7),('C_ARGENTO_SAT_A1B',208,10),('C_ARGENTO_SAT_A1B',224,8),('C_ARGENTO_SAT_A1B',229,10),
('C_BLU_NOTTE_K2M',204,9),('C_BLU_NOTTE_K2M',205,11),('C_BLU_NOTTE_K2M',209,15),('C_BLU_NOTTE_K2M',222,12),('C_BLU_NOTTE_K2M',227,14),
('C_NERO_OPACO_P3N',201,14),('C_NERO_OPACO_P3N',202,10),('C_NERO_OPACO_P3N',203,19),('C_NERO_OPACO_P3N',206,16),('C_NERO_OPACO_P3N',208,14),
('C_NERO_OPACO_P3N',209,22),('C_NERO_OPACO_P3N',221,10),('C_NERO_OPACO_P3N',222,20),('C_NERO_OPACO_P3N',225,16),('C_NERO_OPACO_P3N',226,25),
('C_NERO_OPACO_P3N',227,18),('C_NERO_OPACO_P3N',230,15),('C_ORO_LUCIDO_R4L',202,8),('C_ORO_LUCIDO_R4L',207,6),('C_ORO_LUCIDO_R4L',224,6),
('C_ORO_LUCIDO_R4L',228,13),('C_ORO_LUCIDO_R4L',229,7),('C_ROSA_CIPRIA_S5C',203,7),('C_ROSA_CIPRIA_S5C',210,18),('C_ROSA_CIPRIA_S5C',223,11),
('C_TARTARUGATO_U7T',201,11),('C_TARTARUGATO_U7T',204,14),('C_TARTARUGATO_U7T',205,18),('C_TARTARUGATO_U7T',210,12),('C_TARTARUGATO_U7T',221,15),
('C_TARTARUGATO_U7T',223,14),('C_TARTARUGATO_U7T',225,12),('C_TARTARUGATO_U7T',230,20);
/*!40000 ALTER TABLE `disponibile` ENABLE KEYS */;
UNLOCK TABLES;

-- 6. Popolamento `immagine`
LOCK TABLES `immagine` WRITE;
/*!40000 ALTER TABLE `immagine` DISABLE KEYS */;
INSERT INTO `immagine` VALUES 
(7,'uploads/occhiali/Oliver_Peoples_Gregory_1.jpg',204),
(8,'uploads/occhiali/Oliver_Peoples_Gregory_2.jpg',204),
(9,'uploads/occhiali/Persol_714sm-steve-mcqueen-havan_1.jpg',205),
(10,'uploads/occhiali/Persol_714sm-steve-mcqueen-havan_2.jpg',205),
(11,'uploads/occhiali/Saint_Laurent_SL276_1.jpg',206),
(12,'uploads/occhiali/Saint_Laurent_SL276_2.jpg',206),
(13,'uploads/occhiali/Dior_Dioright_1.jpg',207),
(14,'uploads/occhiali/Dior_Dioright_2.jpg',207),
(15,'uploads/occhiali/Giorgio_Armani_AR6099_Frames_1.jpg',208),
(16,'uploads/occhiali/Giorgio_Armani_AR6099_Frames_2.jpg',208),
(17,'uploads/occhiali/Police - Origins 1 SPLC04_1.jpg',209),
(18,'uploads/occhiali/Police - Origins 1 SPLC04_2.jpg',209),
(19,'uploads/occhiali/Vogue Eyewear - VO5338S Hailey Bieber_1.jpg',210),
(20,'uploads/occhiali/Vogue Eyewear - VO5338S Hailey Bieber_2.jpg',210),
(21,'uploads/occhiali/Oliver_Peoples_OMalley_OV5183_1.jpg',221),
(22,'uploads/occhiali/Oliver_Peoples_OMalley_OV5183_2.jpg',221),
(23,'uploads/occhiali/Tom Ford - FT5634-B Blue Block_1.jpg',222),
(24,'uploads/occhiali/Tom Ford - FT5634-B Blue Block_2.jpg',222),
(25,'uploads/occhiali/Prada - PR 11RV Journal_1.jpg',223),
(26,'uploads/occhiali/Prada - PR 11RV Journal_2.jpg',223),
(27,'uploads/occhiali/Lindberg_Air_Titanium_Morten_1.jpg',224),
(28,'uploads/occhiali/Lindberg_Air_Titanium_Morten_2.jpg',224),
(29,'uploads/occhiali/Moscot_Miltzen_Classic_1.jpg',225),
(30,'uploads/occhiali/Moscot_Miltzen_Classic_2.jpg',225),
(31,'uploads/occhiali/Ray-Ban - RX5154 Clubmaster Optic_1.jpg',226),
(32,'uploads/occhiali/Ray-Ban - RX5154 Clubmaster Optic_2.jpg',226),
(33,'uploads/occhiali/Giorgio_Armani_AR7004_Executive_1.jpg',227),
(34,'uploads/occhiali/Giorgio_Armani_AR7004_Executive_2.jpg',227),
(35,'uploads/occhiali/Gucci_GG0396O_Metal_Gold_1.jpg',228),
(36,'uploads/occhiali/Gucci_GG0396O_Metal_Gold_2.jpg',228),
(37,'uploads/occhiali/Silhouette - TMA Must 5515_1.jpg',229),
(38,'uploads/occhiali/Silhouette - TMA Must 5515_2.jpg',229),
(39,'uploads/occhiali/Persol_PO3007V_Vintage_1.jpg',230),
(40,'uploads/occhiali/Persol_PO3007V_Vintage_2.jpg',230),
(74,'uploads/occhiali/Tom_Ford_Snowdon1.jpeg',201),
(75,'uploads/occhiali/Tom_Ford_Snowdon2.jpg',201),
(78,'uploads/occhiali/immagine_233_1_1786356742841.jpg',233),
(79,'uploads/occhiali/immagine_233_2_1786356742855.jpg',233),
(90,'uploads/occhiali/Gucci_GG0061S_1.jpg',202),
(91,'uploads/occhiali/Gucci_GG0061S_2.jpg',202),
(92,'uploads/occhiali/Prada_Symbole_1.jpg',203),
(93,'uploads/occhiali/Prada_Symbole_2.jpg',203);
/*!40000 ALTER TABLE `immagine` ENABLE KEYS */;
UNLOCK TABLES;

-- 7. Popolamento `ordine`
LOCK TABLES `ordine` WRITE;
/*!40000 ALTER TABLE `ordine` DISABLE KEYS */;
INSERT INTO `ordine` VALUES 
(8001,'PayPal','2026-06-15 08:30:00','CONSEGNATO',635.00,'cliente@email.it'),
(8002,'Carta di Credito','2026-07-02 12:15:00','SPEDITO',390.00,'giuseppe.verdi@email.it'),
(8003,'Contrassegno','2026-07-18 14:45:00','IN_LAVORAZIONE',315.00,'francesca.neri@email.it'),
(8004,'Carta di Credito','2026-07-20 07:20:00','CONSEGNATO',270.00,'marco.gialli@email.it'),
(414665,'Contrassegno','2026-08-06 13:41:27','SPEDITO',360.00,'adminGE@email.it'),
(437141,'PayPal','2026-08-11 10:32:14','IN_LAVORAZIONE',300.00,'adminGE@email.it'),
(720769,'Contrassegno','2026-08-06 13:55:43','IN_CONSEGNA',360.00,'adminGE@email.it'),
(762576,'Contrassegno','2026-08-06 14:41:42','IN_LAVORAZIONE',295.00,'adminGE@email.it'),
(829204,'Contrassegno','2026-07-23 05:34:49','IN_LAVORAZIONE',340.00,'adminGE@email.it');
/*!40000 ALTER TABLE `ordine` ENABLE KEYS */;
UNLOCK TABLES;

-- 8. Popolamento `prodotto_acquistato`
LOCK TABLES `prodotto_acquistato` WRITE;
/*!40000 ALTER TABLE `prodotto_acquistato` DISABLE KEYS */;
INSERT INTO `prodotto_acquistato` VALUES 
(8001,9001,1,201,1,'C_NERO_OPACO_P3N'),
(8001,9002,1,202,1,'C_NERO_OPACO_P3N'),
(8002,9003,1,205,1,'C_BLU_NOTTE_K2M'),
(8003,9004,1,221,1,'C_TARTARUGATO_U7T'),
(8004,9005,1,222,1,'C_NERO_OPACO_P3N'),
(829204,163739,1,202,1,'C_NERO_OPACO_P3N'),
(414665,261137,1,203,1,'C_NERO_OPACO_P3N'),
(437141,342175,1,202,2,'C_NERO_OPACO_P3N'),
(762576,413824,1,201,1,'C_NERO_OPACO_P3N'),
(720769,755816,1,203,1,'C_ROSA_CIPRIA_S5C');
/*!40000 ALTER TABLE `prodotto_acquistato` ENABLE KEYS */;
UNLOCK TABLES;

-- 9. Popolamento `recensisce`
LOCK TABLES `recensisce` WRITE;
/*!40000 ALTER TABLE `recensisce` DISABLE KEYS */;
INSERT INTO `recensisce` VALUES 
('cliente@email.it',201,'Occhiali fantastici, leggeri e stilosi. Consegna velocissima!',5),
('cliente@email.it',221,'Lenti da vista trasparenti e montatura super confortevole.',5),
('francesca.neri@email.it',201,'Design di altissimo livello. Molto soddisfatta dell acquisto.',5),
('giuseppe.verdi@email.it',202,'Montatura bellissima e custodia molto elegante. Consigliati.',4),
('marco.gialli@email.it',205,'Lenti spettacolari al sole. Modello iconico e comodissimo.',5);
/*!40000 ALTER TABLE `recensisce` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
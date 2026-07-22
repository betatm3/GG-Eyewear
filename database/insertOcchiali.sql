-- ====================================================================================
-- SCRIPT SQL POPOLAMENTO DATABASE - ECOMMERCE OCCHIALI (GG EYEWEAR)
-- Contiene: 
-- 1. Colori
-- 2. 22 Occhiali + Versioni + Disponibilità (12 DA_SOLE e 10 DA_VISTA)
-- 3. Utenti (Clienti ed Amministratore)
-- 4. Ordini Storici e Prodotti Acquistati (con sole tipologie DA_SOLE e DA_VISTA)
-- 5. Recensioni con Voti e Commenti (con sole tipologie DA_SOLE e DA_VISTA)
-- 6. Galleria Immagini Prodotte (con sole tipologie DA_SOLE e DA_VISTA)
-- ====================================================================================

-- RESET PREVENTIVO DEL DATABASE PER EVITARE CHIAVI DUPLICATE
USE ecommerce_db;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE recensisce;
TRUNCATE TABLE prodotto_acquistato;
TRUNCATE TABLE ordine;
TRUNCATE TABLE disponibile;
TRUNCATE TABLE immagine;
TRUNCATE TABLE versione_occhiale;
TRUNCATE TABLE occhiale;
TRUNCATE TABLE utente;
TRUNCATE TABLE colore;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. POPOLAMENTO TABELLA COLORE
INSERT IGNORE INTO colore (codice, nome) VALUES 
('C_NERO', 'Nero Opaco'),
('C_ORO', 'Oro Lucido'),
('C_ARG', 'Argento Satinato'),
('C_BLU', 'Blu Notte'),
('C_ROSSO', 'Rosso Corsa'),
('C_TART', 'Tartarugato Classico'),
('C_VERDE', 'Verde Militare'),
('C_ROSA', 'Rosa Cipria');

-- ====================================================================================
-- 2. TIPOLOGIA: DA_SOLE (12 Prodotti ID 201 - 210, 233, 234)
-- ====================================================================================
INSERT INTO occhiale (id, attivo, tipologia) VALUES (201, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (201, 'Tom Ford', 'Snowdon FT0237', 'UNISEX', 'L', 'SPESSA', 'Squadrata', 'Acetato', 295.00, 1, 201);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (201, 'C_NERO', 15), (201, 'C_TART', 10);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (202, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (202, 'Gucci', 'GG0061S Web', 'DONNA', 'M', 'SPESSA', 'Gatto', 'Acetato', 340.00, 1, 202);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (202, 'C_NERO', 12), (202, 'C_ORO', 8);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (203, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (203, 'Prada', 'PR 17WS Symbole', 'DONNA', 'M', 'SPESSA', 'Rettangolare', 'Acetato', 360.00, 1, 203);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (203, 'C_NERO', 20), (203, 'C_ROSA', 5);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (204, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (204, 'Oliver Peoples', 'Gregory Peck Sun', 'UNISEX', 'S', 'SPESSA', 'Rotonda', 'Acetato', 380.00, 1, 204);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (204, 'C_TART', 14), (204, 'C_BLU', 9);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (205, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (205, 'Persol', '714 SM Steve McQueen', 'UOMO', 'L', 'SPESSA', 'Goccia', 'Acetato', 390.00, 1, 205);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (205, 'C_BLU', 11), (205, 'C_TART', 18);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (206, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (206, 'Saint Laurent', 'SL 276 Mica', 'DONNA', 'M', 'SPESSA', 'Gatto', 'Acetato', 310.00, 1, 206);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (206, 'C_NERO', 16);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (207, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (207, 'Dior', 'Dioright Mask', 'UNISEX', 'L', 'SENZA', 'Maschera', 'Metallo', 420.00, 1, 207);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (207, 'C_ARG', 7), (207, 'C_ORO', 6);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (208, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (208, 'Giorgio Armani', 'AR6099 Frames', 'UOMO', 'M', 'MEZZA', 'Rotonda', 'Titanio', 280.00, 1, 208);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (208, 'C_NERO', 14), (208, 'C_ARG', 10);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (209, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (209, 'Police', 'Origins 1 SPLC04', 'UOMO', 'L', 'SPESSA', 'Squadrata', 'Acetato', 139.00, 1, 209);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (209, 'C_NERO', 22), (209, 'C_BLU', 15);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (210, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (210, 'Vogue Eyewear', 'VO5338S Hailey Bieber', 'DONNA', 'S', 'SPESSA', 'Cat-Eye', 'Acetato', 99.00, 1, 210);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (210, 'C_ROSA', 18), (210, 'C_TART', 12);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (233, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (233, 'Ray-Ban', 'Original Wayfarer Classic', 'UNISEX', 'M', 'SPESSA', 'Squadrata', 'Acetato', 155.00, 1, 233);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (233, 'C_NERO', 10), (233, 'C_TART', 5);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (234, 1, 'DA_SOLE');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (234, 'Ray-Ban', 'Clubmaster Classic', 'UNISEX', 'L', 'MEZZA', 'Clubmaster', 'Acetato e Metallo', 165.00, 1, 234);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (234, 'C_NERO', 8), (234, 'C_ORO', 12);

-- ====================================================================================
-- 3. TIPOLOGIA: DA_VISTA (10 Prodotti ID 221 - 230)
-- ====================================================================================
INSERT INTO occhiale (id, attivo, tipologia) VALUES (221, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (221, 'Oliver Peoples', 'O Malley OV5183', 'UNISEX', 'S', 'SPESSA', 'Rotonda', 'Acetato', 315.00, 1, 221);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (221, 'C_TART', 15), (221, 'C_NERO', 10);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (222, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (222, 'Tom Ford', 'FT5634-B Blue Block', 'UOMO', 'M', 'SPESSA', 'Rettangolare', 'Acetato', 270.00, 1, 222);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (222, 'C_NERO', 20), (222, 'C_BLU', 12);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (223, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (223, 'Prada', 'PR 11RV Journal', 'DONNA', 'M', 'SPESSA', 'Cat-Eye', 'Acetato', 245.00, 1, 223);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (223, 'C_ROSA', 11), (223, 'C_TART', 14);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (224, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (224, 'Lindberg', 'Air Titanium Morten', 'UNISEX', 'M', 'SENZA', 'Rotonda', 'Filo di Titanio', 490.00, 1, 224);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (224, 'C_ARG', 8), (224, 'C_ORO', 6);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (225, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (225, 'Moscot', 'Miltzen Classic', 'UNISEX', 'S', 'SPESSA', 'Rotonda', 'Acetato', 290.00, 1, 225);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (225, 'C_NERO', 16), (225, 'C_TART', 12);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (226, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (226, 'Ray-Ban', 'RX5154 Clubmaster Optic', 'UNISEX', 'M', 'MEZZA', 'Squadrata', 'Acetato e Metallo', 140.00, 1, 226);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (226, 'C_NERO', 25);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (227, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (227, 'Giorgio Armani', 'AR7004 Executive', 'UOMO', 'L', 'SPESSA', 'Rettangolare', 'Acetato', 230.00, 1, 227);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (227, 'C_BLU', 14), (227, 'C_NERO', 18);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (228, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (228, 'Gucci', 'GG0396O Metal Gold', 'DONNA', 'M', 'SPESSA', 'Ottagonale', 'Metallo Dorato', 320.00, 1, 228);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (228, 'C_ORO', 13);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (229, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (229, 'Silhouette', 'TMA Must 5515', 'UNISEX', 'M', 'SENZA', 'Rettangolare', 'Titanio Ultra-Light', 345.00, 1, 229);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (229, 'C_ARG', 10), (229, 'C_ORO', 7);

INSERT INTO occhiale (id, attivo, tipologia) VALUES (230, 1, 'DA_VISTA');
INSERT INTO versione_occhiale (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (230, 'Persol', 'PO3007V Vintage', 'UOMO', 'M', 'SPESSA', 'Squadrata', 'Acetato', 215.00, 1, 230);
INSERT INTO disponibile (occhiale_id, colore_codice, quantita) VALUES (230, 'C_TART', 20), (230, 'C_NERO', 15);

-- ====================================================================================
-- 4. UTENTI (CLIENTI ED AMMINISTRATORE)
-- ====================================================================================
INSERT IGNORE INTO utente (email, password, nome, cognome, data_nascita, indirizzo, telefono, ruolo) VALUES 
('admin@email.it', 'admin', 'Luigi', 'Bianchi', '1985-05-15', 'Via Carducci 12, 80121 Napoli', '3331112222', 'AMMINISTRATORE'),
('cliente@email.it', 'password', 'Mario', 'Rossi', '1990-01-01', 'Via Toledo 150, 80132 Napoli', '3339876543', 'CLIENTE'),
('giuseppe.verdi@email.it', 'password123', 'Giuseppe', 'Verdi', '1992-04-12', 'Via Roma 45, 00100 Roma', '3401234567', 'CLIENTE'),
('francesca.neri@email.it', 'password123', 'Francesca', 'Neri', '1995-09-23', 'Corso Vittorio Emanuele 88, 20121 Milano', '3398765432', 'CLIENTE'),
('marco.gialli@email.it', 'password123', 'Marco', 'Gialli', '1988-11-05', 'Via Garibaldi 12, 50100 Firenze', '3351122334', 'CLIENTE');

-- ====================================================================================
-- 5. ORDINI STORICI E PRODOTTI ACQUISTATI
-- ====================================================================================
-- Ordine 8001 (Cliente Mario Rossi - Consegnato)
INSERT IGNORE INTO ordine (id, metodo_pagamento, data_ordine, stato, totale, utente_email) VALUES 
(8001, 'PayPal', '2026-06-15 10:30:00', 'CONSEGNATO', 635.00, 'cliente@email.it');

INSERT IGNORE INTO prodotto_acquistato (numero, ordine_id, quantita, colore_codice, versione_codice, occhiale_id) VALUES 
(9001, 8001, 1, 'C_NERO', 201, 201),
(9002, 8001, 1, 'C_NERO', 202, 202);

-- Ordine 8002 (Cliente Giuseppe Verdi - Spedito)
INSERT IGNORE INTO ordine (id, metodo_pagamento, data_ordine, stato, totale, utente_email) VALUES 
(8002, 'Carta di Credito', '2026-07-02 14:15:00', 'SPEDITO', 390.00, 'giuseppe.verdi@email.it');

INSERT IGNORE INTO prodotto_acquistato (numero, ordine_id, quantita, colore_codice, versione_codice, occhiale_id) VALUES 
(9003, 8002, 1, 'C_BLU', 205, 205);

-- Ordine 8003 (Cliente Francesca Neri - In Lavorazione)
INSERT IGNORE INTO ordine (id, metodo_pagamento, data_ordine, stato, totale, utente_email) VALUES 
(8003, 'Contrassegno', '2026-07-18 16:45:00', 'IN_LAVORAZIONE', 315.00, 'francesca.neri@email.it');

INSERT IGNORE INTO prodotto_acquistato (numero, ordine_id, quantita, colore_codice, versione_codice, occhiale_id) VALUES 
(9004, 8003, 1, 'C_TART', 221, 221);

-- Ordine 8004 (Cliente Marco Gialli - Consegnato)
INSERT IGNORE INTO ordine (id, metodo_pagamento, data_ordine, stato, totale, utente_email) VALUES 
(8004, 'Carta di Credito', '2026-07-20 09:20:00', 'CONSEGNATO', 270.00, 'marco.gialli@email.it');

INSERT IGNORE INTO prodotto_acquistato (numero, ordine_id, quantita, colore_codice, versione_codice, occhiale_id) VALUES 
(9005, 8004, 1, 'C_NERO', 222, 222);

-- ====================================================================================
-- 6. RECENSIONI DEI PRODOTTI
-- ====================================================================================
INSERT IGNORE INTO recensisce (utente_email, occhiale_id, descrizione, voto) VALUES 
('cliente@email.it', 201, 'Occhiali fantastici, leggeri e stilosi. Consegna velocissima!', 5),
('francesca.neri@email.it', 201, 'Design di altissimo livello. Molto soddisfatta dell acquisto.', 5),
('giuseppe.verdi@email.it', 202, 'Montatura bellissima e custodia molto elegante. Consigliati.', 4),
('marco.gialli@email.it', 205, 'Lenti spettacolari al sole. Modello iconico e comodissimo.', 5),
('cliente@email.it', 221, 'Lenti da vista trasparenti e montatura super confortevole.', 5);

-- ====================================================================================
-- 7. GALLERIA IMMAGINI PRODOTTI (DA_SOLE E DA_VISTA)
-- ====================================================================================
INSERT INTO immagine (path_Img, id_occhiale) VALUES 
('images/occhiali/Tom_Ford_Snowdon1.jpeg', 201),
('images/occhiali/Tom_Ford_Snowdon2.jpg', 201),
('images/occhiali/Gucci_GG0061S_1.jpg', 202),
('images/occhiali/Gucci_GG0061S_2.jpg', 202),
('images/occhiali/Prada_Symbole_1.jpg', 203),
('images/occhiali/Prada_Symbole_2.jpg', 203),
('images/occhiali/Oliver_Peoples_Gregory_1.jpg', 204),
('images/occhiali/Oliver_Peoples_Gregory_2.jpg', 204),
('images/occhiali/Persol_714sm-steve-mcqueen-havan_1.jpg', 205),
('images/occhiali/Persol_714sm-steve-mcqueen-havan_2.jpg', 205),
('images/occhiali/Saint_Laurent_SL276_1.jpg', 206),
('images/occhiali/Saint_Laurent_SL276_2.jpg', 206),
('images/occhiali/Dior_Dioright_1.jpg', 207),
('images/occhiali/Dior_Dioright_2.jpg', 207),
('images/occhiali/Giorgio Armani - AR6099 Frames_1.jpg', 208),
('images/occhiali/Giorgio Armani - AR6099 Frames_2.jpg', 208),
('images/occhiali/Police - Origins 1 SPLC04_1.jpg', 209),
('images/occhiali/Police - Origins 1 SPLC04_2.jpg', 209),
('images/occhiali/Vogue Eyewear - VO5338S Hailey Bieber_1.jpg', 210),
('images/occhiali/Vogue Eyewear - VO5338S Hailey Bieber_2.jpg', 210),
('images/occhiali/Oliver Peoples - O Malley OV5183_1.jpg', 221),
('images/occhiali/Oliver Peoples - O Malley OV5183_2.jpg', 221),
('images/occhiali/Tom Ford - FT5634-B Blue Block_1.jpg', 222),
('images/occhiali/Tom Ford - FT5634-B Blue Block_2.jpg', 222),
('images/occhiali/Prada - PR 11RV Journal_1.jpg', 223),
('images/occhiali/Prada - PR 11RV Journal_2.jpg', 223),
('images/occhiali/Lindberg - Air Titanium Morten_1.jpg', 224),
('images/occhiali/Lindberg - Air Titanium Morten_2.jpg', 224),
('images/occhiali/Moscot - Miltzen Classic_1.jpg', 225),
('images/occhiali/Moscot - Miltzen Classic_2.jpg', 225),
('images/occhiali/Ray-Ban - RX5154 Clubmaster Optic_1.jpg', 226),
('images/occhiali/Ray-Ban - RX5154 Clubmaster Optic_2.jpg', 226),
('images/occhiali/Giorgio Armani - AR7004 Executive_1.jpg', 227),
('images/occhiali/Giorgio Armani - AR7004 Executive_2.jpg', 227),
('images/occhiali/Gucci - GG0396O Metal Gold_1.jpg', 228),
('images/occhiali/Gucci - GG0396O Metal Gold_2.jpg', 228),
('images/occhiali/Silhouette - TMA Must 5515_1.jpg', 229),
('images/occhiali/Silhouette - TMA Must 5515_2.jpg', 229),
('images/occhiali/Persol - PO3007V Vintage_1.jpg', 230),
('images/occhiali/Persol - PO3007V Vintage_2.jpg', 230),
('images/occhiali/Ray-Ban-Wayfarer_1.jpg', 233),
('images/occhiali/Ray-Ban-Wayfarer_2.jpg', 233),
('images/occhiali/ray-ban-clubmaster_1.jpg', 234),
('images/occhiali/ray-ban-clubmaster_2.jpg', 234);

-- FINE SCRIPT SQL

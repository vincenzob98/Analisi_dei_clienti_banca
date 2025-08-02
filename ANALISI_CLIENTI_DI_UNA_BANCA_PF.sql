describe banca.cliente;
describe banca.conto;
describe banca.tipo_conto;
describe banca.tipo_transazione;
describe banca.transazioni;


-- Calcolo dell'età del cliente
CREATE TEMPORARY TABLE Temp_Eta_Cliente AS
SELECT id_cliente, FLOOR(DATEDIFF(CURDATE(), data_nascita) / 365.25) AS eta_cliente
FROM cliente;
SELECT * FROM Temp_Eta_Cliente;


-- Calcolo del numero di transazioni per cliente (entrata e uscita)
CREATE TEMPORARY TABLE Temp_Num_Transazioni AS
SELECT t.id_cliente, 
       SUM(CASE WHEN tt.segno = '-' THEN 1 ELSE 0 END) AS num_trans_uscita, 
       SUM(CASE WHEN tt.segno = '+' THEN 1 ELSE 0 END) AS num_trans_entrata
FROM transazioni tr
JOIN conto c ON tr.id_conto = c.id_conto
JOIN cliente t ON c.id_cliente = t.id_cliente
JOIN tipo_transazione tt ON tr.id_tipo_trans = tt.id_tipo_transazione
GROUP BY t.id_cliente;
SELECT * FROM Temp_Num_Transazioni;


-- Calcolo dell'importo totale delle transazioni per cliente (entrata e uscita)
CREATE TEMPORARY TABLE Temp_Importo_Transazioni AS
SELECT t.id_cliente, 
       SUM(CASE WHEN tt.segno = '-' THEN tr.importo ELSE 0 END) AS importo_uscita,
       SUM(CASE WHEN tt.segno = '+' THEN tr.importo ELSE 0 END) AS importo_entrata
FROM transazioni tr
JOIN conto c ON tr.id_conto = c.id_conto
JOIN cliente t ON c.id_cliente = t.id_cliente
JOIN tipo_transazione tt ON tr.id_tipo_trans = tt.id_tipo_transazione
GROUP BY t.id_cliente;
SELECT * FROM  Temp_Importo_Transazioni;


-- Calcolo del numero di conti posseduti per cliente
CREATE TEMPORARY TABLE Temp_Num_Conti AS
SELECT id_cliente, COUNT(DISTINCT id_conto) AS num_conti_posseduti
FROM conto
GROUP BY id_cliente;
SELECT * FROM Temp_Num_Conti;

-- Calcolo delle transazioni per tipologia di conto (numero e importo)
CREATE TEMPORARY TABLE Temp_Transazioni_Per_Tipo_Conto AS
SELECT t.id_cliente, tc.desc_tipo_conto,
       SUM(CASE WHEN tt.segno = '-' THEN 1 ELSE 0 END) AS num_trans_uscita_tipo,
       SUM(CASE WHEN tt.segno = '+' THEN 1 ELSE 0 END) AS num_trans_entrata_tipo,
       SUM(CASE WHEN tt.segno = '-' THEN tr.importo ELSE 0 END) AS importo_uscita_tipo,
       SUM(CASE WHEN tt.segno = '+' THEN tr.importo ELSE 0 END) AS importo_entrata_tipo
FROM transazioni tr
JOIN conto c ON tr.id_conto = c.id_conto
JOIN cliente t ON c.id_cliente = t.id_cliente
JOIN tipo_transazione tt ON tr.id_tipo_trans = tt.id_tipo_transazione
JOIN tipo_conto tc ON c.id_tipo_conto = tc.id_tipo_conto
GROUP BY t.id_cliente, tc.desc_tipo_conto;
SELECT * FROM  Temp_Transazioni_Per_Tipo_Conto;


-- Creazione della tabella finale denormalizzata, unendo tutte le informazioni
CREATE TABLE Indicatori_Cliente_Denormalizzato AS
SELECT 
    cl.id_cliente,
    cl.nome,
    cl.cognome,
    et.eta_cliente,
    IFNULL(nt.num_trans_uscita, 0) AS num_trans_uscita,
    IFNULL(nt.num_trans_entrata, 0) AS num_trans_entrata,
    IFNULL(it.importo_uscita, 0) AS importo_uscita,
    IFNULL(it.importo_entrata, 0) AS importo_entrata,
    IFNULL(nc.num_conti_posseduti, 0) AS num_conti_posseduti,
    tt.desc_tipo_conto,
    IFNULL(tt.num_trans_uscita_tipo, 0) AS num_trans_uscita_tipo,
    IFNULL(tt.num_trans_entrata_tipo, 0) AS num_trans_entrata_tipo,
    IFNULL(tt.importo_uscita_tipo, 0) AS importo_uscita_tipo,
    IFNULL(tt.importo_entrata_tipo, 0) AS importo_entrata_tipo
FROM 
    cliente cl
LEFT JOIN 
    Temp_Eta_Cliente et ON cl.id_cliente = et.id_cliente
LEFT JOIN 
    Temp_Num_Transazioni nt ON cl.id_cliente = nt.id_cliente
LEFT JOIN 
    Temp_Importo_Transazioni it ON cl.id_cliente = it.id_cliente
LEFT JOIN 
    Temp_Num_Conti nc ON cl.id_cliente = nc.id_cliente
LEFT JOIN 
    Temp_Transazioni_Per_Tipo_Conto tt ON cl.id_cliente = tt.id_cliente
ORDER BY cl.id_cliente;

-- Visualizzazione della tabella denormalizzata
SELECT * FROM Indicatori_Cliente_Denormalizzato;




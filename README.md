# Analisi dei Clienti di una Banca

## 📌 Descrizione

Progetto SQL per la costruzione di una tabella denormalizzata con indicatori comportamentali dei clienti di una banca, utile per l'addestramento di modelli di machine learning supervisionato.

## 🗂️ Struttura del Progetto

- `database/db_bancario.sql`: script SQL per creare e popolare il database con tutte le tabelle necessarie.
- `sql/ANALISI_CLIENTI_DI_UNA_BANCA_PF.sql`: script SQL che calcola indicatori aggregati per ogni cliente e crea la tabella `Indicatori_Cliente_Denormalizzato`.

## 🎯 Obiettivo

Costruire una **tabella di feature** per ogni cliente contenente:

- Età
- Numero di transazioni in entrata/uscita
- Importi totali in entrata/uscita
- Numero di conti totali e per tipologia
- Transazioni e importi aggregati per tipologia di conto

## 🧱 Tabelle di Partenza

- `cliente`
- `conto`
- `tipo_conto`
- `tipo_transazione`
- `transazioni`

## 💡 Indicatori Calcolati

- Età del cliente
- Numero e importo di transazioni in entrata/uscita
- Indicatori per tipologia di conto

✅ Requisiti
MySQL (versione 8 o superiore consigliata)

👤 Autore

Creato nell’ambito del corso ProfessionAI, a cura di Vincenzo Barone e supervisione di ProfessionAI, autore Giuseppe Gullo

## 🛠️ Come usare

1. Esegui i seguenti comandi in sequenza nel terminale MySQL o bash:

```bash
mysql -u root -p < database/db_bancario.sql
mysql -u root -p banca < sql/ANALISI_CLIENTI_DI_UNA_BANCA_PF.sql
SELECT * FROM banca.Indicatori_Cliente_Denormalizzato;



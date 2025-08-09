# Template progetto API

Questo template contiene una struttura base per:

- Compilare ed eseguire il tuo progetto con le flag come sul sito
- Creare test automatici (con il generatore del prof.)
- Risolvere test personalizzati scelti da te
- Quando c'è una discrepanza tra il risultato del tuo codice e quello atteso, ti fa vedere le differenze nel terminale

Contiene anche uno script per aggiornarsi, nel caso in cui dovesse cambiare qualcosa o dovessi aggiungere più funzionalità. Vedi più in basso per tutti i comandi disponibili.

### Prerequisiti:

- Sistema UNIX (Linux, WSL, MacOS)
- `git`, `gcc` e `make` installati
  - Per controllare, fai `which gcc; which make`, dovresti avere qualcosa come `/usr/bin/gcc` e `/usr/bin/make`

## Quickstart

1. Clona il repository
   - `git clone https://github.com/nicolello-dev/progetto-api-template.git`
2. Entra nella cartella del progetto
   - `cd progetto-api-template` (puoi rinominarla se vuoi)
3. Metti il contenuto del tuo file su `main.c`
4. Esegui `make`

### Come leggere il diff

Ci sarà sempre il risultato atteso a sinistra, ed il tuo risultato a destra.

Nel caso in cui ci siano differenze, può accadere una di queste tre cose:

#### Qualcosa manca nel tuo risultato

Es. Atteso: `A B C D`, Tuo: `A B D`

```
A     A
B     B
C     <
D     D
```

(notare la freccia verso sinistra indicando che qualcosa manca)

#### Il tuo risultato ha qualcosa in più

Es. Atteso: `A B D`, Tuo: `A B C D`

```
A     A
B     B
      > C
D     D
```

(notare la freccia verso destra indicando che c'è qualcosa in più)

#### La stessa riga è diversa

Es. Atteso: `A B C`, Tuo: `A B B`

```
A     A
B     B
C     | B
```

(notare la barra verticale per dire che c'è qualcosa di diverso tra i due)

## Come aggiungere nuovi test

Per aggiungere un test personalizzato:

- Crea un file in `/tests` che finisce in `.txt`, per esempio `/tests/mio_test.txt`
- Mettici l'input che vuoi
- Fai `make solve` per creare il risultato (o `make` lo genera in automatico)

Per rimuoverlo, elimina sia il file di input che il file di output generato, `<file>.txt.result`

## Come aggiornare il template

`make update`

## Lista di comandi

### all (default)

Compila il codice, genera test automatizzati, risolve test personalizzati e ne verifica i risultati, in questo ordine

_Molto probabilmente userai solo questo comando_

```
make
```

### build

Compila il codice

```
make build
```

### test

Usa i test predefiniti, e quelli generati se esistono

```
make test
```

## gen

Genera nuovi test casuali usando il generatore del prof.

```
make gen
```

## clean

Elimina file compilati, testcase _generati_ (`/tests/generated`), etc.

```
make clean
```

# Struttura cartelle

```
/bin
    # Contiene gli eseguibili per creare e risolvere i testcase, dati dal prof.
/dist
    # Contiene l'eseguibile compilato
/docs
    # PDF e simili del prof.
/res
    # Aggiungi qui i file che vuoi salvarti, per esempio `27.c` se quella versione è passata con un 27
/tests
    # Contiene i test predefiniti
    # Aggiungi qui i tuoi test personalizzati
    /generated
        # Contiene i test generati da `make gen`
```

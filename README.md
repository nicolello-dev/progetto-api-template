# Come usare questo progetto

Assumo si stia usando un sistema UNIX (Linux/MacOS/WSL) con `gcc` e `make` installati, vedi file del prof. su [docs/strumenti_progetto_api.pdf](docs/strumenti_progetto_api.pdf).

## Compila, genera e testa tutto

```
make
```

## Compila

```
make build
```

## Test

Usa i test predefiniti, e quelli generati se esistono

```
make test
```

## Genera (nuovi) test casuali

Sovrascrive quelli vecchi, ne genera 10

```
make gen
```

## Pulisci tutto

Elimina file compilati, testcase generati, etc.

```
make clean
```

# Struttura cartelle

```
/bin
    # Contiene gli eseguibili per creare testcase, dati dal prof.
/dist
    # Contiene l'eseguibile compilato
/docs
    # Documentazione data dal prof.
/res
    # Aggiungi qui i file che vuoi salvarti, per esempio `27.c` se e' passato con un 27
/tests
    # Contiene i test predefiniti
    /generated
        # Contiene i test generati casualmente, generato da `make gen`
```

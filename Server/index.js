/*
    Salve a chiunque stia leggendo questo programma.
    Parto subito con il dire che in questo server ci sono ovvii problemi di sicurezza,
    Questo è stato fatto perché nel sito (per ora) non sono presenti dati sensibili
    e avendo a disposizione poco tempo, ho deciso di tralasciare la sicurezza per poi aggiustare tale problematica in futuro.
*/


// Inclusione delle librerie necessarie per il corretto funzionamento del Server
const express = require('express');
const app = express();
var cors = require('cors')
const path = require('path');
const router = require('./serverRequirements/router');
require('dotenv').config({ path: './serverRequirements/.env' });

// Middleware per la gestione di HTTP POST
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Abilito il Cross-Origin Resource Sharing da parte di ogni connessione (non essendoci dati sensibili nel database / server).
app.use(cors());

// Tramite questo comando chiunque si connetta al server avrà LIBERO accesso alla cartella dist/TMMClient, 
// che è dove risiedono le risorse della pagina WEB
app.use(express.static(path.join(__dirname, 'dist/TMMClient')))

// Tutte le richieste che iniziano con la route 'api' (esempio: http://localhost:4000/api/...) 
// vengono gestite dall'oggetto route che viene creato basandosi sul file router.js che sta in ServerApp
app.use('/api', router);

// Questo percorso di route risponde a tutte le chiamate che non iniziano per api, e fa gestire tutte
// queste chiamate dalla Pagina WEB. 
// (Tutti i file che servono per il funzionamento della pagina web sono dentro la cartella dist/TMMClient).
app.get('/*', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist/TMMClient/index.html'));
})


const port = process.env.PORT || 4000
app.listen(port, () => console.log('listening on: http://localhost:' + port));
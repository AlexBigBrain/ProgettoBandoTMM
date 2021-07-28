const express = require('express');
var cors = require('cors')
const { SearchWords, IncreaseCounterWord, ParolaRequest, InsertWord } = require('./controllerdb');

const router = express.Router();

// Questo percorso di route risponde a tutte le chiamate che iniziano per api, e sono seguite da un parametro 'word' 
// (es. localhost:4000/api?word=VIRUS)
router.get('', async (req, res) => {
    // Questo comando elimina possibili comandi che potrebbero essere stati inseriti nella casella di ricerca della parola
    message = req.query.word.toUpperCase().split(' ').map((msg) => {
        let onlyLettersArray = msg.split('').filter(char => /[A-Z]/.test(char));
        return onlyLettersArray.join('');
    }).join(' ').trim();
    console.log(message);

    // Se non viene passata una stringa valida, allora viene inviato una risposta di tipo JSON con uno status: 'NoWordPassed'
    if (message === '') {
        res.json({
            "data": [],
            "status": 'NoWordPassed'
        });
        return;
    }

    // Se viene passata una stringa valita viene fatta una riqchiesta al server chiedendo
    // se quella parola è presente nel database.

    // Se la parola non è presente nel database, allora viene aggiunta.
    let result = await ParolaRequest(message);
    if (result.length === 0) {
        const result = await InsertWord(message, null);
        res.json({
            "data": result,
            "status": 'AddedWord'
        });
        return;
    }


    // Se invece la parola è presente nel database allora viene generata la risposta da inviare al client.
    const usable = [];
    const unusable = [];
    let status = 'FoundWord';
    await Promise.all(result.map(async (res) => {
        if (res.Descriptions.length === 0) {
            await IncreaseCounterWord(res.Word.specificWord);
            unusable.push([res.Word.specificWord, res.Word.RequestNumber]);
            return;
        }
        usable.push(res);
        return;
    }));
    if (usable.length === 0) {
        status = 'NotUsableWord';
    }

    res.json({
        "data": {
            "usable": usable,
            "unusable": unusable
        },
        "status": status
    });
})

// Questa rotta serve soltanto per la LiveSearch.
// Questo percorso di route risponde a tutte le chiamate che iniziano per api/search, e sono seguite da un parametro 'word'
// (es. localhost:4000/api/search?word=VIRUS)
// In pratica con questa rotta si controlla se la stringa inserita nella barra di ricerca ha una stringa simile nel database.
router.get('/search', async (req, res) => {
    message = req.query.word.toUpperCase().split(' ').map((msg) => {
        let onlyLettersArray = msg.split('').filter(char => /[A-Z]/.test(char));
        return onlyLettersArray.join('');
    }).join(' ').trim();

    const [result,] = await SearchWords(message);
    let resWordArray = [];
    result.forEach((res) => {
        resWordArray.push(res.resWord);
    });
    res.json(resWordArray);
});

module.exports = router;
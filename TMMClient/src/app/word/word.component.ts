import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { WordService } from '../word.service';
import { WordInfo } from '../word-info';
import { DescriptionType } from '../description-type';

@Component({
  selector: 'app-word',
  templateUrl: './word.component.html',
  styleUrls: ['./word.component.scss']
})

/*
  Tutto questo componente serve per l'acquisizione e la gestione dei dati sulla parola scelta
*/
export class WordComponent implements OnInit {

  constructor(
    private wordService: WordService,
    private route: ActivatedRoute
  ) { }

  public wordInfo: WordInfo = {
    data: {
      usable: undefined,
      unusable: undefined
    },
    status: "NotLoadedYet"
  };

  public DescriptionIT: DescriptionType[] = []

  public DescriptionEN: DescriptionType[] = [];


  ngOnInit(): void {
    const usable = this.wordInfo.data.usable;
    usable?.forEach(us => {
      us.Descriptions.filter(f => f.LangDesc === 'IT');
    })
    this.route.params.subscribe(
      (params) => {

        this.wordInfo = {
          data: {
            usable: undefined,
            unusable: undefined
          },
          status: "NotLoadedYet"
        };

        this.DescriptionEN = [];
        this.DescriptionIT = [];

        this.wordService.getWordInfo(params.word).subscribe(
          (res) => {
            this.wordInfo = res;
            this.wordInfo.data.usable?.forEach(us => {
              us.Descriptions.forEach(Description => {
                console.log(Description);
                switch (Description.LangDesc) {
                  default:
                    this.DescriptionEN.push({ "Description": this.sentenceFormatter(Description.Description), "descriptionID": Description.descriptionID, "Examples": [] });
                    return;
                  case 'IT':
                    this.DescriptionIT.push({ "Description": this.sentenceFormatter(Description.Description), "descriptionID": Description.descriptionID, "Examples": [] });
                    return;
                }
              });
              us.Examples.forEach(Example => {
                console.log(Example);
                switch (Example.LangExample) {
                  default:
                    this.DescriptionEN.forEach(Des => {
                      if (Des.descriptionID === Example.descriptionID)
                        Des.Examples?.push(this.sentenceFormatter(Example.Example));
                    })
                    return;

                  case 'IT':
                    this.DescriptionIT.forEach(Des => {
                      if (Des.descriptionID === Example.descriptionID)
                        Des.Examples?.push(this.sentenceFormatter(Example.Example));
                    })
                    return;
                }

              });
              /*
              console.log(this.DescriptionIT);
              console.log(this.DescriptionEN);
              */
            });
            /*
            console.log(res);
            */
          },
          (err) => {
            this.wordInfo.status = 'error';
            console.log(this.wordInfo.status);
          }
        );

        setTimeout(() => {
          if (this.wordInfo.status === 'NotLoadedYet') {
            this.wordInfo.status = 'error';
          }
        }, 5000)
      }
    )
  }

  // Questo metodo serve per inserire le MAIUSCOLE dopo i punti e a inizio frase.
  sentenceFormatter(sentence: string): string {
    let _sentenceFormatted: string = ``;
    console.log(sentence.substring(0, 1));
    _sentenceFormatted = sentence.split('.').map(s => s.toLowerCase().trim()).map(s => s.substring(0, 1).toUpperCase() + s.substring(1)).join('. ');
    console.log(_sentenceFormatted);
    return _sentenceFormatted;
  }

  // Questo serve per decidere la composizione della pagina in base ai dati acquisiti sulla parola
  wordStatus(wordInfo: WordInfo): number {
    switch (wordInfo.status) {
      case 'error':
        return -1;
      default:  //NotLoadedYet
        return 0;
      case 'NotUsableWord':
        return 1;
      case 'AddedWord':
        return 2;
      case 'FoundWord':
        return 3;
    }
  }


}

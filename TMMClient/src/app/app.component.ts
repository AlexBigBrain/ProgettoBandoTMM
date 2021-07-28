import { Component, HostListener, OnInit } from '@angular/core';
import { FormControl } from '@angular/forms';
import { Observable } from 'rxjs';
import { debounceTime, distinctUntilChanged, switchMap } from 'rxjs/operators';
import { WordService } from './word.service';



@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})

/*
  Questo componente è il componente 'principale' e gestisce quali componenti mostrare in quale momento,
  l'header e il footer.
*/
export class AppComponent implements OnInit {
  constructor(
    private wordService: WordService
  ) { }

  // Titolo della pagina WEB
  title = 'MyWordBOT';

  // Variabili per il monitoraggio delle dimensioni della pagina
  screenWidth: number = 0;
  screenHeight: number = 0;



  // Variabile e Metodo per la gestione del menu per dispositivi piccoli
  mobile_menu: boolean = false;
  mobileTranslation() {
    return this.mobile_menu ? "translate-x-0 opacity-100" : "translate-x-full opacity-0"
  }

// Variabile per l'utilizzo del LiveSearch
  word: string = '';
  myControl = new FormControl();
  filteredOptions: Observable<string[]> | undefined;


  ngOnInit() {
    this.filteredOptions = this.myControl.valueChanges.pipe(
      debounceTime(300),
      distinctUntilChanged(),
      switchMap(word => this.wordService.getLiveSearchWords(word)));
    this.screenWidth = window.innerWidth;
    this.screenHeight = window.innerHeight;
  }

// Questo metodo aggiorna le variabili di screenSize ogni volta che la finestra cambia dimensione
  @HostListener('window:resize', ['$event'])
  onResize(event: any) {
    this.screenWidth = window.innerWidth;
    this.screenHeight = window.innerHeight;

    console.log(this.screenHeight);
    console.log(this.screenWidth);
  }
}

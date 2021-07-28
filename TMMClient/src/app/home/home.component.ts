import { ViewportScroller } from '@angular/common';
import { Component, AfterViewInit, HostListener } from '@angular/core';
import { ActivatedRoute, Router, Scroll } from '@angular/router';
import { filter } from 'rxjs/operators';

/*
  Questo componente corrisponde alla home del sito.
*/


// Questo metodo è una mia creazione e serve per andare a un determinato anchor
// anche quando ci si trova in su un differente componente.
// Ho dovuto creare questo componente perché quello di Angular sembra non funzionare.
declare function myMethod(id: string, scrollOffset: number): any;
@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements AfterViewInit {

  screenWidth: number = 0;
  screenHeight: number = 0;

  constructor(private router: Router, private route: ActivatedRoute, private viewportScroller: ViewportScroller) { }

  // Questo metodo viene avviato quando si 'crea' la componente visuale di questo componente
  ngAfterViewInit(): void {
    // Inizializza le variabili che tengono traccia della larghezza e lunghezza dello schermo.
    this.screenWidth = window.innerWidth;
    this.screenHeight = window.innerHeight;

    // E' un metodo Observable che aspetta un evento di tipo router (cioè quando si cambia pagina),
    // serve per portare la schermata di un utente sull anchor da lui selezionato.
    this.router.events.pipe(filter((e: any): e is Scroll => e instanceof Scroll)
    ).subscribe(e => {
      if (e.anchor) {
        switch (true) {
          case this.screenWidth > 768:
            myMethod('#' + e.anchor, 145);
            return;
          case (this.screenWidth > 500 && this.screenWidth<= 768):
            myMethod('#' + e.anchor, 120);
            return;
          case this.screenWidth <= 500:
            myMethod('#' + e.anchor, 100);
            return;
        }
      }
    });
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

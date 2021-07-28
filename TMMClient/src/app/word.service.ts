import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { takeUntil } from 'rxjs/operators';
import { timer } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
  /*
    In questo servizio sono contenute tutte le funzioni utili per l'acquisizione di tutte le informazioni
    su una parola o per l'utilizzo del Live Search
  */
export class WordService {

  constructor(private http: HttpClient) { }

  wordURL = 'https://tmmserver3.herokuapp.com/api';
  searchURL = 'https://tmmserver3.herokuapp.com/api/search';


  /*
  private handleError(error: HttpErrorResponse): any {
    if (error.status === 0) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', error.error);
    } else {
      // The backend returned an unsuccessful response code.
      // The response body may contain clues as to what went wrong.
      console.error(
        `Backend returned code ${error.status}, ` +
        `body was: ${error.error}`);
    }
    // Return an observable with a user-facing error message.
    return error.error;
  }
  */

  getWordInfo(Word: string) {
    const params = { params: new HttpParams().set('word', Word) };
    return this.http.get<any>(this.wordURL, params)
      .pipe(
        takeUntil(timer(5000))
      );
  }

  getLiveSearchWords(Word: string) {
    const params = { params: new HttpParams().set('word', Word) };
    return this.http.get<any>(this.searchURL, params)
      .pipe(
        takeUntil(timer(5000))
      );
  }
}

import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatAutocompleteModule } from '@angular/material/autocomplete'
import { MatFormFieldModule } from '@angular/material/form-field'
import { FormsModule, ReactiveFormsModule, FormControl } from '@angular/forms';
import { MatDividerModule } from '@angular/material/divider';
import { MatButtonModule } from '@angular/material/button';
import { HomeComponent } from './home/home.component';
import { WordComponent } from './word/word.component'
import { HttpClientModule } from '@angular/common/http';
import { WordService } from "./word.service";
/**
 * NgModule that includes all Material modules.
*/

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    WordComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatAutocompleteModule,
    MatFormFieldModule,
    ReactiveFormsModule,
    MatDividerModule,
    MatButtonModule,
    HttpClientModule,
    FormsModule
  ],
  providers: [WordService],
  bootstrap: [AppComponent]
})
export class AppModule {/*  constructor(router: Router, viewportScroller: ViewportScroller) {
    router.events.pipe(
      tap((e: any) => {
        console.log('ue');
        console.log(e);
      }),
      filter((e: any): e is Scroll => e instanceof Scroll)
    ).subscribe(e => {
      console.log('ueue');
      console.log(e);
      if (e.position) {
        // backward navigation
        viewportScroller.scrollToPosition(e.position);
      } else if (e.anchor) {
        // anchor navigation
        viewportScroller.scrollToAnchor(e.anchor);
      } else {
        // forward navigation
        viewportScroller.scrollToPosition([0, -10000]);
      }
    });
  }
  */
}

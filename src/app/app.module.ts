import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppComponent } from './app.component';
import { StoreModule } from '@ngrx/store';
import { EffectsModule } from '@ngrx/effects';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { environment } from '../environments/environment';
import { ACESSMSModule } from './acesssmfeatureACESSM/acessm.module';
import { TaskStructureModule } from './acesssmfeatureACESSM/taskStructure/task-structure.module';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
	CommonModule,
    StoreModule.forRoot({}, {}),
    EffectsModule.forRoot([]),
	ACESSMSModule,
    StoreDevtoolsModule.instrument({ maxAge: 25, logOnly: environment.production }),
	TaskStructureModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }

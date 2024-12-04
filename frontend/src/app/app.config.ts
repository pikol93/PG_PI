import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideHttpClient } from '@angular/common/http';
import { provideAnimations } from '@angular/platform-browser/animations';

import { SessionService } from './session.service';
import { provideRouter, withComponentInputBinding } from '@angular/router';
import { Routes } from '@angular/router';
import { AppMainComponent } from './app-main/app-main.component';
      

const routes: Routes = [  
  { path: 'ui/:sessionUuid', component: AppMainComponent },
];

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideHttpClient(),
    SessionService,
    provideAnimations(),
    provideRouter(routes, withComponentInputBinding()),
  ],
};

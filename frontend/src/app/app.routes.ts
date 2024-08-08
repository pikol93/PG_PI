import { Routes } from '@angular/router';
import { AppCalendarComponent } from './app-calendar/app-calendar.component';
import { AppLoginComponent } from './app-login/app-login.component';
import { AppContactComponent } from './app-contact/app-contact.component';
import { AppMainComponent } from './app-main/app-main.component';

export const routes: Routes = [
    { path: 'calendar', component: AppCalendarComponent },
    { path: 'login', component: AppLoginComponent },
    { path: 'contact', component: AppContactComponent },
    { path: 'main', component: AppMainComponent },
  ];

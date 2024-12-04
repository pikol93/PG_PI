import { Component } from '@angular/core';
import { AppMainComponent } from './app-main/app-main.component';
import { AppFooterComponent } from './app-footer/app-footer.component';
import { RouterOutlet, RouterLink, RouterLinkActive, ActivatedRoute } from '@angular/router';

export interface User {
  first_name: string;
  last_name: string;
  username: string;
  email: string;
}

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    AppMainComponent,
    AppFooterComponent,
    RouterOutlet, RouterLink, RouterLinkActive
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent {
  title = 'frontend';
}

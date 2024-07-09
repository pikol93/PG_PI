import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [RouterModule],
  templateUrl: './app-nav.component.html',
  styleUrl: './app-nav.component.css'
})
export class AppNavComponent {
}

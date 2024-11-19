import { Component, OnInit } from '@angular/core';
import { UserService } from './user.service';
import { AppMainComponent } from './app-main/app-main.component';
import { AppFooterComponent } from './app-footer/app-footer.component';

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
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent implements OnInit {
  title = 'frontend';

  user: User = {
    first_name: '',
    last_name: '',
    username: '',
    email: '',
  };

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.userService.getUser('username_value').subscribe((user) => {
      this.user = user;
    });
  }
}

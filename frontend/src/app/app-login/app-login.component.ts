import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { UserService } from '../user.service';

export interface User {
  first_name: string;
  last_name: string;
  username: string;
  email: string;
}

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [RouterModule],
  templateUrl: './app-login.component.html',
  styleUrl: './app-login.component.css'
})
export class AppLoginComponent {
  user: User = {
    first_name: '',
    last_name: '',
    username: '',
    email: '',
  };

  constructor(private userService: UserService) {
  }

  ngOnInit(): void {
    this.userService.getUser('username_value').subscribe(user => {
      this.user = user;
    });
  }
}


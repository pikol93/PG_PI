import {Injectable} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Observable} from "rxjs";
import { User } from './app.component';

@Injectable({
providedIn: 'root',
})
export class UserService {
  constructor(private http: HttpClient) {
  }

  getUser(username: string) {
    return this.http.get<User>(`/api/get_user/${username}`)
    }
}

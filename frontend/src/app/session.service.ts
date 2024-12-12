import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface SetInWorkout {
    intensity: number;
    reps: number;
  }
  
  export interface ExerciseInWorkout {
    exerciseId: number;
    sets: SetInWorkout[];
  }
  
  export interface Workout {
    id: number;
    name: string;
    exercises: ExerciseInWorkout[];
  }
  
  export interface Routine {
    id: number;
    name: string;
    workouts: Workout[];
  }
  
  export interface Exercise {
    id: number;
    name: string;
    oneRepMaxList: any;
  }
  
  export interface Set {
    weight: number;
    reps: number;
    rpe: number;
    restSecs: number;
  }
  
  export interface ExerciseInSet {
    exerciseId: number;
    sets: Set[];
  }
  
  export interface Session {
    id: number;
    routineId: number;
    workoutId: number;
    startTimestamp: number;
    exercises: ExerciseInSet[];
  }
  
  export interface SessionData {
    sessions: Session[];
    exercises: Exercise[];
    routines: Routine[];
  }
  
  export interface Sessions {
    uuid: string;
    expiration_date: string;
    data: SessionData;
  }

@Injectable({
  providedIn: 'root',
})
export class SessionService {
  constructor(private http: HttpClient) {}

  getSession(sessionUuid: string): Observable<any> {
    return this.http.get<any>(`/api/session/${sessionUuid}`, { responseType: 'json' });
  }
}

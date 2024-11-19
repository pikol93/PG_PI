import {Component} from '@angular/core';
import payloadData from '../../assets/data/payload.json'; // Import pliku JSON
import { RouterOutlet } from '@angular/router';
import { TableModule } from 'primeng/table';
import { InputSwitchModule } from 'primeng/inputswitch';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

export interface OneRepMax {
  weight: number;
  date: Date;
}

export interface OneRepMaxCollection {
  [key: string]: OneRepMax[];
}

export interface TrainingExerciseSetDatatable {
  date: Date;
  name: string;
  weight: number;
  reps: number;
  rpe: number;
  uuid: string;
}

export interface TrainingExerciseSet {
  expectedReps: number;
  expectedWeight: number;
  expectedIntensity: number;
  weight: number;
  reps: number;
  rpe: number;
  uuid: string;
}

export interface TrainingExercise {
  name: string;
  expectedNumberOfSets: number;
  performedSets: TrainingExerciseSet[];
  restTime: number;
}

export interface Training {
  date: Date;
  exercises: TrainingExercise[];
}

export interface Payload {
  user: string;
  raport_number: string;
  trainings: Training[];
  oneRepMaxs: OneRepMaxCollection;
}

@Component({
  selector: 'app-main',
  standalone: true,
  imports: [TableModule, InputSwitchModule, FormsModule, CommonModule],
  templateUrl: './app-main.component.html',
  styleUrl: './app-main.component.css',
})
export class AppMainComponent {
  payload: Payload = this.transformPayload(payloadData); // Przypisanie danych do obiektu

  private transformPayload(data: any): Payload {
    data.trainings.forEach((training: any) => {
      training.date = new Date(training.date);
    });
    return data;
  }

  allRows = this.payload.trainings.map((training: Training) => {
    return training.exercises.map((exercise: TrainingExercise) => {
      return exercise.performedSets.map((set: TrainingExerciseSet) => {
        return {
          date: training.date,
          name: exercise.name,
          weight: set.weight,
          reps: set.reps,
          rpe: set.rpe,
          uuid: set.uuid,
        };
      });
    });
  }).flat(2) as TrainingExerciseSetDatatable[];

  selectedProducts!: TrainingExerciseSetDatatable;
}
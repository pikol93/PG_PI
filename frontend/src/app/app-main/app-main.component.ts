import payloadData from '../../assets/data/payload.json';
import { Component } from '@angular/core';
import { TableModule } from 'primeng/table';
import { InputTextModule } from 'primeng/inputtext';
import { MultiSelectModule } from 'primeng/multiselect';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ChartModule } from 'primeng/chart';

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
  imports: [TableModule, ChartModule, InputTextModule, MultiSelectModule, CommonModule, FormsModule],  
  templateUrl: './app-main.component.html',
  styleUrl: './app-main.component.css',
})
export class AppMainComponent {
  payload: Payload = this.transformPayload(payloadData);
  data: any;
  chartOptions: any;

  private transformPayload(data: any): Payload {
    data.trainings.forEach((training: any) => {
      training.date = new Date(training.date);
    });
    data.oneRepMaxs = Object.keys(data.oneRepMaxs).reduce((acc, key) => {
      acc[key] = data.oneRepMaxs[key].map((oneRepMax: any) => ({
        ...oneRepMax,
        date: new Date(oneRepMax.date),
      }));
      return acc;
    }, {} as OneRepMaxCollection);
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

  private _selectedSets: TrainingExerciseSetDatatable[] = [];

  get selectedSets(): TrainingExerciseSetDatatable[] {
    return this._selectedSets;
  }

  set selectedSets(value: TrainingExerciseSetDatatable[]) {
    this._selectedSets = value;
    this.updateChartData();
  }

  onFilterChange(event: any) {
    console.log('Current filters:', event.filters);
  }

  private updateChartData() {
    const uniqueDates = Array.from(new Set(this.selectedSets.map(set => set.date.toISOString().split('T')[0])));
    uniqueDates.sort();

    const dates = this.selectedSets.map(set => set.date.toISOString().split('T')[0]);
    dates.sort();
  
    const lineData = dates.map(date => {
      const oneRepMax = this.findOneRepMaxForDate(date, this.selectedSets[0].name);
      return oneRepMax ? oneRepMax.weight : 0;
    });
  
    const barData = this.selectedSets.map(set => set.weight);

    const colors = [
      'rgba(255, 99, 132, 0.2)',
      'rgba(54, 162, 235, 0.2)',
      'rgba(255, 206, 86, 0.2)',
      'rgba(75, 192, 192, 0.2)',
      'rgba(153, 102, 255, 0.2)',
    ];
    
    const borderColors = [
      'rgba(255, 99, 132, 1)',
      'rgba(54, 162, 235, 1)',
      'rgba(255, 206, 86, 1)',
      'rgba(75, 192, 192, 1)',
      'rgba(153, 102, 255, 1)',
    ];
    
    const dateColorMap = new Map<string, string>();
    const dateBorderColorMap = new Map<string, string>();

    uniqueDates.forEach((date, index) => {
      const colorIndex = index % colors.length;
      dateColorMap.set(date, colors[colorIndex]);
      dateBorderColorMap.set(date, borderColors[colorIndex]);
    });

    const barBackgroundColors = dates.map(date => dateColorMap.get(date));
    const barBorderColors = dates.map(date => dateBorderColorMap.get(date));

    this.data = {
      labels: dates,
      datasets: [
        {
          type: 'line',
          label: 'One Rep Max',
          data: lineData,
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          borderColor: 'rgba(75, 192, 192, 1)',
          borderWidth: 1,
        },
        {
          type: 'bar',
          label: 'Selected Sets',
          data: barData,
          backgroundColor: barBackgroundColors,
          borderColor: barBorderColors,
          borderWidth: 1,
        },
      ],
    };
  
    this.chartOptions = {
      scales: {
        x: {
          grid: {
            display: false
          }
        },
        y: {
          grid: {
            display: true
          }
        }
      },
      plugins: {
        legend: {
          display: false
        }
      },
      elements: {
        bar: {
          barPercentage: 1.0,
          categoryPercentage: 1.0
        },
      }
    };
  }

  private findOneRepMaxForDate(date: string, exerciseName: string): OneRepMax | null {
    const dateObj = new Date(date);
    const oneRepMaxsForExercise = this.payload.oneRepMaxs[exerciseName];
    if (!oneRepMaxsForExercise) {
      return null;
    }
    const sortedOneRepMaxs = oneRepMaxsForExercise.sort((a, b) => a.date.getTime() - b.date.getTime());
    for (let i = sortedOneRepMaxs.length - 1; i >= 0; i--) {
      if (sortedOneRepMaxs[i].date.getTime() <= dateObj.getTime()) {
        return sortedOneRepMaxs[i];
      }
    }
    return null;
  }
}
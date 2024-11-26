import payloadData from '../../assets/data/payload.json';
import { Component } from '@angular/core';
import { TableModule } from 'primeng/table';
import { MultiSelectModule } from 'primeng/multiselect';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ChartModule } from 'primeng/chart';
import { ButtonModule } from 'primeng/button';

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
  oneRepMax: number;
  groupedByDate: string;
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
  imports: [TableModule, ChartModule, MultiSelectModule, CommonModule, FormsModule, ButtonModule],
  templateUrl: './app-main.component.html',
  styleUrl: './app-main.component.css',
})
export class AppMainComponent {

  payload: Payload = this.transformPayload(payloadData);
  graphData: any;
  chartOptions: any;
  isSelectCheckboxDisabled = true;
  showChart: boolean = false;
  isGraphButtonDisabled: boolean = true;

  uniqueExerciseNames: { label: string, value: string }[] = [];

  constructor() {
    this.uniqueExerciseNames = Array.from(new Set(this.allRows.map(row => row.name)))
      .map(name => ({ label: name, value: name }));
  }

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
          oneRepMax: this.findOneRepMaxForDate(training.date.toISOString().split('T')[0], exercise.name)?.weight,
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
    const filterValue = event.filters.name?.value || [];
    if (filterValue.length === 1) {
      this.isGraphButtonDisabled = false;
      this.isSelectCheckboxDisabled = false;
    } else {
      this.isSelectCheckboxDisabled = true;
      this.isGraphButtonDisabled = true;
      this.showChart = false;
      this.selectedSets = [];
    }
  }

  toggleChart() {
    this.showChart = !this.showChart;
  }

  formatDate(date: Date): string {
    const options: Intl.DateTimeFormatOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    return new Intl.DateTimeFormat('pl-PL', options).format(date);
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

    const expectedOneRepMaxData = this.selectedSets.map(set =>
      this.calculateExpectedOneRepMax(set.weight, set.reps).toFixed(0)
    );

    const barBackgroundColors = dates.map(date => dateColorMap.get(date));
    const barBorderColors = dates.map(date => dateBorderColorMap.get(date));

    this.graphData = {
      labels: dates,
      datasets: [
        {
          type: 'line',
          label: '1RM',
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
        {
          type: 'scatter',
          label: 'Expected 1RM',
          data: expectedOneRepMaxData,
          backgroundColor: 'rgba(255, 159, 64, 0.2)',
          borderColor: 'rgba(255, 159, 64, 1)',
          borderWidth: 1,
          pointStyle: 'star',
        }
      ]
    };

    this.chartOptions = {
      interaction: {
        mode: 'index',
        intersect: false,
      },
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
          labels: {
            filter: function (item: any, chart: any) {
              return item.text !== 'Selected Sets';
            },
            usePointStyle: true,
          }
        },
        tooltip: {
          mode: 'index',
          intersect: false,
          callbacks: {
            label: function (context: any) {
              if (context.dataset.label === 'Expected 1RM') {
                return `Expected 1RM: ${context.raw}`;
              }
              return `${context.dataset.label}: ${context.raw}`;
            }
          }
        }
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

  calculateExpectedOneRepMax(weight: number, repetitions: number): number {
    const percentageMap = new Map<number, number>([
      [1, 1.00],
      [2, 0.97],
      [3, 0.94],
      [4, 0.92],
      [5, 0.89],
      [6, 0.86],
      [7, 0.83],
      [8, 0.81],
      [9, 0.78],
      [10, 0.75],
      [11, 0.73],
      [12, 0.71],
    ]);

    const percentage = percentageMap.get(repetitions) || 0.71;
    return weight / percentage;
  }
}
import { Component, Input, OnInit } from '@angular/core';
import { TableModule } from 'primeng/table';
import { MultiSelectModule } from 'primeng/multiselect';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ChartModule } from 'primeng/chart';
import { ButtonModule } from 'primeng/button';
import { Exercise, ExerciseInWorkout, Routine, SessionData, Sessions, SessionService } from '../session.service';
import { ActivatedRoute, RouterOutlet } from '@angular/router';

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
}

export interface Training {
  date: Date;
  exercises: TrainingExercise[];
}

export interface Payload {
  trainings: Training[];
  oneRepMaxs: OneRepMaxCollection;
}

@Component({
  selector: 'app-main',
  standalone: true,
  imports: [TableModule, ChartModule, MultiSelectModule, CommonModule, FormsModule, ButtonModule, RouterOutlet],
  templateUrl: './app-main.component.html',
  styleUrl: './app-main.component.css',
})

export class AppMainComponent implements OnInit {
  @Input() sessionUuid: string | undefined;

  constructor(private sessionService: SessionService, private route: ActivatedRoute) {
    this.route.params.subscribe((params) => {
      this.sessionUuid = params['sessionUuid'];
      console.log(this.sessionUuid);
    });
  }

  ngOnInit(): void {
    if (this.sessionUuid) {
      this.sessionService.getSession(this.sessionUuid).subscribe(
        (session: Sessions) => {
          this.payload = this.transformPayload(session.data);
          this.allRows = this.getAllRows();
          this.initializeUniqueExerciseNames();
        },
        (error) => {
          console.error('Error fetching session:', error);
        }
      );
    }
  }
  payload: Payload | undefined;
  graphData: any;
  chartOptions: any;
  isSelectCheckboxDisabled = true;
  showChart: boolean = false;
  isGraphButtonDisabled: boolean = true;

  uniqueExerciseNames: { label: string, value: string }[] = [];

  private initializeUniqueExerciseNames() {
    if (this.payload) {
      this.uniqueExerciseNames = Array.from(new Set(this.allRows.map(row => row.name)))
        .map(name => ({ label: name, value: name }));
    }
  }

  private transformPayload(data: SessionData): Payload {
    var nextId = 0;
    const trainings: Training[] = data.sessions.map(session => ({
      date: new Date(session.startTimestamp),
      exercises: session.exercises.map(exercise => {
        const routineExercise = this.findRoutineExercise(data.routines, session.routineId, exercise.exerciseId);
        return {
          name: this.findExerciseNameById(data.exercises, exercise.exerciseId),
          expectedNumberOfSets: exercise.sets.length,
          performedSets: exercise.sets.map((set, index) => {
            const performedSet = {
              expectedReps: routineExercise ? routineExercise.sets[index]?.reps : set.reps,
              expectedWeight: set.weight,
              expectedIntensity: routineExercise ? routineExercise.sets[index]?.intensity : set.rpe,
              weight: set.weight,
              reps: set.reps,
              rpe: set.rpe,
              uuid: nextId.toString(),
            };
            nextId++;
            return performedSet;
          }),
        };
      })
    }));

    const oneRepMaxs: OneRepMaxCollection = data.exercises.reduce((acc, exercise) => {
      acc[exercise.name] = exercise.oneRepMaxList.map((oneRepMax: any) => ({
        weight: oneRepMax.value,
        date: new Date(oneRepMax.timestamp),
      }));
      return acc;
    }, {} as OneRepMaxCollection);

    return {
      trainings,
      oneRepMaxs,
    };
  }

  private findRoutineExercise(routines: Routine[], routineId: number, exerciseId: number): ExerciseInWorkout | null {
    const routine = routines.find(r => r.id === routineId);
    if (!routine) return null;

    for (const workout of routine.workouts) {
      const exercise = workout.exercises.find(e => e.exerciseId === exerciseId);
      if (exercise) return exercise;
    }

    return null;
  }

  private findExerciseNameById(exercises: Exercise[], id: number): string {
    const exercise = exercises.find(ex => ex.id === id);
    return exercise ? exercise.name : 'Unknown';
  }

  allRows: TrainingExerciseSetDatatable[] = [];

  getAllRows(): TrainingExerciseSetDatatable[] {
    if (!this.payload) {
      return [];
    }
    return this.payload.trainings.map((training: Training) => {
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
  }

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
          label: 'Wybrane serie',
          data: barData,
          backgroundColor: barBackgroundColors,
          borderColor: barBorderColors,
          borderWidth: 1,
        },
        {
          type: 'scatter',
          label: 'Szacowany 1RM',
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
              return item.text !== 'Wybrane serie';
            },
            usePointStyle: true,
          }
        },
        tooltip: {
          mode: 'index',
          intersect: false,
          callbacks: {
            label: function (context: any) {
              if (context.dataset.label === 'Szacowany 1RM') {
                return `Szacowany 1RM: ${context.raw}`;
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
    if (!this.payload || !this.payload.oneRepMaxs) {
      return null;
    }
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
      [2, 0.92],
      [3, 0.90],
      [4, 0.87],
      [5, 0.85],
      [6, 0.82],
      [7, 0.80],
      [8, 0.75],
      [9, 0.73],
      [10, 0.70],
      [11, 0.68],
      [12, 0.65],
    ]);

    const percentage = percentageMap.get(repetitions) || 0.65;
    return weight / percentage;
  }
}
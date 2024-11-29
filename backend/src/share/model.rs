use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct ShareRequest {
    pub validity_millis: u64,
    pub shared_data: DataToShare,
}

#[derive(Serialize)]
pub struct ShareResponse {
    pub id: String,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct DataToShare {
    pub share_timestamp: u64,
    pub sessions: Vec<SharedSession>,
    pub exercises: Vec<SharedExercise>,
    pub routines: Vec<SharedRoutine>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct SharedSession {
    pub id: u64,
    pub routine_id: u64,
    pub workout_id: u64,
    pub start_timestamp: u64,
    pub exercises: Vec<SharedSessionExercise>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct SharedSessionExercise {
    pub exercise_id: u64,
    pub sets: Vec<SharedSet>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct SharedSet {
    pub reps: u64,
    pub weight: f64,
    pub rpe: f64,
    pub rest_secs: u64,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct SharedExercise {
    pub id: u64,
    pub name: String,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct SharedRoutine {
    pub id: u64,
    pub name: String,
    pub workouts: Vec<SharedWorkout>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct SharedWorkout {
    pub id: u64,
    pub name: String,
    pub exercises: Vec<SharedWorkoutExercise>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct SharedWorkoutExercise {
    pub exercise_id: u64,
    pub sets: Vec<SharedExerciseSet>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct SharedExerciseSet {
    pub intensity: f64,
    pub reps: u64,
}

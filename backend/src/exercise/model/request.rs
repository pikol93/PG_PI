use serde::Deserialize;

#[derive(Deserialize, Debug, Clone)]
pub struct AddExerciseRequest {
    pub name: String,
}

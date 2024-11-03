use serde::{Deserialize, Serialize};

#[derive(Serialize, Debug, Clone)]
pub struct PuzzleResponse {
    pub uuid: String,
}

#[derive(Deserialize, Debug, Clone)]
pub struct PuzzleSolutionRequest {
    pub uuid: String,
    pub solution: String,
}

#[derive(Serialize, Debug, Clone)]
pub struct PuzzleSolutionResponse {
    pub token: String,
}

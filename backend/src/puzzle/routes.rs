use actix_web::{post, web::Json, Responder};
use mongodb::bson::Uuid;

use crate::puzzle::model::{PuzzleResponse, PuzzleSolutionResponse};

use super::model::PuzzleSolutionRequest;

#[post("/request_puzzle")]
pub async fn route_request_puzzle() -> impl Responder {
    let uuid = Uuid::new();
    Json(PuzzleResponse {
        uuid: uuid.to_string(),
    })
}

#[post("/puzzle_solution")]
pub async fn route_puzzle_solution(solution: Json<PuzzleSolutionRequest>) -> impl Responder {
    dbg!(solution);
    let uuid = Uuid::new();
    Json(PuzzleSolutionResponse {
        token: uuid.to_string(),
    })
}

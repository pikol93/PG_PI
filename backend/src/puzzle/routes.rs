use actix_web::{
    post,
    web::{Data, Json},
    HttpResponse, Responder,
};
use tracing::warn;
use uuid::Uuid;

use crate::puzzle::model::{PuzzleResponse, PuzzleSolutionResponse};

use super::{
    model::PuzzleSolutionRequest,
    service::{authorization::AuthorizationStoreService, puzzle::PuzzleStoreService},
};

#[post("/request_puzzle")]
pub async fn route_request_puzzle(
    puzzle_store_service: Data<PuzzleStoreService>,
) -> impl Responder {
    let uuid = puzzle_store_service.create_entry().await;
    let response = PuzzleResponse {
        uuid: uuid.to_string(),
    };

    HttpResponse::Ok().json(response)
}

#[post("/puzzle_solution")]
pub async fn route_puzzle_solution(
    puzzle_store_service: Data<PuzzleStoreService>,
    authorization_store_service: Data<AuthorizationStoreService>,
    solution: Json<PuzzleSolutionRequest>,
) -> impl Responder {
    let verify_result = puzzle_store_service
        .verify_solution(&solution.uuid, &solution.solution)
        .await;
    if let Err(error) = verify_result {
        warn!("Could not verify. {}", error);
        return HttpResponse::Unauthorized().finish();
    };

    let uuid = Uuid::new_v4();
    authorization_store_service.insert_entry(uuid).await;
    let response = PuzzleSolutionResponse {
        token: uuid.to_string(),
    };

    HttpResponse::Ok().json(response)
}

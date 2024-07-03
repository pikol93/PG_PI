use crate::application_state::ApplicationState;
use crate::exercise::model::Exercise;
use actix_web::web::{Data, Form, Path};
use actix_web::{get, post, HttpResponse, Responder};
use mongodb::bson::oid::ObjectId;

#[post("/add_exercise")]
pub async fn add_exercise(state: Data<ApplicationState>, form: Form<Exercise>) -> impl Responder {
    let exercise = form.into_inner();
    let result = state.exercise_repository.add_exercise(&exercise).await;

    match result {
        Ok(_) => HttpResponse::Ok().finish(),
        Err(err) => HttpResponse::InternalServerError().json(err.to_string()),
    }
}

#[get("/get_exercise/{id}")]
pub async fn get_exercise(state: Data<ApplicationState>, id: Path<ObjectId>) -> HttpResponse {
    let result = state.exercise_repository.get_exercise_by_id(&id).await;

    match result {
        Ok(Some(exercise)) => HttpResponse::Ok().json(exercise),
        Ok(None) => HttpResponse::NotFound().finish(),
        Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
    }
}

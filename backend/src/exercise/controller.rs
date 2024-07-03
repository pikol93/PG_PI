use actix_web::web::{Data, Form, Path};
use actix_web::{get, post, HttpResponse, Responder};
use mongodb::bson::oid::ObjectId;

use crate::exercise::model::Exercise;
use crate::exercise::repository::ExerciseRepository;

#[post("/add_exercise")]
pub async fn add_exercise(
    exercise_repository: Data<dyn ExerciseRepository>,
    form: Form<Exercise>,
) -> impl Responder {
    let exercise = form.into_inner();
    let result = exercise_repository.add_exercise(&exercise).await;

    match result {
        Ok(_) => HttpResponse::Ok().finish(),
        Err(err) => HttpResponse::InternalServerError().json(err.to_string()),
    }
}

#[get("/get_exercise/{id}")]
pub async fn get_exercise(
    exercise_repository: Data<dyn ExerciseRepository>,
    id: Path<ObjectId>,
) -> HttpResponse {
    let result = exercise_repository.get_exercise_by_id(&id).await;

    match result {
        Ok(Some(exercise)) => HttpResponse::Ok().json(exercise),
        Ok(None) => HttpResponse::NotFound().finish(),
        Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
    }
}

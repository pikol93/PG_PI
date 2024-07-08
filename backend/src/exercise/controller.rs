use actix_web::web::{Data, Form, Path};
use actix_web::{get, post, HttpResponse, Responder};
use mongodb::bson::oid::ObjectId;

use crate::exercise::model::AddExerciseModel;
use crate::exercise::repository::ExerciseRepository;

#[post("/add_exercise")]
pub async fn add_exercise(
    exercise_repository: Data<dyn ExerciseRepository>,
    form: Form<AddExerciseModel>,
) -> impl Responder {
    let exercise = form.into_inner();
    let result = exercise_repository.add_exercise(&exercise).await;

    match result {
        Ok(_) => HttpResponse::Ok().finish(),
        Err(err) => HttpResponse::InternalServerError().json(err.to_string()),
    }
}

#[get("/get_exercises")]
pub async fn get_exercises(exercise_repository: Data<dyn ExerciseRepository>) -> impl Responder {
    let result = exercise_repository.get_exercises().await;

    match result {
        Ok(exercises) => HttpResponse::Ok().json(exercises),
        Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
    }
}

#[get("/get_exercise/{id}")]
pub async fn get_exercise(
    exercise_repository: Data<dyn ExerciseRepository>,
    id: Path<String>,
) -> HttpResponse {
    let Ok(id) = ObjectId::parse_str(id.as_ref()) else {
        return HttpResponse::BadRequest().finish();
    };

    let result = exercise_repository.get_exercise_by_id(&id).await;

    match result {
        Ok(Some(exercise)) => HttpResponse::Ok().json(exercise),
        Ok(None) => HttpResponse::NotFound().finish(),
        Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
    }
}

#[get("/get_exercises_by_user/{id}")]
pub async fn get_exercises_by_user(
    exercise_repository: Data<dyn ExerciseRepository>,
    id: Path<String>,
) -> impl Responder {
    let Ok(id) = ObjectId::parse_str(id.as_ref()) else {
        return HttpResponse::BadRequest().finish();
    };

    // TODO: The received ID is to be verified. The user might not exist.
    let result = exercise_repository.get_exercises_by_user_id(&id).await;

    match result {
        Ok(exercises) => HttpResponse::Ok().json(exercises),
        Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
    }
}

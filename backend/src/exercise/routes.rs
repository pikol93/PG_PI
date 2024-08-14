use actix_session::Session;
use actix_web::web::{Data, Form};
use actix_web::{get, put, HttpResponse, Responder};
use tracing::error;

use crate::exercise::model::request::AddExerciseRequest;
use crate::exercise::model::response::MultipleExercisesResponse;
use crate::exercise::repository::ExerciseRepository;
use crate::user::utility::validate_and_renew_session;

#[get("/exercises")]
pub async fn route_exercises(
    session: Session,
    exercise_repository: Data<ExerciseRepository>,
) -> impl Responder {
    let Ok(user_id) = validate_and_renew_session(&session) else {
        return HttpResponse::Unauthorized().finish();
    };

    let get_exercises_result = exercise_repository.get_exercises_by_user_id(&user_id).await;
    let exercises = match get_exercises_result {
        Ok(exercises) => exercises,
        Err(err) => {
            error!(
                "Could not get exercises for user: {}. Reason = {}",
                user_id, err
            );
            return HttpResponse::InternalServerError().finish();
        }
    };

    let convertion_result = MultipleExercisesResponse::convert_from(exercises);
    let response = match convertion_result {
        Ok(response) => response,
        Err(err) => {
            error!("Could not convert multiple exercises. Error = {}", err);
            return HttpResponse::InternalServerError().finish();
        }
    };

    HttpResponse::Ok().json(response)
}

#[put("/exercise")]
pub async fn route_put_exercise(
    session: Session,
    exercise_repository: Data<ExerciseRepository>,
    form: Form<AddExerciseRequest>,
) -> impl Responder {
    let Ok(user_id) = validate_and_renew_session(&session) else {
        return HttpResponse::Unauthorized().finish();
    };

    let request = form.0;
    let add_result = exercise_repository
        .add_exercise(request.name, user_id)
        .await;

    let exercise_id = match add_result {
        Ok(_exercise_id) => _exercise_id,
        Err(err) => {
            error!(
                "Could not add exercise for user {:?}. Error = {}",
                user_id, err
            );
            return HttpResponse::InternalServerError().finish();
        }
    };

    HttpResponse::Created().json(exercise_id)
}

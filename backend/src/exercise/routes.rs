use actix_session::Session;
use actix_web::web::Data;
use actix_web::{get, HttpResponse, Responder};
use tracing::error;

use crate::exercise::repository::ExerciseRepository;
use crate::session::utility::validate_and_renew_session;

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

    HttpResponse::Ok().json(exercises)
}

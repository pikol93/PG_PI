use actix_session::Session;
use actix_web::{
    post,
    web::{Data, Form},
    HttpResponse, Responder,
};
use tracing::{error, info};

use crate::{
    user::repository::UserRepository,
    user::{
        model::request::{LoginRequest, RegisterRequest},
        utility::set_user_id,
    },
};

#[post("/register")]
pub async fn register(
    user_repository: Data<UserRepository>,
    form: Form<RegisterRequest>,
    session: Session,
) -> impl Responder {
    // TODO: Consider returning an error if a user is already logged in
    let add_user_result = user_repository.as_ref().add_user(form.name.clone()).await;

    let Ok(user_id) = add_user_result else {
        return HttpResponse::BadRequest().body("Could not add user.");
    };

    if let Err(_) = set_user_id(&session, &user_id) {
        return HttpResponse::InternalServerError().body("Could not insert user ID.");
    };

    HttpResponse::Ok().finish()
}

#[post("/login")]
pub async fn login(
    user_repository: Data<UserRepository>,
    form: Form<LoginRequest>,
    session: Session,
) -> impl Responder {
    // TODO: Consider returning an error if a user is already logged in
    let get_user_result = user_repository.get_user_by_name(&form.name).await;

    let user_id = match get_user_result {
        Ok(Some(user)) => user.id,
        Ok(None) => return HttpResponse::Unauthorized().finish(),
        Err(err) => {
            error!("Error while trying to get user: {}", err);
            return HttpResponse::InternalServerError().finish();
        }
    };

    let Some(user_id) = user_id else {
        error!(
            "Could not get user ID since no object ID is tied to the user {}.",
            form.name
        );
        return HttpResponse::InternalServerError().finish();
    };

    if let Err(_) = set_user_id(&session, &user_id) {
        return HttpResponse::InternalServerError().body("Could not insert user ID.");
    };

    HttpResponse::Ok().finish()
}

#[post("/logout")]
pub async fn logout(session: Session) -> impl Responder {
    info!("Logout: {:?}", session.status());
    session.clear();
    HttpResponse::Ok()
}

use actix_web::web::{Data, Form, Path};
use actix_web::{get, post, HttpResponse, Responder};

use crate::user::model::AddUserModel;
use crate::user::repository::UserRepository;

#[post("/add_user")]
pub async fn add_user(
    user_repository: Data<dyn UserRepository>,
    form: Form<AddUserModel>,
) -> impl Responder {
    let user = form.into_inner();
    let result = user_repository.add_user(&user).await;

    match result {
        Ok(_) => HttpResponse::Ok().finish(),
        Err(err) => HttpResponse::InternalServerError().json(err.to_string()),
    }
}

#[get("/get_user/{username}")]
pub async fn get_user(
    user_repository: Data<dyn UserRepository>,
    username: Path<String>,
) -> HttpResponse {
    let result = user_repository.get_user_by_name(&username).await;

    match result {
        Ok(Some(user)) => HttpResponse::Ok().json(user),
        Ok(None) => {
            HttpResponse::NotFound().body(format!("No user found with username {username}"))
        }
        Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
    }
}

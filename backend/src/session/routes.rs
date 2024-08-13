use actix_web::{post, web::Form, HttpResponse, Responder};
use tracing::info;

use crate::session::model::request::{LoginRequest, RegisterRequest};

#[post("/register")]
pub async fn register(form: Form<RegisterRequest>) -> impl Responder {
    info!("Register: {:?}", form.0);
    HttpResponse::ImATeapot()
}

#[post("/login")]
pub async fn login(form: Form<LoginRequest>) -> impl Responder {
    info!("Login: {:?}", form.0);
    HttpResponse::ImATeapot()
}

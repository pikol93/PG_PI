use actix_web::{
    post,
    web::{Json, Path},
    HttpResponse, Responder,
};

use super::model::DataToShare;

#[post("/share/{token}")]
pub async fn route_share(token: Path<String>, data: Json<DataToShare>) -> impl Responder {
    dbg!(token, data);
    HttpResponse::Ok()
}

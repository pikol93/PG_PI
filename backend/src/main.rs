use actix_web::{get, App, HttpResponse, HttpServer, Responder};

#[actix_web::main]
async fn main() {
    HttpServer::new(|| App::new().service(health_check))
        .bind(("0.0.0.0", 8080))
        .expect("Binding server")
        .run()
        .await
        .expect("Running server");
}

#[get("/")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use color_eyre::Result;

#[actix_web::main]
async fn main() -> Result<()> {
    HttpServer::new(|| App::new().service(health_check))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await?;
    
    Ok(())
}

#[get("/")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

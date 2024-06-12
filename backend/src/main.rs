use actix_web::middleware::Logger;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use color_eyre::Result;
use dotenvy::dotenv;
use tracing::{info, instrument};
use tracing_subscriber::filter::EnvFilter;

#[actix_web::main]
async fn main() -> Result<()> {
    initialize_logger()?;

    HttpServer::new(|| App::new().wrap(Logger::default()).service(health_check))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await?;

    Ok(())
}

#[get("/")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

#[instrument]
fn initialize_logger() -> Result<()> {
    let _ = dotenv()?;

    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    info!("Initialized logger.");

    Ok(())
}

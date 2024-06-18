mod configuration;

use crate::configuration::Configuration;
use actix_web::middleware::Logger;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use color_eyre::Result;
use dotenvy::dotenv;
use tracing::{debug, info, instrument};
use tracing_subscriber::filter::EnvFilter;

#[actix_web::main]
async fn main() -> Result<()> {
    let _ = dotenv();
    initialize_logger();
    let configuration = Configuration::new_from_env()?;
    debug!("Read environment configuration: {:?}", configuration);

    HttpServer::new(|| App::new().wrap(Logger::default()).service(health_check))
        .bind((configuration.host, configuration.port))?
        .run()
        .await?;

    Ok(())
}

#[get("/")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

#[instrument]
fn initialize_logger() {
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    info!("Initialized logger.");
}

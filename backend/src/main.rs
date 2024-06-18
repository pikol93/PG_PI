use actix_web::middleware::Logger;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use color_eyre::Result;
use dotenvy::dotenv;
use envy::from_env;
use serde::Deserialize;
use tracing::log::trace;
use tracing::{info, instrument};
use tracing_subscriber::filter::EnvFilter;

#[derive(Deserialize, Debug)]
struct Configuration {
    host: String,
    port: u16,
}

impl Configuration {
    pub fn new_from_env() -> Result<Configuration> {
        let result = from_env::<Configuration>()?;
        trace!("Read environment configuration: {:?}", result);
        Ok(result)
    }
}

#[actix_web::main]
async fn main() -> Result<()> {
    let _ = dotenv();
    initialize_logger();
    let configuration = Configuration::new_from_env()?;

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

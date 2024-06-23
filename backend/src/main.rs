mod application_state;
mod configuration;

use crate::application_state::ApplicationState;
use crate::configuration::Configuration;
use actix_web::middleware::Logger;
use actix_web::web::Data;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use color_eyre::Result;
use dotenvy::dotenv;
use mongodb::Client;
use tracing::debug;
use tracing_subscriber::filter::EnvFilter;

#[actix_web::main]
async fn main() -> Result<()> {
    let _ = dotenv();

    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    let configuration = Configuration::new_from_env()?;
    debug!("Read environment configuration: {:?}", configuration);

    let client = Client::with_uri_str(&configuration.mongo_db_url).await?;
    let application_state = ApplicationState { client };
    let state_cloned = application_state.clone();

    HttpServer::new(move || {
        App::new()
            .app_data(Data::new(state_cloned.clone()))
            .wrap(Logger::default())
            .service(health_check)
    })
    .bind((configuration.host, configuration.port))?
    .run()
    .await?;

    application_state.client.shutdown().await;
    Ok(())
}

#[get("/")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

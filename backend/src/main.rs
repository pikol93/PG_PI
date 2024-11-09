#![warn(unused_crate_dependencies)]

mod configuration;
pub mod serializer;
mod share;
pub mod utility;

use crate::configuration::Configuration;
use crate::share::routes::route_share;
use actix_web::middleware::Logger;
use actix_web::web::{Data, JsonConfig};
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use dotenvy::dotenv;
use eyre::Result;
use mongodb::Client;
use share::service::SharedDataService;
use tracing::{debug, info};
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
    info!("MongoDB client initialized successfully");
    let shared_data_service = SharedDataService::new_with_client(client.clone());

    HttpServer::new(move || {
        App::new()
            .wrap(Logger::default())
            .app_data(Data::new(shared_data_service.clone()))
            .app_data(JsonConfig::default().content_type(|mime| mime == mime::APPLICATION_JSON))
            .service(health_check)
            .service(route_share)
    })
    .bind((configuration.host, configuration.port))?
    .run()
    .await?;

    debug!("Shutting down MongoDB client");
    client.shutdown().await;
    info!("Shut down MongoDB client");
    Ok(())
}

#[get("/")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

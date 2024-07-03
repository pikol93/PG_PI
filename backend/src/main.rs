mod application_state;
mod configuration;
mod exercise;
mod user;
pub mod utility;

use crate::application_state::ApplicationState;
use crate::configuration::Configuration;
use crate::exercise::controller::{add_exercise, get_exercise};
use crate::user::controller::{add_user, get_user};
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
    let application_state = ApplicationState::create_and_initialize(client.clone()).await?;
    let state_cloned = application_state.clone();

    HttpServer::new(move || {
        App::new()
            .app_data(Data::new(state_cloned.clone()))
            .wrap(Logger::default())
            .service(health_check)
            .service(add_user)
            .service(get_user)
            .service(add_exercise)
            .service(get_exercise)
    })
    .bind((configuration.host, configuration.port))?
    .run()
    .await?;

    client.shutdown().await;
    Ok(())
}

#[get("/")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

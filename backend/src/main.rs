mod configuration;
mod exercise;
mod user;
pub mod utility;

use crate::configuration::Configuration;
use crate::exercise::controller::{add_exercise, get_exercise};
use crate::exercise::repository::{ExerciseRepository, ExerciseRepositoryImpl};
use crate::user::controller::{add_user, get_user};
use crate::user::repository::{UserRepository, UserRepositoryImpl};
use actix_web::middleware::Logger;
use actix_web::web::Data;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use color_eyre::Result;
use dotenvy::dotenv;
use mongodb::Client;
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
    let user_repository = UserRepositoryImpl::create_and_initialize(client.clone()).await?;
    let exercise_repository = ExerciseRepositoryImpl::create_and_initialize(client.clone()).await?;

    HttpServer::new(move || {
        App::new()
            .app_data::<Data<Box<dyn UserRepository>>>(Data::new(Box::new(user_repository.clone())))
            .app_data::<Data<Box<dyn ExerciseRepository>>>(Data::new(Box::new(
                exercise_repository.clone(),
            )))
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

    debug!("Shutting down MongoDB client");
    client.shutdown().await;
    info!("Shut down MongoDB client");
    Ok(())
}

#[get("/")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

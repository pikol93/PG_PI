mod configuration;
mod exercise;
pub mod serializer;
mod user;
pub mod utility;

use crate::configuration::Configuration;
use crate::exercise::repository::ExerciseRepository;
use crate::user::repository::UserRepository;
use actix_session::storage::RedisSessionStore;
use actix_session::SessionMiddleware;
use actix_web::cookie::Key;
use actix_web::middleware::Logger;
use actix_web::web::Data;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use dotenvy::dotenv;
use exercise::routes::{route_exercises, route_put_exercise};
use eyre::Result;
use mongodb::Client;
use tracing::{debug, info};
use tracing_subscriber::filter::EnvFilter;
use user::routes::{login, logout, register};

#[actix_web::main]
async fn main() -> Result<()> {
    let _ = dotenv();

    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    let configuration = Configuration::new_from_env()?;
    debug!("Read environment configuration: {:?}", configuration);

    let client = Client::with_uri_str(&configuration.mongo_db_url).await?;
    let user_repository = UserRepository::create_and_initialize(client.clone()).await?;
    let exercise_repository = ExerciseRepository::create_and_initialize(client.clone()).await?;

    let store = RedisSessionStore::new(&configuration.redis_url)
        .await
        .unwrap();
    let key = Key::try_from(configuration.session_secret_key.as_bytes())?;

    HttpServer::new(move || {
        App::new()
            .wrap(
                SessionMiddleware::builder(store.clone(), key.clone())
                    // TODO: This is temporary. This line has to be removed before the application gets to production.
                    .cookie_secure(false)
                    .build(),
            )
            .app_data(Data::new(user_repository.clone()))
            .app_data(Data::new(exercise_repository.clone()))
            .wrap(Logger::default())
            .service(health_check)
            .service(route_exercises)
            .service(route_put_exercise)
            .service(register)
            .service(login)
            .service(logout)
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

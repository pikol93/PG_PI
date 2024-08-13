mod configuration;
mod exercise;
pub mod serializer;
mod session;
mod user;
pub mod utility;

use crate::configuration::Configuration;
use crate::exercise::repository::{ExerciseRepository, ExerciseRepositoryImpl};
use crate::exercise::routes::{add_exercise, get_exercise, get_exercises, get_exercises_by_user};
use crate::user::repository::{UserRepository, UserRepositoryImpl};
use crate::user::routes::{add_user, get_user, get_users};
use actix_session::storage::RedisSessionStore;
use actix_session::SessionMiddleware;
use actix_web::cookie::Key;
use actix_web::middleware::Logger;
use actix_web::web::Data;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use color_eyre::Result;
use dotenvy::dotenv;
use mongodb::Client;
use session::routes::{login, register};
use std::sync::Arc;
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

    let store = RedisSessionStore::new(&configuration.redis_url)
        .await
        .unwrap();
    let key = Key::try_from(configuration.session_secret_key.as_bytes())?;

    HttpServer::new(move || {
        App::new()
            .wrap(SessionMiddleware::new(store.clone(), key.clone()))
            .app_data(Data::from(
                Arc::new(user_repository.clone()) as Arc<dyn UserRepository>
            ))
            .app_data(Data::from(
                Arc::new(exercise_repository.clone()) as Arc<dyn ExerciseRepository>
            ))
            .wrap(Logger::default())
            .service(health_check)
            .service(add_user)
            .service(get_user)
            .service(get_users)
            .service(add_exercise)
            .service(get_exercise)
            .service(get_exercises)
            .service(get_exercises_by_user)
            .service(login)
            .service(register)
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

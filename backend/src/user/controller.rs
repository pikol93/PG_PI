use crate::application_state::ApplicationState;
use crate::user::models::User;
use actix_web::web::{Data, Form, Path};
use actix_web::{get, post, HttpResponse, Responder};
use color_eyre::Result;
use mongodb::bson::doc;
use mongodb::options::IndexOptions;
use mongodb::{Client, Collection, IndexModel};

const DATABASE_NAME: &str = "dbname";
const COLLECTION_NAME: &str = "coll_name";

pub async fn create_username_index(client: &Client) -> Result<()> {
    // TODO: Move this function elsewhere
    let options = IndexOptions::builder().unique(true).build();
    let model = IndexModel::builder()
        .keys(doc! { User::FIELD_USERNAME: 1 })
        .options(options)
        .build();

    client
        .database(DATABASE_NAME)
        .collection::<User>(COLLECTION_NAME)
        .create_index(model, None)
        .await?;

    Ok(())
}

#[post("/add_user")]
pub async fn add_user(state: Data<ApplicationState>, form: Form<User>) -> impl Responder {
    let collection = state
        .client
        .database(DATABASE_NAME)
        .collection(COLLECTION_NAME);
    let result = collection.insert_one(form.into_inner(), None).await;

    match result {
        Ok(_) => HttpResponse::Ok().finish(),
        Err(err) => HttpResponse::InternalServerError().json(err.to_string()),
    }
}

#[get("/get_user/{username}")]
pub async fn get_user(state: Data<ApplicationState>, username: Path<String>) -> HttpResponse {
    let username = username.into_inner();
    let collection: Collection<User> = state
        .client
        .database(DATABASE_NAME)
        .collection(COLLECTION_NAME);
    let result = collection
        .find_one(doc! { User::FIELD_USERNAME: &username }, None)
        .await;

    match result {
        Ok(Some(user)) => HttpResponse::Ok().json(user),
        Ok(None) => {
            HttpResponse::NotFound().body(format!("No user found with username {username}"))
        }
        Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
    }
}

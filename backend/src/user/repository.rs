use crate::user::model::{AddUserModel, GetUserModel, User};
use color_eyre::eyre::OptionExt;
use color_eyre::Result;
use mongodb::bson::doc;
use mongodb::bson::oid::ObjectId;
use mongodb::options::IndexOptions;
use mongodb::{Client, Collection, IndexModel};
use tracing::debug;

#[derive(Clone, Debug)]
pub struct UserRepository {
    client: Client,
}

impl UserRepository {
    // TODO: The database name should be stored somewhere else since it will be used by more
    // repositories.
    const DATABASE_NAME: &'static str = "dbname";
    const COLLECTION_NAME: &'static str = "users";

    pub async fn create_and_initialize(client: Client) -> Result<Self> {
        let this = Self { client };
        this.create_username_index().await?;

        Ok(this)
    }

    pub async fn get_user_by_name(&self, name: &str) -> Result<Option<GetUserModel>> {
        let user = self
            .get_collection()
            .find_one(doc! { User::FIELD_USERNAME: name }, None)
            .await?;

        Ok(user)
    }

    pub async fn add_user(&self, username: String) -> Result<ObjectId> {
        let user = AddUserModel {
            user: User {
                username,
                first_name: None,
                last_name: None,
            },
        };
        let result = self
            .get_collection::<AddUserModel>()
            .insert_one(user, None)
            .await?
            .inserted_id
            .as_object_id()
            .ok_or_eyre("Insert did not result in ObjectID.")?;

        Ok(result)
    }

    async fn create_username_index(&self) -> Result<()> {
        debug!("Begin creating username index");
        let options = IndexOptions::builder().unique(true).build();

        let model = IndexModel::builder()
            .keys(doc! { User::FIELD_USERNAME: 1 })
            .options(options)
            .build();

        self.get_collection::<User>()
            .create_index(model, None)
            .await?;

        Ok(())
    }

    fn get_collection<T>(&self) -> Collection<T> {
        self.client
            .database(Self::DATABASE_NAME)
            .collection(Self::COLLECTION_NAME)
    }
}

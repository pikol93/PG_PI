use crate::user::model::{AddUserModel, GetUserModel, User};
use async_trait::async_trait;
use color_eyre::Result;
use futures::TryStreamExt;
use mongodb::bson::doc;
use mongodb::bson::oid::ObjectId;
use mongodb::options::IndexOptions;
use mongodb::{Client, Collection, IndexModel};
use tracing::debug;

#[async_trait]
pub trait UserRepository {
    /// Asynchronously gets all existing users. If the request fails, then the returned `Result`
    /// contains an `Err` value.
    async fn get_users(&self) -> Result<Vec<GetUserModel>>;

    /// Asynchronously gets the user identified by the given ID. If the request fails, then the
    /// returned `Result` contains an `Err`. If the request succeeds but no user by the given ID
    /// could be found, then the returned `Option` is `None`.
    ///
    /// # Arguments
    ///
    /// * `id`: ID representing a single user.
    ///
    async fn get_user_by_id(&self, id: &ObjectId) -> Result<Option<GetUserModel>>;

    /// Asynchronously gets the user identified by their name. If the request fails, then the
    /// returned `Result` contains an `Err`. If the request succeeds but no user by the given name
    /// could be found, then the returned `Option` is `None`.
    ///
    /// # Arguments
    ///
    /// * `name`: Username to find the user by.
    ///
    async fn get_user_by_name(&self, name: &str) -> Result<Option<GetUserModel>>;

    /// Asynchronously adds a user to the repository.
    ///
    /// # Arguments
    ///
    /// * 'user': User to be inserted into the repository.
    ///
    async fn add_user(&self, user: &AddUserModel) -> Result<()>;
}

#[derive(Clone, Debug)]
pub struct UserRepositoryImpl {
    client: Client,
}

#[async_trait]
impl UserRepository for UserRepositoryImpl {
    async fn get_users(&self) -> Result<Vec<GetUserModel>> {
        let users = self
            .get_collection()
            .find(None, None)
            .await?
            .try_collect()
            .await?;

        Ok(users)
    }

    async fn get_user_by_id(&self, id: &ObjectId) -> Result<Option<GetUserModel>> {
        let user = self
            .get_collection()
            .find_one(doc! { "_id": id }, None)
            .await?;

        Ok(user)
    }

    async fn get_user_by_name(&self, name: &str) -> Result<Option<GetUserModel>> {
        let user = self
            .get_collection()
            .find_one(doc! { User::FIELD_USERNAME: name }, None)
            .await?;

        Ok(user)
    }

    async fn add_user(&self, user: &AddUserModel) -> Result<()> {
        self.get_collection::<AddUserModel>()
            .insert_one(user, None)
            .await?;

        Ok(())
    }
}

impl UserRepositoryImpl {
    // TODO: The database name should be stored somewhere else since it will be used by more
    // repositories.
    const DATABASE_NAME: &'static str = "dbname";
    const COLLECTION_NAME: &'static str = "users";

    pub async fn create_and_initialize(client: Client) -> Result<Self> {
        let this = Self { client };
        this.create_username_index().await?;

        Ok(this)
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

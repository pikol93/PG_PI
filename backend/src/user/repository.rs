use crate::user::model::User;
use async_trait::async_trait;
use color_eyre::Result;
use futures::TryStreamExt;
use mongodb::bson::doc;
use mongodb::bson::oid::ObjectId;
use mongodb::{Client, Collection};

#[async_trait]
pub trait UserRepository {
    /// Gets all existing users asynchronously. If the request fails, then the returned `Result` contains an `Err`
    /// value.
    async fn get_users(&self) -> Result<Vec<User>>;

    /// Gets the user identified by the given ID asynchronously. If the request fails, then the
    /// returned `Result` contains an `Err`. If the request succeeds but no user by the given ID
    /// could be found, then the returned `Option` is `None`.
    ///
    /// # Arguments
    ///
    /// * `id`: ID representing a single user.
    async fn get_user(&self, id: &ObjectId) -> Result<Option<User>>;
}

pub struct UserRepositoryImpl {
    pub client: Client,
}

#[async_trait]
impl UserRepository for UserRepositoryImpl {
    async fn get_users(&self) -> Result<Vec<User>> {
        let users = self
            .get_collection()
            .find(None, None)
            .await?
            .try_collect()
            .await?;

        Ok(users)
    }

    async fn get_user(&self, id: &ObjectId) -> Result<Option<User>> {
        let user = self
            .get_collection()
            .find_one(doc! { "_id": id }, None)
            .await?;

        Ok(user)
    }
}

impl UserRepositoryImpl {
    // TODO: The database name should be stored somewhere else since it will be used by more
    // repositories.
    const DATABASE_NAME: &'static str = "dbname";
    const COLLECTION_NAME: &'static str = "users";

    fn get_collection<T>(&self) -> Collection<T> {
        self.client
            .database(Self::DATABASE_NAME)
            .collection(Self::COLLECTION_NAME)
    }
}

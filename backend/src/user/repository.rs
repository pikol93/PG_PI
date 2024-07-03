use crate::user::model::User;
use async_trait::async_trait;
use color_eyre::Result;
use futures::TryStreamExt;
use mongodb::bson::doc;
use mongodb::bson::oid::ObjectId;
use mongodb::{Client, Collection};

#[async_trait]
pub trait UserRepository {
    /// Asynchronously gets all existing users. If the request fails, then the returned `Result` 
    /// contains an `Err` value.
    async fn get_users(&self) -> Result<Vec<User>>;

    /// Asynchronously gets the user identified by the given ID. If the request fails, then the
    /// returned `Result` contains an `Err`. If the request succeeds but no user by the given ID
    /// could be found, then the returned `Option` is `None`.
    ///
    /// # Arguments
    ///
    /// * `id`: ID representing a single user.
    ///
    async fn get_user_by_id(&self, id: &ObjectId) -> Result<Option<User>>;

    /// Asynchronously gets the user identified by their name. If the request fails, then the
    /// returned `Result` contains an `Err`. If the request succeeds but no user by the given name
    /// could be found, then the returned `Option` is `None`.
    ///
    /// # Arguments
    ///
    /// * `name`: Username to find the user by.
    ///
    async fn get_user_by_name(&self, name: &str) -> Result<Option<User>>;

    /// Asynchronously adds a user to the repository.
    ///
    /// # Arguments
    ///
    /// * 'user': User to be inserted into the repository.
    ///
    async fn add_user(&self, user: &User) -> Result<()>;
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

    async fn get_user_by_id(&self, id: &ObjectId) -> Result<Option<User>> {
        let user = self
            .get_collection()
            .find_one(doc! { "_id": id }, None)
            .await?;

        Ok(user)
    }

    async fn get_user_by_name(&self, name: &str) -> Result<Option<User>> {
        let user = self
            .get_collection()
            .find_one(doc! { User::FIELD_USERNAME: name }, None)
            .await?;

        Ok(user)
    }

    async fn add_user(&self, user: &User) -> Result<()> {
        self.get_collection::<User>().insert_one(user, None).await?;

        Ok(())
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

use crate::exercise::model::Exercise;
use async_trait::async_trait;
use color_eyre::Result;
use futures::TryStreamExt;
use mongodb::bson::doc;
use mongodb::bson::oid::ObjectId;
use mongodb::options::IndexOptions;
use mongodb::{Client, Collection, IndexModel};
use tracing::{debug, instrument};

#[async_trait]
pub trait ExerciseRepository {
    /// Asynchronously gets all existing exercises. If the request fails, then the returned `Result`
    /// contains an `Err` value.
    async fn get_exercises(&self) -> Result<Vec<Exercise>>;

    /// Asynchronously gets the exercise identified by the given ID. If the request fails, then the
    /// returned `Result` contains an `Err`. If the request succeeds but no user by the given ID
    /// could be found, then the returned `Option` is `None`.
    ///
    /// # Arguments
    ///
    /// * `id`: ID representing a single exercise.
    ///
    async fn get_exercise_by_id(&self, id: &ObjectId) -> Result<Option<Exercise>>;

    /// Gets all exercises related to a user identified by the given ID.
    ///
    /// # Arguments:
    ///
    /// * `id`: ID of the user to get related exercises by.
    ///
    async fn get_exercises_by_user_id(&self, id: &ObjectId) -> Result<Vec<Exercise>>;

    /// Asynchronously adds an exercise to the repository.
    ///
    /// # Arguments
    ///
    /// * 'user': Exercise to be inserted into the repository.
    ///
    async fn add_exercise(&self, exercise: &Exercise) -> Result<()>;
}

#[derive(Debug, Clone)]
pub struct ExerciseRepositoryImpl {
    client: Client,
}

#[async_trait]
impl ExerciseRepository for ExerciseRepositoryImpl {
    async fn get_exercises(&self) -> Result<Vec<Exercise>> {
        let exercises = self
            .get_collection()
            .find(None, None)
            .await?
            .try_collect()
            .await?;

        Ok(exercises)
    }

    async fn get_exercise_by_id(&self, id: &ObjectId) -> Result<Option<Exercise>> {
        let exercise = self
            .get_collection()
            .find_one(doc! { "_id": id }, None)
            .await?;

        Ok(exercise)
    }

    async fn get_exercises_by_user_id(&self, id: &ObjectId) -> Result<Vec<Exercise>> {
        let exercises = self
            .get_collection()
            .find(
                doc! {
                    Exercise::FIELD_USER: id,
                },
                None,
            )
            .await?
            .try_collect()
            .await?;

        Ok(exercises)
    }

    async fn add_exercise(&self, exercise: &Exercise) -> Result<()> {
        self.get_collection::<Exercise>()
            .insert_one(exercise, None)
            .await?;

        Ok(())
    }
}

impl ExerciseRepositoryImpl {
    const DATABASE_NAME: &'static str = "dbname";
    const COLLECTION_NAME: &'static str = "exercises";

    pub async fn create_and_initialize(client: Client) -> Result<Self> {
        let this = Self { client };
        this.create_user_index().await?;

        Ok(this)
    }

    async fn create_user_index(&self) -> Result<()> {
        debug!("Begin creating user index");
        let options = IndexOptions::builder().unique(true).build();

        let model = IndexModel::builder()
            .keys(doc! { Exercise::FIELD_USER: 1 })
            .options(options)
            .build();

        self.get_collection::<Exercise>()
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

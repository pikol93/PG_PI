use crate::exercise::model::{Exercise, GetExerciseModel};
use color_eyre::Result;
use futures::TryStreamExt;
use mongodb::bson::doc;
use mongodb::bson::oid::ObjectId;
use mongodb::{Client, Collection, IndexModel};
use tracing::debug;

#[derive(Debug, Clone)]
pub struct ExerciseRepository {
    client: Client,
}

impl ExerciseRepository {
    const DATABASE_NAME: &'static str = "dbname";
    const COLLECTION_NAME: &'static str = "exercises";

    pub async fn create_and_initialize(client: Client) -> Result<Self> {
        let this = Self { client };
        this.create_user_index().await?;

        Ok(this)
    }

    pub async fn get_exercises_by_user_id(&self, id: &ObjectId) -> Result<Vec<GetExerciseModel>> {
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

    async fn create_user_index(&self) -> Result<()> {
        debug!("Begin creating user index");
        let model = IndexModel::builder()
            .keys(doc! { Exercise::FIELD_USER: 1 })
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

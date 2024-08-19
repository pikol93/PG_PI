use color_eyre::eyre::OptionExt;
use color_eyre::Result;
use futures::TryStreamExt;
use mongodb::bson::doc;
use mongodb::bson::oid::ObjectId;
use mongodb::{Client, Collection, IndexModel};
use tracing::debug;

use crate::exercise::model::Exercise;

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

    pub async fn get_exercises_by_user_id(&self, id: &ObjectId) -> Result<Vec<Exercise>> {
        let filter = doc! {
            Exercise::FIELD_USER: id,
        };

        let exercises = self
            .get_collection()
            .find(filter, None)
            .await?
            .try_collect()
            .await?;

        Ok(exercises)
    }

    pub async fn add_exercise(&self, name: String, user_id: ObjectId) -> Result<ObjectId> {
        let exercise = Exercise {
            id: None,
            user_id,
            name,
        };

        let exercise_id = self
            .get_collection::<Exercise>()
            .insert_one(exercise, None)
            .await?
            .inserted_id
            .as_object_id()
            .ok_or_eyre("Could not convert inserted exercise ID to object ID.")?;

        Ok(exercise_id)
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

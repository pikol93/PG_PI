use crate::exercise::repository::{ExerciseRepository, ExerciseRepositoryImpl};
use crate::user::repository::{UserRepository, UserRepositoryImpl};
use color_eyre::Result;
use mongodb::Client;
use std::sync::Arc;

#[derive(Clone)]
pub struct ApplicationState {
    pub client: Client,
    pub user_repository: Arc<dyn UserRepository>,
    pub exercise_repository: Arc<dyn ExerciseRepository>,
}

unsafe impl Send for ApplicationState {}

impl ApplicationState {
    pub async fn create_and_initialize(client: Client) -> Result<Self> {
        let user_repository = UserRepositoryImpl {
            client: client.clone(),
        };
        user_repository.create_indexes().await?;

        let exercise_repository = ExerciseRepositoryImpl {
            client: client.clone(),
        };
        exercise_repository.create_indexes().await?;

        let this = Self {
            client,
            user_repository: Arc::new(user_repository),
            exercise_repository: Arc::new(exercise_repository),
        };

        Ok(this)
    }
}

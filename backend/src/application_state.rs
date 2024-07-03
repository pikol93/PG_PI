use crate::user::repository::{UserRepository, UserRepositoryImpl};
use color_eyre::Result;
use mongodb::Client;
use std::sync::Arc;

#[derive(Clone)]
pub struct ApplicationState {
    pub client: Client,
    pub user_repository: Arc<dyn UserRepository>,
}

unsafe impl Send for ApplicationState {}

impl ApplicationState {
    pub async fn create_and_initialize(client: Client) -> Result<Self> {
        let user_repository = UserRepositoryImpl {
            client: client.clone(),
        };
        user_repository.create_indexes().await?;

        let this = Self {
            client,
            user_repository: Arc::new(user_repository),
        };

        Ok(this)
    }
}

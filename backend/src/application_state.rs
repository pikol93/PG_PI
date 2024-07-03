use crate::user::repository::UserRepository;
use mongodb::Client;
use std::sync::Arc;

#[derive(Clone)]
pub struct ApplicationState {
    pub client: Client,
    pub user_repository: Arc<dyn UserRepository>,
}

unsafe impl Send for ApplicationState {}

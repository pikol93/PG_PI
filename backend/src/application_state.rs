use mongodb::Client;

#[derive(Clone, Debug)]
pub struct ApplicationState {
    pub client: Client,
}

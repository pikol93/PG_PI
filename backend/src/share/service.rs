use eyre::{OptionExt, Result};
use mongodb::{bson::oid::ObjectId, Client, Collection};

use super::model::DataToShare;

#[derive(Clone)]
pub struct SharedDataService {
    client: Client,
}

impl SharedDataService {
    pub fn new_with_client(client: Client) -> Self {
        Self { client }
    }

    pub async fn save(&self, data: DataToShare) -> Result<ObjectId> {
        let result = self
            .get_shared_data_collection()
            .insert_one(data)
            .await?
            .inserted_id
            .as_object_id()
            .ok_or_eyre("Could not extract object ID.")?;

        Ok(result)
    }

    fn get_shared_data_collection(&self) -> Collection<DataToShare> {
        self.client.database("pg_pi").collection("shared_data")
    }
}

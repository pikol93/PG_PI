use chrono::{DateTime, Utc};
use eyre::{OptionExt, Result};
use mongodb::{
    bson::{doc, oid::ObjectId},
    Client, Collection,
};
use serde::{Deserialize, Serialize};

use super::model::DataToShare;

#[derive(Clone)]
pub struct SharedDataService {
    client: Client,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
struct ShareDocument {
    expiration_date: DateTime<Utc>,
    data: DataToShare,
}

impl SharedDataService {
    pub fn new_with_client(client: Client) -> Self {
        Self { client }
    }

    pub async fn save(
        &self,
        expiration_date: DateTime<Utc>,
        data: DataToShare,
    ) -> Result<ObjectId> {
        let document = ShareDocument {
            expiration_date,
            data,
        };

        let result = self
            .get_shared_data_collection()
            .insert_one(document)
            .await?
            .inserted_id
            .as_object_id()
            .ok_or_eyre("Could not extract object ID.")?;

        Ok(result)
    }

    fn get_shared_data_collection(&self) -> Collection<ShareDocument> {
        self.client.database("pg_pi").collection("shared_data")
    }
}

use chrono::{DateTime, Utc};
use eyre::{OptionExt, Result};
use mongodb::{bson::doc, Client, Collection, IndexModel};
use serde::{Deserialize, Serialize};
use tracing::debug;
use uuid::Uuid;

use super::model::DataToShare;

#[derive(Clone)]
pub struct SharedDataService {
    client: Client,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
struct ShareDocument {
    uuid: Uuid,
    expiration_date: DateTime<Utc>,
    data: DataToShare,
}

impl SharedDataService {
    pub fn new_with_client(client: Client) -> Self {
        Self { client }
    }

    pub async fn initialize_indexes(&self) -> Result<()> {
        let index = IndexModel::builder().keys(doc!( "uuid": 1 )).build();

        let index = self
            .get_shared_data_collection()
            .create_index(index)
            .await?;

        debug!("Created index: {}", index.index_name);

        Ok(())
    }

    pub async fn save(&self, expiration_date: DateTime<Utc>, data: DataToShare) -> Result<Uuid> {
        let uuid = Uuid::new_v4();
        let document = ShareDocument {
            uuid,
            expiration_date,
            data,
        };

        self.get_shared_data_collection()
            .insert_one(document)
            .await?
            .inserted_id
            .as_object_id()
            .ok_or_eyre("Could not extract object ID.")?;

        Ok(uuid)
    }

    fn get_shared_data_collection(&self) -> Collection<ShareDocument> {
        self.client.database("pg_pi").collection("shared_data")
    }
}

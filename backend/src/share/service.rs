use bson::Uuid;
use chrono::{DateTime, Utc};
use eyre::{OptionExt, Result};
use mongodb::{bson::doc, Client, Collection, IndexModel};
use serde::{Deserialize, Serialize};
use tracing::{debug, trace};

use super::model::DataToShare;

#[derive(Clone)]
pub struct SharedDataService {
    client: Client,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ShareDocument {
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
        let uuid = Uuid::new();
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

    pub async fn find(&self, uuid: &Uuid) -> Result<Option<ShareDocument>> {
        let filter_doc = doc!("uuid": uuid);
        trace!("Filter doc: {:?}", filter_doc);
        let result = self
            .get_shared_data_collection()
            .find_one(filter_doc)
            .await?
            .filter(|document| {
                debug!("AAAA: {:?}", document);
                Utc::now() < document.expiration_date
            });

        Ok(result)
    }

    fn get_shared_data_collection(&self) -> Collection<ShareDocument> {
        self.client.database("pg_pi").collection("shared_data")
    }
}

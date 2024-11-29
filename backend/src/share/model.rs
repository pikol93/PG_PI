use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ShareRequest {
    #[serde(alias = "validityMillis")]
    pub validity_millis: u64,
    #[serde(alias = "sharedData")]
    pub shared_data: DataToShare,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct DataToShare {
    pub something: String,
    pub something2: String,
}

#[derive(Serialize)]
pub struct ShareResponse {
    pub id: String,
}

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct DataToShare {
    pub something: String,
    pub something2: String,
}

#[derive(Serialize)]
pub struct ShareResponse {
    pub id: String,
}

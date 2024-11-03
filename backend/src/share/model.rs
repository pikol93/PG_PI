use serde::Deserialize;

#[derive(Deserialize, Debug, Clone)]
pub struct DataToShare {
    something: String,
    something2: String,
}

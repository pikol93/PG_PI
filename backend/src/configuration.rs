use envy::from_env;
use eyre::Result;
use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct Configuration {
    pub host: String,
    pub port: u16,
    pub mongo_db_url: String,
}

impl Configuration {
    pub fn new_from_env() -> Result<Configuration> {
        let result = from_env::<Configuration>()?;
        Ok(result)
    }
}

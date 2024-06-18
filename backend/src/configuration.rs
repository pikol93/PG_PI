use color_eyre::Result;
use envy::from_env;
use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct Configuration {
    pub host: String,
    pub port: u16,
}

impl Configuration {
    pub fn new_from_env() -> Result<Configuration> {
        let result = from_env::<Configuration>()?;
        Ok(result)
    }
}
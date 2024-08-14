use serde::Deserialize;

#[derive(Deserialize, Clone, Debug)]
pub struct RegisterRequest {
    pub name: String,
}

#[derive(Deserialize, Clone, Debug)]
pub struct LoginRequest {
    pub name: String,
}

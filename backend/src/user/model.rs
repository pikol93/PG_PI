use mongodb::bson::oid::ObjectId;
use serde::{Deserialize, Serialize};

pub mod request;

#[derive(Clone, Debug, PartialEq, Eq, Deserialize, Serialize)]
pub struct User {
    #[serde(rename = "_id", skip_serializing_if = "Option::is_none")]
    pub id: Option<ObjectId>,
    pub username: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub first_name: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub last_name: Option<String>,
}

impl User {
    pub const FIELD_USERNAME: &'static str = "username";
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::utility::assert_contains_field;

    #[test]
    fn should_contain_username_field() {
        assert_contains_field::<User>(User::FIELD_USERNAME);
    }
}

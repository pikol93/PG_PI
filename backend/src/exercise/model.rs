use mongodb::bson::oid::ObjectId;
use serde::{Deserialize, Serialize};

pub mod request;
pub mod response;

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct Exercise {
    #[serde(rename = "_id", skip_serializing_if = "Option::is_none")]
    pub id: Option<ObjectId>,
    pub user_id: ObjectId,
    pub name: String,
}

impl Exercise {
    pub const FIELD_USER: &'static str = "user_id";
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::utility::assert_contains_field;

    #[test]
    fn should_contain_user_field() {
        assert_contains_field::<Exercise>(Exercise::FIELD_USER);
    }
}

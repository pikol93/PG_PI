use mongodb::bson::oid::ObjectId;
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, PartialEq, Eq, Deserialize, Serialize)]
pub struct Exercise {
    pub user: ObjectId,
    pub name: String,
}

impl Exercise {
    pub const FIELD_USER: &'static str = "user";
    pub const FIELD_NAME: &'static str = "name";
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::utility::assert_contains_field;

    #[test]
    fn should_contain_user_field() {
        assert_contains_field::<Exercise>(Exercise::FIELD_USER);
    }

    #[test]
    fn should_contain_name_field() {
        assert_contains_field::<Exercise>(Exercise::FIELD_NAME);
    }
}

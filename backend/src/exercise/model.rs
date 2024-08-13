use crate::serializer::serialize_object_id;
use mongodb::bson::oid::ObjectId;
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, PartialEq, Eq, Deserialize, Serialize)]
pub struct Exercise {
    #[serde(serialize_with = "serialize_object_id")]
    pub user: ObjectId,
    pub name: String,
}

#[derive(Clone, Debug, PartialEq, Eq, Deserialize, Serialize)]
pub struct GetExerciseModel {
    #[serde(rename = "_id", serialize_with = "serialize_object_id")]
    pub id: ObjectId,
    #[serde(flatten)]
    pub exercise: Exercise,
}

#[derive(Clone, Debug, PartialEq, Eq, Deserialize, Serialize)]
pub struct AddExerciseModel {
    #[serde(flatten)]
    pub exercise: Exercise,
}

impl Exercise {
    pub const FIELD_USER: &'static str = "user";
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

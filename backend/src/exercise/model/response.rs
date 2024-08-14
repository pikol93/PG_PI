use color_eyre::{
    eyre::{OptionExt, Report},
    Result,
};
use itertools::Itertools;
use mongodb::bson::oid::ObjectId;
use serde::Serialize;

use crate::serializer::serialize_object_id;

use super::Exercise;

#[derive(Serialize, Debug, Clone)]
pub struct SingleExerciseResponse {
    #[serde(serialize_with = "serialize_object_id")]
    pub id: ObjectId,
    #[serde(serialize_with = "serialize_object_id")]
    pub user_id: ObjectId,
    pub name: String,
}

#[derive(Serialize, Debug, Clone)]
pub struct MultipleExercisesResponse {
    pub exercises: Vec<SingleExerciseResponse>,
}

impl SingleExerciseResponse {
    pub fn convert_from(value: Exercise) -> Result<Self> {
        let this = Self {
            id: value.id.ok_or_eyre("Missing ID.")?,
            user_id: value.user_id,
            name: value.name,
        };

        Ok(this)
    }
}

impl MultipleExercisesResponse {
    pub fn convert_from(value: Vec<Exercise>) -> Result<Self> {
        let (exercises, _): (Vec<SingleExerciseResponse>, Vec<Report>) = value
            .into_iter()
            .map(|exercise| SingleExerciseResponse::convert_from(exercise))
            .partition_result();

        let this = MultipleExercisesResponse { exercises };

        Ok(this)
    }
}

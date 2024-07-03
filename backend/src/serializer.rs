use mongodb::bson::oid::ObjectId;
use serde::Serializer;

pub fn serialize_object_id<S>(object_id: &ObjectId, serializer: S) -> Result<S::Ok, S::Error>
where
    S: Serializer,
{
    serializer.serialize_some(&object_id.to_string())
}

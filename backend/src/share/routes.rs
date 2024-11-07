use actix_web::{
    post,
    web::{Data, Json, Path},
    HttpResponse, Responder,
};
use tracing::warn;
use uuid::Uuid;

use crate::{puzzle::service::AuthorizationStoreService, share::model::ShareResponse};

use super::{model::DataToShare, service::SharedDataService};

#[post("/share/{token}")]
pub async fn route_share(
    authorization_store_service: Data<AuthorizationStoreService>,
    shared_data_service: Data<SharedDataService>,
    uuid: Path<Uuid>,
    shared_data: Json<DataToShare>,
) -> impl Responder {
    if authorization_store_service
        .consume_entry(uuid.as_ref())
        .await
        .is_none()
    {
        return HttpResponse::Unauthorized().finish();
    };

    let save_result = shared_data_service.save(shared_data.into_inner()).await;
    let object_id = match save_result {
        Ok(object_id) => object_id,
        Err(error) => {
            warn!("Could not save shared data. {}", error);
            return HttpResponse::InternalServerError().finish();
        }
    };

    let response = ShareResponse {
        id: object_id.to_hex(),
    };

    HttpResponse::Ok().json(response)
}

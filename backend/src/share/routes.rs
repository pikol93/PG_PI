use actix_web::{
    post,
    web::{Data, Json},
    HttpResponse, Responder,
};
use tracing::warn;

use crate::share::model::ShareResponse;

use super::{model::DataToShare, service::SharedDataService};

#[post("/share")]
pub async fn route_share(
    shared_data_service: Data<SharedDataService>,
    shared_data: Json<DataToShare>,
) -> impl Responder {
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

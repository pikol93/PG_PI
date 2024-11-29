use actix_web::{
    get, post,
    web::{Data, Json, Path},
    HttpResponse, Responder,
};
use bson::Uuid;
use chrono::{Duration, Utc};
use tracing::warn;

use crate::share::model::{ShareRequest, ShareResponse};

use super::service::SharedDataService;

const MIN_VALIDITY_DURATION: Duration = Duration::days(1);
const MAX_VALIDITY_DURATION: Duration = Duration::days(31);

#[post("/share")]
pub async fn route_share(
    shared_data_service: Data<SharedDataService>,
    share_request: Json<ShareRequest>,
) -> impl Responder {
    let ShareRequest {
        validity_millis,
        shared_data,
    } = share_request.into_inner();

    let validity_duration = Duration::milliseconds(validity_millis as i64);
    if validity_duration < MIN_VALIDITY_DURATION {
        return HttpResponse::BadRequest().body("Validity time is too small.");
    }

    if validity_duration > MAX_VALIDITY_DURATION {
        return HttpResponse::BadRequest().body("Validity time is too large.");
    }

    let time = Utc::now();
    let Some(expiration_date) = time.checked_add_signed(validity_duration) else {
        warn!(
            "Invalid expiration date. {:?} {:?}",
            time, validity_duration
        );
        return HttpResponse::InternalServerError().body("Invalid date.");
    };

    let save_result = shared_data_service.save(expiration_date, shared_data).await;
    let object_id = match save_result {
        Ok(object_id) => object_id,
        Err(error) => {
            warn!("Could not save shared data. {}", error);
            return HttpResponse::InternalServerError().finish();
        }
    };

    let response = ShareResponse {
        id: object_id.to_string(),
    };

    HttpResponse::Ok().json(response)
}

#[get("/data/{uuid}")]
pub async fn route_fetch_shared(
    shared_data_service: Data<SharedDataService>,
    uuid: Path<uuid::Uuid>,
) -> impl Responder {
    // Type conversion is important since actix does not seem to support bson::Uuid
    let uuid = Uuid::parse_str(uuid.to_string()).unwrap();

    match shared_data_service.find(&uuid).await {
        Ok(Some(data)) => HttpResponse::Ok().json(data),
        Ok(None) => HttpResponse::NotFound().finish(),
        Err(err) => {
            warn!("Could not fetch shared item. Error = {}", err);
            HttpResponse::InternalServerError().finish()
        }
    }
}

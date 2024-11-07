use actix_web::cookie::time::{ext::InstantExt, Duration};
use std::{collections::HashMap, sync::Arc, time::Instant};
use tokio::sync::RwLock;
use uuid::Uuid;

struct AuthorizationEntry {
    expiration_date: Instant,
}

#[derive(Default, Clone)]
pub struct AuthorizationStoreService {
    authorized: Arc<RwLock<HashMap<Uuid, AuthorizationEntry>>>,
}

impl AuthorizationStoreService {
    pub async fn insert_entry(&self, uuid: Uuid) {
        let item = AuthorizationEntry {
            expiration_date: Instant::now().add_signed(Duration::minutes(1)),
        };

        self.authorized.write().await.insert(uuid, item);
    }

    pub async fn consume_entry(&self, uuid: &Uuid) -> Option<()> {
        let stored_entry = self.authorized.write().await.remove(uuid)?;

        if stored_entry.expiration_date > Instant::now() {
            return None;
        }

        Some(())
    }
}

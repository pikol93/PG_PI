use std::{collections::HashMap, str::FromStr, sync::Arc, time::Instant};

use actix_web::cookie::time::{ext::InstantExt, Duration};
use eyre::{eyre, OptionExt, Result};
use tokio::sync::RwLock;
use uuid::Uuid;

struct PuzzleEntry {
    expiration_date: Instant,
}

#[derive(Default, Clone)]
pub struct PuzzleStoreService {
    entries: Arc<RwLock<HashMap<Uuid, PuzzleEntry>>>,
}

impl PuzzleStoreService {
    pub async fn create_entry(&self) -> Uuid {
        let uuid = Uuid::new_v4();
        let entry = PuzzleEntry {
            expiration_date: Instant::now().add_signed(Duration::minutes(1)),
        };

        self.entries.write().await.insert(uuid, entry);

        uuid
    }

    pub async fn verify_solution(&self, key_string: &str, solution: &str) -> Result<()> {
        let key = Uuid::from_str(&key_string)?;
        let entry = self
            .entries
            .write()
            .await
            .remove(&key)
            .ok_or_eyre("Could not find entry.")?;

        if entry.expiration_date < Instant::now() {
            return Err(eyre!("Expiration time passed."));
        }

        verify(key_string, solution)?;

        Ok(())
    }
}

fn verify(puzzle_key: &str, solution: &str) -> Result<()> {
    // TODO: Implement this
    dbg!(puzzle_key, solution);
    Ok(())
}

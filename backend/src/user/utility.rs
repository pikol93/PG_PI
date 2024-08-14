use actix_session::Session;
use color_eyre::{eyre::OptionExt, Result};
use mongodb::bson::oid::ObjectId;

const USER_ID_KEY: &str = "user_id";

pub fn validate_and_renew_session(session: &Session) -> Result<ObjectId> {
    let user_id = session
        .get(USER_ID_KEY)?
        .ok_or_eyre("Could not find user ID.")?;

    session.renew();
    Ok(user_id)
}

pub fn set_user_id(session: &Session, user_id: &ObjectId) -> Result<()> {
    session.insert(USER_ID_KEY, user_id)?;

    Ok(())
}

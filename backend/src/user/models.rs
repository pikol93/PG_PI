use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, PartialEq, Eq, Deserialize, Serialize)]
pub struct User {
    pub first_name: String,
    pub last_name: String,
    pub username: String,
    pub email: String,
}

impl User {
    pub const FIELD_USERNAME: &'static str = "username";
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::utility::assert_contains_field;

    #[test]
    fn should_contain_username_field() {
        assert_contains_field::<User>(User::FIELD_USERNAME);
    }
}

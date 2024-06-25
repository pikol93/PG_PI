#![allow(dead_code)]

use serde::Deserialize;
use serde_aux::prelude::serde_introspect;
use std::any::type_name;

/// Checks if a struct contains a field deserialized using a given name.
pub fn assert_contains_field<'de, T>(field_name: &str)
where
    T: Deserialize<'de>,
{
    let field_names = serde_introspect::<T>();
    let check_result = field_names.iter().any(|item| (*item).eq(field_name));

    if !check_result {
        let struct_name = type_name::<T>();
        panic!(
            "Struct \"{}\" does not contain field \"{}\". Available fields: {:?}",
            struct_name, field_name, field_names,
        )
    }
}

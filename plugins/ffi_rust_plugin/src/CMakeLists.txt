# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.11)

project(ffi_rust_plugin_library VERSION 0.0.1 LANGUAGES C)

# Enable ExternalProject CMake module
include(FetchContent)

# Set default ExternalProject root directory
set_directory_properties(PROPERTIES EP_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/rust)


# This will build Rust sources.
# The resulting lib will be src/rust/target/release/libn_body_rust_simulation.so
execute_process (
    COMMAND cargo build --release
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/rust
    OUTPUT_VARIABLE outVar
)
if(LINUX)
    set(SIM_LIB_NAME "libn_body_rust_simulation.so")
endif()
if (WIN32)
  set(SIM_LIB_NAME "n_body_rust_simulation.dll")
endif()

install(
  FILES "rust/target/release/${SIM_LIB_NAME}" 
  DESTINATION "${CMAKE_INSTALL_PREFIX}/lib")
# configure_file(
#   "rust/target/release/${SIM_LIB_NAME}" 
#   "${CMAKE_INSTALL_PREFIX}/lib"
#   COPYONLY)
message("************************************************************** ${CMAKE_INSTALL_PREFIX}")




add_library(ffi_rust_plugin SHARED
  "ffi_rust_plugin.cpp"
)

set_target_properties(ffi_rust_plugin PROPERTIES
  PUBLIC_HEADER ffi_rust_plugin.h
  OUTPUT_NAME "ffi_rust_plugin"
)

target_compile_definitions(ffi_rust_plugin PUBLIC DART_SHARED_LIB)

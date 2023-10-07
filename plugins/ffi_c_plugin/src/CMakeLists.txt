# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(ffi_c_plugin_library VERSION 0.0.1 LANGUAGES C)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

# set(CMAKE_CXX_FLAGS "-Wall -Wextra")
## Compile with optimizations also in debug mode
# set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_DEBUG "-O3")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

add_library(ffi_c_plugin SHARED
  "ffi_c_plugin.cpp"
  "simulation.cpp"
)

set_target_properties(ffi_c_plugin PROPERTIES
  PUBLIC_HEADER ffi_c_plugin.h
  OUTPUT_NAME "ffi_c_plugin"
)

target_compile_definitions(ffi_c_plugin PUBLIC DART_SHARED_LIB)

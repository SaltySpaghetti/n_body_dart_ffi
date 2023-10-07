#ifndef FFI_C_PLUGIN_H
#define FFI_C_PLUGIN_H

#include "simulation.h"

// #include <stdint.h>
// #include <stdio.h>
// #include <stdlib.h>

// #if _WIN32
// #include <windows.h>
// #else
// #include <pthread.h>
// #include <unistd.h>
// #endif

#if _WIN32
#define FFI_PLUGIN_EXPORT extern "C" __declspec(dllexport)
#include <windows.h>
#else
#define FFI_PLUGIN_EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

FFI_PLUGIN_EXPORT void init_c(
    int32_t particles_amount,
    double canvas_width,
    double canvas_height,
    double min_mass,
    double max_mass);

FFI_PLUGIN_EXPORT Particle *update_particles_c();

#endif
#ifndef LIB_FFI_H
#define LIB_FFI_H

#ifdef _WIN32
#define FFI extern "C" __declspec(dllexport)
#pragma warning ( disable : 4310 )
#else
#define FFI extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

typedef struct Particle
{
    float mass;
    float pos_x;
    float pos_y;
    float vel_x;
    float vel_y;
    float force;
} Particle;

FFI void init_c(int particles_amount,
                float canvas_width,
                float canvas_height,
                float min_mass,
                float max_mass);

Particle* update_particles_c();

#endif
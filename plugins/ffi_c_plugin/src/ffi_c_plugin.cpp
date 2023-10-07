#include "ffi_c_plugin.h"

#include <iostream>

NBody nbody = NBody(0, 0.0, 0.0, 0.0, 0.0);

void init_c(int32_t particles_amount,
          double canvas_width,
          double canvas_height,
          double min_mass,
          double max_mass)
{
    nbody = NBody(particles_amount,
                 canvas_width,
                 canvas_height,
                 min_mass,
                 max_mass);
    nbody.init();
}

Particle* update_particles_c() 
{
    nbody.update_particles();
    return nbody.particles.data();
}
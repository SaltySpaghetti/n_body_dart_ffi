#include "lib.h"
#include "simulation.h"

NBody nbody = NBody(0, 0.0, 0.0, 0.0, 0.0);

void init_c(int particles_amount,
          float canvas_width,
          float canvas_height,
          float min_mass,
          float max_mass)
{
    nbody.particles.clear();
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
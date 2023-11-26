#ifndef SIMULATIONS_H
#define SIMULATIONS_H

#include <vector>

typedef struct Particle
{
    double mass;
    double pos_x;
    double pos_y;
    double vel_x;
    double vel_y;
    double force;
} Particle;

class NBody
{
public:
    std::vector<Particle> particles;

    NBody(int particles_amount,
          double canvas_width,
          double canvas_height,
          double min_mass,
          double max_mass);

    void init();

    const Particle *update_particles();

private:
    int m_particles_amount;
    double m_canvas_width;
    double m_canvas_height;
    double m_min_mass;
    double m_max_mass;
};

#endif
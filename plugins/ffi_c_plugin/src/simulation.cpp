#include "simulation.h"

#include <math.h>

#define RANGE(MIN, MAX) (MIN + ((((double)rand() / (double)RAND_MAX)) * (MAX - MIN)))
#define DELTA_T 0.001

NBody::NBody(int particles_amount,
             double canvas_width,
             double canvas_height,
             double min_mass,
             double max_mass) : m_particles_amount(particles_amount),
                                m_canvas_width(canvas_width),
                                m_canvas_height(canvas_height),
                                m_min_mass(min_mass),
                                m_max_mass(max_mass){};

void NBody::init()
{
    for (int i = 0; i < m_particles_amount; i++)
    {
        double radius_x = m_canvas_width / 2;
        double radius_y = m_canvas_height / 2;
        double circle_radius = fmin(radius_x, radius_y);
        double rand_radius = RANGE(0.0f, circle_radius);
        double angle = RANGE(-M_PI, M_PI);

        double position_x = radius_x + cos(angle) * rand_radius;
        double position_y = radius_y + sin(angle) * rand_radius;
        double velocity_x = cos(angle - M_PI / 2.0) * rand_radius * 10.0;
        double velocity_y = sin(angle - M_PI / 2.0) * rand_radius * 10.0;
        double mass = RANGE(m_min_mass, m_max_mass);
        particles.push_back(
            Particle{mass, position_x, position_y, velocity_x, velocity_y, 0.0});
    }
}

const Particle *NBody::update_particles()
{
    double distX = 0;
    double distY = 0;
    double dist = 0;
    double fI = 0;
    double fJ = 0;
    int bodiesCount = (int)particles.size();
    std::vector<double> accel_x(bodiesCount);
    std::vector<double> accel_y(bodiesCount);

    std::fill(accel_x.begin(), accel_x.end(), 0);
    std::fill(accel_y.begin(), accel_y.end(), 0);

    // calculate new velocity
    /// F = G(m1m2)/R^2 (for 2D)
    for (int i = 0; i < bodiesCount; ++i)
    {
        particles[i].force = 0.0;
        for (int j = i + 1; j < bodiesCount; ++j)
        {
            distX = particles[i].pos_x - particles[j].pos_x;
            distY = particles[i].pos_y - particles[j].pos_y;
            dist = sqrt(distX * distX + distY * distY);

            fI = particles[j].mass / (dist * dist);
            fJ = particles[i].mass / (dist * dist);

            accel_x[i] -= distX * fI;
            accel_y[i] -= distY * fI;

            accel_x[j] += distX * fJ;
            accel_y[j] += distY * fJ;

            particles[i].force += fJ;
            particles[j].force += fI;
        }

        particles[i].force /= bodiesCount * 10;
    }
    // std::cout << "FORCE  " << particles[0].force << std::endl;

    /// calculate new position
    for (int i = 0; i < bodiesCount; ++i)
    {
        particles[i].vel_x += accel_x[i] * DELTA_T;
        particles[i].vel_y += accel_y[i] * DELTA_T;

        particles[i].pos_x += particles[i].vel_x * DELTA_T;
        particles[i].pos_y += particles[i].vel_y * DELTA_T;
    }

    return particles.data();
}
#include "lib.h"
#include <vector>

class NBody
{
public:
    std::vector<Particle> particles;

    NBody(int particles_amount,
                float canvas_width,
                float canvas_height,
                float min_mass,
                float max_mass);

    void init();

    const Particle *update_particles();


private:
    int m_particles_amount;
    float m_canvas_width;
    float m_canvas_height;
    float m_min_mass;
    float m_max_mass;
};

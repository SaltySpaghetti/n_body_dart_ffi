typedef struct NBody NBody;

struct ParticleRust
{
   float mass;
   float pos_x;
   float pos_y;
   float vel_x;
   float vel_y;
   float force;
};

const struct NBody *init(int particles_amount,
                   float canvas_width,
                   float canvas_height,
                   float min_mass,
                   float max_mass,
                   struct NBody *previous_ptr);

const struct ParticleRust **update_particles(struct NBody *n_body_ptr);

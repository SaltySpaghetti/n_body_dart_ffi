use std::f32::consts::PI;

use rand::Rng;

const DELTA_T: f32 = 0.0001;

mod capi;

#[derive(Debug)]
pub struct Particle {
    pub mass: f32,
    pub pos_x: f32,
    pub pos_y: f32,
    pub vel_x: f32,
    pub vel_y: f32,
    pub force: f32,
}

#[derive(Debug)]
pub struct SimulationConfig {
    pub particles_amount: i32,
    pub canvas_size: (f32, f32),
    pub min_mass: f32,
    pub max_mass: f32,
}

#[derive(Debug)]
pub struct NBody {
    config: SimulationConfig,
    particles: Vec<Particle>,
}

impl NBody {
    pub const fn new() -> Self {
        NBody {
            config: SimulationConfig {
                particles_amount: 0,
                canvas_size: (0.0, 0.0),
                min_mass: 0.0,
                max_mass: 0.0,
            },
            particles: vec![],
        }
    }

    pub const fn new_with_config(config: SimulationConfig) -> Self {
        NBody {
            config,
            particles: vec![],
        }
    }

    pub fn update_config(&mut self, config: SimulationConfig) -> &mut Self {
        self.config = config;
        self
    }

    pub fn init(&mut self) -> &mut Self {
        for _ in 0..self.config.particles_amount {
            let radius = (self.config.canvas_size.0 / 2.0, self.config.canvas_size.1 / 2.0);
            let circle_radius = radius.0.min(radius.1);
            let rand_radius = rand::thread_rng().gen_range(0.0..circle_radius);
            let angle = rand::thread_rng().gen_range(-PI..PI);

            let position = (radius.0 + angle.cos() * rand_radius, radius.1 + angle.sin() * rand_radius);
            let velocity = ((angle - PI / 2.0).cos() * (rand_radius) * 10.0, (angle - PI / 2.0).sin() * (rand_radius) * 10.0);
            let mass = rand::thread_rng().gen_range(self.config.min_mass..self.config.max_mass);

            let particle = Particle {
                mass,
                pos_x: position.0,
                pos_y: position.1,
                vel_x: velocity.0,
                vel_y: velocity.1,
                force: 0.0,
            };

            self.particles.push(particle);
        }

        self
    }

    pub fn update_particles(&mut self) -> &mut Self {
        let particles_amount = self.particles.len();
        let mut acceleration: (Vec<f32>, Vec<f32>) = (
            vec![0.0; particles_amount],
            vec![0.0; particles_amount],
        );

        for i in 0..particles_amount {
            self.particles[i].force = 0.0;
            for j in i+1..particles_amount {
                let tmp_dist = (
                    self.particles[i].pos_x - self.particles[j].pos_x,
                    self.particles[i].pos_y - self.particles[j].pos_y,
                );
                let dist = (tmp_dist.0 * tmp_dist.0 + tmp_dist.1 * tmp_dist.1).sqrt();

                let f_i = self.particles[j].mass / (dist * dist);
                let f_j = self.particles[i].mass / (dist * dist);

                acceleration.0[i] -= tmp_dist.0 * f_i;
                acceleration.1[i] -= tmp_dist.1 * f_i;

                acceleration.0[j] += tmp_dist.0 * f_j;
                acceleration.1[j] += tmp_dist.1 * f_j;

                self.particles[i].force += f_j;
                self.particles[j].force += f_i;
            }

            self.particles[i].force /= (particles_amount as f32) * 10.0;
        }

        for i in 0..particles_amount {
            self.particles[i].vel_x += acceleration.0[i] * DELTA_T;
            self.particles[i].vel_y += acceleration.1[i] * DELTA_T;

            self.particles[i].pos_x += self.particles[i].vel_x * DELTA_T;
            self.particles[i].pos_y += self.particles[i].vel_y * DELTA_T;
        }

        self
    }
}
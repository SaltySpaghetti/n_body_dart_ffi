use core::ffi::{c_double, c_int};
use rand::Rng;
use std::f32::consts::PI;

#[derive(Debug)]
pub struct Particle {
    mass: f32,
    pos: (f32, f32),
    velocity: (f32, f32),
    force: f32,
}

#[derive(Debug)]
pub struct SimulationConfig {
    pub particles_amount: u32,
    pub canvas_size: (f32, f32),
    pub min_mass: f32,
    pub max_mass: f32,
}

#[derive(Debug)]
pub struct NBodyManager {
    config: SimulationConfig,
    pub particles: Vec<Particle>,
}

impl NBodyManager {
    pub fn new(config: SimulationConfig) -> Self {
        NBodyManager {
            config,
            particles: vec![],
        }
    }

    pub fn init(&mut self) {
        dbg!(&self);
        for _ in 0..self.config.particles_amount {
            let radius_x = self.config.canvas_size.0 / 2.0;
            let radius_y = self.config.canvas_size.1 / 2.0;
            let circle_radius = radius_x.min(radius_y);
            let rand_radius = rand::thread_rng().gen_range(0.0..circle_radius);
            let angle = rand::thread_rng().gen_range(-PI..PI);

            let px = radius_x + angle.cos() * rand_radius;
            let py = radius_y + angle.sin() * rand_radius;

            let vx = (angle - PI / 2.0).cos() * (rand_radius) * 10.0;
            let vy = (angle - PI / 2.0).sin() * (rand_radius) * 10.0;

            let particle = Particle {
                mass: rand::thread_rng().gen_range(self.config.min_mass..self.config.max_mass),
                pos: (px, py),
                velocity: (vx, vy),
                force: 0.0,
            };

            self.particles.push(particle);
        }
    }
}

#[no_mangle]
pub extern "C" fn init(
    particles_amount: u32,
    canvas_width: f32,
    canvas_height: f32,
    min_mass: f32,
    max_mass: f32,
) {
    let mut manager = NBodyManager::new(SimulationConfig {
        particles_amount,
        canvas_size: (canvas_width, canvas_height),
        min_mass,
        max_mass,
    });

    manager.init();

    dbg!(manager);
}

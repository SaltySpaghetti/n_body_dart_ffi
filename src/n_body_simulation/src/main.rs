use n_body_simulation::{SimulationConfig, MANAGER};

fn main() {
    unsafe {
        MANAGER = MANAGER.clone().update_config(SimulationConfig {
            particles_amount: 20,
            canvas_size: (200.0, 200.0),
            min_mass: 1000.0,
            max_mass: 6000.0,
        });
    }
}

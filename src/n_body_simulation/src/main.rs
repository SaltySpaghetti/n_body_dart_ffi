use n_body_simulation::{NBodyManager, SimulationConfig};

fn main() {
    let mut manager = NBodyManager::new_with_config(SimulationConfig {
        particles_amount: 10,
        canvas_size: (200.0, 200.0),
        min_mass: 1000.0,
        max_mass: 6000.0,
    });

    manager.init();

    dbg!(&manager);

    manager.update_particles();

    dbg!(&manager);
}
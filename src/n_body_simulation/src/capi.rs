// #[cfg(feature = "capi")]
mod capi {
    use std::mem::drop;

    use crate::{NBody, Particle, SimulationConfig};

    #[no_mangle]
    pub extern "C" fn init(
        particles_amount: i32,
        canvas_width: f32,
        canvas_height: f32,
        min_mass: f32,
        max_mass: f32,
        previous_ptr: Option<Box<NBody>>,
    ) -> Box<NBody> {
        //Dropping previous pointer if init() is re-called
        if previous_ptr.is_some() {
            drop(previous_ptr.unwrap());
        }

        let config = SimulationConfig {
            particles_amount,
            canvas_size: (canvas_width, canvas_height),
            min_mass,
            max_mass,
        };

        let mut n_body = Box::new(NBody::new_with_config(config));
        n_body.init();

        n_body
    }

    #[no_mangle]
    pub extern "C" fn update_particles(n_body_ptr: &mut NBody) -> *const Vec<Particle> {
        &n_body_ptr.update_particles().particles
    }
}

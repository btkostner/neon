use rustler::NifMap;

#[derive(Debug, NifMap)]
struct Aggregate {
    open_price: f64,
    high_price: f64,
    low_price: f64,
    close_price: f64,

    volume: u64,

    timestamp: String,
}

#[rustler::nif]
fn moving_averages(data: Vec<Aggregate>, length: i64) -> i64 {
    data.len() as i64 + length
}

rustler::init!("Elixir.NeonPredict", [moving_averages]);

use criterion::{Criterion, black_box, criterion_group, criterion_main};
use utils::{factorial, is_prime, square};

fn bench_square(c: &mut Criterion) {
    c.bench_function("square 100", |b| b.iter(|| square(black_box(100))));
}

fn bench_factorial(c: &mut Criterion) {
    c.bench_function("factorial 15", |b| b.iter(|| factorial(black_box(15))));
}

fn bench_is_prime(c: &mut Criterion) {
    c.bench_function("is_prime 97", |b| b.iter(|| is_prime(black_box(97))));

    let mut group = c.benchmark_group("is_prime sizes");
    group.bench_function("small (7)", |b| b.iter(|| is_prime(black_box(7))));
    group.bench_function("medium (997)", |b| b.iter(|| is_prime(black_box(997))));
    group.bench_function("large (999983)", |b| b.iter(|| is_prime(black_box(999983))));
    group.finish();
}

criterion_group!(benches, bench_square, bench_factorial, bench_is_prime);
criterion_main!(benches);

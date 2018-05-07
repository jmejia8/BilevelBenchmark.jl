using BilevelBenchmark
using Base.Test

# write your own tests here
@test bilevel_leader(ones(1000), ones(1000), 1) ≈ bilevel_leader(ones(1000), ones(1000), 1)
@test bilevel_leader(ones(1000), ones(1000), 2) ≈ 0

using BilevelBenchmark
using Base.Test

# write your own tests here

@testset "SDM" begin
    for i = 1:8
        @test bilevel_leader(ones(1000), ones(1000), i) ≈ bilevel_leader(ones(1000), ones(1000), i)
    end
end
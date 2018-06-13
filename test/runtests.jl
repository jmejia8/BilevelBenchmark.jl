using BilevelBenchmark
using Base.Test

# write your own tests here

@testset "bilevel" begin
    for i = 1:8
        @test bilevel_leader(ones(1000), ones(1000), i) ≈ bilevel_leader(ones(1000), ones(1000), i)
    end
end

@testset "SDM" begin
    p, q, r, s = 3, 3, 2, 0
    for i = 1:8
        @test SDM_leader(ones(1000), ones(1000), i, p, q, r, s) ≈ SDM_leader(ones(1000), ones(1000), i, p, q, r, s)
        @test SDM_follower(ones(1000), ones(1000), i, p, q, r, s) ≈ SDM_follower(ones(1000), ones(1000), i, p, q, r, s)
    end
end
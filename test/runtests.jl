using BilevelBenchmark
using Base.Test


@testset "bilevel" begin
    for i = 1:8
        @test bilevel_leader(ones(1000), ones(1000), i) ≈ bilevel_leader(ones(1000), ones(1000), i)
    end
end

@testset "SMD" begin
    p, q, r, s = 3, 3, 2, 0
    for i = 1:8
        @test SMD_leader(ones(1000), ones(1000), i, p, q, r, s) ≈ SMD_leader(ones(1000), ones(1000), i, p, q, r, s)
        @test SMD_follower(ones(1000), ones(1000), i, p, q, r, s) ≈ SMD_follower(ones(1000), ones(1000), i, p, q, r, s)
    end
end
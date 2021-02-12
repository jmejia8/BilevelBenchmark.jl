using BilevelBenchmark
using Test

@testset "Bilevel unconstrained" begin
    D_ul = 5
    D_ll = 5
    for i = 1:8
        x, y = SMD_solutions(D_ul, D_ll, i)
        Fx, fy = SMD_leader(x, y, i), SMD_leader(x, y, i)
        @test  abs(Fx) + abs(fy) < 1e-10
    end
end


@testset "Bilevel Ranges" begin
    D_ul = 5
    D_ll = 5
    for i = 1:8
        bounds_ul, bounds_ll = SMD_ranges(D_ul, D_ll, i)
        x = bounds_ul[1,:] + (bounds_ul[2,:] - bounds_ul[1,:]) .* rand(D_ul)
        y = bounds_ll[1,:] + (bounds_ll[2,:] - bounds_ll[1,:]) .* rand(D_ul)
        
        Fx, fy = SMD_leader(x, y, i), SMD_leader(x, y, i)
        @test  abs(Fx) + abs(fy) > -Inf
    end
end

@testset "SMD" begin
    p, q, r, s = 3, 3, 2, 0
    for i = 1:8
        @test SMD_leader(ones(1000), ones(1000), i, p, q, r, s) ≈ SMD_leader(ones(1000), ones(1000), i, p, q, r, s)
        @test SMD_follower(ones(1000), ones(1000), i, p, q, r, s) ≈ SMD_follower(ones(1000), ones(1000), i, p, q, r, s)
    end
end

@testset "TP" begin
    for i = 1:10
        @test TP_test(i) >= 0

        # bounds_ul, bounds_ll = TP_ranges(i)
        
    end
end

@testset "PMM" begin
    for i = 1:6
        F, f = BilevelBenchmark.PMM_test(10, 10, i)
        @test abs(f + F) <= 1e-16 
    end

    x = zeros(9)
    for fnum = 1:6
        y = PMM_Ψ(x, 9, fnum)
        if fnum < 7
            F = PMM_leader(x, y, fnum)
            f = PMM_follower(x, y, fnum)
        else
            F, _ = PMM_leader(x, y, fnum)
            f, _ = PMM_follower(x, y, fnum)
        end

        @test abs(F) <= 1e-16 &&  abs(f) <= 1e-16
    end
end


@testset "bilevel constrained" begin
    D_ul = 5
    D_ll = 5

    for i = 9:12
        p,q,r,s,lenG, leng = SMD_settings(D_ul, D_ll, i)

        bounds_ul, bounds_ll = SMD_ranges(D_ul, D_ll, i)
        x = bounds_ul[1,:] + (bounds_ul[2,:] - bounds_ul[1,:]) .* rand(D_ul)
        y = bounds_ll[1,:] + (bounds_ll[2,:] - bounds_ll[1,:]) .* rand(D_ul)

        F, G = SMD_leader(x, y, i)
        f, g = SMD_follower(x, y, i)


        @test length(G) == lenG
        @test length(g) == leng
        @test abs(F + sum(G)) >= 0
        @test abs(f + sum(g)) >= 0
    end
end


@testset "bilevel get problem" begin
    for benchmark in [:SMD, :PMM, :TP]
        for fnum = 1:6
            F, f, bounds_ul, bounds_ll, Ψ, z = get_problem(benchmark, fnum)
            x = bounds_ul[1,:]
            y = bounds_ll[1,:]
            Fxy = F(x, y)
            fxy = f(x,y)
            @test abs(z[1]) + abs(z[2]) >= 0 
        end
    end
    
end


function PMM_settings(fnum::Int)

    settings = zeros(Int32, 2)
    ccall((:PMM_config, bilevelBenchmark),
          Cvoid,
        (Ptr{Int32}, Int32),
        settings, fnum)

    lenG, leng = settings

    return lenG, leng
end


function PMM_Ψ(x::Array{Float64}, m::Int, fnum::Int)

    lenG, leng = PMM_settings(fnum)

    n = length(x)
    y = zeros(n)
    
    ccall((:PMM_Psi, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        m,   n,       x,           y,        fnum)

    return y
end

function PMM_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    lenG, leng = PMM_settings(fnum)
    F = [0.0]
    G = zeros(lenG)

    n = length(x)
    m = div(n, 2)

    ccall((:PMM_leader, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        m, n, x, y, F, G, fnum)

    if lenG == 0
        return F[1]
    end

    return F[1], -G
    
end

function PMM_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    lenG, leng = PMM_settings(fnum)
    f = [0.0]
    g = zeros(leng)

    n = length(x)
    m = div(n, 2)

    ccall((:PMM_follower, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        m, n, x, y, f, g, fnum)

    if leng == 0
        return f[1]
    end

    return f[1], -g
end

function PMM_test(m, n, fnum)
    x = rand(10)
    y = PMM_Ψ(x, 5, fnum)#rand(10)
    if fnum < 6
        F = PMM_leader(x, y, fnum)
        f = PMM_follower(x, y, fnum)
    else
        F, _ = PMM_leader(x, y, fnum)
        f, _ = PMM_follower(x, y, fnum)
    end

    if !(f ≈ 0)
        @error("Check bilevel-benchmark repository: (x, y) is infeasible")
        return -1
    end

    return abs(F) + abs(f)
end

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
    x = zeros(n)
    
    ccall((:PMM_Psi, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        m,   n,       x,           y,        fnum)

    return x, y
end

function PMM_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    lenG, leng = PMM_settings(fnum)
    F = [0.0]
    G = zeros(lenG)

    ccall((:PMM_leader, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, x, y, F, G, fnum)

    if lenG == 0
        return F[1]
    end

    return F[1], -G
    
end

function PMM_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    lenG, leng = PMM_settings(fnum)
    f = [0.0]
    g = zeros(leng)

    ccall((:PMM_follower, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, x, y, f, g, fnum)

    if leng == 0
        return F[1]
    end

    return f[1], -g
end

function PMM_test(fnum)
    lenG, leng = PMM_settings(fnum)

    x = rand(D_ul)
    y = rand(D_ll)
    f, gs = PMM_follower(x, y, fnum)
    F, Gs = PMM_leader(x, y, fnum)
    return abs(F + f)
end


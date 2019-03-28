function TP_settings(fnum::Int)

    settings = zeros(Int32, 4)
    ccall((:TP_config, bilevelBenchmark),
          Cvoid,
        (Ptr{Int32}, Int32),
        settings, fnum)

    D_ul, D_ll, lenG, leng = settings

    return D_ul, D_ll, lenG, leng
end

function TP_solutions(fnum::Int)

    D_ul, D_ll, lenG, leng = TP_settings(fnum)

    x = zeros(D_ul)
    y = zeros(D_ll)
    
    ccall((:TP_solutions, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul,   D_ll,       x,           y,        fnum)

    return x, y
end

function TP_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    D_ul, D_ll, lenG, _ = TP_settings(fnum)
    F = [0.0]
    G = zeros(lenG)

    ccall((:TP_leader, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, x, y, F, G, fnum)

    return F[1], -G
    
end

function TP_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    D_ul, D_ll, _, leng = TP_settings(fnum)
    f = [0.0]
    g = zeros(leng)

    ccall((:TP_follower, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, x, y, f, g, fnum)

    return f[1], -g
end

function TP_test(fnum)
    D_ul, D_ll, lenG, leng = TP_settings(fnum)

    x = rand(D_ul)
    y = rand(D_ll)
    f, gs = TP_follower(x, y, fnum)
    F, Gs = TP_leader(x, y, fnum)
    return abs(F + f)
end


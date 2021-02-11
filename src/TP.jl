function TP_settings(fnum::Int)

    settings = zeros(Int32, 4)
    ccall((:TP_config, bilevelBenchmark),
          Cvoid,
        (Ptr{Int32}, Int32),
        settings, fnum)

    D_ul, D_ll, lenG, leng = settings

    return Int(D_ul), Int(D_ll), Int(lenG), Int(leng)
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

function TP_optimum(fnum::Int)

    F = [0.0] 
    f = [0.0] 
    ccall((:TP_optimum, bilevelBenchmark),
        Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        F, f, fnum)

    return F[1], f[1]
end

function TP_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    D_ul, D_ll, lenG, _ = TP_settings(fnum)
    F = [0.0]
    G = zeros(lenG)

    ccall((:TP_leader, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, x, y, F, G, fnum)

    return F[1], G
    
end

function TP_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    D_ul, D_ll, _, leng = TP_settings(fnum)
    f = [0.0]
    g = zeros(leng)

    ccall((:TP_follower, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, x, y, f, g, fnum)

    return f[1], g
end

function TP_ranges(fnum)
    D_ul, D_ll, _, leng = TP_settings(fnum)

    bounds_ul = zeros(2D_ul)
    bounds_ll = zeros(2D_ll)

    # TP_ranges(int D_ul, int D_ll, double *bounds_ul, double *bounds_ll, int fnum)
    ccall((:TP_ranges, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
          D_ul,  D_ll,    bounds_ul,    bounds_ll,  fnum)

    return Array(reshape(bounds_ul, D_ul, :)'), Array(reshape(bounds_ll, D_ll, :)')
end



function TP_test(fnum)
    D_ul, D_ll, lenG, leng = TP_settings(fnum)
    D_ul, D_ll, lenG, leng = TP_settings(fnum)

    bounds_ul = TP_ranges(fnum)
    bounds_ll = TP_ranges(fnum)
    Fx, fx = TP_optimum(fnum)
    x, y = TP_solutions(fnum)
    FFx = TP_leader(x,y, fnum)[1]
    ffx = TP_follower(x,y, fnum)[1]

    x = rand(D_ul)
    y = rand(D_ll)
    f, gs = TP_follower(x, y, fnum)
    F, Gs = TP_leader(x, y, fnum)
    return abs(F + f)
end


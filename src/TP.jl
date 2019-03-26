
function bilevel_settings(D_ul::Int, D_ll::Int, fnum::Int)

    settings = zeros(Int32, 4)
    ccall((:TP_leader, bilevelBenchmark),
          Cvoid,
        (Ptr{Int32}, Int32),
        settings, fnum)

    D_ul, D_ll, lenG, leng = settings

    return D_ul, D_ll, lenG, leng
end

function TP_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    D_ul, D_ll, lenG, leng = bilevel_settings(D_ul, D_ll, fnum)
    F = [0.0]
    G = [0.0]

    ccall((:TP_leader, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        1, D_ul, D_ll, x, y, F, G, fnum)

    if lenG == 0
        return F[1]
    end

    return F[1], -G
    
end

function TP_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    D_ul = length(x)
    D_ll = length(y)
    f = [0.0]
    g = [0.0]
    leng = 0

    if fnum > 8
        _, leng = bilevel_settings(D_ul, D_ll, fnum)
        g = zeros(leng)
    end

    ccall((:TP_follower, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        1, D_ul, D_ll, x, y, f, g, fnum)
    
    if leng == 0
        return f[1]
    end

    return f[1], -g
end

function PMM_settings(D_ul::Int, D_ll::Int, fnum::Int)

    settings = zeros(Int32, 5)
    ccall((:PMM_config, bilevelBenchmark),
          Cvoid,
        (Int32,Int32,Ptr{Int32}, Int32),
        D_ul, D_ll,settings, fnum)

    _, _,m,lenG, leng = settings

    return m,lenG, leng
end


function PMM_Ψ(x::Array{Float64}, D_ll::Int, fnum::Int)

    D_ul = length(x)
    
    m,lenG, leng = PMM_settings(D_ul,D_ll,fnum)

    y = zeros(D_ll)
    
    ccall((:PMM_Psi, bilevelBenchmark),
          Cvoid,
        (Int32, Int32,Int32, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, m,       x,           y,        fnum)

    return y
end

function PMM_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    F = [0.0]

    D_ul = length(x)
    D_ll = length(y)

    m,lenG, leng = PMM_settings(D_ul,D_ll,fnum)
    G = zeros(lenG)

    ccall((:PMM_leader, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, x, y, F, G, fnum)

    if lenG == 0
        return F[1]
    end

    return F[1], G
    
end

function PMM_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int)
    f = [0.0]


    D_ul = length(x)
    D_ll = length(y)

    m,lenG, leng = PMM_settings(D_ul,D_ll,fnum)
    g = zeros(leng)

    ccall((:PMM_follower, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        D_ul, D_ll, x, y, f, g, fnum)

    if leng == 0
        return f[1]
    end

    return f[1], g
end

function PMM_test(D_ul, D_ll, fnum)
    x = -10 .+ 20*rand(D_ul)
    y = PMM_Ψ(x, D_ll, fnum)#rand(10)
    if fnum < 6
        F = PMM_leader(x, y, fnum)
        f = PMM_follower(x, y, fnum)
    else
        F, _ = PMM_leader(x, y, fnum)
        f, _ = PMM_follower(x, y, fnum)
    end

    return F, f
end

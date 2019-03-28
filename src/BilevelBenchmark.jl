module BilevelBenchmark

if VERSION >= v"0.7.0"
    using Pkg
    "BinDeps" ∉ keys(Pkg.installed()) && Pkg.add("BinDeps")

elseif VERSION < v"0.7.0"
    Pkg.installed("BinDeps") == nothing && Pkg.add("BinDeps")
    Cvoid = Void
end

if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("This test function suit is not properly installed. Please run Pkg.build(\"BilevelBenchmark\")")
end

export bilevel_leader, bilevel_follower, SMD_leader, SMD_follower, bilevel_solutions
export bilevel_settings, bilevel_ranges
export TP_settings,TP_leader,TP_follower,TP_test

include("TP.jl")

function bilevel_settings(D_ul::Int, D_ll::Int, fnum::Int)
    r = div(D_ul, 2);
    p = D_ul - r;
    q = s = 0
    
    if fnum == 6
        q = floor(Int, (D_ll - r) / 2);
        s =  ceil(Int, (D_ll - r) / 2);
    else
        q = D_ll - r;
    end

    if fnum == 9
        lenG = 1
        leng = 1
    elseif fnum == 10
        lenG = p+r
        leng = q
    elseif fnum == 11
        lenG = r
        leng = 1
    elseif fnum == 12
        lenG = 2*r + p
        leng = q+1
    else
        lenG = 0
        leng = 0
    end

    return lenG, leng
end

function bilevel_solutions(D_ul::Int, D_ll::Int, fnum::Int)
    x = zeros(D_ul)
    y = zeros(D_ll)

    ccall((:blb18_cop_solutions, bilevelBenchmark),
              Cvoid,
            (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
            D_ul, D_ll, x, y, fnum)
    
    return x, y
end

function bilevel_ranges(D_ul::Int, D_ll::Int, fnum::Int)
    bounds_ul = zeros(2D_ul)
    bounds_ll = zeros(2D_ll)

    ccall((:blb18_cop_ranges, bilevelBenchmark),
              Cvoid,
            (Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
            D_ul, D_ll, bounds_ul, bounds_ll, fnum)
    
    return Array(reshape(bounds_ul, D_ul, :)'), Array(reshape(bounds_ll, D_ll, :)')
end

function bilevel_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int)
	D_ul = length(x)
	D_ll = length(y)
    F = [0.0]
	G = [0.0]
    lenG = 0

    if fnum > 8
        lenG, _ = bilevel_settings(D_ul, D_ll, fnum)
        G = zeros(lenG)
    end

    ccall((:blb18_leader_cop, bilevelBenchmark),
          Cvoid,
        (Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
        1, D_ul, D_ll, x, y, F, G, fnum)

    if lenG == 0
    	return F[1]
    end

    return F[1], -G


    
end

function bilevel_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int)
	D_ul = length(x)
	D_ll = length(y)
    f = [0.0]
	g = [0.0]
    leng = 0

    if fnum > 8
        _, leng = bilevel_settings(D_ul, D_ll, fnum)
        g = zeros(leng)
    end

	ccall((:blb18_follower_cop, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
		1, D_ul, D_ll, x, y, f, g, fnum)
	
    if leng == 0
        return f[1]
    end

    return f[1], -g
end


function SMD_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int,p::Int,q::Int,r::Int,s::Int = 0)
	F = [0.0]

	if fnum == 1
		ccall((:SMD1_leader, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 2
		ccall((:SMD2_leader, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 3
		ccall((:SMD3_leader, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 4
		ccall((:SMD4_leader, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 5
		ccall((:SMD5_leader, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 6
		ccall((:SMD6_leader, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, s, x, y, F)
	elseif fnum == 7
		ccall((:SMD7_leader, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 8
		ccall((:SMD8_leader, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	else
		error("Not a valid number")
	end
	
	return F[1]
end


function SMD_follower(x::Array{Float64},y::Array{Float64},fnum::Int,p::Int,q::Int,r::Int,s::Int = 0)
	D_ul = length(x)
	D_ll = length(y)
	F = [0.0]

	if fnum == 1
		ccall((:SMD1_follower, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 2
		ccall((:SMD2_follower, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 3
		ccall((:SMD3_follower, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 4
		ccall((:SMD4_follower, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 5
		ccall((:SMD5_follower, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 6
		ccall((:SMD6_follower, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, s, x, y, F)
	elseif fnum == 7
		ccall((:SMD7_follower, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 8
		ccall((:SMD8_follower, bilevelBenchmark),
		  Cvoid,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	else
		error("Not a valid number")
	end
	
	return F[1]
end


end # module

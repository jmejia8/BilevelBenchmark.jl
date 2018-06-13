module BilevelBenchmark

if Pkg.installed("BinDeps") == nothing
    Pkg.add("BinDeps")
end

if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("This test function suit is not properly installed. Please run Pkg.build(\"BilevelBenchmark\")")
end

export bilevel_leader, bilevel_follower, SDM_leader, SDM_follower

function bilevel_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int)
	D_upper = length(x)
	D_lower = length(y)
	F = [0.0]

	ccall((:blb18_leader_cop, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
		1, D_upper, D_lower, x, y, F, fnum)
	
	return F[1]
end

function bilevel_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int)
	D_upper = length(x)
	D_lower = length(y)
	F = [0.0]

	ccall((:blb18_follower_cop, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
		1, D_upper, D_lower, x, y, F, fnum)
	
	return F[1]
end


function SDM_leader(x::Array{Float64}, y::Array{Float64}, fnum::Int, p, q, r, s = 0)
	F = [0.0]

	if fnum == 1
		ccall((:SDM1_leader, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 2
		ccall((:SDM2_leader, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 3
		ccall((:SDM3_leader, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 4
		ccall((:SDM4_leader, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 5
		ccall((:SDM5_leader, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 6
		ccall((:SDM6_leader, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, s, x, y, F)
	elseif fnum == 7
		ccall((:SDM7_leader, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 8
		ccall((:SDM8_leader, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	else
		error("Not a valid number")
	end
	
	return F[1]
end


function SDM_follower(x::Array{Float64}, y::Array{Float64}, fnum::Int, p, q, r, s = 0)
	D_upper = length(x)
	D_lower = length(y)
	F = [0.0]

	if fnum == 1
		ccall((:SDM1_follower, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 2
		ccall((:SDM2_follower, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 3
		ccall((:SDM3_follower, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 4
		ccall((:SDM4_follower, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 5
		ccall((:SDM5_follower, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 6
		ccall((:SDM6_follower, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, s, x, y, F)
	elseif fnum == 7
		ccall((:SDM7_follower, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	elseif fnum == 8
		ccall((:SDM8_follower, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		  p, q, r, x, y, F)
	else
		error("Not a valid number")
	end
	
	return F[1]
end


end # module

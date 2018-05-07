module BilevelBenchmark

if Pkg.installed("BinDeps") == nothing
    Pkg.add("BinDeps")
end

if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("This test function suit is not properly installed. Please run Pkg.build(\"BilevelBenchmark\")")
end

export bilevel_leader, bilevel_follower

function bilevel_leader(x::Vector, y::Vector, fnum::Int)
	D_upper = length(x)
	D_lower = length(y)
	F = [0.0]

	ccall((:blb18_leader_cop, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
		1, D_upper, D_lower, x, y, F, fnum)
	
	return F[1]
end

function bilevel_follower(x::Vector, y::Vector, fnum::Int)
	D_upper = length(x)
	D_lower = length(y)
	F = [0.0]

	ccall((:blb18_follower_cop, bilevelBenchmark),
		  Void,
		(Int32, Int32, Int32, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Int32),
		1, D_upper, D_lower, x, y, F, fnum)
	
	return F[1]
end

end # module

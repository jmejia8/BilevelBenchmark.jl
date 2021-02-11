module BilevelBenchmark

if VERSION < v"0.7.0"
    Pkg.installed("BinDeps") == nothing && Pkg.add("BinDeps")
    Cvoid = Void
end

if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("This test function suit is not properly installed. Please run Pkg.build(\"BilevelBenchmark\")")
end

export bilevel_leader, bilevel_follower, bilevel_solutions
export bilevel_settings, bilevel_ranges
export TP_settings,TP_leader,TP_follower,TP_test, TP_optimum
export SMD_settings, SMD_solutions, SMD_ranges, SMD_leader, SMD_follower, SMD_optimum
export PMM_settings, PMM_Ψ, PMM_leader, PMM_follower, PMM_test, PMM_ranges, TP_ranges, PMM_optimum
export SMD_Ψ
export get_problem

include("TP.jl")
include("SMD.jl")
include("PMM.jl")
include("deprecated.jl")

function get_problem(benchmark, fnum; D_ul = 2, D_ll = 3)
    if benchmark == :SMD
        F = (x,y) -> SMD_leader(x,y,fnum)
        f = (x,y) -> SMD_follower(x,y,fnum)
        Ψ = x -> SMD_Ψ(x, D_ll, fnum)
        bounds_ul, bounds_ll = SMD_ranges(D_ul, D_ll, fnum)
        z = SMD_optimum(fnum)
    elseif benchmark == :PMM
        F = (x,y) -> PMM_leader(x,y,fnum)
        f = (x,y) -> PMM_follower(x,y,fnum)
        Ψ = x -> PMM_Ψ(x, D_ll, fnum)
        bounds_ul, bounds_ll = PMM_ranges(D_ul, D_ll, fnum)
        z = PMM_optimum(fnum)
    elseif benchmark == :TP
        @warn "TP not implement the Ψ mapping"
        F = (x,y) -> TP_leader(x,y,fnum)
        f = (x,y) -> TP_follower(x,y,fnum)
        Ψ = x -> zeros(D_ll)
        bounds_ul, bounds_ll = TP_ranges(fnum)
        z = TP_optimum(fnum)
    else
        error("Only :SMD, :PMM and :TP are defined.")
        return
    end

    return F, f, bounds_ul, bounds_ll, Ψ, z 
end



end # module

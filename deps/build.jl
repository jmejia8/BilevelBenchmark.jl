if VERSION >= v"0.7.0"
    using Pkg
    "BinDeps" ∉ keys(Pkg.installed()) && Pkg.add("BinDeps")
    "Compat" ∉ keys(Pkg.installed()) && Pkg.add("Compat")

elseif VERSION < v"0.7.0" && Pkg.installed("BinDeps") == nothing
    Pkg.add("BinDeps")    
end

using BinDeps
using Compat.Libdl

@BinDeps.setup

version = "9.1.1"
bilevelBenchmark = library_dependency("bilevelBenchmarkJulia", aliases=["blb18_op_v$version"], os = :Unix)

# build from source
provides(Sources,
        URI("https://github.com/jmejia8/bilevel-benchmark/archive/v$(version).zip"),
        unpacked_dir="bilevel-benchmark-$version",
        bilevelBenchmark)

# provides(BuildProcess, Autotools(libtarget = "libgsl.la"), bilevelBenchmark)

prefix = joinpath(BinDeps.depsdir(bilevelBenchmark), "usr")
srcdir = joinpath(BinDeps.srcdir(bilevelBenchmark), "bilevel-benchmark-$version")

println(prefix)

provides(SimpleBuild,
    (@build_steps begin
        GetSources(bilevelBenchmark)
        CreateDirectory(joinpath(prefix, "lib"))
        @build_steps begin
            ChangeDirectory(srcdir)
            MAKE_CMD
            `mv blb18_op.$(Libdl.dlext) "$prefix/lib/blb18_op_v$(version).$(Libdl.dlext)"`
        end
    end), [bilevelBenchmark], os = :Unix)

@BinDeps.install Dict(:bilevelBenchmarkJulia => :bilevelBenchmark)

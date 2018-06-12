if Pkg.installed("BinDeps") == nothing
    Pkg.add("BinDeps")
end

using BinDeps
using Compat.Libdl

@BinDeps.setup

bilevelBenchmark = library_dependency("bilevelBenchmarkJulia", aliases=["blb18_op"], os = :Unix)
version = "v0.5"

# build from source
provides(Sources,
        URI("https://github.com/jmejia8/bilevel-benchmark/archive/$(version).zip"),
        unpacked_dir="bilevel-benchmark-master",
        bilevelBenchmark)

# provides(BuildProcess, Autotools(libtarget = "libgsl.la"), bilevelBenchmark)

prefix = joinpath(BinDeps.depsdir(bilevelBenchmark), "usr")
srcdir = joinpath(BinDeps.srcdir(bilevelBenchmark), "bilevel-benchmark-master")

println(prefix)

provides(SimpleBuild,
    (@build_steps begin
        GetSources(bilevelBenchmark)
        CreateDirectory(joinpath(prefix, "lib"))
        @build_steps begin
            ChangeDirectory(srcdir)
            MAKE_CMD
            `mv blb18_op.$(Libdl.dlext) "$prefix/lib"`
        end
    end), [bilevelBenchmark], os = :Unix)

@BinDeps.install Dict(:bilevelBenchmarkJulia => :bilevelBenchmark)

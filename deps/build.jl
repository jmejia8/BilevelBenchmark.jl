if VERSION < v"0.7.0" && Pkg.installed("BinDeps") == nothing
    Pkg.add("BinDeps")    
end

using BinDeps
using Compat.Libdl

@BinDeps.setup

version = "9.1.6"
bilevelBenchmark = library_dependency("bilevelBenchmarkJulia",
                                      aliases=["blb18_op_v$version", "blb18_op.exe"],
                                      os = BinDeps.OSNAME)

# build from source
provides(Sources,
        URI("https://github.com/jmejia8/bilevel-benchmark/archive/v$(version).zip"),
        unpacked_dir="bilevel-benchmark-$version",
        bilevelBenchmark, so = :Unix)


prefix = joinpath(BinDeps.depsdir(bilevelBenchmark), "usr")
srcdir = joinpath(BinDeps.srcdir(bilevelBenchmark), "bilevel-benchmark-$version")


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


provides(Binaries,
    URI("https://bi-level.org/wp-content/uploads/2020/12/blb_op.zip"),
    bilevelBenchmark,
    os = :Windows)


@BinDeps.install Dict(:bilevelBenchmarkJulia => :bilevelBenchmark)

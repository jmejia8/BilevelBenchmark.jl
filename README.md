# A Benchmark for Bilevel Optimization for Julia

Test Function Suite for Bilevel Optimization.


## Installation

```julia
Pkg.clone("git@github.com:jmejia8/BilevelBenchmark.jl.git")
```

## Example


```julia
using BilevelBenchmark

# upper level
D_upper = 100
x = rand(D_upper)

# lower level
D_lower = 100
y = rand(D_lower)

# get the upper level value
F = bilevel_leader(rand(10), rand(10), 1)

# get the lower level value
f = bilevel_follower(rand(10), rand(10), 1)
```

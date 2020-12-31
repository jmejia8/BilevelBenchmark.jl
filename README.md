# A Benchmark for Bilevel Optimization for Julia

Test Function Suite for Bilevel Optimization.


## Installation


Open the Julia (Julia 1.0 or Later) REPL and press `]` to open the Pkg prompt. To add this package, use the add command:


Type `]`  
```julia
pkg> add https://github.com/jmejia8/BilevelBenchmark.jl.git
```

Or, equivalently, via the `Pkg` API:

```julia
julia> import Pkg; Pkg.add("https://github.com/jmejia8/BilevelBenchmark.jl.git")
```

## Example


## SMD test suite

Simple example:

```julia
using BilevelBenchmark

# upper level
D_upper = 100 # dimension (number of variables)
x = rand(D_upper)

# lower level
D_lower = 100 # dimension (number of variables)
y = rand(D_lower)

# test function number
fnum = 1 # SMD1

# get the upper level value
Fxy = SMD_leader(x, y, fnum)

# get the lower level value
fxy = SMD_follower(x, y, fnum)
```

You also can wrap the upper and lower level functions (say SMD2) into
a Julia Function:


```julia
using BilevelBenchmark

# leader function
F(x, y) = SMD_leader(x, y, 2)

# follower function
f(x, y) = SMD_follower(x, y, 2)

# leader decision vector
x = rand(5)

# follower decision vector
y = rand(5)

@show F(x, y)
@show f(x, y)
```

### Feasible Solutions

It can be useful to know a feasible solution related to an upper level vector (x).
This Package includes the following method to handle that `SMD_Ψ(x, D_ll, fnum)`
where `x` is the upper level vector, `D_ll` is the lower level dimension and `fnum`
is the test problem id (e.g. `fnum = 5` is for the SMD5 test problem).

Example:

```julia
using BilevelBenchmark

# SMD5
fnum = 5

# a random leader decision vector
x = rand(5) # 5D

# lower level optimal solution corresponding to x
D_ll = 5
y = SMD_Ψ(x, D_ll, fnum)

# show feasible solution
@show (x, y)

```


### Other methods:

- Optimal feasible solutions: `SMD_solutions(D_ul, D_ll, fnum)`
- UL and LL ranges/search spaces: `SMD_ranges(D_ul, D_ll, fnum)`




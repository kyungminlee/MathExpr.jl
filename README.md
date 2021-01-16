# MathExpr.jl

| **Documentation** | **Build Status** | **Code Coverage** |
|:-----------------:|:----------------:|:-----------------:|
| [![**STABLE**][docs-stable-img]][docs-stable-url] [![**DEV**][docs-dev-img]][docs-dev-url] | [![Build][githubaction-img]][githubaction-url] | [![Code Coverage][codecov-img]][codecov-url] |


**MathExpr.jl** provides (1) parser `parseexpr` for mathematical expressions using Julia's parser, and (2) exact methods for determinant and inverse for matrices (`determinant` and `inverse`).

Expressions supported by the parser include:
- Unary operations: `+` and `-`
- Binary operations: `+`, `-`, `*`, `/`, `//`, `\`, `^`
- Mathematical functions
  - `cos`, `sin`, `tan`
  - `cosh`, `sinh`, `tanh`
  - `exp`, `cis`
  - `cospi`, `sinpi`, `cispi`
  - `sqrt`
  - `log`
  - `abs`, `abs2`, `sign`
  - `conj`, `real`, `imag`, `angle`
- Mathematical constants
  - `i`, `im`
  - `pi`, `π`

```julia-repl
julia> using MathExpr

julia> parseexpr("cos(0.75π)+i*sin(0.5*pi)")
 -0.7071067811865475 + 1.0im

julia> parseexpr("[cos(0.1) sin(0.1); -sin(0.1) cos(0.1)]")
2×2 Array{Float64,2}:
  0.995004   0.0998334
 -0.0998334  0.995004
```

"Exact" determinant and inverse support matrices of integers and rational numbers.

```julia-repl
julia> inverse([2 0; 1 2])
2×2 Array{Rational{Int64},2}:
  1//2  0//1
 -1//6  1//3

julia> determinant([2 0; 1 3])
6
```

Note that `determinant` and `inverse` are also defined for floating points. They simply call `LinearAlgebra`'s `det` and `inv`.

```julia-repl
julia> det([2.0 0.0; 1.0 3.0])
6.0

julia> inv([2.0 0.0; 1.0 3.0])
2×2 Array{Float64,2}:
  0.5       0.0
 -0.166667  0.333333
```

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: http://kyungminlee.org/MathExpr.jl/stable
[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: http://kyungminlee.org/MathExpr.jl/dev

[githubaction-img]: https://github.com/kyungminlee/MathExpr.jl/workflows/Build/badge.svg
[githubaction-url]: https://github.com/kyungminlee/MathExpr.jl/actions?query=workflow%3ABuild

[codecov-img]: https://codecov.io/gh/kyungminlee/MathExpr.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/kyungminlee/MathExpr.jl

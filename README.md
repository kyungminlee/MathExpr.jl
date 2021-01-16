# MathExpr.jl

**Build Status**: [![Build][githubaction-img]][githubaction-url]

**Code Coverage**: [![Code Coverage][codecov-img]][codecov-url]

`MathExpr.jl` provides a simple parser for mathematical expressions using Julia's parser.
Supported expressions include:
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

# Quick Example

```julia-repl
julia> using MathExpr

julia> parseexpr("cos(0.75π)+i*sin(0.5*pi)")
 -0.7071067811865475 + 1.0im
```

[githubaction-img]: https://github.com/kyungminlee/MathExpr.jl/workflows/Build/badge.svg
[githubaction-url]: https://github.com/kyungminlee/MathExpr.jl/actions?query=workflow%3ABuild

[codecov-img]: https://codecov.io/gh/kyungminlee/MathExpr.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/kyungminlee/MathExpr.jl

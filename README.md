# MathExpr.jl

| **Build Status** | **Code Coverage** |
|:----------------:|:-----------------:|
| [![Build Status][travis-img]][travis-url] [![Build Status][appveyor-img]][appveyor-url] | [![Code Coverage][codecov-img]][codecov-url] [![Code Coverage][coveralls-img]][coveralls-url] |

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


[travis-img]: https://travis-ci.org/kyungminlee/MathExpr.jl.svg?branch=main
[travis-url]: https://travis-ci.org/kyungminlee/MathExpr.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/1yrosfyjvn4u61nw?svg=true
[appveyor-url]: https://ci.appveyor.com/project/kyungminlee/MathExpr-jl

[codecov-img]: https://codecov.io/gh/kyungminlee/MathExpr.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/kyungminlee/MathExpr.jl

[coveralls-img]: https://coveralls.io/repos/github/kyungminlee/MathExpr.jl/badge.svg?branch=main
[coveralls-url]: https://coveralls.io/github/kyungminlee/MathExpr.jl?branch=main

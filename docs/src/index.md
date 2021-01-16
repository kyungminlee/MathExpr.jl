# MathExpr.jl

**MathExpr.jl** provides (1) parser for mathematical expressions, and (2) exact methods for matrix determinant and inverse.

## Exmples

```julia-repl
julia> using MathExpr

julia> parseexpr("cos(0.75π)+i*sin(0.5*pi)")
 -0.7071067811865475 + 1.0im

julia> parseexpr("[cos(0.1) sin(0.1); -sin(0.1) cos(0.1)]")
2×2 Array{Float64,2}:
  0.995004   0.0998334
 -0.0998334  0.995004

julia> inverse([2 0; 1 2])
2×2 Array{Rational{Int64},2}:
  1//2  0//1
 -1//4  1//2
```

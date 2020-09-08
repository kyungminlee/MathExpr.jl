export parseexpr

for (TL, TR, OP) in [
    (Integer, Integer, ://),
    (Integer, Rational, ://),
    (Rational, Integer, ://),
    (Rational, Rational, ://),
    (Real, Real, :/)
]
    @eval begin
        divide(lhs::$TL, rhs::$TR) = ($OP)(lhs, rhs)
        divide(lhs::Complex{<:$TL}, rhs::$TR) = ($OP)(lhs, rhs)
        divide(lhs::$TL, rhs::Complex{<:$TR}) = ($OP)(lhs, rhs)
        divide(lhs::Complex{<:$TL}, rhs::Complex{<:$TR}) = ($OP)(lhs, rhs)
    end
end

rdivide(lhs::Number, rhs::Number) = divide(rhs, lhs)

cispi(arg::Number) = cospi(arg) + im*sinpi(arg)

SYMBOL_DATABASE = Dict(
    :i => im,  :im => im,
    :pi => pi,  :π => π,
    :+ => (+),  :- => (-),  :* => (*),  :/ => (divide),  :\ => (rdivide),  :^ => (^),  :// => (divide),
    :cos => cos,  :sin => sin,  :tan => tan,
    :cosh => cosh,  :sinh => sinh,  :tanh => tanh,
    :exp => exp,
    :cospi => cospi,  :sinpi => sinpi,
    :cis => cis,  :cispi => cispi,
    :sqrt => sqrt,
    :log => log,
    :abs => abs,  :abs2 => abs2,  :sign => sign,
    :conj => conj,  :real => real,  :imag => imag,
    :angle => angle,
)

evalexpr(expr::Number) = expr
function evalexpr(expr::Symbol)
    if haskey(SYMBOL_DATABASE, expr)
        return SYMBOL_DATABASE[expr]
    else
        error("unsupported symbol $expr")
    end
end

function evalexpr(expr::Expr)
    if expr.head == :call
        ftn, args = Iterators.peel(evalexpr.(expr.args))
        return ftn(args...)
    elseif expr.head == :vect
        return [(evalexpr.(expr.args))...]
    elseif expr.head == :tuple
        return tuple((evalexpr.(expr.args))...)
    elseif expr.head == :hcat
        return hcat((evalexpr.(expr.args))...)
    elseif expr.head == :row
        return hcat((evalexpr.(expr.args))...)
    elseif expr.head == :vcat
        return vcat((evalexpr.(expr.args))...)
    else
        throw(ArgumentError("unsupported expression $expr"))
    end
end

parseexpr(expr::Number) = expr
parseexpr(expr::AbstractString) = evalexpr(Meta.parse(expr))
parseexpr(expr::AbstractArray) = [parseexpr(elem) for elem in expr]

#= # commented for now
function parsetable(s::AbstractString)
    s = strip(s)
    rows = Vector{Int}[]
    for line in split(s, "\n")
        line = strip(line)
        row = [parse(Int, x) for x in split(line)]
        !isempty(row) && push!(rows, row)
    end
    return transpose(hcat(rows...))
end
=#

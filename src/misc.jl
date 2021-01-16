export extendedgcd
export tuplelength
export tupleadd
export tuplesubtract
export tuplezero
export tupleone
export choptol!


function extendedgcd(a::Integer, b::Integer)
    sign_a, sign_b = sign(a), sign(b)
    s, old_s = 0, 1
    r, old_r = abs(b), abs(a)
    while r != 0
        quotient = old_r ÷ r
        (old_r, r) = (r, old_r - quotient * r)
        (old_s, s) = (s, old_s - quotient * s)
    end
    if b != 0
        bezout_t = (old_r - old_s * abs(a)) ÷ abs(b)
    else
        bezout_t = 0
    end
    return (old_r, [sign_a * old_s, sign_b * bezout_t])
end


tuplelength(::Type{<:NTuple{N, Any}}) where N = N
tuplelength(::NTuple{N, Any}) where N = N

tupleadd(l::T, r::T) where {T<:Tuple} = l .+ r
tuplesubtract(l::T, r::T) where {T<:Tuple} = l .- r

tuplezero(::Type{T}) where {T<:Tuple} = ((zero(S) for S in T.parameters)...,)
tupleone(::Type{T}) where {T<:Tuple} = ((one(S) for S in T.parameters)...,)

tuplezero(::T) where {T<:Tuple} = ((zero(S) for S in T.parameters)...,)
tupleone(::T) where {T<:Tuple} = ((one(S) for S in T.parameters)...,)


function choptol!(d::Dict{K, V}, tol::Real) where {K, V<:Number}
    to_delete = K[k for (k, v) in d if abs(v) < tol]
    for k in to_delete
        delete!(d, k)
    end
    return d
end

export cleanupnumber

function cleanupnumber(x::AbstractFloat, tol::Real)
    units = [16, 16/sqrt(3), 16*sqrt(3)]
    for unit in units
        if isapprox(x*unit, round(x*unit); atol=tol)
            return round(x*unit)/unit
        end
    end
    return x
end

cleanupnumber(x::Integer, tol::Real) = x
cleanupnumber(x::Rational{<:Integer}, tol::Real) = x

function cleanupnumber(x::Complex, tol::Real)
    return cleanupnumber(real(x), tol) + im * cleanupnumber(imag(x), tol)
end

cleanupnumber(x::AbstractArray, tol::Real) = [cleanupnumber(y, tol) for y in x]

@deprecate cleanup_number(x) cleanupnumber(x)

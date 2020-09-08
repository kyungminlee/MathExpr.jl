import LinearAlgebra

export determinant
export inverse

ScalarType = Union{Integer, Complex{<:Integer}, <:Rational, Complex{<:Rational}}

function get_cofactor_matrix_unsafe!(
    out::AbstractMatrix{I1},
    mat::AbstractMatrix{I2},
    row::Integer,
    col::Integer,
) where {I1<:ScalarType, I2<:ScalarType}
    out[1:row-1, 1:col-1] = mat[1:row-1, 1:col-1]
    out[1:row-1, col:end] = mat[1:row-1, col+1:end]
    out[row:end, 1:col-1] = mat[row+1:end, 1:col-1]
    out[row:end, col:end] = mat[row+1:end, col+1:end]
    return out
end

function determinant_unsafe(mat::AbstractMatrix{S}) where {S<:ScalarType}
    n = size(mat)[1]
    n == 1 && return mat[1]
    out = Matrix{S}(undef, (n-1, n-1))
    sign = 1
    D = zero(S)
    for f = 1:n
        get_cofactor_matrix_unsafe!(out, mat, 1, f)
        @inbounds D += sign * mat[1,f] * determinant_unsafe(out)
        sign = -sign
    end
    return D
end

function determinant(mat::AbstractMatrix{S}) where {S<:ScalarType}
    n, m = size(mat)
    n != m && throw(ArgumentError("matrix needs to be square"))
    n <= 0 && throw(ArgumentError("matrix empty"))
    return determinant_unsafe(mat)
end

determinant(mat::AbstractMatrix{<:AbstractFloat}) = LinearAlgebra.det(mat)
determinant(mat::AbstractMatrix{<:Complex{<:AbstractFloat}}) = LinearAlgebra.det(mat)

function inverse(mat::AbstractMatrix{S}) where {S<:ScalarType}
    n, m = size(mat)
    n != m && throw(ArgumentError("matrix needs to be square"))
    n <= 0 && throw(ArgumentError("matrix empty"))
    n == 1 && return ones(S, (1,1)) .// mat[1]
    cofactor = Array{S}(undef, (n, n))
    temp = Array{S}(undef, (n-1, n-1))
    for r in 1:n, c in 1:n
        sign = 1 - 2 * mod(r+c, 2)
        get_cofactor_matrix_unsafe!(temp, mat, r, c)
        @inbounds cofactor[r,c] = sign * determinant_unsafe(temp)
    end
    D = sum(mat[1,:] .* cofactor[1,:])
    return transpose(cofactor) // D
end

inverse(mat::AbstractMatrix{<:AbstractFloat}) = LinearAlgebra.inv(mat)
inverse(mat::AbstractMatrix{<:Complex{<:AbstractFloat}}) = LinearAlgebra.inv(mat)

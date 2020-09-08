using Test
using MathExpr
using LinearAlgebra

@testset "linear algebra" begin
    mat = Int[
        1 2 3;
        4 5 2;
        7 8 10]

    @testset "cofactor" begin
        results = Dict(
            (1,1) => [5 2; 8 10],
            (1,2) => [4 2; 7 10],
            (1,3) => [4 5; 7 8],
            (2,1) => [2 3; 8 10],
            (2,2) => [1 3; 7 10],
            (2,3) => [1 2; 7 8],
            (3,1) => [2 3; 5 2],
            (3,2) => [1 3; 4 2],
            (3,3) => [1 2; 4 5]
        )

        for i in 1:3, j in 1:3
            out = ones(Int, (2,2))
            MathExpr.get_cofactor_matrix_unsafe!(out, mat, i, j)
            @test out == results[i,j]
        end
    end

    @testset "determinant" begin
        tol = Base.rtoldefault(Float64)
        @test_throws ArgumentError determinant([1 2 3; 4 5 6])
        @test_throws ArgumentError determinant(ones(Int, 0,0))
        @test determinant(7*ones(Int, 1, 1)) == 7

        @test determinant(float.(mat)) == det(mat)
        @test abs(det(mat) - determinant(mat)) < tol
        for n in [5, 6, 7, 8]
            a = rand(-3:3, (n, n))
            det1 = det(a)
            det2 = determinant(a)
            @test abs(det1 - det2) < Base.rtoldefault(Float64)
        end
    end # testset determinant

    @testset "inverse" begin
        tol = Base.rtoldefault(Float64)
        @test_throws ArgumentError inverse([1 2 3; 4 5 6])
        @test_throws ArgumentError inverse(ones(Int, 0, 0))
        @test inverse(7*ones(Int, 1, 1)) == ones(Int, 1, 1)//7

        @test maximum(abs.(inv(mat) - inverse(float.(mat)))) < tol
        @test maximum(abs.(inv(mat) - inverse(mat))) < tol
        for n in [5, 6, 7, 8]
            a = rand(-3:3, (n, n)) + 30*I
            inv1 = inv(a)
            inv2 = inverse(a)
            @test maximum(abs.(inv1 - inv2)) < tol
        end

    end
end # testset ExactLinearAlgebra


@testset "parseexpr" begin
    @test 1 == parseexpr(1)
    @test 1 == parseexpr("1")
    @test 1.5 == parseexpr("1.5")
    @test 1.5im == parseexpr("1.5im")
    @test 1.5im == parseexpr("1.5i")
    @test [1,2,3] == parseexpr("[1,2,3]")
    @test [1,2,3im] == parseexpr([1, "2", "3i"])

    @test parseexpr("2") == 2
    @test parseexpr("i") == im
    @test parseexpr("cis(2)") == cis(2)
    @test parseexpr("exp(2i)") == exp(2im)
    @test parseexpr("[10, π, exp(1)]") == [10, π, exp(1)]
    @test parseexpr("[10 π]") == [10 π]
    @test parseexpr("[1 2; 3 4]") == [1 2; 3 4]
    @test parseexpr("(1, 2.0)") == (1, 2.0)

    @test parseexpr("2+3") == 2+3
    @test parseexpr("2-3") == 2-3
    @test parseexpr("2*3") == 2*3
    @test parseexpr("2/3") == 2/3
    @test parseexpr("2//3") == 2//3
    @test parseexpr("2\\3") == 2\3
    @test parseexpr("2^3") == 2^3

    for unary_ftn in [cos, sin, tan, exp, cis, cospi, sinpi, sqrt, log, abs, abs2, sign, conj, conj, real, imag, angle]
        @test parseexpr("$unary_ftn(3.0 + 5.0i)") == unary_ftn(3.0 + 5.0im)
    end
    @test_throws ArgumentError parseexpr("j")
    @test_throws ArgumentError parseexpr("true ? π : -1")
end

@testset "cleanup" begin
    @test cleanupnumber(42, 1E-8) == 42
    @test cleanupnumber(1.5 + 1E-12, 1E-8) == 1.5
    @test cleanupnumber([1.0 + 1E-12, 2.0 - 1E-12, 3.0], 1E-8) == [1.0, 2.0, 3.0]
    @test cleanupnumber(0.1234567, 1E-8) == 0.1234567
    @test cleanupnumber(-1//3, 1E-8) == -1//3
end

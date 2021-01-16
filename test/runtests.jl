using Test
using MathExpr
using LinearAlgebra

@testset "linear algebra" begin
    mat = Int[
        1 2 3;
        4 5 2;
        7 8 10
    ]

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
            let
                a = big.(rand(-3:3, (n, n)) + 30*I)
                @test abs(det(a) - determinant(a)) < tol
                b = big.(rand(-2:2, (n, n)) + im*rand(-2:2, (n,n)) + 10*I)
                @test abs(det(b) - determinant(b)) < tol
            end
            let
                a = big.(rand(-3:3, (n, n))//4 + 30*I)
                @test abs(det(a) - determinant(a)) < tol
                b = big.(rand(-2:2, (n, n))//4 + im*rand(-2:2, (n,n)) + 10*I)
                @test abs(det(b) - determinant(b)) < tol
            end
            c = rand(Float64, (n, n)) + 30*I
            @test abs(det(c) - determinant(c)) < tol
            d = rand(ComplexF64, (n, n)) + 30*I
            @test abs(det(d) - determinant(d)) < tol
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
            let
                a = rand(-3:3, (n, n)) + 30*I
                @test maximum(abs.(inv(float.(a)) - inverse(big.(a)))) < tol
                b = rand(-3:3, (n, n)) + im*rand(-3:3, (n,n)) + 30*I
                @test maximum(abs.(inv(float.(b)) - inverse(big.(b)))) < tol
            end
            let
                a = rand(-3:3, (n, n))//4 + 30*I
                @test maximum(abs.(inv(float.(a)) - inverse(big.(a)))) < tol
                b = rand(-3:3, (n, n))//4 + im*rand(-3:3, (n,n))+ 30*I
                @test maximum(abs.(inv(float.(b)) - inverse(big.(b)))) < tol
            end
            c = rand(Float64, (n, n)) + 30*I
            @test maximum(abs.(inv(float.(c)) - inverse(c))) < tol
            d = rand(ComplexF64, (n, n)) + 30*I
            @test maximum(abs.(inv(float.(d)) - inverse(d))) < tol
        end
    end
end

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
    @test parseexpr("cispi(0.5)") == cospi(0.5) + im*sinpi(0.5)
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
    @test cleanupnumber(42 + im, 1E-8) == 42 + im
    @test cleanupnumber(1.5 + 1E-12 + 1.0im, 1E-8) == 1.5 + 1.0im
    @test cleanupnumber([1.0 + 1E-12 + 1.0im, 2.0 - 1E-12 + 2.0im - 1E-12im, 3.0 + 3.0im + 1E-12im], 1E-8) == [1.0 + 1.0im, 2.0 + 2.0im, 3.0 + 3.0im]
    @test cleanupnumber(1//2 + 3im//4, 1E-8) == 1//2 + 3im//4
end


@testset "misc" begin
    @testset "gcd" begin
        using MathExpr: extendedgcd
        let x = 3, y = 0
            r, (a,b) = extendedgcd(x,y)
            @test r == 3
            @test a*x + b*y == r
        end
        let x = 0, y = -3
            r, (a,b) = extendedgcd(x,y)
            @test r == 3
            @test a*x + b*y == r
        end

        for sx in [-1,1], sy in [-1,1]
            let x = 3*sx, y = 4*sy
                r, (a,b) = extendedgcd(x,y)
                @test r == 1
                @test a*x + b*y == r
            end
            let x = 6*sx, y = 9*sy
                r, (a,b) = extendedgcd(x,y)
                @test r == 3
                @test a*x + b*y == r
            end
        end
    end
end

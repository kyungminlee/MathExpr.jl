using Documenter, MathExpr

makedocs(;
    modules=[MathExpr],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/kyungminlee/MathExpr.jl/blob/{commit}{path}#L{line}",
    sitename="MathExpr.jl",
    authors="Kyungmin Lee",
    assets=String[],
)

deploydocs(;
    repo="github.com/kyungminlee/MathExpr.jl",
    devbranch="dev",
)

using NWBS3
using Documenter

DocMeta.setdocmeta!(NWBS3, :DocTestSetup, :(using NWBS3); recursive=true)

makedocs(;
    modules=[NWBS3],
    authors="brendanjohnharris <brendanjohnharris@gmail.com> and contributors",
    repo="https://github.com/brendanjohnharris/NWBS3.jl/blob/{commit}{path}#{line}",
    sitename="NWBS3.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/brendanjohnharris/NWBS3.jl.git",
)

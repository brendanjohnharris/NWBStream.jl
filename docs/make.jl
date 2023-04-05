using NWBStream
using Documenter

DocMeta.setdocmeta!(NWBStream, :DocTestSetup, :(using NWBStream); recursive=true)

makedocs(;
    modules=[NWBStream],
    authors="brendanjohnharris <brendanjohnharris@gmail.com> and contributors",
    repo="https://github.com/brendanjohnharris/NWBStream.jl/blob/{commit}{path}#{line}",
    sitename="NWBStream.jl",
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
    repo = "github.com/brendanjohnharris/NWBStream.jl.git",
)

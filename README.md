# NWBStream

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://brendanjohnharris.github.io/NWBStream.jl/dev)
[![Build Status](https://github.com/brendanjohnharris/NWBStream.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/brendanjohnharris/NWBStream.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/brendanjohnharris/NWBStream.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/brendanjohnharris/NWBStream.jl)


The goal of this package is to modularize streaming from an NWB S3 file, of the type used for the Dandi archive. It will open a connection to the remote file, then provide some convenience functions for loading data.
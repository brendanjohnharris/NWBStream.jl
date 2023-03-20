module NWBS3
using PythonCall
using Pkg.Artifacts
using DataFrames
using Downloads
using DelimitedFiles

export cachefs, dandiurl, s3open, url2df


const pynwb = PythonCall.pynew()
const fsspec = PythonCall.pynew()
const h5py = PythonCall.pynew()
const fsspec_cached = PythonCall.pynew()

# Create the file cache
artifact_toml = abspath(joinpath(@__DIR__, "../Artifacts.toml"))
cachehash = artifact_hash("cache", artifact_toml)
if isnothing(cachehash) || !artifact_exists(cachehash)
    cachehash = create_artifact() do artifact_dir
        mkpath(artifact_dir)
    end
    bind_artifact!(artifact_toml, "cache", cachehash)
end

function __init__()
    PythonCall.pycopy!(pynwb, pyimport("pynwb"))
    PythonCall.pycopy!(fsspec, pyimport("fsspec"))
    PythonCall.pycopy!(h5py, pyimport("h5py"))
    PythonCall.pycopy!(fsspec_cached, pyimport("fsspec.implementations.cached"))
end

"""
    cachefs(protocol::String="http") -> CachingFileSystem

Create a caching file system object using `fsspec_cached.CachingFileSystem`.
The `protocol` argument sets the underlying file system protocol to be used and is set to `"http"` by default.

Returns a new `CachingFileSystem` object that can be used for reading and writing files from the specified file system.
"""
function cachefs(protocol="http")
    CachingFileSystem = fsspec_cached.CachingFileSystem
    CachingFileSystem(
        fs=fsspec.filesystem(protocol),
        cache_storage=artifact"cache",  # Local folder for the cache
    )
end


"""
    s3open(s3_url::AbstractString, mode::AbstractString="rb") -> Any

Open a file from an S3 URL.

## Arguments
- `s3_url::AbstractString`: The S3 URL of the file.
- `mode::AbstractString="rb"`: The access mode. Default is read-only in binary mode.

## Examples
```julia
s3_url = dandiurl()
data = s3open(s3_url)
```
"""
function s3open(s3_url, mode="rb")
    f = cachefs().open(s3_url, mode)
    file = h5py.File(f)
    io = pynwb.NWBHDF5IO(; file=file, load_namespaces=true)
    return io.read()
end

"""
    url2df(url::AbstractString) -> DataFrame

Convert the data from an online CSV file to a `DataFrame`.

## Arguments
- `url::AbstractString`: The URL of the CSV file.

"""
function url2df(url::AbstractString)
    csv = take!(Downloads.download(url, IOBuffer()))
    mat = readdlm(csv, ',')
    return DataFrame(mat[2:end, :], mat[1, :])
end

end

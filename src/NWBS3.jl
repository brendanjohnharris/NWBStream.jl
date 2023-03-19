module NWBS3
using PythonCall
using Pkg.Artifacts
using DataFrames
using Downloads
using DelimitedFiles

export cachefs, dandiurl, s3open, url2df


const pynwb = PythonCall.pynew()
const dandi = PythonCall.pynew()
const fsspec = PythonCall.pynew()
const h5py = PythonCall.pynew()
const fsspec_cached = PythonCall.pynew()
const dandiapi = PythonCall.pynew()

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
    PythonCall.pycopy!(dandi, pyimport("dandi"))
    PythonCall.pycopy!(fsspec, pyimport("fsspec"))
    PythonCall.pycopy!(h5py, pyimport("h5py"))
    PythonCall.pycopy!(fsspec_cached, pyimport("fsspec.implementations.cached"))
    PythonCall.pycopy!(dandiapi, pyimport("dandi.dandiapi"))
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
    dandiurl(dandiset_id::String="000006", filepath::String="sub-anm372795/sub-anm372795_ses-20170718.nwb"; version::Union{Nothing, String}=nothing) -> String

Returns the S3 URL of a file in a DANDI dataset.

## Arguments
- `dandiset_id`: The ID of the DANDI dataset.
- `filepath`: The path of the file within the DANDI dataset.
- `version`: The version of the file. If nothing, the latest version is used.
"""
function dandiurl(dandiset_id="000006", filepath="sub-anm372795/sub-anm372795_ses-20170718.nwb"; version=nothing)
    client = dandiapi.DandiAPIClient()
    if isnothing(version)
        asset = client.get_dandiset(dandiset_id).get_asset_by_path(filepath)
    else
        asset = client.get_dandiset(dandiset_id).get_asset_by_path(filepath, version)
    end
    s3_url = asset.get_content_url(follow_redirects=1, strip_query=true)
    return s3_url
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
    io = pynwb.NWBHDF5IO(; file, load_namespaces=true)
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

include("./Session.jl")

end

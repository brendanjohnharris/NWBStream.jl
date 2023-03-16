module NWBS3
using PythonCall
using Pkg.Artifacts


const pynwb = PythonCall.pynew()
const dandi = PythonCall.pynew()
const fsspec = PythonCall.pynew()
const h5py = PythonCall.pynew()
const fsspec_cached = PythonCall.pynew()
const dandiapi = PythonCall.pynew()


function __init__()
    # Create the file cache
    artifact_toml = joinpath(@__DIR__, "Artifacts.toml")
    cachehash = artifact_hash("cache", artifact_toml)
    if isnothing(cachehash) || !artifact_exists(cachehash)
        cachehash = create_artifact() do artifact_dir
            mkpath(artifact_dir)
        end
        bind_artifact!(artifact_toml, "cache", cachehash)
    end

    PythonCall.pycopy!(pynwb, pyimport("pynwb"))
    PythonCall.pycopy!(dandi, pyimport("dandi"))
    PythonCall.pycopy!(fsspec, pyimport("fsspec"))
    PythonCall.pycopy!(h5py, pyimport("h5py"))
    PythonCall.pycopy!(fsspec_cached, pyimport("fsspec.implementations.cached"))
    PythonCall.pycopy!(dandiapi, pyimport("dandi.dandiapi"))
end

function cachefs()
    CachingFileSystem = fsspec_cached.CachingFileSystem
    CachingFileSystem(
        fs=fsspec.filesystem("http"),
        cache_storage=artifact"cache",  # Local folder for the cache
    )
end

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

function s3open(s3_url, mode="rb")
    f = cachefs().open(s3_url, mode)
    file = h5py.File(f)
    io = pynwb.NWBHDF5IO(; file, load_namespaces=true)
    return io.read()
end


end

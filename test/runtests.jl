using NWBStream
using PythonCall
using Test
using Pkg.Artifacts

@testset "Visual Behaviour" begin
    url = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com/visual-behavior-neuropixels/behavior_ecephys_sessions/1044385384/ecephys_session_1044385384.nwb"
    file, io = s3open(url)
    s3close(io)
end


@testset "Test cacher" begin
    cache = artifact"cache"
    for f in readdir(cache)
        rm(joinpath(cache, f))
    end
    url = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com/visual-behavior-neuropixels/behavior_ecephys_sessions/1044385384/probe_probeB_lfp.nwb"

    (file, io), t = @timed s3open(url)
    _x, _t, _ = @timed file.get_acquisition("probe_1044506933_lfp_data").data
    @test _x isa Py
    x = [(@timed pyconvert(Array{Float64}, _x[i*10000:(i+1)*10000])) for i ∈ 1:10]
    t = getfield.(x, :time)
    x = getfield.(x, :value)

    x, t, _ = @timed _x[0:500000]


    s3close(io)
end

using NWBS3
using Test

@testset "Visual Behaviour" begin
    url = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com/visual-behavior-neuropixels/behavior_ecephys_sessions/1044385384/ecephys_session_1044385384.nwb"
    file, io = @test_nowarn s3open(url)
    s3close(io)
end

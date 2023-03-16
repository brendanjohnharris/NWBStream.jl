module VisualBehaviour
using Downloads
using DelimitedFiles
using DataFrames

const visualbehaviour = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"

function getsessions(hostname=visualbehaviour)
    url = visualbehaviour*"/visual-behavior-neuropixels/project_metadata/ecephys_sessions.csv"
    sessions = take!(Downloads.download(url, IOBuffer()))
    mat = readdlm(sessions, ',')
    return DataFrame(mat[2:end, :], mat[1, :])
end

# * The goal is now to copy all of the convenience functions in AllenAttention.jl to here...

const sources = Dict(
            :Allen_neuropixels_visual_behaviour => "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"
        )

function getmanifestversions(hostname=visualbehaviour)

end

function getmanifesturl(hostname=visualbehaviour, manifest_version="0.1.0")
    object_key = "visual-behavior-neuropixels/manifests/visual-behavior-neuropixels_project_manifest_v$manifest_version.json"
    return hostname*"/"*object_key
end

def get_metadata_url(metadata_table_name: str) -> str:
    hostname = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"
    object_key = f"visual-behavior-neuropixels/project_metadata/{metadata_table_name}.csv"
    return urljoin(hostname, object_key)



def get_behavior_session_url(ecephys_session_id: int) -> str:
    hostname = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"
    object_key = f"visual-behavior-neuropixels/ecephys_sessions/ecephys_session_{ecephys_session_id}.nwb"
    return urljoin(hostname, object_key)


function getmanifestversions(hostname=visualbehaviour)

end

function getmanifesturl(hostname=visualbehaviour, manifest_version="0.1.0")
    object_key = "visual-behavior-neuropixels/manifests/visual-behavior-neuropixels_project_manifest_v$manifest_version.json"
    return hostname*"/"*object_key
end

def get_metadata_url(metadata_table_name: str) -> str:
    hostname = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"
    object_key = f"visual-behavior-neuropixels/project_metadata/{metadata_table_name}.csv"
    return urljoin(hostname, object_key)



def get_behavior_session_url(ecephys_session_id: int) -> str:
    hostname = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"
    object_key = f"visual-behavior-neuropixels/ecephys_sessions/ecephys_session_{ecephys_session_id}.nwb"
    return urljoin(hostname, object_key)

end

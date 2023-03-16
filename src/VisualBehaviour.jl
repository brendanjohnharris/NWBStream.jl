module VisualBehaviour
using Downloads
using DelimitedFiles
using DataFrames
using XMLDict
using JSON

const visualbehaviour = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com/"
const visualbehaviourbehaviour = visualbehaviour*"visual-behavior-neuropixels/"

function getsessiontable(hostname=visualbehaviour)
    url = visualbehaviour*"/visual-behavior-neuropixels/project_metadata/ecephys_sessions.csv"
    sessions = take!(Downloads.download(url, IOBuffer()))
    mat = readdlm(sessions, ',')
    return DataFrame(mat[2:end, :], mat[1, :])
end

function getprobes(hostname=visualbehaviour)

end
function getchannels()
end

function getsessiondata()
end

# * The goal is now to copy all of the convenience functions in AllenAttention.jl to here...

const sources = Dict(
            :Allen_neuropixels_visual_behaviour => "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"
        )

function getmanifesturl(manifest_version="0.1.0")
    object_key = "manifests/visual-behavior-neuropixels_project_manifest_v$manifest_version.json"
    return visualbehaviourbehaviour*object_key
end

function getmanifest(args...)
    hostname = getmanifesturl(args...)
    data = String(take!(Downloads.download(hostname, IOBuffer())))
    JSON.parse(data)
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
    hostname = "https://s3.console.aws.amazon.com/s3/buckets/visual-behavior-neuropixels-data?list-type=2&prefix=visual-behavior-neuropixels/manifests/"
    object_key = "visual-behavior-neuropixels/manifests/visual-behavior-neuropixels_project_manifest_v$manifest_version.json"
    return hostname*"/"*object_key
end

function getmetadatatablename(hostname=visualbehaviour)
    url = visualbehaviour*"/visual-behavior-neuropixels/project_metadata/"
    sessions = take!(Downloads.download(url, IOBuffer()))
    mat = readdlm(sessions, ',')
    return DataFrame(mat[2:end, :], mat[1, :])
end

get_metadata_url(metadata_table_name: str) -> str:
    hostname = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"
    object_key = f"visual-behavior-neuropixels/project_metadata/{metadata_table_name}.csv"
    return urljoin(hostname, object_key)


function filetree(paths::Vector{String})
    dict_tree = Dict{String, Any}()
    for path in paths
        current_dict = dict_tree
        components = splitpath(path)
        for component in components[1:end-1]
            if !haskey(current_dict, component)
                current_dict[component] = Dict{String, Any}()
            end
            current_dict = current_dict[component]
        end
        current_dict[components[end]] = path
    end
    return dict_tree
end

function getdatalayout(hostname=visualbehaviour)
    data = getmanifest()
    ks = merge([data[k] for k in keys(data) if data[k] isa Dict]...)
    ks = getindex.([ks[k] isa Dict ? ks[k] : Dict(k=>ks[k]) for k in keys(ks)], ["url"])
    tree = filetree(String.(ks))
    return tree["https:"]["visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"]["visual-behavior-neuropixels"]
end




def get_behavior_session_url(ecephys_session_id: int) -> str:
    hostname = "https://visual-behavior-neuropixels-data.s3.us-west-2.amazonaws.com"
    object_key = f"visual-behavior-neuropixels/ecephys_sessions/ecephys_session_{ecephys_session_id}.nwb"
    return urljoin(hostname, object_key)

end

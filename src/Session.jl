abstract type AbstractSession end
abstract type AbstractNWBSession end
# AbstractNWBSessions should implement the getfile() method.

struct NWBSession <: AbstractSession
    file
end

struct S3Session <: AbstractSession
    url
end

function getfile(S::S3Session)
    s3open(S.url, "rb")
end

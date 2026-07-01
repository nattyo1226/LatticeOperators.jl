struct SumPrimitive{T<:AbstractSystemTag} <: AbstractPrimitive{T}
    pps::Vector{ProductPrimitive{T}}
end

function SumPrimitive(
    pps::AbstractVector{ProductPrimitive{T}},
) where {T<:AbstractSystemTag}
    return SumPrimitive{T}(collect(ProductPrimitive{T}, pps))
end

function SumPrimitive(
    pp::ProductPrimitive{T},
) where {T<:AbstractSystemTag}
    return SumPrimitive([pp])
end

function SumPrimitive(aps::AbstractPrimitive{T}...) where {T<:AbstractSystemTag}
    pps = Vector{ProductPrimitive{T}}()
    for ap in aps
        if ap isa ElementaryPrimitive{T}
            push!(pps, ProductPrimitive(ap))
        elseif ap isa ProductPrimitive{T}
            push!(pps, ap)
        elseif ap isa SumPrimitive{T}
            append!(pps, ap.pps)
        else
            throw(ArgumentError("Cannot create SumPrimitive from $(typeof(ap))"))
        end
    end

    return SumPrimitive(pps)
end

function Base.:(==)(sp1::SumPrimitive{T}, sp2::SumPrimitive{T}) where {T<:AbstractSystemTag}
    return sp1.pps == sp2.pps
end

function Base.hash(sp::SumPrimitive, h::UInt)
    return hash(sp.pps, h)
end

function Base.adjoint(sp::SumPrimitive{T}) where {T<:AbstractSystemTag}
    pps_adj = Vector{ProductPrimitive{T}}()
    for pp in sp.pps
        push!(pps_adj, adjoint(pp))
    end
    return SumPrimitive(pps_adj)
end

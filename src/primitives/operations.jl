function Base.:(+)(
    ap1::AbstractPrimitive{T},
    ap2::AbstractPrimitive{T},
) where {T<:AbstractSystemTag}
    return SumPrimitive(ap1, ap2)
end

function Base.:(+)(
    ap::AbstractPrimitive{T},
    c::Number,
) where {T<:AbstractSystemTag}
    id = Identity{T}()
    return ap + ProductPrimitive(id, c)
end

function Base.:(+)(
    c::Number,
    ap::AbstractPrimitive{T},
) where {T<:AbstractSystemTag}
    return ap + c
end

function Base.sum(
    aps::AbstractArray{<:AbstractPrimitive{T}},
) where {T<:AbstractSystemTag}
    isempty(aps) && throw(ArgumentError("Cannot take sum of empty array"))
    return reduce(+, aps)
end

function Base.sum(
    aps::AbstractPrimitive{T}...,
) where {T<:AbstractSystemTag}
    isempty(aps) && throw(ArgumentError("Cannot take sum of empty array"))
    return reduce(+, aps)
end

function Base.:(*)(
    c::Number,
    ep::ElementaryPrimitive{T},
) where {T<:AbstractSystemTag}
    return ProductPrimitive([ep], c)
end

function Base.:(*)(
    c::Number,
    pp::ProductPrimitive{T},
) where {T<:AbstractSystemTag}
    coeff = c * pp.coeff
    return ProductPrimitive(pp.eps, coeff)
end

function Base.:(*)(
    c::Number,
    sp::SumPrimitive{T},
) where {T<:AbstractSystemTag}
    pps = Vector{ProductPrimitive{T}}()
    for pp in sp.pps
        push!(pps, c * pp)
    end

    return SumPrimitive(pps)
end

function Base.:(*)(
    pp::AbstractPrimitive{T},
    c::Number,
) where {T<:AbstractSystemTag}
    return c * pp
end

function Base.:(*)(
    ap1::AbstractPrimitive{T},
    ap2::AbstractPrimitive{T},
) where {T<:AbstractSystemTag}
    eps = Vector{ElementaryPrimitive{T}}()
    coeff = one(ComplexF64)
    for ap in (ap1, ap2)
        if ap isa ElementaryPrimitive{T}
            push!(eps, ap)
        elseif ap isa ProductPrimitive{T}
            append!(eps, ap.eps)
            coeff *= ap.coeff
        else
            throw(ArgumentError("Cannot multiply $(typeof(ap))"))
        end
    end

    return ProductPrimitive(eps, coeff)
end


function Base.:(*)(
    sp::SumPrimitive{T},
    ap::AbstractPrimitive{T},
) where {T<:AbstractSystemTag}
    pps = Vector{ProductPrimitive{T}}()
    for pp in sp.pps
        push!(pps, pp * ap)
    end

    return SumPrimitive(pps)
end

function Base.:(*)(
    ap::AbstractPrimitive{T},
    sp::SumPrimitive{T},
) where {T<:AbstractSystemTag}
    pps = Vector{ProductPrimitive{T}}()
    for pp in sp.pps
        push!(pps, ap * pp)
    end

    return SumPrimitive(pps)
end

function Base.:(*)(
    sp1::SumPrimitive{T},
    sp2::SumPrimitive{T},
) where {T<:AbstractSystemTag}
    pps = Vector{ProductPrimitive{T}}()
    for pp1 in sp1.pps
        for pp2 in sp2.pps
            push!(pps, pp1 * pp2)
        end
    end

    return SumPrimitive(pps)
end

function Base.prod(
    aps::AbstractArray{<:AbstractPrimitive{T}},
) where {T<:AbstractSystemTag}
    isempty(aps) && throw(ArgumentError("Cannot take product of empty array"))
    return reduce(*, aps)
end

function Base.prod(
    aps::AbstractPrimitive{T}...,
) where {T<:AbstractSystemTag}
    isempty(aps) && throw(ArgumentError("Cannot take product of empty array"))
    return reduce(*, aps)
end

function Base.:(-)(ap::AbstractPrimitive{T}) where {T<:AbstractSystemTag}
    return (-1.0) * ap
end

function Base.:(-)(
    ap1::AbstractPrimitive{T},
    ap2::AbstractPrimitive{T},
) where {T<:AbstractSystemTag}
    return ap1 + (-ap2)
end

function Base.:(-)(
    c::Number,
    ap::AbstractPrimitive{T},
) where {T<:AbstractSystemTag}
    return c + (-ap)
end

function Base.:(-)(
    ap::AbstractPrimitive{T},
    c::Number,
) where {T<:AbstractSystemTag}
    return ap + (-c)
end

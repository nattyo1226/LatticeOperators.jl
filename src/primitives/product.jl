struct ProductPrimitive{T<:AbstractSystemTag} <: AbstractPrimitive{T}
    eps::Vector{ElementaryPrimitive{T}}
    coeff::ComplexF64
end

function ProductPrimitive(
    aps::AbstractVector{<:AbstractPrimitive{T}},
    coeff::Number=one(ComplexF64),
) where {T<:AbstractSystemTag}
    eps = Vector{ElementaryPrimitive{T}}()
    coeff = ComplexF64(coeff)

    for ap in aps
        if ap isa ElementaryPrimitive{T}
            push!(eps, ap)
        elseif ap isa ProductPrimitive{T}
            append!(eps, ap.eps)
            coeff *= ap.coeff
        else
            throw(ArgumentError("Cannot create ProductPrimitive from $(typeof(ap))"))
        end
    end

    return ProductPrimitive{T}(eps, coeff)
end

function ProductPrimitive(
    ao::ElementaryPrimitive{T},
    coeff::Number=one(ComplexF64),
) where {T<:AbstractSystemTag}
    return ProductPrimitive([ao], coeff)
end

function ProductPrimitive(aps::AbstractPrimitive{T}...) where {T<:AbstractSystemTag}
    return ProductPrimitive(collect(aps))
end

function Base.:(==)(pp1::ProductPrimitive{T}, pp2::ProductPrimitive{T}) where {T<:AbstractSystemTag}
    return pp1.eps == pp2.eps && pp1.coeff == pp2.coeff
end

function Base.hash(pp::ProductPrimitive, h::UInt)
    return hash((pp.eps, pp.coeff), h)
end

function Base.adjoint(pp::ProductPrimitive{T}) where {T<:AbstractSystemTag}
    eps_adj = Vector{AbstractPrimitive{T}}()
    for ep in reverse(pp.eps)
        push!(eps_adj, adjoint(ep))
    end
    coeff_adj = conj(pp.coeff)
    return ProductPrimitive(eps_adj, coeff_adj)
end

struct ProductedOperatorPrimitive{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T}
    prs::Vector{<:AbstractOperatorPrimitive{T}}
end

function Base.:(==)(pr1::ProductedOperatorPrimitive{T}, pr2::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return pr1.prs == pr2.prs
end

function Base.hash(pr::ProductedOperatorPrimitive{T}, h::UInt) where {T<:AbstractSystemTag}
    return hash(pr.prs, h)
end

function Base.adjoint(pr::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return ProductedOperatorPrimitive(adjoint.(reverse(pr.prs)))
end

function Base.show(io::IO, pr::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    @printf io "ProductedOperatorPrimitive{%s}([%s])" Val{T} join(string.(reverse(pr.prs)), ", ")
end

function Base.show(io::IO, ::MIME"text/plain", pr::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    @printf io "[ProductedOperatorPrimitive]\n"
    @printf io "%s" join(string.(reverse(pr.prs)), " * ")
end

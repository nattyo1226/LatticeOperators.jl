struct SummedOperatorPrimitive{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T}
    prs::Vector{<:AbstractOperatorPrimitive{T}}
end

function Base.:(==)(pr1::SummedOperatorPrimitive{T}, pr2::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return Set(pr1.prs) == Set(pr2.prs)
end

function Base.hash(pr::SummedOperatorPrimitive, h::UInt)
    return hash(Set(pr.prs), h)
end

function Base.adjoint(pr::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return SummedOperatorPrimitive(adjoint.(pr.prs))
end

function Base.show(io::IO, pr::SummedOperatorPrimitive)
    @printf io "SummedOperatorPrimitive([%s])" join(string.(pr.prs), ", ")
end

function Base.show(io::IO, ::MIME"text/plain", pr::SummedOperatorPrimitive)
    @printf io "[SummedOperatorPrimitive]\n"
    @printf io "%s" join(string.(pr.prs), " + ")
end

struct SummedOperatorPrimitive <: AbstractOperatorPrimitive
    prs::Vector{<:AbstractOperatorPrimitive}
end

function Base.:(==)(pr1::SummedOperatorPrimitive, pr2::SummedOperatorPrimitive)
    return Set(pr1.prs) == Set(pr2.prs)
end

function Base.hash(pr::SummedOperatorPrimitive, h::UInt)
    return hash(Set(pr.prs), h)
end

function Base.show(io::IO, pr::SummedOperatorPrimitive)
    @printf io "SummedOperatorPrimitive([%s])" join(string.(pr.prs), ", ")
end

function Base.show(io::IO, ::MIME"text/plain", pr::SummedOperatorPrimitive)
    @printf io "[SummedOperatorPrimitive]\n"
    @printf io "%s" join(string.(pr.prs), " + ")
end

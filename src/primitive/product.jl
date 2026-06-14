struct ProductedOperatorPrimitive <: AbstractOperatorPrimitive
    prs::Vector{<:AbstractOperatorPrimitive}
end

function Base.:(==)(pr1::ProductedOperatorPrimitive, pr2::ProductedOperatorPrimitive)
    return pr1.prs == pr2.prs
end

function Base.hash(pr::ProductedOperatorPrimitive, h::UInt)
    return hash(pr.prs, h)
end

function Base.show(io::IO, pr::ProductedOperatorPrimitive)
    @printf io "ProductedOperatorPrimitive([%s])" join(string.(reverse(pr.prs)), ", ")
end

function Base.show(io::IO, ::MIME"text/plain", pr::ProductedOperatorPrimitive)
    @printf io "[ProductedOperatorPrimitive]\n"
    @printf io "%s" join(string.(reverse(pr.prs)), " * ")
end

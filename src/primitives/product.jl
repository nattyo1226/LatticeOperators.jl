struct ProductedOperatorPrimitive{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T}
    prs::Vector{<:AbstractOperatorPrimitive{T}}
    coeff::Number

    function ProductedOperatorPrimitive(
        prs::AbstractVector{<:AbstractOperatorPrimitive{T}},
        coeff::Number=1.0,
    ) where {T<:AbstractSystemTag}
        coeff = coeff_type(T)(coeff)
        return new{T}(prs, coeff)
    end
end

function ProductedOperatorPrimitive(pr::AbstractOperatorPrimitive, coeff::Number=1.0)
    return ProductedOperatorPrimitive([pr], coeff)
end

function ProductedOperatorPrimitive(pr::ProductedOperatorPrimitive{T}, coeff::Number=1.0) where {T<:AbstractSystemTag}
    coeff = coeff_type(T)(coeff)
    return ProductedOperatorPrimitive(pr.prs, coeff * pr.coeff)
end

function ProductedOperatorPrimitive(prs::AbstractOperatorPrimitive{T}...) where {T<:AbstractSystemTag}
    prs_flat = Vector{AbstractOperatorPrimitive{T}}()
    coeff = one(coeff_type(T))

    for pr in prs
        if pr isa ProductedOperatorPrimitive{T}
            append!(prs_flat, pr.prs)
            coeff *= pr.coeff
        else
            push!(prs_flat, pr)
        end
    end

    return ProductedOperatorPrimitive(prs_flat, coeff)
end

function order_key(pr::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return (1, length(pr.prs), Tuple(Iterators.flatten(order_key.(pr.prs))))
end

function Base.:(==)(pr1::ProductedOperatorPrimitive{T}, pr2::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return pr1.prs == pr2.prs && pr1.coeff == pr2.coeff
end

function Base.hash(pr::ProductedOperatorPrimitive{T}, h::UInt) where {T<:AbstractSystemTag}
    return hash(pr.prs, h)
end

function Base.:(*)(c::Number, pr::AbstractOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    if pr isa ProductedOperatorPrimitive{T}
        coeff = coeff_type(T)(c) * pr.coeff
        return ProductedOperatorPrimitive(pr.prs, coeff)
    else
        coeff = coeff_type(T)(c)
        return ProductedOperatorPrimitive([pr], coeff)
    end
end

function Base.:(*)(pr1::AbstractOperatorPrimitive{T}, pr2::AbstractOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return ProductedOperatorPrimitive(pr1, pr2)
end

function Base.:(-)(pr::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return (-1.0) * pr
end

function Base.adjoint(pr::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    prs_adj = adjoint.(reverse(pr.prs))
    coeff_adj = conj(pr.coeff)
    return ProductedOperatorPrimitive(prs_adj, coeff_adj)
end

function Base.show(io::IO, pr::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    if coeff_type(T) <: Complex
        real_coeff = real(pr.coeff)
        imag_coeff = imag(pr.coeff)
        imag_coeff_sign = imag_coeff >= 0 ? "+" : "-"
        coeff_str = @sprintf "%g %s %gim" real_coeff imag_coeff_sign abs(imag_coeff)

        @printf io "(%s) %s" coeff_str join(string.(pr.prs), " ")
    else
        @printf io "(%g) %s" pr.coeff join(string.(pr.prs), " ")
    end
end

function Base.show(io::IO, ::MIME"text/plain", pr::ProductedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    @printf io "[ProductedOperatorPrimitive]\n"

    for pr in pr.prs
        @printf io "%s\n" string(pr)
    end

    if coeff_type(T) <: Complex
        real_coeff = real(pr.coeff)
        imag_coeff = imag(pr.coeff)
        imag_coeff_sign = imag_coeff >= 0 ? "+" : "-"
        coeff_str = @sprintf "%g %s %gim" real_coeff imag_coeff_sign abs(imag_coeff)

        @printf io "Coefficient: %s\n" coeff_str
    else
        @printf io "Coefficient: %g\n" pr.coeff
    end
end

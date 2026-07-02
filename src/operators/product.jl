function normalize_los(
    los::AbstractVector{<:LocalOperator{T,I}},
    coeff::Number,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    coeff_n = ComplexF64(coeff)
    for i in eachindex(los)
        for j in (i+1):length(los)
            if los[i] > los[j]
                if anticommutes(los[i], los[j])
                    coeff_n *= -1
                end
            end
        end
    end

    los_sorted = sort(los)
    los_reduced = Vector{LocalOperator{T,I}}()
    i = firstindex(los_sorted)
    while i <= lastindex(los_sorted)
        if i < lastindex(los_sorted) && isone_product(los_sorted[i], los_sorted[i+1])
            i += 2
        else
            push!(los_reduced, los_sorted[i])
            i += 1
        end
    end

    return los_reduced, coeff_n
end

struct ProductOperator{T<:AbstractSystemTag,I<:AbstractIndex{T}} <: AbstractOperator{T,I}
    los::Vector{LocalOperator{T,I}}
    coeff::ComplexF64

    function ProductOperator{T,I}(
        los::AbstractVector{<:LocalOperator{T,I}},
        coeff::Number=one(ComplexF64),
    ) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
        los_n, coeff_n = normalize_los(los, coeff)
        return new{T,I}(los_n, coeff_n)
    end
end

function ProductOperator(
    aos::AbstractArray{<:AbstractOperator{T,I}},
    coeff::Number=one(ComplexF64),
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    los = Vector{LocalOperator{T,I}}()
    coeff = ComplexF64(coeff)
    for ao in aos
        if ao isa LocalOperator{T,I}
            push!(los, ao)
        elseif ao isa ProductOperator{T,I}
            append!(los, ao.los)
            coeff *= ao.coeff
        elseif ao isa SumOperator{T,I}
            throw(ArgumentError("Cannot create ProductOperator from SumOperator"))
        else
            throw(ArgumentError("Unsupported operator type: $(typeof(ao))"))
        end
    end

    return ProductOperator{T,I}(los, coeff)
end

function ProductOperator(
    ao::AbstractOperator{T,I},
    coeff::Number=one(ComplexF64),
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return ProductOperator([ao], coeff)
end

function ProductOperator(aos::AbstractOperator{T,I}...) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return ProductOperator(collect(aos))
end

function ProductOperator(
    ids::AbstractVector{I},
    aps::AbstractVector{<:AbstractPrimitive{T}},
    coeff::Number=one(ComplexF64),
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    if length(ids) != length(aps)
        throw(ArgumentError("Length of ids and aps must be the same"))
    end

    los = Vector{LocalOperator{T,I}}()
    coeff = ComplexF64(coeff)

    for (id, ap) in zip(ids, aps)
        if ap isa ProductPrimitive{T}
            for ep in ap.eps
                if ep isa SumPrimitive{T}
                    throw(ArgumentError("Cannot create ProductOperator from SumPrimitive"))
                end
                lo = LocalOperator(id, ep)
                push!(los, lo)
            end
            coeff = coeff * ap.coeff
        elseif ap isa SumPrimitive{T}
            throw(ArgumentError("Cannot create ProductOperator from SumPrimitive"))
        else
            lo = LocalOperator(id, ap)
            push!(los, lo)
        end
    end

    return ProductOperator(los, coeff)
end

function ProductOperator(
    id::I,
    ap::P,
    coeff::Number=one(ComplexF64),
) where {T<:AbstractSystemTag,I<:AbstractIndex{T},P<:AbstractPrimitive{T}}
    return ProductOperator([id], [ap], coeff)
end

function local_operator(
    id::I,
    pp::ProductPrimitive{T},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return ProductOperator([id], [pp], 1.0)
end

function Base.:(==)(
    po1::ProductOperator{T,I},
    po2::ProductOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return po1.los == po2.los && po1.coeff == po2.coeff
end

function Base.hash(po::ProductOperator, h::UInt)
    return hash((po.los, po.coeff), h)
end

function Base.isless(po1::ProductOperator{T,I}, po2::ProductOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return length(po1.los) < length(po2.los) || (length(po1.los) == length(po2.los) && po1.los < po2.los)
end

function Base.adjoint(po::ProductOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    prs_adj = LocalOperator{T,I}[adjoint(lo) for lo in reverse(po.los)]
    coeff_adj = conj(po.coeff)
    return ProductOperator{T,I}(prs_adj, coeff_adj)
end

function Base.show(io::IO, po::ProductOperator{T}) where {T<:AbstractSystemTag}
    if !isone(po.coeff)
        if isreal(po.coeff)
            @printf io "(%g) " real(po.coeff)
        elseif iszero(real(po.coeff))
            @printf io "(%gim) " imag(po.coeff)
        else
            real_coeff = real(po.coeff)
            imag_coeff = imag(po.coeff)
            imag_coeff_sign = imag_coeff >= 0 ? "+" : "-"
            coeff_str = @sprintf "%g %s %gim" real_coeff imag_coeff_sign abs(imag_coeff)

            @printf io "(%s) " coeff_str
        end
    end

    if isempty(po.los)
        @printf io "I"
    else
        @printf io "%s" join(string.(po.los), " ")
    end
end

function Base.show(io::IO, ::MIME"text/plain", po::ProductOperator{T}) where {T<:AbstractSystemTag}
    @printf io "[ProductOperator]"

    @printf io "\nOperator Primitives:"
    if isempty(po.los)
        @printf io "  Identity"
    else
        for pr in po.los
            @printf io "\n  %s" string(pr)
        end
    end

    @printf io "\nCoefficient        : "
    if isreal(po.coeff)
        @printf io "%g" real(po.coeff)
    elseif iszero(real(po.coeff))
        @printf io "%gim" imag(po.coeff)
    else
        real_coeff = real(po.coeff)
        imag_coeff = imag(po.coeff)
        imag_coeff_sign = imag_coeff >= 0 ? "+" : "-"
        coeff_str = @sprintf "%g %s %gim" real_coeff imag_coeff_sign abs(imag_coeff)

        @printf io "%s" coeff_str
    end
end

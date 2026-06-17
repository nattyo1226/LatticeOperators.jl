function perm_parity(perm::AbstractArray{Int})
    n = length(perm)
    visited = falses(n)
    odd = false

    for i in 1:n
        visited[i] && continue

        len = 0
        j = i

        while !visited[j]
            visited[j] = true
            j = perm[j]
            len += 1
        end

        odd ⊻= iseven(len)
    end

    return odd ? -1 : 1
end

struct TensoredOperator{T<:AbstractSystemTag,I<:AbstractIndex{T}} <: AbstractOperator{T,I}
    prs::Vector{IndexedOperatorPrimitive{T,I}}
    coeff::Number

    function TensoredOperator(
        prs::AbstractVector{<:IndexedOperatorPrimitive{T,I}},
        coeff::Number=1.0,
    ) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
        coeff = coeff_type(T)(coeff)

        p = sortperm(prs, by=x->x.id)
        prs = prs[p]
        if T == FermionTag
            coeff *= perm_parity(p)
        end

        return new{T,I}(prs, coeff)
    end
end

function TensoredOperator(
    ids::AbstractVector{I},
    prs::AbstractVector{<:AbstractOperatorPrimitive{T}},
    coeff::Number=1.0,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    num_prs = length(ids)

    if num_prs != length(prs)
        throw(ArgumentError("Length of ids and prs must be the same"))
    end

    if ids != unique(ids)
        throw(ArgumentError("All ids must be distinct"))
    end

    prs_build = [IndexedOperatorPrimitive(ids[i], prs[i]) for i in 1:num_prs]

    return TensoredOperator(prs_build, coeff)
end

function TensoredOperator(
    id::I,
    pr::P,
    coeff::Number=1.0,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T},P<:AbstractOperatorPrimitive{T}}
    return TensoredOperator([id], [pr], coeff)
end

function Base.:(==)(
    op1::TensoredOperator{T,I},
    op2::TensoredOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return op1.prs == op2.prs && op1.coeff == op2.coeff
end

function Base.hash(op::TensoredOperator, h::UInt)
    return hash((op.prs, op.coeff), h)
end

function Base.isless(op1::TensoredOperator{T,I}, op2::TensoredOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    ids1 = ntuple(i -> op1.prs[i].id, length(op1.prs))
    ids2 = ntuple(i -> op2.prs[i].id, length(op2.prs))
    return ids1 < ids2
end

function Base.:(*)(c::Number, op::TensoredOperator{T}) where {T<:AbstractSystemTag}
    coeff = coeff_type(T)(c) * op.coeff
    return TensoredOperator(op.prs, coeff)
end

function Base.:(-)(op::TensoredOperator)
    return (-1.0) * op
end

function Base.adjoint(op::TensoredOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    prs_adj = reverse(op.prs)
    coeff_adj = conj(op.coeff)
    return TensoredOperator(prs_adj, coeff_adj)
end

function Base.show(io::IO, op::TensoredOperator{T}) where {T<:AbstractSystemTag}
    if coeff_type(T) <: Complex
        @printf io "TensoredOperator([%s], %g + %gim)" join(string.(op.prs), ", ") real(op.coeff) imag(op.coeff)
    else
        @printf io "TensoredOperator([%s], %g)" join(string.(op.prs), ", ") op.coeff
    end
end

function Base.show(io::IO, ::MIME"text/plain", op::TensoredOperator)
    @printf io "[TensoredOperator]\n"

    for pr in op.prs
        @printf io "%s\n" string(pr)
    end

    if !isapprox(op.coeff, 1.0)
        @printf io "Coefficient: %g" op.coeff
    end
end

function normalize(prs::AbstractVector{<:IndexedOperatorPrimitive{T,I}}, coeff::Number) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    inv_grade = 0
    for i in eachindex(prs)
        for j in (i+1):length(prs)
            if prs[i].id > prs[j].id
                inv_grade += majorana_grade(prs[i].pr) * majorana_grade(prs[j].pr)
            end
        end
    end
    sign = isodd(inv_grade) ? -1 : 1
    return sort(prs; by=x->x.id), sign * coeff
end

struct TensoredOperator{T<:AbstractSystemTag,I<:AbstractIndex{T}} <: AbstractOperator{T,I}
    prs::Vector{IndexedOperatorPrimitive{T,I}}
    coeff::Number

    function TensoredOperator(
        prs::AbstractVector{<:IndexedOperatorPrimitive{T,I}},
        coeff::Number=1.0,
    ) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
        coeff = coeff_type(T)(coeff)
        prs_n, coeff_n = normalize(prs, coeff)
        return new{T,I}(prs_n, coeff_n)
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
    prs1 = ntuple(i -> op1.prs[i].pr, length(op1.prs))
    prs2 = ntuple(i -> op2.prs[i].pr, length(op2.prs))
    ids1 = ntuple(i -> op1.prs[i].id, length(op1.prs))
    ids2 = ntuple(i -> op2.prs[i].id, length(op2.prs))
    return prs1 < prs2 || (prs1 == prs2 && ids1 < ids2)
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

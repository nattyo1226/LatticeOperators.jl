struct TensoredOperator <: AbstractOperator
    prs::Vector{IndexedOperatorPrimitive}
    coeff::Float64

    function TensoredOperator(prs::Vector{IndexedOperatorPrimitive}, coeff::Float64=1.0)
        prs_sorted = sort(prs, by=x->x.id)
        return new(prs_sorted, coeff)
    end
end

function TensoredOperator(
    ids::Vector{Int},
    prs::Vector{<:AbstractOperatorPrimitive},
    coeff::Float64=1.0,
)
    num_prs = length(ids)

    if num_prs != length(prs)
        throw(ArgumentError("Length of ids and prs must be the same"))
    end

    if ids != unique(ids)
        throw(ArgumentError("All ids must be distinct"))
    end

    prs_build = IndexedOperatorPrimitive[IndexedOperatorPrimitive(ids[i], prs[i]) for i in 1:num_prs]
    return TensoredOperator(prs_build, coeff)
end

function TensoredOperator(
    id::Int,
    pr::AbstractOperatorPrimitive,
    coeff::Float64=1.0,
)
    return TensoredOperator([id], [pr], coeff)
end

function coeff(op::TensoredOperator)
    return op.coeff
end

function Base.:(==)(
    op1::TensoredOperator,
    op2::TensoredOperator,
)
    return op1.prs == op2.prs && op1.coeff == op2.coeff
end

function Base.hash(op::TensoredOperator, h::UInt)
    return hash((op.prs, op.coeff), h)
end

function Base.show(io::IO, op::TensoredOperator)
    @printf io "TensoredOperator([%s], %g)" join(string.(op.prs), ", ") op.coeff
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

struct SummedOperator <: AbstractOperator
    ops::Vector{<:AbstractOperator}
    coeff::Float64

    function SummedOperator(ops::Vector{<:AbstractOperator}, coeff::Float64=1.0)
        return new(ops, coeff)
    end
end

function SummedOperator(ops::AbstractOperator...)
    return SummedOperator(collect(ops), 1.0)
end

function SummedOperator(op::AbstractOperator, coeff::Float64=1.0)
    return SummedOperator([op], coeff)
end

function coeff(op::SummedOperator)
    return op.coeff
end

function Base.:(==)(
    op1::SummedOperator,
    op2::SummedOperator,
)
    return Set(op1.ops) == Set(op2.ops) && op1.coeff == op2.coeff
end

function Base.hash(op::SummedOperator, h::UInt)
    return hash((Set(op.ops), op.coeff), h)
end

function Base.show(io::IO, op::SummedOperator)
    @printf io "SummedOperator([%s], %g)" join(string.(op.ops), ", ") op.coeff
end

function Base.show(io::IO, ::MIME"text/plain", op::SummedOperator)
    @printf io "[SummedOperator]\n"

    for op in op.ops
        @printf io "%s\n" string(op)
    end

    if !isapprox(op.coeff, 1.0)
        @printf io "Coefficient: %g" op.coeff
    end
end

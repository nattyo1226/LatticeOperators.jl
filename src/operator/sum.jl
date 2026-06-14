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
    ops = filter(op_sub -> coeff(op_sub) != 0, op.ops)
    @printf io "SummedOperator([%s], %f)" join(string.(ops), ", ") op.coeff
end

function Base.show(io::IO, ::MIME"text/plain", op::SummedOperator)
    ops = filter(op_sub -> coeff(op_sub) != 0, op.ops)
    num_ignored = length(op.ops) - length(ops)

    @printf io "[SummedOperator]\n"
    if op.coeff == 1.0
        @printf io "%s" join(string.(ops), " + ")
    else
        @printf io "%f * (%s)" op.coeff join(string.(ops), " + ")
    end
    if num_ignored > 0
        @printf io "(and %d more with zero coefficient)" num_ignored
    end
end

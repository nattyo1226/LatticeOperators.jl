abstract type AbstractOperatorPrimitive end

struct IndexedOperatorPrimitive
    id::Int
    pr::AbstractOperatorPrimitive
end

function Base.:(==)(
    op1::IndexedOperatorPrimitive,
    op2::IndexedOperatorPrimitive,
)
    return op1.id == op2.id && op1.pr == op2.pr
end

function Base.hash(op::IndexedOperatorPrimitive, h::UInt)
    return hash((op.id, op.pr), h)
end

function Base.show(io::IO, op::IndexedOperatorPrimitive)
    @printf io "%s%d" op.pr op.id
end

function Base.show(io::IO, ::MIME"text/plain", op::IndexedOperatorPrimitive)
    @printf io "[IndexedOperatorPrimitive]\n"
    @printf io "id: %d\n" op.id
    @printf io "primitive: %s\n" op.pr
end

abstract type AbstractOperator end

function coeff(::AbstractOperator)
    throw(ArgumentError("Coefficient not defined for this operator type"))
end

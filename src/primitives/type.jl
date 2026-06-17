abstract type AbstractOperatorPrimitive{T<:AbstractSystemTag} end

struct IndexedOperatorPrimitive{T<:AbstractSystemTag,I<:AbstractIndex{T},P<:AbstractOperatorPrimitive{T}}
    id::I
    pr::P
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
    @printf io "%s%s" op.pr op.id
end

function Base.show(io::IO, ::MIME"text/plain", op::IndexedOperatorPrimitive)
    @printf io "[IndexedOperatorPrimitive]\n"
    @printf io "id: %s\n" op.id
    @printf io "primitive: %s\n" op.pr
end

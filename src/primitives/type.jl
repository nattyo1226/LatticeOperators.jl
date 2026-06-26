"""
Abstract base type for all operator primitives.
"""
abstract type AbstractOperatorPrimitive{T<:AbstractSystemTag} end

"""
order_key(pr::AbstractOperatorPrimitive) -> Tuple
Returns a tuple that defines the ordering of operator primitives.
This is used for sorting and comparison of operator primitives.
"""
function order_key(pr::AbstractOperatorPrimitive)
    throw(ArgumentError("order_key is not defined for $(typeof(pr))"))
end

function Base.isless(pr1::AbstractOperatorPrimitive{T}, pr2::AbstractOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return order_key(pr1) < order_key(pr2)
end

"""
fermion_parity(pr::AbstractOperatorPrimitive) -> Int
Returns the fermion parity of the operator primitive.
"""
function fermion_parity(::AbstractOperatorPrimitive)
    return 0
end

"""
Indexed operator primitive.
"""
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

function Base.adjoint(op::IndexedOperatorPrimitive)
    return IndexedOperatorPrimitive(op.id, adjoint(op.pr))
end

function Base.show(io::IO, op::IndexedOperatorPrimitive)
    @printf io "%s%s" op.pr op.id
end

function Base.show(io::IO, ::MIME"text/plain", op::IndexedOperatorPrimitive)
    @printf io "[IndexedOperatorPrimitive]\n"
    @printf io "id: %s\n" op.id
    @printf io "primitive: %s\n" op.pr
end

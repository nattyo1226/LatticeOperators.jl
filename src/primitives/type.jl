"""
Abstract base type for all operator primitives.
"""
abstract type AbstractPrimitive{T<:AbstractSystemTag} end

"""
order_key(pr::AbstractPrimitive) -> Tuple
Returns a tuple that defines the ordering of operator primitives.
This is used for sorting and comparison of operator primitives.
"""
function order_key(pr::AbstractPrimitive)
    throw(ArgumentError("order_key is not defined for $(typeof(pr))"))
end

function Base.isless(pr1::AbstractPrimitive{T}, pr2::AbstractPrimitive{T}) where {T<:AbstractSystemTag}
    return order_key(pr1) < order_key(pr2)
end

"""
isone_product(pr::AbstractPrimitive{T}, pr::AbstractPrimitive{T}) where {T<:AbstractSystemTag} -> Bool
Returns true if the multiplication of the operator primitive with itself yields the identity operator.
"""
function isone_product(::AbstractPrimitive{T}, ::AbstractPrimitive{T}) where {T<:AbstractSystemTag}
    return false
end

"""
fermion_parity(pr::AbstractPrimitive) -> Int
Returns the fermion parity of the operator primitive.
"""
function fermion_parity(::AbstractPrimitive)
    return 0
end

abstract type ElementaryPrimitive{T<:AbstractSystemTag} <: AbstractPrimitive{T} end

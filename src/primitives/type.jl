"""
Abstract base type for all operator primitives.
"""
abstract type AbstractPrimitive{T<:AbstractSystemTag} end

"""
order_key(pr::AbstractPrimitive) -> Tuple
Returns a tuple that defines the ordering of operator primitives.
This is used for sorting and comparison of operator primitives.
"""
function _order_key(pr::AbstractPrimitive)
    throw(ArgumentError("order_key is not defined for $(typeof(pr))"))
end

function Base.isless(pr1::AbstractPrimitive{T}, pr2::AbstractPrimitive{T}) where {T<:AbstractSystemTag}
    return _order_key(pr1) < _order_key(pr2)
end

"""
isone_product(pr::AbstractPrimitive{T}, pr::AbstractPrimitive{T}) where {T<:AbstractSystemTag} -> Bool
Returns true if the multiplication of the operator primitive with itself yields the identity operator.
"""
function isone_product(
    ::AbstractPrimitive{T},
    ::AbstractPrimitive{T},
) where {T<:AbstractSystemTag}
    return false
end

"""
anticommutes(pr1::AbstractPrimitive{T}, pr2::AbstractPrimitive{T}) where {T<:AbstractSystemTag} -> Bool
Returns true if the two operator primitives anticommute with each other.
"""
function anticommutes(
    ::AbstractPrimitive{T},
    ::AbstractPrimitive{T},
) where {T<:AbstractSystemTag}
    return false
end

"""
isodd_fermion(pr::AbstractPrimitive{T}) where {T<:AbstractSystemTag} -> Bool
Returns true if the operator primitive represents an odd fermion operator.
"""
function isodd_fermion(::AbstractPrimitive{T}) where {T<:AbstractSystemTag}
    return false
end

abstract type ElementaryPrimitive{T<:AbstractSystemTag} <: AbstractPrimitive{T} end

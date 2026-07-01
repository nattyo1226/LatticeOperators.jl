"""
Identity operator primitive.
"""
struct Identity{T<:AbstractSystemTag} <: ElementaryPrimitive{T} end
order_key(::Identity) = (typemax(Int),)
isone_product(::Identity{T}, ::Identity{T}) where {T<:AbstractSystemTag} = true
Base.adjoint(::Identity{T}) where {T<:AbstractSystemTag} = Identity{T}()
Base.show(io::IO, ::Identity) = print(io, "I")

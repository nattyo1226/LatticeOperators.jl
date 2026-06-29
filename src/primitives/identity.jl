"""
Identity operator primitive.
"""
struct Identity{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T} end
order_key(::Identity) = (0, typemax(Int))
Base.adjoint(::Identity{T}) where {T<:AbstractSystemTag} = Identity{T}()
Base.show(io::IO, ::Identity) = print(io, "I")

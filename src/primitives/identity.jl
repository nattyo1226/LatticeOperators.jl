struct Identity{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T} end
order_key(::Identity) = 0
Base.show(io::IO, ::Identity) = print(io, "I")

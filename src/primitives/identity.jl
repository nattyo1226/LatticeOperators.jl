struct Identity{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T} end

Base.show(io::IO, ::Identity) = print(io, "I")

struct PauliX{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T} end
order_key(::PauliX) = 1
majorana_grade(::PauliX{FermionTag}) = 1
Base.show(io::IO, ::PauliX) = print(io, "X")

struct PauliY{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T} end
order_key(::PauliY) = 2
majorana_grade(::PauliY{FermionTag}) = 1
Base.show(io::IO, ::PauliY) = print(io, "Y")

struct PauliZ{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T} end
order_key(::PauliZ) = 3
Base.show(io::IO, ::PauliZ) = print(io, "Z")

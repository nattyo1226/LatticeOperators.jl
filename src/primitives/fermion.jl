struct Creation <: AbstractOperatorPrimitive{FermionTag} end
order_key(::Creation) = 1
fermion_parity(::Creation) = 1
Base.adjoint(::Creation) = Annihilation()
Base.show(io::IO, ::Creation) = print(io, "c†")

struct Annihilation <: AbstractOperatorPrimitive{FermionTag} end
order_key(::Annihilation) = 2
fermion_parity(::Annihilation) = 1
Base.adjoint(::Annihilation) = Creation()
Base.show(io::IO, ::Annihilation) = print(io, "c")

struct Occupation <: AbstractOperatorPrimitive{FermionTag} end
order_key(::Occupation) = 3
Base.adjoint(::Occupation) = Occupation()
Base.show(io::IO, ::Occupation) = print(io, "n")

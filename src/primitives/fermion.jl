"""
Fermion creation operator primitive.
"""
struct Creation <: AbstractOperatorPrimitive{FermionTag} end
order_key(::Creation) = (0, 1)
fermion_parity(::Creation) = 1
Base.adjoint(::Creation) = Annihilation()
Base.show(io::IO, ::Creation) = print(io, "c†")

"""
Fermion annihilation operator primitive.
"""
struct Annihilation <: AbstractOperatorPrimitive{FermionTag} end
order_key(::Annihilation) = (0, 2)
fermion_parity(::Annihilation) = 1
Base.adjoint(::Annihilation) = Creation()
Base.show(io::IO, ::Annihilation) = print(io, "c")

"""
Fermion occupation number operator primitive.
"""
struct Occupation <: AbstractOperatorPrimitive{FermionTag} end
order_key(::Occupation) = (0, 3)
Base.adjoint(::Occupation) = Occupation()
Base.show(io::IO, ::Occupation) = print(io, "n")


"""
Majorana X operator primitive.
"""
struct MajoranaX <: AbstractOperatorPrimitive{FermionTag} end
order_key(::MajoranaX) = (0, 1)
fermion_parity(::MajoranaX) = 1
Base.adjoint(::MajoranaX) = MajoranaX()
Base.show(io::IO, ::MajoranaX) = print(io, "X")

"""
Majorana Y operator primitive.
"""
struct MajoranaY <: AbstractOperatorPrimitive{FermionTag} end
order_key(::MajoranaY) = (0, 2)
fermion_parity(::MajoranaY) = 1
Base.adjoint(::MajoranaY) = MajoranaY()
Base.show(io::IO, ::MajoranaY) = print(io, "Y")

"""
Majorana Z operator primitive.
"""
struct MajoranaZ <: AbstractOperatorPrimitive{FermionTag} end
order_key(::MajoranaZ) = (0, 3)
Base.adjoint(::MajoranaZ) = MajoranaZ()
Base.show(io::IO, ::MajoranaZ) = print(io, "Z")

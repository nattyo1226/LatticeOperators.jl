"""
Majorana X operator primitive.
"""
struct MajoranaX <: ElementaryPrimitive{FermionTag} end
order_key(::MajoranaX) = (0,)
fermion_parity(::MajoranaX) = 1
isone_product(::MajoranaX, ::MajoranaX) = true
Base.adjoint(::MajoranaX) = MajoranaX()
Base.show(io::IO, ::MajoranaX) = print(io, "γ₁")

"""
Majorana Y operator primitive.
"""
struct MajoranaY <: ElementaryPrimitive{FermionTag} end
order_key(::MajoranaY) = (1,)
fermion_parity(::MajoranaY) = 1
isone_product(::MajoranaY, ::MajoranaY) = true
Base.adjoint(::MajoranaY) = MajoranaY()
Base.show(io::IO, ::MajoranaY) = print(io, "γ₂")

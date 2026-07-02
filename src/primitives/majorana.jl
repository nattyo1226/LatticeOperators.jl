"""
Majorana X operator primitive.
"""
struct MajoranaX <: ElementaryPrimitive{FermionTag} end
_order_key(::MajoranaX) = (0,)
Base.adjoint(::MajoranaX) = MajoranaX()
Base.show(io::IO, ::MajoranaX) = print(io, "γ₁")

"""
Majorana Y operator primitive.
"""
struct MajoranaY <: ElementaryPrimitive{FermionTag} end
_order_key(::MajoranaY) = (1,)
Base.adjoint(::MajoranaY) = MajoranaY()
Base.show(io::IO, ::MajoranaY) = print(io, "γ₂")

"""
Majorana Z operator primitive.
"""
struct MajoranaZ <: ElementaryPrimitive{FermionTag} end
_order_key(::MajoranaZ) = (2,)
Base.adjoint(::MajoranaZ) = MajoranaZ()
Base.show(io::IO, ::MajoranaZ) = print(io, "γ₃")

isone_product(::MajoranaX, ::MajoranaX) = true
isone_product(::MajoranaY, ::MajoranaY) = true
isone_product(::MajoranaZ, ::MajoranaZ) = true

anticommutes(::MajoranaX, ::MajoranaY) = true
anticommutes(::MajoranaY, ::MajoranaX) = true
anticommutes(::MajoranaY, ::MajoranaZ) = true
anticommutes(::MajoranaZ, ::MajoranaY) = true
anticommutes(::MajoranaZ, ::MajoranaX) = true
anticommutes(::MajoranaX, ::MajoranaZ) = true

struct MajoranaX <: AbstractOperatorPrimitive{FermionTag} end
Base.show(io::IO, ::MajoranaX) = print(io, "tX")

struct MajoranaY <: AbstractOperatorPrimitive{FermionTag} end
Base.show(io::IO, ::MajoranaY) = print(io, "tY")

struct MajoranaZ <: AbstractOperatorPrimitive{FermionTag} end
Base.show(io::IO, ::MajoranaZ) = print(io, "tZ")

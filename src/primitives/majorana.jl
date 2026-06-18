struct MajoranaX <: AbstractOperatorPrimitive{FermionTag} end
order_key(::MajoranaX) = 1
majorana_grade(::MajoranaX) = 1
Base.show(io::IO, ::MajoranaX) = print(io, "tX")

struct MajoranaY <: AbstractOperatorPrimitive{FermionTag} end
order_key(::MajoranaY) = 2
majorana_grade(::MajoranaY) = 1
Base.show(io::IO, ::MajoranaY) = print(io, "tY")

struct MajoranaZ <: AbstractOperatorPrimitive{FermionTag} end
order_key(::MajoranaZ) = 3
Base.show(io::IO, ::MajoranaZ) = print(io, "tZ")

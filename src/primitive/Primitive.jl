module Primitive

using Printf

using ..LatticeOperator: AbstractOperatorPrimitive

struct Identity <: AbstractOperatorPrimitive end
Base.show(io::IO, ::Identity) = print(io, "I")
export Identity

include("pauli.jl")
export PauliX, PauliY, PauliZ

include("sum.jl")
export SummedOperatorPrimitive

include("product.jl")
export ProductedOperatorPrimitive


end

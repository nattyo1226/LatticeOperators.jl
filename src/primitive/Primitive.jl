module Primitive

using ..LatticeOperator: AbstractOperatorPrimitive

struct Identity <: AbstractOperatorPrimitive end
export Identity

include("pauli.jl")
export PauliX, PauliY, PauliZ

end

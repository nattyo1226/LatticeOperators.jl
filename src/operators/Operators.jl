module Operators

using LatticeSpaces
using Printf

using ..Primitives: AbstractOperatorPrimitive, fermion_parity, IndexedOperatorPrimitive, SummedOperatorPrimitive, ProductedOperatorPrimitive

include("type.jl")
export AbstractOperator

include("tensor.jl")
export TensoredOperator

include("sum.jl")
export SummedOperator


end

module Families

using Random
using LatticeSpaces

using ..Primitives: AbstractPrimitive, Identity, PauliX, PauliY, PauliZ, MajoranaX, MajoranaY
using ..Operators: AbstractOperator, ProductOperator, SumOperator, local_operator

include("operator.jl")
export uniform_onsite, uniform_bond

include("hamiltonian.jl")
export tfi, xyz, cluster, hubbard, symmetric_hubbard

end

module Families

using Combinatorics
using Random
using LatticeSpaces

using ..Primitives: AbstractPrimitive, ElementaryPrimitive, majorana_parity, Identity, PauliX, PauliY, PauliZ, MajoranaX, MajoranaY, MajoranaZ
using ..Operators: AbstractOperator, LocalOperator, ProductOperator, SumOperator, local_operator

include("util.jl")
export default_eps, hermitian_phase, local_basis_operators
export nearest_neighbor_basis_operators

include("operator.jl")
export uniform_onsite, uniform_bond

include("hamiltonian.jl")
export tfi, xyz, cluster, hubbard, symmetric_hubbard

end

module LatticeOperators

using Printf

include("primitives/Primitives.jl")
using .Primitives
export AbstractPrimitive, isone_product, anticommutes, majorana_parity
export ElementaryPrimitive
export Identity
export PauliX, PauliY, PauliZ
export MajoranaX, MajoranaY, MajoranaZ
export ProductPrimitive, SumPrimitive

include("operators/Operators.jl")
using .Operators
export AbstractOperator
export LocalOperator, ProductOperator, SumOperator
export local_operator

include("families/Families.jl")
using .Families
export default_eps, hermitian_phase, local_basis_operators
export nearest_neighbor_basis_operators
export uniform_onsite, uniform_bond
export tfi, xyz, cluster, hubbard, symmetric_hubbard

end

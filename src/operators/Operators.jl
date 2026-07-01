module Operators

using LatticeSpaces
using Printf

using ..Primitives: AbstractPrimitive, isone_product, fermion_parity, ProductPrimitive, SumPrimitive

include("type.jl")
export AbstractOperator

include("local.jl")
export LocalOperator
export local_operator

include("product.jl")
export ProductOperator

include("sum.jl")
export SumOperator

include("operations.jl")

end

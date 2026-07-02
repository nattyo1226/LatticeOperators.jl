module Operators

using LatticeSpaces
using Printf

using ..Primitives: AbstractPrimitive, MajoranaZ, ProductPrimitive, SumPrimitive, isodd_fermion
import ..Primitives: isone_product, anticommutes

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

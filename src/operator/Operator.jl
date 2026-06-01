module Operator

using ..LatticeOperator: AbstractOperatorPrimitive, AbstractOperator

include("onsite.jl")
export OnsiteOperator, UniformOnsiteOperator

include("pair.jl")
export PairOperator, UniformPairOperator

include("summed.jl")
export SummedOperator


end

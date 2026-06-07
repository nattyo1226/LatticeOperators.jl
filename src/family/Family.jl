module Family

using Random
using LatticeGeometry

using ..Primitive: PauliX, PauliY, PauliZ
using ..Operator: OnsiteOperator, UniformOnsiteOperator, PairOperator, UniformPairOperator, SummedOperator


include("hamilaonian.jl")
export TFIHamiltonian, XYZHamiltonian

end

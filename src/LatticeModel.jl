module LatticeModel

include("operator/Operator.jl")
using .Operator
export AbstractOperator, Identity, PauliX, PauliY, PauliZ

include("term/Term.jl")
using .Term
export AbstractTerm, OnsiteTerm, PairTerm

include("model/Model.jl")
using .Model
export GenericModel, TFIModel, XYZModel

end

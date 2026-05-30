module Model

using ..Operator
using ..Term

include("type.jl")
export GenericModel

include("tfi.jl")
export TFIModel

include("xyz.jl")
export XYZModel

end

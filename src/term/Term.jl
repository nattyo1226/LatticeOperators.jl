module Term

using ..Operator

include("type.jl")
export AbstractTerm

include("onsite.jl")
export OnsiteTerm

include("pair.jl")
export PairTerm

end

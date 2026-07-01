"""
Primitives.jl is a module that defines various operator primitives used in lattice systems.
It includes abstract types, concrete operator primitives, and utility functions for handling these operators.
The module provides a structured way to represent and manipulate different types of operators in a lattice framework.
"""
module Primitives

using LatticeSpaces
using Printf

include("type.jl")
export AbstractPrimitive, isone_product, fermion_parity
export ElementaryPrimitive

include("identity.jl")
export Identity

include("pauli.jl")
export PauliX, PauliY, PauliZ

include("majorana.jl")
export MajoranaX, MajoranaY

include("product.jl")
export ProductPrimitive

include("sum.jl")
export SumPrimitive

include("operations.jl")

end

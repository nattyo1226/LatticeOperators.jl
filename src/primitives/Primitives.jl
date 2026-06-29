"""
Primitives.jl is a module that defines various operator primitives used in lattice systems.
It includes abstract types, concrete operator primitives, and utility functions for handling these operators.
The module provides a structured way to represent and manipulate different types of operators in a lattice framework.
"""
module Primitives

using LatticeSpaces
using Printf

include("type.jl")
export AbstractOperatorPrimitive, fermion_parity
export IndexedOperatorPrimitive

include("identity.jl")
export Identity

include("pauli.jl")
export PauliX, PauliY, PauliZ

include("fermion.jl")
export Creation, Annihilation, Occupation, MajoranaX, MajoranaY, MajoranaZ

include("sum.jl")
export SummedOperatorPrimitive

include("product.jl")
export ProductedOperatorPrimitive

end

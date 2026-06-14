struct PauliX <: AbstractOperatorPrimitive end
Base.show(io::IO, ::PauliX) = print(io, "X")

struct PauliY <: AbstractOperatorPrimitive end
Base.show(io::IO, ::PauliY) = print(io, "Y")

struct PauliZ <: AbstractOperatorPrimitive end
Base.show(io::IO, ::PauliZ) = print(io, "Z")

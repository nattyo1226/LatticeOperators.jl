struct PauliX <: AbstractOperatorPrimitive{SpinHalfTag} end
Base.show(io::IO, ::PauliX) = print(io, "X")

struct PauliY <: AbstractOperatorPrimitive{SpinHalfTag} end
Base.show(io::IO, ::PauliY) = print(io, "Y")

struct PauliZ <: AbstractOperatorPrimitive{SpinHalfTag} end
Base.show(io::IO, ::PauliZ) = print(io, "Z")

struct PauliX <: AbstractOperatorPrimitive{SpinHalfTag} end
order_key(::PauliX) = 1
Base.show(io::IO, ::PauliX) = print(io, "X")

struct PauliY <: AbstractOperatorPrimitive{SpinHalfTag} end
order_key(::PauliY) = 2
Base.show(io::IO, ::PauliY) = print(io, "Y")

struct PauliZ <: AbstractOperatorPrimitive{SpinHalfTag} end
order_key(::PauliZ) = 3
Base.show(io::IO, ::PauliZ) = print(io, "Z")

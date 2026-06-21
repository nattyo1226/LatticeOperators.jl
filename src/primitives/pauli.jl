struct PauliX <: AbstractOperatorPrimitive{SpinHalfTag} end
order_key(::PauliX) = 1
Base.adjoint(::PauliX) = PauliX()
Base.show(io::IO, ::PauliX) = print(io, "X")

struct PauliY <: AbstractOperatorPrimitive{SpinHalfTag} end
order_key(::PauliY) = 2
Base.adjoint(::PauliY) = PauliY()
Base.show(io::IO, ::PauliY) = print(io, "Y")

struct PauliZ <: AbstractOperatorPrimitive{SpinHalfTag} end
order_key(::PauliZ) = 3
Base.adjoint(::PauliZ) = PauliZ()
Base.show(io::IO, ::PauliZ) = print(io, "Z")

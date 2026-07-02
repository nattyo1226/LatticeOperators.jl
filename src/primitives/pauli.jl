"""
Pauli X operator primitive.
"""
struct PauliX <: ElementaryPrimitive{SpinHalfTag} end
_order_key(::PauliX) = (0,)
Base.adjoint(::PauliX) = PauliX()
Base.show(io::IO, ::PauliX) = print(io, "X")

"""
Pauli Y operator primitive.
"""
struct PauliY <: ElementaryPrimitive{SpinHalfTag} end
_order_key(::PauliY) = (1,)
Base.adjoint(::PauliY) = PauliY()
Base.show(io::IO, ::PauliY) = print(io, "Y")

"""
Pauli Z operator primitive.
"""
struct PauliZ <: ElementaryPrimitive{SpinHalfTag} end
_order_key(::PauliZ) = (2,)
Base.adjoint(::PauliZ) = PauliZ()
Base.show(io::IO, ::PauliZ) = print(io, "Z")

isone_product(::PauliX, ::PauliX) = true
isone_product(::PauliY, ::PauliY) = true
isone_product(::PauliZ, ::PauliZ) = true

anticommutes(::PauliX, ::PauliY) = true
anticommutes(::PauliY, ::PauliX) = true
anticommutes(::PauliY, ::PauliZ) = true
anticommutes(::PauliZ, ::PauliY) = true
anticommutes(::PauliZ, ::PauliX) = true
anticommutes(::PauliX, ::PauliZ) = true

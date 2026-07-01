"""
Pauli X operator primitive.
"""
struct PauliX <: ElementaryPrimitive{SpinHalfTag} end
order_key(::PauliX) = (0,)
isone_product(::PauliX, ::PauliX) = true
Base.adjoint(::PauliX) = PauliX()
Base.show(io::IO, ::PauliX) = print(io, "X")

"""
Pauli Y operator primitive.
"""
struct PauliY <: ElementaryPrimitive{SpinHalfTag} end
order_key(::PauliY) = (1,)
Base.adjoint(::PauliY) = PauliY()
isone_product(::PauliY, ::PauliY) = true
Base.show(io::IO, ::PauliY) = print(io, "Y")

"""
Pauli Z operator primitive.
"""
struct PauliZ <: ElementaryPrimitive{SpinHalfTag} end
order_key(::PauliZ) = (2,)
Base.adjoint(::PauliZ) = PauliZ()
isone_product(::PauliZ, ::PauliZ) = true
Base.show(io::IO, ::PauliZ) = print(io, "Z")

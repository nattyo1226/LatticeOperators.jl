function XYZModel(jx::T, jy::T, jz::T) where T<:Number
    return GenericModel{T}([
        PairTerm(PauliX(), PauliX(), -jx, 1),
        PairTerm(PauliY(), PauliY(), -jy, 1),
        PairTerm(PauliZ(), PauliZ(), -jz, 1),
    ])
end

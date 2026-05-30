function TFIModel(j::T, h::T) where T<:Number
    return GenericModel{T}([
        PairTerm(PauliZ(), PauliZ(), -j, 1),
        OnsiteTerm(PauliX(), -h),
    ])
end

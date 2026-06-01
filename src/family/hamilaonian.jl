function TFIHamiltonian(;
    j::Float64,
    h::Float64,
)
    return SummedOperator(
        UniformPairOperator(PauliZ(), j, 1),
        UniformOnsiteOperator(PauliX(), h),
    )
end

function XYZHamiltonian(;
    jx::Float64,
    jy::Float64,
    jz::Float64,
)
    return SummedOperator(
        UniformPairOperator(PauliX(), jx, 1),
        UniformPairOperator(PauliY(), jy, 1),
        UniformPairOperator(PauliZ(), jz, 1),
    )
end

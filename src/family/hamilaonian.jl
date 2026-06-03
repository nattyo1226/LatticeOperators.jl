function TFIHamiltonian(
    j::Float64,
    h::Float64,
)
    return SummedOperator(
        UniformPairOperator(PauliZ(), j, 1),
        UniformOnsiteOperator(PauliX(), h),
    )
end

function TFIHamiltonian(
    rng::AbstractRNG,
    lattice::Lattice,
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        error("upper_coeff must be positive.")
    end

    num_sites = num_sites(lattice)
    pairs = neighbor_pairs(lattice)
    num_neighbor_pairs = length(pairs)

    coeffs = (2.0 .* rand(rng, num_sites + num_neighbor_pairs) .- 1.0) .* upper_coeff

    onsite_ops = [OnsiteOperator(i, PauliX(), coeffs[i]) for i in 1:num_sites]
    neighbor_ops = [PairOperator(p, PauliZ(), coeffs[num_sites+i]) for (i, p) in enumerate(pairs)]

    return SummedOperator(onsite_ops..., neighbor_ops...)
end

function XYZHamiltonian(
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

function XYZHamiltonian(
    rng::AbstractRNG,
    lattice::Lattice,
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        error("upper_coeff must be positive.")
    end

    pairs = neighbor_pairs(lattice)
    num_neighbor_pairs = length(pairs) * 3 # X, Y, Z

    coeffs = (2.0 .* rand(rng, num_sites + num_neighbor_pairs) .- 1.0) .* upper_coeff

    neighbor_ops = [
        PairOperator(p1, p2, pr, coeffs[num_sites+i])
        for pr in (PauliX(), PauliY(), PauliZ())
        for (i, (p1, p2)) in enumerate(pairs)
    ]

    return SummedOperator(onsite_ops..., neighbor_ops...)
end

function TFIHamiltonian(
    j::Float64,
    h::Float64,
)
    return SummedOperator(
        UniformPairOperator(PauliZ, j, 1),
        UniformOnsiteOperator(PauliX, h),
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

    onsite_ops = [OnsiteOperator(PauliX, i, coeffs[i]) for i in 1:num_sites]
    neighbor_ops = [PairOperator(PauliZ, p, coeffs[num_sites+i]) for (i, p) in enumerate(pairs)]

    return SummedOperator(onsite_ops..., neighbor_ops...)
end

function XYZHamiltonian(
    jx::Float64,
    jy::Float64,
    jz::Float64,
)
    return SummedOperator(
        UniformPairOperator(PauliX, jx, 1),
        UniformPairOperator(PauliY, jy, 1),
        UniformPairOperator(PauliZ, jz, 1),
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
    num_neighbor_pairs_per_axis = length(pairs)
    num_neighbor_pairs = num_neighbor_pairs_per_axis * 3 # X, Y, Z

    coeffs = (2.0 .* rand(rng, num_sites + num_neighbor_pairs) .- 1.0) .* upper_coeff

    neighbor_ops = [
        PairOperator(PauliX, id1, id2, coeffs[num_sites+i])
        for (i, (id1, id2)) in enumerate(pairs)
    ]
    neighbor_ops = [
        PairOperator(PauliY, id1, id2, coeffs[num_sites+num_neighbor_pairs_per_axis+i])
        for (i, (id1, id2)) in enumerate(pairs)
    ]
    neighbor_ops = [
        PairOperator(PauliZ, id1, id2, coeffs[num_sites+2*num_neighbor_pairs_per_axis+i])
        for (i, (id1, id2)) in enumerate(pairs)
    ]

    return SummedOperator(onsite_ops..., neighbor_ops...)
end

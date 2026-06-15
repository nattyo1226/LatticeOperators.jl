function TFIHamiltonian(
    lattice::Lattice,
    j::Float64,
    h::Float64,
)
    shell = 1

    return SummedOperator(
        UniformTwoSiteOperator(lattice, PauliZ(), PauliZ(), shell, j),
        UniformOneSiteOperator(lattice, PauliX(), h),
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

    num_sites = nsites(lattice)
    pairs = neighbor_pairs(lattice)
    num_neighbor_pairs = length(pairs)

    coeffs = (2.0 .* rand(rng, num_sites + num_neighbor_pairs) .- 1.0) .* upper_coeff

    one_site_ops = [OneSiteOperator(i, PauliX(), coeffs[i]) for i in 1:num_sites]
    two_site_ops = [TwoSiteOperator(i, j, PauliZ(), PauliZ(), coeffs[num_sites+i]) for (i, j) in pairs]

    return SummedOperator(one_site_ops..., two_site_ops...)
end

function XYZHamiltonian(
    lattice::Lattice,
    jx::Float64,
    jy::Float64,
    jz::Float64,
)
    return SummedOperator(
        UniformTwoSiteOperator(lattice, PauliX(), PauliX(), 1, jx),
        UniformTwoSiteOperator(lattice, PauliY(), PauliY(), 1, jy),
        UniformTwoSiteOperator(lattice, PauliZ(), PauliZ(), 1, jz),
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
    num_neighbor_pairs = length(pairs)

    coeffs = (2.0 .* rand(rng, num_neighbor_pairs * 3) .- 1.0) .* upper_coeff

    two_site_ops_x = [
        TwoSiteOperator(id1, id2, PauliX(), PauliX(), coeffs[i])
        for (i, (id1, id2)) in enumerate(pairs)
    ]
    two_site_ops_y = [
        TwoSiteOperator(id1, id2, PauliY(), PauliY(), coeffs[num_neighbor_pairs+i])
        for (i, (id1, id2)) in enumerate(pairs)
    ]
    two_site_ops_z = [
        TwoSiteOperator(id1, id2, PauliZ(), PauliZ(), coeffs[2*num_neighbor_pairs+i])
        for (i, (id1, id2)) in enumerate(pairs)
    ]

    return SummedOperator(two_site_ops_x..., two_site_ops_y..., two_site_ops_z...)
end

function ClusterHamiltonian(lattice::Lattice, coeffs::Vector{Float64}=fill(1.0, nsites(lattice)))
    if !(lattice.geometry isa Hypercubic)
        println("Lattice geometry: ", typeof(lattice.geometry))
        throw(ArgumentError("ClusterHamiltonian requires a hypercubic lattice."))
    end

    if !all(lattice.periodic)
        throw(ArgumentError("ClusterHamiltonian requires a periodic lattice."))
    end

    num_sites = nsites(lattice)
    if num_sites != length(coeffs)
        throw(ArgumentError("Length of coeffs must match the number of sites in the lattice."))
    end

    ops = AbstractOperator[]

    for i in 1:num_sites
        ids_neighbor = neighbors(lattice, i)
        ids_neighbor = mod1.(ids_neighbor, num_sites)
        num_neighbors = length(ids_neighbor)

        push!(
            ops,
            TensoredOperator(
                [i; ids_neighbor],
                [PauliZ(); fill(PauliX(), num_neighbors)],
                coeffs[i],
            )
        )
    end

    return SummedOperator(ops...)
end

function ClusterHamiltonian(rng::AbstractRNG, lattice::Lattice, upper_coeff::Float64)
    num_sites = nsites(lattice)
    coeffs = (2.0 .* rand(rng, num_sites) .- 1.0) .* upper_coeff

    return ClusterHamiltonian(lattice, coeffs)
end

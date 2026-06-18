# Note: All coefficients are trearted with positive sign in each model.

function TFIHamiltonian(
    space::Space{SpinHalfTag},
    j::Float64,
    h::Float64,
)
    return SummedOperator(
        UniformOneSiteOperator(space, PauliX(), h),
        UniformTwoSiteOperator(space, PauliZ(), PauliZ(), j),
    )
end

function TFIHamiltonian(
    rng::AbstractRNG,
    space::Space,
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        error("upper_coeff must be positive.")
    end

    one_site_ops = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            OneSiteOperator(id, PauliX(), coeff)
        end
        for id in indices(space)
    ]
    two_site_ops = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            TwoSiteOperator(id1, id2, PauliZ(), PauliZ(), coeff)
        end
        for (id1, id2) in neighbor_pairs(space)
    ]

    return SummedOperator(one_site_ops..., two_site_ops...)
end

function XYZHamiltonian(
    space::Space,
    jx::Float64,
    jy::Float64,
    jz::Float64,
)
    return SummedOperator(
        UniformTwoSiteOperator(space, PauliX(), PauliX(), jx),
        UniformTwoSiteOperator(space, PauliY(), PauliY(), jy),
        UniformTwoSiteOperator(space, PauliZ(), PauliZ(), jz),
    )
end

function XYZHamiltonian(
    rng::AbstractRNG,
    space::Space,
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        error("upper_coeff must be positive.")
    end

    pairs = neighbor_pairs(space)

    two_site_ops_x = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            TwoSiteOperator(id1, id2, PauliX(), PauliX(), coeff)
        end
        for (id1, id2) in pairs
    ]
    two_site_ops_y = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            TwoSiteOperator(id1, id2, PauliY(), PauliY(), coeff)
        end
        for (id1, id2) in pairs
    ]
    two_site_ops_z = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            TwoSiteOperator(id1, id2, PauliZ(), PauliZ(), coeff)
        end
        for (id1, id2) in pairs
    ]

    return SummedOperator(two_site_ops_x..., two_site_ops_y..., two_site_ops_z...)
end

function ClusterHamiltonian(
    space::Space,
    coeffs::AbstractVector{Float64}=fill(1.0, length(indices(space))),
)
    if !(space.geometry isa Hypercubic)
        println("Space geometry: ", typeof(space.geometry))
        throw(ArgumentError("ClusterHamiltonian requires a hypercubic lattice."))
    end

    num_sites = nsites(space.geometry)
    if num_sites != length(coeffs)
        throw(ArgumentError("Length of coeffs must match the number of sites in the lattice."))
    end

    ops = []

    for (i, id) in enumerate(indices(space))
        ns = neighbors(space, id)
        num_neighbors = length(ns)

        push!(
            ops,
            TensoredOperator(
                [id; ns],
                [PauliZ(); fill(PauliX(), num_neighbors)],
                coeffs[i],
            )
        )
    end

    return SummedOperator(ops...)
end

function ClusterHamiltonian(
    rng::AbstractRNG,
    space::Space,
    upper_coeff::Float64,
)
    num_sites = length(indices(space))
    coeffs = (2.0 .* rand(rng, num_sites) .- 1.0) .* upper_coeff

    return ClusterHamiltonian(space, coeffs)
end

function HubbardHamiltonian(
    space::Space,
    t::Float64,
    u::Float64,
)
    hopping1 = SummedOperator([
        TensoredOperator(
            [id1, id2],
            [MajoranaX(), MajoranaY()],
            t * im / 2,
        )
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ])
    hopping2 = SummedOperator([
        TensoredOperator(
            [id1, id2],
            [MajoranaY(), MajoranaX()],
            -t * im / 2,
        )
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ])

    interaction1 = SummedOperator([
        TensoredOperator(
            indices_with_fixed_site(space, site),
            [MajoranaZ(), MajoranaZ()],
            u / 4,
        )
        for site in 1:nsites(space)
    ])
    interaction2 = SummedOperator([
        TensoredOperator(id, MajoranaZ(), u / 4)
        for labels in local_labels(space)
        for id in indices_with_fixed_labels(space, labels)
    ])
    return SummedOperator(
        hopping1,
        hopping2,
        interaction1,
        interaction2,
    )
end

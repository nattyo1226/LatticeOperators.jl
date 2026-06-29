function TFIHamiltonian(
    space::Space{SpinHalfTag},
    j::Float64,
    h::Float64,
)
    px = PauliX()
    pz = PauliZ()
    return SummedOperator(
        UniformOneSiteOperator(space, px, h),
        UniformTwoSiteOperator(space, pz, pz, j),
    )
end

function TFIHamiltonian(
    rng::AbstractRNG,
    space::Space{SpinHalfTag},
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        error("upper_coeff must be positive.")
    end

    px = PauliX()
    pz = PauliZ()

    one_site_ops = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            OneSiteOperator(id, px, coeff)
        end
        for id in indices(space)
    ]
    two_site_ops = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            TwoSiteOperator(id1, id2, pz, pz, coeff)
        end
        for (id1, id2) in neighbor_pairs(space)
    ]

    return SummedOperator(one_site_ops..., two_site_ops...)
end

function XYZHamiltonian(
    space::Space{SpinHalfTag},
    jx::Float64,
    jy::Float64,
    jz::Float64,
)
    px = PauliX()
    py = PauliY()
    pz = PauliZ()

    return SummedOperator(
        UniformTwoSiteOperator(space, px, px, jx),
        UniformTwoSiteOperator(space, py, py, jy),
        UniformTwoSiteOperator(space, pz, pz, jz),
    )
end

function XYZHamiltonian(
    rng::AbstractRNG,
    space::Space{SpinHalfTag},
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        error("upper_coeff must be positive.")
    end

    px = PauliX()
    py = PauliY()
    pz = PauliZ()

    pairs = neighbor_pairs(space)

    two_site_ops_x = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            TwoSiteOperator(id1, id2, px, px, coeff)
        end
        for (id1, id2) in pairs
    ]
    two_site_ops_y = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            TwoSiteOperator(id1, id2, py, py, coeff)
        end
        for (id1, id2) in pairs
    ]
    two_site_ops_z = [
        begin
            coeff = (2.0 * rand(rng) - 1.0) * upper_coeff
            TwoSiteOperator(id1, id2, pz, pz, coeff)
        end
        for (id1, id2) in pairs
    ]

    return SummedOperator(two_site_ops_x..., two_site_ops_y..., two_site_ops_z...)
end

function ClusterHamiltonian(
    space::Space{SpinHalfTag},
    coeffs::AbstractVector{Float64}=fill(1.0, length(indices(space))),
)
    if !(space.geometry isa Hypercubic)
        println("Space geometry: ", typeof(space.geometry))
        throw(ArgumentError("ClusterHamiltonian requires a hypercubic lattice."))
    end

    px = PauliX()
    pz = PauliZ()

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
                [pz; fill(px, num_neighbors)],
                coeffs[i],
            )
        )
    end

    return SummedOperator(ops...)
end

function ClusterHamiltonian(
    rng::AbstractRNG,
    space::Space{SpinHalfTag},
    upper_coeff::Float64,
)
    num_sites = length(indices(space))
    coeffs = (2.0 .* rand(rng, num_sites) .- 1.0) .* upper_coeff

    return ClusterHamiltonian(space, coeffs)
end

function HubbardHamiltonian(
    space::Space{FermionTag},
    t::Float64,
    u::Float64,
)
    mx = MajoranaX()
    my = MajoranaY()
    oc = 0.5 * (Identity{FermionTag}() - MajoranaZ())

    hopping1 = SummedOperator([
        TensoredOperator(
            [id1, id2],
            [mx, my],
            0.5 * im * t,
        )
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ])
    hopping2 = SummedOperator([
        TensoredOperator(
            [id1, id2],
            [my, mx],
            -0.5 * im * t,
        )
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ])

    interaction = SummedOperator([
        TensoredOperator(
            indices_with_fixed_site(space, site),
            [oc, oc],
            u,
        )
        for site in 1:nsites(space)
    ])

    return SummedOperator(
        hopping1,
        hopping2,
        interaction,
    )
end

function SymmetricHubbardHamiltonian(
    space::Space{FermionTag},
    t::Float64,
    u::Float64,
)
    mx = MajoranaX()
    my = MajoranaY()
    mz = MajoranaZ()

    hopping1 = SummedOperator([
        TensoredOperator(
            [id1, id2],
            [mx, my],
            0.5 * im * t,
        )
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ])
    hopping2 = SummedOperator([
        TensoredOperator(
            [id1, id2],
            [my, mx],
            -0.5 * im * t,
        )
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ])

    interaction = SummedOperator([
        TensoredOperator(
            indices_with_fixed_site(space, site),
            [mz, mz],
            u,
        )
        for site in 1:nsites(space)
    ])

    return SummedOperator(
        hopping1,
        hopping2,
        interaction,
    )
end

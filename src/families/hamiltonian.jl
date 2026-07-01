function tfi(
    space::Space{SpinHalfTag},
    j::Float64,
    h::Float64,
)
    px = PauliX()
    pz = PauliZ()
    return SumOperator(
        uniform_onsite(space, px, -h),
        uniform_bond(space, pz, pz, -j),
    )
end

function tfi(
    rng::AbstractRNG,
    space::Space{SpinHalfTag},
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        throw(ArgumentError("upper_coeff must be positive."))
    end

    px = PauliX()
    pz = PauliZ()

    one_site_ops = [
        begin
            coeff = (2.0 * rand(rng, Float64) - 1.0) * upper_coeff
            lo = local_operator(id, px)
            coeff * lo
        end
        for id in indices(space)
    ]
    two_site_ops = [
        begin
            coeff = (2.0 * rand(rng, Float64) - 1.0) * upper_coeff
            lo1 = local_operator(id1, pz)
            lo2 = local_operator(id2, pz)
            coeff * lo1 * lo2
        end
        for (id1, id2) in neighbor_pairs(space)
    ]

    return SumOperator(one_site_ops..., two_site_ops...)
end

function xyz(
    space::Space{SpinHalfTag},
    jx::Float64,
    jy::Float64,
    jz::Float64,
)
    px = PauliX()
    py = PauliY()
    pz = PauliZ()

    return SumOperator(
        uniform_bond(space, px, px, -jx),
        uniform_bond(space, py, py, -jy),
        uniform_bond(space, pz, pz, -jz),
    )
end

function xyz(
    rng::AbstractRNG,
    space::Space{SpinHalfTag},
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        throw(ArgumentError("upper_coeff must be positive."))
    end

    px = PauliX()
    py = PauliY()
    pz = PauliZ()

    pairs = neighbor_pairs(space)

    ops = [
        begin
            coeff = (2.0 * rand(rng, Float64) - 1.0) * upper_coeff
            lo1 = local_operator(id1, ep)
            lo2 = local_operator(id2, ep)
            lo1 * lo2 * coeff
        end
        for (id1, id2) in pairs
        for ep in (px, py, pz)
    ]

    return SumOperator(ops...)
end

function cluster(
    space::Space{SpinHalfTag},
    coeffs::AbstractVector{Float64}=fill(1.0, length(indices(space))),
)
    if !(space.geometry isa Hypercubic)
        println("Space geometry: ", typeof(space.geometry))
        throw(ArgumentError("cluster requires a hypercubic lattice."))
    end

    px = PauliX()
    pz = PauliZ()

    num_sites = nsites(space.geometry)
    if num_sites != length(coeffs)
        throw(ArgumentError("Length of coeffs must match the number of sites in the lattice."))
    end

    ops = [
        begin
            ns = neighbors(space, id)
            num_neighbors = length(ns)
            ProductOperator(
                [id; ns],
                [pz; fill(px, num_neighbors)],
                -coeffs[i],
            )
        end
        for (i, id) in enumerate(indices(space))
    ]

    return SumOperator(ops...)
end

function cluster(
    rng::AbstractRNG,
    space::Space{SpinHalfTag},
    upper_coeff::Float64,
)
    if upper_coeff <= 0
        throw(ArgumentError("upper_coeff must be positive."))
    end

    num_sites = length(indices(space))
    coeffs = (2.0 .* rand(rng, num_sites) .- 1.0) .* upper_coeff

    return cluster(space, coeffs)
end

function hubbard(
    space::Space{FermionTag},
    t::Float64,
    u::Float64,
)
    mx = MajoranaX()
    my = MajoranaY()
    mz = -im * mx * my
    oc = 0.5 * (1.0 - mz)

    hopping = [
        begin
            lo1 = local_operator(id1, mx)
            lo2 = local_operator(id2, my)
            lo3 = local_operator(id1, my)
            lo4 = local_operator(id2, mx)
            coeff = -0.5im * t
            coeff * (lo1 * lo2 - lo3 * lo4)
        end
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ]

    interaction = [
        begin
            coeff = u
            id1, id2 = indices_with_fixed_site(space, site)
            lo1 = local_operator(id1, oc)
            lo2 = local_operator(id2, oc)
            coeff * (lo1 * lo2)
        end
        for site in 1:nsites(space)
    ]

    return SumOperator(
        hopping...,
        interaction...,
    )
end

function symmetric_hubbard(
    space::Space{FermionTag},
    t::Float64,
    u::Float64,
)
    mx = MajoranaX()
    my = MajoranaY()
    mz = -im * mx * my

    hopping = [
        begin
            lo1 = local_operator(id1, mx)
            lo2 = local_operator(id2, my)
            lo3 = local_operator(id1, my)
            lo4 = local_operator(id2, mx)
            coeff = -0.5im * t
            coeff * (lo1 * lo2 - lo3 * lo4)
        end
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ]

    interaction = [
        begin
            coeff = 0.25 * u
            id1, id2 = indices_with_fixed_site(space, site)
            lo1 = local_operator(id1, mz)
            lo2 = local_operator(id2, mz)
            coeff * (lo1 * lo2)
        end
        for site in 1:nsites(space)
    ]

    return SumOperator(
        hopping...,
        interaction...,
    )
end

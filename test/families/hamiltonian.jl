function test_tfi_1()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    j = 2.0
    h = 3.0

    expected = SumOperator(
        uniform_onsite(space, PauliX(), -h),
        uniform_bond(space, PauliZ(), PauliZ(), -j),
    )

    @test tfi(space, j, h) == expected
end

function test_tfi_2()
    rng1 = MersenneTwister(816)
    rng2 = MersenneTwister(816)

    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))
    upper_coeff = 2.0

    @test tfi(rng1, space, upper_coeff) == tfi(rng2, space, upper_coeff)
    @test_throws ArgumentError tfi(MersenneTwister(1131), space, 0.0)
    @test_throws ArgumentError tfi(MersenneTwister(1131), space, -1.0)
end

function test_xyz_1()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    jx = 1.0
    jy = 2.0
    jz = 3.0

    expected = SumOperator(
        uniform_bond(space, PauliX(), PauliX(), -jx),
        uniform_bond(space, PauliY(), PauliY(), -jy),
        uniform_bond(space, PauliZ(), PauliZ(), -jz),
    )

    @test xyz(space, jx, jy, jz) == expected
end

function test_xyz_2()
    rng1 = MersenneTwister(816)
    rng2 = MersenneTwister(816)

    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))
    upper_coeff = 2.0

    @test xyz(rng1, space, upper_coeff) == xyz(rng2, space, upper_coeff)
    @test_throws ArgumentError xyz(MersenneTwister(1131), space, 0.0)
    @test_throws ArgumentError xyz(MersenneTwister(1131), space, -1.0)
end

function test_cluster_1()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    coeffs = fill(1.0, length(indices(space)))
    expected = [
        begin
            ns = neighbors(space, id)
            ProductOperator(
                [id; ns],
                [PauliZ(); fill(PauliX(), length(ns))],
                -coeffs[i],
            )
        end
        for (i, id) in enumerate(indices(space))
    ]

    @test cluster(space) == SumOperator(expected...)
end

function test_cluster_2()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    coeffs = collect(1.0:length(indices(space)))
    expected = [
        begin
            ns = neighbors(space, id)
            ProductOperator(
                [id; ns],
                [PauliZ(); fill(PauliX(), length(ns))],
                -coeffs[i],
            )
        end
        for (i, id) in enumerate(indices(space))
    ]

    @test cluster(space, coeffs) == SumOperator(expected...)
end

function test_cluster_3()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    @test_throws ArgumentError cluster(space, [1.0, 2.0])

    rng1 = MersenneTwister(816)
    rng2 = MersenneTwister(816)

    @test cluster(rng1, space, 2.0) == cluster(rng2, space, 2.0)
end

function test_hubbard_1()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))

    t = 1.0
    u = 2.0

    H = hubbard(space, t, u)

    @test H isa SumOperator
    @test !isempty(H.pos)
    @test adjoint(H) == H
end

function test_hubbard_2()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))

    t = 1.0
    u = 0.0

    H = hubbard(space, t, u)

    mx = MajoranaX()
    my = MajoranaY()

    expected = [
        begin
            lo1 = local_operator(id1, mx)
            lo2 = local_operator(id2, my)
            lo3 = local_operator(id1, my)
            lo4 = local_operator(id2, mx)

            (-0.5im * t) * (lo1 * lo2 - lo3 * lo4)
        end
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ]

    @test H == SumOperator(expected...)
end

function test_hubbard_3()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))

    t = 0.0
    u = 2.0

    H = hubbard(space, t, u)

    mx = MajoranaX()
    my = MajoranaY()
    mz = -im * mx * my
    oc = 0.5 * (1.0 - mz)

    expected = [
        begin
            id1, id2 = indices_with_fixed_site(space, site)
            lo1 = local_operator(id1, oc)
            lo2 = local_operator(id2, oc)

            u * lo1 * lo2
        end
        for site in 1:nsites(space)
    ]

    @test H == SumOperator(expected...)
end

function test_hubbard_4()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))

    @test hubbard(space, 0.0, 0.0) == SumOperator{FermionTag,index_type(space)}(ProductOperator{FermionTag,index_type(space)}[])
end

function test_symmetric_hubbard_1()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))

    t = 1.0
    u = 2.0

    H = symmetric_hubbard(space, t, u)

    @test H isa SumOperator
    @test !isempty(H.pos)
    @test adjoint(H) == H
end

function test_symmetric_hubbard_2()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))

    t = 1.0
    u = 0.0

    H = symmetric_hubbard(space, t, u)

    mx = MajoranaX()
    my = MajoranaY()

    expected = [
        begin
            lo1 = local_operator(id1, mx)
            lo2 = local_operator(id2, my)
            lo3 = local_operator(id1, my)
            lo4 = local_operator(id2, mx)

            (-0.5im * t) * (lo1 * lo2 - lo3 * lo4)
        end
        for (id1, id2) in neighbor_pairs_with_same_labels(space)
    ]

    @test H == SumOperator(expected...)
end

function test_symmetric_hubbard_3()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))

    t = 0.0
    u = 2.0

    H = symmetric_hubbard(space, t, u)

    mx = MajoranaX()
    my = MajoranaY()
    mz = -im * mx * my

    expected = [
        begin
            id1, id2 = indices_with_fixed_site(space, site)
            lo1 = local_operator(id1, mz)
            lo2 = local_operator(id2, mz)

            (0.25 * u) * lo1 * lo2
        end
        for site in 1:nsites(space)
    ]

    @test H == SumOperator(expected...)
end

function test_symmetric_hubbard_4()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))

    H1 = hubbard(space, 1.0, 0.0)
    H2 = symmetric_hubbard(space, 1.0, 0.0)

    @test H1 == H2
end

@testset "tfi" begin
    test_tfi_1()
    test_tfi_2()
end

@testset "xyz" begin
    test_xyz_1()
    test_xyz_2()
end

@testset "cluster" begin
    test_cluster_1()
    test_cluster_2()
    test_cluster_3()
end

@testset "hubbard" begin
    test_hubbard_1()
    test_hubbard_2()
    test_hubbard_3()
    test_hubbard_4()
end

@testset "symmetric_hubbard" begin
    test_symmetric_hubbard_1()
    test_symmetric_hubbard_2()
    test_symmetric_hubbard_3()
    test_symmetric_hubbard_4()
end

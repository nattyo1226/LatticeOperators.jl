function test_uo_1()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    xs = [
        local_operator(id, PauliX())
        for id in indices(space)
    ]

    @test uniform_onsite(space, PauliX()) == SumOperator(xs...)
    @test uniform_onsite(space, PauliX(), 2.0) == SumOperator((2.0 .* xs)...)
end

function test_uo_2()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    pr = prod(PauliX(), PauliZ())

    expected = [
        local_operator(id, pr)
        for id in indices(space)
    ]

    @test uniform_onsite(space, pr) == SumOperator(expected...)
    @test uniform_onsite(space, pr, 3.0) == SumOperator((3.0 .* expected)...)
end

function test_ub_1()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    expected = [
        local_operator(i, PauliX()) * local_operator(j, PauliX())
        for (i, j) in neighbor_pairs(space)
    ]

    @test uniform_bond(space, PauliX()) == SumOperator(expected...)

    expected_xz = [
        2.0 * local_operator(i, PauliX()) * local_operator(j, PauliZ())
        for (i, j) in neighbor_pairs(space)
    ]

    @test uniform_bond(space, PauliX(), PauliZ(), 2.0) == SumOperator(expected_xz...)
end

function test_ub_2()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    pr1 = prod(PauliX(), PauliZ())
    pr2 = PauliY()

    expected = [
        local_operator(i, pr1) * local_operator(j, pr2)
        for (i, j) in neighbor_pairs(space)
    ]

    @test uniform_bond(space, pr1, pr2) == SumOperator(expected...)
    @test uniform_bond(space, pr1, pr2, 2.0) == SumOperator((2.0 .* expected)...)
end

function test_ub_3()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    pr1 = PauliY()
    pr2 = prod(PauliX(), PauliZ())

    expected = [
        local_operator(i, pr1) * local_operator(j, pr2)
        for (i, j) in neighbor_pairs(space)
    ]

    @test uniform_bond(space, pr1, pr2) == SumOperator(expected...)
    @test uniform_bond(space, pr1, pr2, 2.0) == SumOperator((2.0 .* expected)...)
end

function test_ub_4()
    space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))

    pr1 = prod(PauliX(), PauliZ())
    pr2 = prod(PauliY(), PauliZ())

    expected = [
        local_operator(i, pr1) * local_operator(j, pr2)
        for (i, j) in neighbor_pairs(space)
    ]

    @test uniform_bond(space, pr1, pr2) == SumOperator(expected...)

    expected_same = [
        local_operator(i, pr1) * local_operator(j, pr1)
        for (i, j) in neighbor_pairs(space)
    ]

    @test uniform_bond(space, pr1) == SumOperator(expected_same...)
end

@testset "uniform_onsite" begin
    test_uo_1()
    test_uo_2()
end

@testset "uniform_bond" begin
    test_ub_1()
    test_ub_2()
    test_ub_3()
    test_ub_4()
end

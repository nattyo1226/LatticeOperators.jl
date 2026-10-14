function test_default_eps()
    @test default_eps(SpinHalfTag) == (PauliX(), PauliY(), PauliZ())
    @test default_eps(FermionTag) == (MajoranaX(), MajoranaY(), MajoranaZ())
end

function test_hermitian_phase()
    @test hermitian_phase([PauliX(), PauliY()]) == 1.0 + 0.0im

    @test hermitian_phase([MajoranaX()]) == 1.0 + 0.0im
    @test hermitian_phase([MajoranaZ()]) == 1.0 + 0.0im

    @test hermitian_phase([MajoranaX(), MajoranaY()]) == 0.0 + 1.0im
    @test hermitian_phase([MajoranaX(), MajoranaZ()]) == 1.0 + 0.0im
    @test hermitian_phase([MajoranaY(), MajoranaZ()]) == 1.0 + 0.0im

    @test hermitian_phase([MajoranaX(), MajoranaY(), MajoranaZ()]) == 0.0 + 1.0im
end

function test_local_basis_operators_1()
    space = Space(SpinHalfSpace(), Hypercubic(2, OpenBoundary))
    ids = collect(indices(space))

    ops1 = local_basis_operators(ids, 1)
    ops2 = local_basis_operators(ids, 2)

    @test length(ops1) == binomial(length(ids), 1) * 3
    @test length(ops2) == binomial(length(ids), 2) * 3^2

    @test all(op -> op isa ProductOperator{SpinHalfTag}, ops1)
    @test all(op -> op isa ProductOperator{SpinHalfTag}, ops2)

    @test all(op -> adjoint(op) == op, ops1)
    @test all(op -> adjoint(op) == op, ops2)
end

function test_local_basis_operators_2()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))
    ids = collect(indices(space))

    ops1 = local_basis_operators(ids, 1)
    ops2 = local_basis_operators(ids, 2)

    @test length(ops1) == binomial(length(ids), 1) * 3
    @test length(ops2) == binomial(length(ids), 2) * 3^2

    @test all(op -> op isa ProductOperator{FermionTag}, ops1)
    @test all(op -> op isa ProductOperator{FermionTag}, ops2)

    @test all(op -> adjoint(op) == op, ops1)
    @test all(op -> adjoint(op) == op, ops2)
end

function test_local_basis_operators_3()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))
    ids = collect(indices(space))

    ops = local_basis_operators(ids, 2; only_same_site=true)

    @test length(ops) == 2 * 1 * 3^2
    @test all(op -> adjoint(op) == op, ops)
end

function test_local_basis_operators_4()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))
    ids = collect(indices(space))

    ops = local_basis_operators(ids, 0; only_same_site=false)

    @test length(ops) == 1
    @test all(op -> adjoint(op) == op, ops)
end

@testset "utility" begin
    test_default_eps()
    test_hermitian_phase()
    test_local_basis_operators_1()
    test_local_basis_operators_2()
    test_local_basis_operators_3()
    test_local_basis_operators_4()
end

@testset "nearest_neighbor_basis_operators" begin
    @testset "open spin chain" begin
        space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))
        ops = nearest_neighbor_basis_operators(space)
        eps = (PauliX(), PauliY(), PauliZ())
        expected = ProductOperator{SpinHalfTag,index_type(space)}[]
        for (s1, s2) in ((1, 2), (2, 3), (3, 4))
            for pr2 in eps, pr1 in eps
                push!(expected,
                    local_operator(SiteIndex(SpinHalfTag, s1), pr1) *
                    local_operator(SiteIndex(SpinHalfTag, s2), pr2))
            end
        end

        @test length(ops) == 27
        @test all(op -> length(op.los) == 2, ops)
        @test ops == expected
        @test ops isa Vector{ProductOperator{SpinHalfTag,index_type(space)}}
        @test all(op -> adjoint(op) == op, ops)
    end

    @testset "periodic spin chains" begin
        space = Space(SpinHalfSpace(), Hypercubic(4, PeriodicBoundary))
        ops = nearest_neighbor_basis_operators(space)
        seam = local_operator(SiteIndex(SpinHalfTag, 1), PauliX()) *
               local_operator(SiteIndex(SpinHalfTag, 4), PauliZ())
        @test length(ops) == 36
        @test seam in ops
        @test length(unique(ops)) == length(ops)

        space2 = Space(SpinHalfSpace(), Hypercubic(2, PeriodicBoundary))
        ops2 = nearest_neighbor_basis_operators(space2)
        ids2 = collect(indices(space2))
        @test length(ops2) == 9
        @test length(unique(ops2)) == 9
        @test ops2 == local_basis_operators(ids2, 2)
    end

    @testset "spinful fermions" begin
        space = Space(SpinfulFermionSpace(), Hypercubic(3, OpenBoundary))
        ops = nearest_neighbor_basis_operators(space)
        eps = (MajoranaX(), MajoranaY(), MajoranaZ())
        expected = ProductOperator{FermionTag,index_type(space)}[]
        for (s1, s2) in ((1, 2), (2, 3))
            for spin1 in (Up, Down), spin2 in (Up, Down)
                for pr2 in eps, pr1 in eps
                    phase = majorana_parity(pr1) == 1 && majorana_parity(pr2) == 1 ? 1im : 1
                    push!(expected,
                        phase * local_operator(SiteSpinIndex(s1, spin1), pr1) *
                        local_operator(SiteSpinIndex(s2, spin2), pr2))
                end
            end
        end

        @test length(ops) == 72
        @test all(op -> length(op.los) == 2, ops)
        @test ops == expected
        @test ops isa Vector{ProductOperator{FermionTag,index_type(space)}}
        @test all(op -> adjoint(op) == op, ops)
        @test all(op -> site(op.los[1].id) != site(op.los[2].id), ops)
    end

    @testset "one site and custom primitives" begin
        for local_space in (SpinHalfSpace(), SpinfulFermionSpace())
            for boundary in (OpenBoundary, PeriodicBoundary)
                space = Space(local_space, Hypercubic(1, boundary))
                ops = nearest_neighbor_basis_operators(space)
                @test isempty(ops)
                @test typeof(ops) == typeof(local_basis_operators(collect(indices(space)), 1))
            end
        end

        space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))
        eps = (PauliX(), PauliZ())
        ops = nearest_neighbor_basis_operators(space; eps)
        ids = collect(indices(space))
        expected = ProductOperator{SpinHalfTag,index_type(space)}[]
        for s in 1:3
            append!(expected, local_basis_operators(ids[s:s+1], 2; eps))
        end
        @test length(ops) == 12
        @test ops == expected
        empty_ops = nearest_neighbor_basis_operators(space; eps=())
        @test isempty(empty_ops)
        @test empty_ops isa Vector{ProductOperator{SpinHalfTag,index_type(space)}}
    end

    @testset "other geometries" begin
        space = Space(SpinHalfSpace(), AllToAll(4))
        ids = collect(indices(space))
        @test nearest_neighbor_basis_operators(space) == local_basis_operators(ids, 2)

        space2d = Space(SpinHalfSpace(), Hypercubic((2, 2), OpenBoundary))
        ops2d = nearest_neighbor_basis_operators(space2d)
        @test length(ops2d) == 36
        @test length(unique(ops2d)) == 36
    end
end

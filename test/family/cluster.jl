function test_cluster()
    lattice = Lattice(
        Hypercubic(4),
        PeriodicBoundary(),
    )

    model = ClusterHamiltonian(lattice)
    ops = model.ops
    @test length(ops) == 4
    @test ops[1] == TensoredOperator([1, 2, 4], [PauliZ(), PauliX(), PauliX()], 1.0)
    @test ops[2] == TensoredOperator([2, 1, 3], [PauliZ(), PauliX(), PauliX()], 1.0)
    @test ops[3] == TensoredOperator([3, 2, 4], [PauliZ(), PauliX(), PauliX()], 1.0)
    @test ops[4] == TensoredOperator([4, 1, 3], [PauliZ(), PauliX(), PauliX()], 1.0)
end

@testset "ClusterHamiltonian" begin
    test_cluster()
end

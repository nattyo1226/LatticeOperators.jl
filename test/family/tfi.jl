function test_tfi()
    j = -1.0
    h = -2.0
    lattice = Lattice(
        AllToAll(4),
        OpenBoundary(),
    )

    model = TFIHamiltonian(lattice, j, h)
    ops = model.ops
    @test length(ops) == 2
    @test ops[1] == UniformTwositeOperator(lattice, PauliZ(), PauliZ(), 1, j)
    @test ops[2] == UniformOnesiteOperator(lattice, PauliX(), h)
end

@testset "TFIHamiltonian" begin
    test_tfi()
end

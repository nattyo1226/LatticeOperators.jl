function test_xyz()
    jx = -3.0
    jy = -1.0
    jz = +1.0
    lattice = Lattice(
        AllToAll(4),
        OpenBoundary(),
    )

    model = XYZHamiltonian(lattice, jx, jy, jz)
    ops = model.ops
    @test length(ops) == 3
    @test ops[1] == UniformTwoSiteOperator(lattice, PauliX(), PauliX(), 1, jx)
    @test ops[2] == UniformTwoSiteOperator(lattice, PauliY(), PauliY(), 1, jy)
    @test ops[3] == UniformTwoSiteOperator(lattice, PauliZ(), PauliZ(), 1, jz)
end

@testset "XYZHamiltonian" begin
    test_xyz()
end

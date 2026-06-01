function test_xyz()
    model = XYZHamiltonian(jx=1.0, jy=0.5, jz=0.25)
    ops = model.ops
    @test length(ops) == 3
    @test ops[1] == UniformPairOperator(PauliX(), 1.0, 1)
    @test ops[2] == UniformPairOperator(PauliY(), 0.5, 1)
    @test ops[3] == UniformPairOperator(PauliZ(), 0.25, 1)
end

@testset "XYZHamiltonian" begin
    test_xyz()
end

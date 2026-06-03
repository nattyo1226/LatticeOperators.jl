function test_xyz()
    jx = -3.0
    jy = -1.0
    jz = +1.0


    model = XYZHamiltonian(jx, jy, jz)
    ops = model.ops
    @test length(ops) == 3
    @test ops[1] == UniformPairOperator(PauliX(), jx, 1)
    @test ops[2] == UniformPairOperator(PauliY(), jy, 1)
    @test ops[3] == UniformPairOperator(PauliZ(), jz, 1)
end

@testset "XYZHamiltonian" begin
    test_xyz()
end

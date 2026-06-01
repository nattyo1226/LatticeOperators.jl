function test_tfi()
    model = TFIHamiltonian(j=-1.0, h=-2.0)
    ops = model.ops
    @test length(ops) == 2
    @test ops[1] == UniformPairOperator(PauliZ(), -1.0, 1)
    @test ops[2] == UniformOnsiteOperator(PauliX(), -2.0)
end

@testset "TFIHamiltonian" begin
    test_tfi()
end

function test_tfi()
    j = -1.0
    h = -2.0

    model = TFIHamiltonian(j, h)
    ops = model.ops
    @test length(ops) == 2
    @test ops[1] == UniformPairOperator(PauliZ(), j, 1)
    @test ops[2] == UniformOnsiteOperator(PauliX(), h)
end

@testset "TFIHamiltonian" begin
    test_tfi()
end

function test_tfi()
    model = TFIModel(1.0, 0.5)
    @test length(model.terms) == 2
    @test model.terms[1] == PairTerm(PauliZ(), PauliZ(), -1.0, 1)
    @test model.terms[2] == OnsiteTerm(PauliX(), -0.5)
end

@testset "TFIModel" begin
    test_tfi()
end

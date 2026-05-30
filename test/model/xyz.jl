function test_xyz()
    model = XYZModel(1.0, 0.5, 0.25)
    @test length(model.terms) == 3
    @test model.terms[1] == PairTerm(PauliX(), PauliX(), -1.0, 1)
    @test model.terms[2] == PairTerm(PauliY(), PauliY(), -0.5, 1)
    @test model.terms[3] == PairTerm(PauliZ(), PauliZ(), -0.25, 1)
end

@testset "XYZModel" begin
    test_xyz()
end

function test_summed_operator_primitive()
    pr1 = PauliX()
    pr2 = PauliY()
    pr = SummedOperatorPrimitive([pr1, pr2])

    @test length(pr.prs) == 2
    @test pr.prs[1] == pr1
    @test pr.prs[2] == pr2
end

@testset "SummedOperatorPrimitive" begin
    test_summed_operator_primitive()
end

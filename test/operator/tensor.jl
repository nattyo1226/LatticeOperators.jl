function test_tensored_operator()
    T = SpinHalfTag
    pr1 = IndexedOperatorPrimitive(SiteIndex{T}(1), PauliX())
    pr2 = IndexedOperatorPrimitive(SiteIndex{T}(2), PauliY())
    op = TensoredOperator([pr1, pr2], 0.5)

    @test op.coeff == 0.5
    @test length(op.prs) == 2
    @test op.prs[1] == pr1
    @test op.prs[2] == pr2
end

@testset "TensoredOperator" begin
    test_tensored_operator()
end

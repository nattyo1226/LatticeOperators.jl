function test_tensored_operator_1()
    T = SpinHalfTag
    pr1 = IndexedOperatorPrimitive(SiteIndex{T}(1), PauliX())
    pr2 = IndexedOperatorPrimitive(SiteIndex{T}(2), PauliY())
    op = TensoredOperator([pr1, pr2], 0.5)

    @test op.coeff == 0.5
    @test length(op.prs) == 2
    @test op.prs[1] == pr1
    @test op.prs[2] == pr2

    @test op' == op
end

function test_tensored_operator_2()
    pr1 = IndexedOperatorPrimitive(SiteSpinIndex(1, Up), MajoranaX())
    pr2 = IndexedOperatorPrimitive(SiteSpinIndex(2, Down), MajoranaY())
    pr3 = IndexedOperatorPrimitive(SiteSpinIndex(3, Down), MajoranaY())
    coeff = 1.0 + 0.5im
    op = TensoredOperator([pr1, pr2, pr3], coeff)

    @test op.coeff == coeff
    @test length(op.prs) == 3
    @test op.prs[1] == pr1
    @test op.prs[2] == pr2
    @test op.prs[3] == pr3

    @test op' == TensoredOperator([pr1, pr2, pr3], -conj(coeff))
end

@testset "TensoredOperator" begin
    test_tensored_operator_1()
    test_tensored_operator_2()
end

function test_sum()
    T = SpinHalfTag
    op1 = TensoredOperator(SiteIndex{T}(1), PauliX())
    op2 = TensoredOperator(SiteIndex{T}(2), PauliY())
    op3 = TensoredOperator(SiteIndex{T}(3), PauliZ())
    op = SummedOperator(op1, op2, op3)

    @test length(op.ops) == 3
end

@testset "SummedOperator" begin
    test_sum()
end

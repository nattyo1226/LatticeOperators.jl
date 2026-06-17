function test_sum()
    T = SpinHalfTag
    op1 = TensoredOperator(SiteIndex{T}(1), PauliX())
    op2 = TensoredOperator(SiteIndex{T}(2), PauliY())
    op3 = TensoredOperator(SiteIndex{T}(3), PauliZ())
    sum_op = SummedOperator([op1, op2, op3])

    @test length(sum_op.ops) == 3
    @test sum_op.ops[1] == op1
    @test sum_op.ops[2] == op2
    @test sum_op.ops[3] == op3
end

@testset "SummedOperator" begin
    test_sum()
end

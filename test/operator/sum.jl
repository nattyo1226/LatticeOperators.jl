function test_sum_1()
    T = SpinHalfTag
    op1 = TensoredOperator(SiteIndex{T}(1), PauliX())
    op2 = TensoredOperator(SiteIndex{T}(2), PauliY())
    op3 = TensoredOperator(SiteIndex{T}(3), PauliZ())
    op = SummedOperator(op1, op2, op3)

    @test length(op.ops) == 3
    @test op.ops[1] == op1
    @test op.ops[2] == op2
    @test op.ops[3] == op3

    @test op' == op
end

function test_sum_2()
    op1 = TensoredOperator([SiteSpinIndex(1, Up), SiteSpinIndex(1, Down)], [MajoranaX(), MajoranaY()])
    op2 = TensoredOperator([SiteSpinIndex(1, Up), SiteSpinIndex(2, Down)], [MajoranaY(), MajoranaZ()])
    op3 = TensoredOperator([SiteSpinIndex(2, Up), SiteSpinIndex(2, Down)], [MajoranaZ(), MajoranaX()])
    op = SummedOperator(op1, op2, op3)

    @test length(op.ops) == 3
    @test Set(op.ops) == Set([op1, op2, op3])

    @test op' == SummedOperator(op1', op2', op3')
end

@testset "SummedOperator" begin
    test_sum_1()
    test_sum_2()
end

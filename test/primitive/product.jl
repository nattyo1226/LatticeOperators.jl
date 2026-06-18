function test_producted_operator_primitive()
    T = SpinHalfTag
    pr1 = PauliX{T}()
    pr2 = PauliY{T}()
    pr = ProductedOperatorPrimitive([pr1, pr2])

    @test length(pr.prs) == 2
    @test pr.prs[1] == pr1
    @test pr.prs[2] == pr2
end

@testset "ProductedOperatorPrimitive" begin
    test_producted_operator_primitive()
end

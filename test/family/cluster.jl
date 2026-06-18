function test_cluster()
    space = Space(
        SpinHalfSpace(),
        Hypercubic((2, 2), OpenBoundary(2)),
    )

    model = ClusterHamiltonian(space)
    @test model' == model

    ops = model.ops
    @test length(ops) == 4
end

@testset "ClusterHamiltonian" begin
    test_cluster()
end

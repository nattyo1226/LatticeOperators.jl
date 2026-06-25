function test_hubbard()
    t = 1.0
    u = 2.0
    space = Space(
        SpinfulFermionSpace(),
        Hypercubic(2, OpenBoundary),
    )

    model = HubbardHamiltonian(space, t, u)
    @test model' == model

    ops = model.ops
    @test length(ops) == 6
end

@testset "HubbardHamiltonian" begin
    test_hubbard()
end

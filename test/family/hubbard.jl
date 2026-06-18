function test_hubbard()
    t = -1.0
    u = 2.0
    space = Space(
        SpinfulFermionSpace(),
        Hypercubic(
            (2, 2),
            OpenBoundary(2),
        ),
    )

    model = HubbardHamiltonian(space, t, u)
    display(model)
    @test model' == model

    ops = model.ops
    @test length(ops) == 28
end

@testset "HubbardHamiltonian" begin
    test_hubbard()
end

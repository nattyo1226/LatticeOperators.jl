function test_tfi()
    j = -1.0
    h = -2.0
    space = Space(
        SpinHalfSpace(),
        Hypercubic(
            (2, 2),
            OpenBoundary(2),
        ),
    )

    model = TFIHamiltonian(space, j, h)
    ops = model.ops
    @test length(ops) == 8
end

@testset "TFIHamiltonian" begin
    test_tfi()
end

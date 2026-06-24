function test_xyz()
    jx = -3.0
    jy = -1.0
    jz = +1.0
    space = Space(
        SpinHalfSpace(),
        Hypercubic((2, 2), OpenBoundary),
        FullSector{SpinHalfTag}(),
    )

    model = XYZHamiltonian(space, jx, jy, jz)
    @test model' == model

    ops = model.ops
    @test length(ops) == 12
end

@testset "XYZHamiltonian" begin
    test_xyz()
end

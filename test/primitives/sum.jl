function test_sp_1()
    x = PauliX()
    z = PauliZ()

    sp = x + z

    @test sp isa SumPrimitive{SpinHalfTag}
    @test sp == SumPrimitive(ProductPrimitive(x), ProductPrimitive(z))
end

function test_sp_2()
    x = PauliX()
    y = PauliY()
    z = PauliZ()

    sp1 = x + y
    sp2 = z + x

    @test sp1 + z == SumPrimitive(ProductPrimitive(x), ProductPrimitive(y), ProductPrimitive(z))
    @test x + sp2 == SumPrimitive(ProductPrimitive(x), ProductPrimitive(z), ProductPrimitive(x))
    @test sp1 + sp2 == SumPrimitive(
        ProductPrimitive(x),
        ProductPrimitive(y),
        ProductPrimitive(z),
        ProductPrimitive(x),
    )
end

function test_sp_3()
    x = PauliX()
    z = PauliZ()

    sp = x + z

    @test 2.0 * sp == SumPrimitive(ProductPrimitive(x, 2.0), ProductPrimitive(z, 2.0))
    @test sp * 2.0 == SumPrimitive(ProductPrimitive(x, 2.0), ProductPrimitive(z, 2.0))
    @test -sp == SumPrimitive(ProductPrimitive(x, -1.0), ProductPrimitive(z, -1.0))
end

function test_sp_4()
    x = PauliX()
    y = PauliY()
    z = PauliZ()

    @test (x + y) * z == SumPrimitive(
        ProductPrimitive([x, z]),
        ProductPrimitive([y, z]),
    )

    @test z * (x + y) == SumPrimitive(
        ProductPrimitive([z, x]),
        ProductPrimitive([z, y]),
    )
end

function test_sp_5()
    x = PauliX()
    y = PauliY()
    z = PauliZ()

    @test (x + y) * (y + z) == SumPrimitive(
        ProductPrimitive([x, y]),
        ProductPrimitive([x, z]),
        ProductPrimitive([y, y]),
        ProductPrimitive([y, z]),
    )
end

function test_sp_6()
    x = PauliX()
    y = PauliY()

    sp = ProductPrimitive([x], 2 + im) + ProductPrimitive([y], 3 - im)

    @test adjoint(sp) == SumPrimitive(
        adjoint(ProductPrimitive([x], 2 + im)),
        adjoint(ProductPrimitive([y], 3 - im)),
    )
end

function test_sp_7()
    x = PauliX()
    y = PauliY()
    z = PauliZ()

    @test sum([x, y, z]) == SumPrimitive(ProductPrimitive(x), ProductPrimitive(y), ProductPrimitive(z))
    @test sum(x, y, z) == SumPrimitive(ProductPrimitive(x), ProductPrimitive(y), ProductPrimitive(z))

    @test prod([x, y, z]) == ProductPrimitive([x, y, z])
    @test prod(x, y, z) == ProductPrimitive([x, y, z])
end

@testset "SumPrimitive" begin
    test_sp_1()
    test_sp_2()
    test_sp_3()
    test_sp_4()
    test_sp_5()
    test_sp_6()
    test_sp_7()
end

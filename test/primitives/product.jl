function test_pp_1()
    x = PauliX()
    z = PauliZ()

    pp = x * z

    @test pp isa ProductPrimitive{SpinHalfTag}
    @test pp == ProductPrimitive([x, z])
end

function test_pp_2()
    x = PauliX()
    z = PauliZ()

    pp = 2.0 * x * z

    @test pp == ProductPrimitive([x, z], 2.0)
end

function test_pp_3()
    x = PauliX()
    y = PauliY()
    z = PauliZ()

    pp1 = ProductPrimitive([x, y], 2.0)
    pp2 = ProductPrimitive([z], 3.0)

    @test pp1 * pp2 == ProductPrimitive([x, y, z], 6.0)
    @test x * pp2 == ProductPrimitive([x, z], 3.0)
    @test pp1 * z == ProductPrimitive([x, y, z], 2.0)
end

function test_pp_4()
    x = PauliX()
    y = PauliY()

    pp = ProductPrimitive([x, y], 2 + 3im)

    @test adjoint(pp) == ProductPrimitive([adjoint(y), adjoint(x)], 2 - 3im)
end

function test_pp_5()
    x = PauliX()

    @test -x == ProductPrimitive([x], -1.0)
    @test x - x == SumPrimitive(ProductPrimitive([x]), ProductPrimitive([x], -1.0))
end

@testset "ProductPrimitive" begin
    test_pp_1()
    test_pp_2()
    test_pp_3()
    test_pp_4()
    test_pp_5()
end

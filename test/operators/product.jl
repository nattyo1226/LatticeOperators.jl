function test_po_1()
    i = SiteIndex{SpinHalfTag}(1)
    xi = LocalOperator(i, PauliX())

    @test ProductOperator(xi) == ProductOperator([xi])
    @test ProductOperator([xi], 2) == 2 * xi
end

function test_po_2()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    @test ProductOperator([xj, xi]) == ProductOperator([xi, xj])
end

function test_po_3()
    i = SiteIndex{SpinHalfTag}(1)
    xi = LocalOperator(i, PauliX())

    po = ProductOperator([xi], 2)

    @test 3 * po == ProductOperator([xi], 6)
    @test po * 3 == ProductOperator([xi], 6)
    @test -po == ProductOperator([xi], -2)
end

function test_po_4()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    pxi = ProductOperator([xi], 2)
    pxj = ProductOperator([xj], 3)

    @test pxi * pxj == ProductOperator([xi, xj], 6)
    @test pxi * xj == ProductOperator([xi, xj], 2)
    @test xj * pxi == ProductOperator([xi, xj], 2)
end

function test_po_5()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    @test adjoint(ProductOperator([xi, xj], 2 + 3im)) == ProductOperator([adjoint(xj), adjoint(xi)], 2 - 3im)
end

function test_po_6()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    @test ProductOperator([xi], 2) == ProductOperator([xi], 2)
    @test hash(ProductOperator([xi], 2)) == hash(ProductOperator([xi], 2))
    @test ProductOperator([xi]) < ProductOperator([xi, xj])
end

@testset "ProductOperator" begin
    test_po_1()
    test_po_2()
    test_po_3()
    test_po_4()
    test_po_5()
    test_po_6()
end

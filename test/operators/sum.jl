function test_so_1()
    i = SiteIndex{SpinHalfTag}(1)
    xi = LocalOperator(i, PauliX())

    pxi = ProductOperator([xi])

    @test SumOperator(pxi) == SumOperator([pxi])
    @test SumOperator(pxi, SumOperator(pxi)) == SumOperator(ProductOperator([xi], 2))
end

function test_so_2()
    i = SiteIndex{SpinHalfTag}(1)
    xi = LocalOperator(i, PauliX())

    p1 = ProductOperator([xi], 1)
    p2 = ProductOperator([xi], 2)

    @test SumOperator(p1, p2) == SumOperator(ProductOperator([xi], 3))
end

function test_so_3()
    i = SiteIndex{SpinHalfTag}(1)
    xi = LocalOperator(i, PauliX())

    p1 = ProductOperator([xi], 1)
    p2 = ProductOperator([xi], -1)

    @test isempty(SumOperator(p1, p2).pos)
end

function test_so_4()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    pxi = ProductOperator([xi])
    pxj = ProductOperator([xj])

    @test xi + xj == SumOperator(pxi, pxj)
    @test xi + pxj == SumOperator(pxi, pxj)
    @test pxi + xj == SumOperator(pxi, pxj)
    @test pxi + pxj == SumOperator(pxi, pxj)
end

function test_so_5()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    pxi = ProductOperator([xi])
    pxj = ProductOperator([xj])

    @test xi - xj == SumOperator(pxi, -pxj)
    @test pxi - pxj == SumOperator(pxi, -pxj)
    @test SumOperator(pxi, pxj) - pxi == SumOperator(pxj)
end

function test_so_6()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    pxi = ProductOperator([xi])
    pxj = ProductOperator([xj])
    so = SumOperator(pxi, pxj)

    @test 2 * so == SumOperator(2 * pxi, 2 * pxj)
    @test so * 2 == SumOperator(2 * pxi, 2 * pxj)
    @test -so == SumOperator(-pxi, -pxj)
end

function test_so_7()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)
    k = SiteIndex{SpinHalfTag}(3)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())
    xk = LocalOperator(k, PauliX())

    pxi = ProductOperator([xi])
    pxj = ProductOperator([xj])
    pxk = ProductOperator([xk])

    so = SumOperator(pxi, pxj)

    @test so * pxk == SumOperator(pxi * pxk, pxj * pxk)
    @test pxk * so == SumOperator(pxk * pxi, pxk * pxj)
end

function test_so_8()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    pxi = ProductOperator([xi])
    pxj = ProductOperator([xj])

    so1 = SumOperator(pxi, pxj)
    so2 = SumOperator(pxi, pxj)

    @test so1 * so2 == SumOperator(
        pxi * pxi,
        pxi * pxj,
        pxj * pxi,
        pxj * pxj,
    )
end

function test_so_9()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    pxi = ProductOperator([xi], 2 + im)
    pxj = ProductOperator([xj], 3 - im)

    so = SumOperator(pxi, pxj)

    @test adjoint(so) == SumOperator(adjoint(pxi), adjoint(pxj))
end

function test_so_10()
    i = SiteIndex{SpinHalfTag}(1)
    j = SiteIndex{SpinHalfTag}(2)

    xi = LocalOperator(i, PauliX())
    xj = LocalOperator(j, PauliX())

    pxi = ProductOperator([xi])
    pxj = ProductOperator([xj])

    @test SumOperator(pxi, pxj) == SumOperator(pxj, pxi)
    @test hash(SumOperator(pxi, pxj)) == hash(SumOperator(pxj, pxi))
    @test SumOperator(pxi) < SumOperator(pxi, pxj)
end

@testset "SummedOperator" begin
    test_so_1()
    test_so_2()
    test_so_3()
    test_so_4()
    test_so_5()
    test_so_6()
    test_so_7()
    test_so_8()
    test_so_9()
    test_so_10()
end

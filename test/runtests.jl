using LatticeOperator
using Test

@testset "LatticeOperator.jl" begin
    include("model/tfi.jl")
    include("model/xyz.jl")
end

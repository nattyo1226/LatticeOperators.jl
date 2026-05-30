using LatticeModel
using Test

@testset "LatticeModel.jl" begin
    include("model/tfi.jl")
    include("model/xyz.jl")
end

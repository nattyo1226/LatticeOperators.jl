function OneSiteOperator(
    id::Int,
    pr::AbstractOperatorPrimitive,
    coeff::Float64=1.0,
)
    return TensoredOperator(id, pr, coeff)
end

function UniformOneSiteOperator(
    lattice::Lattice,
    pr::AbstractOperatorPrimitive,
    coeff::Float64=1.0,
)
    num_sites = nsites(lattice)
    ops = [OneSiteOperator(i, pr, coeff) for i in 1:num_sites]
    return SummedOperator(ops)
end

function TwoSiteOperator(
    id1::Int,
    id2::Int,
    pr1::AbstractOperatorPrimitive,
    pr2::AbstractOperatorPrimitive=pr1,
    coeff::Float64=1.0,
)
    return TensoredOperator([id1, id2], [pr1, pr2], coeff)
end

function UniformTwoSiteOperator(
    lattice::Lattice,
    pr1::AbstractOperatorPrimitive,
    pr2::AbstractOperatorPrimitive=pr1,
    shell::Int=1,
    coeff::Float64=1.0,
)
    pairs = neighbor_pairs(lattice, shell)
    ops = [TwoSiteOperator(i, j, pr1, pr2, coeff) for (i, j) in pairs]
    return SummedOperator(ops)
end

function ThreeSiteOperator(
    id1::Int,
    id2::Int,
    id3::Int,
    pr1::AbstractOperatorPrimitive,
    pr2::AbstractOperatorPrimitive=pr1,
    pr3::AbstractOperatorPrimitive=pr1,
    coeff::Float64=1.0,
)
    return TensoredOperator([id1, id2, id3], [pr1, pr2, pr3], coeff)
end

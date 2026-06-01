struct PairOperator{P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive} <: AbstractOperator
    id1::Int
    id2::Int
    pr1::P1
    pr2::P2
    coeff::Float64
end

function PairOperator(
    id1::Int,
    id2::Int,
    pr::P,
    coeff::Float64,
) where {P<:AbstractOperatorPrimitive}
    return PairOperator{P,P}(id1, id2, pr, pr, coeff)
end

function PairOperator(
    id1::Int,
    id2::Int,
    pr1::P1,
    pr2::P2,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return PairOperator{P1,P2}(id1, id2, pr1, pr2, 1.0)
end

function PairOperator(
    id1::Int,
    id2::Int,
    pr::P,
) where {P<:AbstractOperatorPrimitive}
    return PairOperator{P,P}(id1, id2, pr, pr, 1.0)
end

struct UniformPairOperator{P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive} <: AbstractOperator
    pr1::P1
    pr2::P2
    coeff::Float64
    shell::Int
end

function UniformPairOperator(
    pr::P,
    coeff::Float64,
    shell::Int,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator{P,P}(pr, pr, coeff, shell)
end

function UniformPairOperator(
    pr1::P1,
    pr2::P2,
    shell::Int,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator{P1,P2}(pr1, pr2, 1.0, shell)
end

function UniformPairOperator(
    pr1::P1,
    pr2::P2,
    coeff::Float64,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator{P1,P2}(pr1, pr2, coeff, 1)
end

function UniformPairOperator(
    pr1::P1,
    pr2::P2,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator{P1,P2}(pr1, pr2, 1.0, 1)
end

function UniformPairOperator(
    pr::P,
    shell::Int,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator{P,P}(pr, pr, 1.0, shell)
end

function UniformPairOperator(
    pr::P,
    coeff::Float64,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator{P,P}(pr, pr, coeff, 1)
end

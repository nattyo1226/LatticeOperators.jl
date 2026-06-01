struct PairOperator{O1<:AbstractOperatorPrimitive,O2<:AbstractOperatorPrimitive} <: AbstractOperator
    id1::Int
    id2::Int
    op1::O1
    op2::O2
    coeff::Float64
end

function PairOperator(
    id1::Int,
    id2::Int,
    op::O,
    coeff::Float64,
) where {O<:AbstractOperatorPrimitive}
    return PairOperator{O,O}(id1, id2, op, op, coeff)
end

function PairOperator(
    id1::Int,
    id2::Int,
    op1::O1,
    op2::O2,
) where {O1<:AbstractOperatorPrimitive,O2<:AbstractOperatorPrimitive}
    return PairOperator{O1,O2}(id1, id2, op1, op2, 1.0)
end

function PairOperator(
    id1::Int,
    id2::Int,
    op::O,
) where {O<:AbstractOperatorPrimitive}
    return PairOperator{O,O}(id1, id2, op, op, 1.0)
end

struct UniformPairOperator{O1<:AbstractOperatorPrimitive,O2<:AbstractOperatorPrimitive} <: AbstractOperator
    op1::O1
    op2::O2
    coeff::Float64
    shell::Int
end

function UniformPairOperator(
    op::O,
    coeff::Float64,
    shell::Int,
) where {O<:AbstractOperatorPrimitive}
    return UniformPairOperator{O,O}(op, op, coeff, shell)
end

function UniformPairOperator(
    op1::O1,
    op2::O2,
    shell::Int,
) where {O1<:AbstractOperatorPrimitive,O2<:AbstractOperatorPrimitive}
    return UniformPairOperator{O1,O2}(op1, op2, 1.0, shell)
end

function UniformPairOperator(
    op1::O1,
    op2::O2,
    coeff::Float64,
) where {O1<:AbstractOperatorPrimitive,O2<:AbstractOperatorPrimitive}
    return UniformPairOperator{O1,O2}(op1, op2, coeff, 1)
end

function UniformPairOperator(
    op1::O1,
    op2::O2,
) where {O1<:AbstractOperatorPrimitive,O2<:AbstractOperatorPrimitive}
    return UniformPairOperator{O1,O2}(op1, op2, 1.0, 1)
end

function UniformPairOperator(
    op::O,
    shell::Int,
) where {O<:AbstractOperatorPrimitive}
    return UniformPairOperator{O,O}(op, op, 1.0, shell)
end

function UniformPairOperator(
    op::O,
    coeff::Float64,
) where {O<:AbstractOperatorPrimitive}
    return UniformPairOperator{O,O}(op, op, coeff, 1)
end

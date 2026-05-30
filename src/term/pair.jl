struct PairTerm{O1<:AbstractOperator,O2<:AbstractOperator,T<:Number} <: AbstractTerm{T}
    op1::O1
    op2::O2
    coeff::T
    shell::Int
end

function PairTerm(op::O, coeff::T, shell::Int) where {O<:AbstractOperator,T<:Number}
    return PairTerm{O,O,T}(op, op, coeff, shell)
end

function PairTerm(op1::O1, op2::O2, shell::Int) where {O1<:AbstractOperator,O2<:AbstractOperator}
    return PairTerm{O1,O2,Float64}(op1, op2, 1.0, shell)
end

function PairTerm(op1::O1, op2::O2, coeff::T) where {O1<:AbstractOperator,O2<:AbstractOperator,T<:Number}
    return PairTerm{O1,O2,T}(op1, op2, coeff, 1)
end

function PairTerm(op1::O1, op2::O2) where {O1<:AbstractOperator,O2<:AbstractOperator}
    return PairTerm{O1,O2,Float64}(op1, op2, 1.0, 1)
end

function PairTerm(op::O, shell::Int) where {O<:AbstractOperator}
    return PairTerm{O,O,Float64}(op, op, 1.0, shell)
end

function PairTerm(op::O, coeff::T) where {O<:AbstractOperator,T<:Number}
    return PairTerm{O,O,T}(op, op, coeff, 1)
end

function PairTerm(op::O) where {O<:AbstractOperator}
    return PairTerm{O,O,Float64}(op, op, 1.0, 1)
end

struct PairTerm{O1<:AbstractOperator,O2<:AbstractOperator,T<:Number} <: AbstractTerm{T}
    op1::O1
    op2::O2
    coeff::T
    shell::Int
end

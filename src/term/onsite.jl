struct OnsiteTerm{O<:AbstractOperator,T<:Number} <: AbstractTerm{T}
    op::O
    coeff::T
end

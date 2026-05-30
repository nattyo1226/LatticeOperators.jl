struct OnsiteTerm{O<:AbstractOperator,T<:Number} <: AbstractTerm{T}
    op::O
    coeff::T
end

function OnsiteTerm(op::O) where {O<:AbstractOperator}
    return OnsiteTerm{O,Float64}(op, 1.0)
end

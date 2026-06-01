struct OnsiteOperator{O<:AbstractOperatorPrimitive} <: AbstractOperator
    op::O
    id::Int
    coeff::Float64
end

function OnsiteOperator(op::O, id::Int) where {O<:AbstractOperatorPrimitive}
    return OnsiteOperator{O}(op, id, 1.0)
end

struct UniformOnsiteOperator{O<:AbstractOperatorPrimitive} <: AbstractOperator
    op::O
    coeff::Float64
end

function UniformOnsiteOperator(op::O) where {O<:AbstractOperatorPrimitive}
    return UniformOnsiteOperator{O}(op, 1.0)
end

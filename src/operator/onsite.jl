struct OnsiteOperator{P<:AbstractOperatorPrimitive} <: AbstractOperator
    pr::P
    id::Int
    coeff::Float64
end

function OnsiteOperator(pr::P, id::Int) where {P<:AbstractOperatorPrimitive}
    return OnsiteOperator{P}(pr, id, 1.0)
end

struct UniformOnsiteOperator{P<:AbstractOperatorPrimitive} <: AbstractOperator
    pr::P
    coeff::Float64
end

function UniformOnsiteOperator(pr::P) where {P<:AbstractOperatorPrimitive}
    return UniformOnsiteOperator{P}(pr, 1.0)
end

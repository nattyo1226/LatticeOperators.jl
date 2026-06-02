struct OnsiteOperator{P<:AbstractOperatorPrimitive} <: AbstractOperator
    id::Int
    pr::P
    coeff::Float64
end

function OnsiteOperator(id::Int, pr::P) where {P<:AbstractOperatorPrimitive}
    return OnsiteOperator{P}(id, pr, 1.0)
end

function Base.show(io::IO, op::OnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "OnsiteOperator(id=%d, %s, coeff=%+f)" op.id nameof(typeof(op.pr)) op.coeff
end

function Base.show(io::IO, ::MIME"text/plain", op::OnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "[OnsiteOperator] \n"
    @printf io "id:          %d\n" op.id
    @printf io "primitive:   %s\n" nameof(typeof(op.pr))
    @printf io "coefficient: %+f\n" op.coeff
end


struct UniformOnsiteOperator{P<:AbstractOperatorPrimitive} <: AbstractOperator
    pr::P
    coeff::Float64
end

function UniformOnsiteOperator(pr::P) where {P<:AbstractOperatorPrimitive}
    return UniformOnsiteOperator{P}(pr, 1.0)
end

function Base.show(io::IO, op::UniformOnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "UniformOnsiteOperator(%s, coeff=%+f)" nameof(typeof(op.pr)) op.coeff
end

function Base.show(io::IO, ::MIME"text/plain", op::UniformOnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "[UniformOnsiteOperator] \n"
    @printf io "primitive:   %s\n" nameof(typeof(op.pr))
    @printf io "coefficient: %+f\n" op.coeff
end

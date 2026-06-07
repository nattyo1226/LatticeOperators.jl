struct OnsiteOperator{P<:AbstractOperatorPrimitive} <: AbstractOperator
    id::Int
    coeff::Float64
end

function OnsiteOperator(
    ::Type{P},
    id::Int,
    coeff::Float64,
) where {P<:AbstractOperatorPrimitive}
    return OnsiteOperator{P}(id, coeff)
end

function OnsiteOperator(
    ::Type{P},
    id::Int,
) where {P<:AbstractOperatorPrimitive}
    return OnsiteOperator(P, id, 1.0)
end

function Base.show(io::IO, op::OnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "OnsiteOperator{P=%s}(id=%d, coeff=%+f)" nameof(P) op.id op.coeff
end

function Base.show(io::IO, ::MIME"text/plain", op::OnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "[OnsiteOperator] \n"
    @printf io "id:          %d\n" op.id
    @printf io "primitive:   %s\n" nameof(P)
    @printf io "coefficient: %+f\n" op.coeff
end

struct UniformOnsiteOperator{P<:AbstractOperatorPrimitive} <: AbstractOperator
    coeff::Float64
end

function UniformOnsiteOperator(
    ::Type{P},
    coeff::Float64,
) where {P<:AbstractOperatorPrimitive}
    return UniformOnsiteOperator{P}(coeff)
end

function UniformOnsiteOperator(::Type{P}) where {P<:AbstractOperatorPrimitive}
    return UniformOnsiteOperator(P, 1.0)
end

function Base.show(io::IO, op::UniformOnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "UniformOnsiteOperator{P=%s}(coeff=%+f)" nameof(P) op.coeff
end

function Base.show(io::IO, ::MIME"text/plain", op::UniformOnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "[UniformOnsiteOperator] \n"
    @printf io "primitive:   %s\n" nameof(P)
    @printf io "coefficient: %+f\n" op.coeff
end

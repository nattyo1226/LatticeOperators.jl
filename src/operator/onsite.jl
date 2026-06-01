struct OnsiteOperator{P<:AbstractOperatorPrimitive} <: AbstractOperator
    pr::P
    id::Int
    coeff::Float64
end

function OnsiteOperator(pr::P, id::Int) where {P<:AbstractOperatorPrimitive}
    return OnsiteOperator{P}(pr, id, 1.0)
end

Base.show(io::IO, op::OnsiteOperator{P}) where {P<:AbstractOperatorPrimitive} = print(io, "OnsiteOperator{$(P)}($(op.pr), id=$(op.id), coeff=$(op.coeff))")
function Base.show(io::IO, ::MIME"text/plain", op::OnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "[OnsiteOperator] \n"
    @printf io "primitive:   %s\n" string(op.pr)
    @printf io "id:          %d\n" op.id
    @printf io "coefficient: %f\n" op.coeff
end


struct UniformOnsiteOperator{P<:AbstractOperatorPrimitive} <: AbstractOperator
    pr::P
    coeff::Float64
end

function UniformOnsiteOperator(pr::P) where {P<:AbstractOperatorPrimitive}
    return UniformOnsiteOperator{P}(pr, 1.0)
end

Base.show(io::IO, op::UniformOnsiteOperator{P}) where {P<:AbstractOperatorPrimitive} = print(io, "UniformOnsiteOperator{$(P)}($(op.pr), coeff=$(op.coeff))")
function Base.show(io::IO, ::MIME"text/plain", op::UniformOnsiteOperator{P}) where {P<:AbstractOperatorPrimitive}
    @printf io "[UniformOnsiteOperator] \n"
    @printf io "primitive:   %s\n" string(op.pr)
    @printf io "coefficient: %f\n" op.coeff
end

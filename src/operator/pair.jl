struct PairOperator{P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive} <: AbstractOperator
    id1::Int
    id2::Int
    pr1::P1
    pr2::P2
    coeff::Float64
end

function PairOperator(
    id1::Int,
    id2::Int,
    pr::P,
    coeff::Float64,
) where {P<:AbstractOperatorPrimitive}
    return PairOperator{P,P}(id1, id2, pr, pr, coeff)
end

function PairOperator(
    id1::Int,
    id2::Int,
    pr1::P1,
    pr2::P2,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return PairOperator{P1,P2}(id1, id2, pr1, pr2, 1.0)
end

function PairOperator(
    id1::Int,
    id2::Int,
    pr::P,
) where {P<:AbstractOperatorPrimitive}
    return PairOperator{P,P}(id1, id2, pr, pr, 1.0)
end

Base.show(io::IO, op::PairOperator{P1,P2}) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive} = print(io, "PairOperator{$(P1),$(P2)}(id1=$(op.id1), id2=$(op.id2), $(op.pr1), $(op.pr2), coeff=$(op.coeff))")
function Base.show(io::IO, ::MIME"text/plain", op::PairOperator{P1,P2}) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    @printf io "[PairOperator] \n"
    @printf io "id:          (%d, %d)\n" op.id1, op.id2
    @printf io "primitive:   (%s, %s)\n" string(op.pr1), string(op.pr2)
    @printf io "coefficient: %f\n" op.coeff
end

struct UniformPairOperator{P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive} <: AbstractOperator
    pr1::P1
    pr2::P2
    coeff::Float64
    shell::Int
end

function UniformPairOperator(
    pr::P,
    coeff::Float64,
    shell::Int,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator{P,P}(pr, pr, coeff, shell)
end

function UniformPairOperator(
    pr1::P1,
    pr2::P2,
    shell::Int,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator{P1,P2}(pr1, pr2, 1.0, shell)
end

function UniformPairOperator(
    pr1::P1,
    pr2::P2,
    coeff::Float64,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator{P1,P2}(pr1, pr2, coeff, 1)
end

function UniformPairOperator(
    pr1::P1,
    pr2::P2,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator{P1,P2}(pr1, pr2, 1.0, 1)
end

function UniformPairOperator(
    pr::P,
    shell::Int,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator{P,P}(pr, pr, 1.0, shell)
end

function UniformPairOperator(
    pr::P,
    coeff::Float64,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator{P,P}(pr, pr, coeff, 1)
end

Base.show(io::IO, op::UniformPairOperator{P1,P2}) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive} = print(io, "UniformPairOperator{$(P1),$(P2)}($(op.pr1), $(op.pr2), coeff=$(op.coeff), shell=$(op.shell))")
function Base.show(io::IO, ::MIME"text/plain", op::UniformPairOperator{P1,P2}) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    @printf io "[UniformPairOperator]\n"
    @printf io "primitive:   (%s, %s)\n" string(op.pr1), string(op.pr2)
    @printf io "coefficient: %f\n" op.coeff
    @printf io "shell:       %d\n" op.shell
end

struct PairOperator{
    P1<:AbstractOperatorPrimitive,
    P2<:AbstractOperatorPrimitive,
} <: AbstractOperator
    id1::Int
    id2::Int
    coeff::Float64

    function PairOperator{P1,P2}(
        id1::Int,
        id2::Int,
        coeff::Float64,
    ) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
        id1 == id2 && error("id1 and id2 must differ.")
        return new{P1,P2}(id1,id2,coeff)
    end
end

function PairOperator(
    ::Type{P1},
    ::Type{P2},
    id1::Int,
    id2::Int,
    coeff::Float64,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return PairOperator{P1,P2}(id1, id2, coeff)
end

function PairOperator(
    ::Type{P},
    id1::Int,
    id2::Int,
    coeff::Float64,
) where {P<:AbstractOperatorPrimitive}
    return PairOperator(P, P, id1, id2, coeff)
end

function PairOperator(
    ::Type{P1},
    ::Type{P2},
    id1::Int,
    id2::Int,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return PairOperator(P1, P2, id1, id2, 1.0)
end

function PairOperator(
    ::Type{P},
    id1::Int,
    id2::Int,
) where {P<:AbstractOperatorPrimitive}
    return PairOperator(P, P, id1, id2, 1.0)
end

function Base.show(io::IO, op::PairOperator{P1,P2}) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    @printf io "PairOperator{P1=%s,P2=%s}(id1=%d, id2=%d, coeff=%+10.9f)" nameof(P1) nameof(P2) op.id1 op.id2 op.coeff
end

function Base.show(io::IO, ::MIME"text/plain", op::PairOperator{P1,P2}) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    @printf io "[PairOperator] \n"
    @printf io "primitive:   (%s, %s)\n" nameof(P1) nameof(P2)
    @printf io "id:          (%d, %d)\n" op.id1 op.id2
    @printf io "coefficient: %+10.9f\n" op.coeff
end

struct UniformPairOperator{P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive} <: AbstractOperator
    coeff::Float64
    shell::Int
end

function UniformPairOperator(
    ::Type{P1},
    ::Type{P2},
    coeff::Float64,
    shell::Int,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator{P1,P2}(coeff, shell)
end

function UniformPairOperator(
    ::Type{P},
    coeff::Float64,
    shell::Int,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator(P, P, coeff, shell)
end

function UniformPairOperator(
    ::Type{P1},
    ::Type{P2},
    shell::Int,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator(P1, P2, 1.0, shell)
end

function UniformPairOperator(
    ::Type{P1},
    ::Type{P2},
    coeff::Float64,
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator(P1, P2, coeff, 1)
end

function UniformPairOperator(
    ::Type{P1},
    ::Type{P2},
) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    return UniformPairOperator(P1, P2, 1.0, 1)
end

function UniformPairOperator(
    ::Type{P},
    shell::Int,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator(P, P, 1.0, shell)
end

function UniformPairOperator(
    ::Type{P},
    coeff::Float64,
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator(P, P, coeff, 1)
end

function UniformPairOperator(
    ::Type{P},
) where {P<:AbstractOperatorPrimitive}
    return UniformPairOperator(P, P, 1.0, 1)
end

function Base.show(io::IO, op::UniformPairOperator{P1,P2}) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    @printf io "UniformPairOperator{P1=%s,P2=%s}(coeff=%+10.9f, shell=%d)" nameof(P1) nameof(P2) op.coeff op.shell
end
function Base.show(io::IO, ::MIME"text/plain", op::UniformPairOperator{P1,P2}) where {P1<:AbstractOperatorPrimitive,P2<:AbstractOperatorPrimitive}
    @printf io "[UniformPairOperator]\n"
    @printf io "primitive:   (%s, %s)\n" nameof(P1) nameof(P2)
    @printf io "coefficient: %+10.9f\n" op.coeff
    @printf io "shell:       %d\n" op.shell
end

struct SummedOperator <: AbstractOperator
    ops::Vector{AbstractOperator}
end

function SummedOperator(op::AbstractOperator...)
    return SummedOperator(collect(op))
end

Base.show(io::IO, op::SummedOperator) = print(io, "SummedOperator($(op.ops))")
function Base.show(io::IO, ::MIME"text/plain", op::SummedOperator)
    @printf io "[SummedOperator]\n"
    for subop in op.ops
        show(io, subop)
        @printf io "\n"
    end
end

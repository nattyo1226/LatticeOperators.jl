struct SummedOperator <: AbstractOperator
    ops::Vector{AbstractOperator}
end

function SummedOperator(op::AbstractOperator...)
    return SummedOperator(collect(op))
end

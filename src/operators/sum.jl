struct SummedOperator{T<:AbstractSystemTag,I<:AbstractIndex{T}} <: AbstractOperator{T,I}
    ops::Vector{TensoredOperator{T,I}}

    function SummedOperator(ops::Vector{TensoredOperator{T,I}}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
        return new{T,I}(ops)
    end
end

function SummedOperator(op::TensoredOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return SummedOperator([op])
end

function SummedOperator(ops::AbstractOperator{T,I}...) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    ops_merged = TensoredOperator{T,I}[]
    for op in ops
        if op isa TensoredOperator{T,I}
            push!(ops_merged, op)
        elseif op isa SummedOperator{T,I}
            append!(ops_merged, op.ops)
        else
            throw(ArgumentError("Unsupported operator type: $(typeof(op))"))
        end
    end
    ops_sorted = sort(ops_merged)
    return SummedOperator(ops_sorted)
end

function SummedOperator(op::AbstractOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return SummedOperator{T,I}([op])
end

function Base.:(==)(
    op1::SummedOperator{T,I},
    op2::SummedOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return Set(op1.ops) == Set(op2.ops) && op1.coeff == op2.coeff
end

function Base.hash(op::SummedOperator, h::UInt)
    return hash((Set(op.ops), op.coeff), h)
end

function Base.show(io::IO, op::SummedOperator)
    @printf io "SummedOperator([%s], %g)" join(string.(op.ops), ", ") op.coeff
end

function Base.show(io::IO, ::MIME"text/plain", op::SummedOperator)
    @printf io "[SummedOperator]\n"

    for op in op.ops
        @printf io "%s\n" string(op)
    end

    if !isapprox(op.coeff, 1.0)
        @printf io "Coefficient: %g" op.coeff
    end
end

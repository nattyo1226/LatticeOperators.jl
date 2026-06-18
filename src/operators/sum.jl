struct SummedOperator{T<:AbstractSystemTag,I<:AbstractIndex{T}} <: AbstractOperator{T,I}
    ops::Vector{TensoredOperator{T,I}}

    function SummedOperator(ops::Vector{TensoredOperator{T,I}}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
        ops = sort(ops)
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
    return length(op1.ops) == length(op2.ops) && all(op1.ops .== op2.ops)
end

function Base.hash(op::SummedOperator, h::UInt)
    return hash(Set(op.ops), h)
end

function Base.:(*)(c::Number, op::SummedOperator{T}) where {T<:AbstractSystemTag}
    ops_scaled = [c * op for op in op.ops]
    return SummedOperator(ops_scaled)
end

function Base.:(-)(op::SummedOperator)
    ops_neg = [-op for op in op.ops]
    return SummedOperator(ops_neg)
end

function Base.adjoint(op::SummedOperator)
    ops_adj = [adjoint(op) for op in op.ops]
    return SummedOperator(ops_adj)
end

function Base.show(io::IO, op::SummedOperator)
    @printf io "SummedOperator([%s])" join(string.(op.ops), ", ")
end

function Base.show(io::IO, ::MIME"text/plain", op::SummedOperator)
    @printf io "[SummedOperator]\n"

    for op in op.ops
        @printf io "%s\n" string(op)
    end
end

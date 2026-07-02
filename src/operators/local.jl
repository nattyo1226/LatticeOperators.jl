struct LocalOperator{T<:AbstractSystemTag,I<:AbstractIndex{T},P<:AbstractPrimitive{T}} <: AbstractOperator{T,I}
    id::I
    pr::P
end

function local_operator(
    id::I,
    pr::P,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T},P<:AbstractPrimitive{T}}
    return LocalOperator{T,I,P}(id, pr)
end

function Base.:(==)(
    op1::LocalOperator{T,I},
    op2::LocalOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return op1.id == op2.id && op1.pr == op2.pr
end

function Base.hash(op::LocalOperator, h::UInt)
    return hash((op.id, op.pr), h)
end

function Base.isless(op1::LocalOperator{T,I}, op2::LocalOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return op1.id < op2.id || (op1.id == op2.id && op1.pr < op2.pr)
end

function Base.adjoint(lo::LocalOperator)
    return LocalOperator(lo.id, adjoint(lo.pr))
end

function Base.show(io::IO, op::LocalOperator{T,I,P}) where {T,I,P}
    @printf io "%s%s" op.pr op.id
end

function Base.show(io::IO, ::MIME"text/plain", op::LocalOperator{T,I,P}) where {T,I,P}
    @printf io "[LocalOperator]\n"
    @printf io "id: %s\n" op.id
    @printf io "primitive: %s\n" op.pr
end

function isone_product(
    op1::LocalOperator{T,I,P1},
    op2::LocalOperator{T,I,P2},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T},P1<:AbstractPrimitive{T},P2<:AbstractPrimitive{T}}
    return op1.id == op2.id && isone_product(op1.pr, op2.pr)
end

function anticommutes(
    op1::LocalOperator{T,I,P1},
    op2::LocalOperator{T,I,P2},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T},P1<:AbstractPrimitive{T},P2<:AbstractPrimitive{T}}
    if T == FermionTag
        return anticommutes(op1.pr, op2.pr)
    else
        return op1.id == op2.id && anticommutes(op1.pr, op2.pr)
    end
end

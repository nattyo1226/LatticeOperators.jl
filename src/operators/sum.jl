function normalize_pos(
    pos::AbstractVector{ProductOperator{T,I}},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    pos_dict = Dict{Tuple{Vararg{LocalOperator{T,I}}},ComplexF64}()
    for po in pos
        key = Tuple(po.los)
        pos_dict[key] = get(pos_dict, key, 0.0 + 0.0im) + po.coeff
    end

    pos_merged = [
        begin
            prs = collect(LocalOperator{T,I}, key)
            ProductOperator(prs, value)
        end
        for (key, value) in pos_dict
        if !iszero(value)
    ]

    return sort(pos_merged)
end

struct SumOperator{T<:AbstractSystemTag,I<:AbstractIndex{T}} <: AbstractOperator{T,I}
    pos::Vector{ProductOperator{T,I}}

    function SumOperator{T,I}(
        pos::AbstractVector{ProductOperator{T,I}},
    ) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
        pos_n = normalize_pos(pos)
        return new{T,I}(pos_n)
    end
end

function SumOperator(pos::AbstractVector{ProductOperator{T,I}}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return SumOperator{T,I}(pos)
end

function SumOperator(po::ProductOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return SumOperator([po])
end

function SumOperator(ops::AbstractOperator{T,I}...) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    pos = Vector{ProductOperator{T,I}}()
    for op in ops
        if op isa LocalOperator{T,I}
            push!(pos, ProductOperator(op))
        elseif op isa ProductOperator{T,I}
            push!(pos, op)
        elseif op isa SumOperator{T,I}
            append!(pos, op.pos)
        else
            throw(ArgumentError("Unsupported operator type: $(typeof(op))"))
        end
    end

    return SumOperator(pos)
end

function local_operator(
    id::I,
    sp::SumPrimitive{T},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    pos = Vector{ProductOperator{T,I}}()
    for pp in sp.pps
        po = ProductOperator(id, pp)
        push!(pos, po)
    end

    return SumOperator(pos)
end

function Base.:(==)(
    so1::SumOperator{T,I},
    so2::SumOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return so1.pos == so2.pos
end

function Base.hash(so::SumOperator, h::UInt)
    return hash(so.pos, h)
end

function Base.isless(so1::SumOperator{T,I}, so2::SumOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return length(so1.pos) < length(so2.pos) || (length(so1.pos) == length(so2.pos) && so1.pos < so2.pos)
end

function Base.adjoint(so::SumOperator)
    pos_adj = adjoint.(so.pos)
    return SumOperator(pos_adj)
end

function Base.show(io::IO, op::SumOperator)
    if isempty(op.pos)
        @printf io "0"
    else
        for (i, po) in enumerate(op.pos)
            if i > 1
                @printf io " + "
            end
            @printf io "%s" string(po)
        end
    end
end

function Base.show(io::IO, ::MIME"text/plain", op::SumOperator)
    @printf io "[SumOperator]"

    if isempty(op.pos)
        @printf io "\n0"
    else
        @printf io "\nTerms:"
        for po in op.pos
            @printf io "\n  %s" string(po)
        end
    end
end

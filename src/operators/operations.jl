function Base.:(+)(
    ao1::AbstractOperator{T,I},
    ao2::AbstractOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return SumOperator(ao1, ao2)
end

function Base.:(+)(
    ao::AbstractOperator{T,I},
    c::Number,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    id = Identity{T}()
    return ao + ProductOperator(id, c)
end

function Base.:(+)(
    c::Number,
    ao::AbstractOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return ao + c
end

function Base.sum(
    aos::AbstractArray{<:AbstractOperator{T,I}},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    isempty(aos) && throw(ArgumentError("Cannot take sum of empty array"))
    return reduce(+, aos)
end

function Base.sum(
    aos::AbstractOperator{T,I}...,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    isempty(aos) && throw(ArgumentError("Cannot take sum of empty array"))
    return reduce(+, aos)
end

function Base.:(*)(
    c::Number,
    lo::LocalOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return ProductOperator(lo.id, lo.pr, c)
end

function Base.:(*)(
    c::Number,
    po::ProductOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    coeff = c * po.coeff
    return ProductOperator(po.los, coeff)
end

function Base.:(*)(c::Number, so::SumOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    pos = Vector{ProductOperator{T,I}}()
    for po in so.pos
        push!(pos, c * po)
    end

    return SumOperator(pos)
end

function Base.:(*)(
    ao::AbstractOperator{T,I},
    c::Number,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return c * ao
end

function Base.:(*)(
    ao1::AbstractOperator{T,I},
    ao2::AbstractOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    los = Vector{LocalOperator{T,I}}()
    coeff = one(ComplexF64)
    for ao in (ao1, ao2)
        if ao isa LocalOperator{T,I}
            push!(los, ao)
        elseif ao isa ProductOperator{T,I}
            append!(los, ao.los)
            coeff *= ao.coeff
        else
            throw(ArgumentError("Unsupported operator type: $(typeof(ao))"))
        end
    end

    return ProductOperator(los, coeff)
end

function Base.:(*)(
    so::SumOperator{T,I},
    ao::AbstractOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    pos = Vector{ProductOperator{T,I}}()
    for po in so.pos
        push!(pos, po * ao)
    end
    return SumOperator(pos)
end

function Base.:(*)(
    ao::AbstractOperator{T,I},
    so::SumOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    pos = Vector{ProductOperator{T,I}}()
    for po in so.pos
        push!(pos, ao * po)
    end
    return SumOperator(pos)
end

function Base.:(*)(
    so1::SumOperator{T,I},
    so2::SumOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    pos = Vector{ProductOperator{T,I}}()
    for po1 in so1.pos
        for po2 in so2.pos
            push!(pos, po1 * po2)
        end
    end
    return SumOperator(pos)
end

function Base.prod(
    aos::AbstractArray{<:AbstractOperator{T,I}},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    isempty(aos) && throw(ArgumentError("Cannot take product of empty array"))
    return reduce(*, aos)
end

function Base.prod(
    aos::AbstractOperator{T,I}...,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    isempty(aos) && throw(ArgumentError("Cannot take product of empty array"))
    return reduce(*, aos)
end

function Base.:(-)(ao::AbstractOperator{T,I}) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return (-1.0) * ao
end

function Base.:(-)(
    ao1::AbstractOperator{T,I},
    ao2::AbstractOperator{T,I},
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return ao1 + (-ao2)
end

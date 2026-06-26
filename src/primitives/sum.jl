struct SummedOperatorPrimitive{T<:AbstractSystemTag} <: AbstractOperatorPrimitive{T}
    prs::Vector{<:AbstractOperatorPrimitive{T}}

    function SummedOperatorPrimitive(prs::AbstractVector{<:AbstractOperatorPrimitive{T}}) where {T<:AbstractSystemTag}
        prs = sort(prs)
        return new{T}(prs)
    end
end

function SummedOperatorPrimitive(pr::AbstractOperatorPrimitive)
    return SummedOperatorPrimitive([pr])
end

function SummedOperatorPrimitive(prs::AbstractOperatorPrimitive{T}...) where {T<:AbstractSystemTag}
    prs_flat = Vector{AbstractOperatorPrimitive{T}}()
    for pr in prs
        if pr isa SummedOperatorPrimitive{T}
            append!(prs_flat, pr.prs)
        elseif pr isa AbstractOperatorPrimitive{T}
            push!(prs_flat, pr)
        else
            throw(ArgumentError("Unsupported operator primitive type: $(typeof(pr))"))
        end
    end

    prs_dict = Dict{AbstractOperatorPrimitive{T},Number}()
    for pr in prs_flat
        coeff = if pr isa ProductedOperatorPrimitive{T}
            pr.coeff
        else
            one(coeff_type(T))
        end

        if haskey(prs_dict, pr)
            prs_dict[pr] += coeff
        else
            prs_dict[pr] = coeff
        end
    end

    prs_merged = [ProductedOperatorPrimitive(pr, coeff) for (pr, coeff) in prs_dict]

    return SummedOperatorPrimitive(sort(prs_merged))
end

function order_key(pr::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return (2, length(pr.prs), Tuple(Iterators.flatten(order_key.(pr.prs))))
end

function Base.:(==)(pr1::SummedOperatorPrimitive{T}, pr2::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return Set(pr1.prs) == Set(pr2.prs)
end

function Base.hash(pr::SummedOperatorPrimitive, h::UInt)
    return hash(Set(pr.prs), h)
end

function Base.:(+)(pr1::AbstractOperatorPrimitive{T}, pr2::AbstractOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return SummedOperatorPrimitive(pr1, pr2)
end

function Base.:(*)(c::Number, pr::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    prs_scaled = [c * pr for pr in pr.prs]
    return SummedOperatorPrimitive(prs_scaled)
end

function Base.:(-)(pr1::AbstractOperatorPrimitive{T}, pr2::AbstractOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return pr1 + (-1.0) * pr2
end

function Base.:(-)(pr::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return (-1.0) * pr
end

function Base.adjoint(pr::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return SummedOperatorPrimitive(adjoint.(pr.prs))
end

function Base.show(io::IO, pr::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    @printf io "("
    for (i, p) in enumerate(pr.prs)
        if i > 1
            @printf io " + "
        end
        @printf io "%s" string(p)
    end
    @printf io ")"
end

function Base.show(io::IO, ::MIME"text/plain", pr::SummedOperatorPrimitive)
    @printf io "[SummedOperatorPrimitive]\n"
    for pr in pr.prs
        @printf io "%s\n" string(pr)
    end
end

"""
SummedOperatorPrimitive{T<:AbstractSystemTag} is a concrete type that represents a sum of operator primitives in a lattice system.
It is parameterized by a type T that must be a subtype of AbstractSystemTag.
The struct contains a vector of operator primitives, allowing for the representation of complex operator sums in lattice systems.

You can create a SummedOperatorPrimitive by constructors or `+` operator.
Examples:
```julia
pr1 = PauliX()
pr2 = PauliY()

sum1 = SummedOperatorPrimitive(pr1)  # Single operator primitive
sum2 = SummedOperatorPrimitive(pr1, pr2)  # Multiple operator primitives

sum3 = pr1 + pr2  # Using the `+` operator with two operator primitives
@assert sum3 == sum2
```

SummedOperatorPrimitive has tier 2 in the ordering of operator primitives.
"""
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

    prs_dict = Dict{Vector{AbstractOperatorPrimitive{T}},Number}()
    for pr in prs_flat
        key = if pr isa ProductedOperatorPrimitive{T}
            pr.prs
        else
            [pr]
        end

        val = if pr isa ProductedOperatorPrimitive{T}
            pr.coeff
        else
            one(coeff_type(T))
        end

        if haskey(prs_dict, key)
            prs_dict[key] += val
        else
            prs_dict[key] = val
        end
    end

    prs_merged = [ProductedOperatorPrimitive(prs, coeff) for (prs, coeff) in prs_dict]

    return SummedOperatorPrimitive(sort(prs_merged))
end

function order_key(pr::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return (2, length(pr.prs), Tuple(Iterators.flatten(order_key.(pr.prs))))
end

function Base.:(==)(pr1::SummedOperatorPrimitive{T}, pr2::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return pr1.prs == pr2.prs
end

function Base.hash(pr::SummedOperatorPrimitive, h::UInt)
    return hash(pr.prs, h)
end

function Base.:(+)(pr1::AbstractOperatorPrimitive{T}, pr2::AbstractOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return SummedOperatorPrimitive(pr1, pr2)
end

function Base.:(*)(c::Number, pr::SummedOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    prs_scaled = [c * pr for pr in pr.prs]
    return SummedOperatorPrimitive(prs_scaled)
end

function Base.:(*)(pr::SummedOperatorPrimitive{T}, c::Number) where {T<:AbstractSystemTag}
    prs_scaled = [pr * c for pr in pr.prs]
    return SummedOperatorPrimitive(prs_scaled)
end

function Base.:(-)(pr1::AbstractOperatorPrimitive{T}, pr2::AbstractOperatorPrimitive{T}) where {T<:AbstractSystemTag}
    return pr1 + (-pr2)
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

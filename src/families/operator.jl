function uniform_onsite(
    space::Space{T},
    pr::P,
    coeff::Number=1.0,
) where {T<:AbstractSystemTag,P<:AbstractPrimitive{T}}
    I = index_type(space)
    aos = Vector{AbstractOperator{T,I}}()
    for id in indices(space)
        ao = local_operator(id, pr) * coeff
        push!(aos, ao)
    end

    return SumOperator(aos...)
end

function uniform_bond(
    space::Space{T},
    pr1::P1,
    pr2::P2=pr1,
    coeff::Number=1.0,
    shell::Int=1,
) where {T<:AbstractSystemTag,P1<:AbstractPrimitive{T},P2<:AbstractPrimitive{T}}
    I = index_type(space)
    aos = Vector{AbstractOperator{T,I}}()
    for (id1, id2) in neighbor_pairs(space, shell)
        ao = local_operator(id1, pr1) * local_operator(id2, pr2) * coeff
        push!(aos, ao)
    end

    return SumOperator(aos...)
end

function OneSiteOperator(
    id::I,
    pr::P,
    coeff::Float64=1.0,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T},P<:AbstractOperatorPrimitive{T}}
    return TensoredOperator(id, pr, coeff)
end

function UniformOneSiteOperator(
    space::Space,
    pr::P,
    coeff::Float64=1.0,
) where {T<:AbstractSystemTag,P<:AbstractOperatorPrimitive{T}}
    ops = [OneSiteOperator(id, pr, coeff) for id in indices(space)]
    return SummedOperator(ops)
end

function TwoSiteOperator(
    id1::I,
    id2::I,
    pr1::AbstractOperatorPrimitive{T},
    pr2::AbstractOperatorPrimitive{T}=pr1,
    coeff::Float64=1.0,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return TensoredOperator([id1, id2], [pr1, pr2], coeff)
end

function UniformTwoSiteOperator(
    space::Space,
    pr1::AbstractOperatorPrimitive{T},
    pr2::AbstractOperatorPrimitive{T}=pr1,
    coeff::Float64=1.0,
    shell::Int=1,
) where {T<:AbstractSystemTag}
    ops = [TwoSiteOperator(i, j, pr1, pr2, coeff) for (i, j) in neighbor_pairs(space, shell)]
    return SummedOperator(ops)
end

function ThreeSiteOperator(
    id1::I,
    id2::I,
    id3::I,
    pr1::AbstractOperatorPrimitive{T},
    pr2::AbstractOperatorPrimitive{T}=pr1,
    pr3::AbstractOperatorPrimitive{T}=pr1,
    coeff::Float64=1.0,
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    return TensoredOperator([id1, id2, id3], [pr1, pr2, pr3], coeff)
end

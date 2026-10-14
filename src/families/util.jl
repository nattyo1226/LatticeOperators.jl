function default_eps(::Type{SpinHalfTag})
    return (PauliX(), PauliY(), PauliZ())
end

function default_eps(::Type{FermionTag})
    return (MajoranaX(), MajoranaY(), MajoranaZ())
end

function hermitian_phase(
    eps::AbstractVector{<:AbstractPrimitive{T}}
) where {T<:AbstractSystemTag}
    if T == FermionTag
        p = sum(majorana_parity, eps)
        return ifelse(
            iseven(p * (p - 1) ÷ 2),
            1.0 + 0.0im,
            0.0 + 1.0im
        )
    else
        return 1.0 + 0.0im
    end
end

function local_basis_operators(
    ids::AbstractVector{I},
    locality::Int;
    only_same_site::Bool=false,
    eps::Tuple{Vararg{ElementaryPrimitive{T}}}=default_eps(T),
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    if locality < 0
        throw(ArgumentError("locality must be non-negative."))
    elseif locality == 0
        return [ProductOperator{T,I}(Vector{LocalOperator{T,I}}())]
    else
        pos = Vector{ProductOperator{T,I}}()

        for ids_comb in combinations(ids, locality)
            if only_same_site && length(unique(site.(ids_comb))) > 1
                continue
            end
            for eps_comb in Iterators.product(ntuple(_ -> eps, locality)...)
                eps_comb = collect(eps_comb)
                phase = hermitian_phase(eps_comb)
                push!(pos, ProductOperator(ids_comb, eps_comb, phase))
            end
        end

        return pos
    end
end

"""
    nearest_neighbor_basis_operators(space::Space{T}; eps=default_eps(T))

Return a vector of Hermitian `ProductOperator`s containing all one-index basis
operators followed by all two-index basis operators on nearest-neighbor sites
of `space.geometry` (`shell=1`). All combinations of local labels are included.
Identity operators and pairs within the same site are excluded. Degree counts
indices, so `MajoranaZ` is a one-index operator.

The one-index operators follow `indices(space)` order. Two-index operators
follow sorted, unique index-pair order, with the indices in each pair sorted.
Primitive combinations follow `Iterators.product` order for `eps`. Sector
conservation laws are not used to filter the basis.

# Example
```julia
space = Space(SpinHalfSpace(), Hypercubic(4, OpenBoundary))
ops = nearest_neighbor_basis_operators(space) # 12 one-index + 27 two-index operators
```
"""
function nearest_neighbor_basis_operators(
    space::Space{T};
    eps::Tuple{Vararg{ElementaryPrimitive{T}}}=default_eps(T),
) where {T<:AbstractSystemTag}
    pos = local_basis_operators(collect(indices(space)), 1; eps)
    I = index_type(space)
    pairs = Tuple{I,I}[]
    for (id1, id2) in neighbor_pairs(space)
        push!(pairs, id2 < id1 ? (id2, id1) : (id1, id2))
    end
    sort!(unique!(pairs))

    for (id1, id2) in pairs
        for eps_pair in Iterators.product(eps, eps)
            eps_comb = collect(eps_pair)
            phase = hermitian_phase(eps_comb)
            push!(pos, ProductOperator([id1, id2], eps_comb, phase))
        end
    end

    return pos
end

struct GenericModel{T<:Number}
    terms::Vector{AbstractTerm{T}}
end

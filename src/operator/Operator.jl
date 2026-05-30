module Operator

abstract type AbstractOperator end

struct Identity <: AbstractOperator end
struct PauliX <: AbstractOperator end
struct PauliY <: AbstractOperator end
struct PauliZ <: AbstractOperator end

export AbstractOperator, Identity, PauliX, PauliY, PauliZ

end

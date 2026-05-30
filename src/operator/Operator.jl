module Operator

abstract type AbstractOperator end

struct PauliI <: AbstractOperator end
struct PauliX <: AbstractOperator end
struct PauliY <: AbstractOperator end
struct PauliZ <: AbstractOperator end

export AbstractOperator, PauliI, PauliX, PauliY, PauliZ

end

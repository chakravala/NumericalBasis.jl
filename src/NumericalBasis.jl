__precompile__()
module NumericalBasis

#   This file is part of NumericalBasis.jl. It is licensed under the MIT license
#   Copyright (C) 2018 Michael Reed

using SyntaxTree, Reduce
import Reduce: horner, factor, expand

horner(x,a) = horner(x,a,1)
horner(x,a::Array{<:Any,1},k) = k == length(a) ? a[k] : a[k] + x*horner(x,a,k+1)

factor(x,a) = factor(x,a,1)
factor(x,a::Array{<:Any,1},k) = k == length(a) ? x-a[k] : (x-a[k])*factor(x,a,k+1)

expand(x,a) = expand(x,a,length(a))
expand(x,a::Array{<:Any,1},k) = k == 1 ? a[k] : a[k]*x^(k-1) + expand(x,a,k-1)

#export roots

roots = factor

export optimal

function optimal(expr)
    h = horner(expr)
    f = factor(h)
    eh = SyntaxTree.exprval(h)[1]
    ef = SyntaxTree.exprval(f)[1]
    eo = SyntaxTree.exprval(expr)[1]
    if eh ≤ ef
        return eh ≤ eo ? h : expr
    else
        return ef ≤ eo ? f : expr
    end
end

__init__() = nothing

end # module

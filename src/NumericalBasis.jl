#__precompile__()
module NumericalBasis

#   This file is part of NumericalBasis.jl. It is licensed under the MIT license
#   Copyright (C) 2018 Michael Reed

using SyntaxTree, ForceImport, Reduce
export floatset, optimal, roots, polyhorner, polyfactors, polyexpand

function floatset(T::DataType,N;scale=x->x)
    l = scale(eps(T))
    u = scale(prevfloat(T(Inf)))
    return l:(u-l)/(N-1):u
end

polyhorner(x,a) = polyhorner(x,a,1)
polyhorner(x,a::Array{<:Any,1},k) = k==length(a) ? a[k] : Algebra.:+(a[k],Algebra.:*(x,polyhorner(x,a,k+1)))

polyfactors(x,a) = polyfactors(x,a,1)
polyfactors(x,a::Array{<:Any,1},k) = k==length(a) ? Algebra.:-(x,a[k]) : Algebra.:*(Algebra.:-(x,a[k]),polyfactors(x,a,k+1))

polyexpand(x,a) = polyexpand(x,a,length(a))
polyexpand(x,a::Array{<:Any,1},k) = k==1 ? a[k] : Algebra.:+(Algebra.:*(a[k],Algebra.:^(x,k-1)),polyexpand(x,a,k-1))

roots = factor

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

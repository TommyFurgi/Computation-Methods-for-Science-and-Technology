function NewtonInterpolation(xs, ys)
    T = Float64[]
    n = size(xs)[1]
    for a in 1:n
        push!(T,ys[a])
        for i in 1:a-1
            nom = T[end]-T[end-a+1]
            den = xs[a] - xs[a-i]
            push!(T,nom/den)
        end
    end
    newt = Float64[]
    k = 0
    for i in 1:n
        k = k + i
        push!(newt,T[k])
    end
    return newt
end

function Newton(newt, xs, x)
    n = size(xsf)[1]
    b = newt[n]
    for i=1:n-1
        b = newt[n-i] + b*(x-xs[n-i])
    end
    return b
end
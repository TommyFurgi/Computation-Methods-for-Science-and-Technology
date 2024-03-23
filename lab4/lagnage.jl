function Lagrange_interpolation(xs, ys, x)
    n = size(xs)[1]
    result = 0
    for i in 1:n
        L = 1
        for j in 1:n
            if j != i
                L *= (x-xs[j])/(xs[i]-xs[j])
            end
        end
        results += (ys[i]*L)
    end
    return result
end

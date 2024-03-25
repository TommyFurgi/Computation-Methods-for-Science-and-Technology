using Interpolations, Polynomials, DataFrames, CSV

function NewtonInterpolation(xs, ys)
    T = Float64[]
    n = size(xs)[1]
    
    # Populate the divided difference table
    for a in 1:n
        push!(T, ys[a])
        for i in 1:a-1
            nom = T[end] - T[end - a + 1] # numerator of the divided difference
            den = xs[a] - xs[a - i]      # denominator of the divided difference
            push!(T, nom / den)          # push the divided difference onto T
        end
    end
    
    # Extract the coefficients of the interpolating polynomial
    newt = Float64[]
    k = 0
    for i in 1:n
        k = k + i
        push!(newt, T[k])  # Store the coefficients
    end
    return newt
end

function Newton(newt, xs, x)
    n = size(xs)[1]    # Size of xs, not xsf
    b = newt[n]        # Start with the last coefficient
    for i in 1:n-1
        b = newt[n-i] + b * (x - xs[n-i])  # Update b using the recursive Newton formula
    end
    return b
end

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
        result += (ys[i]*L)
    end
    return result
end


xs = 0:1:10
ys = [rand() for _ in xs]
xsf = 0:1:10

lagr, time1 = @timed [Lagrange_interpolation(xs, ys, x) for x in xsf]
newt, time2 = @timed NewtonInterpolation(xs, ys)
newt2, time3 = @timed [Newton(newt, xs, x) for x in xsf]
polyn, time4 = @timed fit(xs ,ys)
polyn2, time5 = @timed [polyn(x) for x in xsf]



sizes = 10:3:40
results = DataFrame(Size = Int[], Lagrange_interpolation = Float64[], Newton_polynomial = Float64[], Newton_Interpolation = Float64[], package_Polynomial = Float64[], package_interpolation = Float64[]) 

for i in sizes
    for j in 1:10
        section = 10 / i
        xs = 0:section:10
        ys = [rand() for _ in xs]
        xsf = 0:0.1:10

        lagr, time1 = @timed [Lagrange_interpolation(xs, ys, x) for x in xsf]
        newt, time2 = @timed NewtonInterpolation(xs, ys)
        newt2, time3 = @timed [Newton(newt, xs, x) for x in xsf]
        polyn, time4 = @timed fit(xs ,ys)
        polyn2, time5 = @timed [polyn(x) for x in xsf]

        push!(results, (i, time1, time2, time3, time4, time5)) 
    end
end

CSV.write("results.csv", results)
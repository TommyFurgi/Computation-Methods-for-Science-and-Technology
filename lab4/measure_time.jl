using Interpolations, Polynomials, DataFrames, CSV

include("divided_differences.jl")
include("lagnage.jl")

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
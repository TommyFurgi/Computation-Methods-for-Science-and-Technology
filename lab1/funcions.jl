function vector_multiplication(A, B) # dot(A,B)
    if (size(A,1) != size(B,1))
        error("Vectors A and B must have the same length.")
    end

    result = 0
    for i in 1:size(A, 1)
        result += A[i] * B[i]
    end
    return result
end

function matrix_multiplication(A, B) # A * B
    if size(A, 2) != size(B, 1)
        error("Number of columns in A must equal number of rows in B")
    end

    result_vec = Vector{Float64}()
    for i in 1:size(A, 1)
        result_row = vector_multiplication(A[i, :], B)
        push!(result_vec, result_row)
    end
    return result_vec
end


using Random
using CSV
using DataFrames

A = [1;1]
B = [1;1]
@elapsed vector_multiplication(A, B)

A = [1 2 3; 4 5 6; 7 8 9]
B = [1, 2, 3]
@elapsed matrix_multiplication(A, B)

dimensions = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
results = DataFrame(Dimension = Int[], TimeVect = Float64[], TimeMatrix = Float64[]) 

for i in dimensions
    for j in 1:10
        A = rand(1:10, i)
        B = rand(1:10, i)
        C = rand(1:10, i, i)
        time_vector = @elapsed vector_multiplication(A, B) 
        time_matrix = @elapsed matrix_multiplication(C, B) 
        push!(results, (i, time_vector, time_matrix)) 
    end
end

CSV.write("results.csv", results)


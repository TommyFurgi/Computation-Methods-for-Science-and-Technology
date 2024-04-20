using Random, CSV, DataFrames


function naive_multiplication(A,B)
    C = zeros(Float64, size(A,1), size(B,2))
    for i=1:size(A,1)
        for j=1:size(B,2)
            for k=1:size(A,2)
                C[i,j] = C[i,j] + A[i,k]*B[k,j]
            end
        end
    end
    C
end

function better_multiplication(A, B)
    C = zeros(Float64, size(A,1), size(B,2))
    for j=1:size(B,2)
        for k=1:size(A,2)
            for i=1:size(A,1)
                C[i,j] = C[i,j] + A[i,k]*B[k,j]
            end
        end
    end
    C
end

Asmall = [[1.0 4.0]; [0.0 1.0]]
Bsmall = Asmall

naive_multiplication(Asmall, Bsmall)
better_multiplication(Asmall, Bsmall)
@elapsed Asmall * Bsmall

results = DataFrame(Size = Int[], naive_multiplication = Float64[], better_multiplication = Float64[], BLAS = Float64[]) 

for i in 50:50:500
    for _ in 1:10
        A = rand(0:9,(i,i))
        B = rand(0:9,(i,i))

        naive = @elapsed naive_multiplication(A, B)
        better = @elapsed better_multiplication(A, B)
        blas = @elapsed A*B

        push!(results, (i, naive, better, blas))
    end
end

CSV.write("results.csv", results)




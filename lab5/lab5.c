#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_blas.h>
#include <time.h>

void naive_multiplication(double** A, double** B, double** C, int size){
    for (int i = 0; i < size;i++){
        for (int j = 0; j < size; j++){
            for (int k = 0; k < size; k ++){
                C[i][j] += A[i][k]*B[k][j];
            }
        }     
    }
}
void better_multiplication(double** A, double** B, double** C, int size){
    for (int i = 0; i < size; i++){
        for (int k = 0; k < size; k ++){
            for (int j = 0; j < size; j++){
                C[i][j] += A[i][k]*B[k][j];
            }
        }
    }    
}

void blas_multiplication(double* a, double* b, double* c, int rows){
    gsl_matrix_view D = gsl_matrix_view_array(a, rows, rows);
    gsl_matrix_view E = gsl_matrix_view_array(b, rows, rows);
    gsl_matrix_view F = gsl_matrix_view_array(c, rows, rows);
    gsl_blas_dgemm (CblasNoTrans, CblasNoTrans,
                  1.0, &D.matrix, &E.matrix,
                  0.0, &F.matrix);
}

int main(int argc, char** argv) {
    double **A, **B, **C;
    double *a, *b, *c;
    double time1, time2, time3;
    FILE *raport = fopen("results1.csv","w");
    clock_t start, end;

    for (int i = 50; i <= 500; i += 50){
        A = calloc(i,sizeof(double *));
        B = calloc(i,sizeof(double *));
        C = calloc(i,sizeof(double *));
        a = calloc(i*i, sizeof(double));
        b = calloc(i*i, sizeof(double));
        c = calloc(i*i, sizeof(double));
        for (int j = 0; j < i; j++){
            A[j] = calloc(i,sizeof(double));
            B[j] = calloc(i,sizeof(double));
            C[j] = calloc(i,sizeof(double));
        }
        for (int j = 0; j < 10; j++){
            for (int k = 0; k < i; k ++){
                for (int a = 0; a < i; a ++){
                    A[k][a] = rand()%10;
                    B[k][a] = rand()%10;
                }
            }

            start = clock();
            naive_multiplication(A, B, C, i);
            end = clock();
            time1 = ((double)(end - start)) / CLOCKS_PER_SEC;

            start = clock();
            better_multiplication(A, B, C, i);
            end = clock();
            time2 = ((double)(end - start)) / CLOCKS_PER_SEC;

            for (int k = 0; k < i*i; k++){
                a[k] = A[k/i][k%i];
                b[k] = B[k/i][k%i];
            }

            start = clock();
            blas_multiplication(a, b, c, i);
            end = clock();
            time3 = ((double)(end - start)) / CLOCKS_PER_SEC;

            fprintf(raport,"%d,%f,%f,%f\n",i,time1,time2,time3);
        }
        for (int j = 0; j < i; j++){
            free(A[j]);
            free(B[j]);
            free(C[j]);
        }
        free(A);
        free(B);
        free(C);
        free(a);
        free(b);
        free(c);
    }

    fclose(raport);
    return 0;
}

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

#define ROWS 1000
#define COLS 500


void gemver(double** A, double* x, double** b) {
    #pragma scop
    for (size_t i = 0; i < ROWS; i ++ )
        for (size_t j = 0; j < COLS; j ++ ) {
            (*b)[i] = (*b)[i] + A[i][j]*x[j];
        }
    #pragma endscop
}

int main(){
  double **A;
  double *x;
  double **b;
  
  gemver(A, x, b);

}


#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>


#define A_ROWS 100
#define B_ROWS 200

#define A_COLS 200


void spmv(int A[A_ROWS][A_COLS], int B[B_ROWS], int C[A_ROWS]) {
    int sparseA[A_ROWS][A_COLS][2];
    int sparseAIndex[A_ROWS];
    int sparseIndexArr[A_ROWS];
    #pragma scop    
    for (int i = 0 ; i < A_ROWS; i ++){
        int sparse_index = 0 ;
        for (int j = 0 ; j < A_COLS; j++){
            sparseA[i][sparse_index][0] = j;
            sparseA[i][sparse_index][1] = A[i][j];
            sparse_index+= (A[i][j]!=0);
        }
        sparseIndexArr[i] = sparse_index;
    }
    #pragma endscop

    #pragma scop    
    for(int i = 0; i < A_ROWS; i++){
        int index = sparseIndexArr[i];
        for(int j = 0; j < A_COLS; j++){
            int x = sparseA[i][j][0];
            C[i] += sparseA[i][j][1] * B[x];
            j = A_COLS * (j == sparseAIndex[i]);
        }
    }
    #pragma endscop
}

int main(int argc, char** argv) {
    // int **A = initMatrix(A_ROWS, A_COLS);
    // int *B = initVec(B_ROWS);
    // int *C = initVec(A_ROWS);
    int A[A_ROWS][A_COLS];
    int B[B_ROWS];
    int C[A_ROWS];


    spmv(A, B, C);


    return 0;

}

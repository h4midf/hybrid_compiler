#include <stdio.h>

#define ARR_SIZE 1000

int pred(int x){
  return (x % 2) == 0;
}

int select(int size, int t) {
    int pos = 0;
    int A[ARR_SIZE];
    int B[ARR_SIZE];
    int C[ARR_SIZE];

    C[pos] = A[pos];
    int check;

    #pragma scop
    for(int my = 1; my < size; my++) {
        check = (A[my] %2) == 2;
        if(!check) {
            int p;
            pos++;
            p = pos;
            C[p] = A[my];
        }
    }
    #pragma endscop

    return pos;
}
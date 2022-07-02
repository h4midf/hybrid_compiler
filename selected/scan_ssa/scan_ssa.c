#define D_TYPE int

void scan_ssa(D_TYPE* C, D_TYPE* A, unsigned int nr_elements) {
    #pragma scop 
    C[0] = A[0];
    for (unsigned int i = 1; i < nr_elements; i++) {
        C[i] = C[i - 1] + A[i];
    }
    #pragma endscop
}
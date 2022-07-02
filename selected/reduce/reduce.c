#define D_TYPE int

int reduce(D_TYPE* A, unsigned int nr_elements) {
    D_TYPE count = 0;
    #pragma scop
    for (unsigned int i = 0; i < nr_elements; i++) {
        count += A[i];
    }
    #pragma endscop
    return count;
}

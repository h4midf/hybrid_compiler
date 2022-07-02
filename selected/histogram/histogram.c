#define D_TYPE int
// Pixel depth
#define DEPTH 12

void histogram(unsigned int* histo, D_TYPE* A, unsigned int bins, unsigned int nr_elements, int t) {

    #pragma scop
    for (unsigned int j = 0; j < nr_elements; j++) {
        D_TYPE d = A[j];
        histo[bins + ((d * bins) >> DEPTH)] += 1;
    }
    #pragma endscop
}

void histogram_exp(unsigned int* histo, D_TYPE* A, unsigned int bins, unsigned int nr_elements, int t){
    #pragma scop
    for (unsigned int j = 0; j < nr_elements; j++) {
        D_TYPE d = A[j];
        histo[(d * bins) >> DEPTH] += 1;

    }
    #pragma endscop

}
// Compute output in the host
#define NUM_LAYERS 10
#define D_TYPE int

void mlp(D_TYPE* C, D_TYPE** A, D_TYPE* B, unsigned int m_size, unsigned int n_size) {
    #pragma scop
	for (unsigned int nl = 0; nl < NUM_LAYERS; nl++){
		for (unsigned int m = 0; m < m_size; m++){
			C[m] = 0;
		}
		for (unsigned int m = 0; m < m_size; m++){
			for (unsigned int n = 0; n < n_size; n++){
				C[m] += A[nl][m * n_size + n] * B[n];
			}
            int max = 0 > C[m];
			C[m] = max * C[m];
            
		}
		for (unsigned int n = 0; n < n_size; n++){
			B[n] = C[n];
		}
	}


  D_TYPE sum = 0;
  for (D_TYPE m = 0; m < n_size; m++){
    sum += B[m];
  }
#pragma endscop
}

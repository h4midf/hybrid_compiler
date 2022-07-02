
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <assert.h>
#include <time.h>
#include <stdint.h>

#define DTYPE uint64_t

uint64_t bs(DTYPE * input, uint64_t input_size, DTYPE* querys, unsigned n_querys)
{

    #pragma scop
    uint64_t found = -1;
    uint64_t q, r, l, m;
	
    for(q = 0; q < n_querys; q++) {
        l = 0;
        r = input_size;
        while (l <= r) {
            m = l + (r - l) / 2;
            if (input[m] == querys[q]) {	
                found += m;
                break;
            }
            if (input[m] < querys[q])
                l = m + 1;

            else
		    		r = m - 1;
        }
    }


    return found;
    #pragma endscop
}

int main(int argc, char **argv) {

    uint64_t input_size = atol(argv[1]);
    uint64_t n_querys = atol(argv[2]);

    DTYPE * input = malloc((input_size) * sizeof(DTYPE));
    DTYPE * querys = malloc((n_querys) * sizeof(DTYPE));

    DTYPE result_host = -1;

    result_host = bs(input, input_size - 1, querys, n_querys);   
    free(input);


    return 0;
}


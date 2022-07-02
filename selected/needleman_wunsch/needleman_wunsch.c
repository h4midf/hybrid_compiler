#define BLOCK_SIZE 16

void needleman_wunsch(int *input_itemsets, int *output_itemsets, int *referrence,
        int max_rows, int max_cols, int penalty)
{
    int transfer_size = max_rows * max_cols;
    #pragma scop
    for( int blk = 1; blk <= (max_cols-1)/BLOCK_SIZE; blk++ ) {
        for( int b_index_x = 0; b_index_x < blk; ++b_index_x) {
            int b_index_y = blk - 1 - b_index_x;
            int input_itemsets_l[(BLOCK_SIZE + 1) *(BLOCK_SIZE+1)] __attribute__ ((aligned (64)));
            int reference_l[BLOCK_SIZE * BLOCK_SIZE] __attribute__ ((aligned (64)));

            for ( int i = 0; i < BLOCK_SIZE; ++i ){
                for ( int j = 0; j < BLOCK_SIZE; ++j) {
                    reference_l[i*BLOCK_SIZE + j] = referrence[max_cols*(b_index_y*BLOCK_SIZE + i + 1) + b_index_x*BLOCK_SIZE +  j + 1];
                }
            }
            for ( int i = 0; i < BLOCK_SIZE + 1; ++i ) {
                for ( int j = 0; j < BLOCK_SIZE + 1; ++j) {
                    input_itemsets_l[i*(BLOCK_SIZE + 1) + j] = input_itemsets[max_cols*(b_index_y*BLOCK_SIZE + i) + b_index_x*BLOCK_SIZE +  j];
                }
            }

            for ( int i = 1; i < BLOCK_SIZE + 1; ++i )
            {
                for ( int j = 1; j < BLOCK_SIZE + 1; ++j)
                {
                    int temp_a = input_itemsets_l[(i - 1)*(BLOCK_SIZE + 1) + j - 1] + reference_l[(i - 1)*BLOCK_SIZE + j - 1];
                    int temp_b = (input_itemsets_l[i*(BLOCK_SIZE + 1) + j - 1] - penalty);
                    int temp_c = (input_itemsets_l[(i - 1)*(BLOCK_SIZE + 1) + j] - penalty);
                    int a_g_b =  temp_a > temp_b;
                    int b_g_c =  temp_b > temp_c;
                    
                    // input_itemsets_l[i*(BLOCK_SIZE + 1) + j] = 
                    //     a_g_c * (a_g_b * temp_a + (1 - a_g_b) * temp_b) + (1 - a_g_c) * (b_g_c * temp_c + (1 - b_g_c) * temp_b);
                    // input_itemsets_l[i*(BLOCK_SIZE + 1) + j] = 
                    //     a_g_b ? (a_g_c? temp_a: (b_g_c?temp_b:temp_c)) : (b_g_c?temp_b:temp_c); 
                    
                    int big_p1 = a_g_b ? temp_a: temp_b;
                    int big_p2 = b_g_c ? temp_b: temp_c;
                    
                    int big_p3 = (big_p1 > big_p2)? big_p1: big_p2;
                    input_itemsets_l[i*(BLOCK_SIZE + 1) + j] = big_p3;
                        


                }
            }

            for ( int i = 0; i < BLOCK_SIZE; ++i ) {
                for ( int j = 0; j < BLOCK_SIZE; ++j) {
                    input_itemsets[max_cols*(b_index_y*BLOCK_SIZE + i + 1) + b_index_x*BLOCK_SIZE +  j + 1] = input_itemsets_l[(i + 1)*(BLOCK_SIZE+1) + j + 1];
                }
            }

        }
    }    

    for ( int blk = 2; blk <= (max_cols-1)/BLOCK_SIZE; blk++ ) {
        for( int b_index_x = blk - 1; b_index_x < (max_cols-1)/BLOCK_SIZE; ++b_index_x) {
            int b_index_y = (max_cols-1)/BLOCK_SIZE + blk - 2 - b_index_x;

            int input_itemsets_l[(BLOCK_SIZE + 1) *(BLOCK_SIZE+1)] __attribute__ ((aligned (64)));
            int reference_l[BLOCK_SIZE * BLOCK_SIZE] __attribute__ ((aligned (64)));

            for ( int i = 0; i < BLOCK_SIZE; ++i ) {
                for ( int j = 0; j < BLOCK_SIZE; ++j){
                    reference_l[i*BLOCK_SIZE + j] = referrence[max_cols*(b_index_y*BLOCK_SIZE + i + 1) + b_index_x*BLOCK_SIZE +  j + 1];
                }
            }

            for ( int i = 0; i < BLOCK_SIZE + 1; ++i ) {
                for ( int j = 0; j < BLOCK_SIZE + 1; ++j) {
                    input_itemsets_l[i*(BLOCK_SIZE + 1) + j] = input_itemsets[max_cols*(b_index_y*BLOCK_SIZE + i) + b_index_x*BLOCK_SIZE +  j];
                }
            }

            for ( int i = 1; i < BLOCK_SIZE + 1; ++i ) {
                for ( int j = 1; j < BLOCK_SIZE + 1; ++j) {
                    int temp_a = (input_itemsets_l[(i - 1)*(BLOCK_SIZE + 1) + j - 1] + reference_l[(i - 1)*BLOCK_SIZE + j - 1]);
                    int temp_b = (input_itemsets_l[i*(BLOCK_SIZE + 1) + j - 1] - penalty);
                    int temp_c = (input_itemsets_l[(i - 1)*(BLOCK_SIZE + 1) + j] - penalty);
                    int a_g_b =  temp_a > temp_b;
                    int b_g_c =  temp_b > temp_c;
                    int a_g_c = temp_a > temp_c;
                    
                    // input_itemsets_l[i*(BLOCK_SIZE + 1) + j] = 
                    //     a_g_c * (a_g_b * temp_a + (1 - a_g_b) * temp_b) + (1 - a_g_c) * (b_g_c * temp_c + (1 - b_g_c) * temp_b);
                    // input_itemsets_l[i*(BLOCK_SIZE + 1) + j] = 
                    //     a_g_b ? (a_g_c? temp_a: (b_g_c?temp_b:temp_c)) : (b_g_c?temp_b:temp_c);
                    int big_p1 = a_g_b ? temp_a: temp_b;
                    int big_p2 = b_g_c ? temp_b: temp_c;
                    
                    int big_p3 = (big_p1 > big_p2)? big_p1: big_p2;
                    input_itemsets_l[i*(BLOCK_SIZE + 1) + j] = big_p3;
                }
            }

            for ( int i = 0; i < BLOCK_SIZE; ++i ) {
                for ( int j = 0; j < BLOCK_SIZE; ++j) {
                    input_itemsets[max_cols*(b_index_y*BLOCK_SIZE + i + 1) + b_index_x*BLOCK_SIZE +  j + 1] = input_itemsets_l[(i + 1)*(BLOCK_SIZE+1) + j +1];

                }
            }
        }
    }
    #pragma endscop
}
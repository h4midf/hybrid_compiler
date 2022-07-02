#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <limits>
#include <vector>
#include <algorithm>
#include <string.h>
#include <sstream>
#include <chrono>
#include <omp.h>

#define DTYPE double 

bool interrupt = false;
int numThreads, exclusionZone;
int windowSize, timeSeriesLength, ProfileLength;
int* profileIndex, *profileIndex_tmp;
DTYPE *AMean, *ASigma, *profile, *profile_tmp;
std::vector<int> idx;
std::vector<DTYPE> A;


void time_series_analysis() {

    DTYPE  lastz, distance, windowSizeDTYPE;
    DTYPE  * distances, * lastzs;
    int diag, my_offset, i, j, ri;

    distances = new DTYPE[ARIT_FACT];
    lastzs    = new DTYPE[ARIT_FACT];

    windowSizeDTYPE = (DTYPE) windowSize;

    my_offset = omp_get_thread_num() * ProfileLength;

    for (ri = 0; ri < idx.size(); ri++) {
        diag = idx[ri];
        lastz = 0;
        for (j = diag; j < windowSize + diag; j++) {
            lastz += A[j] * A[j-diag];
        }
        j = diag;
        i = 0;

        distance = 2 * (windowSizeDTYPE - (lastz - windowSizeDTYPE* AMean[j] * AMean[i]) / (ASigma[j] * ASigma[i]));

        if (distance < profile_tmp[my_offset + j]) {
            profile_tmp[my_offset + j] = distance;
            profileIndex_tmp [my_offset+j] = i;
        }

        if (distance < profile_tmp[my_offset + i]) {
            profile_tmp[my_offset + i] = distance;
            profileIndex_tmp [my_offset + i] = j;
        }
        i = 1;
        j = diag + 1;

    }

    // Reduce the (partial) result
    DTYPE min_distance;
    int min_index;

    for (int colum = 0; colum < ProfileLength; colum++){
      min_distance = std::numeric_limits<DTYPE>::infinity();
      min_index = 0;
      for(int row = 0; row < numThreads; row++)
      {
        if(profile_tmp[colum + (row*ProfileLength)] < min_distance)
        {
          min_distance = profile_tmp[colum + (row * ProfileLength)];
          min_index    = profileIndex_tmp[colum + (row * ProfileLength)];
        }
      }
      profile[colum]      = min_distance;
      profileIndex[colum] = min_index;
    }

}

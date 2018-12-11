#include <stdio.h>
#include <stdlib.h>
#define TILE_SIZE  8
	__global__ void csr_multiply(int* d_row_size ,int* d_sparse, int*  d_cols, int* d_vals, int* d_X, int* d_y){
__shared__  int dot[TILE_SIZE];
int thid = TILE_SIZE * blockIdx.x + threadIdx.x;
int warp = thid/32;
int stride = thid % 32;
int row = warp;
		if (row < *d_row_size) {
		dot[threadIdx.x]=0;
		int row_start = d_sparse[row];
		int row_end = d_sparse[row+1];
			for(int elem = row_start+stride; elem < row_end ; elem +=32){
				dot[threadIdx.x]+= d_vals[elem] * d_X[d_cols[elem]];
	
}

for ( int s = 32 >> 1 ; s >= 1; s >>=1) {

if(stride < s ){dot[threadIdx.x] += dot[threadIdx.x +s];}

}

       if(stride==0){
                d_y[row]+=dot[threadIdx.x];

}



}
}

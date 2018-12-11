#include <stdio.h>
#include <stdlib.h>

	__global__ void csr_multiply(int *d_row_size, int* d_sparse, int*  d_cols, int* d_vals, int* d_X, int* d_y){
	int row = blockDim.x*blockIdx.x+threadIdx.x;


		if (row < *d_row_size) {
		int dot = 0;
		int row_start = d_sparse[row];
		int row_end = d_sparse[row+1];
			for(int elem = row_start; elem < row_end ; elem ++){
				dot += (d_vals[elem]) *( d_X[d_cols[elem]]);

	}		
	d_y[row]+=dot;

}
}

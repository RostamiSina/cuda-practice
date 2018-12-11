#include <stdio.h>
#include <stdlib.h>
#include "kernel.cu"
#include <sys/time.h>
#include "support.h"
#define TILE_SIZE 8
int main(int argc, char ** argv ) 
{
	 Timer timer;
    cudaError_t cuda_ret;
	  printf("\nSetting up the problem..."); fflush(stdout);
startTime(&timer);
int count=0;
     int length=70;
    int width=70;
    int Matrix[length][width];
    for(int i=0; i < length ; i++) {
     for (int j=0; j< width ; j++){
            if((rand()%5) <= 3){Matrix[i][j]=0;}
            else {
        Matrix[i][j]=rand()%60; if (Matrix[i][j] > 0){count++;}}
       // printf(" %d\t", Matrix[i][j]);
}
     }
     int X[length];
     for(int k=0; k<length; k++){
        if((rand()%5) >= 3){X[k]=0;}
            else {
        X[k]=rand()%60;}
        //printf(" \n X val  %d\t", X[k]);
}

    int rows[count];
int cols[count];
int vals[count];
    int sparse[count];
    int k=1;
    int f=1;
    int t=0;
    int row_size=sizeof(Matrix)/sizeof(Matrix[0]);
    int col_size=sizeof(Matrix[0])/sizeof(Matrix[0][0]);
    //printf("Row size of Matrix is %d \n", row_size);
    //printf("column size of Matrix is %d ", col_size);
    for (int i = 0; i < row_size; i++) {
                              for(int j=0; j <col_size ; j++){
                                        if (Matrix[i][j] != 0) {
            rows[t] = i;
            cols[t] = j;
            vals[t] = Matrix[i][j];
            //printf("\n %d \t %d \t %d", rows[t], cols[t], vals[t]);
                         t++;}
                                     }

                                        }
int   r_start, r_end;
 sparse[0]=0;
for (int row = 0; row < count-1 ; row++){
                    r_start=rows[row];
                    r_end=rows[row+1];
                    if (r_end > r_start){
sparse[k]=f;
    k++;} else {
		
			f++;
                    }
                                        }
sparse[k]=count;
                          int colsizer=sizeof(vals)/sizeof(vals[0]);
                                        //printf("\n your col size is %d",colsizer);
                                        sparse[k] = colsizer;
/*for( int l=0 ; l < count  ; l++) {
printf("\n  the sparse is %d  \n", sparse[l]);}*/
	int y[length];
	int * d_vals;
	int * d_cols;
	int * d_row_size;
	int * d_sparse;
	int * d_X;
	int * d_y;
	const int ARRAY_BYTES =colsizer *  sizeof(int);
	stopTime(&timer); printf("%f s\n", elapsedTime(timer));

//allocate GPU memory;

 	printf("Allocating device variables..."); fflush(stdout);
    	startTime(&timer);

	cuda_ret = cudaMalloc((void **) &d_vals, ARRAY_BYTES);
	if(cuda_ret !=cudaSuccess) FATAL("unable to allocate device memory" );
	cuda_ret =cudaMalloc((void **) &d_cols, ARRAY_BYTES);
	if(cuda_ret !=cudaSuccess) FATAL("unable to allocate device memory" );
	cuda_ret = cudaMalloc((void **) &d_row_size, ARRAY_BYTES);
        if(cuda_ret !=cudaSuccess) FATAL("unable to allocate device memory" );
        cuda_ret =cudaMalloc((void **) &d_sparse, ARRAY_BYTES);
        if(cuda_ret !=cudaSuccess) FATAL("unable to allocate device memory" );
 	cuda_ret = cudaMalloc((void **) &d_y, ARRAY_BYTES);
        if(cuda_ret !=cudaSuccess) FATAL("unable to allocate device memory" );
        cuda_ret =cudaMalloc((void **) &d_X, ARRAY_BYTES);
        if(cuda_ret !=cudaSuccess) FATAL("unable to allocate device memory" );
    	stopTime(&timer); printf("%f s\n", elapsedTime(timer));
	cudaDeviceSynchronize();


	// transfer the array to the GPU
	  printf("Copying data from host to device..."); fflush(stdout);
   	 startTime(&timer);

	cuda_ret = cudaMemcpy(d_vals, vals  , ARRAY_BYTES, cudaMemcpyHostToDevice);
	 if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to device");
	cuda_ret = cudaMemcpy(d_cols, cols  , ARRAY_BYTES, cudaMemcpyHostToDevice);
         if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to device");
	cuda_ret = cudaMemcpy(d_sparse, sparse  , ARRAY_BYTES, cudaMemcpyHostToDevice);
         if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to device");
	cuda_ret = cudaMemcpy(d_X, X  , ARRAY_BYTES, cudaMemcpyHostToDevice);
         if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to device");
	cuda_ret = cudaMemcpy(d_row_size, &row_size  , ARRAY_BYTES, cudaMemcpyHostToDevice);
         if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to device");
 	cudaDeviceSynchronize();
    	stopTime(&timer); printf("%f s\n", elapsedTime(timer));
// luanching kernel
	 printf("Launching kernel..."); fflush(stdout);
    	startTime(&timer);

	//const unsigned int THREADS_PER_BLOCK = 512;
	const unsigned int numBlocks = (row_size*32-1)/TILE_SIZE +1;
	dim3 gridDim(numBlocks, 1, 1), blockDim(TILE_SIZE, 1, 1);
	csr_multiply<<<numBlocks, TILE_SIZE, ARRAY_BYTES>>>(d_row_size, d_sparse, d_cols, d_vals, d_X, d_y);

	cuda_ret = cudaDeviceSynchronize();
        if(cuda_ret != cudaSuccess) FATAL("Unable to launch kernel");
    	stopTime(&timer); printf("%f s\n", elapsedTime(timer));

	printf("Copying data from device to host..."); fflush(stdout);
    	startTime(&timer);


	cuda_ret = cudaMemcpy(y , d_y , ARRAY_BYTES, cudaMemcpyDeviceToHost);
	if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory from device");

	cudaDeviceSynchronize();
    	stopTime(&timer); printf("%f s\n", elapsedTime(timer));

	//printf("time of the end printing ...."); fflush(stdout);
    	//startTime(&timer);
	
	cudaFree(d_row_size);
        cudaFree(d_cols);
	cudaFree(d_sparse);
	cudaFree(d_sparse);
	cudaFree(d_y);
        cudaFree(d_X);
/*for (int s=0 ; s<length ; s++){
printf(" \n your Y value is  %d ", y[s]);}*/ 
    return 0;
}

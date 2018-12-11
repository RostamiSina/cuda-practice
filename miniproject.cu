#include <stdio.h>
#include <sys/time.h>
#include "support.h"
#include <stdlib.h>

__global__ void check(int * d_out , int * d_in) {
	
	extern __shared__ int  ionCurrent[];
		int d_NUM_DUST=10;
        	int thid = threadIdx.x;
       		 while(thid <d_NUM_DUST){
               	 ionCurrent[thid]=0;
               	 thid+=blockDim.x;
        	}
        __syncthreads();
int idx = blockIdx.x*blockDim.x + threadIdx.x;
if( d_in[idx] > 0 )
{int  R = d_in[idx]-1 ;
atomicAdd(&(ionCurrent[R]),1);
d_out[R]=ionCurrent[R];
//d_out[R]+=1;
}

}

int main(int argc, char ** argv) {

 Timer timer;
    cudaError_t cuda_ret;

    // Initialize host variables ----------------------------------------------

    printf("\nSetting up the problem..."); fflush(stdout);
startTime(&timer);

    // Initialize host variables ----------------------------------------------

   
int  h_NUM_DUST = 1000000;
int  ionCurrent[h_NUM_DUST];
	for (int k = 0; k <h_NUM_DUST; k++){
         ionCurrent[k] = 0;
          }
int boundsIon[h_NUM_DUST];
     for(int k=0; k<h_NUM_DUST; k++){
        if((rand()%5) <= 2){boundsIon[k]=0;}
            else {
        boundsIon[k]=rand()% h_NUM_DUST;}

       // const int ARRAY_BYTES =h_NUM_DUST *  sizeof(int);

        // declare GPU memory pointers
int * d_in;
int * d_out;

//stopTime(&timer); printf("%f s\n", elapsedTime(timer));

//allocate GPU memory;



cuda_ret = cudaMalloc((void **) &d_in, ARRAY_BYTES);
if(cuda_ret !=cudaSuccess) FATAL("unable to allocate device memory" );
cuda_ret =cudaMalloc((void **) &d_out, ARRAY_BYTES);
if(cuda_ret !=cudaSuccess) FATAL("unable to allocate device memory" );

 cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));


// transfer the array to the GPU
  printf("Copying data from host to device..."); fflush(stdout);
    startTime(&timer);

cuda_ret = cudaMemcpy(d_in, boundsIon  , ARRAY_BYTES, cudaMemcpyHostToDevice);
 if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to device");

 cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));


//launch the kernel
 printf("Launching kernel..."); fflush(stdout);
    startTime(&timer);

const unsigned int THREADS_PER_BLOCK = 512;
const unsigned int numBlocks = (h_NUM_DUST-1)/THREADS_PER_BLOCK +1;
dim3 gridDim(numBlocks, 1, 1), blockDim(THREADS_PER_BLOCK, 1, 1);
check<<<numBlocks, THREADS_PER_BLOCK, ARRAY_BYTES>>>(d_out,d_in);

cuda_ret = cudaDeviceSynchronize();
        if(cuda_ret != cudaSuccess) FATAL("Unable to launch kernel");
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

//copy back the result array to the cpu
  printf("Copying data from device to host..."); fflush(stdout);
    startTime(&timer);
 

cuda_ret = cudaMemcpy(ionCurrent , d_out , ARRAY_BYTES, cudaMemcpyDeviceToHost);
if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory from device");

cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

printf("time of the end printing ...."); fflush(stdout);
    startTime(&timer);



cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));*/
//free GPU memory allocation
    printf("Verifying results..."); fflush(stdout);

    verify(A_h, B_h, C_h, matArow, matAcol, matBcol);*/

cudaFree(d_in);
cudaFree(d_out);
stopTime(&timer); printf("%f s\n", elapsedTime(timer));
return 0;
}


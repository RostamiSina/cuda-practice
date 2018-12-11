#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "support.h"
#define TILE_SIZE 8
int main(int argc, char ** argv ) 
{
	 Timer timer;
    cudaError_t cuda_ret;
	  printf("\nSetting up the problem..."); fflush(stdout);
startTime(&timer);
  int length=70;
    int width=70;
    int Matrix[length][width];
    for(int i=0; i < length ; i++) {
     for (int j=0; j< width ; j++){
            if((rand()%5) <= 3){Matrix[i][j]=0;}
            else {
        Matrix[i][j]=rand()%60;}
        }
     }
     int X[length];
     for(int k=0; k<length; k++){
        if((rand()%5) >= 3){X[k]=0;}
            else {
        X[k]=rand()%60;}
        }


int J[length];
for (int o =0 ; o < length ; o++ ){
        J[o]=0;
    for(int u=0; u < width ; u ++){
        J[o]+=X[u]*Matrix[o][u];
    }
}

        
	stopTime(&timer); printf("%f s\n", elapsedTime(timer));

/*for (int s=0 ; s<length ; s++){
printf(" \n your Y value is  %d ", y[s]);}*/ 
    return 0;
}

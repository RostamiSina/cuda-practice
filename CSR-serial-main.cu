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
int count=0;
     int length=80;
    int width=80;
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


for (int row = 0; row < length; row++){
                    r_start=sparse[row];
                    r_end=sparse[row+1];
                    int dot=0;
                    for(int elem=r_start; elem<r_end; elem++){
                          

                        dot += vals[elem]*X[cols[elem]];
                        //printf(" \n prime result is %d ", dot);

                    }
 y[row] += dot ;
 //printf(" \n your multiply is %d ", y[row]);
 }
	stopTime(&timer); printf("%f s\n", elapsedTime(timer));

/*for (int s=0 ; s<length ; s++){
printf(" \n your Y value is  %d ", y[s]);}*/ 
    return 0;
}

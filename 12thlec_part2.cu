#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <cstring>

__global__ void memTransfer( int * input, int size)
{

	int gid = threadIdx.x + blockDim.x*blockIdx.x;

	if (gid < size)
	{

		printf("tid : %d, gid : %d, value : %d, \n",
			threadIdx.x,gid,input[gid]);
 	}
	
}


int main()
{

	int array_size=150;
	int byte_size = sizeof(int)*array_size;

	int * h_data;
	h_data = (int *)malloc(byte_size);

	time_t t;
	srand((unsigned)time(&t));

	for(int i=0;i < array_size;i++)
	{
		h_data[i] = (int)(rand() & 0xff);
	}


	int * d_data;
	cudaMalloc((void **)&d_data,byte_size);

	cudaMemcpy(d_data,h_data,byte_size,cudaMemcpyHostToDevice);

	dim3 block(32);
	dim3 grid(5);

	memTransfer <<< grid,block >>> (d_data , array_size) ;
	cudaDeviceSynchronize();
	
	cudaFree(d_data);
	free(h_data);
	cudaDeviceReset();
	return 0;
}

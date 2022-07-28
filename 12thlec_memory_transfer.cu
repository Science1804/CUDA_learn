#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

#include <cstring>
#include <time.h>

__global__ void memTrnasfer(int * input)
{
	int gid = threadIdx.x + blockIdx.x*blockDim.x;

	printf("tid : %d, gid : %d, value : %d \n",
	threadIdx.x, gid , input[gid]);

}

int main()
{
	int array_size = 128;
	int byte_size = sizeof(int) * array_size;

	int * h_input;
	h_input = (int*)malloc(byte_size);

	time_t t;
	srand((unsigned)time(&t));

	for (int i=0; i < array_size;i++)
	{
		h_input[i] = (int)(rand() & 0xff);
	}

	int * d_input;
	cudaMalloc((void**)&d_input,byte_size);
	
	cudaMemcpy(d_input,h_input,byte_size,cudaMemcpyHostToDevice);

	dim3 block(64);
	dim3 grid(2);

	memTrnasfer <<< grid,block>>> (d_input);

	cudaDeviceSynchronize();

	cudaFree(d_input);
	free(h_input);
	cudaDeviceReset();
	return 0;
}


#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>


__global__ void global_uniq_id(int * input)
{

	int tid = threadIdx.x;
	int offset = blockIdx.x * blockDim.x ;
	int gid = tid + offset ;
	
	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx.x : %d, gid: %d, value : %d \n",
		blockIdx.x,blockIdx.y,threadIdx.x,gid,input[gid]);
}

int main()
{

	int array_size = 16;
	int array_byte_size = sizeof(int) * array_size;
	int h_data[] = {23,9,4,53,65,12,1,33,87,45,23,12,342,56,44,99};

	for ( int i = 0; i < array_size; i++)
	{
		printf("%d ", h_data[i]);
	
	}
	printf("\n \n");

	int * d_data;
	cudaMalloc((void**)&d_data, array_byte_size);
	cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);

	dim3 block(4);
	dim3 grid(2,2);

	global_uniq_id <<< grid,block >>> (d_data);
	cudaDeviceSynchronize();

	cudaDeviceReset();
	return 0;
}


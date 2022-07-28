#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

__global__ void grid2d_2d_block(int * input)

{

	int tid = threadIdx.x + blockDim.x*threadIdx.y;
	int block_offset = blockIdx.x*blockDim.x*blockDim.y;
	int row_offset = blockDim.x*blockDim.y*gridDim.x*blockIdx.y;
	int gid = tid + block_offset + row_offset;

	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx.x : %d, gid: %d, value : %d \n",
		blockIdx.x,blockIdx.y,threadIdx.x,gid,input[gid]);	


}


int main()
{

	int array_size = 16;
	int array_byte_size = sizeof(int)*array_size;
	int h_data[] = {10,20,30,40,5,6,7,8,9,10,11,12,13,14,15,16};

	int * d_data;
	cudaMalloc((void**)&d_data,array_byte_size);
	cudaMemcpy(d_data,h_data, array_byte_size, cudaMemcpyHostToDevice);

	dim3 block(2,2);
	dim3 grid(2,2);

	grid2d_2d_block <<< grid,block >>> (d_data) ;
	cudaDeviceSynchronize();

	cudaDeviceReset();

}

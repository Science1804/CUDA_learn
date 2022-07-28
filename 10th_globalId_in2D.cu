#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

__global__ void gid_2d_block(int * input)
{

	int tid = threadIdx.x;
	int block_offset = blockIdx.x*blockDim.x;
	int row_offset = gridDim.x*blockDim.x*blockIdx.y;
	int gid = tid + row_offset + block_offset ;

	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx.x : %d, gid : %d, data : %d \n",
		blockIdx.x, blockIdx.y , tid, gid, input[gid]);

}


int main()
{

	int array_size=16;
	int array_byte_size = sizeof(int) * array_size ;
	int h_data[] = {23,9,4,53,65,12,1,33,22,43,56,4,76,81,94,32};

	int * d_data;
	cudaMalloc((void**)&d_data, array_byte_size);
	cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);

	dim3 block(4);
	dim3 grid(2,2);

	gid_2d_block <<<grid,block>>> (d_data);
	cudaDeviceSynchronize();

	cudaDeviceReset();


}


#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>


__global__ void ex3_1D_block_1D_grid(int * input)
{
	int tid_x = threadIdx.x ;
	int block_offset= blockIdx.x*blockDim.x;
	
	int gid = tid_x + block_offset;
	printf(" Value : %d, gid : %d \n",
		input[gid],gid);

}

__global__ void ex3_2D_block_1D_grid(int * input)
{
	int tid = threadIdx.x + threadIdx.y*blockDim.x ;
	int block_offset = blockIdx.x*blockDim.x*blockDim.y ;
	// int row_offset = gridDim.x*blockIdx.y*blockDim.x*blockDim.y;

	int gid = tid + block_offset;

	printf(" Value : %d, gid : %d \n",
		input[gid],gid);
}

__global__ void ex3_3D_block_1D_grid( int * input)
{
	int tid = threadIdx.x + threadIdx.y*blockDim.x + \
				threadIdx.z*blockDim.x*blockDim.y;
	// int block_offset = blockIdx.x*blockDim.x*blockDim.y*blockDim.z ;
				
	int gid = tid ; 

	printf(" Value : %d, gid : %d \n",
		input[gid],gid);
}

__global__ void ex3_1D_block_2D_grid( int * input)
{
	int tid = threadIdx.x ;
	// int block_offset= blockIdx.x*blockDim.x;

	int row_offset = gridDim.x ;
				
	int gid = tid + row_offset ;

	printf(" Value : %d, gid : %d \n",
		input[gid],gid);
}


int main()
{

	int array_size = 64;
	int size = sizeof(int)*array_size;

	int * h_input;
	h_input = (int*)malloc(size);

	for (int i=0; i < array_size;i++)
	{
		h_input[i] = i;
	}

	int * d_input;
	cudaMalloc((void**)&d_input,size);

	cudaMemcpy(d_input,h_input,size,cudaMemcpyHostToDevice);

	// dim3 grid1(1);
	// dim3 block1(64);
	// dim3 block2(16,4);
	// dim3 block3(4,4,4);

	dim3 grid2(2,1);
	dim3 block1(32);
	
	// ex3_1D_block_1D_grid <<< grid1,block1 >>> (d_input);

	// ex3_2D_block_1D_grid <<< grid1 , block2 >>> (d_input);

	// ex3_3D_block_1D_grid <<< grid1 , block3 >>> (d_input);

	ex3_1D_block_2D_grid <<< grid2 , block1 >>> (d_input);



	cudaDeviceSynchronize();

	cudaFree(d_input);
	free(h_input);
	cudaDeviceReset();
	return 0;
}

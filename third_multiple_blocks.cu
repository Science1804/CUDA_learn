#include "cuda_runtime.h"
#include "device_launch_parameters.h"


#include <stdio.h>



__global__ void multiple_blocks()
{
	printf(" Hey this is being executed in different blocks \n");
}

int main()
{
	int nx,ny;
	nx = 16;
	ny = 4 ;

	dim3 block(8,2,1);
	dim3 grid(nx/block.x , ny/block.y ,1);

	multiple_blocks <<<grid,block>>> ();

	cudaDeviceSynchronize();

	cudaDeviceReset();
}


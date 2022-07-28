#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

__global__ void thread_array(int * input)
{
	int tid = threadIdx.x;
	printf(" threadIdx.x : %d, value : %d \n",tid,input[tid]);
}

int main()
{

	int array_size=8;
	int array_byte_size = sizeof(int) * array_size;
	int h_data[] = {23,9,4,53,65,12,1,33} ;

	for (int i= 0; i < array_size; i++)
	{
		printf("%d ", h_data[i]);
	}

	printf("\n \n");

	int * d_data ;
	cudaMalloc((void**)&d_data, array_byte_size);
	cudaMemcpy(d_data,h_data,array_byte_size, cudaMemcpyHostToDevice);

	dim3 block(8);
	dim3 grid(1);

	thread_array <<<grid,block>>> (d_data);
	cudaDeviceSynchronize();

	cudaDeviceReset();

}

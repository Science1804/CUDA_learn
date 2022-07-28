#include "cuda_runtime.h"
#include "device_launch_parameters.h"


#include <stdio.h>


__global__ void second()
{
    printf("Hello CUda 2 \n");
}

int main()
{
    dim3 block(4);
    dim3 grid(8);

    second << <grid , block >> > ();

    cudaDeviceSynchronize();

    cudaDeviceReset();

}
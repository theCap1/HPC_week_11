# HPC_week_5
## Homework for the 5th week

### 6. Assembly Building Blocks
#### 6.2 Small GEMM: ASIMD

##### 6.2.1 Implementation and verification
The verification of a working Kernel is implemented in `test.cpp`. A scalar implementation of this matrix multiplication is realized within `gemm_asm_simd_16_6_1.s`and only gives a performance of little over 5 GFLOPs. It is also very lengthy and does not makes a very fast impression in the first place.

##### 6.2.2 Optimization
In advance much thought was put into the implementation to realize good performance from the very beginning. The result is implemented in `gemm_asm_asimd_16_6_1.s` and a peak performance of more than 26 GFLOPs was reached which is already >40% of the theoretical peak performance. This may mostly be accredited to the fact that all computations where performed utilizing full vector registers and vector operations to accomplishing 8 (4 x addition, 4 x multiplication) operations in a single cycle for all operations. 
One optimization that happend later on was to use only non-callee safed registers that don't have to be saved before productive operations can take place. That way it was possible to squeeze out 31.1 GFLOPs which is almost 50% of the maximum peak performance. This also emphasizes that loads and stores to memory are expensive operations that should be avoided if possible.

Team  | Time [s] | # of executions | FP32 GFLOPs | peak [%]
------------- | ------------- | ------------- | ------------- | -------------
Mr. Anderson | 0.925682 | 150000000 | 31.1122 | 48.613

##### 6.2.3 Loop over k
The loop over k was realized in `k_loop_gemm_asm_asimd_16_6_1.s`. It is a little strange that the performance maxes out again at around 31.1 GFLOPs. It was supposed to increase but since the programm really only loops around the same code from 6.2.2 with very little adaptation this could be expected.

Team  | Time [s] | # of executions | FP32 GFLOPs | peak [%]
------------- | ------------- | ------------- | ------------- | -------------
Mr. Anderson | 44.4806 | 150000000 | 31.0787 | 48.605
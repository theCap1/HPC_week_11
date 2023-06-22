#include <iostream>
#include <chrono>
#include <cstdint>
#include <unistd.h>

#define DTYPE float

extern "C" {
    void gemm_asm_asimd_16_6_1( DTYPE const * i_a,
                                DTYPE const * i_b,
                                DTYPE       * io_c );
}

int main(){
    pid_t pid = getpid();
    std::cout << "Process ID: " << pid << std::endl;

    int64_t i_m = 16;
    int64_t i_n = 6;
    int64_t i_k = 1;

    std::cout << "running asimd GEMM microbenchmarks" << std::endl;
    std::chrono::steady_clock::time_point l_tp0, l_tp1;
    std::chrono::duration< double > l_dur;
    double l_g_flops = 0;
    int l_n_threads = 1;
    uint64_t l_n_repetitions = 150;
    l_n_repetitions *= 10000000;

    DTYPE *i_a = (DTYPE*) malloc(i_m*i_k*sizeof(DTYPE));
    DTYPE *i_b = (DTYPE*) malloc(i_k*i_n*sizeof(DTYPE));
    DTYPE *io_c = (DTYPE*) malloc(i_m*i_n*sizeof(DTYPE));

    for (int i = 0; i < i_k*i_m; i++)
    {
        *(i_a+i) = i;
    }

    for (int i = 0; i < i_k*i_n; i++)
    {
        *(i_b+i) = i_k*i_n-i;
    }

    for (int i = 0; i < i_m*i_n; i++)
    {
        *(io_c+i) = i;
    }

    /*
    * Give time to oin process to Core
    */
    std::cout << "This gives you time to pin the process to different CPU Cores. Be fast!!!" << std::endl;
    for (uint64_t i = 0; i < l_n_repetitions; i++)
    {
        gemm_asm_asimd_16_6_1(i_a, i_b, io_c);
    }

    /*
    * actual Benchmark
    */
    gemm_asm_asimd_16_6_1(i_a, i_b, io_c); // dry run
    std::cout << "Benchmark starts now." << std::endl;
    l_tp0 = std::chrono::steady_clock::now();
    for (uint64_t i = 0; i < l_n_repetitions; i++)
    {
        gemm_asm_asimd_16_6_1(i_a, i_b, io_c);
    }
    l_tp1 = std::chrono::steady_clock::now();

    l_dur = std::chrono::duration_cast< std::chrono::duration< double> >( l_tp1 - l_tp0 );

    std::cout << "  # of executions: " << l_n_repetitions << std::endl;
    std::cout << "  duration: " << l_dur.count() << " seconds" << std::endl;
    std::cout << "  average duration: " << l_dur.count()/l_n_repetitions << " seconds" << std::endl;
    l_g_flops = 2*i_m*i_n*i_k;
    l_g_flops *= l_n_threads;
    l_g_flops *= l_n_repetitions;
    l_g_flops *= 1.0E-9;
    l_g_flops /= l_dur.count();
    std::cout << "  GFLOPS: " << l_g_flops << std::endl;

    free(i_a);
    free(i_b);
    free(io_c);
}
#include <cstdint>
#include <iostream>

#define DTYPE float

extern "C" {
    void gemm_asm_asimd_16_6_1( DTYPE const * i_a,
                                DTYPE const * i_b,
                                DTYPE       * io_c );
}

int main(){

    int64_t i_m = 16;
    int64_t i_n = 6;
    int64_t i_k = 3;

    // DTYPE a[16] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 };
    // DTYPE b[6] = {1,2,3,4,5,6};
    // DTYPE c[6*16] = {0};

    DTYPE *a = (DTYPE*) malloc(i_m*i_k*sizeof(DTYPE));
    DTYPE *b = (DTYPE*) malloc(i_k*i_n*sizeof(DTYPE));
    DTYPE *c = (DTYPE*) malloc(i_m*i_n*sizeof(DTYPE));

    for (int i = 0; i < i_k*i_m; i++)
    {
        *(a+i) = (DTYPE)i+1;
    }

    for (int i = 0; i < i_k*i_n; i++)
    {
        *(b+i) = (DTYPE)i+1;
    }

    for (int i = 0; i < i_m*i_n; i++)
    {
        *(c+i) = (DTYPE)i;
    }
    
    printf("\nMatrix a using pointer is: \n");
    for(int i=0; i<i_m; ++i)
    {
        for(int j=0; j<i_k; ++j)
        {
            std::cout << *(a +j*i_m + i) << " ";
        }
        printf("\n");
    }

    std::cout << "\nMatrix B:\n";
    for(int c=0; c<i_k; c++)
    {
        for(int r=0; r<i_n; r++)
        {
            std::cout << *(b +r*i_k + c) << " ";
        }
        printf("\n");
    }

    DTYPE *b_transposed = (DTYPE*) malloc(i_k*i_n*sizeof(DTYPE));
    // std::cout << "\nTranspose of Matrix c:\n";
    for(int r=0; r<i_k; r++)    // i_k rows = 16
    {
        for(int col=0; col<i_n; col++)  // i_n columns = 6
        {
            *(b_transposed + col + r * i_n) = *(b + col * i_k + r);
        }
    }

    std::cout << "\nTransbposed Matrix B:\n";
    for(int c=0; c<i_n; c++)
    {
        for(int r=0; r<i_k; r++)
        {
            std::cout << *(b_transposed +r*i_n + c) << " ";
        }
        printf("\n");
    }

    std::cout << "\nMatrix C:\n";
    for(int col=0; col<i_m; col++)
    {
        for(int r=0; r<i_n; r++)
        {
            std::cout << *(c +r*i_m + col) << " ";
        }
        printf("\n");
    }

    DTYPE *c_transposed = (DTYPE*) malloc(i_m*i_n*sizeof(DTYPE));
    // std::cout << "\nTranspose of Matrix c:\n";
    for(int r=0; r<i_m; r++)    // i_m rows = 16
    {
        for(int col=0; col<i_n; col++)  // i_n columns = 6
        {
            *(c_transposed + col + r * i_n) = *(c + col * i_m + r);
        }
    }

    // for(int col=0; col<i_n; col++)
    // {
    //     for(int r=0; r<i_m; r++)
    //     {
    //         std::cout << *(transposed +r*i_n + col) << " ";
    //     }
    //     printf("\n");
    // }

    std::cout << "\nRetransposed FMA C+=A*B is:\n";
    gemm_asm_asimd_16_6_1(a,b_transposed,c);
    // for(int r=0; r<i_m; r++)    // i_m rows = 16
    // {
    //     for(int col=0; col<i_n; col++)  // i_n columns = 6
    //     {
    //         *(c + col * i_m + r) = *(transposed + col + r * i_n);
    //     }
    // }
    
    for(int col=0; col<i_m; col++) // i_m = 16 rows
    {
        for(int r=0; r<i_n; r++) // i_n = 6
        {
            std::cout << *(c +r*i_m + col) << " ";
            // std::cout << *(c +r*i_m + col) << " ";
        }
        printf("\n");
    }

    free(a);
    free(b);
    free(c);
    free(c_transposed);
    free(b_transposed);
}

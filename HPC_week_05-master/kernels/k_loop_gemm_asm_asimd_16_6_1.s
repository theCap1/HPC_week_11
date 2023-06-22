        .text
        .type gemm_asm_asimd_16_6_1, %function
        .global gemm_asm_asimd_16_6_1
        /*
         * Performs the matrix-multiplication C+=A*B
         * with the shapes (16x6) = (16x1) * (1x6).
         * The input-data is of type float.
         *
         * @param x0 pointer to A.
         * @param x1 pointer to B.
         * @param x2 pointer to C.
         */ 
gemm_asm_asimd_16_6_1:
        // store
        // SIMD callee registers
        //stp x19, x20, [sp, #-16]!       // Save X19 and X20 on the stack
        //stp x21, x22, [sp, #-16]!       // Save X21 and X22 on the stack
        //stp x23, x24, [sp, #-16]!       // Save X23 and X24 on the stack
        //stp x25, x26, [sp, #-16]!       // Save X25 and X26 on the stack
        //stp x27, x28, [sp, #-16]!       // Save X27 and X28 on the stack
        //stp x29, x30, [sp, #-16]!       // Save X29 and X30 on the stack

        // ASIMD callee saved registers
        //stp  d8,  d9, [sp, #-16]!       // Save D8 and D9 on the stack
        //stp d10, d11, [sp, #-16]!       // Save D10 and D11 on the stack
        //stp d12, d13, [sp, #-16]!       // Save D12 and D13 on the stack
        //stp d14, d15, [sp, #-16]!       // Save D14 and D15 on the stack

        // we will always have matrix B in the registers.
        // elements of A will be overwritten after every row of C
        // the result of the FMA will be directly written to memory of C
        // the matrix C is assumed to be stored in transposed version for more efficient memory loads and stores in this column major memory implementation.

        // loop counter to handle loop over k=48
        mov w5, 48

        loop_k:
                // load 16 values of A and one value of B into registers
                ld1 {v0.4s, v1.4s, v2.4s, v3.4s}, [x0], #64    // load 16 values of A into registers

                // load first value of B to be multiplied with all values of A
                ldr w4, [x1], #4

                // duplicate first value of B so we can use parallel vector multiplication
                dup v4.4s, w4

                //load first 16 values of C
                ld1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2]

                // do FMA C+=A*B for first 16 elements of C
                fmla v16.4s, v0.4s, v4.4s
                fmla v17.4s, v1.4s, v4.4s
                fmla v18.4s, v2.4s, v4.4s
                fmla v19.4s, v3.4s, v4.4s

                // store first 16 elements of C to memory
                st1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2], #64



                // load second value of B to be multiplied with all values of A
                ldr w4, [x1], #4
                // duplicate first value of B so we can use parallel vector multiplication
                dup v4.4s, w4

                //load next 16 values of C -> 32
                ld1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2]

                // do FMA C+=A*B for first 16 elements of C
                fmla v16.4s, v0.4s, v4.4s
                fmla v17.4s, v1.4s, v4.4s
                fmla v18.4s, v2.4s, v4.4s
                fmla v19.4s, v3.4s, v4.4s

                // store first 16 elements of C to memory
                st1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2], #64



                // load second value of B to be multiplied with all values of A
                ldr w4, [x1], #4
                // duplicate first value of B so we can use parallel vector multiplication
                dup v4.4s, w4

                //load next 16 values of C -> 48
                ld1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2]

                // do FMA C+=A*B for first 16 elements of C
                fmla v16.4s, v0.4s, v4.4s
                fmla v17.4s, v1.4s, v4.4s
                fmla v18.4s, v2.4s, v4.4s
                fmla v19.4s, v3.4s, v4.4s

                // store first 16 elements of C to memory
                st1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2], #64



                // load second value of B to be multiplied with all values of A
                ldr w4, [x1], #4
                // duplicate first value of B so we can use parallel vector multiplication
                dup v4.4s, w4

                //load next 16 values of C -> 64
                ld1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2]

                // do FMA C+=A*B for first 16 elements of C
                fmla v16.4s, v0.4s, v4.4s
                fmla v17.4s, v1.4s, v4.4s
                fmla v18.4s, v2.4s, v4.4s
                fmla v19.4s, v3.4s, v4.4s

                // store first 16 elements of C to memory
                st1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2], #64



                // load second value of B to be multiplied with all values of A
                ldr w4, [x1], #4
                // duplicate first value of B so we can use parallel vector multiplication
                dup v4.4s, w4

                //load next 16 values of C -> 80
                ld1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2]

                // do FMA C+=A*B for first 16 elements of C
                fmla v16.4s, v0.4s, v4.4s
                fmla v17.4s, v1.4s, v4.4s
                fmla v18.4s, v2.4s, v4.4s
                fmla v19.4s, v3.4s, v4.4s

                // store first 16 elements of C to memory
                st1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2], #64



                // load second value of B to be multiplied with all values of A
                ldr w4, [x1], #4
                // duplicate first value of B so we can use parallel vector multiplication
                dup v4.4s, w4

                // load next 16 values of C -> 96
                ld1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2]

                // do FMA C+=A*B for first 16 elements of C
                fmla v16.4s, v0.4s, v4.4s
                fmla v17.4s, v1.4s, v4.4s
                fmla v18.4s, v2.4s, v4.4s
                fmla v19.4s, v3.4s, v4.4s

                // store first 16 elements of C to memory and go back to the beginning -> 0
                st1 {v16.4s, v17.4s, v18.4s, v19.4s}, [x2], #64
                sub x2, x2, #384

                subs w5, w5, #1
                bne loop_k

        // restore
        //ldp d14, d15, [sp], #16
        //ldp d12, d13, [sp], #16
        //ldp d10, d11, [sp], #16
        //ldp  d8,  d9, [sp], #16

        //ldp x29, x30, [sp], #16
        //ldp x27, x28, [sp], #16
        //ldp x25, x26, [sp], #16
        //ldp x23, x24, [sp], #16
        //ldp x21, x22, [sp], #16
        //ldp x19, x20, [sp], #16

        ret
        .size gemm_asm_asimd_16_6_1, (. - gemm_asm_asimd_16_6_1)
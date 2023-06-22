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
        stp x19, x20, [sp, #-16]!       // Save X19 and X20 on the stack
        stp x21, x22, [sp, #-16]!       // Save X21 and X22 on the stack
        stp x23, x24, [sp, #-16]!       // Save X23 and X24 on the stack
        stp x25, x26, [sp, #-16]!       // Save X25 and X26 on the stack
        stp x27, x28, [sp, #-16]!       // Save X27 and X28 on the stack
        stp x29, x30, [sp, #-16]!       // Save X29 and X30 on the stack

        // ASIMD callee saved registers
        stp  d8,  d9, [sp, #-16]!       // Save D8 and D9 on the stack
        stp d10, d11, [sp, #-16]!       // Save D10 and D11 on the stack
        stp d12, d13, [sp, #-16]!       // Save D12 and D13 on the stack
        stp d14, d15, [sp, #-16]!       // Save D14 and D15 on the stack

        // we will always have matrix B in the registers.
        // elements of A will be overwritten after every row of C
        // the result of the FMA will be directly written to memory of C
        // the matrix C is assumed to be stored in transposed version for more efficient memory loads and stores in this column major memory implementation.

        // load first values of A and all of B into registers
        ldp w3, w4, [x0], #8    // load first two values of A
        // load B
        ldp w5, w6, [x1], #8
        ldp w7, w8, [x1], #8
        ldp w9, w10, [x1], #-16
        //load first two rows of C (here columns because C is transposed!)
        ldp w11, w12, [x2], #8
        ldp w13, w14, [x2], #8
        ldp w15, w16, [x2], #8
        ldp w17, w18, [x2], #8
        ldp w19, w20, [x2], #8
        ldp w21, w22, [x2], #8

        // do FMA C+=A*B for first two rows of C
        MADD w12, w3, w6, w12
        MADD w13, w3, w7, w13
        MADD w14, w3, w8, w14
        MADD w15, w3, w9, w15
        MADD w16, w3, w10, w16

        MADD w17, w4, w5, w17
        MADD w18, w4, w6, w18
        MADD w19, w4, w7, w19
        MADD w20, w4, w8, w20
        MADD w21, w4, w9, w21
        MADD w22, w4, w10, w22

        // store first two rows of C to memory
        stp w11, w12, [x2, #-48]
        stp w13, w14, [x2, #-40]
        stp w15, w16, [x2, #-32]
        stp w17, w18, [x2, #-24]
        stp w19, w20, [x2, #-16]
        stp w21, w22, [x2, #-8]

        // Repeat for next two rows of C
        ldp w3, w4, [x0], #8    // load values three and four of A
        //load rows three and four of C (here columns because C is transposed!)
        ldp w11, w12, [x2], #8
        ldp w13, w14, [x2], #8
        ldp w15, w16, [x2], #8
        ldp w17, w18, [x2], #8
        ldp w19, w20, [x2], #8
        ldp w21, w22, [x2], #8

        // do MADD C+=A*B for rows three and four of C
        MADD w11, w3, w5, w11
        MADD w12, w3, w6, w12
        MADD w13, w3, w7, w13
        MADD w14, w3, w8, w14
        MADD w15, w3, w9, w15
        MADD w16, w3, w10, w16

        MADD w17, w4, w5, w17
        MADD w18, w4, w6, w18
        MADD w19, w4, w7, w19
        MADD w20, w4, w8, w20
        MADD w21, w4, w9, w21
        MADD w22, w4, w10, w22

        // store rows three and four of C to memory
        stp w11, w12, [x2, #-48]
        stp w13, w14, [x2, #-40]
        stp w15, w16, [x2, #-32]
        stp w17, w18, [x2, #-24]
        stp w19, w20, [x2, #-16]
        stp w21, w22, [x2, #-8]

        // Repeat for next two rows of C
        ldp w3, w4, [x0], #8    // load values 5 and 6 of A
        //load rows 5 and 6 of C (here columns because C is transposed!)
        ldp w11, w12, [x2], #8
        ldp w13, w14, [x2], #8
        ldp w15, w16, [x2], #8
        ldp w17, w18, [x2], #8
        ldp w19, w20, [x2], #8
        ldp w21, w22, [x2], #8

        // do MADD C+=A*B for rows 5 and 6 of C
        MADD w11, w3, w5, w11
        MADD w12, w3, w6, w12
        MADD w13, w3, w7, w13
        MADD w14, w3, w8, w14
        MADD w15, w3, w9, w15
        MADD w16, w3, w10, w16

        MADD w17, w4, w5, w17
        MADD w18, w4, w6, w18
        MADD w19, w4, w7, w19
        MADD w20, w4, w8, w20
        MADD w21, w4, w9, w21
        MADD w22, w4, w10, w22

        // store rows 5 and 6 of C to memory
        stp w11, w12, [x2, #-48]
        stp w13, w14, [x2, #-40]
        stp w15, w16, [x2, #-32]
        stp w17, w18, [x2, #-24]
        stp w19, w20, [x2, #-16]
        stp w21, w22, [x2, #-8]

        // Repeat for next two rows of C
        ldp w3, w4, [x0], #8    // load values 5 and 6 of A
        //load rows 7 and 8 of C (here columns because C is transposed!)
        ldp w11, w12, [x2], #8
        ldp w13, w14, [x2], #8
        ldp w15, w16, [x2], #8
        ldp w17, w18, [x2], #8
        ldp w19, w20, [x2], #8
        ldp w21, w22, [x2], #8

        // do MADD C+=A*B for rows 7 and 8 of C
        MADD w11, w3, w5, w11
        MADD w12, w3, w6, w12
        MADD w13, w3, w7, w13
        MADD w14, w3, w8, w14
        MADD w15, w3, w9, w15
        MADD w16, w3, w10, w16

        MADD w17, w4, w5, w17
        MADD w18, w4, w6, w18
        MADD w19, w4, w7, w19
        MADD w20, w4, w8, w20
        MADD w21, w4, w9, w21
        MADD w22, w4, w10, w22

        // store rows 7 and 8 of C to memory
        stp w11, w12, [x2, #-48]
        stp w13, w14, [x2, #-40]
        stp w15, w16, [x2, #-32]
        stp w17, w18, [x2, #-24]
        stp w19, w20, [x2, #-16]
        stp w21, w22, [x2, #-8]

        // Repeat for next two rows of C
        ldp w3, w4, [x0], #8    // load values 5 and 6 of A
        //load rows 9 and 10 of C (here columns because C is transposed!)
        ldp w11, w12, [x2], #8
        ldp w13, w14, [x2], #8
        ldp w15, w16, [x2], #8
        ldp w17, w18, [x2], #8
        ldp w19, w20, [x2], #8
        ldp w21, w22, [x2], #8

        // do MADD C+=A*B for rows 9 and 10 of C
        MADD w11, w3, w5, w11
        MADD w12, w3, w6, w12
        MADD w13, w3, w7, w13
        MADD w14, w3, w8, w14
        MADD w15, w3, w9, w15
        MADD w16, w3, w10, w16

        MADD w17, w4, w5, w17
        MADD w18, w4, w6, w18
        MADD w19, w4, w7, w19
        MADD w20, w4, w8, w20
        MADD w21, w4, w9, w21
        MADD w22, w4, w10, w22

        // store rows 9 and 10 of C to memory
        stp w11, w12, [x2, #-48]
        stp w13, w14, [x2, #-40]
        stp w15, w16, [x2, #-32]
        stp w17, w18, [x2, #-24]
        stp w19, w20, [x2, #-16]
        stp w21, w22, [x2, #-8]

        // Repeat for next two rows of C
        ldp w3, w4, [x0], #8    // load values 5 and 6 of A
        //load rows 11 and 12 of C (here columns because C is transposed!)
        ldp w11, w12, [x2], #8
        ldp w13, w14, [x2], #8
        ldp w15, w16, [x2], #8
        ldp w17, w18, [x2], #8
        ldp w19, w20, [x2], #8
        ldp w21, w22, [x2], #8

        // do MADD C+=A*B for rows 11 and 12 of C
        MADD w11, w3, w5, w11
        MADD w12, w3, w6, w12
        MADD w13, w3, w7, w13
        MADD w14, w3, w8, w14
        MADD w15, w3, w9, w15
        MADD w16, w3, w10, w16

        MADD w17, w4, w5, w17
        MADD w18, w4, w6, w18
        MADD w19, w4, w7, w19
        MADD w20, w4, w8, w20
        MADD w21, w4, w9, w21
        MADD w22, w4, w10, w22

        // store rows 11 and 12 of C to memory
        stp w11, w12, [x2, #-48]
        stp w13, w14, [x2, #-40]
        stp w15, w16, [x2, #-32]
        stp w17, w18, [x2, #-24]
        stp w19, w20, [x2, #-16]
        stp w21, w22, [x2, #-8]

        // Repeat for next two rows of C
        ldp w3, w4, [x0], #8    // load values 5 and 6 of A
        //load rows 13 and 14 of C (here columns because C is transposed!)
        ldp w11, w12, [x2], #8
        ldp w13, w14, [x2], #8
        ldp w15, w16, [x2], #8
        ldp w17, w18, [x2], #8
        ldp w19, w20, [x2], #8
        ldp w21, w22, [x2], #8

        // do MADD C+=A*B for rows 13 and 14 of C
        MADD w11, w3, w5, w11
        MADD w12, w3, w6, w12
        MADD w13, w3, w7, w13
        MADD w14, w3, w8, w14
        MADD w15, w3, w9, w15
        MADD w16, w3, w10, w16

        MADD w17, w4, w5, w17
        MADD w18, w4, w6, w18
        MADD w19, w4, w7, w19
        MADD w20, w4, w8, w20
        MADD w21, w4, w9, w21
        MADD w22, w4, w10, w22

        // store rows 13 and 14 of C to memory
        stp w11, w12, [x2, #-48]
        stp w13, w14, [x2, #-40]
        stp w15, w16, [x2, #-32]
        stp w17, w18, [x2, #-24]
        stp w19, w20, [x2, #-16]
        stp w21, w22, [x2, #-8]

        // Repeat for next two rows of C
        ldp w3, w4, [x0], #8    // load values 5 and 6 of A
        //load rows 15 and 16 of C (here columns because C is transposed!)
        ldp w11, w12, [x2], #8
        ldp w13, w14, [x2], #8
        ldp w15, w16, [x2], #8
        ldp w17, w18, [x2], #8
        ldp w19, w20, [x2], #8
        ldp w21, w22, [x2], #8

        // do MADD C+=A*B for rows 15 and 16 of C
        MADD w11, w3, w5, w11
        MADD w12, w3, w6, w12
        MADD w13, w3, w7, w13
        MADD w14, w3, w8, w14
        MADD w15, w3, w9, w15
        MADD w16, w3, w10, w16

        MADD w17, w4, w5, w17
        MADD w18, w4, w6, w18
        MADD w19, w4, w7, w19
        MADD w20, w4, w8, w20
        MADD w21, w4, w9, w21
        MADD w22, w4, w10, w22

        // store rows 15 and 16 of C to memory
        stp w11, w12, [x2, #-48]
        stp w13, w14, [x2, #-40]
        stp w15, w16, [x2, #-32]
        stp w17, w18, [x2, #-24]
        stp w19, w20, [x2, #-16]
        stp w21, w22, [x2, #-8]

        // restore
        // ASIMD callee saved registers
        ldp d14, d15, [sp], #16         // Restore D14 and D15 from the stack
        ldp d12, d13, [sp], #16         // Restore D12 and D13 from the stack
        ldp d10, d11, [sp], #16         // Restore D10 and D11 from the stack
        ldp  d8,  d9, [sp], #16         // Restore D8 and D9 from the stack

        // SIMD callee registers
        ldp x29, x30, [sp], #16         // Restore X29 and X30 from the stack
        ldp x27, x28, [sp], #16         // Restore X27 and X28 from the stack
        ldp x25, x26, [sp], #16         // Restore X25 and X26 from the stack
        ldp x23, x24, [sp], #16         // Restore X23 and X24 from the stack
        ldp x21, x22, [sp], #16         // Restore X21 and X22 from the stack
        ldp x19, x20, [sp], #16         // Restore X19 and X20 from the stack

        ret
        .size gemm_asm_asimd_16_6_1, (. - gemm_asm_asimd_16_6_1)
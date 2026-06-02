// mesh_pipeline.v
// Fixed diagonal pipeline: 4 sal_e_pimenta stages in series.
// The "mesh" here is the physical wiring; routing is static.
// Each stage alternates max/min output.
//
// Stage 0: max  (node 0,0)
// Stage 1: min  (node 1,1)
// Stage 2: max  (node 2,2)
// Stage 3: min  (node 3,3)

module mesh_pipeline (
    input  wire clock,
    input  wire shiftin,      // raw serial pixel from ROM

    output wire result_bit    // final filtered pixel, serial out
);

    wire max0, min0;
    wire max1, min1;
    wire max2, min2;
    wire max3, min3;

    // Stage 0 — takes max
    modulo_sal_e_pimenta stage0 (
        .clock   (clock),
        .shiftin (shiftin),
        .max_bit (max0),
        .min_bit (min0)
    );

    // Stage 1 — takes min of stage0's max output
    modulo_sal_e_pimenta stage1 (
        .clock   (clock),
        .shiftin (max0),      // feeds on max from stage 0
        .max_bit (max1),
        .min_bit (min1)
    );

    // Stage 2 — takes max of stage1's min output
    modulo_sal_e_pimenta stage2 (
        .clock   (clock),
        .shiftin (min1),
        .max_bit (max2),
        .min_bit (min2)
    );

    // Stage 3 — takes min of stage2's max output
    modulo_sal_e_pimenta stage3 (
        .clock   (clock),
        .shiftin (max2),
        .max_bit (max3),
        .min_bit (min3)
    );

    assign result_bit = min3;

endmodule
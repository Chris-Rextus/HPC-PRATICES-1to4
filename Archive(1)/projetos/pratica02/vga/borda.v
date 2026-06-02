module edge_detector_3x3 (
    input  [2:0] in1,  // linha superior: P1 P2 P3
    input  [2:0] in2,  // linha central:  P4 P5 P6
    input  [2:0] in3,  // linha inferior: P7 P8 P9
    output       out
);

    wire p1 = in1[0];
    wire p2 = in1[1];
    wire p3 = in1[2];

    wire p4 = in2[0];
    wire p5 = in2[1]; // pixel central
    wire p6 = in2[2];

    wire p7 = in3[0];
    wire p8 = in3[1];
    wire p9 = in3[2];

    // XOR com pixel central (detecção real de diferença)
    wire e1 = p5 ^ p1;
    wire e2 = p5 ^ p2;
    wire e3 = p5 ^ p3;
    wire e4 = p5 ^ p4;
    wire e6 = p5 ^ p6;
    wire e7 = p5 ^ p7;
    wire e8 = p5 ^ p8;
    wire e9 = p5 ^ p9;

    // borda se qualquer vizinho for diferente
    assign out = e1 | e2 | e3 | e4 | e6 | e7 | e8 | e9;

endmodule
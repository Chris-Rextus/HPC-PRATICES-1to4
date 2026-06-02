// mux2to1.v
// Simple 2-to-1 mux for 1-bit serial data
// sel=0: output = d0 (raw)
// sel=1: output = d1 (filtered)

module mux2to1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);

    assign y = sel ? d1 : d0;

endmodule
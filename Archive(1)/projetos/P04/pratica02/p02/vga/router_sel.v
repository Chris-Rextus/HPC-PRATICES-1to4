// router_sel.v
// Selects one of 5 incoming serial streams and forwards to one output.
// No processing inside — just a mux.
// The controller sets src_sel and dst_sel each frame.

module router_sel #(
    parameter [3:0] MY_ADDR = 4'b0000
)(
    input  wire clock,

    // Serial inputs from each direction + local PE output
    input  wire d_n, input  wire d_s,
    input  wire d_e, input  wire d_w,
    input  wire d_local_max, input  wire d_local_min,
    input  wire use_max,           // selects max or min from local PE

    // Which input feeds this node's PE (0=ext/entry, 1=N, 2=S, 3=E, 4=W)
    input  wire [2:0] src_sel,
    // Which direction to forward the PE output
    // 0=N, 1=S, 2=E, 3=W, 4=local_out (end of chain)
    input  wire [2:0] dst_sel,

    input  wire        target_addr_match, // (target==MY_ADDR) from controller

    // Serial outputs to each direction
    output reg  dout_n, output reg  dout_s,
    output reg  dout_e, output reg  dout_w,
    output wire dout_pe_in,   // goes to local modulo_sal_e_pimenta.shiftin
    output wire dout_final    // captured final result
);

    // Select which incoming stream feeds the local PE
    reg sel_bit;
    always @(*) begin
        case (src_sel)
            3'd0: sel_bit = d_n;
            3'd1: sel_bit = d_s;
            3'd2: sel_bit = d_e;
            3'd3: sel_bit = d_w;
            default: sel_bit = 1'b0;
        endcase
    end

    assign dout_pe_in = sel_bit;

    // Select max or min output from PE
    wire pe_out = use_max ? d_local_max : d_local_min;

    assign dout_final = pe_out;

    // Route PE output to the right neighbor
    always @(posedge clock) begin
        dout_n <= 0; dout_s <= 0;
        dout_e <= 0; dout_w <= 0;

        if (target_addr_match) begin
            case (dst_sel)
                3'd0: dout_n <= pe_out;
                3'd1: dout_s <= pe_out;
                3'd2: dout_e <= pe_out;
                3'd3: dout_w <= pe_out;
                default: ; // 4 = terminal node, result captured above
            endcase
        end
    end

endmodule
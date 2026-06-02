module mesh_node #(
    parameter [3:0] MY_ADDR = 4'b0000
)(
    input  wire        clock,
    input  wire [3:0]  hop1_addr, hop2_addr, hop3_addr, hop4_addr,
    input  wire        din_entry,
	 input wire hop1_max, hop2_max, hop3_max, hop4_max,

    // Single data channel in/out per direction
    input  wire        din_n, din_s, din_e, din_w,
    input  wire        vin_n, vin_s, vin_e, vin_w,
    output wire        dout_n, dout_s, dout_e, dout_w,
    output wire        vout_n, vout_s, vout_e, vout_w,

    output wire        dout_final
);
    localparam [1:0] my_col = MY_ADDR[3:2];
    localparam [1:0] my_row = MY_ADDR[1:0];

    // Which hop am I?
    wire is_hop1 = (MY_ADDR == hop1_addr);
    wire is_hop2 = (MY_ADDR == hop2_addr);
    wire is_hop3 = (MY_ADDR == hop3_addr);
    wire is_hop4 = (MY_ADDR == hop4_addr);
    wire on_path = is_hop1 | is_hop2 | is_hop3 | is_hop4;

    // Where is the NEXT hop from me?
    // hop1 node routes toward hop2, hop2 toward hop3, hop3 toward hop4
    wire [3:0] next_addr = is_hop1 ? hop2_addr :
                           is_hop2 ? hop3_addr :
                           is_hop3 ? hop4_addr :
                                     hop4_addr; // hop4 doesn't forward

    wire [1:0] next_col = next_addr[3:2];
    wire [1:0] next_row = next_addr[1:0];

    // Routing toward next_addr
    wire go_s = on_path && !is_hop4 && (my_row < next_row);
    wire go_n = on_path && !is_hop4 && (my_row > next_row);
    wire go_e = on_path && !is_hop4 && (my_row == next_row) && (my_col < next_col);
    wire go_w = on_path && !is_hop4 && (my_row == next_row) && (my_col > next_col);

    // Where is data coming FROM (for non-source nodes on path)?
    // Intermediate nodes: pick the valid input
    wire data_in = vin_n ? din_n :
                   vin_s ? din_s :
                   vin_e ? din_e :
                   vin_w ? din_w :
                            1'b0;

    // PE input
    wire pe_in = is_hop1 ? din_entry : data_in;

    wire pe_max_out, pe_min_out;
    modulo_sal_e_pimenta u_pe (
        .clock   (clock),
        .shiftin (pe_in),
        .max_bit (pe_max_out),
        .min_bit (pe_min_out)
    );
	 
	 wire my_max = is_hop1 ? hop1_max :
              is_hop2 ? hop2_max :
              is_hop3 ? hop3_max :
                        hop4_max;

    wire pe_out = my_max ? pe_max_out : pe_min_out;

    // Source of data to forward:
    // - hop nodes: their own PE output
    // - intermediate nodes: pass through data_in
    wire fwd = on_path ? pe_out : data_in;

    assign dout_s = go_s ? fwd : 1'b0;
    assign dout_n = go_n ? fwd : 1'b0;
    assign dout_e = go_e ? fwd : 1'b0;
    assign dout_w = go_w ? fwd : 1'b0;

    assign vout_s = go_s;
    assign vout_n = go_n;
    assign vout_e = go_e;
    assign vout_w = go_w;

    assign dout_final = is_hop4 ? pe_out : 1'b0;

endmodule
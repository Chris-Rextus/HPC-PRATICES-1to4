module mesh_4x4 (
    input  wire        clock,
    input  wire        din_entry,
    input  wire [3:0]  hop1_addr, hop2_addr, hop3_addr, hop4_addr,
	 input wire hop1_max, hop2_max, hop3_max, hop4_max,
    output wire        dout_final
);

    // wires leste
    wire e_00, e_10, e_20;
    wire e_01, e_11, e_21;
    wire e_02, e_12, e_22;
    wire e_03, e_13, e_23;

    // wires sul
    wire s_00, s_10, s_20, s_30;
    wire s_01, s_11, s_21, s_31;
    wire s_02, s_12, s_22, s_32;

    // wires norte
    wire n_01, n_11, n_21, n_31;
    wire n_02, n_12, n_22, n_32;
    wire n_03, n_13, n_23, n_33;

    // wires válidos leste
    wire ve_00, ve_10, ve_20;
    wire ve_01, ve_11, ve_21;
    wire ve_02, ve_12, ve_22;
    wire ve_03, ve_13, ve_23;

    // wires validos sul
    wire vs_00, vs_10, vs_20, vs_30;
    wire vs_01, vs_11, vs_21, vs_31;
    wire vs_02, vs_12, vs_22, vs_32;

    // wires validos norte
    wire vn_01, vn_11, vn_21, vn_31;
    wire vn_02, vn_12, vn_22, vn_32;
    wire vn_03, vn_13, vn_23, vn_33;

    // wires de output
    wire r_00, r_10, r_20, r_30;
    wire r_01, r_11, r_21, r_31;
    wire r_02, r_12, r_22, r_32;
    wire r_03, r_13, r_23, r_33;

    mesh_node #(.MY_ADDR(4'b0000)) n00 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
			.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(1'b0), .din_s(n_01),  .din_e(e_10),  .din_w(1'b0),
        .vin_n(1'b0), .vin_s(vn_01), .vin_e(ve_10), .vin_w(1'b0),
        .dout_n(),    .dout_s(s_00), .dout_e(e_00), .dout_w(),
        .vout_n(),    .vout_s(vs_00),.vout_e(ve_00),.vout_w(),
        .dout_final(r_00)
    );

    mesh_node #(.MY_ADDR(4'b0100)) n10 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(1'b0), .din_s(n_11),  .din_e(e_20),  .din_w(e_00),
        .vin_n(1'b0), .vin_s(vn_11), .vin_e(ve_20), .vin_w(ve_00),
        .dout_n(),    .dout_s(s_10), .dout_e(e_10), .dout_w(),
        .vout_n(),    .vout_s(vs_10),.vout_e(ve_10),.vout_w(),
        .dout_final(r_10)
    );

    mesh_node #(.MY_ADDR(4'b1000)) n20 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(1'b0), .din_s(n_21),  .din_e(1'b0),  .din_w(e_10),
        .vin_n(1'b0), .vin_s(vn_21), .vin_e(1'b0),  .vin_w(ve_10),
        .dout_n(),    .dout_s(s_20), .dout_e(e_20), .dout_w(),
        .vout_n(),    .vout_s(vs_20),.vout_e(ve_20),.vout_w(),
        .dout_final(r_20)
    );

    mesh_node #(.MY_ADDR(4'b1100)) n30 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(1'b0), .din_s(n_31),  .din_e(1'b0),  .din_w(e_20),
        .vin_n(1'b0), .vin_s(vn_31), .vin_e(1'b0),  .vin_w(ve_20),
        .dout_n(),    .dout_s(s_30), .dout_e(),     .dout_w(),
        .vout_n(),    .vout_s(vs_30),.vout_e(),     .vout_w(),
        .dout_final(r_30)
    );

    mesh_node #(.MY_ADDR(4'b0001)) n01 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_00), .din_s(n_02),  .din_e(e_11),  .din_w(1'b0),
        .vin_n(vs_00),.vin_s(vn_02), .vin_e(ve_11), .vin_w(1'b0),
        .dout_n(n_01),.dout_s(s_01), .dout_e(e_01), .dout_w(),
        .vout_n(vn_01),.vout_s(vs_01),.vout_e(ve_01),.vout_w(),
        .dout_final(r_01)
    );

    mesh_node #(.MY_ADDR(4'b0101)) n11 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_10), .din_s(n_12),  .din_e(e_21),  .din_w(e_01),
        .vin_n(vs_10),.vin_s(vn_12), .vin_e(ve_21), .vin_w(ve_01),
        .dout_n(n_11),.dout_s(s_11), .dout_e(e_11), .dout_w(),
        .vout_n(vn_11),.vout_s(vs_11),.vout_e(ve_11),.vout_w(),
        .dout_final(r_11)
    );

    mesh_node #(.MY_ADDR(4'b1001)) n21 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_20), .din_s(n_22),  .din_e(1'b0),  .din_w(e_11),
        .vin_n(vs_20),.vin_s(vn_22), .vin_e(1'b0),  .vin_w(ve_11),
        .dout_n(n_21),.dout_s(s_21), .dout_e(e_21), .dout_w(),
        .vout_n(vn_21),.vout_s(vs_21),.vout_e(ve_21),.vout_w(),
        .dout_final(r_21)
    );

    mesh_node #(.MY_ADDR(4'b1101)) n31 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_30), .din_s(n_32),  .din_e(1'b0),  .din_w(e_21),
        .vin_n(vs_30),.vin_s(vn_32), .vin_e(1'b0),  .vin_w(ve_21),
        .dout_n(n_31),.dout_s(s_31), .dout_e(),     .dout_w(),
        .vout_n(vn_31),.vout_s(vs_31),.vout_e(),    .vout_w(),
        .dout_final(r_31)
    );

    mesh_node #(.MY_ADDR(4'b0010)) n02 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_01), .din_s(n_03),  .din_e(e_12),  .din_w(1'b0),
        .vin_n(vs_01),.vin_s(vn_03), .vin_e(ve_12), .vin_w(1'b0),
        .dout_n(n_02),.dout_s(s_02), .dout_e(e_02), .dout_w(),
        .vout_n(vn_02),.vout_s(vs_02),.vout_e(ve_02),.vout_w(),
        .dout_final(r_02)
    );

    mesh_node #(.MY_ADDR(4'b0110)) n12 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_11), .din_s(n_13),  .din_e(e_22),  .din_w(e_02),
        .vin_n(vs_11),.vin_s(vn_13), .vin_e(ve_22), .vin_w(ve_02),
        .dout_n(n_12),.dout_s(s_12), .dout_e(e_12), .dout_w(),
        .vout_n(vn_12),.vout_s(vs_12),.vout_e(ve_12),.vout_w(),
        .dout_final(r_12)
    );

    mesh_node #(.MY_ADDR(4'b1010)) n22 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_21), .din_s(n_23),  .din_e(1'b0),  .din_w(e_12),
        .vin_n(vs_21),.vin_s(vn_23), .vin_e(1'b0),  .vin_w(ve_12),
        .dout_n(n_22),.dout_s(s_22), .dout_e(e_22), .dout_w(),
        .vout_n(vn_22),.vout_s(vs_22),.vout_e(ve_22),.vout_w(),
        .dout_final(r_22)
    );

    mesh_node #(.MY_ADDR(4'b1110)) n32 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_31), .din_s(n_33),  .din_e(1'b0),  .din_w(e_22),
        .vin_n(vs_31),.vin_s(vn_33), .vin_e(1'b0),  .vin_w(ve_22),
        .dout_n(n_32),.dout_s(s_32), .dout_e(),     .dout_w(),
        .vout_n(vn_32),.vout_s(vs_32),.vout_e(),    .vout_w(),
        .dout_final(r_32)
    );

    mesh_node #(.MY_ADDR(4'b0011)) n03 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_02), .din_s(1'b0),  .din_e(e_13),  .din_w(1'b0),
        .vin_n(vs_02),.vin_s(1'b0),  .vin_e(ve_13), .vin_w(1'b0),
        .dout_n(n_03),.dout_s(),     .dout_e(e_03), .dout_w(),
        .vout_n(vn_03),.vout_s(),    .vout_e(ve_03),.vout_w(),
        .dout_final(r_03)
    );

    mesh_node #(.MY_ADDR(4'b0111)) n13 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_12), .din_s(1'b0),  .din_e(e_23),  .din_w(e_03),
        .vin_n(vs_12),.vin_s(1'b0),  .vin_e(ve_23), .vin_w(ve_03),
        .dout_n(n_13),.dout_s(),     .dout_e(e_13), .dout_w(),
        .vout_n(vn_13),.vout_s(),    .vout_e(ve_13),.vout_w(),
        .dout_final(r_13)
    );

    mesh_node #(.MY_ADDR(4'b1011)) n23 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_22), .din_s(1'b0),  .din_e(1'b0),  .din_w(e_13),
        .vin_n(vs_22),.vin_s(1'b0),  .vin_e(1'b0),  .vin_w(ve_13),
        .dout_n(n_23),.dout_s(),     .dout_e(e_23), .dout_w(),
        .vout_n(vn_23),.vout_s(),    .vout_e(ve_23),.vout_w(),
        .dout_final(r_23)
    );

    mesh_node #(.MY_ADDR(4'b1111)) n33 (
        .clock(clock),
        .hop1_addr(hop1_addr),.hop2_addr(hop2_addr),
        .hop3_addr(hop3_addr),.hop4_addr(hop4_addr),
		  .hop1_max(hop1_max),.hop2_max(hop2_max),
.hop3_max(hop3_max),.hop4_max(hop4_max),
        .din_entry(din_entry),
        .din_n(s_32), .din_s(1'b0),  .din_e(1'b0),  .din_w(e_23),
        .vin_n(vs_32),.vin_s(1'b0),  .vin_e(1'b0),  .vin_w(ve_23),
        .dout_n(n_33),.dout_s(),     .dout_e(),     .dout_w(),
        .vout_n(vn_33),.vout_s(),    .vout_e(),     .vout_w(),
        .dout_final(r_33)
    );

    assign dout_final =
        r_00 | r_10 | r_20 | r_30 |
        r_01 | r_11 | r_21 | r_31 |
        r_02 | r_12 | r_22 | r_32 |
        r_03 | r_13 | r_23 | r_33;

endmodule
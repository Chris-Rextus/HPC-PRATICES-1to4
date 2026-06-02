// Copyright (C) 2025  Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Altera and sold by Altera or its authorized distributors.  Please
// refer to the Altera Software License Subscription Agreements 
// on the Quartus Prime software download page.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 24.1std.0 Build 1077 03/04/2025 SC Lite Edition"
// CREATED		"Mon May 18 05:21:57 2026"

module vga_filtro(
	CLOCK_50,
	SW,
	VGA_HS,
	VGA_VS,
	vga_clk,
	VGA_B,
	VGA_G,
	VGA_R
);


input wire	CLOCK_50;
input wire	[1:0] SW;
output wire	VGA_HS;
output wire	VGA_VS;
output wire	vga_clk;
output wire	[7:7] VGA_B;
output wire	[7:7] VGA_G;
output wire	[7:7] VGA_R;

wire	[19:0] a;
wire	clk2;
wire	img1;
wire	img2;
wire	img2_gated;
wire	img3;
wire	mask;
wire	on;
wire	pclk;
wire	smux;
wire	smux_1;
wire	[14:0] SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	[3:0] SYNTHESIZED_WIRE_5;
wire	[3:0] SYNTHESIZED_WIRE_6;
wire	[3:0] SYNTHESIZED_WIRE_7;
wire	[3:0] SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_12;





modulo_borda	b2v_inst(
	.clock(pclk),
	.shiftin(img2),
	.out(img3));


concatenador	b2v_inst1(
	.a(a[19:10]),
	.b(a[9:0]),
	.y(SYNTHESIZED_WIRE_0));


mux_img	b2v_inst13(
	.data1(img1),
	.data0(img2_gated),
	.sel(SW[0]),
	.result(smux_1));


mux_img	b2v_inst14(
	.data1(img3),
	.data0(smux_1),
	.sel(SW[1]),
	.result(smux));


rom	b2v_inst3(
	.clock(clk2),
	.address(SYNTHESIZED_WIRE_0),
	.q(img1));


mascara_janela	b2v_inst4(
	.pixel_column(a[9:0]),
	.pixel_row(a[19:10]),
	.video_out(mask));

assign	img2_gated = img2 & mask & on;


noc_controller	b2v_inst6(
	.hop1_max(SYNTHESIZED_WIRE_1),
	.hop2_max(SYNTHESIZED_WIRE_2),
	.hop3_max(SYNTHESIZED_WIRE_3),
	.hop4_max(SYNTHESIZED_WIRE_4),
	.hop1_addr(SYNTHESIZED_WIRE_5),
	.hop2_addr(SYNTHESIZED_WIRE_6),
	.hop3_addr(SYNTHESIZED_WIRE_7),
	.hop4_addr(SYNTHESIZED_WIRE_8));

assign	clk2 = mask & pclk & on;


mesh_4x4	b2v_inst9(
	.clock(clk2),
	.din_entry(img1),
	.hop1_max(SYNTHESIZED_WIRE_1),
	.hop2_max(SYNTHESIZED_WIRE_2),
	.hop3_max(SYNTHESIZED_WIRE_3),
	.hop4_max(SYNTHESIZED_WIRE_4),
	.hop1_addr(SYNTHESIZED_WIRE_5),
	.hop2_addr(SYNTHESIZED_WIRE_6),
	.hop3_addr(SYNTHESIZED_WIRE_7),
	.hop4_addr(SYNTHESIZED_WIRE_8),
	.dout_final(img2));

assign	SYNTHESIZED_WIRE_12 = mask & on & smux;


VGA_SYNC	b2v_vga(
	.clock_50Mhz(CLOCK_50),
	.red(SYNTHESIZED_WIRE_12),
	.green(SYNTHESIZED_WIRE_12),
	.blue(SYNTHESIZED_WIRE_12),
	.red_out(VGA_R),
	.green_out(VGA_G),
	.blue_out(VGA_B),
	.horiz_sync_out(VGA_HS),
	.vert_sync_out(VGA_VS),
	.video_on(on),
	.pixel_clock(pclk),
	.pixel_column(a[9:0]),
	.pixel_row(a[19:10]));

assign	vga_clk = pclk;

endmodule

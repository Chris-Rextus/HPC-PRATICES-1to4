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
// CREATED		"Sun May 17 13:41:28 2026"

module vga_filtro(
	CLOCK_50,
	KEY,
	SW,
	VGA_HS,
	VGA_VS,
	vga_clk,
	VGA_B,
	VGA_G,
	VGA_R
);


input wire	CLOCK_50;
input wire	[1:0] KEY;
input wire	[1:0] SW;
output wire	VGA_HS;
output wire	VGA_VS;
output wire	vga_clk;
output wire	[7:7] VGA_B;
output wire	[7:7] VGA_G;
output wire	[7:7] VGA_R;

wire	[19:0] a;
wire	[14:0] addr;
wire	clk;
wire	data;
wire	manual_pulse;
wire	mode_button;
wire	mode_switch_1;
wire	on;
wire	pclk;
wire	pulse_out;
wire	reset;
wire	temp2;
wire	temp3;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[4095:0] SYNTHESIZED_WIRE_2;




assign	reset =  ~KEY[0];


button_pulse	b2v_inst1(
	.clk(clk),
	.btn(mode_button),
	.pulse(manual_pulse));


GameOfLife2	b2v_inst11(
	.clk(clk),
	.reset(reset),
	.update_pulse(pulse_out),
	.use_hardcoded(SW[0]),
	.rom_q(data),
	.current_grid(SYNTHESIZED_WIRE_2),
	.rom_addr(addr));

assign	temp3 = SYNTHESIZED_WIRE_0 & SYNTHESIZED_WIRE_1 & on;


LifeToVGAMono2	b2v_inst13(
	.grid(SYNTHESIZED_WIRE_2),
	.pixel_column(a[9:0]),
	.pixel_row(a[19:10]),
	.pixel_out(SYNTHESIZED_WIRE_0),
	.pixel_enable(SYNTHESIZED_WIRE_1));


clock_divider	b2v_inst2(
	.clk(clk),
	.update_pulse(temp2));


pulse_mux	b2v_inst4(
	.auto_pulse(temp2),
	.manual_pulse(manual_pulse),
	.sel(mode_switch_1),
	.pulse_out(pulse_out));


rom	b2v_inst9(
	.clock(clk),
	.address(addr),
	.q(data));


VGA_SYNC	b2v_vga(
	.clock_50Mhz(clk),
	.red(temp3),
	.green(temp3),
	.blue(temp3),
	.red_out(VGA_R),
	.green_out(VGA_G),
	.blue_out(VGA_B),
	.horiz_sync_out(VGA_HS),
	.vert_sync_out(VGA_VS),
	.video_on(on),
	.pixel_clock(pclk),
	.pixel_column(a[9:0]),
	.pixel_row(a[19:10]));

assign	clk = CLOCK_50;
assign	mode_switch_1 = SW[1];
assign	vga_clk = pclk;
assign	mode_button = KEY[1];

endmodule

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
// CREATED		"Sun May 17 22:51:59 2026"

module modulo_sal_e_pimenta(
	clock,
	shiftin,
	max_bit,
	min_bit
);


input wire	clock;
input wire	shiftin;
output wire	max_bit;
output wire	min_bit;

wire	[255:0] q1;
wire	[255:0] q2;
wire	[2:0] q3;





shift_register	b2v_inst(
	.clock(clock),
	.shiftin(shiftin),
	.q(q1));


shift_register	b2v_inst1(
	.clock(clock),
	.shiftin(q1[0]),
	.q(q2));


max_min_9bits	b2v_inst2(
	.in1(q1[255:253]),
	.in2(q2[255:253]),
	.in3(q3),
	.max_bit(max_bit),
	.min_bit(min_bit));


shift_3	b2v_inst5(
	.clock(clock),
	.shiftin(q2[0]),
	.q(q3));


endmodule

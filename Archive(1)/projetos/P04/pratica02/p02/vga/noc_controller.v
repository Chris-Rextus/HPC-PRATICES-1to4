module noc_controller (
    output wire [3:0] hop1_addr,
    output wire [3:0] hop2_addr,
    output wire [3:0] hop3_addr,
    output wire [3:0] hop4_addr,
    output wire       hop1_max,
    output wire       hop2_max,
    output wire       hop3_max,
    output wire       hop4_max
);
	// Coluna Vertical
	//assign hop1_addr = 4'b0100;  assign hop1_max = 1'b1; // n10 col=1,row=0
	//assign hop2_addr = 4'b0101;  assign hop2_max = 1'b0; // n11 col=1,row=1
	//assign hop3_addr = 4'b0110;  assign hop3_max = 1'b0; // n12 col=1,row=2
	//assign hop4_addr = 4'b0111;  assign hop4_max = 1'b1; // n13 col=1,row=3
	
	// Quatro juntos no topo
	//assign hop1_addr = 4'b0000;  assign hop1_max = 1'b1; // n00 MAX
   //assign hop2_addr = 4'b0001;  assign hop2_max = 1'b0; // n01 MIN
   //assign hop3_addr = 4'b0101;  assign hop3_max = 1'b0; // n11 MIN
   //assign hop4_addr = 4'b0110;  assign hop4_max = 1'b1; // n12 MAX
	
	// Diagonal
	assign hop1_addr = 4'b0101;  assign hop1_max = 1'b1; // n11 col=1,row=1
	assign hop2_addr = 4'b0110;  assign hop2_max = 1'b0; // n12 col=1,row=2
	assign hop3_addr = 4'b1010;  assign hop3_max = 1'b0; // n22 col=2,row=2
	assign hop4_addr = 4'b1011;  assign hop4_max = 1'b1; // n23 col=2,row=3
endmodule
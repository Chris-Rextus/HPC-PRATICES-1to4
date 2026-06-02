module xy_network #(
    parameter [3:0] MY_ADDR = 4'b0000
)(
    input  wire        clock,
    input  wire [3:0]  target_addr,
    input  wire        use_max,

    input  wire        din_local,

    input  wire        din_n,
    input  wire        din_s,
    input  wire        din_e,
    input  wire        din_w,

    output reg         dout_n,
    output reg         dout_s,
    output reg         dout_e,
    output reg         dout_w,

    output wire        pe_feed,
    output wire        pe_we,
    input  wire        pe_max,
    input  wire        pe_min,

    output wire        dout_result
);

    wire [1:0] my_x  = MY_ADDR[3:2];
    wire [1:0] my_y  = MY_ADDR[1:0];
    wire [1:0] tgt_x = target_addr[3:2];
    wire [1:0] tgt_y = target_addr[1:0];

    wire is_target = (MY_ADDR == target_addr);

    // When routing, pick which neighbor carries data toward target
    wire sel_din = (tgt_x > my_x) ? din_w :
                   (tgt_x < my_x) ? din_e :
                   (tgt_y > my_y) ? din_n :
                   (tgt_y < my_y) ? din_s :
                                    din_local;

    // PE is fed continuously when this node is the target
    assign pe_feed  = din_local;
    assign pe_we    = is_target;

    // Result is combinational — always valid when target
    assign dout_result = is_target ? (use_max ? pe_max : pe_min) : 1'b0;

    // Routing outputs — registered
    always @(posedge clock) begin
        dout_n <= 1'b0;
        dout_s <= 1'b0;
        dout_e <= 1'b0;
        dout_w <= 1'b0;

        if (!is_target) begin
            if      (tgt_x > my_x) dout_e <= sel_din;
            else if (tgt_x < my_x) dout_w <= sel_din;
            else if (tgt_y > my_y) dout_s <= sel_din;
            else                   dout_n <= sel_din;
        end
    end

endmodule
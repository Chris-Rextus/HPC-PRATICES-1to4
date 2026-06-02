module router_xy #(
    parameter [3:0] MY_ADDR = 4'b0000
)(
    input  wire        clock,

    // Config phase
    input  wire        cfg_valid,
    input  wire        cfg_active,
    input  wire [3:0]  cfg_addr,
    input  wire        cfg_use_max,
    input  wire [2:0]  cfg_dir_in,
    input  wire [2:0]  cfg_dir_out,

    // Data phase
    input  wire        data_start,
    input  wire        din_local,
    input  wire        din_n,
    input  wire        din_s,
    input  wire        din_e,
    input  wire        din_w,

    // From local PE
    input  wire        pe_max,
    input  wire        pe_min,

    // Outputs
    output reg         dout_n,
    output reg         dout_s,
    output reg         dout_e,
    output reg         dout_w,
    output reg         dout_pe,
    output reg         dout_result
);

    // Latched config
    reg        r_active;
    reg        r_use_max;
    reg [2:0]  r_dir_in;
    reg [2:0]  r_dir_out;

    always @(posedge clock) begin
        if (cfg_valid && cfg_addr == MY_ADDR) begin
            r_active   <= cfg_active;
            r_use_max  <= cfg_use_max;
            r_dir_in   <= cfg_dir_in;
            r_dir_out  <= cfg_dir_out;
        end
    end

    // Select input data based on latched dir_in
    wire sel_din = (r_dir_in == 3'd0) ? din_local :
                   (r_dir_in == 3'd1) ? din_n     :
                   (r_dir_in == 3'd2) ? din_s     :
                   (r_dir_in == 3'd3) ? din_e     :
                                        din_w;

    wire pe_out = r_use_max ? pe_max : pe_min;

    always @(posedge clock) begin
        dout_n      <= 1'b0;
        dout_s      <= 1'b0;
        dout_e      <= 1'b0;
        dout_w      <= 1'b0;
        dout_pe     <= 1'b0;
        dout_result <= 1'b0;

        if (data_start) begin
            if (r_active) begin
                dout_pe <= sel_din;

                case (r_dir_out)
                    3'd0: dout_result <= pe_out;
                    3'd1: dout_n      <= pe_out;
                    3'd2: dout_s      <= pe_out;
                    3'd3: dout_e      <= pe_out;
                    3'd4: dout_w      <= pe_out;
                    default: ;
                endcase

            end else begin
                // Pass-through: forward sel_din to r_dir_out
                case (r_dir_out)
                    3'd1: dout_n <= sel_din;
                    3'd2: dout_s <= sel_din;
                    3'd3: dout_e <= sel_din;
                    3'd4: dout_w <= sel_din;
                    default: ;
                endcase
            end
        end
    end

endmodule
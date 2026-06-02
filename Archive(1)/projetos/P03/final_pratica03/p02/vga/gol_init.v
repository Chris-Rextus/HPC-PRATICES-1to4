module gol_init (
    input clk,
    input reset,
    output reg [4095:0] init_grid,
    output reg done
);
    reg [11:0] addr;
    wire rom_q;

    rom rom0 (
        .clock(clk),
        .address({3'b000, addr}),
        .q(rom_q)
    );

    always @(posedge clk) begin
        if (reset) begin
            addr <= 0;
            done <= 0;
        end else if (!done) begin
            init_grid[addr] <= rom_q;
            if (addr == 12'd4095) done <= 1;
            else addr <= addr + 1;
        end
    end
endmodule
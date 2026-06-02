module GameOfLife2 (
    input clk,
    input reset,
    input update_pulse,
    input use_hardcoded,
    input rom_q,
    output reg [14:0] rom_addr,
    output reg [4095:0] current_grid
);
    integer i, j, l, c, count;
    reg [4095:0] next;
    reg [11:0] load_addr;
    reg loading;

    task set_hardcoded;
    begin
        current_grid = 0;
        // Gosper Glider Gun
        current_grid[10*64 + 24] = 1;
        current_grid[11*64 + 22] = 1; current_grid[11*64 + 24] = 1;
        current_grid[12*64 + 12] = 1; current_grid[12*64 + 13] = 1;
        current_grid[12*64 + 20] = 1; current_grid[12*64 + 21] = 1;
        current_grid[12*64 + 34] = 1; current_grid[12*64 + 35] = 1;
        current_grid[13*64 + 11] = 1; current_grid[13*64 + 15] = 1;
        current_grid[13*64 + 20] = 1; current_grid[13*64 + 21] = 1;
        current_grid[13*64 + 34] = 1; current_grid[13*64 + 35] = 1;
        current_grid[14*64 + 0]  = 1; current_grid[14*64 + 1]  = 1;
        current_grid[14*64 + 10] = 1; current_grid[14*64 + 16] = 1;
        current_grid[14*64 + 20] = 1; current_grid[14*64 + 21] = 1;
        current_grid[15*64 + 0]  = 1; current_grid[15*64 + 1]  = 1;
        current_grid[15*64 + 10] = 1; current_grid[15*64 + 14] = 1;
        current_grid[15*64 + 16] = 1; current_grid[15*64 + 17] = 1;
        current_grid[15*64 + 22] = 1; current_grid[15*64 + 24] = 1;
        current_grid[16*64 + 10] = 1; current_grid[16*64 + 16] = 1;
        current_grid[17*64 + 11] = 1; current_grid[17*64 + 15] = 1;
        current_grid[18*64 + 12] = 1; current_grid[18*64 + 13] = 1;
        current_grid[19*64 + 22] = 1; current_grid[19*64 + 24] = 1;
        current_grid[20*64 + 23] = 1;
    end
    endtask

    initial begin
        set_hardcoded;
        loading = 0;
        load_addr = 0;
        rom_addr = 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            loading <= ~use_hardcoded;
            load_addr <= 0;
            rom_addr <= 0;
            if (use_hardcoded) begin
                current_grid <= 0;
                current_grid[10*64 + 24] <= 1;
                current_grid[11*64 + 22] <= 1; current_grid[11*64 + 24] <= 1;
                current_grid[12*64 + 12] <= 1; current_grid[12*64 + 13] <= 1;
                current_grid[12*64 + 20] <= 1; current_grid[12*64 + 21] <= 1;
                current_grid[12*64 + 34] <= 1; current_grid[12*64 + 35] <= 1;
                current_grid[13*64 + 11] <= 1; current_grid[13*64 + 15] <= 1;
                current_grid[13*64 + 20] <= 1; current_grid[13*64 + 21] <= 1;
                current_grid[13*64 + 34] <= 1; current_grid[13*64 + 35] <= 1;
                current_grid[14*64 + 0]  <= 1; current_grid[14*64 + 1]  <= 1;
                current_grid[14*64 + 10] <= 1; current_grid[14*64 + 16] <= 1;
                current_grid[14*64 + 20] <= 1; current_grid[14*64 + 21] <= 1;
                current_grid[15*64 + 0]  <= 1; current_grid[15*64 + 1]  <= 1;
                current_grid[15*64 + 10] <= 1; current_grid[15*64 + 14] <= 1;
                current_grid[15*64 + 16] <= 1; current_grid[15*64 + 17] <= 1;
                current_grid[15*64 + 22] <= 1; current_grid[15*64 + 24] <= 1;
                current_grid[16*64 + 10] <= 1; current_grid[16*64 + 16] <= 1;
                current_grid[17*64 + 11] <= 1; current_grid[17*64 + 15] <= 1;
                current_grid[18*64 + 12] <= 1; current_grid[18*64 + 13] <= 1;
                current_grid[19*64 + 22] <= 1; current_grid[19*64 + 24] <= 1;
                current_grid[20*64 + 23] <= 1;
            end else
                current_grid <= 0;
        end else if (loading) begin
            if (load_addr > 0)
                current_grid[load_addr - 1] <= rom_q;
            rom_addr <= {3'b000, load_addr};
            if (load_addr == 12'd4095) begin
                current_grid[4094] <= rom_q;
                loading <= 0;
            end else
                load_addr <= load_addr + 1;
        end else if (update_pulse) begin
            next = 0;
            for (i = 0; i < 64; i = i + 1) begin
                next[i*64 + 0]  = current_grid[i*64 + 0];
                next[i*64 + 63] = current_grid[i*64 + 63];
            end
            for (j = 0; j < 64; j = j + 1) begin
                next[0*64 + j]  = current_grid[0*64 + j];
                next[63*64 + j] = current_grid[63*64 + j];
            end
            for (i = 1; i < 63; i = i + 1) begin
                for (j = 1; j < 63; j = j + 1) begin
                    count = 0;
                    for (l = 0; l < 3; l = l + 1)
                        for (c = 0; c < 3; c = c + 1)
                            if (!(l == 1 && c == 1))
                                count = count + current_grid[(i+l-1)*64 + (j+c-1)];
                    if (current_grid[i*64 + j])
                        next[i*64 + j] = (count==2 || count==3) ? 1'b1 : 1'b0;
                    else
                        next[i*64 + j] = (count==3) ? 1'b1 : 1'b0;
                end
            end
            current_grid <= next;
        end
    end
endmodule
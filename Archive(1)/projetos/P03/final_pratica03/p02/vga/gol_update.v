module gol_update (
    input clk,
    input update_pulse,
    input [4095:0] current_grid,
    output reg [4095:0] next_grid
);
    integer i, j, l, c;
    integer count;

    always @(posedge clk) begin
    // bordas
    for (i = 0; i < 64; i = i + 1) begin
        next_grid[i*64 + 0]  <= current_grid[i*64 + 0];
        next_grid[i*64 + 63] <= current_grid[i*64 + 63];
    end
    for (j = 0; j < 64; j = j + 1) begin
        next_grid[0*64 + j]  <= current_grid[0*64 + j];
        next_grid[63*64 + j] <= current_grid[63*64 + j];
    end
    // interior
    for (i = 1; i < 63; i = i + 1) begin
        for (j = 1; j < 63; j = j + 1) begin
            count = 0;
            for (l = 0; l < 3; l = l + 1)
                for (c = 0; c < 3; c = c + 1)
                    if (!(l == 1 && c == 1))
                        count = count + current_grid[(i+l-1)*64 + (j+c-1)];
            if (current_grid[i*64 + j])
                next_grid[i*64 + j] <= (count==2 || count==3) ? 1'b1 : 1'b0;
            else
                next_grid[i*64 + j] <= (count==3) ? 1'b1 : 1'b0;
        end
    end
end
endmodule
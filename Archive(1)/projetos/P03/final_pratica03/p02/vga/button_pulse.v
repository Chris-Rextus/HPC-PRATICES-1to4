module button_pulse (
    input  clk,
    input  btn,    // active low (KEY on DE1)
    output pulse   // one-cycle high on press
);
    reg btn_prev;

    always @(posedge clk)
        btn_prev <= btn;

    // KEY is active-low: btn falls 1->0 when pressed
    // falling edge = prev was high, now low
    assign pulse = btn_prev & ~btn;

endmodule
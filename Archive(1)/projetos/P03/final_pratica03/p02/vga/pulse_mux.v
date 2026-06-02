module pulse_mux (
    input  auto_pulse,   // from clock_divider
    input  manual_pulse, // from button_pulse
    input  sel,          // SW[1]: 0 = auto, 1 = manual
    output pulse_out     // goes to GameOfLife2 update_pulse
);
    assign pulse_out = sel ? manual_pulse : auto_pulse;

endmodule
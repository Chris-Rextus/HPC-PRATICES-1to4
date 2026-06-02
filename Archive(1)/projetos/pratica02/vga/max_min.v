module max_min_9bits (
    input  [2:0] in1,
    input  [2:0] in2,
    input  [2:0] in3,
    output reg max_bit,
    output reg min_bit
);

    integer i;
    reg [8:0] all_bits;

    always @(*) begin
        // Concatenar todos os bits em um único vetor
        all_bits = {in1, in2, in3};

        // Inicialização
        max_bit = all_bits[0];
        min_bit = all_bits[0];

        // Percorrer todos os 9 bits
        for (i = 1; i < 9; i = i + 1) begin
            if (all_bits[i] > max_bit)
                max_bit = all_bits[i];

            if (all_bits[i] < min_bit)
                min_bit = all_bits[i];
        end
    end

endmodule
module clk_div(
    input wire clk_in,
    input wire rstn,
    output reg clk_out
);
    parameter DIVISOR = 50_000_000; // 50 MHz para 1 Hz
    reg [25:0] count = 0;           // Tamaño para 50M

    always @(posedge clk_in, negedge rstn) begin
        if (!rstn) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            if (count == DIVISOR/2 - 1) begin
                clk_out <= ~clk_out;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule

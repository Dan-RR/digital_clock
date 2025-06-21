module digital_clock(
    input wire clk,         // Señal de reloj
    input wire rstn,        // Señal de reset
    input wire start_stop,  // Señal de activación
    output wire [6:0] hex0, // Unidades de segundo
    output wire [6:0] hex1, // Decenas de segundo
    output wire [6:0] hex2, // Unidades de minuto
    output wire [6:0] hex3  // Decenas de minuto
);

wire clk_signal;        //  Señal de reloj para uso
reg running = 0;        //
reg prev_start_stop = 0;//  

/* Genera una señal de reloj a partir del reloj base
y un parámetro de conteo de ciclos de reloj*/
clk_div clk_div_1 (
    .clk_in(clk),       //  Entra la señal del reloj original
    .rstn(rstn),        //  Señal de reset
    .clk_out(clk_signal)//  Señal de frecuencia reducida
);

/* Lógica de control de pausa/reanudar
El inicio no está anclado a la señal de reloj lenta
usada en el conteo de segundos */
always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
        running <= 0;
        prev_start_stop <= 0;
    end else begin
        if (start_stop && ~prev_start_stop)
            running <= ~running;
        prev_start_stop <= start_stop;
    end
end

// Registros para segundos y minutos
reg [5:0] seconds = 0;
reg [5:0] minutes = 0;

always @(posedge clk_signal, negedge rstn) begin
    if (!rstn) begin
        seconds <= 0;
        minutes <= 0;
    end else if (running) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59)
                minutes <= 0;
            else
                minutes <= minutes + 1;
        end else begin
            seconds <= seconds + 1;
        end
    end
end

// Conversión a dígitos BCD
wire [3:0] sec_units = seconds % 10;
wire [3:0] sec_tens  = seconds / 10;
wire [3:0] min_units = minutes % 10;
wire [3:0] min_tens  = minutes / 10;

// Decodificadores BCD a 7 segmentos
bcd_to_7seg bcd0 (.bcd(sec_units), .seg(hex0)); // segundos unidades
bcd_to_7seg bcd1 (.bcd(sec_tens),  .seg(hex1)); // segundos decenas
bcd_to_7seg bcd2 (.bcd(min_units), .seg(hex2)); // minutos unidades
bcd_to_7seg bcd3 (.bcd(min_tens),  .seg(hex3)); // minutos decenas

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2025 20:59:38
// Design Name: 
// Module Name: digital_clock_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module digital_clock_tb;
    
	// Datos
	reg clk;
	reg rstn;
	reg start_stop;
	wire [6:0] hex0, hex1, hex2, hex3;
 
	// Generador de cilos de reloj
	always #1 clk = ~clk;
	
	// Valores iniciales de entrada
	initial clk = 0;
	initial rstn = 1;
	
	initial start_stop = 0;
 
	// Finaliza en...
	initial begin
		#1000;
		$finish;
	end
 
	// Generación de estimulos
	initial begin
		#2;
		rstn <= 0;
		#2;
		rstn <= 1;
		#2;
		start_stop <= 1;
		#50;
		start_stop <= 0;
		#20;
		start_stop <= 1;
		#20;
		start_stop <= 0;
		#50;
		rstn <= 0;
		#2;
		rstn <= 1;
		#2;
		start_stop <= 1;
	end
 
	// Instance
	digital_clock DUT (
		.clk(clk),
		.rstn(rstn),
		.start_stop(start_stop),
		.hex0(hex0),
		.hex1(hex1),
		.hex2(hex2),
		.hex3(hex3)
	);
endmodule

module simon
(
	input logic clk,
	input logic rst,
	input logic ps2_data,
	input logic ps2_clk,
	output logic [6:0] hex0,
	output logic [6:0] hex1,
	output logic [6:0] hex2,
	output logic [6:0] hex3,
	output logic hsync,
	output logic vsync,
	output logic [3:0] red,
	output logic [3:0] green,
	output logic [3:0] blue
	);
	
	logic btn_pulse;
	logic [7:0] btn_code;
	logic start_btn;
	logic [7:0] round;
	logic [1:0] color;
	logic red_btn;
	logic green_btn;
	logic blue_btn;
	logic yellow_btn;
	logic color_en;


always_comb begin
	if (btn_code == 8'h5A && btn_pulse == 1'b1) begin
		start_btn = 1'b1;
	end else begin
		start_btn = 1'b0;
	end
end
always_comb begin
	red_btn = 1'b0;
	green_btn = 1'b0;
	blue_btn = 1'b0;
	yellow_btn = 1'b0;
	if (btn_code == 8'h2D && btn_pulse == 1'b1) begin
		red_btn = 1'b1;
	end else if (btn_code == 8'h34 && btn_pulse == 1'b1) begin
		green_btn = 1'b1;
	end else if (btn_code == 8'h32 && btn_pulse == 1'b1) begin
		blue_btn = 1'b1;
	end else if (btn_code == 8'h35 && btn_pulse == 1'b1) begin
		yellow_btn = 1'b1;
	end
end
ps2
ps2_inst
	(.clk (clk),
	 .rst (rst),
	 .ps2_data (ps2_data),
	 .ps2_clk (ps2_clk),
	 .btn_pulse (btn_pulse),
	 .btn_code (btn_code)
	 );
	 
hex_disp_dec
hex_inst0
	(
	.en (1'b1),
	.hex_in (btn_code [3:0]),
	.seg_out (hex2)
	);

hex_disp_dec
hex_inst1
	(
	.en (1'b1),
	.hex_in (btn_code [7:4]),
	.seg_out (hex3)
	);
core
core_inst
(
	.clk (clk),
	.rst (rst),
	.start_btn (start_btn),
	.round (round),
	.color (color),
	.red_btn (red_btn),
	.green_btn (green_btn),
	.blue_btn (blue_btn),
	.yellow_btn (yellow_btn),
	.color_en (color_en)
	);
hex_disp_dec
hex_round
	(
	.en (1'b1),
	.hex_in (round[3:0]),
	.seg_out (hex1)
	);
hex_disp_dec
hex_color
	(
	.en (color_en),
	.hex_in ({2'b00,color}),
	.seg_out (hex0)
	);
vga
vga_inst
	(
	.clk (clk),
	.rst (rst),
	.hsync (hsync),
	.vsync (vsync),
	.red (red),
	.green (green),
	.blue (blue),
	.en (color_en),
	.color (color)
	);

	
endmodule
	
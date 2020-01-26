module hex_disp_dec
(
	input  logic      en,
	input  logic[3:0] hex_in,
	output logic[6:0] seg_out
);

logic[6:0] seg_tmp;

always_comb begin
	case(hex_in)
		4'h0 : seg_tmp = 7'b1000000; //to display 0
		4'h1 : seg_tmp = 7'b1111001; //to display 1
		4'h2 : seg_tmp = 7'b0100100; //to display 2
		4'h3 : seg_tmp = 7'b0110000; //to display 3
		4'h4 : seg_tmp = 7'b0011001; //to display 4
		4'h5 : seg_tmp = 7'b0010010; //to display 5
		4'h6 : seg_tmp = 7'b0000010; //to display 6
		4'h7 : seg_tmp = 7'b1111000; //to display 7
		4'h8 : seg_tmp = 7'b0000000; //to display 8
		4'h9 : seg_tmp = 7'b0010000; //to display 9

		4'hA : seg_tmp = 7'b0001000; //to display A
		4'hB : seg_tmp = 7'b0000011; //to display b
		4'hC : seg_tmp = 7'b1000110; //to display C
		4'hD : seg_tmp = 7'b0100001; //to display d
		4'hE : seg_tmp = 7'b0000110; //to display E
		4'hF : seg_tmp = 7'b0101110; //to display F
		default : seg_tmp = 7'b0111111; //dash
	endcase
end

assign seg_out = en ? seg_tmp : 7'b111_1111;

endmodule

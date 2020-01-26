module counter
(
	input  logic 	clk,
	input  logic 	rstn,
	input  logic 	en,
	input  logic 	rst_sync,
	output int	 	cnt_val
);

always_ff @(posedge clk, negedge rstn) begin
	if (!rstn) begin
		cnt_val <= 0;
	end else begin
		if (rst_sync) begin
			cnt_val <= 0;
		end else if (en) begin
			cnt_val <= cnt_val+1;
		end
	end
end

endmodule

module ps2 (
input logic clk,
input logic rst,
input logic ps2_data,
input logic ps2_clk,
output logic btn_pulse,
output logic [7:0] btn_code);

logic [1:0] ps2_data_r;
logic [1:0] ps2_clk_r;
logic [1:0] key_seq3;
always @(posedge clk or negedge rst)
begin
  if (!rst) begin
    ps2_data_r<= 2'b00;
    ps2_clk_r<= 2'b00;
  end
  else begin
    ps2_data_r <= {ps2_data_r[0],ps2_data};
    ps2_clk_r  <= {ps2_clk_r[0],ps2_clk};
  end
 end

logic key_cnt_en;
logic key_cnt_rst;
int key_count;

assign key_cnt_en = (ps2_clk_r == 2'b10) ? 1'b1 : 1'b0;
assign key_cnt_rst = (key_count == 4'b1011) ? 1'b1 : 1'b0;

 counter
 count
 (.clk (clk),
  .rstn (rst),
  .en (key_cnt_en),
  .rst_sync (key_cnt_rst),
  .cnt_val (key_count)
  );

logic [10:0] key_reg;


always_ff @ (posedge clk or negedge rst) begin
  if (!rst) begin
    btn_pulse <= 1'b0;
	 key_seq3 <= 2'b00;
	 
  end else begin
    if (key_cnt_en) begin
      key_reg <= {ps2_data_r[1], key_reg [10:1]};
    end
    if (key_cnt_rst) begin
		key_seq3 <= (key_seq3 == 2'b10) ? 0 : key_seq3 +1;
		if (key_seq3 == 2'b10) begin
			btn_pulse <= 1'b1;
			btn_code <= key_reg[8:1];
		end
    end else begin
      btn_pulse <= 1'b0;
    end
  end
  end
endmodule

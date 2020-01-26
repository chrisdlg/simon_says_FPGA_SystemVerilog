module core (
	input logic clk,
	input logic rst,
	input logic start_btn,
	output logic [7:0] round,
	output logic [1:0] color,
	input logic red_btn,
	input logic green_btn,
	input logic blue_btn,
	input logic yellow_btn,
	output logic color_en
	);
	
	int rnd_color;
	logic any_btn;
	assign any_btn = red_btn | green_btn | blue_btn | yellow_btn;
	logic [1:0] btn_pressed;
	logic [7:0] player_round;
	logic [1:0] blink_btn;
	logic blink_en;
	int blink_timer;
	
//assign buttons with code
	
always_comb begin
	if (red_btn) begin
		btn_pressed = 2'b00;
	end else if (green_btn) begin
		btn_pressed = 2'b01;
	end else if (blue_btn) begin
		btn_pressed = 2'b10;
	end else if (yellow_btn) begin
		btn_pressed = 2'b11;
	end else	begin
		btn_pressed = 2'b11;
	end
end	 
	
	
typedef enum
{
	IDLE, GETCOLOR, SEQUENCE, PLAYER
} state_t;

state_t state;
state_t next_state;

always_ff @ (posedge clk or negedge rst) begin
	if (!rst) begin
		state <= IDLE;
	end else begin
		state <= next_state;
	end
end

logic [250:0] [1:0] memory;

//vazw sto memory to xor diaforwn bit tou ran_color

always_ff @ (posedge clk) begin
	if (state== GETCOLOR) begin
		//memory [round] <= {rnd_color[9] ^ rnd_color[5],rnd_color[8] ^ rnd_color[3]};
		memory [round] <= {rnd_color[1],rnd_color[0]}; 
	end
end

logic end_round;
logic success;
logic fail;
logic [1:0] exp_color;
assign exp_color = memory[player_round];
localparam int TIMEOUT = 50000000;
int seq_count;
int time_count;

always_comb begin
	success = 1'b0;
	fail = 1'b0;
	if (blink_timer == 25000000) begin
		if (exp_color == blink_btn) begin
			success= 1'b1;
		end else begin		
			fail = 1'b1;		
		end
	end
end

always_comb begin
	if (state == SEQUENCE && time_count == TIMEOUT && seq_count == (round-1)) begin
		end_round = 1'b1;
	end else begin
		end_round = 1'b0;
	end
end

always_comb begin
	next_state = state;
	case (state)
		IDLE: begin
			if (start_btn) begin
				next_state = GETCOLOR;
			end
		end
		GETCOLOR: begin
			next_state = SEQUENCE;
		end
		SEQUENCE: begin
			if (end_round) begin
				next_state = PLAYER;
			end
		end
		PLAYER: begin
			if (success && player_round == (round-1)) begin
				next_state = GETCOLOR;
			end else if (fail) begin
				next_state = IDLE;
			end
		end
	endcase
	
end

//to color pou deixnoume stin e3odo 8a ein otan deixnoume to sequence apo to memory alliws to color tou koumpiou pou patame
always_comb begin
	if ( state == SEQUENCE) begin
		color = memory [seq_count];
	end else begin
		color = blink_btn;
	end
end
//orizoume to blink_en kai apothikevw to xrwma tou koumpiou pou pati8ike

always_ff @ (posedge clk or negedge rst) begin
	if (!rst) begin
		blink_en <= 1'b0;
	end else begin
		if (state == PLAYER && blink_timer == 25000000) begin
			blink_en <= 1'b0;
		end else	if (state == PLAYER && any_btn) begin
			blink_en <= 1'b1;
			blink_btn <= btn_pressed;
		end
	end
end
//stelnoume to shma color_en
always_comb begin
	if (state == SEQUENCE | (state == PLAYER && blink_en)) begin
		color_en = 1'b1;
	end else begin
		color_en = 1'b0;
	end
end

counter
player_round_count_inst
 (.clk (clk),
  .rstn (rst),
  .en (success),
  .rst_sync ((success && player_round == (round-1))| fail),
  .cnt_val (player_round)
  );

counter
round_count_inst
 (.clk (clk),
  .rstn (rst),
  .en (state == GETCOLOR),
  .rst_sync (state == IDLE),
  .cnt_val (round)
  );
  
counter
 seq_count_inst
 (.clk (clk),
  .rstn (rst),
  .en (state == SEQUENCE && time_count == TIMEOUT),
  .rst_sync (state == SEQUENCE && time_count == TIMEOUT && seq_count == (round-1)),
  .cnt_val (seq_count)
  );
 //metraei xrono otan eimaste sto sequence 
counter
time_count_inst
 (.clk (clk),
  .rstn (rst),
  .en (state == SEQUENCE),
  .rst_sync (time_count == TIMEOUT),
  .cnt_val (time_count)
  );
//pairnoume to random color  
counter
rand_color_count_inst
 (.clk (clk),
  .rstn (rst),
  .en (1'b1),
  .rst_sync (1'b0),
  .cnt_val (rnd_color)
  );
 //metraei xrono otan pati8ei koumpi k eimaste ston player
counter
time_count_color_blink_inst
 (.clk (clk),
  .rstn (rst),
  .en (blink_en),
  .rst_sync (state == PLAYER && blink_timer == 25000000),
  .cnt_val (blink_timer)
  );
  
endmodule

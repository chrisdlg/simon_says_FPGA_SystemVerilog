module vga (
input logic clk,
input logic rst,
output logic hsync,
output logic vsync,
output logic [3:0] red,
output logic [3:0] green,
output logic [3:0] blue,
input logic en,
input logic color
);

logic ks25;
logic [9:0] x;
logic [9:0] y;

always_ff @(posedge clk)
begin
 if(!rst)
   ks25 <=0;
 else 
    if(ks25)
     ks25 <=0;
    else
     ks25 <=1;
end

always_ff @(posedge clk)
begin
 if(!rst)
   x <=0;
 else
   if (ks25)
     if (x==799)   
       x <= 0;
     else
       x <= x+1;
end

always_ff @(posedge clk)
begin
 if(!rst)
   y <=0;
 else
   if (ks25)
     if (x==799)   
       if (y==523)
         y <=0;
       else 
         y <= y+1;
end

always_comb
begin
 if (x>=655 && x<752)
   hsync =0;
 else
   hsync =1;
 if (y>=491 && y<493) 
   vsync =0;
 else
   vsync =1;
end

always_comb
begin
	if (x<640 && y<480 ) begin
		if (en) begin
			if (color == 2'b00) begin
				red =4'b1111;
				green=4'b0000;
				blue=4'b0000;
			end else if (color == 2'b01) begin
				red=4'b0000;
				green=4'b1111;
				blue=4'b0000;
			end else if (color == 2'b10) begin
				red=4'b0000;
				green=4'b0000;
				blue=4'b1111;
			end else if (color == 2'b11) begin
				red=4'b0000;
				green=4'b1111;
				blue=4'b1111;
			end else begin
				red=4'b0000;
				green=4'b0000;
				blue=4'b0000;
			end
		end else begin
			if(x<320) begin
			   if(y<240) begin
				 red=4'b1111;
				 green=4'b0000;
				 blue=4'b0000;
			   end
			   else begin
				 red=4'b0000;
				 green=4'b0000;
				 blue=4'b1111;
			   end
			end
			else begin
			   if(y<240) begin
				 red=4'b0000;
				 green=4'b1111;
				 blue=4'b0000;
			   end
			   else begin
				 red=4'b0000;
				 green=4'b1111;
				 blue=4'b1111;
			   end
			end
		end 
	end else begin
		 red=4'b0000;
		 green=4'b0000;
		 blue=4'b0000;
	end

end
endmodule 

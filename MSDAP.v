`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//
// Create Date:     11/26/2018 
// Design Name:     MSDAP
// Project Name:    EEDG 6306 ASIC design Final Project 
// Target Devices:  ASIC
// Submitted by:    Akash Anil Tadmare, Akshay Nandkumar Patil
// Submission Date: 12/15/2018
//
//
//////////////////////////////////////////////////////////////////////////////////

module top_level (Reset, Frame, Dclk, Sclk, InReady, OutReady, Start, InputL, InputR, OutputL, OutputR);//, OutputH );

input Frame, Reset, Sclk, Dclk, Start, InputL, InputR;

output InReady;
output OutReady;
//output [15:0] OutputRJ;
output OutputL,OutputR;

wire w1, w2, w3, w3L, w3R, w5L, w5R, w8L, w8R, w9, /*w11,*/ w12L, w12R, w13L, 
	 w13R, w16L, w16R, w17, w19L, w19R, w20L, w20R, w21, w22, w23L, w23R, w24L, 
	 w24R, w27L, w27R, w29, w29L, w29R, w30L, w30R,  w31L, w31R, w32L, w32R, w33L, w33R, w34L, w34R, w35L, w35R, w36L, w36R, w37L, w37R, w38, 
	 w40, w40L, w40R, w42, w43, w43L, w43R, /*w44,*/ w45 ;
wire [15:0]w4L, w4R, w10L, w10R, w18L, w18R, w28L, w28R;
wire [3:0]w6L, w6R, w7L,w7R;
wire [8:0]w14L, w14R, w15L, w15R;
wire [7:0]w25L, w25R, w26L, w26R, w39;
wire [39:0] w41L, w41R;

or2		inst_RJ_en_L       (.a(w30L), .b(w31L), .out(w5L) );
or2		inst_RJ_en_R       (.a(w30R), .b(w31R), .out(w5R) );
or2		inst_H_en_L	       (.a(w32L), .b(w33L), .out(w13L) );
or2		inst_H_en_R	       (.a(w32R), .b(w33R), .out(w13R) );
or3		inst_Write_Done_L  (.a(w12L), .b(w19L), .c(w27L), .out(w20L) );
or3		inst_Write_Done_R  (.a(w12R), .b(w19R), .c(w27R), .out(w20R) );
or3		inst_data_valid_L  (.a(w34L), .b(w35L), .c(w36L), .out(w37L) );
or3		inst_data_valid_R  (.a(w34R), .b(w35R), .c(w36R), .out(w37R) );
and2	inst_word_ready    (.a(w3L),  .b(w3R),  .out(w3)  );
and2	inst_sleep 		   (.a(w29L), .b(w29R), .out(w29) );
and2	inst_prev_OutReady (.a(w40L), .b(w40R), .out(w40) );
and2 	inst_word_sent	   (.a(w43L), .b(w43R), .out(w43));
			
SIPO	SIPO_L (.Frame_edg(w2), .Reset(Reset), .rst(w1), .Dclk(Dclk), .data_in(InputL), .word_ready(w3L), .data_out(w4L), .received(w20L) );
SIPO	SIPO_R (.Frame_edg(w2), .Reset(Reset), .rst(w1), .Dclk(Dclk), .data_in(InputR), .word_ready(w3R), .data_out(w4R), .received(w20R) );

RJmem  	rLmem  (.Start(Start), .en(w5L), .rd_addr(w6L), .wr_addr(w7L), .wr(w8L), .rst(w9), .data_in(w4L), .data_out(w10L), .w_done(w12L), .data_valid(w36L) );
RJmem  	rRmem  (.Start(Start), .en(w5R), .rd_addr(w6R), .wr_addr(w7R), .wr(w8R), .rst(w9), .data_in(w4R), .data_out(w10R), .w_done(w12R), .data_valid(w36R) );

Hmem  	hLmem  (.Start(Start), .en(w13L), .rd_addr(w14L), .wr_addr(w15L), .wr(w16L), .rst(w17), .data_in(w4L), .data_out(w18L), .w_done(w19L), .data_valid(w35L) );
Hmem  	hRmem  (.Start(Start), .en(w13R), .rd_addr(w14R), .wr_addr(w15R), .wr(w16R), .rst(w17), .data_in(w4R), .data_out(w18R), .w_done(w19R), .data_valid(w35R) );

Xmem	xLmem  (.Start(Start), .Reset(Reset), .rst(w22), .rd_en(w24L), .wr_en(w23L), .rd_addr(w26L), .wr_addr(w25L), .data_in(w4L), .data_out(w28L), .sleep(w29L), 
			    .w_done(w27L), .data_valid(w34L) );
Xmem	xRmem  (.Start(Start), .Reset(Reset), .rst(w22), .rd_en(w24R), .wr_en(w23R), .rd_addr(w26R), .wr_addr(w25R), .data_in(w4R), .data_out(w28R), .sleep(w29R), 
			    .w_done(w27R), .data_valid(w34R) );

ALU		ALU_L  (.Sclk(Sclk), .Reset(Reset), .en(w21), .Start(Start), .sleep(w29),
				.RJ_en(w31L), .rr_ptr(w6L), .r_valid(w36L), .rj_data_in(w10L),
				.H_en(w33L), .hr_ptr(w14L), .h_valid(w35L), .h_data_in(w18L), 
				.X_rd_en(w24L), .xr_ptr(w26L), /*.x_valid(w34L),*/ .x_data_in(w28L), .x_flagbit(w38), .n(w39),
				.valid(w37L), .prev_OutReady(w40L), .y(w41L) );

ALU		ALU_R  (.Sclk(Sclk), .Reset(Reset), .en(w21), .Start(Start), .sleep(w29),
				.RJ_en(w31R), .rr_ptr(w6R), .r_valid(w36R), .rj_data_in(w10R),
				.H_en(w33R), .hr_ptr(w14R), .h_valid(w35R), .h_data_in(w18R), 
				.X_rd_en(w24R), .xr_ptr(w26R), /*.x_valid(w34R),*/ .x_data_in(w28R), .x_flagbit(w38), .n(w39),
				.valid(w37R), .prev_OutReady(w40R), .y(w41R) );				
				
PISO	PISO_L (.en(w42), .Sclk(Sclk), .Start(Start), .data_in(w41L), .word_sent(w43L), .data_out(OutputL) );
PISO	PISO_R (.en(w42), .Sclk(Sclk), .Start(Start), .data_in(w41R), .word_sent(w43R), .data_out(OutputR) );

controller CU  (.Reset(Reset), .Frame(Frame), .Frame_edg(w2), .Start(Start), .InReady(InReady), .OutReady(OutReady), .Sclk(Sclk), .word_ready(w3), 
				.RJ_enL(w30L), .RJ_enR(w30R), .RJ_rst(w9), .RJ_wrL(w8L), .RJ_wrR(w8R), .rw_ptr_L(w7L), .rw_ptr_R(w7R),
				.H_enL(w32L), .H_enR(w32R), .H_rst(w17), .H_wrL(w16L), .H_wrR(w16R), .hw_ptr_L(w15L), .hw_ptr_R(w15R),
				.X_rst(w22), .X_wr_enL(w23L), .X_wr_enR(w23R), .xw_ptr_L(w25L), .xw_ptr_R(w25R), .x_flagbit(w38),
				.ALU_en(w21), .n(w39), .prev_OutReady(w40),
				.PISO_en(w42), .word_sent(w43),
				.SIPO_rst(w1), .sleep(w29), .done_L(w20L), .done_R(w20R) );

//assign InReady  = w11;
//assign OutReady = w45;
//assign OutputL = w44;


endmodule

module or3(a,b,c,out);
input a, b, c;
output out;

assign out = a | b | c;

endmodule

module or2(a,b,out);
input a, b;
output out;

assign out = a | b;

endmodule

module and2(a,b,out);
input a, b;
output out;

assign out = a & b;

endmodule


/****************SIPO*****************/
module SIPO (Frame_edg, rst, Reset, Dclk, data_in, word_ready, data_out, received);
input Frame_edg, Reset, Dclk, data_in, rst, received;
output reg word_ready;// = 1'b0;
output reg [15:0] data_out;// = 16'h0;
reg [3:0] bt;

always @ (negedge Dclk or posedge rst or posedge received or negedge Reset)
begin
	if( Reset == 1'b0 )
	begin
		bt         <= 4'h0;
		data_out   <= 16'h0000;
		word_ready <= 1'b0;
	end
	else if( rst )
	begin
		bt         <= 4'h0;
		data_out   <= 16'h0000;
		word_ready <= 1'b0;
	end
	else if(received == 1'b1)
	begin
		if(word_ready== 1'b1)
		begin
			word_ready <= 1'b0;
		end
	end
	else
	begin
		if (Frame_edg == 1'b1)
		begin
			if (bt == 4'h0)
			begin
				word_ready <= 1'b0;
			end
			data_out [bt]   <= data_in;
			{word_ready,bt} <= bt + 1'b1;
		end
		
		else
		begin
			word_ready <= 1'b0;
			bt 		   <= 4'h0;
		end
	end
end
endmodule


/*******RJmemory*******/
module RJmem (en, Start, rd_addr, wr_addr, wr, rst, data_in, data_out, w_done, data_valid );
input en, rst, wr, Start;
input [3:0] wr_addr, rd_addr;
input [15:0] data_in;
output reg w_done;
output reg data_valid;
output reg [15:0] data_out;
reg [15:0] MEM [15:0];

always @ (en or Start)
begin
	if (Start== 1'b1)
	begin
		data_out   = 16'h0000;
		w_done     = 1'b0;
		data_valid = 1'b0;
	end
	
	else if(en== 1'b1)
	begin
		if (rst== 1'b1)
		begin
			MEM [wr_addr] = 16'h0000;
			//#sclk
			w_done = 1'b1;
		end
		else
		begin
			if (wr== 1'b1)
			begin
				MEM [wr_addr] = data_in[15:0];
				//#30
				w_done = 1'b1;
			end
			
			else
			begin
				data_out = MEM [rd_addr];
				//#30
				data_valid = 1'b1;
			end
		end
	end
	else
	begin
		w_done = 1'b0;
		data_valid = 1'b0;
		//data_out   = 16'h0;
	end
end

endmodule

/*******Hmemory*******/
module Hmem (en, Start, rd_addr, wr_addr, wr, rst, data_in, data_out, w_done, data_valid );

input en, rst, wr, Start;
input [8:0] wr_addr, rd_addr;
input [15:0] data_in;
output reg w_done;
output reg data_valid;
output reg [15:0] data_out;
reg [15:0] MEM [511:0];

always @ (Start or en)
begin
	if(Start== 1'b1)
	begin
		w_done = 1'b0;
		data_valid = 1'b0;
		data_out = 16'h0000;
	end
	
	else if(en== 1'b1)
	begin
		if (rst== 1'b1)
		begin
			MEM [wr_addr] = 16'h0000;
			//#sclk
			w_done = 1'b1;
		end
		
		else
		begin
			if (wr== 1'b1)
			begin
				MEM [wr_addr] = data_in[15:0];
				//#30
				w_done = 1'b1;
			end
			
			else
			begin
				data_out = MEM [rd_addr];
				//#30
				data_valid = 1'b1;
			end
		end
	end
	else
	begin
		w_done = 1'b0;
		data_valid = 1'b0;
		//data_out = 16'h0;
	end
end

endmodule

/*********************Xmemory**********************/

module Xmem (Start, Reset, rst, rd_addr, wr_addr, wr_en, rd_en, data_in, data_out, sleep, w_done, data_valid);

input Start, Reset,wr_en, rd_en, rst;
input [7:0] rd_addr, wr_addr;
input [15:0] data_in;
output reg w_done, sleep, data_valid;
output reg [15:0] data_out;

reg [15:0] MEM [255:0];
reg [11:0] sleep_count;

always @ (wr_en or Reset or Start)
begin
	if(Reset == 1'b0)
	begin
		sleep 		= 1'b0;
		sleep_count = 12'h0;
	end
	
	else if(Start== 1'b1)
	begin
		w_done 		= 1'b0;
		sleep  		= 1'b0;
		sleep_count = 12'h000;
	end
	
	else  if(wr_en== 1'b1)
	begin
		if(rst== 1'b1)
		begin
			MEM [wr_addr] = 16'h0000;
			w_done = 1'b1;
		end
		else
		begin
			MEM [wr_addr] = data_in;
			//#30
			if( data_in == 16'h0000 )
			begin
				sleep_count = sleep_count + 1'b1;
			end
			else
			begin
				sleep = 1'b0;
				sleep_count = 12'h000;
			end
			
			if ( sleep_count == 12'h320 )
			begin
				sleep = 1'b1;
				sleep_count = 12'h000;
			end
			w_done = 1'b1;
		end
	end
	else
	begin
		w_done = 1'b0;
	end
end

always @ (rd_en or Start)
begin
	if(Start== 1'b1)
	begin
		data_out   = 16'h0000;
		data_valid = 1'b0;
	end
	else if(rd_en== 1'b1)
	begin
		data_out = MEM [rd_addr];
		//#30
		data_valid = 1'b1;	
	end
	else
	begin
		data_valid = 1'b0;
		//data_out   = 16'h0;
	end
end

endmodule

/*******************ALU****************************/

module ALU 
(
Sclk, Reset, en, Start, sleep,
RJ_en, rr_ptr, r_valid, rj_data_in,
H_en, hr_ptr, h_valid, h_data_in, 
X_rd_en, xr_ptr/*, x_valid*/, x_data_in, n, x_flagbit,
valid, prev_OutReady, y
);

input Sclk, Reset, en, valid, Start, x_flagbit, sleep;
output reg prev_OutReady;
output reg [39:0] y;
 
input r_valid;
input [15:0] rj_data_in;
output reg RJ_en;
output reg [3:0] rr_ptr;
reg [15:0] rj_data;
reg [4:0] rr_ptr_buff;
reg rj_read;

input h_valid;
input [15:0] h_data_in;
output reg H_en;
output reg [8:0] hr_ptr;
reg [15:0] h_data;
reg [8:0] hr_ptr_buff;
reg [7:0] h_cntr;
reg h_read, calc, h_finish, last_h, last_x;

//input x_valid;
input [15:0] x_data_in;
input [7:0] n;
output reg X_rd_en;
output reg [7:0] xr_ptr;
reg [15:0] x_data;
//reg [7:0] xr_ptr_buff;
reg x_read, x_finish;

reg [1:0] neg;
reg h_sign ;
reg [39:0] U ;
reg [39:0] U_curr ;
/* reg [1:0]state;
parameter Read_RJ = 2'h0;
parameter Read_H = 2'h1;
parameter Compute = 2'h2; */

//integer i = 0;
always @ (posedge Sclk or negedge Reset or posedge Start or posedge valid)
begin
	if(Reset == 1'b0)
	begin
		RJ_en = 1'b0;
		rr_ptr = 4'h0;
		rj_data = 16'h0000;
		rj_read = 1'b0;
		
		H_en = 1'b0;
		hr_ptr = 9'h000;
		h_cntr = 8'h00;
		h_data = 16'h0000;
		h_read = 1'b0;
		calc = 1'b0;
		h_finish = 1'b0;
		last_h = 1'b0;
		
		X_rd_en = 1'b0;
		xr_ptr = 8'h00;
		x_read = 1'b0;
		x_data = 16'h0000;
		x_finish = 1'b0;
		last_x = 1'b0;
		
		U = 40'h0000000000;
		U_curr = 40'h0000000000;
		y = 40'h0000000000;
		neg = 2'h0;
		prev_OutReady = 1'b0;
	end
	else if(Start== 1'b1)
	begin
		RJ_en = 1'b0;
		rr_ptr = 4'h0;
		rj_data = 16'h0000;
		rj_read = 1'b0;
		
		H_en = 1'b0;
		hr_ptr = 9'h000;
		h_cntr = 8'h00;
		h_data = 16'h0000;
		h_read = 1'b0;
		calc = 1'b0;
		h_finish = 1'b0;
		last_h = 1'b0;
		
		X_rd_en = 1'b0;
		xr_ptr = 8'h00;
		x_read = 1'b0;
		x_data = 16'h0000;
		x_finish = 1'b0;
		last_x = 1'b0;
		
		U = 40'h0000000000;
		U_curr = 40'h0000000000;
		y = 40'h0000000000;
		neg = 2'h0;
		prev_OutReady = 1'b0;
	end
	else if(valid== 1'b1)
	begin
	    RJ_en = 1'b0;
		H_en = 1'b0;
		X_rd_en = 1'b0; 
	end
	
	else
	begin
		if(en== 1'b1)
		begin
			prev_OutReady = 1'b0;
			if(sleep== 1'b0)
			begin
				if(x_read== 1'b1)
				begin
					if(neg[1]== 1'b0)
					begin
						x_data = x_data_in;
					end
					else
					begin
						x_data = 16'h0000; 
					end
					x_read = 1'b0;
					
					if ( h_sign== 1'b0 )
					begin
						U = U + {{8{x_data[15]}},x_data,{16{1'b0}}};//Add if positive
						U_curr = U_curr + {{8{x_data[15]}},x_data,{16{1'b0}}};
					end
					
					else
					begin
						U = U - {{8{x_data[15]}},x_data,{16{1'b0}}};//Subtract if negative
						U_curr = U_curr - {{8{x_data[15]}},x_data,{16{1'b0}}};
					end
				end
			
				if(x_finish== 1'b1)
				begin
					//$display("U[%d] : %h", i,U_curr);
					//i = i+1;
					U = {U[39],U[39:1]};
					U_curr = {40{1'b0}};
					if(last_x == 1'b1)
					begin
						last_x = 1'b0;
						y = U;
						//i = 0;
						//$display("Y : %h",  y);
						prev_OutReady = 1'b1;
						calc = 1'b0;
					end
					x_finish = 1'b0;
				end
		
				if(h_finish== 1'b1)
				begin
					x_finish = 1'b1;
					if(last_h== 1'b1)
					begin
						last_x = 1'b1;
					end
					h_finish = 1'b0;
				end
			
				if(h_read== 1'b1)
				begin
					h_data = h_data_in;
					//H_en = 1'b0;
					h_read = 1'b0;
					calc = 1'b1;
				end
			
				if(calc== 1'b1)
				begin
					{neg,xr_ptr} = {x_flagbit, n} - h_data[7:0];
					if( neg[1]== 1'b0 )
					begin
						X_rd_en = 1'b1;
						//x_read = 1'b1;
					end
					h_sign = h_data[8];
					x_read = 1'b1;
				end
			
				if(rj_read== 1'b1)
				begin
					rj_data = rj_data_in;
					rj_read = 1'b0;
				end
				
				if(h_cntr != rj_data)
				begin
					hr_ptr = hr_ptr_buff;
					H_en = 1'b1;
					h_read = 1'b1;
					h_cntr = h_cntr + 1'b1;
				end
	
				if(((h_cntr == rj_data) || (rr_ptr_buff == 4'h0)) && (last_h == 1'b0))
				begin
					if(rr_ptr == 4'hf)
					begin
						last_h = 1'b1;
						h_finish = 1'b1;
						rr_ptr = rr_ptr_buff;
					end
					else
					begin
						rr_ptr = rr_ptr_buff;
						if(rr_ptr != 1'b0)  //If not initial entry? then h_finished =1
						begin
							h_finish = 1'b1;
						end
						h_cntr = 8'h00;
						RJ_en = 1'b1;
						rj_read = 1'b1;
					end
				end
			end
		end
		
		else
		begin
			RJ_en = 1'b0;
			rr_ptr = 4'h0;
			rj_data = 16'h0000;
			rj_read = 1'b0;
			
			H_en = 1'b0;
			hr_ptr = 9'h000;
			h_cntr = 8'h00;
			h_data = 16'h0000;
			h_read = 1'b0;
			calc = 1'b0;
			h_finish = 1'b0;
			last_h = 1'b0;
			
			X_rd_en = 1'b0;
			x_read = 1'b0;
			x_data = 16'h0000;
			x_finish = 1'b0;
			last_x = 1'b0;
			
			U = 40'h0000000000;
			U_curr = 40'h0000000000;
			neg = 2'h0;
		end
	end
end

always @ (negedge Reset or posedge valid or posedge Start)
begin
	if (Reset == 1'b0)
	begin
		rr_ptr_buff = 4'h0;
		hr_ptr_buff = 9'h000;
		//xr_ptr_buff = 8'h0;
	end
	else if(Start== 1'b1)
	begin
		rr_ptr_buff = 4'h0;
		hr_ptr_buff = 9'h000;
		//xr_ptr_buff = 8'h0;
	end
	else
	begin
		if (r_valid)
		begin
			rr_ptr_buff = rr_ptr + 1'b1;
		end
		/* if (x_valid)
		begin
			xr_ptr_buff = xr_ptr + 1'b1;
		end */
		if (h_valid)
		begin
			hr_ptr_buff = hr_ptr + 1'b1;
		end
		
	end
end
endmodule


/********************PISO**************************/

module PISO (en, Sclk, Start, data_in, word_sent, data_out);

input en, Sclk, Start;
input [39:0] data_in;
output reg word_sent, data_out;
reg [5:0] ybt;
reg [39:0] data;

always @ (posedge Sclk or posedge Start)
begin
	if(Start)
	begin
		data = 40'h0000000000;
		data_out = 1'b0;
		ybt = 6'h00;
		word_sent = 1'b0;
	end
	else 
	begin
		if(en)
		begin
			data = data_in;
			data_out = data[ybt];
			ybt = ybt + 1'b1;
			if(ybt == 6'h28)
			begin
				word_sent = 1'b1;
				ybt = 6'h00;
			end
		end
		else
		begin
			word_sent = 1'b0;
		end
	end
end	
endmodule

/********************Controller********************/

module controller
(
Reset, Frame, Frame_edg, Start, InReady, Sclk, OutReady, word_ready, 
RJ_enL, RJ_enR, RJ_rst, RJ_wrL, RJ_wrR, rw_ptr_L, rw_ptr_R,// r_done,
H_enL, H_enR, H_rst, H_wrL, H_wrR, hw_ptr_L, hw_ptr_R,// h_done,
X_wr_enL, X_wr_enR, X_rst, xw_ptr_L, xw_ptr_R, x_flagbit,
sleep, done_L, done_R,
ALU_en, n, prev_OutReady,
SIPO_rst, 
PISO_en, word_sent
);

input Reset;
input Start;
input Sclk;
input word_ready, word_sent;
input Frame;
input done_L, done_R;
input sleep;
input prev_OutReady;

output reg Frame_edg;
output reg InReady;
output reg OutReady;
output reg SIPO_rst;
output reg ALU_en;
output reg PISO_en;

output reg RJ_enL, RJ_enR, RJ_rst, RJ_wrL, RJ_wrR;//, r_done;
output reg [3:0] rw_ptr_L, rw_ptr_R ;
reg [3:0]  rw_ptr_buff_L, rw_ptr_buff_R;
reg R_clr_stop_L, R_clr_stop_R;

output reg H_enL, H_enR, H_rst, H_wrL, H_wrR;//, h_done;
output reg [8:0] hw_ptr_L, hw_ptr_R;
reg [8:0] hw_ptr_buff_L, hw_ptr_buff_R;

output reg X_rst, X_wr_enL, X_wr_enR;//, h_done;
output reg [7:0] xw_ptr_L, xw_ptr_R, n;
reg [8:0] xw_ptr_buff_L, xw_ptr_buff_R;
reg X_clr_stop_L, X_clr_stop_R;

output reg x_flagbit;


reg [3:0] state;
reg [3:0] next_state;
parameter state0 = 4'h0;
parameter state1 = 4'h1;
parameter state2 = 4'h2;
parameter state3 = 4'h3;
parameter state4 = 4'h4;
parameter state5 = 4'h5;
parameter state6 = 4'h6;
parameter state7 = 4'h7;
parameter state8 = 4'h8;




always @ (state or Frame or word_ready or Reset or Start or prev_OutReady or word_sent or sleep)
begin
	if(Reset == 1'b0)
	begin
		next_state <= state7;
		Frame_edg <= 1'b0;
		OutReady = 1'b0;
		ALU_en = 1'b0;
		PISO_en = 1'b0;
	end
	else if (Start== 1'b1)
	begin
		ALU_en = 1'b0;
		PISO_en = 1'b0;
		OutReady = 1'b0;
		//next_state <= state0;
	end
	else
	begin
		case ( state )
			state0:
			begin
				if (R_clr_stop_L && R_clr_stop_R)
				begin
					next_state <= state1;
				end
				else
				begin
					next_state <= state0;
				end
			end
				
			state1:
			begin
				if (Frame)
				begin
					next_state <= state2;
					Frame_edg  <= 1'b1;
				end
				else
				begin
					next_state <= state1;
				end
			end
			
			state2:
			begin
				if (Frame)
				begin
					Frame_edg  <= 1'b1;
				end
				else if (word_ready)
				begin
					Frame_edg  <= 1'b0;
				end
				else
				begin
					next_state <= state2;
				end
			end
			
			state3:
			begin
				if (Frame)
				begin
					next_state <= state4;
					Frame_edg  <= 1'b1;
				end
				else
				begin
					next_state <= state3;
				end
			end
			
			state4:
			begin
				if (Frame)
				begin
					Frame_edg  <= 1'b1;
				end
				else if (word_ready)
				begin
					Frame_edg  <= 1'b0;
				end
				else
				begin
					next_state <= state4;
				end
				//H mem code
			end
			
			state5:
			begin
				if (Frame)
				begin
					next_state <= state6;
					Frame_edg  <= 1'b1;
				end
				else
				begin
					next_state <= state5;
				end
			end
			
			state6:
			begin
				if (Frame)
				begin
					Frame_edg  <= 1'b1;
					if (prev_OutReady)
					begin
						PISO_en = 1'b1;
						OutReady = 1'b1;
					end
					if( (|{x_flagbit,xw_ptr_buff_L}) )
					begin
						ALU_en = 1'b1;
					end
				end
				
				else if (word_ready)
				begin
					Frame_edg  <= 1'b0;
				end
				else if (prev_OutReady)
				begin
					ALU_en = 1'b0;
				end
				
				else if (word_sent)
				begin
					PISO_en = 1'b0;
					OutReady = 1'b0;
				end
				else
				begin
					next_state <= state6;
				end
				
			end
			
			state7:
			begin
				if(Reset)
				begin
					next_state <= state5;
				end
			end
			
			state8:
			begin
				if (Frame)
				begin
					Frame_edg  <= 1'b1;
					if (prev_OutReady)
					begin
						PISO_en = 1'b1;
						OutReady = 1'b1;
					end
					ALU_en = 1'b1;
				end
				
				else if (!sleep)
				begin
					ALU_en = 1'b0;
				end
				
				else if (word_ready)
				begin
					Frame_edg  <= 1'b0;
				end
				
				else if (word_sent)
				begin
					PISO_en = 1'b0;
					OutReady = 1'b0;
				end
				
				else
				begin
					next_state <= state8;
				end
			end
			
			default:
			begin
				Frame_edg <= 1'b0;
				OutReady = 1'b0;
				ALU_en = 1'b0;
				PISO_en = 1'b0;
			end
		endcase
	end
end

always @ (posedge Start or posedge done_L or negedge Reset )// or posedge r_done or posedge h_done)
begin
	if(Reset == 1'b0)
	begin
		xw_ptr_buff_L = 9'h000;
		x_flagbit = 1'b0;
	end
	
	else if(Start== 1'b1)
	begin
		{R_clr_stop_L,rw_ptr_buff_L} = 5'h00;
		hw_ptr_buff_L = 9'h000;
		{X_clr_stop_L,xw_ptr_buff_L} = 9'h000;
		x_flagbit = 1'b0;
	end
	else
	begin
		case (next_state)
		state0:
			begin
				if(R_clr_stop_L == 1'b0)
				begin
					{R_clr_stop_L,rw_ptr_buff_L} =  rw_ptr_L + 1'b1;
				end		
				if(X_clr_stop_L == 1'b0)
				begin
					{X_clr_stop_L,xw_ptr_buff_L[7:0]} =  xw_ptr_L + 1'b1;
				end
				
				hw_ptr_buff_L  =  hw_ptr_L + 1'b1;
			end
			
		state1:
			begin
				rw_ptr_buff_L = 4'h0;
				xw_ptr_buff_L = 9'h000;
				hw_ptr_buff_L = 9'h000;
			end
			
		state2:
			begin
				rw_ptr_buff_L = rw_ptr_L + 1'b1;
			end
			
		state3:
			begin
				rw_ptr_buff_L = 4'h0;
			end
			
		state4:
			begin
				hw_ptr_buff_L = hw_ptr_L + 1'b1;
			end
			
		state5:
			begin
				hw_ptr_buff_L = 9'h000;
			end
			
		state6:
			begin
				if(sleep== 1'b1)
				begin
					xw_ptr_buff_L = 9'h0;
					x_flagbit = 1'b0;
				end
				else
				begin
					xw_ptr_buff_L = xw_ptr_L + 1'b1;
					if(xw_ptr_buff_L == 9'h100)
					begin
						x_flagbit = 1'b1;
					end
				end
			end
			
		state7:
			begin
				rw_ptr_buff_L = 4'h0;
				xw_ptr_buff_L = 9'h000;
				hw_ptr_buff_L = 9'h000;
			end
			
		state8:
			begin
				if(sleep == 1'b1)
				begin
					xw_ptr_buff_L = 9'h0;
				end
				else
				begin
					xw_ptr_buff_L = 9'h001;
				end
			end
			
		default:
		begin
			rw_ptr_buff_L = 4'h0;
			xw_ptr_buff_L = 9'h000;
			hw_ptr_buff_L = 9'h000;
			 R_clr_stop_L = 1'b0;
			 X_clr_stop_L = 1'b0;
		end
		endcase
	end
end

always @ (posedge Start or posedge done_R or negedge Reset )// or posedge r_done or posedge h_done)
begin
	if(Reset == 1'b0)
	begin
		xw_ptr_buff_R = 9'h000;
	end
	
	else if(Start)
	begin
		{R_clr_stop_R,rw_ptr_buff_R} = 5'h0;
		hw_ptr_buff_R = 9'h000;
		{X_clr_stop_R,xw_ptr_buff_R} = 9'h000;
	end
	else
	begin
		case (next_state)
		state0:
			begin
				if(R_clr_stop_R == 1'b0)
				begin
					{R_clr_stop_R,rw_ptr_buff_R} =  rw_ptr_R + 1'b1;
				end		
				if(X_clr_stop_R == 1'b0)
				begin
					{X_clr_stop_R,xw_ptr_buff_R[7:0]} =  xw_ptr_R + 1'b1;
				end
				
				hw_ptr_buff_R  =  hw_ptr_R + 1'b1;
			end
			
		state1:
			begin
				rw_ptr_buff_R = 4'h0;
				xw_ptr_buff_R = 9'h000;
				hw_ptr_buff_R = 9'h000;
			end
			
		state2:
			begin
				rw_ptr_buff_R = rw_ptr_R + 1'b1;
			end
			
		state3:
			begin
				rw_ptr_buff_R = 4'h0;
			end
			
		state4:
			begin
				hw_ptr_buff_R = hw_ptr_R + 1'b1;
			end
			
		state5:
			begin
				hw_ptr_buff_R = 9'h000;
			end
			
		state6:
			begin
				if(sleep== 1'b1)
				begin
					xw_ptr_buff_R = 9'h000;
				end
				else
				begin
					xw_ptr_buff_R = xw_ptr_R + 1'b1;
				end
			end
			
		state7:
			begin
				rw_ptr_buff_R = 4'h0;
				xw_ptr_buff_R = 9'h000;
				hw_ptr_buff_R = 9'h000;
			end
			
		state8:
			begin
				if(sleep == 1'b1)
				begin
					xw_ptr_buff_R = 9'h000;
				end
				else
				begin
					xw_ptr_buff_R = 9'h001;
				end
			end
			
		default:
		begin
			rw_ptr_buff_R = 4'h0;
			xw_ptr_buff_R = 9'h000;
			hw_ptr_buff_R = 9'h000;
			R_clr_stop_R = 1'b0;
			X_clr_stop_R = 1'b0;
		end
		endcase
	end
end


always @ (posedge Sclk or negedge Reset or posedge Start or posedge done_L )// or posedge r_done or posedge h_done)
begin
	if(Reset == 1'b0)
	begin
		state <= state7;
		InReady = 1'b0;
			 n = 8'h00;
	end
	else if(Start== 1'b1)
	begin
		 RJ_enL = 1'b0;
		  H_enL = 1'b0;
	   X_wr_enL = 1'b0;
		RJ_rst = 1'b1;
		 H_rst = 1'b1;
		 X_rst = 1'b1;
		rw_ptr_L = 4'h0;
		hw_ptr_L = 9'h000;
		xw_ptr_L = 8'h00;
	  SIPO_rst = 1'b1;
			 n = 8'h00; 
		state <= state0;
	end
	
	else if (done_L== 1'b1)
	begin
		RJ_enL = 1'b0;
		 H_enL = 1'b0;
		 X_wr_enL = 1'b0;
	end

	else
	begin
		state <= next_state;
		case (next_state)
			state0:
			begin   //clear memories
				SIPO_rst = 1'b0;
				if(R_clr_stop_L == 1'b0)
				begin
					rw_ptr_L = rw_ptr_buff_L;
					RJ_enL = 1'b1;
				end
				if(X_clr_stop_L == 1'b0)
				begin
					xw_ptr_L = xw_ptr_buff_L[7:0];
					X_wr_enL = 1'b1;
				end
				hw_ptr_L = hw_ptr_buff_L;
				H_enL = 1'b1;			
				if(hw_ptr_L == 9'h1FF)
				begin
					state <= state1;
				end
			end
			
			state1:
			begin	// wait for frame
				rw_ptr_L      = 4'h0;
				InReady     = 1'b1;
				RJ_rst      = 1'b0;
			end
			
			state2:
			begin
				if(word_ready)
				begin
					rw_ptr_L = rw_ptr_buff_L;
					if(rw_ptr_L == 4'hF)
					begin
						state <= state3;
					end
					RJ_wrL = 1'b1;
					RJ_enL = 1'b1;
				end
			end
			
			state3:
			begin	// wait for frame
				RJ_wrL 		= 1'b0;
				hw_ptr_L    = 9'h000;
				InReady     = 1'b1;
				 H_rst      = 1'b0;
			end
			
			state4:
			begin
				if(word_ready)
				begin
					hw_ptr_L = hw_ptr_buff_L;
					if(hw_ptr_L == 9'h1FF)
					begin
						state <= state5;
					end
					H_wrL = 1'b1;
					H_enL = 1'b1;
				end
			end
			
			state5:
			begin
				H_wrL 		= 1'b0;
				xw_ptr_L	= 8'h00;
				InReady		= 1'b1;
				X_rst		= 1'b0;
			end
			
			state6:
			begin
				if(word_ready)
				begin
					 xw_ptr_L = xw_ptr_buff_L[7:0];
						  n = xw_ptr_L;
					X_wr_enL = 1'b1;
				end
				
				if(sleep)
				begin
					state <= state8;
				end
			end
			
			state7:
			begin
				InReady = 1'b0;
					 n = 8'h00;
			end
			
			state8:
			begin
				if(word_ready)
				begin
					xw_ptr_L = 8'h0;
					X_wr_enL = 1'b1;
					n = xw_ptr_L; 
				end
				if(sleep == 1'b0)
				begin
					state <= state6;
				end
			end
			
			default:
			begin
				if (Start == 1'b1)
				begin
					rw_ptr_L = 4'h0;
					hw_ptr_L = 9'h000;
					xw_ptr_L = 8'h00;
					state <= state0;
				end
			end
		endcase
	end
end

always @ (posedge Sclk or posedge Start or posedge done_R )// or posedge r_done or posedge h_done)
begin
	if(Start)
	begin
		 RJ_enR = 1'b0;
		  H_enR = 1'b0;
	   X_wr_enR = 1'b0;
		rw_ptr_R = 4'h0;
		hw_ptr_R = 9'h000;
		xw_ptr_R = 8'h00;
		//state <= state0;
	end
	
	else if (done_R)
	begin
		RJ_enR = 1'b0;
		 H_enR = 1'b0;
		 X_wr_enR = 1'b0;
	end

	else
	begin
		case (next_state)
			state0:
			begin   //clear memories
				if(R_clr_stop_R == 1'b0)
				begin
					rw_ptr_R = rw_ptr_buff_R;
					RJ_enR = 1'b1;
				end
				if(X_clr_stop_R == 1'b0)
				begin
					xw_ptr_R = xw_ptr_buff_R[7:0];
					X_wr_enR = 1'b1;
				end
				hw_ptr_R = hw_ptr_buff_R;
				H_enR = 1'b1;	
			end
			
			state1:
			begin	// wait for frame
				rw_ptr_R      = 4'h0;
			end
			
			state2:
			begin
				if(word_ready)
				begin
					rw_ptr_R = rw_ptr_buff_R;
					
					RJ_wrR = 1'b1;
					RJ_enR = 1'b1;
				end
			end
			
			state3:
			begin	// wait for frame
				RJ_wrR 		= 1'b0;
				hw_ptr_R      = 9'h000;
			end
			
			state4:
			begin
				if(word_ready)
				begin
					hw_ptr_R = hw_ptr_buff_R;
					H_wrR = 1'b1;
					H_enR = 1'b1;
				end
			end
			
			state5:
			begin
				H_wrR 		= 1'b0;
				xw_ptr_R		= 8'h00;
			end
			
			state6:
			begin
				if(word_ready)
				begin
					 xw_ptr_R = xw_ptr_buff_L[7:0];
					X_wr_enR = 1'b1;
				end
			end
			
			state7:
			begin
				rw_ptr_R = 4'h0;
				hw_ptr_R = 9'h000;
				xw_ptr_R = 8'h00;
			end
			
			state8:
			begin
				if(word_ready)
				begin
					xw_ptr_R = 8'h00;
					X_wr_enR = 1'b1;
				end
			end
			
			default:
			begin
				if (Start == 1'b1)
				begin
					rw_ptr_R = 4'h0;
					hw_ptr_R = 9'h000;
					xw_ptr_R = 8'h00;
				end
			end
		endcase
	end
end

endmodule

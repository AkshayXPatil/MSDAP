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

module MSDAP_tb;
	
	integer outfile;
	
	// Inputs
	reg Frame;
	reg Dclk;
	reg Sclk;
	reg InputL;
	reg InputR;
	reg Start;
	reg Reset;
	
	// Outputs
	wire InReady;
	wire OutputL;
	wire OutputR;
	wire OutReady;
	
	reg [15:0] data [15056:0];
	reg OutReady_buff = 1'b0;
	reg [39:0] out_data [1:0];
	
	parameter Dclk_period = 1302.08;
	parameter Sclk_period = 37.2023;
	
	integer j=0, k=0, ybt=0, count=0;
	
	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.Frame  (Frame  ),
		.Dclk   (Dclk   ),
		.Sclk   (Sclk   ),
		.InReady(InReady),
		.OutReady(OutReady),
		.Start  (Start  ),
		.InputL (InputL ),
		.InputR (InputR ),
		.OutputL(OutputL),
		.OutputR(OutputR),
		.Reset(Reset)
	);

	initial begin
		// Initialize Inputs
		Dclk = 0;
		Sclk = 0; 
		Start = 0;
		Reset = 1;
		Frame = 0;
		InputL = 0;
		InputR = 0;
		$readmemh("./data1.in", data);
		outfile = $fopen("data1.out", "wb");
		#1250
		Start = 1;
		#130
		Start = 0;
	end
	
	always @ (posedge Dclk)
	begin
	if(InReady)
	begin
		if( (k==0) && (j<15056) )
		begin
			Frame = 1'b1;
			//$display("frame is %b in tb at %d", Frame, $time);
		end
		if (k == 1)
		begin
			Frame = 1'b0;
		end
		
		if ( j<15056 )
		begin
			InputL = data[j][k];
			InputR = data[j+1][k];
		end
		/*$display("k is: %d at %d", k, $time);
		$display("Lbit: %b, Rbit: %b from tb",data[j][k],data[j+1][k] );*/
		k = k +1;

		if (k == 16)
		begin
			k = 0;
			count = (j/2)+1;
			//$display("intput %d is sent", count);
			//$display("%h\t%h",data[j],data[j+1]);
			j = j+2;
		end
		if(((j == 9458)|| (j == 13058)) && (k == 0))
		begin
			#100
			Reset = 1'b0;
			#100
			Reset = 1'b1;
			Frame = 1'b0;
			k =0;
		end
	end
	end
	
	
   always @ (posedge Sclk)
	begin
		OutReady_buff <= OutReady;
		if(OutReady_buff == 1'b1)
		begin
			out_data[0][ybt] = OutputL;
			out_data[1][ybt] = OutputR;
			ybt = ybt+1;
			if(ybt == 40)
			begin
				//$display ("OutputL: %h, OutputR: %h\n",out_data[0],out_data[1] );
				$fwrite (outfile,"%h\t%h\n",out_data[0],out_data[1] );
				ybt=0;
			end
		end
	end
   always
	begin
		#(Dclk_period/2) Dclk = ~Dclk;
	end  
	
	 always
	begin
		#(Sclk_period/2) Sclk = ~Sclk;
	end
endmodule


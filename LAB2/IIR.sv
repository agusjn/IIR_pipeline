module IIR(
    input logic signed [23:0] data_in,      
    input logic clk,                    
    input logic reset_n,                  
    output logic signed [23:0] data_out     
);

  logic signed [23:0] out1, out2; //section out
  logic signed [23:0] d1as1, d2as1, d1bs1, d2bs1, d1as2, d2as2, d1bs2, d2bs2, d1as3, d2as3, d1bs3, d2bs3; //delays
  logic signed [23:0] tempout1, d1as1t, tempin1, d1bs1t, tempout2, d1as2t, tempin2, d1bs2t, tempout3, d1as3t, tempin3, d1bs3t; //wires
  logic signed [55:0] bout1, aout1, bout2, aout2, bout3, aout3; 
  logic signed [32:0] a1s1, a2s1, b0s1, b1s1, b2s1, a1s2, a2s2, b0s2, b1s2, b2s2, a1s3, a2s3, b0s3, b1s3, b2s3; //coeffs
  logic signed [23:0] pips1, pips2; //pipeline reg
  
  assign b0s1 = 7322;
  assign b1s1 = 14644;
  assign b2s1 = 7322;
  assign a1s1 = -1979412;
  assign a2s1 = 960122;

  assign b0s2 = 6823;
  assign b1s2 = 13646;
  assign b2s2 = 6823;
  assign a1s2 = -1844652;
  assign a2s2 = 823369;

  assign b0s3 = 6565;
  assign b1s3 = 13130;
  assign b2s3 = 6565;
  assign a1s3 = -1979412;
  assign a2s3 = 960122;
  
  //Section 1
  
  assign tempin1 = data_in;
  assign d1bs1t = d1bs1;
  assign tempout1 = out1;
  assign d1as1t = d1as1;
  assign bout1 = data_in*b0s1 + d1bs1*b1s1 + d2bs1*b2s1;
  assign aout1 = bout1 - d1as1*a1s1 - d2as1*a2s1;
  assign out1 = aout1 >> 20;
  
  //Pipeline 1
  PIPFF PIP1(.in(out1),
             .clk(clk),
             .reset_n(reset_n),
             .out(pips1));
  
  //Section 2
  assign tempin2 = pips1;
  assign d1bs2t = d1bs2;
  assign tempout2 = out2;
  assign d1as2t = d1as2;
  assign bout2 = pips1*b0s2 + d1bs2*b1s2 + d2bs2*b2s2;
  assign aout2 = bout2 - d1as2*a1s2 - d2as2*a2s2;
  assign out2 = aout2 >> 20;
  
  //Pipeline 2
  PIPFF PIP2(.in(out2),
             .clk(clk),
             .reset_n(reset_n),
             .out(pips2));
  
  //Section 3
  assign tempin3 = pips2;
  assign d1bs3t = d1bs3;
  assign tempout3 = data_out;
  assign d1as3t = d1as3;
  assign bout3 = pips2*b0s3 + d1bs3*b1s3 + d2bs3*b2s3;
  assign aout3 = bout3 - d1as3*a1s3 - d2as3*a2s3;
  assign data_out = aout3 >> 20;


	always @ (posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			d1as1 <= 0;
			d2as1 <= 0;
			d1bs1 <= 0;
			d2bs1 <= 0;

      d1as2 <= 0;
      d2as2 <= 0;
      d1bs2 <= 0;
      d2bs2 <= 0;

      d1as3 <= 0;
      d2as3 <= 0;
      d1bs3 <= 0;
      d2bs3 <= 0;
		end else begin
			d1as1 <= tempout1;
			d2as1 <= d1as1t;
			d1bs1 <= tempin1;
			d2bs1 <= d1bs1t;

      d1as2 <= tempout2;
      d2as2 <= d1as2t;
      d1bs2 <= tempin1;
      d2bs2 <= d1bs2t;

      d1as3 <= tempout3;
      d2as3 <= d1as3t;
      d1bs3 <= tempin3;
      d2bs3 <= d1bs3t;
		end
	end
endmodule

module PIPFF (in, clk, reset_n, out);
  input clk, reset_n;
  input logic signed [23:0] in;
  output logic signed [23:0] out;
  
  always_ff @(posedge clk or negedge reset_n)begin
    if (!reset_n)
      out <= 0;
    else 
      out <= in;
    end
endmodule: PIPFF

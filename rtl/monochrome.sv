// Composite-like horizontal blending by Kitrinx

module monochrome (
	input        clk,
	input        pix_ce,
	input        enable,

	input        hblank,
	input        vblank,
	input        hs,
	input        vs,
	input  [8:0] red,
	input  [8:0] green,
	input  [8:0] blue,
	input  [1:0] mode,

	output reg       hblank_out,
	output reg       vblank_out,
	output reg       hs_out,
	output reg       vs_out,
	output reg [7:0] red_out,
	output reg [7:0] green_out,
	output reg [7:0] blue_out
);

wire[8:0] bval = (red >> 2) + ((green >> 1) + (green >> 2)) + (blue >> 3);
wire[7:0] val = (bval > 255) ? 8'd255 : bval[7:0];
wire[8:0] rval = bval + (bval >> 3);

always @(posedge clk) if (pix_ce) begin
	
	hblank_out <= hblank;
	vblank_out <= vblank;
	vs_out     <= vs;
	hs_out     <= hs;

	
	/*red_out    <= enable ? ((rval > 255) ? 8'd255 : rval[7:0]) : red;
	blue_out   <= enable ? (val >> 3) : blue;
	green_out  <= enable ? (val >> 1) + (val >> 2) : green;*/
	
	case (mode)
		2'b00: begin // off
			red_out <= red;
			blue_out <= blue;
			green_out <= green;
		end
		2'b01: begin // b/w
			red_out <= val;
			blue_out <= val;
			green_out <= val;
		end
		2'b10: begin // amber
			red_out <= (rval > 255) ? 8'd255 : rval[7:0];
			blue_out <= 0;
			green_out <= (val >> 1) + (val >> 2);
		end
		2'b11: begin // green
			red_out <= (val >> 2) - (val >> 4);
			blue_out <= (val >> 2) - (val >> 4);
			green_out <= (rval > 255) ? 8'd255 : rval[7:0];
		end

	endcase

end

endmodule

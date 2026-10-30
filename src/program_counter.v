module program_counter (
	input wire clk,
	input wire rst_n,          // Active-low reset
	input wire jmp_en,         // High if a JMP instruction is executed
	input wire [6:0] jmp_addr, // Target address to jump to (7 bits for 128 lines)
	input wire waiting,
	output reg [6:0] pc,        // Current instruction address
	output reg [6:0] clk_counter // For debugging, instead of counting cycles by hand TODO: Remove
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			pc <= 7'd0;        // On reset, start at line 0
			clk_counter <= 7'd0; // On reset, start counting at 0 TODO: Remove
		end else if (!waiting) begin
			if (jmp_en) begin
				pc <= jmp_addr;    // If jumping, go to target address
			end else begin
				pc <= pc + 1'b1;   // Otherwise, go to the next instruction
			end
		end
		clk_counter <= clk_counter +1'b1;
	end

endmodule
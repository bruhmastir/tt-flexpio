module instruction_memory (
    input wire [6:0] addr,        // 7-bit address from the Program Counter (0 to 127)
    output reg [15:0] instr       // 16-bit instruction word output
);

    // Declare an array of 128 words, each 16 bits wide
    reg [15:0] mem [0:127];

    initial begin
        // Initialize memory to zero (NOPs / safe defaults)
        integer i;
        for (i = 0; i < 128; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        
        // --- LOAD MULTI-INSTRUCTION TEST PROGRAM ---
        $readmemh("program.hex", mem);
    end

    // Combinational read: output the instruction at the current address instantly
    always @(*) begin
        instr = mem[addr];
    end

endmodule
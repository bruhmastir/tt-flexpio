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
        
        // --- MULTI-INSTRUCTION TEST PROGRAM ---
        // Address 0: SET pin 0 HIGH (Opcode 000, val=1, mask = bit 0)
        mem[0] = 16'b000_1_00000001_0000; 

        // Address 1: WAIT for 15 cycles (Opcode 001, count = 15)
        mem[1] = {3'b001, 3'd0, 10'd15}; 

        // Address 2: SET pin 0 LOW, pin 1 HIGH (Opcode 000, val=0, mask = bits 0 & 1)
        // Let's set val=1 for pin 1: mask = 8'b00000010, val = 1
        mem[2] = 16'b000_1_00000010_0000;

        // Address 3: WAIT for 10 cycles
        mem[3] = {3'b001, 3'd0, 10'd10};

        // Address 4: JMP back to Address 0 (Opcode for JMP or loop back)
        // (Assuming JMP opcode or letting PC wrap/loop for now)
    end

    // Combinational read: output the instruction at the current address instantly
    always @(*) begin
        instr = mem[addr];
    end

endmodule
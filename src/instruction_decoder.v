module instruction_decoder (
    input wire [15:0] instr,       // Raw 16-bit instruction from memory
    
    // Decoded outputs
    output wire [2:0] opcode,      // 3-bit opcode
    output wire [7:0] pin_mask,    // Bitmask for multi-pin SET operations
    output wire pin_val,           // Value to set pins to (0 or 1)
    output wire [9:0] wait_cycles, // Cycle count for WAIT instructions
    output wire [2:0] reg_addr,    // Register address (R0-R7)
    output wire [6:0] jmp_addr     // Jump target address (0-127)
);

    // Extract opcode from the top 3 bits
    assign opcode = instr[15:13];

    // Field extractions (overlapped depending on instruction type)
    // For SET: pin mask and value
    assign pin_mask    = instr[11:4];   // 8-bit mask for our 8 GPIO pins
    assign pin_val     = instr[3];     // High or low value

    // For WAIT: 10-bit cycle count
    assign wait_cycles = instr[9:0];

    // For Register operations (IN / scratch work)
    assign reg_addr    = instr[2:0];   // 3-bit register selector

    // For JMP: 7-bit target address
    assign jmp_addr    = instr[6:0];   // 7-bit memory address

endmodule
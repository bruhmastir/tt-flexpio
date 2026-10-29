module flexpio_core (
    input wire clk,
    input wire rst_n,
    inout wire [7:0] gio      // Our 8 general-purpose input/output pins
);

    // Internal wires connecting our modules
    wire [6:0] pc_addr;
    wire [15:0] instr;
    
    // Decoder outputs
    wire [2:0] opcode;
    wire [7:0] pin_mask;
    wire pin_val;
    wire [9:0] wait_cycles;
    wire [2:0] reg_addr;
    wire [6:0] jmp_addr;
    
    // Control & Status wires
    wire timer_busy;
    reg jmp_en;
    reg wr_en;
    reg [7:0] wr_data;
    
    // GPIO direction and output control (simple drive logic)
    reg [7:0] gpio_out;
    reg [7:0] gpio_dir; // 1 = output, 0 = input
    
    // Instantiate Program Counter
    program_counter pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .jmp_en(jmp_en),
        .jmp_addr(jmp_addr),
        .pc(pc_addr)
    );

    // Instantiate Instruction Memory
    instruction_memory mem_inst (
        .addr(pc_addr),
        .instr(instr)
    );

    // Instantiate Instruction Decoder
    instruction_decoder decoder_inst (
        .instr(instr),
        .opcode(opcode),
        .pin_mask(pin_mask),
        .pin_val(pin_val),
        .wait_cycles(wait_cycles),
        .reg_addr(reg_addr),
        .jmp_addr(jmp_addr)
    );

    // Instantiate Wait Timer
    wait_timer timer_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start_wait((opcode == 3'b001) && !timer_busy),
        .wait_cycles(wait_cycles),
        .busy(timer_busy)
    );

    // Instantiate Register File (using R1-R7 for general use)
    register_file regs_inst (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_addr(reg_addr),
        .wr_data(wr_data),
        .rd_addr1(reg_addr),
        .rd_data1(),
        .rd_addr2(3'd0),
        .rd_data2()
    );

    // Core Execution Logic (Finite State Machine / Controller)
    always @(*) begin
        // Default control signals
        jmp_en = 1'b0;
        wr_en  = 1'b0;
        wr_data = 8'd0;
        
        // Only execute instructions if the wait timer is NOT busy counting down
        if (!timer_busy) begin
            case (opcode)
                3'b000: begin // SET instruction
                    // Drive masked pins
                end
                3'b001: begin // WAIT instruction
                    // Handled automatically by wait_timer busy signal pausing PC advance
                end
                3'b010: begin // IN instruction (Read pins into register)
                    wr_en = 1'b1;
                    wr_data = gio; // Capture current pin states
                end
                3'b011: begin // JMP instruction
                    jmp_en = 1'b1;
                end
                default: begin
                    // NOP / Safe default
                end
            endcase
        end
    end

    // Tri-state buffer wiring for bidirectional GPIO pins
    genvar g;
    generate
        for (g = 0; g < 8; g = g + 1) begin : gpio_gen
            assign gio[g] = gpio_dir[g] ? gpio_out[g] : 1'bz;
        end
    endgenerate

    // Control pin directions and output values based on SET instructions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gpio_out <= 8'd0;
            gpio_dir <= 8'd0; // Default all pins to inputs on reset
        end else if (!timer_busy && (opcode == 3'b000)) begin
            // Apply pin mask for SET instruction
            gpio_dir <= gpio_dir | pin_mask; // Set pins as outputs
            // Update selected pins to pin_val
            if (pin_val)
                gpio_out <= gpio_out | pin_mask;
            else
                gpio_out <= gpio_out & ~pin_mask;
        end
    end

endmodule
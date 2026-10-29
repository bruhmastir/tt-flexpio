module register_file (
    input wire clk,
    input wire rst_n,
    
    // Write port
    input wire wr_en,          // High if we want to store a value in a register
    input wire [2:0] wr_addr,  // Destination register (0 to 7)
    input wire [7:0] wr_data,  // Data to write
    
    // Read ports (allowing us to read two registers simultaneously if needed)
    input wire [2:0] rd_addr1,
    output wire [7:0] rd_data1,
    
    input wire [2:0] rd_addr2,
    output wire [7:0] rd_data2
);

    // 8 registers, each 8 bits wide
    reg [7:0] regs [0:7];
    integer i;

    // Synchronous write & asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1) begin
                regs[i] <= 8'd0;
            end
        end else if (wr_en) begin
            regs[wr_addr] <= wr_data;
        end
    end

    // Combinational read (R0 always reads as 0 for safety/convenience if desired, or standard read)
    assign rd_data1 = (rd_addr1 == 3'd0) ? 8'd0 : regs[rd_addr1];
    assign rd_data2 = (rd_addr2 == 3'd0) ? 8'd0 : regs[rd_addr2];

endmodule
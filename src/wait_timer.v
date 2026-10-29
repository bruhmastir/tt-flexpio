module wait_timer (
    input wire clk,
    input wire rst_n,
    input wire start_wait,          // High when we load a WAIT instruction
    input wire [9:0] wait_cycles,   // Number of cycles to wait
    output reg busy                 // High while the timer is counting down
);

    reg [9:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 10'd0;
            busy    <= 1'b0;
        end else begin
            if (start_wait && !busy) begin
                if (wait_cycles > 0) begin
                    counter <= wait_cycles - 1'b1; // Load cycles (minus 1 for current cycle)
                    busy    <= 1'b1;
                end
            end else if (busy) begin
                if (counter == 10'd0) begin
                    busy <= 1'b0; // Done waiting!
                end else begin
                    counter <= counter - 1'b1; // Count down
                end
            end
        end
    end

endmodule
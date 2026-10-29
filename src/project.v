/*
 * Copyright (c) 2026 bruhmastir
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_bruhmastir_flexpio (
    input  wire [7:0] ui_in,    // Dedicated inputs (unused for now, tied off)
    output wire [7:0] uo_out,   // Dedicated outputs (unused for now, tied off)
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (1 = output, 0 = input)
    input  wire       ena,      // always 1 when the design is powered, can be ignored
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Tie off unused dedicated outputs
    assign uo_out = 8'd0;

    // Internal wires for our core's GPIO control and data path
    wire [7:0] gio;
    wire [7:0] core_gio_out;
    wire [7:0] core_gio_dir;

    // Bridge Tiny Tapeout's input path into our core's bidirectional bus when pins are inputs
    // In Tiny Tapeout, uio_in reads the physical pin state regardless of direction
    assign gio = uio_in;

    // Instantiate our custom FlexPIO core
    flexpio_core core_inst (
        .clk(clk),
        .rst_n(rst_n)
        // .gio(uio_in) // Route Tiny Tapeout's input path directly into our core's gio bus
    );

    // Route our core's internal driver states directly to Tiny Tapeout's UIO ports
    // (Note: To access internal registers of core_inst cleanly, we can expose them 
    // or map them based on core_inst's internal names).
    
    // For now, let's map them directly:
    assign uio_out = core_inst.gpio_out;
    assign uio_oe  = core_inst.gpio_dir;

endmodule
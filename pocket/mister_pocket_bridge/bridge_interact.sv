//
// bridge_interact.sv
//
// Analogue Pocket APF Bridge Registers → MiSTer status[] Bits
//
// Maps APF bridge register writes at configurable addresses to
// specific bit ranges within a 128-bit MiSTer-compatible status register.
//
// Bridge registers are written from the Pocket OS (interact.json menu)
// on the clk_74a domain. Values are synchronized to clk_sys for use
// by the core.
//
// Copyright (c) 2026 Eric Lewis
// SPDX-License-Identifier: GPL-3.0-or-later
//

module bridge_interact #(
    parameter NUM_REGS = 16
) (
    input         clk_74a,
    input         clk_sys,

    // APF bridge bus (active on clk_74a)
    input  [31:0] bridge_addr,
    input         bridge_wr,
    input  [31:0] bridge_wr_data,
    input         bridge_rd,
    output reg [31:0] bridge_rd_data,

    // MiSTer-compatible status output (active on clk_sys)
    output reg [127:0] status,
    output reg         swap_joysticks,
    output reg  [7:0]  cart_type_override,
    output reg  [2:0]  cpu_speed,
    output reg         clip_sides,
    output reg         reset_request
);

// Register file in clk_74a domain
// Each register is a 32-bit value at address offset [5:2] (word-aligned)
reg [31:0] regs_74a [NUM_REGS];

integer k;
initial begin
    for (k = 0; k < NUM_REGS; k = k + 1)
        regs_74a[k] = 32'd0;
end

// Handle bridge reads and writes
always @(posedge clk_74a) begin
    if (bridge_wr && bridge_addr[31:16] == 16'h0000) begin
        if (bridge_addr[7:2] < NUM_REGS[5:0])
            regs_74a[bridge_addr[7:2]] <= bridge_wr_data;
    end

    if (bridge_rd && bridge_addr[31:16] == 16'h0000) begin
        if (bridge_addr[7:2] < NUM_REGS[5:0])
            bridge_rd_data <= regs_74a[bridge_addr[7:2]];
        else
            bridge_rd_data <= 32'd0;
    end
end

// Synchronize register values to clk_sys domain
// Double-flop each register value (safe since these are quasi-static config values)
reg [31:0] regs_sys [NUM_REGS];
reg [31:0] regs_meta [NUM_REGS];

integer j;
always @(posedge clk_sys) begin
    for (j = 0; j < NUM_REGS; j = j + 1) begin
        regs_meta[j] <= regs_74a[j];
        regs_sys[j]  <= regs_meta[j];
    end
end

// Register layout for the Atari5200 Pocket port:
//   0x00: [0]   = Swap joysticks
//   0x04: [7:0] = Cartridge type override (0 = auto)
//   0x08: [2:0] = CPU speed
//   0x0C: [0]   = Clip sides
//   0x10: [0]   = Reset request
//
// The original MiSTer core consumes these controls primarily through
// status[] bits plus hps_ext cart-select signals, so expose the relevant
// status bits here and provide the decoded values directly to core_top.
always @(posedge clk_sys) begin
    status <= 128'd0;
    swap_joysticks     <= regs_sys[0][0];
    cart_type_override <= regs_sys[1][7:0];
    cpu_speed          <= regs_sys[2][2:0];
    clip_sides         <= regs_sys[3][0];
    reset_request      <= regs_sys[4][0];

    status[5]          <= regs_sys[0][0];
    status[9:7]        <= regs_sys[2][2:0];
    status[34]         <= regs_sys[3][0];
    status[40]         <= regs_sys[4][0];
end

endmodule

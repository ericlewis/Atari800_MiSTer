// pocket_pll.v — Atari 5200 PLL for Analogue Pocket
//
// Input: 74.25 MHz → Output: 57.27 MHz (sys), 114.55 MHz (SDRAM), 57.27 MHz (video)
// The SDRAM clock needs 180° phase shift.

`timescale 1 ps / 1 ps

module pll (
    input  wire        refclk,
    input  wire        rst,
    output wire        outclk_0,   // 57.272728 MHz (clk_sys)
    output wire        outclk_1,   // 114.545456 MHz (clk_mem, 180° phase)
    output wire        outclk_2,   // 57.272728 MHz (clk_vdo)
    output wire        locked
);

altera_pll #(
    .fractional_vco_multiplier ("true"),
    .reference_clock_frequency ("74.25 MHz"),
    .operation_mode            ("direct"),
    .number_of_clocks          (3),
    .output_clock_frequency0   ("57.272728 MHz"),
    .phase_shift0              ("0 ps"),
    .duty_cycle0               (50),
    .output_clock_frequency1   ("114.545456 MHz"),
    .phase_shift1              ("4365 ps"),         // 180° at 114.545 MHz
    .duty_cycle1               (50),
    .output_clock_frequency2   ("57.272728 MHz"),
    .phase_shift2              ("0 ps"),
    .duty_cycle2               (50),
    .pll_type                  ("General"),
    .pll_subtype               ("General")
) pll_inst (
    .refclk   ({1'b0, refclk}),
    .rst      (rst),
    .outclk   ({outclk_2, outclk_1, outclk_0}),
    .locked   (locked),
    .fboutclk (),
    .fbclk    (1'b0),
    .reconfig_to_pll   (64'd0),
    .reconfig_from_pll ()
);

endmodule

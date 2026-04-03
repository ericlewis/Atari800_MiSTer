// pocket_pll.v — Atari 5200 CORE clocks only
// Video uses mf_pllbase (template PLL, known working)
//
// Input: 74.25 MHz
// Outputs:
//   outclk_0: 57.272728 MHz  (clk_sys)
//   outclk_1: 114.545456 MHz (clk_mem, 180° phase for SDRAM)

`timescale 1 ps / 1 ps

module pll (
    input  wire        refclk,
    input  wire        rst,
    output wire        outclk_0,
    output wire        outclk_1,
    output wire        locked
);

altera_pll #(
    .fractional_vco_multiplier ("true"),
    .reference_clock_frequency ("74.25 MHz"),
    .operation_mode            ("direct"),
    .number_of_clocks          (2),
    .output_clock_frequency0   ("57.272728 MHz"),
    .phase_shift0              ("0 ps"),
    .duty_cycle0               (50),
    .output_clock_frequency1   ("114.545456 MHz"),
    .phase_shift1              ("4365 ps"),
    .duty_cycle1               (50),
    .pll_type                  ("General"),
    .pll_subtype               ("General")
) pll_inst (
    .refclk   ({1'b0, refclk}),
    .rst      (rst),
    .outclk   ({outclk_1, outclk_0}),
    .locked   (locked),
    .fboutclk (),
    .fbclk    (1'b0),
    .reconfig_to_pll   (64'd0),
    .reconfig_from_pll ()
);

endmodule

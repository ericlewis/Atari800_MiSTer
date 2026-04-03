// pocket_pll.v — Atari 5200 PLL for Analogue Pocket
//
// Input: 74.25 MHz
// Outputs:
//   outclk_0: 57.272728 MHz  (clk_sys — system clock + video clock)
//   outclk_1: 114.545456 MHz (clk_mem — SDRAM, 180° phase)
//   outclk_2: 7.159091 MHz   (clk_vid — pixel clock for Pocket scaler)
//   outclk_3: 7.159091 MHz   (clk_vid_90 — pixel clock 90° for DDR)

`timescale 1 ps / 1 ps

module pll (
    input  wire        refclk,
    input  wire        rst,
    output wire        outclk_0,
    output wire        outclk_1,
    output wire        outclk_2,
    output wire        outclk_3,
    output wire        locked
);

altera_pll #(
    .fractional_vco_multiplier ("true"),
    .reference_clock_frequency ("74.25 MHz"),
    .operation_mode            ("direct"),
    .number_of_clocks          (4),
    .output_clock_frequency0   ("57.272728 MHz"),
    .phase_shift0              ("0 ps"),
    .duty_cycle0               (50),
    .output_clock_frequency1   ("114.545456 MHz"),
    .phase_shift1              ("4365 ps"),
    .duty_cycle1               (50),
    .output_clock_frequency2   ("7.159091 MHz"),
    .phase_shift2              ("0 ps"),
    .duty_cycle2               (50),
    .output_clock_frequency3   ("7.159091 MHz"),
    .phase_shift3              ("34917 ps"),
    .duty_cycle3               (50),
    .pll_type                  ("General"),
    .pll_subtype               ("General")
) pll_inst (
    .refclk   ({1'b0, refclk}),
    .rst      (rst),
    .outclk   ({outclk_3, outclk_2, outclk_1, outclk_0}),
    .locked   (locked),
    .fboutclk (),
    .fbclk    (1'b0),
    .reconfig_to_pll   (64'd0),
    .reconfig_from_pll ()
);

endmodule

//============================================================================
//  Atari 5200 Core Top for Analogue Pocket
//
//  Copyright (C) 2026 Eric Lewis
//  SPDX-License-Identifier: GPL-3.0-or-later
//
//  Based on Atari5200.sv (MiSTer) by Sorgelig
//  Atari core by Mark Watson
//============================================================================

`default_nettype none

module core_top (

input   wire            clk_74a,
input   wire            clk_74b,

inout   wire    [7:0]   cart_tran_bank2,
output  wire            cart_tran_bank2_dir,
inout   wire    [7:0]   cart_tran_bank3,
output  wire            cart_tran_bank3_dir,
inout   wire    [7:0]   cart_tran_bank1,
output  wire            cart_tran_bank1_dir,
inout   wire    [7:4]   cart_tran_bank0,
output  wire            cart_tran_bank0_dir,
inout   wire            cart_tran_pin30,
output  wire            cart_tran_pin30_dir,
output  wire            cart_pin30_pwroff_reset,
inout   wire            cart_tran_pin31,
output  wire            cart_tran_pin31_dir,

input   wire            port_ir_rx,
output  wire            port_ir_tx,
output  wire            port_ir_rx_disable,

inout   wire            port_tran_si,
output  wire            port_tran_si_dir,
inout   wire            port_tran_so,
output  wire            port_tran_so_dir,
inout   wire            port_tran_sck,
output  wire            port_tran_sck_dir,
inout   wire            port_tran_sd,
output  wire            port_tran_sd_dir,

output  wire    [21:16] cram0_a,
inout   wire    [15:0]  cram0_dq,
input   wire            cram0_wait,
output  wire            cram0_clk,
output  wire            cram0_adv_n,
output  wire            cram0_cre,
output  wire            cram0_ce0_n,
output  wire            cram0_ce1_n,
output  wire            cram0_oe_n,
output  wire            cram0_we_n,
output  wire            cram0_ub_n,
output  wire            cram0_lb_n,

output  wire    [21:16] cram1_a,
inout   wire    [15:0]  cram1_dq,
input   wire            cram1_wait,
output  wire            cram1_clk,
output  wire            cram1_adv_n,
output  wire            cram1_cre,
output  wire            cram1_ce0_n,
output  wire            cram1_ce1_n,
output  wire            cram1_oe_n,
output  wire            cram1_we_n,
output  wire            cram1_ub_n,
output  wire            cram1_lb_n,

output  wire    [12:0]  dram_a,
output  wire    [1:0]   dram_ba,
inout   wire    [15:0]  dram_dq,
output  wire    [1:0]   dram_dqm,
output  wire            dram_clk,
output  wire            dram_cke,
output  wire            dram_ras_n,
output  wire            dram_cas_n,
output  wire            dram_we_n,

output  wire    [16:0]  sram_a,
inout   wire    [15:0]  sram_dq,
output  wire            sram_oe_n,
output  wire            sram_we_n,
output  wire            sram_ub_n,
output  wire            sram_lb_n,

input   wire            vblank,

output  wire            dbg_tx,
input   wire            dbg_rx,

output  wire            user1,
input   wire            user2,

inout   wire            aux_sda,
output  wire            aux_scl,

output  wire            vpll_feed,

// logical connections
output  wire    [23:0]  video_rgb,
output  wire            video_rgb_clock,
output  wire            video_rgb_clock_90,
output  wire            video_de,
output  wire            video_skip,
output  wire            video_vs,
output  wire            video_hs,

output  wire            audio_mclk,
input   wire            audio_adc,
output  wire            audio_dac,
output  wire            audio_lrck,

output  wire            bridge_endian_little,
input   wire    [31:0]  bridge_addr,
input   wire            bridge_rd,
output  reg     [31:0]  bridge_rd_data,
input   wire            bridge_wr,
input   wire    [31:0]  bridge_wr_data,

input   wire    [31:0]  cont1_key,
input   wire    [31:0]  cont2_key,
input   wire    [31:0]  cont3_key,
input   wire    [31:0]  cont4_key,
input   wire    [31:0]  cont1_joy,
input   wire    [31:0]  cont2_joy,
input   wire    [31:0]  cont3_joy,
input   wire    [31:0]  cont4_joy,
input   wire    [15:0]  cont1_trig,
input   wire    [15:0]  cont2_trig,
input   wire    [15:0]  cont3_trig,
input   wire    [15:0]  cont4_trig

);

// ========================================================================
//  Unused I/O tie-offs
// ========================================================================

assign port_ir_tx = 0;
assign port_ir_rx_disable = 1;
assign bridge_endian_little = 0;

assign cart_tran_bank3 = 8'hzz;            assign cart_tran_bank3_dir = 1'b0;
assign cart_tran_bank2 = 8'hzz;            assign cart_tran_bank2_dir = 1'b0;
assign cart_tran_bank1 = 8'hzz;            assign cart_tran_bank1_dir = 1'b0;
assign cart_tran_bank0 = 4'hf;             assign cart_tran_bank0_dir = 1'b1;
assign cart_tran_pin30 = 1'b0;             assign cart_tran_pin30_dir = 1'bz;
assign cart_pin30_pwroff_reset = 1'b0;
assign cart_tran_pin31 = 1'bz;             assign cart_tran_pin31_dir = 1'b0;

assign port_tran_so = 1'bz;               assign port_tran_so_dir = 1'b0;
assign port_tran_si = 1'bz;               assign port_tran_si_dir = 1'b0;
assign port_tran_sck = 1'bz;              assign port_tran_sck_dir = 1'b0;
assign port_tran_sd = 1'bz;               assign port_tran_sd_dir = 1'b0;

assign cram0_a = 'h0;      assign cram0_dq = {16{1'bZ}};   assign cram0_clk = 0;
assign cram0_adv_n = 1;    assign cram0_cre = 0;            assign cram0_ce0_n = 1;
assign cram0_ce1_n = 1;    assign cram0_oe_n = 1;           assign cram0_we_n = 1;
assign cram0_ub_n = 1;     assign cram0_lb_n = 1;

assign cram1_a = 'h0;      assign cram1_dq = {16{1'bZ}};   assign cram1_clk = 0;
assign cram1_adv_n = 1;    assign cram1_cre = 0;            assign cram1_ce0_n = 1;
assign cram1_ce1_n = 1;    assign cram1_oe_n = 1;           assign cram1_we_n = 1;
assign cram1_ub_n = 1;     assign cram1_lb_n = 1;

assign sram_a = 'h0;       assign sram_dq = {16{1'bZ}};
assign sram_oe_n = 1;      assign sram_we_n = 1;
assign sram_ub_n = 1;      assign sram_lb_n = 1;

assign dbg_tx = 1'bZ;
assign user1 = 1'bZ;
assign aux_scl = 1'bZ;
assign vpll_feed = 1'bZ;

// ========================================================================
//  Bridge bus mux
// ========================================================================

wire [31:0] cmd_bridge_rd_data;
wire [31:0] interact_bridge_rd_data;

always @(*) begin
    casex (bridge_addr)
    32'h00xxxxxx: bridge_rd_data <= interact_bridge_rd_data;
    32'hF8xxxxxx: bridge_rd_data <= cmd_bridge_rd_data;
    default:      bridge_rd_data <= 0;
    endcase
end

// ========================================================================
//  Host/target command handler
// ========================================================================

wire        reset_n;
wire        pll_core_locked;
wire        pll_core_locked_s;

synch_3 s01 (pll_core_locked, pll_core_locked_s, clk_74a);

wire        status_boot_done  = pll_core_locked_s;
wire        status_setup_done = pll_core_locked_s;
wire        status_running    = reset_n;

wire        dataslot_requestread;
wire [15:0] dataslot_requestread_id;
wire        dataslot_requestread_ack = 1;
wire        dataslot_requestread_ok  = 1;
wire        dataslot_requestwrite;
wire [15:0] dataslot_requestwrite_id;
wire [31:0] dataslot_requestwrite_size;
wire        dataslot_requestwrite_ack = 1;
wire        dataslot_requestwrite_ok  = 1;
wire        dataslot_update;
wire [15:0] dataslot_update_id;
wire [31:0] dataslot_update_size;
wire        dataslot_allcomplete;
wire [31:0] rtc_epoch_seconds;
wire [31:0] rtc_date_bcd;
wire [31:0] rtc_time_bcd;
wire        rtc_valid;
wire        savestate_supported  = 0;
wire [31:0] savestate_addr       = 0;
wire [31:0] savestate_size       = 0;
wire [31:0] savestate_maxloadsize = 0;
wire        savestate_start;
wire        savestate_start_ack  = 0;
wire        savestate_start_busy = 0;
wire        savestate_start_ok   = 0;
wire        savestate_start_err  = 0;
wire        savestate_load;
wire        savestate_load_ack   = 0;
wire        savestate_load_busy  = 0;
wire        savestate_load_ok    = 0;
wire        savestate_load_err   = 0;
wire        osnotify_inmenu;
reg         target_dataslot_read;
reg         target_dataslot_write;
reg         target_dataslot_getfile;
reg         target_dataslot_openfile;
wire        target_dataslot_ack;
wire        target_dataslot_done;
wire  [2:0] target_dataslot_err;
reg  [15:0] target_dataslot_id;
reg  [31:0] target_dataslot_slotoffset;
reg  [31:0] target_dataslot_bridgeaddr;
reg  [31:0] target_dataslot_length;
wire [31:0] target_buffer_param_struct;
wire [31:0] target_buffer_resp_struct;
wire  [9:0] datatable_addr;
wire        datatable_wren;
wire [31:0] datatable_data;
wire [31:0] datatable_q;

core_bridge_cmd icb (
    .clk                        ( clk_74a ),
    .reset_n                    ( reset_n ),
    .bridge_endian_little       ( bridge_endian_little ),
    .bridge_addr                ( bridge_addr ),
    .bridge_rd                  ( bridge_rd ),
    .bridge_rd_data             ( cmd_bridge_rd_data ),
    .bridge_wr                  ( bridge_wr ),
    .bridge_wr_data             ( bridge_wr_data ),
    .status_boot_done           ( status_boot_done ),
    .status_setup_done          ( status_setup_done ),
    .status_running             ( status_running ),
    .dataslot_requestread       ( dataslot_requestread ),
    .dataslot_requestread_id    ( dataslot_requestread_id ),
    .dataslot_requestread_ack   ( dataslot_requestread_ack ),
    .dataslot_requestread_ok    ( dataslot_requestread_ok ),
    .dataslot_requestwrite      ( dataslot_requestwrite ),
    .dataslot_requestwrite_id   ( dataslot_requestwrite_id ),
    .dataslot_requestwrite_size ( dataslot_requestwrite_size ),
    .dataslot_requestwrite_ack  ( dataslot_requestwrite_ack ),
    .dataslot_requestwrite_ok   ( dataslot_requestwrite_ok ),
    .dataslot_update            ( dataslot_update ),
    .dataslot_update_id         ( dataslot_update_id ),
    .dataslot_update_size       ( dataslot_update_size ),
    .dataslot_allcomplete       ( dataslot_allcomplete ),
    .rtc_epoch_seconds          ( rtc_epoch_seconds ),
    .rtc_date_bcd               ( rtc_date_bcd ),
    .rtc_time_bcd               ( rtc_time_bcd ),
    .rtc_valid                  ( rtc_valid ),
    .savestate_supported        ( savestate_supported ),
    .savestate_addr             ( savestate_addr ),
    .savestate_size             ( savestate_size ),
    .savestate_maxloadsize      ( savestate_maxloadsize ),
    .savestate_start            ( savestate_start ),
    .savestate_start_ack        ( savestate_start_ack ),
    .savestate_start_busy       ( savestate_start_busy ),
    .savestate_start_ok         ( savestate_start_ok ),
    .savestate_start_err        ( savestate_start_err ),
    .savestate_load             ( savestate_load ),
    .savestate_load_ack         ( savestate_load_ack ),
    .savestate_load_busy        ( savestate_load_busy ),
    .savestate_load_ok          ( savestate_load_ok ),
    .savestate_load_err         ( savestate_load_err ),
    .osnotify_inmenu            ( osnotify_inmenu ),
    .target_dataslot_read       ( target_dataslot_read ),
    .target_dataslot_write      ( target_dataslot_write ),
    .target_dataslot_getfile    ( target_dataslot_getfile ),
    .target_dataslot_openfile   ( target_dataslot_openfile ),
    .target_dataslot_ack        ( target_dataslot_ack ),
    .target_dataslot_done       ( target_dataslot_done ),
    .target_dataslot_err        ( target_dataslot_err ),
    .target_dataslot_id         ( target_dataslot_id ),
    .target_dataslot_slotoffset ( target_dataslot_slotoffset ),
    .target_dataslot_bridgeaddr ( target_dataslot_bridgeaddr ),
    .target_dataslot_length     ( target_dataslot_length ),
    .target_buffer_param_struct ( target_buffer_param_struct ),
    .target_buffer_resp_struct  ( target_buffer_resp_struct ),
    .datatable_addr             ( datatable_addr ),
    .datatable_wren             ( datatable_wren ),
    .datatable_data             ( datatable_data ),
    .datatable_q                ( datatable_q )
);

// ========================================================================
//  Interact registers
// ========================================================================

wire [127:0] status;

bridge_interact #(.NUM_REGS(16)) interact_bridge (
    .clk_74a        (clk_74a),
    .clk_sys        (clk_sys),
    .bridge_addr    (bridge_addr),
    .bridge_wr      (bridge_wr & (bridge_addr[31:24] == 8'h00)),
    .bridge_wr_data (bridge_wr_data),
    .bridge_rd      (bridge_rd & (bridge_addr[31:24] == 8'h00)),
    .bridge_rd_data (interact_bridge_rd_data),
    .status         (status)
);

// ========================================================================
//  Clocks: 74.25 MHz → 57.27 / 114.55 / 57.27 MHz
// ========================================================================

wire clk_sys;     // 57.27 MHz
wire clk_mem;     // 114.55 MHz (SDRAM)
wire clk_vid;     // 12.288 MHz (video pixel clock — from template PLL)
wire clk_vid_90;  // 12.288 MHz 90°

wire pll_core_locked_a, pll_core_locked_b;
assign pll_core_locked = pll_core_locked_a & pll_core_locked_b;

// Core PLL: system + SDRAM clocks
pll pll_core (
    .refclk   (clk_74a),
    .rst      (1'b0),
    .outclk_0 (clk_sys),
    .outclk_1 (clk_mem),
    .locked   (pll_core_locked_a)
);

// Video PLL: uses template mf_pllbase (12.288 MHz, known working)
mf_pllbase pll_vid (
    .refclk   (clk_74a),
    .rst      (1'b0),
    .outclk_0 (clk_vid),
    .outclk_1 (clk_vid_90),
    .locked   (pll_core_locked_b)
);

// ========================================================================
//  Video Output
// ========================================================================

wire [7:0] Ro, Go, Bo;
wire       HBlank_o, VBlank_o, HSync_o, VSync_o;
wire       ce_pix_raw;

// Video at 12.288 MHz (template PLL, proven sync).
// Sync counters to ANTIC's hsync/vsync edges so the picture aligns.
assign video_rgb_clock    = clk_vid;
assign video_rgb_clock_90 = clk_vid_90;
assign video_skip = 1'b0;

// Line buffer approach: capture ANTIC scanlines into dual-port BRAM,
// read them out at 12.288 MHz with our proven generated timing.
// This eliminates the drift between ANTIC and output frame rates.

// Framebuffer: 320x256, 8-bit RGB332, dual-port BRAM.
// Uses 512-pixel wide addressing (power of 2) for simple {y,x} concat.
// Write: clk_sys at ce_pix rate. Read: clk_vid at 12.288 MHz.

reg ce_pix_raw_old = 0;
wire ce_pix = ce_pix_raw & ~ce_pix_raw_old;
always @(posedge clk_sys) ce_pix_raw_old <= ce_pix_raw;

// FB BRAM: 256 lines x 512 pixels x 8 bits = 128K entries
reg  [7:0] fb [0:131071]; // 2^17
reg  [7:0] fb_rddata;

// Write side (clk_sys)
reg  [8:0] fb_x = 0;  // 0-319
reg  [7:0] fb_y = 0;  // 0-255
reg        fb_hs_prev = 0;
reg        fb_vs_prev = 0;

always @(posedge clk_sys) begin
    fb_hs_prev <= HSync_o;
    fb_vs_prev <= VSync_o;

    if (ce_pix & ~HBlank_o & ~VBlank_o & fb_x < 320) begin
        fb[{fb_y, fb_x}] <= {Ro[7:5], Go[7:5], Bo[7:6]};
        fb_x <= fb_x + 1'd1;
    end

    // New line
    if (HSync_o & ~fb_hs_prev) begin
        fb_x <= 0;
        if (~VBlank_o) fb_y <= fb_y + 1'd1;
    end

    // New frame
    if (VSync_o & ~fb_vs_prev)
        fb_y <= 0;
end

// Read side (clk_vid)
reg [16:0] fb_rdaddr;
always @(posedge clk_vid)
    fb_rddata <= fb[fb_rdaddr];

// Generated timing (proven stable sync)
localparam H_BPORCH = 10'd5;
localparam H_ACTIVE = 10'd320;
localparam H_TOTAL  = 10'd400;
localparam V_BPORCH = 10'd10;
localparam V_ACTIVE = 10'd240;
localparam V_TOTAL  = 10'd512;

reg [9:0] h_cnt = 0;
reg [9:0] v_cnt = 0;
reg       vid_vs = 0, vid_hs = 0, vid_de = 0;

always @(posedge clk_vid) begin
    vid_de <= 0; vid_vs <= 0; vid_hs <= 0;

    h_cnt <= h_cnt + 1'd1;
    if (h_cnt == H_TOTAL - 1) begin
        h_cnt <= 0;
        v_cnt <= v_cnt + 1'd1;
        if (v_cnt == V_TOTAL - 1) v_cnt <= 0;
    end

    if (h_cnt == 0 && v_cnt == 0) vid_vs <= 1;
    if (h_cnt == 3) vid_hs <= 1;

    if (h_cnt >= H_BPORCH && h_cnt < H_ACTIVE + H_BPORCH &&
        v_cnt >= V_BPORCH && v_cnt < V_ACTIVE + V_BPORCH)
        vid_de <= 1;

    // Read address: {line[7:0], pixel[8:0]}
    fb_rdaddr <= {v_cnt[7:0], h_cnt[8:0] - H_BPORCH[8:0]};
end

// Expand RGB332 → RGB888
wire [7:0] exp_r = {fb_rddata[7:5], fb_rddata[7:5], fb_rddata[7:6]};
wire [7:0] exp_g = {fb_rddata[4:2], fb_rddata[4:2], fb_rddata[4:3]};
wire [7:0] exp_b = {fb_rddata[1:0], fb_rddata[1:0], fb_rddata[1:0], fb_rddata[1:0]};

assign video_rgb = vid_de ? {exp_r, exp_g, exp_b} : 24'd0;
assign video_de  = vid_de;
assign video_vs  = vid_vs;
assign video_hs  = vid_hs;

// ========================================================================
//  Audio Output (I2S)
// ========================================================================

assign audio_mclk = audgen_mclk;
assign audio_dac  = audgen_dac;
assign audio_lrck = audgen_lrck;

reg  [21:0] audgen_accum;
reg         audgen_mclk;
parameter [20:0] CYCLE_48KHZ = 21'd122880 * 2;

always @(posedge clk_74a) begin
    audgen_accum <= audgen_accum + CYCLE_48KHZ;
    if (audgen_accum >= 21'd742500) begin
        audgen_mclk  <= ~audgen_mclk;
        audgen_accum <= audgen_accum - 21'd742500 + CYCLE_48KHZ;
    end
end

reg  [1:0]  aud_mclk_divider;
wire        audgen_sclk = aud_mclk_divider[1];
always @(posedge audgen_mclk) aud_mclk_divider <= aud_mclk_divider + 1'b1;

reg  [4:0]  audgen_lrck_cnt;
reg         audgen_lrck;
reg         audgen_dac;
reg  [15:0] audgen_shift;
reg  [15:0] aud_l_latch, aud_r_latch;

always @(posedge clk_sys) begin
    aud_l_latch <= cpu_halt ? 16'd0 : {laudio[15], laudio[15:1]};
    aud_r_latch <= cpu_halt ? 16'd0 : {raudio[15], raudio[15:1]};
end

always @(negedge audgen_sclk) begin
    audgen_lrck_cnt <= audgen_lrck_cnt + 1'b1;
    if (audgen_lrck_cnt == 5'd31) audgen_lrck <= ~audgen_lrck;
    if (audgen_lrck_cnt == 5'd0)  audgen_shift <= audgen_lrck ? aud_r_latch : aud_l_latch;
    audgen_dac   <= audgen_shift[15];
    audgen_shift <= {audgen_shift[14:0], 1'b0};
end

// ========================================================================
//  SDRAM
// ========================================================================

assign dram_cke = 1;

// SDRAM clock via DDR output (same as MiSTer)
altddio_out #(
    .extend_oe_disable     ("OFF"),
    .intended_device_family("Cyclone V"),
    .invert_output         ("OFF"),
    .lpm_hint              ("UNUSED"),
    .lpm_type              ("altddio_out"),
    .oe_reg                ("UNREGISTERED"),
    .power_up_high         ("OFF"),
    .width                 (1)
) sdramclk_ddr (
    .datain_h  (1'b0),
    .datain_l  (1'b1),
    .outclock  (clk_mem),
    .dataout   (dram_clk),
    .aclr      (1'b0),
    .aset      (1'b0),
    .oe        (1'b1),
    .outclocken(1'b1),
    .sclr      (1'b0),
    .sset      (1'b0)
);

// ========================================================================
//  Reset
// ========================================================================

reg [19:0] reset_counter = 20'd500000; // ~9ms at 57MHz, enough for SDRAM init
wire       atari_reset = |reset_counter;

always @(posedge clk_sys) begin
    if (status[0])
        reset_counter <= 20'd500000;
    else if (reset_counter)
        reset_counter <= reset_counter - 1'd1;
end

// ========================================================================
//  Input Mapping (5200 controller: analog stick + 21-bit digital)
// ========================================================================

// 5200 JOY format: [20:0]
//   [3:0]  = digital directions (derived from analog stick)
//   [4]    = fire 1
//   [5]    = fire 2
//   [6]    = numpad *
//   [7]    = numpad #
//   [8]    = start
//   [9]    = pause
//   [10]   = reset
//   [11-20]= numpad 0-9

wire [20:0] joy_0 = {
    10'd0,                          // [20:11] numpad 0-9 (TODO)
    cont1_key[13],                  // [10] reset → start button
    cont1_key[7],                   // [9]  pause → Y
    cont1_key[15],                  // [8]  start → start
    cont1_key[6],                   // [7]  # → X
    cont1_key[8],                   // [6]  * → L1
    cont1_key[5],                   // [5]  fire 2 → B
    cont1_key[4],                   // [4]  fire 1 → A
    cont1_key[3],                   // [3]  right
    cont1_key[2],                   // [2]  left
    cont1_key[1],                   // [1]  down
    cont1_key[0]                    // [0]  up
};

wire [20:0] joy_1 = {
    10'd0, cont2_key[13], cont2_key[7], cont2_key[15],
    cont2_key[6], cont2_key[8], cont2_key[5], cont2_key[4],
    cont2_key[3], cont2_key[2], cont2_key[1], cont2_key[0]
};

// Analog sticks — Pocket cont_joy: [7:0]=lstick_x, [15:8]=lstick_y (unsigned 0-255)
// Atari expects signed -128 to +127
wire [7:0] joy1x = cont1_joy[7:0];
wire [7:0] joy1y = cont1_joy[15:8];
wire [7:0] joy2x = cont2_joy[7:0];
wire [7:0] joy2y = cont2_joy[15:8];

// ========================================================================
//  BIOS ROM (2KB, from 5200.mif at synthesis time)
// ========================================================================

wire  [7:0] rom_data;
wire [10:0] rom_addr;

dpram #(11, 8, "rtl/rom/5200.mif") bios_5200 (
    .clock     (clk_sys),
    .address_a (ioctl_addr[10:0]),
    .data_a    (ioctl_dout),
    .wren_a    (ioctl_wr && (ioctl_index == 0)),
    .address_b (rom_addr),
    .q_b       (rom_data)
);

// ========================================================================
//  Cartridge loading via data slots
// ========================================================================

reg        ioctl_download = 0;
reg        ioctl_wr = 0;
reg [26:0] ioctl_addr;
reg  [7:0] ioctl_dout;
reg  [7:0] ioctl_index;

// Bridge write capture (clk_74a domain)
reg [26:0] dl_addr_74 = 0;
reg  [7:0] dl_data_74;
reg        dl_wr_74;
reg        dl_active_74 = 0;
reg  [7:0] dl_index_74;

always @(posedge clk_74a) begin
    dl_wr_74 <= 0;
    if (dataslot_requestread) begin
        dl_active_74 <= 1;
        dl_addr_74   <= 0;
        case (dataslot_requestread_id)
            16'd0:   dl_index_74 <= 8'd0;    // BIOS
            16'd1:   dl_index_74 <= 8'd1;    // Cartridge
            default: dl_index_74 <= dataslot_requestread_id[7:0];
        endcase
    end
    if (bridge_wr && bridge_addr[31:24] == 8'h20 && dl_active_74) begin
        dl_data_74 <= bridge_wr_data[7:0];
        dl_wr_74   <= 1;
        dl_addr_74 <= dl_addr_74 + 1'd1;
    end
    if (dataslot_allcomplete) dl_active_74 <= 0;
end

// Cross to clk_sys domain
reg [2:0] dl_wr_sync;
reg       dl_active_s0, dl_active_s1;
always @(posedge clk_sys) begin
    dl_wr_sync <= {dl_wr_sync[1:0], dl_wr_74};
    dl_active_s0 <= dl_active_74;
    dl_active_s1 <= dl_active_s0;
    ioctl_wr <= 0;
    if (dl_wr_sync[1] & ~dl_wr_sync[2]) begin
        ioctl_wr   <= 1;
        ioctl_dout <= dl_data_74;
        ioctl_addr <= dl_addr_74 - 1'd1;
    end
    ioctl_download <= dl_active_s1;
    ioctl_index    <= dl_index_74;
end

// DMA to SDRAM for cartridge loading
wire       sdram_ready;
wire       dma_ready;
reg        dma_req = 0;
reg        ioctl_wait = 1;
wire       file_download = ioctl_download && ioctl_index != 99;

always @(posedge clk_sys) begin
    reg started = 0;
    if (sdram_ready) begin
        if (!started) begin
            started <= 1;
            ioctl_wait <= 0;
        end
        if (ioctl_index != 0 && ioctl_download) begin
            if (dma_ready) begin
                ioctl_wait <= 0;
                dma_req <= 0;
            end
            if (ioctl_wr) begin
                ioctl_wait <= 1;
                dma_req <= 1;
            end
        end
        else
            ioctl_wait <= 0;
    end
end

// ========================================================================
//  Atari 5200 Core
// ========================================================================

wire [15:0] laudio, raudio;
wire        cpu_halt;

wire  [7:0] cart_select = 8'd0; // TODO: from hps_ext equivalent
wire        set_reset = 0;
wire        set_pause = 0;
wire  [2:0] atari_hotkeys;

atari5200top atari5200top_inst (
    .CLK          (clk_sys),
    .CLK_SDRAM    (clk_mem),
    .RESET_N      (~atari_reset),

    .SDRAM_BA     (dram_ba),
    .SDRAM_nRAS   (dram_ras_n),
    .SDRAM_nCAS   (dram_cas_n),
    .SDRAM_nWE    (dram_we_n),
    .SDRAM_A      (dram_a),
    .SDRAM_DQ     (dram_dq),
    .SDRAM_nCS    (),
    .SDRAM_DQMH   (dram_dqm[1]),
    .SDRAM_DQML   (dram_dqm[0]),

    .ROM_ADDR     (rom_addr),
    .ROM_DATA     (rom_data),

    .SDRAM_READY  (sdram_ready),
    .OSD_PAUSE    (file_download),
    .SET_RESET_IN (set_reset),
    .SET_PAUSE_IN (set_pause),
    .CART_SELECT_IN(cart_select),
    .HOT_KEYS     (atari_hotkeys),
    .COLD_RESET_MENU(status[0]),

    // DMA for cartridge loading
    .HPS_DMA_ADDR (ioctl_index == 0 ? {15'b100111000001000, ioctl_addr[10:0]} : ioctl_addr[25:0]),
    .HPS_DMA_REQ  (dma_req),
    .HPS_DMA_DATA_OUT(ioctl_dout),
    .HPS_DMA_READY(dma_ready),

    .VGA_VS       (VSync_o),
    .VGA_HS       (HSync_o),
    .VGA_B        (Bo),
    .VGA_G        (Go),
    .VGA_R        (Ro),
    .VGA_PIXCE    (ce_pix_raw),
    .HBLANK       (HBlank_o),
    .VBLANK       (VBlank_o),

    .CPU_SPEED    (6'd1),   // 1x speed
    .CLIP_SIDES   (1'b0),
    .AUDIO_L      (laudio),
    .AUDIO_R      (raudio),
    .CPU_HALT     (cpu_halt),

    .PS2_KEY      (11'd0),  // TODO: dock keyboard

    // Analog joysticks
    .JOY1X        (joy1x),
    .JOY1Y        (joy1y),
    .JOY2X        (joy2x),
    .JOY2Y        (joy2y),
    .JOY3X        (8'd0),
    .JOY3Y        (8'd0),
    .JOY4X        (8'd0),
    .JOY4Y        (8'd0),

    // Digital joysticks
    .JOY1         (joy_0),
    .JOY2         (joy_1),
    .JOY3         (21'd0),
    .JOY4         (21'd0)
);

endmodule

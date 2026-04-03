// Simple dual-port RAM with optional MIF initialization
// Replaces MiSTer sys/ dpram for Pocket port

module dpram #(
    parameter AWIDTH = 8,
    parameter DWIDTH = 8,
    parameter MIF_FILE = " "
) (
    input                    clock,

    input      [AWIDTH-1:0]  address_a,
    input      [DWIDTH-1:0]  data_a,
    input                    wren_a,

    input      [AWIDTH-1:0]  address_b,
    output reg [DWIDTH-1:0]  q_b
);

reg [DWIDTH-1:0] mem [0:(2**AWIDTH)-1] /* synthesis ramstyle = "no_rw_check" */;

initial begin
    if (MIF_FILE != " ")
        $readmemh(MIF_FILE, mem);
end

always @(posedge clock) begin
    if (wren_a)
        mem[address_a] <= data_a;
    q_b <= mem[address_b];
end

endmodule

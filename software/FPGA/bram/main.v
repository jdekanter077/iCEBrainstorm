module main (
  input wire clk_i,

  input wire btn_0,
  input wire btn_1,

  input wire in_0, 
  input wire in_1, 
  input wire in_2, 
  input wire in_3, 

  output wire out_0,
  output wire out_1,
  output wire out_2,
  output wire out_3
);

localparam [10:0] address = 11'd12;

wire [3:0] mask = 16'b0; // mask is negated (mad emoji)
wire [3:0] ram_rdata;
wire [3:0] inputs = {in_3, in_2, in_1, in_0};

reg [3:0] leds;

// synchronize buttons
reg btn0_sync, btn1_sync;

always @(posedge clk_i) begin
    btn0_sync <= btn_0;
    btn1_sync <= btn_1;
end

wire re = btn0_sync;
wire we = btn1_sync;

always @(posedge clk_i) begin
    if (re)
        leds <= ram_rdata;
end

assign {out_3, out_2, out_1, out_0} = leds;

SB_RAM40_4K ram40_4kinst_physical (
    .RDATA(ram_rdata),
    .RADDR(address),
    .WADDR(address),
    .MASK(mask),
    .WDATA(inputs),
    .RCLKE(1'b1),
    .RCLK(clk_i),
    .RE(re),
    .WCLKE(1'b1),
    .WCLK(clk_i),
    .WE(we)
);

defparam ram40_4kinst_physical.READ_MODE=2;
defparam ram40_4kinst_physical.WRITE_MODE=2;

endmodule

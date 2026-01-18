module main (
  input wire clk_i,
  input wire btn_0,

  output wire out_0,
  output wire out_1,
  output wire out_2,
  output wire out_3
);

reg [23:0] freqcounter = 0;
wire tick;
parameter PRESCALER = 24'd16_000_000; //16MHz to 1 Hz

assign tick = (freqcounter == (PRESCALER - 1));

always @ (posedge clk_i)
  begin 
    if (tick)
      freqcounter <= 0;
    else 
      freqcounter <= freqcounter + 1;
  end

// counter logic
reg [3:0] led_count;
assign {out_3, out_2, out_1, out_0} = led_count;

always @ (posedge clk_i)
  begin
    if (tick)
      led_count <= led_count + 1;
  end

endmodule

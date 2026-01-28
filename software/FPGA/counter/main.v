module main (
  input wire clk_i,
  input wire btn_0,

  output wire out_0,
  output wire out_1,
  output wire out_2,
  output wire out_3
);
parameter PRESCALER = 24'd16_000_000; //16MHz to 1 Hz

reg [23:0] freqcounter_d, freqcounter_q; //frequency prescaler counters
wire tick; //generated tick

always @(*) begin //combinational block
freqcounter_d = freqcounter_q + 1;
tick = (freqcounter_q == (PRESCALER - 1));
end

always @ (posedge clk_i) //move state forward
  begin 
    if (tick)
      freqcounter_q <= 0;
    else 
      freqcounter_q <= freqcounter_d;
  end

// counter logic
reg [3:0] led_count_d, led_count_q;

always @(*) begin //combinational block
led_count_d = led_count_q + 1;
{out_3, out_2, out_1, out_0} = led_count_q;
end

always @ (posedge clk_i) //move counter forward
  begin
    if (tick)
      led_count_q <= led_count_d;
  end

endmodule

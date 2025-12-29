`default_nettype none

module top (
    input  wire btn0,
    input  wire btn1,
    output wire led0,
    output wire led1
);

    // Direct combinational wiring
    assign led0 = btn0;
    assign led1 = btn1;

endmodule


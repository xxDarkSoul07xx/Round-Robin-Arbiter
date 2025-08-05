module round_robin_arbiter_tb;
  parameter int requesters = 4; // 4 requesters to test

  logic clk; // The clock
  logic reset; // The reset
  logic [requesters-1:0] request; // The requests (inputs)
  logic [requesters-1:0] chosen; // The one that was granted (output)

  // DUT
  round_robin_arbiter #(requesters) dut (
    .clk(clk),
    .reset(reset),
    .request(request),
    .chosen(chosen)
  );

  // Make the clock (10ns period)
  initial clk = 0;
  always #5 clk = ~clk;

  // This is to see the waveform
  initial begin
    $dumpfile("round_robin_arbiter_tb.vcd");
    $dumpvars(0, round_robin_arbiter_tb);
  end

  // Testing the arbiter
  initial begin
    $display("Time\tRequest\tChosen");
    $monitor("%0t\t%b\t%b", $time, request, chosen);
	
    // Reset everything
    reset = 1;
    request = 4'b0000;

    // Reset goes low, so requests can be sent
    #10 reset = 0;

    // Test scenarios
    #10 request = 4'b0101; // 0 and 2 (granted based on the rotation)
    #10 request = 4'b1010; // 1 and 3
    #10 request = 4'b1111; // All
    #10 request = 4'b0000; // None
    #10 request = 4'b0100; // 2 only

    // Wait and then end the test
    #20 $finish;
  end

endmodule

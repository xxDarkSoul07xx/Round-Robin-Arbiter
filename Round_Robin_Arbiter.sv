module round_robin_arbiter #(
  parameter int requesters = 4
)(
  input logic clk, // This is the clock
  input logic reset, // Will reset the arbiter
  input logic [requesters-1:0] request, // Vector of the requesters
  output logic [requesters-1:0] chosen // Which request got access
);

  
  // Keeps track of where arbitration started
  logic [$clog2(requesters)-1:0] starting_index;

  // Simulate wrap around by duplicating the request vector and then a right shift
  logic [2*requesters-1:0] request_twice; 
  
  //Rotated version of the request vector
  logic [requesters-1:0] rotated_request;

 
  int chosen_index; // Index of the requester that got access
  logic selected; // Have we found a requester to give access?

  always_ff @(posedge clk or posedge reset) begin
    
    // If reset is high, reset everything
    if (reset) begin
      chosen <= '0;
      starting_index <= 0;
    end else begin
      
      // Copy request to request_twice
      // Shift vector
      request_twice = {request, request};
      rotated_request = request_twice >> starting_index;

      // -1 is default (no grant yet)
      // 0 means none selected (goes high when one is)
      chosen_index = -1;
      selected = 0;

      // Go through rotated request vector and choose the first one with a 1
      for (int i = 0; i < requesters; i++) begin
        if (!selected && rotated_request[i]) begin
          chosen_index = (starting_index + i) % requesters; // Get OG index
          selected = 1;
        end
      end
	
      // Clear the previous grant that was given
      chosen = '0;
      
      // If someone got picked, then update the starting_index for fairness
      if (chosen_index != -1) begin
        chosen[chosen_index] = 1'b1;
        starting_index <= (chosen_index + 1) % requesters;
      end
    end
  end

endmodule

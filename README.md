# Round-Robin-Arbiter

This is a parametrizable round-robin arbiter implemented in SystemVerilog that grants one of N requesters per cycle. It uses a rotating priority to ensure fairness.

The inputs are clk, reset, and request[requesters-1:0]. The output is chosen[requesters-1:0].

# Features

1. Rotating priority with wrap around using a duplicated request vector and shift

2. One hot grant output

3. Preserves pointer across cycles, ensuring fairness

4. Parametrizable for easy reuse

# How it Works

1. Duplicates request vecotr ({request, request}) allowing for wrap around in one shift

2. Right shift by starting_index for a rotated view

3. Scan from LSB to find the first 1 in the rotated view

4. Map the rotated index back to the original index and then assert the grant bit

5. Advance the starting_index to (winner+1)%requesters

# Testbench

10 ns clock

The testbench sequence of requesters:
- 0101 → grants requester 0 (next pointer = 1)
- 1010 → grants requester 1 (next pointer = 2)
- 1111 → grants requester 2 (next pointer = 3)
- 0000 → no grant (pointer stays 3)
- 0100 → grants requester 2 (pointer stays 3 → wraps on next activity)

# License

MIT License. Feel free to use it (just give credit)

Tool used: EDA Playground, EPWave, Icarus Verilog

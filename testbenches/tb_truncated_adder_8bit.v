`timescale 1ns / 1ps

module tb_truncated_adder_8bit;

    reg  signed [7:0] a;
    reg  signed [7:0] b;
    reg cin;
    wire signed [7:0] sum_trunc;
    // wire signed [8:0] full_sum;

    // DUT instance
    truncated_adder_8bit dut (
        .a(a),
        .b(b),
        .c0(cin),
        .sum_trunc(sum_trunc)
        // .full_sum(full_sum)
    );

    initial begin
        // Monitor prints whenever any displayed signal changes
        $monitor("TIME=%0t  a=%d (%b)  b=%d (%b) cin=%d sum_trunc=%b",
                 $time, a, a, b, b, cin, sum_trunc);

        cin = 1'b0;
        // Directed Tests (with expected full_sum in decimal and sum_trunc in top 8 bits binary)
        a = 8'sh7F; b = 8'sh01; #1;   // 127 + 1 = 128 then trunc 010000000 = 01000000
        a = 8'sh80; b = 8'shFF; #1;   // -128 + -1 = -129 then trunc 101111111 = 10111111
        a = 8'sh7F; b = 8'sh7F; #1;   // 127 + 127 = 254 then trunc 011111110 = 01111111
        a = 8'sh80; b = 8'sh80; #1;   // -128 + -128 = -256 then trunc 100000000 = 10000000
        a = 8'sh00; b = 8'sh00; #1;   // 0 + 0 = 0 then trunc 000000000 = 00000000

        a = 8'sh01; b = 8'shFF; #1;   // 1 + -1 = 0 then trunc 000000000 = 00000000
        a = 8'sh7E; b = 8'sh02; #1;   // 126 + 2 = 128 then trunc 010000000 = 01000000
        a = 8'shFF; b = 8'sh01; #1;   // -1 + 1 = 0 then trunc 000000000 = 00000000
        a = 8'shFF; b = 8'shFF; #1;   // -1 + -1 = -2 then trunc 111111110 = 11111111

        // Boundary conditions
        a = 8'sh00; b = 8'sh01; #1;   // 0 + 1 = 1 then trunc 000000001 = 00000000
        a = 8'shFF; b = 8'sh02; #1;   // -1 + 2 = 1 then trunc 000000001 = 00000000
        a = 8'sh7F; b = 8'sh81; #1;   // 127 + -127 = 0 then trunc 000000000 = 00000000

        cin = 1'b1;
        a = 8'sh7F; b = 8'sh01; #1;   // 127 + 1 + carry = 129 then trunc 010000001 = 01000000
        a = 8'sh80; b = 8'shFF; #1;   // -128 + -1 + carry = -128 then trunc 110000000 = 11000000
    
        a = 8'sh00; b = 8'sh00; #1;   // 0 + 0 + carry = 1 then trunc 000000001 = 00000000
        a = 8'shFF; b = 8'sh01; #1;   // -1 + 1 + carry = 1 then trunc 000000001 = 00000000
    
        a = 8'sh7F; b = 8'sh7F; #1;   // 127 + 127 + carry = 255 then trunc 0111111111 = 01111111
    
        // Boundary conditions with cin = 1
        a = 8'sh00; b = 8'sh01; #1;   // 0 + 1 + carry = 2 then trunc 000000010 = 00000001
        a = 8'shFF; b = 8'sh02; #1;   // -1 + 2 + carry = 2 then trunc 000000010 = 00000001
    
        a = 8'sh7F; b = 8'sh81; #1;   // 127 + -127 + carry = 1 then trunc 000000001 = 00000000
        
        cin = 1'b0;
        // Random tests
        repeat (10) begin
            a = $random;
            b = $random;
            #1;
        end
        $finish;
    end

endmodule

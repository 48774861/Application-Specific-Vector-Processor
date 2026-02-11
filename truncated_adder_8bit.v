module truncated_adder_8bit (
    input  wire signed [7:0] a,
    input  wire signed [7:0] b,
    input  wire c0,
    output reg  signed [7:0] sum_trunc
    // output reg  signed [8:0] full_sum   // full 9-bit sum
);

    reg c1, c2, c3, c4, c5, c6, c7, c8;  // carry bits

    always @(*) begin
        
        // No need to calculate the first digit since we are truncating it anyway.
        c1 = (a[0] & b[0]) | (a[0] & c0) | (b[0] & c0);

        sum_trunc[0] = a[1] ^ b[1] ^ c1;
        c2 = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);

        sum_trunc[1] = a[2] ^ b[2] ^ c2;
        c3 = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);

        sum_trunc[2] = a[3] ^ b[3] ^ c3;
        c4 = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);

        sum_trunc[3] = a[4] ^ b[4] ^ c4;
        c5 = (a[4] & b[4]) | (a[4] & c4) | (b[4] & c4);

        sum_trunc[4] = a[5] ^ b[5] ^ c5;
        c6 = (a[5] & b[5]) | (a[5] & c5) | (b[5] & c5);

        sum_trunc[5] = a[6] ^ b[6] ^ c6;
        c7 = (a[6] & b[6]) | (a[6] & c6) | (b[6] & c6);

        sum_trunc[6] = a[7] ^ b[7] ^ c7;
        c8 = (a[7] & b[7]) | (a[7] & c7) | (b[7] & c7);

        // 9th bit (carry-out) using the sign bits
        sum_trunc[7] = a[7] ^ b[7] ^ c8;
    end

endmodule

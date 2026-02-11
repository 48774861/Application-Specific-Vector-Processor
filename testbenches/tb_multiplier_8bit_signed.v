`timescale 1ns/1ps

module tb_multiplier_8bit_signed;

    reg signed [7:0] a, b;
    // wire signed [15:0] product;
    // wire [7:0] p0,p1,p2,p3,p4,p5,p6,p7;
    // wire [15:0] p0_ext,p1_ext,p2_ext,p3_ext,p4_ext,p5_ext,p6_ext,p7_ext;
    // wire [15:0] extra_add;
    wire [7:0] c;

    // Instantiate the multiplier
    truncated_multiplier_8bit uut (
        .A(a),
        .B(b),
        .c(c)
    );

    initial begin
        // Print header
        // $display("Time\tA\tB\tp0\tp1\tp2\tp3\tp4\tp5\tp6\tp7\tp0_ext\tp1_ext\tp2_ext\tp3_ext\tp4_ext\tp5_ext\tp6_ext\tp7_ext\textra_add\tproduct");
        $monitor(
    "%0dns\nA=%08b\nB=%08b\nprod_o=%b\n\n",
    $time, a, b,c
);


        a = 8'sd0;   b = 8'sd0;    #1; // 0 * 0 = 0
        a = 8'sd1;   b = 8'sd1;    #1; // 1 * 1 = 1
        a = 8'sd127; b = 8'sd127;  #1; // max positive * max positive
        a = -8'sd128; b = -8'sd128;#1; // min negative * min negative
        a = -8'sd128; b = 8'sd127; #1; // min negative * max positive
        a = 8'sd127; b = -8'sd128; #1; // max positive * min negative
        a = -8'sd1;  b = -8'sd1;   #1; // -1 * -1 = 1
        a = -8'sd1;  b = 8'sd1;    #1; // -1 * 1 = -1
        a = 8'sd1;   b = -8'sd1;   #1; // 1 * -1 = -1

        // ------------------------------------------------------------
        // Boundary tests around sign bit
        // ------------------------------------------------------------
        a = 8'sd127; b = 8'sd2;    #1; // 127*2 = 254
        a = -8'sd128; b = 8'sd2;   #1; // -128*2 = -256
        a = 8'sd64;  b = -8'sd64;  #1; // positive * negative
        a = -8'sd64; b = 8'sd64;   #1; // negative * positive
        a = -8'sd64; b = -8'sd64;  #1; // negative * negative


        repeat (10) begin
            a = $random;
            b = $random;
            #1;
        end

        #5 $finish;
    end

endmodule

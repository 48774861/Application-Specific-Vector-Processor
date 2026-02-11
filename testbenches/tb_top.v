`timescale 10ns/1ps

module tb_top;

    reg         clk;
    reg         rst;
    reg signed  [7:0]  din;

    wire signed [7:0]  f1, f2, f3, f4;

    // Instantiate DUT
    top dut (
        clk, rst, din, f1, f2, f3, f4
    );

    // Clock generator: 10 ns period
    always #5 clk = ~clk;

    initial begin
        $monitor("T=%d | rst=%b | din=%0d | f1=%0d f2=%0d f3=%0d f4=%0d",
                 $time, rst, din, f1, f2, f3, f4);

        // Initial values
        clk = 0;
        din = 8'd1;
        rst = 0;
        
        #0.001;
        rst = 1;

        #20; rst = 0; // Hold reset
        
        // Initial group
        din = 8'd0;       // 0
        #10 din = 8'd1;   // +1
        #10 din = 8'd127; // +127
        #10 din = -8'd128; // 8'h80 interpreted as -128
        
        #10 din = 8'd0;       // 0
        #10 din = 8'd1;       // +1
        #10 din = 8'd127;     // +127
        #10 din = -8'd128;    // -128
        
        #10 din = 8'd0;       // 0
        #10 din = 8'd1;       // +1
        #10 din = 8'd0;       // 0 // f1 = 0
        #10 din = 8'd0;       // 0 // f2 = -1
        
        // --- A values for 4 consecutive vectors ---
        #10 din = 8'd127;     // a for vector 5, f3 = -17
        #10 din = -8'd128;    // a for vector 6, f4 = 48
        #10 din = 8'd0;       // a for vector 7
        #10 din = 8'd127;     // a for vector 8
        
        // --- B values for those 4 vectors ---
        #10 din = -8'd128;    // b for vector 5
        #10 din = 8'd127;     // b for vector 6
        #10 din = 8'd127;     // b for vector 7
        #10 din = 8'd0;       // b for vector 8
        
        // --- D values for those 4 vectors ---
        #10 din = 8'd0;       // d for vector 5
        #10 din = 8'd0;       // d for vector 6
        #10 din = 8'd16;      // d for vector 7, f1 = 16
        #10 din = 8'd32;      // d for vector 8, f2 = -48
        
        
        // --- Next group of 4 vectors (9-12) ---
        // A values
        #10 din = 8'd0;       // a for vector 9, f3 = -28
        #10 din = -8'd128;    // a for vector 10, f4 = 8
        #10 din = 8'd127;     // a for vector 11
        #10 din = -8'd1;      // a for vector 12 (8'hFF = -1)
        
        // B values
        #10 din = -8'd128;    // b for vector 9
        #10 din = 8'd0;       // b for vector 10
        #10 din = -8'd1;      // b for vector 11
        #10 din = 8'd127;     // b for vector 12
        
        // D values
        #10 din = -8'd16;     // d for vector 9 (8'hF0 = -16)
        #10 din = -8'd15;     // d for vector 10 (8'hF1 = -15)
        #10 din = -8'd128;    // d for vector 11, f1 = 28
        #10 din = -8'd128;    // d for vector 12, f2 = -4

        // A values
        #10 din = -8'd128;  // a for vector 13 (0x80), f3 = -33
        #10 din = -8'd1;    // a for vector 14 (0xFF), f4 = -65
        #10 din = 8'd64;    // a for vector 15 (0x40)
        #10 din = 8'd96;    // a for vector 16 (0x60)
        
        // B values
        #10 din = -8'd1;    // b for vector 13 (0xFF)
        #10 din = -8'd128;  // b for vector 14 (0x80)
        #10 din = 8'd64;    // b for vector 15 (0x40)
        #10 din = 8'd96;    // b for vector 16 (0x60)
        
        // D values
        #10 din = 8'd127;   // d for vector 13 (0x7F)
        #10 din = 8'd127;   // d for vector 14 (0x7F)
        #10 din = 8'd0;     // d for vector 15 (0x00), f1 = 31
        #10 din = 8'd0;     // d for vector 16 (0x00), f2 = 63

        // A values
        #10 din = 8'd80;    // a for vector 17 (0x50), f3 = -12
        #10 din = -8'd112;  // a for vector 18 (0x90), f4 = -15
        #10 din = 8'd127;   // a for vector 19 (0x7F)
        #10 din = 8'd127;   // a for vector 20 (0x7F)
        
        // B values
        #10 din = -8'd48;   // b for vector 17 (0xD0)
        #10 din = -8'd112;  // b for vector 18 (0x90)
        #10 din = 8'd2;     // b for vector 19 (0x02)
        #10 din = 8'd127;   // b for vector 20 (0x7F)
        
        // D values
        #10 din = 8'd0;     // d for vector 17
        #10 din = 8'd0;     // d for vector 18
        #10 din = 8'd127;   // d for vector 19, f1 = 8
        #10 din = 8'd127;   // d for vector 20, f2 = 40

        // A values
        #10 din = -8'd128;  // a for vector 21 (0x80), f3 = 31
        #10 din = -8'd128;  // a for vector 22 (0x80), f4 = 15
        #10 din = 8'd1;     // a for vector 23 (0x01)
        #10 din = 8'd2;     // a for vector 24 (0x02)
        
        // B values
        #10 din = 8'd2;     // b for vector 21
        #10 din = -8'd128;  // b for vector 22
        #10 din = -8'd16;   // b for vector 23 (0xF0)
        #10 din = -8'd16;   // b for vector 24 (0xF0)
        
        // D values
        #10 din = -8'd128;  // d for vector 21
        #10 din = -8'd128;  // d for vector 22
        #10 din = 8'd16;    // d for vector 23 (0x10), f1 = -33
        #10 din = 8'd0;     // d for vector 24 (0x00), f2 = 16
        
        // A values
        #10 din = 8'd3;      // a for vector 25, f3 = 7
        #10 din = 8'd16;     // a for vector 26, f4 = 3
        #10 din = 8'd1;      // a for vector 27
        #10 din = 8'd85;     // a for vector 28
        
        // B values
        #10 din = -8'd16;    // b for vector 25 (0xF0)
        #10 din = 8'd15;     // b for vector 26 (0x0F)
        #10 din = -8'd128;   // b for vector 27 (0x80), f1 = 3
        #10 din = 8'd85;     // b for vector 28 (0x55), f2 = -36
        
        // D values
        #10 din = -8'd1;     // d for vector 25 (0xFF), f3 = 63
        #10 din = -8'd128;   // d for vector 26 (0x80), f4 = 6
        #10 din = 8'd127;    // d for vector 27 (0x7F)
        #10 din = 8'd85;     // d for vector 28 (0x55)

        // A values
        #10 din = -8'd86;    // a for vector 29 (0xAA)
        #10 din = 8'd85;     // a for vector 30 (0x55)
        #10 din = -8'd86;    // a for vector 31 (0xAA)
        #10 din = 8'd1;      // a for vector 32 (0x01)
        
        // B values
        #10 din = -8'd86;    // b for vector 29 (0xAA)
        #10 din = -8'd86;    // b for vector 30 (0xAA)
        #10 din = 8'd85;     // b for vector 31 (0x55)
        #10 din = -8'd128;   // b for vector 32 (0x80)
        
        // D values
        #10 din = -8'd86;    // d for vector 29 (0xAA)
        #10 din = 8'd85;     // d for vector 30 (0x55)
        #10 din = -8'd86;    // d for vector 31 (0xAA), f1 = 7
        #10 din = 8'd127;    // d for vector 32 (0x7F), f2 = 35

        
        // A values
        #10 din = 8'd127;    // a for vector 33 (0x7F), f3 = -51
        #10 din = -8'd128;   // a for vector 34 (0x80), f4 = 63
        #10 din = -8'd1;     // a for vector 35 (0xFF)
        #10 din = 8'd19;     // a for vector 36 (0x13)
        
        // B values
        #10 din = 8'd1;      // b for vector 33 (0x01)
        #10 din = 8'd1;      // b for vector 34 (0x01)
        #10 din = 8'd1;      // b for vector 35 (0x01)
        #10 din = -8'd25;    // b for vector 36 (0xE7)
        
        // D values
        #10 din = -8'd128;   // d for vector 33 (0x80)
        #10 din = 8'd127;    // d for vector 34 (0x7F)
        #10 din = -8'd1;     // d for vector 35 (0xFF), f1 = -33
        #10 din = -8'd92;    // d for vector 36 (0xA4), f2 = 31

        // A values
        #10 din = 8'd107;    // a for vector 37 (0x6B), f3 = -1
        #10 din = -8'd13;    // a for vector 38 (0xF3), f4 = -18
        #10 din = 8'd32;     // a for vector 39 (0x20)
        #10 din = 8'd16;     // a for vector 40 (0x10)
        
        // B values
        #10 din = -8'd110;   // b for vector 37 (0x92)
        #10 din = 8'd12;     // b for vector 38 (0x0C)
        #10 din = 8'd4;      // b for vector 39 (0x04)
        #10 din = -8'd16;    // b for vector 40 (0xF0)
        
        // D values
        #10 din = 8'd16;     // d for vector 37 (0x10)
        #10 din = 8'd126;    // d for vector 38 (0x7E)
        #10 din = -8'd128;   // d for vector 39 (0x80), f1 = 20
        #10 din = 8'd15;     // d for vector 40 (0x0F), f2 = 28
        
        // f3 = -33
        // f4 = 7
        #30 rst = 1;

        #10;
        $finish;
    end

endmodule

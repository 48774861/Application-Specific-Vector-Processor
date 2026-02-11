`timescale 1ns/1ps

module datapath_tb;

    // DUT inputs
    reg clk;
    reg rst;
    reg en_a1, en_a2, en_a3, en_a4;
    reg en_b1, en_b2, en_b3, en_b4;
    reg en_f1, en_f2, en_f3, en_f4;
    reg en_add1_1, en_add1_2, en_add1_3, en_add1_4;
    reg en_add2_1, en_add2_2, en_add2_3, en_add2_4;
    reg save_c;
    reg signed [7:0] din;

    // DUT outputs
    wire signed [7:0] f1, f2, f3, f4;

    // Instantiate DUT
    datapath uut (
        .clk(clk), .rst(rst),
        .en_a1(en_a1), .en_a2(en_a2), .en_a3(en_a3), .en_a4(en_a4),
        .en_b1(en_b1), .en_b2(en_b2), .en_b3(en_b3), .en_b4(en_b4),
        .en_f1(en_f1), .en_f2(en_f2), .en_f3(en_f3), .en_f4(en_f4),
        .en_add1_1(en_add1_1), .en_add1_2(en_add1_2),
        .en_add1_3(en_add1_3), .en_add1_4(en_add1_4),
        .en_add2_1(en_add2_1), .en_add2_2(en_add2_2),
        .en_add2_3(en_add2_3), .en_add2_4(en_add2_4),
        .save_c(save_c),
        .din(din),
        .f1(f1), .f2(f2), .f3(f3), .f4(f4)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task to clear all enables
    task clear_enables;
    begin
        en_a1=0; en_a2=0; en_a3=0; en_a4=0;
        en_b1=0; en_b2=0; en_b3=0; en_b4=0;
        en_f1=0; en_f2=0; en_f3=0; en_f4=0;
        en_add1_1=0; en_add1_2=0; en_add1_3=0; en_add1_4=0;
        en_add2_1=0; en_add2_2=0; en_add2_3=0; en_add2_4=0;
        save_c=0;
    end
    endtask

    initial begin
        $display("Starting datapath testbench...");
        $monitor("T=%0t | din=%d | f1=%d f2=%d f3=%d f4=%d | a1=%d a2=%d a3=%d a4=%d | b1=%d b2=%d b3=%d b4=%d",
             $time, din, f1, f2, f3, f4,
             uut.a1, uut.a2, uut.a3, uut.a4,
             uut.b1, uut.b2, uut.b3, uut.b4);
        clk = 0;
        rst = 1;
        clear_enables;
        din = 0;

        // Reset pulse
        #10 rst = 0;

        // Test loading a1-a4 with positive values
        din = 8'd10; en_a1=1; #10; en_a1=0;
        din = 8'd20; en_a2=1; #10; en_a2=0;
        din = 8'd30; en_a3=1; #10; en_a3=0;
        din = 8'd40; en_a4=1; #10; en_a4=0;

        // Test loading b1-b4 with negative values
        din = -8'sd5; en_b1=1; #10; en_b1=0;
        din = -8'sd15; en_b2=1; #10; en_b2=0;
        din = -8'sd25; en_b3=1; #10; en_b3=0;
        din = -8'sd35; en_b4=1; #10; en_b4=0;

        // Test multiplier save_c functionality
        din = 8'd3; en_b1=1; #10; en_b1=0;
        save_c=1; en_a1=1; #10; en_a1=0; save_c=0;

        // Test add1 paths
        din = 8'd7; en_add1_1=1; #10; en_add1_1=0;
        din = 8'd8; en_add1_2=1; #10; en_add1_2=0;
        din = 8'd9; en_add1_3=1; #10; en_add1_3=0;
        din = 8'd10; en_add1_4=1; #10; en_add1_4=0;

        // Test add2 paths
        en_add2_1=1; #10; en_add2_1=0;
        en_add2_2=1; #10; en_add2_2=0;
        en_add2_3=1; #10; en_add2_3=0;
        en_add2_4=1; #10; en_add2_4=0;

        // Test outputs f1-f4
        en_f1=1; #10; en_f1=0;
        en_f2=1; #10; en_f2=0;
        en_f3=1; #10; en_f3=0;
        en_f4=1; #10; en_f4=0;

        // Corner case: maximum positive input
        din = 8'sd127; en_a1=1; #10; en_a1=0;
        // Corner case: minimum negative input
        din = -8'sd128; en_a2=1; #10; en_a2=0;

        // Corner case: overlapping enables
        din = 8'd55; en_a3=1; en_b3=1; #10; clear_enables;

        // Corner case: simultaneous add1 and add2
        din = 8'd12; en_add1_4=1; en_add2_4=1; #10; clear_enables;

        // Finish simulation
        #50;
        $display("Testbench completed.");
        $finish;
    end

endmodule

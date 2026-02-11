`timescale 1ns/1ps

module controller_tb;

    // DUT inputs
    reg clk;
    reg rst;

    // DUT outputs
    wire en_a1, en_a2, en_a3, en_a4;
    wire en_b1, en_b2, en_b3, en_b4;
    wire en_f1, en_f2, en_f3, en_f4;
    wire en_add1_1, en_add1_2, en_add1_3, en_add1_4;
    wire en_add2_1, en_add2_2, en_add2_3, en_add2_4;
    wire save_c;

    // Instantiate DUT
    controller uut (
        .clk(clk), .rst(rst),
        .en_a1(en_a1), .en_a2(en_a2), .en_a3(en_a3), .en_a4(en_a4),
        .en_b1(en_b1), .en_b2(en_b2), .en_b3(en_b3), .en_b4(en_b4),
        .en_f1(en_f1), .en_f2(en_f2), .en_f3(en_f3), .en_f4(en_f4),
        .en_add1_1(en_add1_1), .en_add1_2(en_add1_2),
        .en_add1_3(en_add1_3), .en_add1_4(en_add1_4),
        .en_add2_1(en_add2_1), .en_add2_2(en_add2_2),
        .en_add2_3(en_add2_3), .en_add2_4(en_add2_4),
        .save_c(save_c)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Monitor signals
    initial begin
        $monitor("T=%0t | rst=%b | en_a1=%b en_a2=%b en_a3=%b en_a4=%b | en_b1=%b en_b2=%b en_b3=%b en_b4=%b | en_f1=%b en_f2=%b en_f3=%b en_f4=%b | add1_1=%b add1_2=%b add1_3=%b add1_4=%b | add2_1=%b add2_2=%b add2_3=%b add2_4=%b | save_c=%b",
                 $time, rst,
                 en_a1,en_a2,en_a3,en_a4,
                 en_b1,en_b2,en_b3,en_b4,
                 en_f1,en_f2,en_f3,en_f4,
                 en_add1_1,en_add1_2,en_add1_3,en_add1_4,
                 en_add2_1,en_add2_2,en_add2_3,en_add2_4,
                 save_c);
    end

    initial begin
        $display("Starting controller testbench...");
        clk = 0;
        rst = 1;

        // Apply reset
        #12 rst = 0;

        // Let FSM cycle through all states twice
        repeat(24) @(posedge clk);

        // Corner case: assert reset mid-cycle
        #2 rst = 1;
        #10 rst = 0;

        // Let FSM run again
        repeat(12) @(posedge clk);

        // Finish simulation
        #20;
        $display("Controller testbench completed.");
        $finish;
    end

endmodule

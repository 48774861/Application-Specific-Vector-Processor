module top (
    input  wire        clk,
    input  wire        rst,
    input  wire signed [7:0] din,
    output wire signed [7:0] f1, f2, f3, f4
);

    // Control signals
    wire en_a1, en_a2, en_a3, en_a4;
    wire en_b1, en_b2, en_b3, en_b4;
    wire en_f1, en_f2, en_f3, en_f4;
    wire en_add1_1, en_add1_2, en_add1_3, en_add1_4;
    wire en_add2_1, en_add2_2, en_add2_3, en_add2_4;
    wire save_c;

    // Instantiate controller
    controller ctrl_inst (
        .clk(clk),
        .rst(rst),
        .en_a1(en_a1), .en_a2(en_a2), .en_a3(en_a3), .en_a4(en_a4),
        .en_b1(en_b1), .en_b2(en_b2), .en_b3(en_b3), .en_b4(en_b4),
        .en_f1(en_f1), .en_f2(en_f2), .en_f3(en_f3), .en_f4(en_f4),
        .en_add1_1(en_add1_1), .en_add1_2(en_add1_2), .en_add1_3(en_add1_3), .en_add1_4(en_add1_4),
        .en_add2_1(en_add2_1), .en_add2_2(en_add2_2), .en_add2_3(en_add2_3), .en_add2_4(en_add2_4),
        .save_c(save_c)
    );

    // Instantiate datapath
    datapath dp_inst (
        .clk(clk),
        .rst(rst),
        .en_a1(en_a1), .en_a2(en_a2), .en_a3(en_a3), .en_a4(en_a4),
        .en_b1(en_b1), .en_b2(en_b2), .en_b3(en_b3), .en_b4(en_b4),
        .en_f1(en_f1), .en_f2(en_f2), .en_f3(en_f3), .en_f4(en_f4),
        .en_add1_1(en_add1_1), .en_add1_2(en_add1_2), .en_add1_3(en_add1_3), .en_add1_4(en_add1_4),
        .en_add2_1(en_add2_1), .en_add2_2(en_add2_2), .en_add2_3(en_add2_3), .en_add2_4(en_add2_4),
        .save_c(save_c),
        .din(din),
        .f1(f1), .f2(f2), .f3(f3), .f4(f4)
    );

endmodule

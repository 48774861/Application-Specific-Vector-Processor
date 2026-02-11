module datapath (
    input  wire        clk,
    input  wire        rst,
    input  wire        en_a1, en_a2, en_a3, en_a4,
    input  wire        en_b1, en_b2, en_b3, en_b4,
    input  wire        en_f1, en_f2, en_f3, en_f4,
    input  wire        en_add1_1, en_add1_2, en_add1_3, en_add1_4,
    input  wire        en_add2_1, en_add2_2, en_add2_3, en_add2_4,
    input  wire        save_c,
    input  signed [7:0] din,
    output reg signed  [7:0] f1, f2, f3, f4
);
    
    reg cin;
    reg signed [7:0]  a1, a2, a3, a4, b1, b2, b3, b4, a_mult, b_mult, a_add1, b_add1, a_add2, b_add2;
    wire signed [7:0] c_mult, c_add1, c_add2;
    truncated_multiplier_8bit uut (.A(a_mult), .B(b_mult), .c(c_mult));
    truncated_adder_8bit add1 (a_add1, b_add1, 1'b0, c_add1);
    truncated_adder_8bit add2 (a_add2, b_add2, cin, c_add2);

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a1 <= 8'd0; a2 <= 8'd0; a3 <= 8'd0; a4 <= 8'd0;
            b1 <= 8'd0; b2 <= 8'd0; b3 <= 8'd0; b4 <= 8'd0;
            a_mult <= 8'd0; b_mult <= 8'd0;
            a_add1 <= 8'd0; b_add1 <= 8'd0; a_add2 <= 8'd0; b_add2 <= 8'd0;
            cin <= 1'b0;
            f1 <= 8'd0; f2 <= 8'd0; f3 <= 8'd0; f4 <= 8'd0;
        end else begin
            // Check each enable independently
            if (en_a1) begin
                if (save_c) a1 <= c_mult;
                else        a1 <= din;
            end
            
            if (en_a2) begin
                if (save_c) a2 <= c_mult;
                else        a2 <= din;
            end
            
            if (en_a3) begin
                if (save_c) a3 <= c_mult;
                else        a3 <= din;
            end
            
            if (en_a4) begin
                if (save_c) a4 <= c_mult;
                else        a4 <= din;
            end

            if (en_b1) begin
                a_mult <= a1;
                b_mult <= din;
                b1 <= din;
            end
            if (en_b2) begin
                a_mult <= a2;
                b_mult <= din;
                b2     <= din;
            end
            
            if (en_b3) begin
                a_mult <= a3;
                b_mult <= din;
                b3     <= din;
            end
            
            if (en_b4) begin
                a_mult <= a4;
                b_mult <= din;
                b4     <= din;
            end
            
            if (en_add1_1) begin
                a_add1 <= a1; // Put c1 into the addition.
                b_add1 <= din; // Put d1 into the addition.
            end
            if (en_add1_2) begin
                a_add1 <= a2; // c2
                b_add1 <= din; // d2
            end
            if (en_add1_3) begin
                a_add1 <= a3; // c3
                b_add1 <= din; // d3
            end
            if (en_add1_4) begin
                a_add1 <= a4; // c4
                b_add1 <= din; // d4
            end
            
            if (en_add2_1) begin
                a_add2 <= c_add1; // e1
                b_add2 <= {~b1[7], ~b1[7:1]};
                cin <= ~b1[0];
            end
            if (en_add2_2) begin
                a_add2 <= c_add1; // e2
                b_add2 <= {~b2[7], ~b2[7:1]};
                cin <= ~b2[0];
            end
            if (en_add2_3) begin
                a_add2 <= c_add1; // e3
                b_add2 <= {~b3[7], ~b3[7:1]};
                cin <= ~b3[0];
            end
            if (en_add2_4) begin
                a_add2 <= c_add1; // e4
                b_add2 <= {~b4[7], ~b4[7:1]};
                cin <= ~b4[0];
            end
            
            if (en_f1) f1 <= c_add2; // f1
            if (en_f2) f2 <= c_add2; // f2
            if (en_f3) f3 <= c_add2; // f3
            if (en_f4) f4 <= c_add2; // f4

        end
        // $display("\na1=%d, a2=%d, a3=%d, a4=%d, b1=%d, b2=%d, b3=%d, b4=%d, d=%d\n", a1, a2, a3, a4, b1, b2, b3, b4, b_add1);
    end

endmodule

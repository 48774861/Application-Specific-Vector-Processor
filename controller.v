module controller (
    input  wire clk,
    input  wire rst,
    // Control signals
    output reg en_a1, en_a2, en_a3, en_a4,
    output reg en_b1, en_b2, en_b3, en_b4,
    output reg en_f1, en_f2, en_f3, en_f4,
    output reg en_add1_1, en_add1_2, en_add1_3, en_add1_4,
    output reg en_add2_1, en_add2_2, en_add2_3, en_add2_4,
    output reg save_c
);

    parameter S0=4'b0000, S1=4'b0001, S2=4'b0011, S3=4'b0010,
              S4=4'b0110, S5=4'b0111, S6=4'b1111, S7=4'b1110,
              S8=4'b1100, S9=4'b1101, S10=4'b0101, S11=4'b0100;
    reg  [3:0] state;

    // State register with synchronous reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
        end else begin
            case (state)
                S0:  state <= S1;
                S1:  state <= S2;
                S2:  state <= S3;
                S3:  state <= S4;
                S4:  state <= S5;
                S5:  state <= S6;
                S6:  state <= S7;
                S7:  state <= S8;
                S8:  state <= S9;
                S9:  state <= S10;
                S10: state <= S11;
                S11: state <= S0;
                default: state <= S0;
            endcase
        end
    end

    // Combinational control logic
    always @(*) begin
        // Default all signals to 0
        en_a1=0; en_a2=0; en_a3=0; en_a4=0;
        en_b1=0; en_b2=0; en_b3=0; en_b4=0;
        en_f1=0; en_f2=0; en_f3=0; en_f4=0;
        en_add1_1=0; en_add1_2=0; en_add1_3=0; en_add1_4=0;
        en_add2_1=0; en_add2_2=0; en_add2_3=0; en_add2_4=0;
        save_c=0;

        case (state)
            S0:  begin en_a1=1; en_add2_4=1; en_f3=1; end
            S1:  begin en_a2=1; en_f4=1; end
            S2:  begin en_a3=1; end
            S3:  begin en_a4=1; end
            S4:  begin en_b1=1; end
            S5:  begin en_a1=1; save_c=1; en_b2=1; end
            S6:  begin en_a2=1; save_c=1; en_b3=1; end
            S7:  begin en_a3=1; save_c=1; en_b4=1; end
            S8:  begin en_a4=1; save_c=1; en_add1_1=1; end
            S9:  begin en_add1_2=1; en_add2_1=1; end
            S10: begin en_add1_3=1; en_add2_2=1; en_f1=1; end
            S11: begin en_add1_4=1; en_add2_3=1; en_f2=1; end
        endcase
    end

endmodule

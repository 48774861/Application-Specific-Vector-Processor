module half_carry_only(input a, b, output carry);
    assign carry = a & b;
endmodule

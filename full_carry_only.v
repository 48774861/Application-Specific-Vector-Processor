module full_carry_only(input a, b, cin, output carry);
    assign carry = (a & b) | (a & cin) | (b & cin);
endmodule

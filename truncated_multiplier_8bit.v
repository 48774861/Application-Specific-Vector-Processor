module truncated_multiplier_8bit (
    input signed [7:0] A, B,
    output [7:0] c
);

    wire [7:0] p0, p1, p2, p3, p4, p5, p6, p7;
    wire [15:0] p0_ext, p1_ext, p2_ext, p3_ext, p4_ext, p5_ext, p6_ext, p7_ext;
    wire [15:0] extra_add;
    
    // Generate partial products
    assign p0 = A & {8{B[0]}};
    assign p1 = A & {8{B[1]}};
    assign p2 = A & {8{B[2]}};
    assign p3 = A & {8{B[3]}};
    assign p4 = A & {8{B[4]}};
    assign p5 = A & {8{B[5]}};
    assign p6 = A & {8{B[6]}};
    assign p7 = A & {8{B[7]}};

    // Sign-extend and shift partial products
    assign p0_ext = {{8{p0[7]}}, p0};           // shift 0
    assign p1_ext = {{7{p1[7]}}, p1, 1'b0};     // shift 1
    assign p2_ext = {{6{p2[7]}}, p2, 2'b0};     // shift 2
    assign p3_ext = {{5{p3[7]}}, p3, 3'b0};     // shift 3
    assign p4_ext = {{4{p4[7]}}, p4, 4'b0};     // shift 4
    assign p5_ext = {{3{p5[7]}}, p5, 5'b0};     // shift 5
    assign p6_ext = {{2{p6[7]}}, p6, 6'b0};     // shift 6

    // Handle sign row (p7)
    assign p7_ext = B[7] ? {~p7[7], ~p7, 7'b0} : {p7, 7'b0}; // invert + shift
    assign extra_add = B[7] ? 16'b000000010000000 : 16'b0; // +1 if negative

    // Final product
    // assign product = A * B;
    
    wire c1a;
    half_carry_only ha1a(p0_ext[1], p1_ext[1], c1a);
    
    wire s2a, c2a, c2b;
    full_adder fa2a(p0_ext[2], p1_ext[2], c1a, s2a, c2a);
    half_carry_only fa2b(s2a, p2_ext[2], c2b);
    
    wire s3a, s3b, c3a, c3b, c3c;
    full_adder fa3a(p0_ext[3], p1_ext[3], c2a, s3a, c3a);
    full_adder fa3b(s3a, p2_ext[3], c2b, s3b, c3b);
    half_carry_only fa3c(s3b, p3_ext[3], c3c);
    
    wire s4a, s4b, s4c, c4a, c4b, c4c, c4d;
    full_adder fa4a(p0_ext[4], p1_ext[4], c3a, s4a, c4a);
    full_adder fa4b(s4a, p2_ext[4], c3b, s4b, c4b);
    full_adder fa4c(s4b, p3_ext[4], c3c, s4c, c4c);
    half_carry_only fa4d(s4c, p4_ext[4], c4d);

    wire s5a, s5b, s5c, s5d, c5a, c5b, c5c, c5d, c5e;
    full_adder fa5a(p0_ext[5], p1_ext[5], c4a, s5a, c5a);
    full_adder fa5b(s5a, p2_ext[5], c4b, s5b, c5b);
    full_adder fa5c(s5b, p3_ext[5], c4c, s5c, c5c);
    full_adder fa5d(s5c, p4_ext[5], c4d, s5d, c5d);
    half_carry_only fa5e(s5d, p5_ext[5], c5e);

    wire s6a, s6b, s6c, s6d, s6e, c6a, c6b, c6c, c6d, c6e, c6f;
    full_adder fa6a(p0_ext[6], p1_ext[6], c5a, s6a, c6a);
    full_adder fa6b(s6a, p2_ext[6], c5b, s6b, c6b);
    full_adder fa6c(s6b, p3_ext[6], c5c, s6c, c6c);
    full_adder fa6d(s6c, p4_ext[6], c5d, s6d, c6d);
    full_adder fa6e(s6d, p5_ext[6], c5e, s6e, c6e);
    half_carry_only fa6f(s6e, p6_ext[6], c6f);
    
    wire s7a, s7b, s7c, s7d, s7e, s7f, c7a, c7b, c7c, c7d, c7e, c7f, c7g;
    full_adder fa7a(p0_ext[7], p1_ext[7], c6a, s7a, c7a);
    full_adder fa7b(s7a, p2_ext[7], c6b, s7b, c7b);
    full_adder fa7c(s7b, p3_ext[7], c6c, s7c, c7c);
    full_adder fa7d(s7c, p4_ext[7], c6d, s7d, c7d);
    full_adder fa7e(s7d, p5_ext[7], c6e, s7e, c7e);
    full_adder fa7f(s7e, p6_ext[7], c6f, s7f, c7f);
    full_carry_only fa7g(s7f, p7_ext[7], extra_add[7], c7g);


    // First actual output that matters
    wire s8a, s8b, s8c, s8d, s8e, s8f, c8a, c8b, c8c, c8d, c8e, c8f, c8g;
    full_adder fa8a(p0_ext[8], p1_ext[8], c7a, s8a, c8a);
    full_adder fa8b(s8a, p2_ext[8], c7b, s8b, c8b);
    full_adder fa8c(s8b, p3_ext[8], c7c, s8c, c8c);
    full_adder fa8d(s8c, p4_ext[8], c7d, s8d, c8d);
    full_adder fa8e(s8d, p5_ext[8], c7e, s8e, c8e);
    full_adder fa8f(s8e, p6_ext[8], c7f, s8f, c8f);
    full_adder fa8g(s8f, p7_ext[8], c7g, c[0], c8g);
    
    wire s9a, s9b, s9c, s9d, s9e, s9f, c9a, c9b, c9c, c9d, c9e, c9f, c9g;
    full_adder fa9a(p0_ext[9], p1_ext[9], c8a, s9a, c9a);
    full_adder fa9b(s9a, p2_ext[9], c8b, s9b, c9b);
    full_adder fa9c(s9b, p3_ext[9], c8c, s9c, c9c);
    full_adder fa9d(s9c, p4_ext[9], c8d, s9d, c9d);
    full_adder fa9e(s9d, p5_ext[9], c8e, s9e, c9e);
    full_adder fa9f(s9e, p6_ext[9], c8f, s9f, c9f);
    full_adder fa9g(s9f, p7_ext[9], c8g, c[1], c9g);

    wire s10a, s10b, s10c, s10d, s10e, s10f, c10a, c10b, c10c, c10d, c10e, c10f, c10g;
    full_adder fa10a(p0_ext[10], p1_ext[10], c9a, s10a, c10a);
    full_adder fa10b(s10a, p2_ext[10], c9b, s10b, c10b);
    full_adder fa10c(s10b, p3_ext[10], c9c, s10c, c10c);
    full_adder fa10d(s10c, p4_ext[10], c9d, s10d, c10d);
    full_adder fa10e(s10d, p5_ext[10], c9e, s10e, c10e);
    full_adder fa10f(s10e, p6_ext[10], c9f, s10f, c10f);
    full_adder fa10g(s10f, p7_ext[10], c9g, c[2], c10g);

    wire s11a, s11b, s11c, s11d, s11e, s11f, c11a, c11b, c11c, c11d, c11e, c11f, c11g;
    full_adder fa11a(p0_ext[11], p1_ext[11], c10a, s11a, c11a);
    full_adder fa11b(s11a, p2_ext[11], c10b, s11b, c11b);
    full_adder fa11c(s11b, p3_ext[11], c10c, s11c, c11c);
    full_adder fa11d(s11c, p4_ext[11], c10d, s11d, c11d);
    full_adder fa11e(s11d, p5_ext[11], c10e, s11e, c11e);
    full_adder fa11f(s11e, p6_ext[11], c10f, s11f, c11f);
    full_adder fa11g(s11f, p7_ext[11], c10g, c[3], c11g);

    wire s12a, s12b, s12c, s12d, s12e, s12f, c12a, c12b, c12c, c12d, c12e, c12f, c12g;
    full_adder fa12a(p0_ext[12], p1_ext[12], c11a, s12a, c12a);
    full_adder fa12b(s12a, p2_ext[12], c11b, s12b, c12b);
    full_adder fa12c(s12b, p3_ext[12], c11c, s12c, c12c);
    full_adder fa12d(s12c, p4_ext[12], c11d, s12d, c12d);
    full_adder fa12e(s12d, p5_ext[12], c11e, s12e, c12e);
    full_adder fa12f(s12e, p6_ext[12], c11f, s12f, c12f);
    full_adder fa12g(s12f, p7_ext[12], c11g, c[4], c12g);

    wire s13a, s13b, s13c, s13d, s13e, s13f, c13a, c13b, c13c, c13d, c13e, c13f, c13g;
    full_adder fa13a(p0_ext[13], p1_ext[13], c12a, s13a, c13a);
    full_adder fa13b(s13a, p2_ext[13], c12b, s13b, c13b);
    full_adder fa13c(s13b, p3_ext[13], c12c, s13c, c13c);
    full_adder fa13d(s13c, p4_ext[13], c12d, s13d, c13d);
    full_adder fa13e(s13d, p5_ext[13], c12e, s13e, c13e);
    full_adder fa13f(s13e, p6_ext[13], c12f, s13f, c13f);
    full_adder fa13g(s13f, p7_ext[13], c12g, c[5], c13g);
    
    wire s14a, s14b, s14c, s14d, s14e, s14f, c14a, c14b, c14c, c14d, c14e, c14f, c14g;
    full_adder fa14a(p0_ext[14], p1_ext[14], c13a, s14a, c14a);
    full_adder fa14b(s14a, p2_ext[14], c13b, s14b, c14b);
    full_adder fa14c(s14b, p3_ext[14], c13c, s14c, c14c);
    full_adder fa14d(s14c, p4_ext[14], c13d, s14d, c14d);
    full_adder fa14e(s14d, p5_ext[14], c13e, s14e, c14e);
    full_adder fa14f(s14e, p6_ext[14], c13f, s14f, c14f);
    full_adder fa14g(s14f, p7_ext[14], c13g, c[6], c14g);

    wire s15a, s15b, s15c, s15d, s15e, s15f, c15a, c15b, c15c, c15d, c15e, c15f, c15g;
    full_adder fa15a(p0_ext[15], p1_ext[15], c14a, s15a, c15a);
    full_adder fa15b(s15a, p2_ext[15], c14b, s15b, c15b);
    full_adder fa15c(s15b, p3_ext[15], c14c, s15c, c15c);
    full_adder fa15d(s15c, p4_ext[15], c14d, s15d, c15d);
    full_adder fa15e(s15d, p5_ext[15], c14e, s15e, c15e);
    full_adder fa15f(s15e, p6_ext[15], c14f, s15f, c15f);
    full_adder fa15g(s15f, p7_ext[15], c14g, c[7], c15g);


endmodule

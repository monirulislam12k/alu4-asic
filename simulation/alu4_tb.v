
`timescale 1ns/1ps

module alu4_tb;

reg [3:0] A;
reg [3:0] B;
reg [2:0] sel;

wire [3:0] result;
wire zero;

alu4 uut (
    .A(A),
    .B(B),
    .sel(sel),
    .result(result),
    .zero(zero)
);

initial begin
    $dumpfile("alu4.vcd");
    $dumpvars(0, alu4_tb);

    A = 4'b0101;
    B = 4'b0011;

    sel = 3'b000; #10;
    sel = 3'b001; #10;
    sel = 3'b010; #10;
    sel = 3'b011; #10;
    sel = 3'b100; #10;
    sel = 3'b101; #10;
    sel = 3'b110; #10;
    sel = 3'b111; #10;

    A = 4'b0000;
    B = 4'b0000;
    sel = 3'b000; #10;

    $finish;
end

initial begin
    $monitor("Time=%0t A=%b B=%b sel=%b result=%b zero=%b",
             $time, A, B, sel, result, zero);
end

endmodule

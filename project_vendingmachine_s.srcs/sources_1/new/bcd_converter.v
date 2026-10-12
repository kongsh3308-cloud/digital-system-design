module bcd_converter(
    input  [9:0] val,
    output [3:0] hundreds, tens, ones
);
    assign hundreds = (val/100)%10;
    assign tens     = (val/10)%10;
    assign ones     = val%10;
endmodule

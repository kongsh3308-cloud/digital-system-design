module debounce_sync(input wire clk, ext_in, output reg sig);

reg t;

always @(posedge clk)
    begin
        t <= ext_in;
        sig <= t;
    end

endmodule
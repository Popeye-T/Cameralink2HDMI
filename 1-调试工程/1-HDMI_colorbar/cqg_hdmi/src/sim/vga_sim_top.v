`timescale 1ps/1ps
module vga_sim_top ();

reg sys_clk;
reg sys_rst_n;
initial begin
    sys_clk <= 0;
    sys_rst_n <= 0;
    #100
    sys_rst_n <= 1;
end

always #10 sys_clk <= ~sys_clk;

VGA_Ctrl VGA_Ctrl_inst(
    .sys_clk    (sys_clk  ),
    .sys_rst_n  (sys_rst_n)
);

endmodule

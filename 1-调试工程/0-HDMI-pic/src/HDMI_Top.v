module HDMI_Top(
    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,

    output  wire            tmds_clk_p    ,  // TMDS 时钟通道
    output  wire            tmds_clk_n    ,
    output  wire    [2:0]   tmds_data_p   ,  // TMDS 数据通道
    output  wire    [2:0]   tmds_data_n     ,
    output  wire            hdmi_on_h
);
assign hdmi_on_h = 1;

wire [23:0] RGB_DATA;
wire [7:0]  R_DATA;
wire [7:0]  G_DATA;
wire [7:0]  B_DATA;
wire clk_x5;
wire clk_x1;
wire lock;

Gowin_rPLL Gowin_rPLL_inst(
    .clkout (clk_x5), //output clkout
    .lock   (lock), //output lock
    .reset  (~sys_rst_n), //input reset
    .clkin  (sys_clk) //input clkin
);

Gowin_CLKDIV Gowin_CLKDIV_inst(
    .clkout (clk_x1     ), //output clkout
    .hclkin (clk_x5     ), //input hclkin
    .resetn (sys_rst_n  ) //input resetn
);

VGA_Ctrl VGA_Ctrl_inst(
    .sys_clk    (clk_x1     ),
    .sys_rst_n  (lock  ),

    .RGB_DATA   (RGB_DATA   ),
    .R_DATA     (R_DATA     ),
    .G_DATA     (G_DATA     ),
    .B_DATA     (B_DATA     ),
    .VGA_DE     (VGA_DE     ),
    .VGA_HS     (VGA_HS     ),
    .VGA_VS     (VGA_VS     )
);

HDMI_Ctrl HDMI_Ctrl_inst(
    .I_rst_n        (lock), //input I_rst_n
    .I_serial_clk   (clk_x5), //input I_serial_clk
    .I_rgb_clk      (clk_x1), //input I_rgb_clk
    .I_rgb_vs       (VGA_VS), //input I_rgb_vs
    .I_rgb_hs       (VGA_HS), //input I_rgb_hs
    .I_rgb_de       (VGA_DE), //input I_rgb_de
    .I_rgb_r        (R_DATA), //input [7:0] I_rgb_r
    .I_rgb_g        (G_DATA), //input [7:0] I_rgb_g
    .I_rgb_b        (B_DATA), //input [7:0] I_rgb_b
    .O_tmds_clk_p   (tmds_clk_p), //output O_tmds_clk_p
    .O_tmds_clk_n   (tmds_clk_n), //output O_tmds_clk_n
    .O_tmds_data_p  (tmds_data_p), //output [2:0] O_tmds_data_p
    .O_tmds_data_n  (tmds_data_n) //output [2:0] O_tmds_data_n
);


endmodule

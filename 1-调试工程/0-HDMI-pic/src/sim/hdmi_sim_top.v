`timescale 1ps/1ps
module hdmi_sim_top ();

reg sys_clk     ;
reg sys_rst_n   ;

wire       tmds_clk_p ;
wire       tmds_clk_n ;
wire [2:0] tmds_data_p;
wire [2:0] tmds_data_n;

GSR GSR(.GSRI(1'b1));

initial begin
    sys_clk <= 0;
    sys_rst_n <= 0;
    #100
    sys_rst_n <= 1;
end

always #18.5 sys_clk <= ~sys_clk;

HDMI_Top HDMI_Top_inst(
    .sys_clk        (sys_clk     )  ,
    .sys_rst_n      (sys_rst_n   )  ,

    .tmds_clk_p     (tmds_clk_p  )  ,  // TMDS 时钟通道
    .tmds_clk_n     (tmds_clk_n  )  ,
    .tmds_data_p    (tmds_data_p )  ,  // TMDS 数据通道
    .tmds_data_n    (tmds_data_n )
);

endmodule

module VGA_Ctrl(
    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,

    output  wire    [23:0]  RGB_DATA    ,
    output  wire    [7:0]   R_DATA      ,
    output  wire    [7:0]   G_DATA      ,
    output  wire    [7:0]   B_DATA      ,

    output  wire            VGA_DE      ,
    output  wire            VGA_HS      ,
    output  wire            VGA_VS
);

//1920*1080
parameter H_Front_Proch     =   88      ;
parameter H_Sync_Time       =   44      ;
parameter H_Back_Proch      =   148     ;
parameter H_Data_Time       =   1920    ;
parameter H_Total_Time      =   H_Front_Proch + H_Sync_Time + H_Back_Proch + H_Data_Time;

parameter V_Front_Proch     =   4       ;
parameter V_Sync_Time       =   5       ;
parameter V_Back_Proch      =   36      ;
parameter V_Data_Time       =   1080    ;
parameter V_Total_Time      =   V_Front_Proch + V_Sync_Time + V_Back_Proch + V_Data_Time;

//行列计数器
reg [12:0]  H_Counter   =   'd0 ;//行计数器
reg [12:0]  V_Counter   =   'd0 ;//列计数器
//行场同步有效信号
reg HS;
reg VS;
reg Vld;
//图像数据
reg [23:0] rgb_data;

assign RGB_DATA = rgb_data;
assign VGA_DE = Vld;
assign VGA_HS = HS;
assign VGA_VS = VS;
assign R_DATA = RGB_DATA[23:16];
assign G_DATA = RGB_DATA[15:8];
assign B_DATA = RGB_DATA[7:0];

always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n || (H_Counter == H_Total_Time - 1))begin
        H_Counter <= 13'd0;
    end
    else begin
        H_Counter <= H_Counter + 13'd1;
    end
end

always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n || ((H_Counter == H_Total_Time - 1) && (V_Counter == V_Total_Time - 1)))begin
        V_Counter <= 13'd0;
    end
    else if(H_Counter == H_Total_Time - 1)begin
        V_Counter <= V_Counter + 13'd1;
    end
    else begin
        V_Counter <= V_Counter;
    end
end

//行场同步信号生成
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        HS <= 1'b0;
    end
    else if(H_Counter < H_Sync_Time)begin
        HS <= 1'b1;
    end
    else begin
        HS <= 1'b0;
    end
end

always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        VS <= 1'b0;
    end
    else if(V_Counter < V_Sync_Time)begin
        VS <= 1'b1;
    end
    else begin
        VS <= 1'b0;
    end
end

//彩条数据及有效信号
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        rgb_data <= 'd0;
    end
    else if((H_Counter >= H_Sync_Time + H_Back_Proch) & (H_Counter < H_Sync_Time + H_Back_Proch + H_Data_Time))begin
        if((V_Counter >= V_Sync_Time + V_Back_Proch) & (V_Counter < V_Sync_Time + V_Back_Proch + V_Data_Time))begin
            rgb_data <= {8'h10,8'hB6,8'h19};  //绿色的RGB分量分别是8'h10,8'hB6,8'h19
        end
    end
    else begin
        rgb_data <= 'd0;
    end
end

always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        Vld <=1'b0;
    end
    else if((H_Counter >= H_Sync_Time + H_Back_Proch) & (H_Counter < H_Sync_Time + H_Back_Proch + H_Data_Time))begin
        if((V_Counter >= V_Sync_Time + V_Back_Proch) & (V_Counter < V_Sync_Time + V_Back_Proch + V_Data_Time))begin
            Vld <=1'b1;
        end
    end
    else begin
        Vld <=1'b0;
    end
end

endmodule

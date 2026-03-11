//`timescale 1ns / 1ps

//module costas_loop_filter #(
//    parameter signed [31:0] KP = 32'd10, 
//    parameter signed [31:0] KI = 32'd1,   
    
//    // 1 MHz Center Frequency
//    parameter signed [31:0] CENTER_FREQ = 32'd42949673 
//)(
//    input wire aclk,

//    input wire [31:0] s_axis_error_tdata,
//    input wire        s_axis_error_tvalid,

//    output reg [31:0] m_axis_phase_tdata,
//    output reg        m_axis_phase_tvalid
//);

//    reg signed [31:0] integral_reg;
//    wire signed [31:0] error_scaled;
//    wire signed [31:0] prop_term;
//    wire signed [31:0] integ_term;

//    assign error_scaled = $signed(s_axis_error_tdata) >>> 19;//16
//    assign prop_term = error_scaled * KP;
//    assign integ_term = error_scaled * KI;

//    initial begin
//        integral_reg = 32'd0;
//        m_axis_phase_tdata = CENTER_FREQ; 
//        m_axis_phase_tvalid = 1'b0;
//    end

//    always @(posedge aclk) begin
//        if (s_axis_error_tvalid) begin
//            integral_reg <= integral_reg + integ_term;
            
//            m_axis_phase_tdata <= CENTER_FREQ + prop_term + integral_reg + integ_term;
            
//            m_axis_phase_tvalid <= 1'b1;
//        end else begin
//            m_axis_phase_tvalid <= 1'b0;
//        end
//    end

//endmodule
/////////////////////////////////////////////////////////////////////////////////////////
//`timescale 1ns / 1ps

//module costas_loop_filter #(
//    // ???????? ???? ??????? (?????? ??????? ??????? ???? ??? ??????????)
//    parameter signed [31:0] KP = 32'd10, 
//    parameter signed [31:0] KI = 32'd1,   
    
//    // 1 MHz Center Frequency
//    parameter signed [31:0] CENTER_FREQ = 32'd42949673 
//)(
//    input wire aclk,

//    input wire [31:0] s_axis_error_tdata,
//    input wire        s_axis_error_tvalid,

//    output reg [31:0] m_axis_phase_tdata,
//    output reg        m_axis_phase_tvalid
//);

//    reg signed [31:0] integral_reg;
//    wire signed [31:0] error_scaled;
//    wire signed [31:0] prop_term;
//    wire signed [31:0] integ_term;

//    // ??????? ????????????? ??????: 32-bit ??? ????????? ?????????????? (Scale Down)
//    // Arithmetic Shift Right (>>> 16) ??????????? ??????? 65536 ?????? ?????????????? ?????????.
//    // ??? ??? ?????????? ??????? ??????? ???????? ????????? ??????????.
//    assign error_scaled = $signed(s_axis_error_tdata) >>> 21;
    
//    // ????? ????? ??? ?????? ????? ????????????
//    assign prop_term = error_scaled * KP;
//    assign integ_term = error_scaled * KI;

//    initial begin
//        integral_reg = 32'd0;
//        m_axis_phase_tdata = CENTER_FREQ; 
//        m_axis_phase_tvalid = 1'b0;
//    end

//    always @(posedge aclk) begin
//        if (s_axis_error_tvalid) begin
//            integral_reg <= integral_reg + integ_term;
            
//            // ????????????: ???????? ??????????? ????????? ???? CENTER_FREQ ? ??????? 
//            // ??? ????????????? ???? (-). ?????? ??????? ????????????? (+) ???????.
//            m_axis_phase_tdata <= CENTER_FREQ + prop_term + integral_reg + integ_term;
            
//            m_axis_phase_tvalid <= 1'b1;
//        end else begin
//            m_axis_phase_tvalid <= 1'b0;
//        end
//    end

//endmodule// this code upload the not possible to bigger change becaouse of the lower gain 21 
//////////////////////////////////////////////////////////////////////////////////////////////////////
//`timescale 1ns / 1ps

//module costas_loop_filter #(
//    parameter signed [31:0] KP = 32'd10, 
//    parameter signed [31:0] KI = 32'd1,   
//    parameter signed [31:0] CENTER_FREQ = 32'd42949673 
//)`timescale 1ns / 1ps

`timescale 1ns / 1ps

module costas_loop_filter (
    input  wire               aclk,

    input  wire               s_axis_error_tvalid,
    input  wire signed [31:0] s_axis_error_tdata,

    output reg                m_axis_phase_tvalid,
    output reg  signed [31:0] m_axis_phase_tdata
);

//    // ?????? ?????????? 1 MHz
//    // 100 MHz ????????? 1 MHz ?????????? ?????????????? ??????
    parameter signed [31:0] CENTER_FREQ = 32'd42949673; 
    
//    // ????? ????? ???????? (Calculated for 5 kHz loop bandwidth)
//    parameter signed [31:0] KP = 32'd91400;
//    parameter signed [31:0] KI_SCALED = 32'd1330380;
    
//    // ????????? ?????? ??????????
//    parameter integer SHIFT_BITS = 16;
//    parameter integer ERROR_SHIFT = 20; // 3.5 ?????? ?????? ??????? ??? ???????
    parameter signed [31:0] KP = 32'd376;
    parameter signed [31:0] KI_SCALED = 32'd5478;
    parameter integer SHIFT_BITS = 16;
    parameter integer ERROR_SHIFT = 18;
    
    reg signed [63:0] proportional_term;
    reg signed [63:0] integral_acc;
    reg signed [31:0] small_error;

    initial begin
        proportional_term   = 0;
        integral_acc        = 0;
        m_axis_phase_tvalid = 0;
        m_axis_phase_tdata  = CENTER_FREQ;
    end

    always @(posedge aclk) begin
        if (s_axis_error_tvalid) begin
            // ???? ?????? ??????????????
            small_error = s_axis_error_tdata >>> ERROR_SHIFT;

            // Proportional & Integral
            proportional_term <= small_error * KP;
            integral_acc <= integral_acc + ((small_error * KI_SCALED) >>> SHIFT_BITS);

            // ???? ???????????
            m_axis_phase_tdata <= CENTER_FREQ + proportional_term[31:0] + integral_acc[31:0];
            m_axis_phase_tvalid <= 1'b1;
        end else begin
            m_axis_phase_tvalid <= 1'b0;
        end
    end
endmodule

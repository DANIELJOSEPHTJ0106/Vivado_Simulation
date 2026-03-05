`timescale 1ns / 1ps

module lfm_controller (
    input  wire        clk,           // 100MHz Clock
    input  wire        reset_n,
    input  wire        enable,
    
    output wire [31:0] m_axis_phase_tdata,
    output wire        m_axis_phase_tvalid
);

    // Continuous ഫ്രീക്വൻസി മാറ്റത്തിനുള്ള പാരാമീറ്ററുകൾ
    parameter START_PHASE_INC = 32'h01000000; 
    parameter STEP_PHASE_INC  = 32'h00020000; // വേഗത്തിൽ ഫ്രീക്വൻസി മാറാൻ വലിയ സ്റ്റെപ്പ് നൽകിയിരിക്കുന്നു
    parameter MAX_PHASE_INC   = 32'h20000000; 

    reg [31:0] current_phase_inc;
    reg        valid_reg;

    always @(posedge clk) begin
        if (!reset_n) begin
            current_phase_inc <= START_PHASE_INC;
            valid_reg <= 1'b0;
        end else if (enable) begin
            valid_reg <= 1'b1;
            
            // Continuous Sweeping Logic (ഇടവേളകളില്ലാതെ)
            if (current_phase_inc < MAX_PHASE_INC) begin
                current_phase_inc <= current_phase_inc + STEP_PHASE_INC;
            end else begin
                // പരമാവധി ഫ്രീക്വൻസിയിൽ എത്തിയാൽ ഉടൻ തന്നെ ആദ്യം മുതൽ തുടങ്ങുന്നു
                current_phase_inc <= START_PHASE_INC; 
            end
            
        end else begin
            valid_reg <= 1'b0;
        end
    end

    assign m_axis_phase_tdata  = current_phase_inc;
    assign m_axis_phase_tvalid = valid_reg;

endmodule

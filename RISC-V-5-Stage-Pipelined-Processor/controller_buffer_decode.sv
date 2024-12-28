module controller_buffer_decode (
    input logic clk,
    input logic rst,
    input logic [3:0] aluop,
    input logic rf_en,
    input logic imm_en,
    input logic jump_en,
    input logic mem_read,
    input logic mem_write,
    input logic [1:0] wb_sel,
    input logic sel_A,
    output logic [3:0] aluopE,
    output logic rf_enE,
    output logic imm_enE,
    output logic jump_enE,
    output logic mem_readE,
    output logic mem_writeE,
    output logic [1:0] wb_selE,
    output logic sel_AE
    
    );

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      aluopE       <= 4'b0;
      rf_enE       <= 1'b0;
      imm_enE      <= 1'b0;
      jump_enE     <= 1'b0;
      mem_readE    <= 1'b0;
      mem_writeE   <= 1'b0;
      wb_selE      <= 2'b0;
      sel_AE       <= 1'b0;
    end else begin
      aluopE       <= aluop;
      rf_enE       <= rf_en;
      imm_enE      <= imm_en;
      jump_enE     <= jump_en;
      mem_readE    <= mem_read;
      mem_writeE   <= mem_write;
      wb_selE      <= wb_sel;
      sel_AE       <= sel_A;
    end
  end
endmodule

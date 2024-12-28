module controller_buffer_execute (
    input logic clk,
    input logic rst,
    input logic rf_enE,
    input logic mem_readE,
    input logic mem_writeE,
    input logic [1:0] wb_selE,
    output logic rf_enM,
    output logic mem_readM,
    output logic mem_writeM,
    output logic [1:0] wb_selM
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      rf_enM     <= 1'b0;
      mem_readM  <= 1'b0;
      mem_writeM <= 1'b0;
      wb_selM    <= 2'b0;
    end else begin
      rf_enM     <= rf_enE;
      mem_readM  <= mem_readE;
      mem_writeM <= mem_writeE;
      wb_selM    <= wb_selE;
    end
  end
endmodule

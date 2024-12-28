module controller_buffer_mem (
    input logic clk,
    input logic rst,
    input logic rf_enM,
    input logic [1:0] wb_selM,
    output logic rf_enW,
    output logic [1:0] wb_selW
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      rf_enW  <= 1'b0;
      wb_selW <= 2'b0;
    end else begin
      rf_enW  <= rf_enM;
      wb_selW <= wb_selM;
    end
  end
endmodule

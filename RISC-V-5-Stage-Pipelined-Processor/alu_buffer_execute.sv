module alu_buffer_execute (
    input logic clk,
    input logic rst,
    input logic [31:0] opr_res,
    output logic [31:0] alu_buffer_execute_out
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      alu_buffer_execute_out <= 32'b0;
    end else begin
      alu_buffer_execute_out <= opr_res;
    end
  end
endmodule
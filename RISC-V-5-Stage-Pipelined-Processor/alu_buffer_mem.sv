module alu_buffer_mem (
    input logic clk,
    input logic rst,
    input logic [31:0] alu_buffer_execute_out,
    output logic [31:0] alu_buffer_mem_out
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      alu_buffer_mem_out <= 32'b0;
    end else begin
      alu_buffer_mem_out <= alu_buffer_execute_out;
    end
  end
endmodule